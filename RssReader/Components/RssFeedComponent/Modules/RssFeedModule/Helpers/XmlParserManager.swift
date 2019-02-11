
import Foundation

enum ElementType: String {
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
    
    private var elementType: ElementType?
    
    //MARK:- Public Properties
    
    var feeds: [RssItem] = []
    
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
    
    //MARK:- XMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementType = ElementType(rawValue: elementName)
        guard let type = self.elementType else {
            return
        }
        switch type {
        case .item:
            self.builder.reset()
        case .enclosure:
            if let urlString = attributeDict["url"] {
                self.builder.imgURL = urlString
            }
        default:
            return
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard let endType = ElementType(rawValue: elementName), endType == .item else {
            return
        }
        if let newItem = self.builder.tryToBuild() {
            feeds.append(newItem)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElementType = self.elementType else {
            return
        }
        switch currentElementType {
        case .title:
            self.builder.title?.append(string)
        case .link:
            self.builder.link?.append(string)
        case .description:
            self.builder.description?.append(string)
        case .pubDate:
            self.builder.date?.append(string)
        default:
            return
        }
    }
}
