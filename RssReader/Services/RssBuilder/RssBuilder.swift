//
//  RssBuilder.swift
//  RssReader
//
//  Created by 1 on 13/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

protocol RssBuilder {
    func startBuilding()
    func startNewElement(elementType: XmlElementType, attributes: [String: String])
    func processValueFor(_ elementType: XmlElementType, value: String)
}
