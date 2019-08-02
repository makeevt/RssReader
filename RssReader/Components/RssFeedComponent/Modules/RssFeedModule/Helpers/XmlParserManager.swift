
import Foundation
import Alamofire

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
    func xmlParserManagerDidHandleError(_ manager: XmlParserManager, error: Error)
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
        AF.request(self.contentURL).response(completionHandler: { [weak self] data in
            guard let self = self else { return }
            if let error = data.error {
                self.delegate?.xmlParserManagerDidHandleError(self, error: error)
            } else if let data = data.data {
                self.parseResponse(data: data)
            }
        })
    }
    
    func obtainFeeds() -> [RssItem] {
        return self.feeds
    }
    
    //MARK:- Private methods
    
    private func parseResponse(data: Data) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.shouldProcessNamespaces = false
            parser.shouldReportNamespacePrefixes = false
            parser.shouldResolveExternalEntities = false
            parser.parse()
        }
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.delegate?.xmlParserManagerDidHandleError(self, error: parseError)
    }
}
