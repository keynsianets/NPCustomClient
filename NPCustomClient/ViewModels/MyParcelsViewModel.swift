//
//  MyParcelsViewModel.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/31/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import Foundation
import UIKit

class MyParcelsViewModel: NSObject {
    
    var trackList: [TrackInfo] = [] {
        didSet {
            self.trackListChanged?()
            self.showNoDataLabel?(trackList.count > 0)
        }
    }
    
    var trackListChanged: (() -> ())? = nil
    
    var showNoDataLabel: ((Bool) -> ())? = nil
    
    var showLoading: ((Bool) -> ())? = nil
    
    func dataForCell(indexPath: IndexPath) -> TrackInfo? {
        let index = indexPath.row
        if index < trackList.count {
            return trackList[index]
        }
        return nil
    }
    
    func loadData() {
        showLoading?(false)
        if let tracks = userDefaults?.array(forKey: defaultsTracksKey) as? [String], tracks.count > 0 {
            RestAPI.shared.getTrackInfo(documents: tracks) { (isOk, response) in
                self.showLoading?(true)
                if isOk, let success = response?.success, success, let data = response?.data, data.count > 0 {
                    var tracks: [TrackInfo] = []
                    for track in data {
                        if let _ = track.scheduledDeliveryDate, !tracks.contains(where: { (previous) -> Bool in
                            guard let number = track.number else { return true }
                            return previous.number == number
                        }) {
                            tracks.append(track)
                            if let status = track.status, let number = track.number {
                                self.updateTrackStatus(track: number, status: status)
                            }
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
                    self.showLoading?(true)
                }
            }
        } else {
            self.showLoading?(true)
            showNoDataLabel?(false)
        }
    }
    
    func updateTrackStatus(track: String, status: String) {
        if let previousStatus = userDefaults?.string(forKey: track), previousStatus != status {
            LocalNotification.push(title: track, description: status, identifier: track)
        }
        userDefaults?.set(status, forKey: track)
    }
    
    
}
