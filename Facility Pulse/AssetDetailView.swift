//
//  AssetDetailView.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/17/23.
//

import SwiftUI

struct AssetDetailView: View {
    let asset: Asset
    
    var body: some View {
        // You can create a detailed view for each asset here if needed
        // For now, let's just display the asset's ID
        Text("Asset ID: \(asset.assetID)")
            .navigationBarTitle("Asset Detail")
    }
}

//struct AssetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        AssetDetailView()
//    }
//}
