//
//  RssModelTableViewCell.swift
//  RssReader
//
//  Created by 1 on 02/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import UIKit

class RssModelTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet private weak var previewImageView: CircleImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberOfUnreadContainerView: UIView!
    @IBOutlet private weak var numberOfUnreadLabel: UILabel!
    
    //MARK:- Public Properties
    
    var viewModel: RssSourceViewModel? {
        didSet {
            self.updateInterface()
        }
    }
    
    //MARK:- Public Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.nameLabel.font = UIFont.helveticaNeueMediumFont(ofSize: 16)
        self.nameLabel.textColor = UIColor.darkText
        
        self.numberOfUnreadLabel.font = UIFont.helveticaNeueMediumFont(ofSize: 14)
        self.numberOfUnreadLabel.textColor = UIColor.white
        
        self.numberOfUnreadContainerView.layer.masksToBounds = true
        self.numberOfUnreadContainerView.backgroundColor = UIColor.rssOrange
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.previewImageView.stopImageLoading()
        self.resetInterface()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.numberOfUnreadContainerView.layer.cornerRadius = self.numberOfUnreadContainerView.frame.width/2
    }
    
    //MARK:- Private methods
    
    private func updateInterface() {
        guard let viewModel = self.viewModel else {
            self.resetInterface()
            return
        }
        self.nameLabel.text = viewModel.name
        if let url = viewModel.imageUrl {
            self.previewImageView.startImageLoading(urlPath: url)
        }
        if let numberOfUnread = viewModel.numberOfUnread {
            self.numberOfUnreadContainerView.isHidden = false
            self.numberOfUnreadLabel.text = "\(numberOfUnread)"
        } else {
            self.numberOfUnreadContainerView.isHidden = true
            self.numberOfUnreadLabel.text = ""
        }
    }
    
    private func resetInterface() {
        self.previewImageView.image = nil
        self.nameLabel.text = ""
        self.numberOfUnreadContainerView.isHidden = true
        self.numberOfUnreadLabel.text = ""
    }
    
}
