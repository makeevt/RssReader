

import UIKit

class ConfigureAppViewController: UIViewController {
    
    var presenter: ConfigureAppPresenter!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.viewLoaded()
        self.imageView.startImageLoading(urlPath: "https://look.com.ua/pic/201406/1920x1080/look.com.ua-104898.jpg")
    }
}
