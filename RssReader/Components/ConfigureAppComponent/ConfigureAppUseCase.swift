
import Foundation

protocol ConfigureAppUseCase {
//    func constructServiceLocator(completion: @escaping (ServiceLocator) -> ())
}

class ConfigureDefaultAppUseCase: ConfigureAppUseCase{
    
//    func constructServiceLocator(completion: @escaping (ServiceLocator) -> ()) {
//
//        let dispatchGroup = DispatchGroup()
//
//        var error: Swift.Error?
//
//        var persistentContainer: TCAPersistentContainer?
//        dispatchGroup.enter()
//        loadTCAModel { (result) in
//            switch result {
//            case .success(let container):
//                persistentContainer = container
//            case .failure(let localError):
//                error = localError
//            }
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.notify(queue: DispatchQueue.main) {
//            if let persistentContainer = persistentContainer {
//                
//                let locator = DefaultServiceLocator(tcaPersistentContainer: persistentContainer)
//                completion(locator)
//            } else {
//                if let error = error {
//                    fatalError(String(describing: error))
//                } else {
//                    fatalError()
//                }
//            }
//        }
//    }
}

