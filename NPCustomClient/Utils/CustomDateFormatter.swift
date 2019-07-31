//
//  CustomDateFormatter.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/31/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation

class CustomDateFormatter {
    
    static func dateString(source: String?, sourceFormat: String, targetFormat: String) -> String {
        guard let source = source else { return "-" }
        let sourceDateFormatter = DateFormatter()
        sourceDateFormatter.dateFormat = sourceFormat
        guard let date = sourceDateFormatter.date(from: source) else { return "-" }
        let targetDateFormatter = DateFormatter()
        targetDateFormatter.dateFormat = targetFormat
        return targetDateFormatter.string(from: date)
    }
    
    static func date(source: String?, sourceFormat: String, targetFormat: String) -> Date {
        guard let source = source else { return Date()}
        let sourceDateFormatter = DateFormatter()
        sourceDateFormatter.dateFormat = sourceFormat
        return sourceDateFormatter.date(from: source) ?? Date()
    }
}
