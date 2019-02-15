
import Foundation

protocol NewsDetailsPageInteractor {
    var newsImageURL: String? {get}
    var newsTitle: String? {get}
    var newsDescription: String? {get}
}

class NewsDetailsPageInteractorImpl: NewsDetailsPageInteractor {
    
    private let serviceLocator: ServiceLocator
    private let newsItem: RssItem
    
    var newsImageURL: String? {
        return self.newsItem.imageURLs.first
    }
    
    var newsTitle: String? {
        return self.newsItem.title
    }
    
    var newsDescription: String? {
        return self.newsItem.description
    }
    
    init(serviceLocator: ServiceLocator, newsItem: RssItem) {
        self.serviceLocator = serviceLocator
        self.newsItem = newsItem
    }
    
    
}

