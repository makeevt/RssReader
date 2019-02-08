import Foundation

extension URL {
    public static var rss_documentsDirectiryURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }
    
}
