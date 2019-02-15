

import Foundation
import UIKit
import SDWebImage

class LoadableImageView: UIImageView, ImageTarget {
    
    // MARK: - Private Properties
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = UIActivityIndicatorView.Style.white
        activity.isHidden = true
        self.addSubview(activity)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        activity.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        activity.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return activity
    }()
    
    private var placeholderImage: UIImageView!
    
    // MARK: - Override properties
    
    override var image: UIImage? {
        didSet {
            self.placeholderImage.isHidden = self.image != nil || !self.activityIndicator.isHidden
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        self.commonInit()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.ultraLightGray
        
        self.placeholderImage = UIImageView(image: UIImage(named: "placeholder.icon"))
        self.placeholderImage.contentMode = .scaleAspectFit
        self.placeholderImage.isHidden = false
        self.addSubview(self.placeholderImage)
        
        self.placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        self.placeholderImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        self.placeholderImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        self.placeholderImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.placeholderImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    // MARK: - ImageTarget
    
    func startImageLoading(urlPath: String) {
        self.showActivityIndicator()
        self.sd_setImage(with: URL(string: urlPath), placeholderImage: nil, completed: { [weak self] (image, _, _, _) in
            guard let self = self else { return }
            self.endImageLoading(image: image)
        })
    }
    
    func stopImageLoading() {
        self.sd_cancelCurrentImageLoad()
        self.endImageLoading(image: self.image)
    }
    
    // MARK: - Private methods
    
    private func endImageLoading(image: UIImage?) {
        self.image = image
        self.hideActivityIndicator()
    }
    
    private func hideActivityIndicator() {
        self.placeholderImage.isHidden = self.image != nil
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    private func showActivityIndicator() {
        self.placeholderImage.isHidden = true
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
}
