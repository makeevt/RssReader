
import Foundation
import UIKit

protocol RssModelsListRouter {
    func showAddNewSource()
}

class RssModelsListRouterImpl: RssModelsListRouter {
    
    //MARK: - Private properties
    
    private weak var navigationController: UINavigationController?
    private let serviceLocator: ServiceLocator
    
    
    //MARK: - Lifecycle
    
    init(navigationViewController: UINavigationController?, serviceLocator: ServiceLocator) {
        self.navigationController = navigationViewController
        self.serviceLocator = serviceLocator
    }
    
    func showAddNewSource() {
        let controller = AddNewRssSourceViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.configurator = AddNewRssSourceConfiguratorImpl(navigationController: navigationController, serviceLocator: serviceLocator)
        navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
}
