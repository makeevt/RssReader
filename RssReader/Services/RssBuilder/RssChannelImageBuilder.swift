//
//  RssChannelImageBuilder.swift
//  RssReader
//
//  Created by 1 on 13/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

class RssChannelImageBuilder: RssBuilder {
    
    private var rssImage: RssChannelImage?
    
    func startBuilding() {
        self.rssImage = RssChannelImage()
    }
    
    func startNewElement(elementType: XmlElementType, attributes: [String: String]) {
        // Nothing to do
    }
    
    func processValueFor(_ elementType: XmlElementType, value: String) {
        switch elementType {
        case .title:
            self.rssImage?.title.append(value)
        case .link:
            self.rssImage?.link.append(value)
        case .description:
            self.rssImage?.description.append(value)
        case .url:
            self.rssImage?.imageURL.append(value)
        case .channel, .item, .enclosure, .image, .pubDate:
            break
        }
    }
    
    func buildChannelImage() -> RssChannelImage? {
        guard let image = self.rssImage else {
            return nil
        }
        image.title = image.title.trimmingCharacters(in: .whitespacesAndNewlines)
        image.link = image.link.trimmingCharacters(in: .whitespacesAndNewlines)
        image.description = image.description.trimmingCharacters(in: .whitespacesAndNewlines)
        image.imageURL = image.imageURL.trimmingCharacters(in: .whitespacesAndNewlines)
        return image
    }
    
}
