
import Foundation
import UIKit

protocol RssFeedRouter {
}

class RssFeedRouterImpl: RssFeedRouter {
    
    //MARK: - Private properties
    
    private weak var navigationController: UINavigationController?
    private let serviceLocator: ServiceLocator
    
    
    //MARK: - Lifecycle
    
    init(navigationViewController: UINavigationController?, serviceLocator: ServiceLocator) {
        self.navigationController = navigationViewController
        self.serviceLocator = serviceLocator
    }
    
}
