
import Foundation

protocol RssFeedView: class {
    func configure(viewModels: [RssItem])
}

protocol RssFeedPresenter: class {
    func didTriggerViewReadyEvent()
    func didTriggerItemSelected(item: RssItem)
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
}
