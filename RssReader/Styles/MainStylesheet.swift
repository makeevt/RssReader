import UIKit
import Fashion

extension RawRepresentable where RawValue == String {
    var string: String { return "\(type(of:self))." + rawValue }
}

enum Styles {
    enum UINavigationBar: String, StringConvertible {
        case `default`
    }
}

struct MainStylesheet: Stylesheet {
    
    func define() {
        
        //MARK:- UINavigationBar
        
        register(Styles.UINavigationBar.default) { (navigationBar:UINavigationBar) in
            navigationBar.tintColor = UIColor.white
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
            
            navigationBar.titleTextAttributes              = [NSAttributedString.Key.font: UIFont.helveticaNeueMediumFont(ofSize: 17),
                                                              NSAttributedString.Key.foregroundColor: UIColor.white,
                                                              NSAttributedString.Key.kern: 0.7]
            navigationBar.isTranslucent                    = false
            navigationBar.barTintColor                     = UIColor.rssOrange
            navigationBar.backgroundColor                  = UIColor.rssOrange
        }
        
        //MARK:- Shared Styles
        
        share { (navBar:UINavigationBar) in
            navBar.apply(styles: Styles.UINavigationBar.default)
        }

        shareAppearance { (barButtonItem: UIBarButtonItem) in
            barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.helveticaNeueMediumFont(ofSize: 16)], for: UIControl.State.normal)
            barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.helveticaNeueMediumFont(ofSize: 16)], for: UIControl.State.highlighted)
            barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.helveticaNeueMediumFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)], for: UIControl.State.disabled)
        }
        
    }
}
