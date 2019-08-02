import UIKit

class RssModelsListViewController: UIViewController, RssModelsListView {
    
    //MARK:- Constants
    
    private struct Constants {
        static let screenTitle = "rssModelsList.screenTitle".localized.uppercased()
        static let rssModelsCellReuseID = "RssModelsCellReuseID"
        static let estimatedRowHeight: CGFloat = 112.0
    }
    
    //MARK:- Public properties
    
    var configurator: RssModelsListConfigurator!
    var presenter: RssModelsListPresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    //MARK:- Private properties
    
    private lazy var addButton: UIBarButtonItem = {
        let image = UIImage(named: "plus.icon")?.withRenderingMode(.alwaysTemplate)
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addRssTapped))
    }()
    
    private var viewModels: [RssItem] = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "  ", style:.plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = self.addButton
        self.title = Constants.screenTitle
        self.configurator.configure(viewController: self)
        
        self.configureTableView()
        self.configurePlaceholder()
        
        self.presenter.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public methods
    
    func configure(viewModels: [RssItem]) {
        self.viewModels = viewModels
        self.placeholderView.isHidden = !viewModels.isEmpty
        self.tableView.isHidden = viewModels.isEmpty
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func addRssTapped() {
        
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        let nibName = UINib(nibName: "RssModelTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: Constants.rssModelsCellReuseID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = Constants.estimatedRowHeight
        self.tableView.isHidden = true
    }
    
    private func configurePlaceholder() {
        self.placeholderLabel.font = UIFont.helveticaNeueLightFont(ofSize: 18)
        self.placeholderLabel.textColor = UIColor.gray
//        self.placeholderLabel.attributedText = Constants.placeholderTitle.attributedStringWithKern(value: 1.0)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RssModelsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = self.viewModels[safe: indexPath.row] {
            self.presenter.didTriggerItemSelected(item: item)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rssModelsCellReuseID, for: indexPath) as? RssModelTableViewCell else {
            fatalError()
        }
        
        guard let item = self.viewModels[safe: indexPath.row] else {
            fatalError()
        }
        
//        cell.configure
        
        return cell
    }
    
}
