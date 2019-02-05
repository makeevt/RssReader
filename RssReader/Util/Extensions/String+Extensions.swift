import Foundation
import UIKit

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    static func notNil(_ string: String?) -> String {
        guard let string = string else { return String() }
        return string
    }
    
    func attributedStringWithKern(value: CGFloat) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string:  self)
        attrString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSMakeRange(0, attrString.length))
        return attrString
    }
}
