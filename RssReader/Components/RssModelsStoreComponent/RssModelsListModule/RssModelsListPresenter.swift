import Foundation

protocol RssModelsListView: class {
    func configure(viewModels: [RssItem])
}

protocol RssModelsListPresenter: class {
    func didTriggerViewReadyEvent()
    func didTriggerItemSelected(item: RssItem)
}

class RssModelsListPresenterImpl: RssModelsListPresenter {
    
    private weak var view: RssModelsListView?
    private var router: RssModelsListRouter
    private var interactor: RssModelsListInteractor
    
    
    init(view: RssModelsListView, router: RssModelsListRouter, interactor: RssModelsListInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func didTriggerViewReadyEvent() {
        
    }
    
    func didTriggerItemSelected(item: RssItem) {
        
    }
    
}
