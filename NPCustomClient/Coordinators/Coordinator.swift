//
//  Coordinator.swift
//  NPCustomClient
//
//  Created by Denis Markov on 8/1/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation

class Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter { $0 is T  == false }
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }
    
}

extension Coordinator: Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
