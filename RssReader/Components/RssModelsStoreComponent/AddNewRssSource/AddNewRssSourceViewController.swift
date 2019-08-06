import UIKit

enum AddNewRssSourceViewState {
    case initial
    case loading
    case error
}

class AddNewRssSourceViewController: UIViewController, AddNewRssSourceView {
    
    //MARK:- Constants
    
    private struct Constants {
        static let titleLabelText = "addNewRssSource.titleLabelText".localized
        static let errorLabelText = "addNewRssSource.errorLabelText".localized
        static let addNewSourceButtonTitle = "addNewRssSource.addNewSourceButtonTitle".localized
    }
    
    //MARK:- Public properties
    
    var configurator: AddNewRssSourceConfigurator!
    var presenter: AddNewRssSourcePresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLinkInputTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addNewSourceButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Private properties
    

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configurator.configure(viewController: self)
        
        self.configureBlurEffect()
        self.configureContainerView()
        self.configureLabels()
        self.configureButtons()
        
        self.presenter.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public methods
    
    func applyState(_ state: AddNewRssSourceViewState) {
        switch state {
        case .initial:
            self.activityIndicator.stopAnimating()
            self.addNewSourceButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.errorLabel.isHidden = true
        case .loading:
            self.activityIndicator.startAnimating()
            self.addNewSourceButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.errorLabel.isHidden = true
        case .error:
            self.activityIndicator.stopAnimating()
            self.addNewSourceButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.errorLabel.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.presenter.didTriggerCloseAction()
    }

    @IBAction func addNewSourceButtonTapped(_ sender: UIButton) {
        self.presenter.didTriggerAddAction(rssSourceLink: self.sourceLinkInputTextField.text ?? "")
    }
    
    // MARK: - Private methods
    
    private func configureBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        self.view.addSubview(blurEffectView)
        self.view.sendSubviewToBack(blurEffectView)
    }
    
    private func configureContainerView() {
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 12
        self.containerView.layer.borderColor = UIColor.rssOrange.withAlphaComponent(0.3).cgColor
        self.containerView.layer.borderWidth = 1
    }
    
    private func configureLabels() {
        self.titleLabel.font = UIFont.helveticaNeueRegularFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.rssTextGray
        self.titleLabel.attributedText = Constants.titleLabelText.attributedStringWithKern(value: 0.8)
        
        self.errorLabel.font = UIFont.helveticaNeueRegularFont(ofSize: 12)
        self.errorLabel.textColor = UIColor.red.withAlphaComponent(0.6)
        self.errorLabel.attributedText = Constants.errorLabelText.attributedStringWithKern(value: 0.4)
    }
    
    private func configureButtons() {
        self.closeButton.tintColor = UIColor.rssOrange
        
        self.addNewSourceButton.apply(styles: Styles.RSSButton.primary)
        self.addNewSourceButton.setTitle(Constants.addNewSourceButtonTitle, for: .normal)
        self.addNewSourceButton.setImage(UIImage(named: "plus.icon"), for: .normal)
        self.addNewSourceButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}
