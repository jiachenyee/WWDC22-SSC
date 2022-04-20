/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ARViewController: UIViewController {
    
    // MARK: IBOutlets
    
    var sceneView: VirtualObjectARView!
    
    var flagImage: UIImage!
    
    // MARK: - UI Elements
    
    let coachingOverlay = ARCoachingOverlayView()
    
    var focusSquare: FocusSquare? = FocusSquare()
    
    var toastView: UIVisualEffectView!
    
    // MARK: - ARKit Configuration Properties
    
    /// A type which manages gesture manipulation of virtual content in the scene.
    lazy var virtualObjectInteraction = VirtualObjectInteraction(sceneView: sceneView, viewController: self)
    
    /// Coordinates the loading and unloading of reference nodes for virtual objects.
    let virtualObjectLoader = VirtualObjectLoader()
    
    /// Marks if the AR experience is available for restart.
    var isRestartAvailable = true
    
    /// A serial queue used to coordinate adding or removing nodes from the scene.
    let updateQueue = DispatchQueue(label: "sg.tk.flagraising.serialSceneKitQueue")
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - View Controller Life Cycle
    override func loadView() {
        super.loadView()
        
        guard let view = view else { return }
        
        sceneView = VirtualObjectARView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sceneView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: sceneView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: sceneView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: sceneView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: sceneView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        setUpToastView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Set up coaching overlay.
        setupCoachingOverlay()

        // Set up scene content.
        sceneView.scene.rootNode.addChildNode(focusSquare!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addFlagToScene))
        // Set the delegate to ensure this gesture is only used when there are no virtual objects in the scene.
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start the `ARSession`.
        resetTracking()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        session.pause()
    }

    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        virtualObjectInteraction.selectedObject = nil
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        if #available(iOS 12.0, *) {
            configuration.environmentTexturing = .automatic
        }
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

//        statusViewController.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .planeEstimation)
    }

    // MARK: - Focus Square

    func updateFocusSquare(isObjectVisible: Bool) {
        if isObjectVisible || coachingOverlay.isActive {
            focusSquare?.hide()
        } else {
            focusSquare?.unhide()
        }
        
        // Perform ray casting only when ARKit tracking is in a good state.
        if let camera = session.currentFrame?.camera, case .normal = camera.trackingState,
            let query = sceneView.getRaycastQuery(),
            let result = sceneView.castRay(for: query).first {
            
            updateQueue.async {
                if let focusSquare = self.focusSquare {
                    self.sceneView.scene.rootNode.addChildNode(focusSquare)
                }
                self.focusSquare?.state = .detecting(raycastResult: result, camera: camera)
            }
        } else {
            updateQueue.async {
                self.focusSquare?.state = .initializing
                if let focusSquare = self.focusSquare {
                    self.sceneView.pointOfView?.addChildNode(focusSquare)
                }
            }
        }
    }
}
