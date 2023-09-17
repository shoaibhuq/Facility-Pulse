//
//  DashboardView.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/16/23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("YOO")
            CriticalItemsView()
        }
    }
}

struct CriticalItemsView: View {
    let assets: [Asset] = Array(AssetManager.assets[...3])
    var body: some View {
        VStack(spacing: 0) {
            List(assets) { asset in
                CriticalItemCardView(
                    assetName: asset.assetName,
                    location: asset.location,
                    expectedFailureDate: expectedFailureDate()
                )
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
        }
        .frame(maxHeight: .infinity, alignment: .top)
//        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    func expectedFailureDate() -> Date {
        let timeToAdd: Int = .random(in: 200000...2000000)
        return Date.now.addingTimeInterval(Double(timeToAdd))
    }
}

struct CriticalItemCardView: View {
    let assetName: String
    let location: String
    var expectedFailureDate: Date = Date.now.addingTimeInterval(500000)
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
                    Text(assetName)
                        .font(.title2.bold())
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(location)
                        .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 8)
                
                
                /// DATE EXPECTED TO FAIL
                Text(RelativeDateTimeFormatter()
                    .localizedString(for: expectedFailureDate,
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
        let days = expectedFailureDate.timeIntervalSince(.now) / 86400
        if days < 6 {
            return .red
        } else if days < 15 {
            return .yellow
        } else {
            return .green
        }
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
