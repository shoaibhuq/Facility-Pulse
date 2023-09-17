//
//  DashboardView.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/16/23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            Text("YOO")
            CriticalItemsView()
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct CriticalItemsView: View {
    var body: some View {
        VStack {
            CriticalItemCardView()
        }
    }
}

struct CriticalItemCardView: View {
    let assetName: String = "AC01"
    let location: String = "Building A.120"
    var expectedFailureDate: Date = Date.now.addingTimeInterval(500000)
    var body: some View {
        ZStack {
            Color.init(red: 69/256, green: 69/256, blue: 69/256)
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
                    Text(location)
                        .font(.footnote)
                }
                .frame(alignment: .leading)
                
                
                /// DATE EXPECTED TO FAIL
                Text(RelativeDateTimeFormatter()
                    .localizedString(for: expectedFailureDate,
                                     relativeTo: .now)
                )
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
        }
//        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 72)
        .padding(.horizontal, 12)
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
