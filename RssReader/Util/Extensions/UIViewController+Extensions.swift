
import Foundation
import UIKit

extension UIViewController {
    
    private struct Constants {
        static let ok = "alert.ok".localized
    }
    
    func showAlert(title: String?, message: String?, presentationCompletion: (() -> Void)? = nil, action: (() -> Void)? = nil) {
        showAlert(title: title, message: message, buttonTitle: Constants.ok, presentationCompletion: presentationCompletion, action: action)
    }
    
    func showAlert(title: String?, message: String?, buttonTitle: String, presentationCompletion: (() -> Void)? = nil, action: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { (_) in action?() }))
        present(alert, animated: true, completion: presentationCompletion)
    }
}
