
import Foundation

class RssItemBuilder {
    
    private var title: String?
    private var link: String?
    private var description: String?
    private var date: String?
    private var imgURLs: [String] = []
    
    func newItem() {
        self.title = nil
        self.link = nil
        self.description = nil
        self.date = nil
        self.imgURLs.removeAll()
    }
    
    func addImageURL(urlString: String) {
        self.imgURLs.append(urlString)
    }
    
    func processValue(_ value: String, elementType: XmlElementType) {
        switch elementType {
        case .title:
            if self.title == nil { self.title = "" }
            self.title?.append(value)
        case .link:
            if self.link == nil { self.link = "" }
            self.link?.append(value)
        case .description:
            if self.description == nil { self.description = "" }
            self.description?.append(value)
        case .pubDate:
            if self.date == nil { self.date = "" }
            self.date?.append(value)
        default:
            return
        }
    }
    
    func tryToBuild() -> RssItem? {
        guard let title = self.title?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        guard let link = self.link?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        let description = self.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = self.date?.trimmingCharacters(in: .whitespacesAndNewlines)
        return RssItem(title: title, link: link, imageURLs: self.imgURLs, description: description, date: date)
    }
    
}
