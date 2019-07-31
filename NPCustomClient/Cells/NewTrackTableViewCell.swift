//
//  NewTrackTableViewCell.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/30/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

protocol NewTrackTableViewCellDelegate {
    func removeButtonDidTap(track:String)
}

class NewTrackTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton! {
        didSet {
            removeButton.addTarget(self, action: #selector(removeButtonDidTap), for: .touchUpInside)
        }
    }
    
    var track: String?
    var delegate: NewTrackTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(track: String?) {
        trackLabel.text = track
        self.track = track
    }
    
    @objc func removeButtonDidTap() {
        guard let track = track else { return }
        delegate?.removeButtonDidTap(track: track)
    }
    
}



