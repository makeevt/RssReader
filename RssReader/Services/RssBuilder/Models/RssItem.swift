
import Foundation

class RssItem {
    
    var title: String
    var link: String
    var imageURLs: [String]
    var description: String
    var date: Date?
    var dateString: String
    
    init() {
        self.title = ""
        self.link = ""
        self.imageURLs = []
        self.description = ""
        self.dateString = ""
    }
    
}
