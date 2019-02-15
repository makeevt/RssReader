
import Foundation

enum XmlElementType: String {
    case item = "item"
    case enclosure = "enclosure"
    case title = "title"
    case link = "link"
    case description = "description"
    case pubDate = "pubDate"
}

class XmlParserManager: NSObject, XMLParserDelegate {
    
    //MARK:- Private Properties
    
    private let parser: XMLParser?
    private let builder: RssItemBuilder
    
    private var currentElementType: XmlElementType?
    private var feeds: [RssItem] = []
    
    //MARK:- Init
    
    init(contentURL: URL) {
        self.parser = XMLParser(contentsOf: contentURL)
        self.builder = RssItemBuilder()
        super.init()
        
        self.parser?.delegate = self
        self.parser?.shouldProcessNamespaces = false
        self.parser?.shouldReportNamespacePrefixes = false
        self.parser?.shouldResolveExternalEntities = false
    }
    
    //MARK:- Public methods
    
    func startParse() {
        self.feeds.removeAll()
        self.parser?.parse()
    }
    
    func obtainFeeds() -> [RssItem] {
        return self.feeds
    }
    
    //MARK:- XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentElementType = XmlElementType(rawValue: elementName)
        guard let type = self.currentElementType else {
            return
        }
        switch type {
        case .item:
            self.builder.newItem()
        case .enclosure:
            if let urlString = attributeDict["url"] {
                self.builder.addImageURL(urlString: urlString)
            }
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let endType = XmlElementType(rawValue: elementName), endType == .item else {
            return
        }
        if let newItem = self.builder.tryToBuild() {
            self.feeds.append(newItem)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElementType = self.currentElementType else {
            return
        }
        self.builder.processValue(string, elementType: currentElementType)
    }
}
