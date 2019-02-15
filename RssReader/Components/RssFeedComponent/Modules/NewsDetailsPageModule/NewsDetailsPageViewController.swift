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
    
    
    //MARK:- Private properties
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.screenTitle
        
        self.configurator.configure(viewController: self)
        
        
        
        self.presenter.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public methods
    
    func configure() {
        
    }
    
    // MARK: - Private methods
    
    
    
}
