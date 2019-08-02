
import Foundation

protocol RssFeedInteractorOutput: class {
    func rssItemsDidChange(newItems: [RssItem])
    func rssLoadingFailedWithError(error: Error)
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
    private var url3: URL = URL(string: "https://habr.com/ru/rss/best/daily/?fl=ru")!
    
    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        self.parser = XmlParserManager(contentURL: self.url2)
        self.parser.delegate = self
    }
    
    func loadRssItems() {
        self.parser.startAsyncParse()
    }
    
    //MARK:- XmlParserManagerDelegate
    
    func xmlParserManagerDidEndParsing(_ manager: XmlParserManager, newItems: [RssItem]) {
        Thread.do_onMainThread {
            self.output?.rssItemsDidChange(newItems: newItems)
        }
    }
    
    func xmlParserManagerDidHandleError(_ manager: XmlParserManager, error: Error) {
        Thread.do_onMainThread {
            self.output?.rssLoadingFailedWithError(error: error)
        }
    }
    
}
