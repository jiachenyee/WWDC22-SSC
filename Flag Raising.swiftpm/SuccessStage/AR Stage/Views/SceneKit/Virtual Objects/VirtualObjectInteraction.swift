import UIKit
import ARKit

class VirtualObjectInteraction: NSObject, UIGestureRecognizerDelegate {
    
    let translateAssumingInfinitePlane = true
    
    let sceneView: VirtualObjectARView
    
    let viewController: ARViewController
    
    var selectedObject: VirtualObject?
    
    var trackedObject: VirtualObject? {
        didSet {
            guard trackedObject != nil else { return }
            selectedObject = trackedObject
        }
    }
    
    private var currentTrackingPosition: CGPoint?
    
    init(sceneView: VirtualObjectARView, viewController: ARViewController) {
        self.sceneView = sceneView
        self.viewController = viewController
        super.init()
        
        createPanGestureRecognizer(sceneView)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(_:)))
        rotationGesture.delegate = self
        sceneView.addGestureRecognizer(rotationGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    func createPanGestureRecognizer(_ sceneView: VirtualObjectARView) {
        let panGesture = ThresholdPanGesture(target: self, action: #selector(didPan(_:)))
        panGesture.delegate = self
        sceneView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Gesture Actions
    
    @objc func didPan(_ gesture: ThresholdPanGesture) {
        switch gesture.state {
        case .began:
            // Check for an object at the touch location.
            if let object = objectInteracting(with: gesture, in: sceneView) {
                trackedObject = object
            }
            
        case .changed where gesture.isThresholdExceeded:
            guard let object = trackedObject else { return }
            // Move an object if the displacment threshold has been met.
            translate(object, basedOn: updatedTrackingPosition(for: object, from: gesture))

            gesture.setTranslation(.zero, in: sceneView)
            
        case .changed:
            // Ignore the pan gesture until the displacment threshold is exceeded.
            break
            
        case .ended:
            // Update the object's position when the user stops panning.
            guard let object = trackedObject else { break }
            setDown(object, basedOn: updatedTrackingPosition(for: object, from: gesture))
            
            fallthrough
            
        default:
            // Reset the current position tracking.
            currentTrackingPosition = nil
            trackedObject = nil
        }
    }
    
    func updatedTrackingPosition(for object: VirtualObject, from gesture: UIPanGestureRecognizer) -> CGPoint {
        let translation = gesture.translation(in: sceneView)
        
        let currentPosition = currentTrackingPosition ?? CGPoint(sceneView.projectPoint(object.position))
        let updatedPosition = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)
        currentTrackingPosition = updatedPosition
        return updatedPosition
    }

    /**
     For looking down on the object (99% of all use cases), you subtract the angle.
     To make rotation also work correctly when looking from below the object one would have to
     flip the sign of the angle depending on whether the object is above or below the camera.
     - Tag: didRotate */
    @objc
    func didRotate(_ gesture: UIRotationGestureRecognizer) {
        guard gesture.state == .changed else { return }
        
        trackedObject?.objectRotation -= Float(gesture.rotation)
        
        gesture.rotation = 0
    }
    
    /// Handles the interaction when the user taps the screen.
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation = gesture.location(in: sceneView)
        
        if let tappedObject = sceneView.virtualObject(at: touchLocation) {
            
            // If an object exists at the tap location, select it.
            selectedObject = tappedObject
        } else if let object = selectedObject {
            
            // Otherwise, move the selected object to its new position at the tap location.
            setDown(object, basedOn: touchLocation)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow objects to be translated and rotated at the same time.
        return true
    }

    private func objectInteracting(with gesture: UIGestureRecognizer, in view: ARSCNView) -> VirtualObject? {
        for index in 0..<gesture.numberOfTouches {
            let touchLocation = gesture.location(ofTouch: index, in: view)
            
            // Look for an object directly under the `touchLocation`.
            if let object = sceneView.virtualObject(at: touchLocation) {
                return object
            }
        }
        
        // As a last resort look for an object under the center of the touches.
        if let center = gesture.center(in: view) {
            return sceneView.virtualObject(at: center)
        }
        
        return nil
    }
    
    // MARK: - Update object position
    /// - Tag: DragVirtualObject
    func translate(_ object: VirtualObject, basedOn screenPos: CGPoint) {
        object.stopTrackedRaycast()
        
        // Update the object by using a one-time position request.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: object.allowedAlignment) {
            viewController.createRaycastAndUpdate3DPosition(of: object, from: query)
        }
    }
    
    func setDown(_ object: VirtualObject, basedOn screenPos: CGPoint) {
        object.stopTrackedRaycast()
        
        // Prepare to update the object's anchor to the current location.
        object.shouldUpdateAnchor = true
        
        // Attempt to create a new tracked raycast from the current location.
        if let query = sceneView.raycastQuery(from: screenPos, allowing: .estimatedPlane, alignment: object.allowedAlignment),
            let raycast = viewController.createTrackedRaycastAndSet3DPosition(of: object, from: query) {
            object.raycast = raycast
        } else {
            // If the tracked raycast did not succeed, simply update the anchor to the object's current position.
            object.shouldUpdateAnchor = false
            viewController.updateQueue.async {
                self.sceneView.addOrUpdateAnchor(for: object)
            }
        }
    }
}
