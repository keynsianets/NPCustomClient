//
//  TodayViewController.swift
//  NPTodayExtension
//
//  Created by Denis Markov on 17.07.2019.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit
import NotificationCenter

fileprivate let cellIdentifier = "TodayExtensionTrackInfoTableViewCell"

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = MyParcelsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        tableView.dataSource = self
        tableView.rowHeight = extensionRowHeight
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets.zero
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        viewModel.loadData()
        viewModel.trackListChanged = { [weak self] () in
            self?.tableView.reloadData()
        }
        viewModel.showLoading = { [weak self] (hide) in
            self?.activityIndicator.isHidden = hide
            hide ? self?.activityIndicator.stopAnimating() : self?.activityIndicator.startAnimating()
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        viewModel.loadData()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: preferedHeightForExtension)
        } else {
            preferredContentSize = maxSize
        }
    }
    
}

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TodayExtensionTrackInfoTableViewCell
        cell.setData(trackInfo: viewModel.dataForCell(indexPath: indexPath))
        return cell
    }
    
}
