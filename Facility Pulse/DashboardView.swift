//
//  DashboardView.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/16/23.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var assetVM = AssetViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    SummaryView(assetVM: assetVM,
                                redCount: assetVM.countRed,
                                yellowCount: assetVM.countYellow,
                                greenCount: assetVM.countGreen)
                    CriticalItemsView(assets: assetVM.assets)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SummaryView: View {
    @ObservedObject var assetVM: AssetViewModel
    var redCount: Int
    var yellowCount: Int
    var greenCount: Int
    let list = ["Building A", "Building B"]
    @State private var selection = "Building A"
    
    @State private var showRedAlert: Bool = false
    @State private var showYellowAlert: Bool = false
    var body: some View {
        VStack {
            PieChartView(slices: [
                (Double(redCount), .redChart),
                (Double(yellowCount), .yellowChart),
                (Double(greenCount), .greenChart)
            ])
            
            HStack {
                Button {
                    showRedAlert.toggle()
                } label: {
                    redSum
                }
                
                VStack(spacing: 8) {
                    yellowSum
                    
                    greenSum
                }
            }
            .frame(height: 180)
            .padding()
            
            
        }
        .onChange(of: selection) { _ in
            assetVM.assets = AssetManager.readJson(forName: "assets")!.sorted(by: {$0.expectedFailureDate < $1.expectedFailureDate})
        }
        .alert("Do you want to place work order for all critcal alert?",
               isPresented: $showRedAlert) {
            Button("OK", role: .destructive) {
                assetVM.placeRedOrder()
            }
            Button("Cancel", role: .cancel) { }
        }
               .toolbar {
                   ToolbarItem(placement: .navigationBarTrailing) {
                       Picker("Building", selection: $selection) {
                           ForEach(list, id:\.self) {
                               Text($0)
                           }
                       }
                       .pickerStyle(.menu)
                   }
               }
        .padding()
    }
    
    private var redSum: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.redChart)
            .overlay {
                VStack(spacing: 0) {
                    Image(systemName: "exclamationmark.transmission")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(6)
                    
                    Text("\(Int(redCount))")
                        .font(.title.bold())
                    
                    Text("critical")
                        .font(.title.bold())
                }
                .padding(4)
                .foregroundColor(.black)
            }
    }
    
    
    private var greenSum: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.greenChart)
            .overlay {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(6)
                    
                    VStack {
                        Text("\(Int(greenCount))")
                        Text("working")
                        
                    }
                    .layoutPriority(1)
                    .font(.title3.bold())
                }
                .padding(4)
                .foregroundColor(.black)
            }
    }
    
    private var yellowSum: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.yellowChart)
            .overlay {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(6)
                    
                    VStack {
                        Text("\(Int(yellowCount))")
                        Text("warnings")
                        
                    }
                    .layoutPriority(1)
                    .font(.title3.bold())
                }
                .padding(4)
                .foregroundColor(.black)
            }
    }
}


/// Credit to : Chan_ https://medium.com/@iOSchandra0/how-to-create-a-pie-chart-in-swiftui-c7f056d54c81
struct PieChartView: View {
    let slices: [(Double, Color)]
    
    var body: some View {
         Canvas { context, size in
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct CriticalItemsView: View {
    let assets: [Asset] 
    var body: some View {
        VStack {
            ForEach(assets) { asset in
                NavigationLink(destination: AssetDetailView(asset: asset)) {
                    CriticalItemCardView(
                        assetName: asset.assetName,
                        location: asset.location,
                        expectedFailureDate: asset.expectedFailureDate
                    )
                }
                .buttonStyle(.plain)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .frame(maxHeight: .infinity, alignment: .top)
        }
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
        .frame(height: 84)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
    
    var dangerColor: Color {
        let days = expectedFailureDate.timeIntervalSince(.now) / 86400
        if days < 5 {
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
