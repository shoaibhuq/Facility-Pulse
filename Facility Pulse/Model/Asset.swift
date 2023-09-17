//
//  Asset.swift
//  Facility Pulse
//
//  Created by Shoaib Huq on 9/16/23.
//

import Foundation

struct Asset: Identifiable, Codable {
    let id = UUID()
    let assetID: Int
    let assetType: String
    let floor: Int
    let room: Int
    let installationDate: String
    let manufacturer: String
    let operationalTime: Int
    let repairs: Int
    let winter: Int
    let summer: Int
    let fall: Int
    let spring: Int
    
    var expectedFailureDate: Date = Date.now.addingTimeInterval(Double.random(in: 200000...4000000))
    var workOrderPlaced: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case assetID = "Asset ID"
        case assetType = "Asset Type"
        case floor = "Floor"
        case room = "Room"
        case installationDate = "Installation Date"
        case manufacturer = "Manufacturer"
        case operationalTime = "Operational Time (hrs)"
        case repairs = "Repairs"
        case winter = "Winter"
        case summer = "Summer"
        case fall = "Fall"
        case spring = "Spring"
    }
    
    var assetName: String {
        "\(self.assetType)-\(self.assetID)"
    }
    
    var location: String {
        "Room \(self.floor).\(self.room)"
    }

}




