
import Foundation
import UIKit

protocol RssFeedConfigurator {
    func configure(viewController: RssFeedViewController)
}

class RssFeedConfiguratorImpl: RssFeedConfigurator {
    private weak var navigationController: UINavigationController?
    private var serviceLocator: ServiceLocator!
    
    init(navigationController: UINavigationController?, serviceLocator: ServiceLocator) {
        self.navigationController = navigationController
        self.serviceLocator = serviceLocator
    }
    
    func configure(viewController: RssFeedViewController) {
        let router = RssFeedRouterImpl(navigationViewController: navigationController, serviceLocator: serviceLocator)
        let interactor = RssFeedInteractorImpl(serviceLocator: serviceLocator)
        let presenter = RssFeedPresenterImpl(view: viewController, router: router, interactor: interactor)
        viewController.presenter = presenter
        interactor.output = presenter
    }
}
