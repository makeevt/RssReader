
import Foundation

class RssItem {
    
    let title: String?
    let link: String?
    let imageURLs: [String]
    let description: String?
    let date: String?
    
    init(title: String?, link: String?, imageURLs: [String], description: String?, date: String?) {
        self.title = title
        self.link = link
        self.imageURLs = imageURLs
        self.description = description
        self.date = date
    }
    
}
