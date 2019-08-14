//
//  CompositeRssBuilder.swift
//  RssReader
//
//  Created by Timofey Makeev on 13/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

class RssBuilderDirector {
    
    private var currentElementType: XmlElementType?
    private var currentBuildWorker: RssBuilder?
    
    private let channelBuilder = RssChannelBuilder()
    private let channelImageBuilder = RssChannelImageBuilder()
    private let channelItemBuilder = RssItemBuilder()
    
    private(set) var resultChannel: RssChannel?
    private var items: [RssItem] = []
    private var channelImage: RssChannelImage?
    
    func startNewDocument() {
        self.currentElementType = nil
        self.currentBuildWorker = nil
        self.resultChannel = nil
        self.channelImage = nil
        self.items.removeAll()
    }
    
    func startNewElement(elementName: String, attributes: [String: String]) {
        self.currentElementType = XmlElementType(rawValue: elementName)
        guard let elementType = self.currentElementType else { return }
        switch elementType {
        case .channel:
            self.channelBuilder.startBuilding()
            self.currentBuildWorker = self.channelBuilder
        case .item:
            self.channelItemBuilder.startBuilding()
            self.currentBuildWorker = self.channelItemBuilder
        case .image:
            self.channelImageBuilder.startBuilding()
            self.currentBuildWorker = self.channelImageBuilder
        case .title, .link, .description, .pubDate, .enclosure, .url:
            self.currentBuildWorker?.startNewElement(elementType: elementType, attributes: attributes)
        }
    }
    
    func endElement(elementName: String) {
        guard let elementType = XmlElementType(rawValue: elementName) else { return }
        switch elementType {
        case .channel:
            self.resultChannel = self.channelBuilder.buildChannel(with: self.items, channelImage: self.channelImage)
            self.currentBuildWorker = nil
        case .item:
            if let item = self.channelItemBuilder.buildItem() {
                self.items.append(item)
            }
            self.currentBuildWorker = nil
        case .image:
            self.channelImage = self.channelImageBuilder.buildChannelImage()
            self.currentBuildWorker = nil
        case .title, .link, .description, .pubDate, .enclosure, .url:
            break
        }
    }
    
    func processValue(_ value: String) {
        guard let type = self.currentElementType else { return }
        self.currentBuildWorker?.processValueFor(type, value: value)
    }
    
}
