

import Foundation

protocol ConfigureAppPresenter {
    func viewLoaded()
}


class ConfigureAppPresenterImpl: ConfigureAppPresenter {
    var router: ConfigureAppRouter!
    var useCase: ConfigureAppUseCase!
    weak var viewController: ConfigureAppViewController!
    
    func viewLoaded() {
        useCase.constructServiceLocator { (locator) in
            Thread.do_onMainThread {
                self.router.showRssFeed(locator: locator)
            }
        }
    }
}
