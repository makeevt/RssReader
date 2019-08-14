//
//  RssChannel.swift
//  RssReader
//
//  Created by 1 on 13/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

class RssChannel {
    var title: String
    var link: String
    var description: String
    var image: RssChannelImage?
    var dateString: String
    var date: Date?
    var items: [RssItem]
    
    init() {
        self.title = ""
        self.link = ""
        self.description = ""
        self.dateString = ""
        self.items = []
    }
}
