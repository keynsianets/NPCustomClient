//
//  MyParcelsViewModel.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/31/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation
import UIKit

class MyParcelsViewTodaysModel: NSObject {
    
    var trackList: [TrackInfo] = [] {
        didSet {
            self.trackListChanged?()
        }
    }
    
    var trackListChanged: (() -> ())? = nil
    
    func dataForCell(indexPath: IndexPath) -> TrackInfo? {
        let index = indexPath.row
        if index < trackList.count {
            return trackList[index]
        }
        return nil
    }
    
    func loadData() {
        if let tracks = UserDefaults(suiteName: "group.kinect.pro.npcustomclient")?.array(forKey: defaultsTracksKey) as? [String] {
            RestAPI.shared.getTrackInfo(documents: tracks) { (isOk, response) in
                if isOk, let success = response?.success, success, let data = response?.data, data.count > 0 {
                    var tracks: [TrackInfo] = []
                    for track in data {
                        if let _ = track.scheduledDeliveryDate, !tracks.contains(where: { (previous) -> Bool in
                            guard let number = track.number else { return true }
                            return previous.number == number
                        }) {
                            tracks.append(track)
                        }
                    }
                    self.trackList = tracks.sorted(by: {(first, second) in
                        var firstDate = Date()
                        var secondDate = Date()
                        if let firstReceiveDate = first.recipientDateTime, !firstReceiveDate.isEmpty {
                            firstDate = CustomDateFormatter.date(source: firstReceiveDate, sourceFormat: dateRecipientDateTime, targetFormat: defaultDateFormat)
                        } else {
                            if let firstScheduleDate = first.scheduledDeliveryDate {
                                firstDate = CustomDateFormatter.date(source: firstScheduleDate, sourceFormat: dateScheduledDeliveryDate, targetFormat: defaultDateFormat)
                            }
                        }
                        if let secondReceiveDate = second.recipientDateTime, !secondReceiveDate.isEmpty {
                            secondDate = CustomDateFormatter.date(source: secondReceiveDate, sourceFormat: dateRecipientDateTime, targetFormat: defaultDateFormat)
                        } else {
                            if let secondScheduleDate = second.scheduledDeliveryDate {
                                secondDate = CustomDateFormatter.date(source: secondScheduleDate, sourceFormat: dateScheduledDeliveryDate, targetFormat: defaultDateFormat)
                            }
                        }
                        return firstDate > secondDate
                    })
                }
            }
        }
    }
    
    
}
