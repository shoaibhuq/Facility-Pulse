//
//  SummaryView.swift
//  Facility Pulse
//
//  Created by Khang Nguyen on 9/17/23.
//

import SwiftUI

struct WidgetSummaryView: View {
    var redCount: Int
    var yellowCount: Int
    var greenCount: Int
    
    var body: some View {
        VStack {
            PieView(slices: [
                (Double(redCount), .redChart),
                (Double(yellowCount), .yellowChart),
                (Double(greenCount), .greenChart)
            ])
            
            HStack {
                redSum
                
                VStack(spacing: 8) {
                    yellowSum
                    
                    greenSum
                }
            }
//            .frame(height: 180)
            .padding()
            
            
        }
        .padding(.top, 8)
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

struct PieView: View {
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

