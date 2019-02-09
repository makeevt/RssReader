
import Foundation
import UIKit

protocol ConfigureAppRouter {
    func showRssFeed(locator: ServiceLocator)
}

class ConfigureAppRouterImpl: ConfigureAppRouter {
    
    func showRssFeed(locator: ServiceLocator) {
        let vc = RssFeedViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        
        vc.configurator = RssFeedConfiguratorImpl(navigationController: navigationController, serviceLocator: locator)
        ViewDispatcher.shared.showRoot(viewController: navigationController, animated: true)
    }

}
