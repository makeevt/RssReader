
import UIKit

class RssFeedTableViewCell: UITableViewCell {
    
    //MARK:- Outlets

    @IBOutlet private weak var previewImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    //MARK:- Public Properties
    
    var viewModel: RssItem? {
        didSet {
            self.updateInterface()
        }
    }
    
    //MARK:- Public Methods
    
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
        self.previewImageView.startImageLoading(urlPath: viewModel.img.first ?? "")
        self.dateLabel.text = viewModel.date
        self.descriptionLabel.text = viewModel.description
    }
    
    private func resetInterface() {
        self.previewImageView.image = nil
        self.dateLabel.text = ""
        self.descriptionLabel.text = ""
    }
    
    
}
