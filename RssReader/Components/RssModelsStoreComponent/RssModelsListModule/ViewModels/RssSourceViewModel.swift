//
//  RssSourceViewModel.swift
//  RssReader
//
//  Created by 1 on 05/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

struct RssSourceViewModel {
    
    let uuid: String
    let name: String
    let link: String
    let imageUrl: String?
    let description: String?
    let numberOfUnread: Int?
    
    init(uuid: String, name: String, link: String, imageUrl: String?, description: String?, numberOfUnread: Int?) {
        self.uuid = uuid
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.description = description
        self.numberOfUnread = numberOfUnread
    }
    
}
