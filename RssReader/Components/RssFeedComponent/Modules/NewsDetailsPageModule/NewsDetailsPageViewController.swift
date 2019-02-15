import UIKit

class NewsDetailsPageViewController: UIViewController,  NewsDetailsPageView {
    
    //MARK:- Constants
    
    private struct Constants {
        static let screenTitle = "newsDetails.screenTitle".localized.uppercased()
    }
    
    //MARK:- Public properties
    
    var configurator:  NewsDetailsPageConfigurator!
    var presenter:  NewsDetailsPagePresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var imageView: LoadableImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK:- Private properties
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "  ", style:.plain, target: nil, action: nil)
        self.title = Constants.screenTitle
        
        self.configurator.configure(viewController: self)
        
        self.titleLabel.font = UIFont.helveticaNeueRegularFont(ofSize: 20)
        self.titleLabel.textColor = UIColor.darkText
        
        self.descriptionLabel.font = UIFont.helveticaNeueMediumFont(ofSize: 16)
        self.descriptionLabel.textColor = UIColor.gray
        
        self.presenter.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public methods
    
    func configure(imageURL: String?, title: String?, description: String?) {
        if let imageURL = imageURL {
            self.imageView.startImageLoading(urlPath: imageURL)
        }
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
    
    // MARK: - Private methods
    
    
    
}
