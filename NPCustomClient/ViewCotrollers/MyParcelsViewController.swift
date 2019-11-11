//
//  ViewController.swift
//  NPCustomClient
//
//  Created by Denis Markov on 17.07.2019.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

fileprivate let cellIdentifier = "TrackInfoTableViewCell"

class MyParcelsViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var screenTitleLabel: UILabel! {
        didSet {
            screenTitleLabel.text = Strings.myParcels.localized()
        }
    }
    @IBOutlet weak var noDataLabel: UILabel! {
        didSet {
            noDataLabel.text = Strings.noData.localized()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: RoundButtonWithShadow! {
        didSet {
            plusButton.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let viewModel = MyParcelsViewModel()
    
    var openAddNewTrack: (() -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = mainAppRowHeight
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.allowsSelection = false
        self.navigationController?.isNavigationBarHidden = true
        viewModel.trackListChanged = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.showNoDataLabel = { [weak self] (hide) in
            DispatchQueue.main.async {
                self?.noDataLabel.isHidden = hide
            }
        }
        viewModel.showLoading = { [weak self] (hide) in
            DispatchQueue.main.async {
                debugPrint("activiti indicator hidden", hide)
                self?.activityIndicator.isHidden = hide
                hide ? self?.activityIndicator.stopAnimating() : self?.activityIndicator.startAnimating()
            }
        }
        viewModel.loadData()
    }
    
    @objc func plusButtonDidTap() {
        openAddNewTrack?()
    }
}

extension MyParcelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TrackInfoTableViewCell
        cell.setData(trackInfo: viewModel.dataForCell(indexPath: indexPath))
        return cell
    }
    
}



