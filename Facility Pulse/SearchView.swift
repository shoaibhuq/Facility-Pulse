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

    var assets: [Asset] 
    
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
                asset.assetName.localizedCaseInsensitiveContains(searchText)
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
                    
                }
                
                List(filteredAssets) { asset in
                    NavigationLink(destination: AssetDetailView(asset: asset)) {
                        AssetCell(asset: asset)
                    }
                }
                .navigationBarTitle("Asset List")
                .listStyle(.plain)
            }
        }
    }
}

struct AssetCell: View {
    let asset: Asset
    
    var body: some View {
        ZStack {
            Color.darkGray
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            HStack {
                /// ICON
                ZStack {
                    dangerColor.opacity(0.8)
                        .clipShape(Circle())
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .bold()
                        .padding(8)
                }
                .frame(width: 40)
                
                
                /// ASSET NAME AND LOCATION
                VStack(alignment: .leading) {
                    Text(asset.assetName)
                        .font(.title2.bold())
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(asset.location)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
                
                
                /// DATE EXPECTED TO FAIL
                Text(RelativeDateTimeFormatter()
                    .localizedString(for: asset.expectedFailureDate,
                                     relativeTo: .now)
                )
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
        .frame(height: 72)
//        .padding(.horizontal, 12)
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

