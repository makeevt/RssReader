
import Foundation
import CoreData

protocol AddNewRssSourceInteractor {
    func addNewRssSource(sourceUrlString: String)
}

class AddNewRssSourceInteractorImpl: AddNewRssSourceInteractor {
    
    private let serviceLocator: ServiceLocator
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }
    
    func addNewRssSource(sourceUrlString: String) {
        guard let url = URL(string: "http://www.sports.ru/sports_docs.xml") else {
            return
        }
        self.addNew()
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
