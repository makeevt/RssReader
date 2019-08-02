
import Foundation

protocol RssModelsListInteractorOutput: class {
    
}

protocol RssModelsListInteractor {
    
}

class RssModelsListInteractorImpl: RssModelsListInteractor {
    
    weak var output: RssModelsListInteractorOutput?
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
}
