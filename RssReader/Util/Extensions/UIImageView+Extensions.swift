

import Foundation
import UIKit
import SDWebImage

private var AssociatedObjectHandle: UInt8 = 0

protocol ImageTarget: class {
    func startImageLoading(urlPath: String)
    func stopImageLoading()
}

extension UIImageView: ImageTarget {
    
    private var activityIndicator: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func startImageLoading(urlPath: String) {
        self.backgroundColor = UIColor.ultraLightGray
        self.showActivityIndicator()
        self.sd_setImage(with: URL(string: urlPath), placeholderImage: nil, completed: { (image, _, _, _) in
            self.endImageLoading(image: image)
        })
    }
    
    func stopImageLoading() {
        self.sd_cancelCurrentImageLoad()
        self.endImageLoading(image: nil)
    }
    
    private func endImageLoading(image: UIImage?) {
        Thread.do_onMainThread {
            self.backgroundColor = self.image != nil ? UIColor.clear : UIColor.ultraLightGray
            self.image = image
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
        }
    }
    
    private func showActivityIndicator() {
        guard self.activityIndicator == nil else {
            return
        }
        self.activityIndicator = UIActivityIndicatorView()
        guard let activity = self.activityIndicator else { return }
        activity.style = UIActivityIndicatorView.Style.gray
        self.addSubview(activity)
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        activity.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        activity.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.layoutIfNeeded()
    }
}
