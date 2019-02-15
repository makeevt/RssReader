
import Foundation
import UIKit

protocol NewsDetailsPageConfigurator {
    func configure(viewController: NewsDetailsPageViewController)
}

class NewsDetailsPageConfiguratorImpl: NewsDetailsPageConfigurator {
    private weak var navigationController: UINavigationController?
    private var serviceLocator: ServiceLocator!
    private let newsItem: RssItem
    
    init(navigationController: UINavigationController?, serviceLocator: ServiceLocator, newsItem: RssItem) {
        self.navigationController = navigationController
        self.serviceLocator = serviceLocator
        self.newsItem = newsItem
    }
    
    func configure(viewController: NewsDetailsPageViewController) {
        let router = NewsDetailsPageRouterImpl(navigationViewController: navigationController, serviceLocator: serviceLocator)
        let interactor = NewsDetailsPageInteractorImpl(serviceLocator: serviceLocator, newsItem: self.newsItem)
        let presenter = NewsDetailsPagePresenterImpl(view: viewController, router: router, interactor: interactor)
        viewController.presenter = presenter
    }
}
