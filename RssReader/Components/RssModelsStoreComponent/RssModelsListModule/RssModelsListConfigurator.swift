import Foundation
import UIKit

protocol RssModelsListConfigurator {
    func configure(viewController: RssModelsListViewController)
}

class RssModelsListConfiguratorImpl: RssModelsListConfigurator {
    private weak var navigationController: UINavigationController?
    private var serviceLocator: ServiceLocator!
    
    init(navigationController: UINavigationController?, serviceLocator: ServiceLocator) {
        self.navigationController = navigationController
        self.serviceLocator = serviceLocator
    }
    
    func configure(viewController: RssModelsListViewController) {
        let router = RssModelsListRouterImpl(navigationViewController: navigationController, serviceLocator: serviceLocator)
        let interactor = RssModelsListInteractorImpl(serviceLocator: serviceLocator)
        let presenter = RssModelsListPresenterImpl(view: viewController, router: router, interactor: interactor)
        viewController.presenter = presenter
    }
}
