
import Foundation

class RssItemBuilder {
    
    var title: String?
    var link: String?
    var description: String?
    var date: String?
    var imgURL: String?
    
    func reset() {
        self.title = ""
        self.link = ""
        self.description = ""
        self.date = ""
        self.imgURL = ""
    }
    
    func tryToBuild() -> RssItem? {
        guard let title = self.title, let link = self.link, let description = self.description, let date = self.date else {
            return nil
        }
        var imgURLS: [String] = []
        if let url = self.imgURL {
            imgURLS.append(url)
        }
        return RssItem(title: title, link: link, img: imgURLS, description: description, date: date)
    }
    
}
