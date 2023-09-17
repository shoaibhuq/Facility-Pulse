//
//  AssetManager.swift
//  Facility Pulse
//
//  Created by Shoaib Huq on 9/16/23.
//

import Foundation

struct AssetManager {
    static var assets = readJson(forName: "assets")!
    static func readJson(forName fileName: String) -> [Asset]? {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let decodedData = try JSONDecoder().decode([Asset].self,
                                                           from: jsonData)
                return decodedData
            }
        } catch {
            print(error)
        }
        return nil
    }
}
