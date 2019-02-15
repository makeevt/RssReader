
import Foundation
import UIKit

protocol NewsDetailsPageConfigurator {
    func configure(viewController: NewsDetailsPageViewController)
}

class NewsDetailsPageConfiguratorImpl: NewsDetailsPageConfigurator {
    private weak var navigationController: UINavigationController?
    private var serviceLocator: ServiceLocator!
    
    init(navigationController: UINavigationController?, serviceLocator: ServiceLocator) {
        self.navigationController = navigationController
        self.serviceLocator = serviceLocator
    }
    
    func configure(viewController: NewsDetailsPageViewController) {
        let router = NewsDetailsPageRouterImpl(navigationViewController: navigationController, serviceLocator: serviceLocator)
        let interactor = NewsDetailsPageInteractorImpl(serviceLocator: serviceLocator)
        let presenter = NewsDetailsPagePresenterImpl(view: viewController, router: router, interactor: interactor)
        viewController.presenter = presenter
    }
}
