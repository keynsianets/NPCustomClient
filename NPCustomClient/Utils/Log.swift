//
//  File.swift
//  NPCustomClient
//
//  Created by Denis Markov on 8/1/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation
import Firebase

class Log {
    
    
    static func logNewTrack(_ track: String) {
        Analytics.logEvent("addNewTrack", parameters: [
            "track": track as NSObject
            ])
    }
}
