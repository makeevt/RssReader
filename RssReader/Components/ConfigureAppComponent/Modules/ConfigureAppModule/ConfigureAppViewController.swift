

import UIKit

class ConfigureAppViewController: UIViewController {
    
    var presenter: ConfigureAppPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewLoaded()
    }
}
