//
//  ContentView.swift
//  Facility Pulse
//
//  Created by Shoaib Huq on 9/16/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var assetVM = AssetViewModel()
    var body: some View {
        TabView {
            DashboardView(assetVM: assetVM)
                .badge(assetVM.countRed)
                .tabItem {
                    Label("Dashboard", systemImage: "list.bullet.clipboard.fill")
                }
            SearchView(assets: assetVM.assets)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
