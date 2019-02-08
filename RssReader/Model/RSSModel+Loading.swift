
import CoreData

public func loadRSSModel(completion: @escaping SetupCallback) {
    RSSPersistentContainer.constructSQLiteStack(modelName: "RssReader",
                                                in: Bundle.main) { (result) in
                                                    switch result {
                                                    case .success(_):
                                                        completion(result)
                                                    default:
                                                        completion(result)
                                                    }
                                                    
    }
}
