
import Foundation
import CoreData
import QueryKit

protocol AddNewRssSourceInteractor {

}

class AddNewRssSourceInteractorImpl: AddNewRssSourceInteractor {
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    func addNew() {
        self.serviceLocator.rssPersistentContainer.mainContext.performChangesAndSaveOrRollBack {
            _ = CDRssSource.insertToContext(self.serviceLocator.rssPersistentContainer.mainContext, configure: { source in
                source.uuid = UUID().uuidString
                source.addingDate = Date()
                source.name = "\(Date())"
                source.link = ""
                source.numberOfUnread = 8
            })
        }
    }
    
}
