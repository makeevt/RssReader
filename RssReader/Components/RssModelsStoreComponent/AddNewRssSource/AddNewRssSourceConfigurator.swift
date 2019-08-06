import Foundation
import UIKit

protocol AddNewRssSourceConfigurator {
    func configure(viewController: AddNewRssSourceViewController)
}

class AddNewRssSourceConfiguratorImpl: AddNewRssSourceConfigurator {
    private weak var navigationController: UINavigationController?
    private var serviceLocator: ServiceLocator!
    
    init(navigationController: UINavigationController?, serviceLocator: ServiceLocator) {
        self.navigationController = navigationController
        self.serviceLocator = serviceLocator
    }
    
    func configure(viewController: AddNewRssSourceViewController) {
        let router = AddNewRssSourceRouterImpl(viewController: viewController, serviceLocator: serviceLocator)
        let interactor = AddNewRssSourceInteractorImpl(serviceLocator: serviceLocator)
        let presenter = AddNewRssSourcePresenterImpl(view: viewController, router: router, interactor: interactor)
        viewController.presenter = presenter
    }
}
