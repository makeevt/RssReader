
import Foundation

protocol RssFeedInteractor {
//    func obtainCurrencies() -> [CurrencyRateViewModel]
}

class RssFeedInteractorImpl: RssFeedInteractor {
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
}
