
import Foundation

class RssItem {
    
    let title: String
    let link: String
    let img: [String]
    let description: String
    let date: String
    
    init(title: String, link: String, img: [String], description: String, date: String) {
        self.title = title
        self.link = link
        self.img = img
        self.description = description
        self.date = date
    }
    
}
