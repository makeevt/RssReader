
import Foundation
import Alamofire

protocol XmlParserManagerDelegate: class {
    func xmlParserManagerDidEndParsing(_ manager: XmlParserManager, newItems: [RssItem])
    func xmlParserManagerDidHandleError(_ manager: XmlParserManager, error: Error)
}

class XmlParserManager: NSObject, XMLParserDelegate {
    
    //MARK:- Public Properties
    
    weak var delegate: XmlParserManagerDelegate?
    
    //MARK:- Private Properties
    
    private let contentURL: URL
    private let buildDirector: RssBuilderDirector
    
    //MARK:- Init
    
    init(contentURL: URL) {
        self.contentURL = contentURL
        self.buildDirector = RssBuilderDirector()
        super.init()
    }
    
    //MARK:- Public methods
    
    func startAsyncParse() {
        AF.request(self.contentURL).response(completionHandler: { [weak self] data in
            guard let self = self else { return }
            if let error = data.error {
                self.delegate?.xmlParserManagerDidHandleError(self, error: error)
            } else if let data = data.data {
                self.parseResponse(data: data)
            }
        })
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
    
    func parserDidStartDocument(_ parser: XMLParser) {
        self.buildDirector.startNewDocument()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.buildDirector.startNewElement(elementName: elementName, attributes: attributeDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.buildDirector.endElement(elementName: elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.buildDirector.processValue(string)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let items = self.buildDirector.resultChannel?.items  {
            self.delegate?.xmlParserManagerDidEndParsing(self, newItems: items)
        } else {
            // TODO: - call delegate error
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.delegate?.xmlParserManagerDidHandleError(self, error: parseError)
    }
}
