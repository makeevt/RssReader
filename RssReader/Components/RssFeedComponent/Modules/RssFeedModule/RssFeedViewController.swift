
import UIKit

class RssFeedViewController: UIViewController, RssFeedView {
    
    //MARK:- Constants
    
    private struct Constants {
        static var screenTitle = "rssFeed.screenTitle".localized.uppercased()
        static let rssFeedCellReuseID = "RssFeedTableViewCellID"
        static let rowHeight: CGFloat = 90.0
    }
    
    //MARK:- Public properties
    
    var configurator: RssFeedConfigurator!
    var presenter: RssFeedPresenter!
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- Private properties
    
//    var viewModels: [CurrencyRateViewModel] = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.screenTitle
        self.configurator.configure(viewController: self)
        
        self.configureTableView()
        
        self.presenter.didTriggerViewReadyEvent()
    }
    
    // MARK: - Public methods
    
//    func configure(viewModels: [CurrencyRateViewModel]) {
//        self.viewModels = viewModels
//        self.tableView.reloadData()
//    }
    
    // MARK: - Private methods
    
    private func configureTableView() {
//        let nibName = UINib(nibName: "CurrencyRateTableViewCell", bundle: nil)
//        self.tableView.register(nibName, forCellReuseIdentifier: Constants.currencyRateCellReuseID)
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.rowHeight = Constants.rowHeight
    }
    
}

extension RssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
//        return self.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.rssFeedCellReuseID, for: indexPath) as? RssFeedTableViewCell else {
            fatalError()
        }
        
//        cell.delegate = self
//        cell.viewModel = self.viewModels[indexPath.row]
        
        return cell
    }
    
}
