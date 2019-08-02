
import Foundation

enum XmlElementType: String {
    case item = "item"
    case enclosure = "enclosure"
    case title = "title"
    case link = "link"
    case description = "description"
    case pubDate = "pubDate"
}

protocol XmlParserManagerDelegate: class {
    func xmlParserManagerDidEndParsing(_ manager: XmlParserManager, newItems: [RssItem])
}

class XmlParserManager: NSObject, XMLParserDelegate {
    
    //MARK:- Public Properties
    
    weak var delegate: XmlParserManagerDelegate?
    
    //MARK:- Private Properties
    
    private let contentURL: URL
    private let builder: RssItemBuilder
    
    private var currentElementType: XmlElementType?
    private var feeds: [RssItem] = []
    
    //MARK:- Init
    
    init(contentURL: URL) {
        self.contentURL = contentURL
        self.builder = RssItemBuilder()
        super.init()
    }
    
    //MARK:- Public methods
    
    func startAsyncParse() {
        self.feeds.removeAll()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            guard let parser = XMLParser(contentsOf: self.contentURL) else {
                return
            }
            parser.delegate = self
            parser.shouldProcessNamespaces = false
            parser.shouldReportNamespacePrefixes = false
            parser.shouldResolveExternalEntities = false
            parser.parse()
        }
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
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.delegate?.xmlParserManagerDidEndParsing(self, newItems: self.feeds)
    }
}
