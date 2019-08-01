//
//  AddNewTrackViewModel.swift
//  NPCustomClient
//
//  Created by Denis Markov on 7/30/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit
import Foundation

class AddNewTrackViewModel: NSObject {
    
    var trackList: [String] = [] {
        didSet {
            self.trackListChanged?()
        }
    }
    
    var trackListChanged: (() -> ())? = nil
    
    var setSanitizeText: (() -> ())? = nil
    
    var setTrackInvalid: ((Bool) -> ())? = nil
    
    var backToPreviousScreen: (() -> ())? = nil
    
    var showLoading: ((Bool) -> ())? = nil
    
    var tracksStatus: [String: String] = [:]
    
    func processUserInput(text: String?) {
        guard let track = text else { return }
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: track)) {
            if  track.count == trackLength {
                ckeckIsValidTrack(track: track)
            } else {
                self.setTrackInvalid?(true)
            }
        } else {
            self.setSanitizeText?()
        }
    }
    
    func ckeckIsValidTrack(track: String)  {
        showLoading?(false)
        RestAPI.shared.getTrackInfo(documents: [track], callback: { (isOk, trackInfo) in
            self.showLoading?(true)
            if isOk, let success = trackInfo?.success, success, trackInfo?.data?.count ?? 0 > 0, let dateCreated = trackInfo?.data?[0].dateCreated, !dateCreated.isEmpty {
                debugPrint("is valid track")
                if let status = trackInfo?.data?[0].status {
                    self.updateTrackStatus(track: track, status: status)
                }
                if !self.trackList.contains(track) {
                    self.trackList.append(track)
                } else {
                    self.trackListChanged?()
                }
            } else {
                self.setTrackInvalid?(false)
            }
        })
    }
    
    func updateTrackStatus(track: String, status: String) {
        if let previousStatus = userDefaults?.string(forKey: track), previousStatus != status {
            LocalNotification.push(title: track, description: status, identifier: track)
        }
        userDefaults?.set(status, forKey: track)
    }
    
    func sanitizeText(sourceText: String?) -> String? {
        guard let text = sourceText else { return nil }
        return text.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    }
    
    func dataForCell(indexPath: IndexPath) -> String? {
        let index = indexPath.row
        if index < trackList.count {
            return trackList[index]
        }
        return nil
    }
    
    func removeFromList(track: String) {
        if trackList.contains(track), let index = trackList.firstIndex(of: track), index < trackList.count {
            trackList.remove(at: index)
        }
    }
    
    func clearAll() {
        trackList = []
    }
    
    func addTracksToTrackingList() {
        var allTracks: [String] = trackList
        if let previousTracks = userDefaults?.array(forKey: defaultsTracksKey) as? [String] {
            allTracks = previousTracks
            for track in trackList {
                if !allTracks.contains(track) {
                    allTracks.append(track)
                    Log.logNewTrack(track)
                }
            }
        }
        userDefaults?.set(allTracks, forKey: defaultsTracksKey)
        userDefaults?.synchronize()
        self.backToPreviousScreen?()
    }
    
    
}
