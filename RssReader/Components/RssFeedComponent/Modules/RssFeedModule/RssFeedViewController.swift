
import UIKit

class RssFeedViewController: UIViewController, RssFeedView {
    
    //MARK:- Constants
    
    private struct Constants {
        static let screenTitle = "rssFeed.screenTitle".localized.uppercased()
        static let updatingFailedAlertTitle = "rssFeed.updatingFailedAlert.title".localized
        static let updatingFailedAlertMessage = "rssFeed.updatingFailedAlert.message".localized
        static let rssFeedCellReuseID = "RssFeedTableViewCellID"
        static let estimatedRowHeight: CGFloat = 112.0
    }
    
    //MARK:- Public properties
    
    var configurator: RssFeedConfigurator!
    var presenter: RssFeedPresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- Private properties
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshValueChanged(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var loadingItemActivity: UIActivityIndicatorView?
    private lazy var loadingItem: UIBarButtonItem = {
        let activity = UIActivityIndicatorView()
        activity.style = UIActivityIndicatorView.Style.white
        self.loadingItemActivity = activity
        return UIBarButtonItem(customView: activity)
    }()
    
    private lazy var reloadButton: UIBarButtonItem = {
        let image = UIImage(named: "reload.icon")?.withRenderingMode(.alwaysTemplate)
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(reloadTapped))
    }()
    
    private var viewModels: [RssItem] = []
    private var isLoading: Bool = false
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "  ", style:.plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = self.reloadButton
        self.title = Constants.screenTitle
        self.configurator.configure(viewController: self)
        
        self.configureTableView()
        
        self.presenter.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public methods
    
    func configure(viewModels: [RssItem]) {
        self.viewModels = viewModels
        self.tableView.reloadData()
    }
    
    func configure(isLoading: Bool) {
        self.navigationItem.rightBarButtonItem = isLoading ? self.loadingItem : self.reloadButton
        isLoading ? self.loadingItemActivity?.startAnimating() : self.loadingItemActivity?.stopAnimating()
        if !isLoading && self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        self.isLoading = isLoading
    }
    
    func showUpdatingFailedAlert() {
        self.showAlert(title: Constants.updatingFailedAlertTitle, message: Constants.updatingFailedAlertMessage)
    }
    
    // MARK: - Actions
    
    @objc private func reloadTapped() {
        self.startReloading()
    }
    
    @objc func refreshValueChanged(_ sender: AnyObject) {
        self.startReloading()
    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
        let nibName = UINib(nibName: "RssFeedTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: Constants.rssFeedCellReuseID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = Constants.estimatedRowHeight
        self.tableView.addSubview(self.refreshControl)
    }
    
    private func startReloading() {
        if self.isLoading {
            return
        }
        self.presenter.didTriggerReloadStarted()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rssFeedCellReuseID, for: indexPath) as? RssFeedTableViewCell else {
            fatalError()
        }
        
        guard let item = self.viewModels[safe: indexPath.row] else {
            fatalError()
        }

        cell.viewModel = item
        
        return cell
    }
    
}
