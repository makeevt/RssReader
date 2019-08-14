
import Foundation

class RssItemBuilder: RssBuilder {
    
    private var rssItem: RssItem?
    
    func startBuilding() {
        self.rssItem = RssItem()
    }
    
    func startNewElement(elementType: XmlElementType, attributes: [String: String]) {
        switch elementType {
        case .enclosure:
            if let urlString = attributes["url"] {
                self.rssItem?.imageURLs.append(urlString)
            }
        default:
            return
        }
    }
    
    func processValueFor(_ elementType: XmlElementType, value: String) {
        switch elementType {
        case .title:
            self.rssItem?.title.append(value)
        case .link:
            self.rssItem?.link.append(value)
        case .description:
            self.rssItem?.description.append(value)
        case .pubDate:
            self.rssItem?.dateString.append(value)
        case .channel, .item, .enclosure, .url, .image:
            break
        }
    }
    
    func buildItem() -> RssItem? {
        guard let item = self.rssItem else {
            return nil
        }
        item.title = item.title.trimmingCharacters(in: .whitespacesAndNewlines)
        item.link = item.link.trimmingCharacters(in: .whitespacesAndNewlines)
        item.description = item.description.trimmingCharacters(in: .whitespacesAndNewlines)
        item.dateString = item.dateString.trimmingCharacters(in: .whitespacesAndNewlines)
        item.date = DateFormatterProvider.shared.formatterFor(type: .rssInputFormat, timeOffset: .local).date(from: item.dateString)
        return item
    }
    
}
