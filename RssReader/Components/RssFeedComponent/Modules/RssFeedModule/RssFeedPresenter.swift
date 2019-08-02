
import Foundation

protocol RssFeedView: class {
    func configure(viewModels: [RssItem])
    func configure(isLoading: Bool)
    func showUpdatingFailedAlert()
}

protocol RssFeedPresenter: class {
    func didTriggerViewReadyEvent()
    func didTriggerItemSelected(item: RssItem)
    func didTriggerReloadStarted()
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
        self.view?.configure(isLoading: true)
        self.interactor.loadRssItems()
    }
    
    func didTriggerItemSelected(item: RssItem) {
        self.router.showNewsDetailsPage(item: item)
    }
    
    func didTriggerReloadStarted() {
        self.view?.configure(isLoading: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) { [weak self] in
            guard let `self` = self else { return }
            self.view?.configure(isLoading: false)
            self.view?.showUpdatingFailedAlert()
        }
    }
}

extension RssFeedPresenterImpl: RssFeedInteractorOutput {
    func rssItemsDidChange(newItems: [RssItem]) {
        self.view?.configure(isLoading: false)
        self.view?.configure(viewModels: newItems)
    }
}
