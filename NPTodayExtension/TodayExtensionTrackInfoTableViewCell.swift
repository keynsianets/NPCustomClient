//
//  TrackInfoTableViewCell.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/31/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit

class TodayExtensionTrackInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var sendDateLabel: UILabel!
    @IBOutlet weak var arrivedDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var startPointView: UIView! {
        didSet {
            startPointView.layer.cornerRadius = startPointView.frame.height / 2
            startPointView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var endPointView: UIView! {
        didSet {
            endPointView.layer.cornerRadius = endPointView.frame.height / 2
            endPointView.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(trackInfo: TrackInfo?) {
        guard let trackInfo = trackInfo else { return }
        trackLabel.text = trackInfo.number
        sendDateLabel.text = CustomDateFormatter.dateString(source: trackInfo.dateCreated, sourceFormat: dateCreatedDateFormat, targetFormat: defaultDateFormat)
        if let firstReceiveDate = trackInfo.recipientDateTime, !firstReceiveDate.isEmpty {
            arrivedDateLabel.text = CustomDateFormatter.dateString(source: firstReceiveDate, sourceFormat: dateRecipientDateTime, targetFormat: defaultDateFormat)
        } else {
            arrivedDateLabel.text = CustomDateFormatter.dateString(source: trackInfo.scheduledDeliveryDate, sourceFormat: dateScheduledDeliveryDate, targetFormat: defaultDateFormat)
        }
        statusLabel.text = trackInfo.status
        
    }
    
    
    
}
