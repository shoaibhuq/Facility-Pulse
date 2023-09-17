//
//  AssetViewModel.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/17/23.
//

import Foundation

class AssetViewModel: ObservableObject {
    @Published var assets: [Asset] = Array(AssetManager.assets.sorted(by: {$0.expectedFailureDate < $1.expectedFailureDate}))
    
    func isRed(_ asset: Asset) -> Bool {
        return asset.expectedFailureDate.timeIntervalSince(.now) / 86400 < 5
    }
    
    func isYellow(_ asset: Asset) -> Bool {
        return !isRed(asset) && asset.expectedFailureDate.timeIntervalSince(.now) / 86400 < 15
    }
    
    func isGreen(_ asset: Asset) -> Bool {
        return !isRed(asset) && !isYellow(asset)
    }
    
    var countRed: Int {
        assets.filter({ isRed($0) }).count
    }
    
    var countYellow: Int {
        assets.filter({$0.expectedFailureDate.timeIntervalSince(.now) / 86400 < 15}).count - countRed
    }
    
    var countGreen: Int {
        assets.count - countRed - countYellow
    }
    
    func placeRedOrder() {
        assets = assets.map {
            var newAsset = $0
            if isRed($0) {
                newAsset.expectedFailureDate = $0.expectedFailureDate.addingTimeInterval(86400 * 100)
            }
            return newAsset
        }
        assets = assets.sorted(by: {$0.expectedFailureDate < $1.expectedFailureDate})
    }
    
    func placeYellowOrder() {
        assets = assets.map {
            var newAsset = $0
            if isYellow($0) {
                newAsset.expectedFailureDate = $0.expectedFailureDate.addingTimeInterval(86400 * 100)
            }
            return newAsset
        }
        assets = assets.sorted(by: {$0.expectedFailureDate < $1.expectedFailureDate})
    }
}
