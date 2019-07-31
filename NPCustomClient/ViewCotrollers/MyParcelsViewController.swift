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
            screenTitleLabel.text = "Мои отправления"
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButton: RoundButtonWithShadow! {
        didSet {
            plusButton.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
        }
    }
    
    let viewModel = MyParcelsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 153
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.isNavigationBarHidden = true
        viewModel.loadData()
        viewModel.trackListChanged = { [weak self] () in
            self?.tableView.reloadData()
        }
    }
    
    @objc func plusButtonDidTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let plusViewController = storyboard.instantiateViewController(withIdentifier: "AddNewTrackViewController") as! AddNewTrackViewController
        plusViewController.delegate = self
        self.navigationController?.pushViewController(plusViewController, animated: true)
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

extension MyParcelsViewController: AddNewTrackViewControllerDelegate {
    func newTracksAppend() {
        viewModel.loadData()
    }
}

