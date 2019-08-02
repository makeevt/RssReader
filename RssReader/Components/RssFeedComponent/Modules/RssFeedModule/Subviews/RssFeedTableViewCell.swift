
import UIKit

class RssFeedTableViewCell: UITableViewCell {
    
    //MARK:- Constants
    
    private struct Constants {
        static let datePlaceholder = "rssFeed.cell.datePlaceholder".localized
    }
    
    //MARK:- Outlets

    @IBOutlet private weak var previewImageView: CircleImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    //MARK:- Public Properties
    
    var viewModel: RssItem? {
        didSet {
            self.updateInterface()
        }
    }
    
    //MARK:- Public Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateLabel.font = UIFont.helveticaNeueLightFont(ofSize: 12)
        self.dateLabel.textColor = UIColor.gray
        
        self.titleLabel.font = UIFont.helveticaNeueMediumFont(ofSize: 16)
        self.titleLabel.textColor = UIColor.darkText
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.previewImageView.stopImageLoading()
        self.resetInterface()
    }
    
    //MARK:- Private methods
    
    private func updateInterface() {
        guard let viewModel = self.viewModel else {
            self.resetInterface()
            return
        }
        self.titleLabel.text = viewModel.title
        self.dateLabel.text = viewModel.date ?? Constants.datePlaceholder
        if let url = viewModel.imageURLs.first {
            self.previewImageView.startImageLoading(urlPath: url)
        }
    }
    
    private func resetInterface() {
        self.previewImageView.image = nil
        self.dateLabel.text = ""
        self.titleLabel.text = ""
    }
    
    
}
