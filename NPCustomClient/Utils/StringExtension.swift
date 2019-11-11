//
//  StringExtension.swift
//  NPCustomClient
//
//  Created by Денис Марков on 11/8/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation

let LANGUAGE = Locale.current.languageCode

extension String {
    
    func localized() -> String {
        
        if let path = Bundle.main.path(forResource: LANGUAGE, ofType:  "lproj") {
            print(path)
            guard let bundle = Bundle(path: path) else { return self }
            print(bundle)
            return NSLocalizedString(self, tableName: nil, bundle: bundle,   value: self, comment: "")
        }
        return self
    }
    
}
