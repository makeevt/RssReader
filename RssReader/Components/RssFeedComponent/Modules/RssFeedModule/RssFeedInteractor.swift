
import Foundation

protocol RssFeedInteractorOutput: class {
    func rssItemsDidChange(newItems: [RssItem])
}

protocol RssFeedInteractor {
    func loadRssItems()
}

class RssFeedInteractorImpl: RssFeedInteractor, XmlParserManagerDelegate {
    
    weak var output: RssFeedInteractorOutput?
    
    private let serviceLocator: ServiceLocator
    private let parser: XmlParserManager
    
    private var url: URL = URL(string: "http://feeds.skynews.com/feeds/rss/technology.xml")!
    private var url2: URL = URL(string: "http://www.sports.ru/sports_docs.xml")!
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        self.parser = XmlParserManager(contentURL: self.url2)
        self.parser.delegate = self
    }
    
    func loadRssItems() {
        self.parser.startParse()
    }
    
    //MARK:- XmlParserManagerDelegate
    
    func xmlParserManagerDidEndParsing(_ manager: XmlParserManager, newItems: [RssItem]) {
        Thread.do_onMainThread {
            self.output?.rssItemsDidChange(newItems: newItems)
        }
    }
    
}
