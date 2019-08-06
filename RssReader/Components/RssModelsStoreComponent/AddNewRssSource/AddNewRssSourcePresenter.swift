import Foundation

protocol AddNewRssSourceView: class {
    func applyState(_ state: AddNewRssSourceViewState)
}

protocol AddNewRssSourcePresenter: class {
    func didTriggerViewReadyEvent()
    func didTriggerCloseAction()
    func didTriggerAddAction(rssSourceLink: String)
}

class AddNewRssSourcePresenterImpl: AddNewRssSourcePresenter {
    
    private weak var view: AddNewRssSourceView?
    private var router: AddNewRssSourceRouter
    private var interactor: AddNewRssSourceInteractor
    
    
    init(view: AddNewRssSourceView, router: AddNewRssSourceRouter, interactor: AddNewRssSourceInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func didTriggerViewReadyEvent() {
        self.view?.applyState(.initial)
    }
    
    func didTriggerCloseAction() {
        self.router.dismissAddNewRssSource()
    }
    
    func didTriggerAddAction(rssSourceLink: String) {
        self.view?.applyState(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.view?.applyState(.error)
        })
    }
}

