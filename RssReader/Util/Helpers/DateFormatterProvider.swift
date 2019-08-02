//
//  DateFormatterProvider.swift
//  RssReader
//
//  Created by 1 on 02/08/2019.
//  Copyright © 2019 makeev. All rights reserved.
//

import Foundation

enum TimeOffsetType {
    case local
    case custom(offset: Int)
}

enum FormatType {
    case rssInputFormat
    case feedFormat
    
    var format: String {
        switch self {
        case .rssInputFormat:
            return "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        case .feedFormat:
            return "EEEE, dd MMM yyyy HH:mm"
        }
    }
}

private struct DateFormatterDictionaryKey: Hashable {
    
    let type: FormatType
    let offset: Int16
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("(\(type),\(offset))".hashValue)
    }
    
    static func ==(lhs: DateFormatterDictionaryKey, rhs: DateFormatterDictionaryKey) -> Bool {
        return lhs.type == rhs.type && lhs.offset == rhs.offset
    }
}

class DateFormatterProvider {
    
    static let shared = DateFormatterProvider()
    
    private init() { }
    
    private var dateFormatters: [DateFormatterDictionaryKey: DateFormatter] = [:]
    
    public func formatterFor(type: FormatType, timeOffset: TimeOffsetType) -> DateFormatter {
        
        let offsetValue: Int
        switch timeOffset {
        case .local:
            offsetValue = TimeZone.current.secondsFromGMT()/60
        case .custom(let offset):
            offsetValue = offset
        }
        
        let key = DateFormatterDictionaryKey(type: type, offset: Int16(offsetValue))
        
        if let formatter = dateFormatters[key] {
            return formatter
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 60 * 60 * Int(offsetValue))
        formatter.dateFormat = type.format
        formatter.locale = .current
        dateFormatters[key] = formatter
        
        return formatter
    }
}
