
import Foundation

protocol NewsDetailsPageInteractor {
    
}

class NewsDetailsPageInteractorImpl: NewsDetailsPageInteractor {
    
    private let serviceLocator: ServiceLocator
    
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    
}

