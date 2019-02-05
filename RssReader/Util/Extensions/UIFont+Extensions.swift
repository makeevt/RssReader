
import Foundation
import UIKit

extension UIFont {
    
    // MARK:- Constants
    
    private struct Constants {
        static let helveticaNeueLight = "HelveticaNeue-Light"
        static let helveticaNeueBold = "HelveticaNeue-Bold"
        static let helveticaNeueMedium = "HelveticaNeue-Medium"
        static let helveticaNeueRegular = "HelveticaNeue"
    }
    
    // MARK:- Private methods
    
    private static func font(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    // MARK:- Public methods
    
    static func helveticaNeueMediumFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.font(name: Constants.helveticaNeueMedium, size: size)
    }
    
    static func helveticaNeueRegularFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.font(name: Constants.helveticaNeueRegular, size: size)
    }
    
    static func helveticaNeueLightFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.font(name: Constants.helveticaNeueLight, size: size)
    }
    
    static func helveticaNeueBoldFont(ofSize size: CGFloat) -> UIFont {
        return UIFont.font(name: Constants.helveticaNeueBold, size: size)
    }
    
}
