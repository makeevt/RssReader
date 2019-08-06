
import Foundation
import UIKit

protocol AddNewRssSourceRouter {
    func dismissAddNewRssSource()
}

class AddNewRssSourceRouterImpl: AddNewRssSourceRouter {
    
    //MARK: - Private properties
    
    private weak var viewController: UIViewController?
    private let serviceLocator: ServiceLocator
    
    
    //MARK: - Lifecycle
    
    init(viewController: UIViewController?, serviceLocator: ServiceLocator) {
        self.viewController = viewController
        self.serviceLocator = serviceLocator
    }
    
    func dismissAddNewRssSource() {
        self.viewController?.dismiss(animated: true, completion: nil)
    }
    
}
