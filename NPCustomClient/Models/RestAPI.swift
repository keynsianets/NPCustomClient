//
//  RestAPI.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/31/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation
import Alamofire


class RestAPI: NSObject {
    
    static let shared = RestAPI()
    
    let headers = [
        "Content-Type":"application/json"
    ]
    
    var parameters: [String: Any] = ["apiKey": apiKey, ]
    
}
