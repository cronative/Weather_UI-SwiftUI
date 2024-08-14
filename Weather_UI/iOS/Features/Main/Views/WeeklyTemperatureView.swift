//
//  WeeklyTemperatureView.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//

import SwiftUI

struct WeeklyTemperatureView: View {
    
    // MARK: - Variables
    @Environment(MainViewModel.self) var mainViewModel
    
    var backAction: () -> () = {}
    
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            VStack(alignment: .leading) {                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 52) {
                        ForEach(mainViewModel.weeklyTemperature) { temperature in
                            VStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ViewBuilders.GenerateTemperatureView(temperature: temperature.temperature, isCurrent: true)
                                        ViewBuilders.GenerateTemperatureView(temperature: temperature.minimumTemperature, isCurrent: false)
                                        ViewBuilders.GenerateTemperatureView(temperature: temperature.maximumTemperature, isCurrent: false)
                                    }
                                    .padding(.leading, UIScreen.main.bounds.width * 0.2)

                                }
                                
                                HStack {
                                    Spacer()
                                    Text(temperature.currentDescription)
                                        .font(Montserrat.semibold.font(size: 14))
                                        .textCase(.uppercase)
                                        .tracking(1.25)
                                    Spacer()
                                }
                                .padding(.trailing, UIScreen.main.bounds.width * 0.05)
                            }
                            .overlay {
                                HStack {
                                    Text(temperature.weekday)
                                        .font(Montserrat.semibold.font(size: 13))
                                        .textCase(.uppercase)
                                        .opacity(0.5)
                                        .tracking(1.25)
                                        .rotationEffect(.degrees(-90))
                                        .offset(x: -UIScreen.main.bounds.width / 2 + 32)
                                    
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 100)
                }
                .safeAreaPadding(.top, 42)
                .padding(.trailing, -24)
            }
            .padding(.vertical, 12)
            .padding(.top, 44)
            .padding([.horizontal], 24)
            .edgesIgnoringSafeArea(.bottom)
            
        }
        .environment(mainViewModel)
    }
}

#Preview {
    WeeklyTemperatureView()
        .environment(MainViewModel(forTest: true))
}
