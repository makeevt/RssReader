
import Foundation

protocol RssFeedInteractor {
    func obtainRssItems() -> [RssItem]
}

class RssFeedInteractorImpl: RssFeedInteractor {
    
    private let serviceLocator: ServiceLocator
    private let parser: XmlParserManager
    
    private var url: URL = URL(string: "http://feeds.skynews.com/feeds/rss/technology.xml")!
    private var url2: URL = URL(string: "http://www.sports.ru/sports_docs.xml")!
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        self.parser = XmlParserManager(contentURL: self.url2)
        self.parser.startParse()
    }
    
    func obtainRssItems() -> [RssItem] {
        return self.parser.obtainFeeds()
    }
    
}
