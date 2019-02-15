
import Foundation

protocol NewsDetailsPageView: class {
    func configure(imageURL: String?, title: String?, description: String?)
}

protocol NewsDetailsPagePresenter: class {
    func didTriggerViewReadyEvent()
}

class NewsDetailsPagePresenterImpl: NewsDetailsPagePresenter {
    
    private weak var view: NewsDetailsPageView?
    private var router: NewsDetailsPageRouter
    private var interactor: NewsDetailsPageInteractor
    
    
    init(view: NewsDetailsPageView, router: NewsDetailsPageRouter, interactor: NewsDetailsPageInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func didTriggerViewReadyEvent() {
        self.view?.configure(imageURL: self.interactor.newsImageURL, title: self.interactor.newsTitle, description: self.interactor.newsDescription)
    }
}
