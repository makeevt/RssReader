
import Foundation

protocol RssFeedView: class {
//    func configure(viewModels: [CurrencyRateViewModel])
}

protocol RssFeedPresenter: class {
    func didTriggerViewReadyEvent()
}

class RssFeedPresenterImpl: RssFeedPresenter {
    
    private weak var view: RssFeedView?
    private var router: RssFeedRouter
    private var interactor: RssFeedInteractor
    
    
    init(view: RssFeedView, router: RssFeedRouter, interactor: RssFeedInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func didTriggerViewReadyEvent() {
//        let currencies = self.interactor.obtainCurrencies()
//        self.view?.configure(viewModels: currencies)
    }
}
