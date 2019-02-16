
import Foundation

protocol RssFeedView: class {
    func configure(viewModels: [RssItem])
    func configure(isLoading: Bool)
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
        let rssItems = self.interactor.obtainRssItems()
        self.view?.configure(viewModels: rssItems)
    }
    
    func didTriggerItemSelected(item: RssItem) {
        self.router.showNewsDetailsPage(item: item)
    }
    
    func didTriggerReloadStarted() {
        self.view?.configure(isLoading: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) { [weak self] in
            guard let `self` = self else { return }
            self.view?.configure(isLoading: false)
        }
    }
}
