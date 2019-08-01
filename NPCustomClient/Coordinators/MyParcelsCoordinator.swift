//
//  MyParcelsCoordinator.swift
//  NPCustomClient
//
//  Created by Denis Markov on 8/1/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

class MyParcelsCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    var myParcelsVC: MyParcelsViewController
    
    override func start() {
        myParcelsVC.openAddNewTrack = { [weak self] in
            self?.openAddNewTrack()
        }
        rootViewController.setViewControllers([myParcelsVC], animated: false)
    }
    
    override func finish() {
        
    }
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        myParcelsVC = storyboard.instantiateViewController(withIdentifier: "MyParcelsViewController") as! MyParcelsViewController
    }
    
    func openAddNewTrack() {
        let addNewTrack = AddNewTrackCoordinator(rootViewController: rootViewController)
        addNewTrack.delegate = self
        addChildCoordinator(addNewTrack)
        addNewTrack.start()
    }
    
    
}

extension MyParcelsCoordinator: AddNewTrackViewControllerDelegate {
    func newTracksAppend() {
        myParcelsVC.viewModel.loadData()
    }
}
