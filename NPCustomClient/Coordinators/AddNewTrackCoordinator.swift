//
//  AddNewTrackCoordinator.swift
//  NPCustomClient
//
//  Created by Denis Markov on 8/1/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

class AddNewTrackCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var delegate: AddNewTrackViewControllerDelegate?
    let currentVC: AddNewTrackViewController
    
    override func start() {
        currentVC.finish = { [weak self] in
            self?.finish()
        }
        rootViewController.pushViewController(currentVC, animated: true) //setViewControllers([currentVC], animated: true)
    }
    
    override func finish() {
        if currentVC.viewModel.trackList.count > 0 {
            delegate?.newTracksAppend()
        }
        self.rootViewController.popViewController(animated: true)
    }
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        currentVC = storyboard.instantiateViewController(withIdentifier: "AddNewTrackViewController") as! AddNewTrackViewController
    }
    
    
    
}

