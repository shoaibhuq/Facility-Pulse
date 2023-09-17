//
//  SearchView.swift
//  Facility Pulse
//
//  Created by Shoaib Huq on 9/16/23.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    @State private var selectedFilter = "All"

    var assets: [Asset] = AssetManager.assets
    
    var filteredAssets: [Asset] {
        if searchText.isEmpty && selectedFilter == "All" {
            return assets
        } else if selectedFilter == "All" {
            return assets.filter { asset in
                asset.assetType.localizedCaseInsensitiveContains(searchText)
            }
        } else if searchText.isEmpty {
            return assets.filter { asset in
                asset.assetType == selectedFilter
            }
        } else {
            return assets.filter { asset in
                asset.assetType == selectedFilter &&
                asset.assetType.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search by Asset Type", text: $searchText)
                        .padding()
                    
                    Picker("Filter by Asset Type", selection: $selectedFilter) {
                        Text("Filter").tag("All")
                        ForEach(Array(Set(assets.map { $0.assetType })).sorted(), id: \.self) { assetType in
                            if assetType == "Plumbing System" {
                                Text("Plumbing").tag(assetType)
                            } else {
                                Text(assetType).tag(assetType)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                    
                    
                    .padding()
                }
                
                List(filteredAssets) { asset in
                    NavigationLink(destination: AssetDetail(asset: asset)) {
                        AssetCell(asset: asset)
                    }
                }
                .navigationBarTitle("Asset List")
            }
        }
    }
}

struct AssetDetail: View {
    let asset: Asset
    
    var body: some View {
        // You can create a detailed view for each asset here if needed
        // For now, let's just display the asset's ID
        Text("Asset ID: \(asset.assetID)")
            .navigationBarTitle("Asset Detail")
    }
}

struct AssetCell: View {
    let asset: Asset
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Asset ID: \(asset.assetID)")
                .font(.headline)
            Text("Asset Type: \(asset.assetType)")
                .font(.subheadline)
            Text("Manufacturer: \(asset.manufacturer)")
                .font(.subheadline)
        }
    }
}




struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
