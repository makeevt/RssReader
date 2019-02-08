
import Foundation

protocol ConfigureAppUseCase {
    func constructServiceLocator(completion: @escaping (ServiceLocator) -> ())
}

class ConfigureDefaultAppUseCase: ConfigureAppUseCase{
    
    func constructServiceLocator(completion: @escaping (ServiceLocator) -> ()) {

        var error: Swift.Error?
        var persistentContainer: RSSPersistentContainer?
        
        loadRSSModel { (result) in
            switch result {
            case .success(let container):
                persistentContainer = container
            case .failure(let localError):
                error = localError
            }
            
            if let persistentContainer = persistentContainer {
                let locator = DefaultServiceLocator(rssPersistentContainer: persistentContainer)
                completion(locator)
                return
            }
            
            if let error = error {
                fatalError(String(describing: error))
            } else {
                fatalError()
            }
        }
    }
}

