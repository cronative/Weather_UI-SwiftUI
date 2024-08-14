//
//  ViewBuilders.swift
//  Weather_UI
//
//  Created by Nikunj on 14/05/24.
//

import SwiftUI

struct ViewBuilders {
    @ViewBuilder
    static func GenerateTemperatureView(temperature: Double, isCurrent: Bool = false) -> some View {
        HStack {
            Spacer()
            
            Text("\(temperature.clean(places: 1))")
                .font(Avenir.black.font(size: 92))
                .if(!isCurrent) { view in
                    view
                        .opacity(0.45)
                }
            Spacer()

        }
    }
    
    @ViewBuilder
    static func GenerateTemperatureLabelView(temperatureLabel: String) -> some View {
        HStack {
            Text(temperatureLabel)
                .font(Montserrat.semibold.font(size: 13))
                .textCase(.uppercase)
                .rotationEffect(.degrees(-90))
                .padding(.leading, 12)
            
            Spacer()
        }
    }
}
