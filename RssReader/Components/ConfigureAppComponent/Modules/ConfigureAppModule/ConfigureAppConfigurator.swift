

import UIKit

protocol ConfigureAppConfigurator {
    func configureViewController(_ viewController: ConfigureAppViewController)
}

class ConfigureAppConfiguratorImpl: ConfigureAppConfigurator {
    func configureViewController(_ viewController: ConfigureAppViewController) {
        let router = ConfigureAppRouterImpl()
        let useCase = ConfigureDefaultAppUseCase()
        let presenter = ConfigureAppPresenterImpl()
        presenter.router = router
        presenter.useCase = useCase
        viewController.presenter = presenter
        presenter.viewController = viewController
    }
}
