import Foundation

protocol RssModelsListView: class {
    func configure(viewModels: [RssSourceViewModel])
    func performChanges(_ changes: CoreDataChangeTransactionBatch<RssSourceViewModel>)
}

protocol RssModelsListPresenter: class {
    func didTriggerViewReadyEvent()
    func didTriggerItemSelected(item: RssSourceViewModel)
    func didTriggerItemDeleted(item: RssSourceViewModel)
    func didTriggerAddNewSource()
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
        self.view?.configure(viewModels: self.interactor.rssSourceModels)
    }
    
    func didTriggerItemSelected(item: RssSourceViewModel) {
        self.router.showRssFeed()
    }
    
    func didTriggerItemDeleted(item: RssSourceViewModel) {
        self.interactor.deleteRssSource(model: item)
    }
    
    func didTriggerAddNewSource() {
        self.router.showAddNewSource()
    }
    
}

extension RssModelsListPresenterImpl: RssModelsListInteractorOutput {
    
    func rssSourceModelsChanged(changes: CoreDataChangeTransactionBatch<RssSourceViewModel>) {
        self.view?.performChanges(changes)
    }
    
}
