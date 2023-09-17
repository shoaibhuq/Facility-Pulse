//
//  AssetDetailView.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/17/23.
//

import SwiftUI

struct AssetDetailView: View {
    let asset: Asset //= AssetManager.assets.first!
    
    var body: some View {
        // You can create a detailed view for each asset here if needed
        // For now, let's just display the asset's ID
        VStack(alignment: .center) {
            Image(systemName: "faxmachine")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(dangerColor)
            
            Text("Asset name: \(asset.assetName)")
                .font(.title.bold())
                .navigationBarTitle("Asset Detail")
                .padding(.vertical)
            VStack {
                Text("Next Expected Failure Date:")
                    .font(.title3.bold())
                Text("\(asset.expectedFailureDate)")
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 8)
    }
    var dangerColor: Color {
        let days = asset.expectedFailureDate.timeIntervalSince(.now) / 86400
        if days < 5 {
            return .red
        } else if days < 15 {
            return .yellow
        } else {
            return .green
        }
    }
}

struct AssetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssetDetailView(asset: AssetManager.assets.first!)
    }
}
