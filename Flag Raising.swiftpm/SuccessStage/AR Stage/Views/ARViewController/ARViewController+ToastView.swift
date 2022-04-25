import Foundation
import SwiftUI

extension ARViewController {
    func setUpToastView() {
        toastView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Tap anywhere to place the flag"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        toastView.contentView.addSubview(label)
        toastView.layer.cornerRadius = 8
        toastView.clipsToBounds = true
        
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: toastView!, attribute: .centerX, relatedBy: .equal, toItem: label, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toastView!, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toastView!, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: toastView!, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: -16),
            NSLayoutConstraint(item: view!, attribute: .topMargin, relatedBy: .equal, toItem: toastView, attribute: .top, multiplier: 1, constant: -8),
            NSLayoutConstraint(item: view!, attribute: .centerX, relatedBy: .equal, toItem: toastView, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        
        toastView.transform = .init(translationX: 0, y: -100)
        
        UIView.animate(withDuration: 0.5) {
            self.toastView.transform = .identity
        }
    }
    
    func hideToast() {
        UIView.animate(withDuration: 0.5) {
            self.toastView.transform = .init(translationX: 0, y: -100)
        }
    }
}
