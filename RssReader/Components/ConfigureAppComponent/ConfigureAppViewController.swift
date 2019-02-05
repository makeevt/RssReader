

import UIKit

class ConfigureAppViewController: UIViewController {
    
    var presenter: ConfigureAppPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        presenter.viewLoaded()
    }
}
