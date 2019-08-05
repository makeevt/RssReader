import Foundation

protocol RssModelsListView: class {
    func configure(viewModels: [RssSourceViewModel])
}

protocol RssModelsListPresenter: class {
    func didTriggerViewReadyEvent()
    func didTriggerItemSelected(item: RssSourceViewModel)
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
        self.view?.configure(viewModels: [RssSourceViewModel.init(name: "Test source RSS feed", link: "", imageUrl: "", description: "", numberOfUnread: 31)])
    }
    
    func didTriggerItemSelected(item: RssSourceViewModel) {
        
    }
    
}
