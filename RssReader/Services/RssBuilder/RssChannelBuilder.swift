//
//  RssChannelBuilder.swift
//  RssReader
//
//  Created by 1 on 13/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

class RssChannelBuilder: RssBuilder {
    
    private var rssChannel: RssChannel?
    
    func startBuilding() {
        self.rssChannel = RssChannel()
    }
    
    func startNewElement(elementType: XmlElementType, attributes: [String: String]) {
        // Nothing to do
    }
    
    func processValueFor(_ elementType: XmlElementType, value: String) {
        switch elementType {
        case .title:
            self.rssChannel?.title.append(value)
        case .link:
            self.rssChannel?.link.append(value)
        case .description:
            self.rssChannel?.description.append(value)
        case .pubDate:
            self.rssChannel?.dateString.append(value)
        case .channel, .item, .enclosure, .url, .image:
            break
        }
    }
    
    func buildChannel(with items: [RssItem], channelImage: RssChannelImage?) -> RssChannel? {
        guard let channel = self.rssChannel else {
            return nil
        }
        channel.title = channel.title.trimmingCharacters(in: .whitespacesAndNewlines)
        channel.link = channel.link.trimmingCharacters(in: .whitespacesAndNewlines)
        channel.description = channel.description.trimmingCharacters(in: .whitespacesAndNewlines)
        channel.dateString = channel.dateString.trimmingCharacters(in: .whitespacesAndNewlines)
        channel.date = DateFormatterProvider.shared.formatterFor(type: .rssInputFormat, timeOffset: .local).date(from: channel.dateString)
        channel.items = items
        channel.image = channelImage
        return channel
    }
    
}
