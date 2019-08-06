import UIKit

class RssModelsListViewController: UIViewController, RssModelsListView {
    
    //MARK:- Constants
    
    private struct Constants {
        static let screenTitle = "rssModelsList.screenTitle".localized.uppercased()
        static let placeholderTitle = "rssModelsList.placeholderTitle".localized
        static let placeholderAddRssButtonTitle = "rssModelsList.placeholderAddRssButtonTitle".localized
        static let rssModelsCellReuseID = "RssModelsCellReuseID"
        static let rowHeight: CGFloat = 92.0
    }
    
    //MARK:- Public properties
    
    var configurator: RssModelsListConfigurator!
    var presenter: RssModelsListPresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var placeholderAddModelButton: UIButton!
    
    //MARK:- Private properties
    
    private lazy var addButton: UIBarButtonItem = {
        let image = UIImage(named: "plus.icon")?.withRenderingMode(.alwaysTemplate)
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addRssTapped))
    }()
    
    private var viewModels: [RssSourceViewModel] = [] {
        didSet {
            self.placeholderView.isHidden = !viewModels.isEmpty
            self.tableView.isHidden = viewModels.isEmpty
        }
    }
    
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
    
    func configure(viewModels: [RssSourceViewModel]) {
        self.viewModels = viewModels
        self.tableView.reloadData()
    }
    
    func performChanges(_ changes: CoreDataChangeTransactionBatch<RssSourceViewModel>) {
        for deleteTransaction in changes.deletedTransactions {
            if let index = deleteTransaction.oldIndexPath?.row {
                self.viewModels.remove(at: index)
            }
        }
        for insertTransaction in changes.insertedTransactions {
            if let index = insertTransaction.newIndexPath?.row {
                self.viewModels.insert(insertTransaction.object, at: index)
            }
        }
        for updateTransaction in changes.updatedTransactions {
            if let index = updateTransaction.oldIndexPath?.row {
                self.viewModels[index] = updateTransaction.object
            }
        }
        self.tableView.processCacheTrackerChange(changes)
    }
    
    // MARK: - Actions
    
    @objc private func addRssTapped() {
        self.presenter.didTriggerAddNewSource()
    }
    
    @IBAction func placeholderAddRssButtonTapped(_ sender: UIButton) {
        self.presenter.didTriggerAddNewSource()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        let nibName = UINib(nibName: "RssModelTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: Constants.rssModelsCellReuseID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = Constants.rowHeight
        self.tableView.isHidden = true
    }
    
    private func configurePlaceholder() {
        self.placeholderLabel.font = UIFont.helveticaNeueLightFont(ofSize: 18)
        self.placeholderLabel.textColor = UIColor.gray
        self.placeholderLabel.attributedText = Constants.placeholderTitle.attributedStringWithKern(value: 1.0)
        
        self.placeholderAddModelButton.apply(styles: Styles.RSSButton.primary)
        self.placeholderAddModelButton.setTitle(Constants.placeholderAddRssButtonTitle, for: .normal)
        self.placeholderAddModelButton.setImage(UIImage(named: "plus.icon"), for: .normal)
        self.placeholderAddModelButton.tintColor = UIColor.white
        self.placeholderAddModelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
        
        cell.viewModel = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let itemForDeletion = self.viewModels[safe: indexPath.row] {
                self.presenter.didTriggerItemDeleted(item: itemForDeletion)
            }
        }
    }
    
}
