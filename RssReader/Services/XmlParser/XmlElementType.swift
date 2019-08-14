//
//  XmlElementType.swift
//  RssReader
//
//  Created by Timofey Makeev on 14/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

enum XmlElementType: String {
    case channel = "channel"
    case item = "item"
    case title = "title"
    case link = "link"
    case description = "description"
    case pubDate = "pubDate"
    case url = "url"
    case enclosure = "enclosure"
    case image = "image"
}
