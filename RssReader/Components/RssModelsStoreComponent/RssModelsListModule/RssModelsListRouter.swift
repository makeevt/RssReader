
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
//        let controller = NewsDetailsPageViewController()
//        controller.configurator = NewsDetailsPageConfiguratorImpl(navigationController: navigationController, serviceLocator: serviceLocator, newsItem: item)
//        navigationController?.pushViewController(controller, animated: true)
    }
    
}
