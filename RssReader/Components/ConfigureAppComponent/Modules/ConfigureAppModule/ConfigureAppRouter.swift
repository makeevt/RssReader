
import Foundation
import UIKit

protocol ConfigureAppRouter {
    func showRssFeed(locator: ServiceLocator)
}

class ConfigureAppRouterImpl: ConfigureAppRouter {
    
    func showRssFeed(locator: ServiceLocator) {
        let vc = RssModelsListViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        
        vc.configurator = RssModelsListConfiguratorImpl(navigationController: navigationController, serviceLocator: locator)
        ViewDispatcher.shared.showRoot(viewController: navigationController, animated: true)
    }

}
