
import Foundation
import CoreData
import QueryKit

protocol RssModelsListInteractorOutput: class {
    func rssSourceModelsChanged(changes: CoreDataChangeTransactionBatch<RssSourceViewModel>)
}

protocol RssModelsListInteractor {
    var rssSourceModels: [RssSourceViewModel] { get }
    func deleteRssSource(model: RssSourceViewModel)
}

class RssModelsListInteractorImpl: RssModelsListInteractor {
    
    weak var output: RssModelsListInteractorOutput?
    
    private let serviceLocator: ServiceLocator
    private var coreDataTracker: CoreDataChangeTracker<CDRssSource, RssSourceViewModel>?
    
    var rssSourceModels: [RssSourceViewModel] {
        return self.coreDataTracker?.fetchedModels() ?? []
    }
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        
        self.configureCoreDataChangeTracker()
    }
    
    func deleteRssSource(model: RssSourceViewModel) {
        let context = self.serviceLocator.rssPersistentContainer.mainContext
        context.performChangesAndSaveOrRollBack {
            let fetchRequest = NSFetchRequest<CDRssSource>(entityName: CDRssSource.entityName)
            fetchRequest.predicate = CDRssSource.predicateForUuid(uuid: model.uuid)
            fetchRequest.fetchLimit = 1
            let result = try? context.fetch(fetchRequest)
            guard let cdModelForDeletion = result?.first else {
                return
            }
            context.delete(cdModelForDeletion)
        }
    }
    
    private func configureCoreDataChangeTracker() {
        let request = CoreDataRequest(predicate: CDRssSource.defaultPredicate, sortDescriptors: [CDRssSource.addingDate.descending()])
        let coreDataTracker = CoreDataChangeTracker<CDRssSource, RssSourceViewModel>(cacheRequest: request, context: self.serviceLocator.rssPersistentContainer.mainContext)
        coreDataTracker.didChangeHandler = { [weak self] batch in
            guard let self = self else { return }
            self.output?.rssSourceModelsChanged(changes: batch)
        }
        coreDataTracker.modelBuilder = { cdModel in
            return RssSourceViewModel(uuid: cdModel.uuid,
                                      name: cdModel.name,
                                      link: cdModel.link,
                                      imageUrl: cdModel.imageUrl,
                                      description: cdModel.note,
                                      numberOfUnread: Int(cdModel.numberOfUnread))
        }
        coreDataTracker.performFetch()
        self.coreDataTracker = coreDataTracker
    }
    
}
