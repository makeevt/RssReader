
import UIKit

class RssFeedViewController: UIViewController, RssFeedView {
    
    //MARK:- Constants
    
    private struct Constants {
        static let screenTitle = "rssFeed.screenTitle".localized.uppercased()
        static let rssFeedCellReuseID = "RssFeedTableViewCellID"
        static let estimatedRowHeight: CGFloat = 112.0
    }
    
    //MARK:- Public properties
    
    var configurator: RssFeedConfigurator!
    var presenter: RssFeedPresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- Private properties
    
    var viewModels: [RssItem] = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Private methods
    
    private func configureTableView() {
        let nibName = UINib(nibName: "RssFeedTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: Constants.rssFeedCellReuseID)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = Constants.estimatedRowHeight
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
