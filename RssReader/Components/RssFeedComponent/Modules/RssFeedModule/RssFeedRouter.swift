
import Foundation
import UIKit

protocol RssFeedRouter {
    func showNewsDetailsPage(item: RssItem)
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
    
    func showNewsDetailsPage(item: RssItem) {
        let controller = NewsDetailsPageViewController()
        controller.configurator = NewsDetailsPageConfiguratorImpl(navigationController: navigationController, serviceLocator: serviceLocator, newsItem: item)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
