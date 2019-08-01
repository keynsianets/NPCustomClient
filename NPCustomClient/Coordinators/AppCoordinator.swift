//
//  AppCoordinator.swift
//  NPCustomClient
//
//  Created by Denis Markov on 8/1/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow?
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()

    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        openMyParcels()
    }
    
    override func finish() {
        
    }
    
    func openMyParcels() {
        let myParcels = MyParcelsCoordinator(rootViewController: rootViewController)
        addChildCoordinator(myParcels)
        myParcels.start()
    }
    
    
}
