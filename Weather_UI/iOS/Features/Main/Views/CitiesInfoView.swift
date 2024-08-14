//
//  CitiesInfoView.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//

import SwiftUI

struct CitiesInfoView: View {
    
    // MARK: - Variables
    @Bindable var mainViewModel: MainViewModel
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        if(!mainViewModel.searchOpened) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 1)) {
                                mainViewModel.searchOpened.toggle()
                            }
                        }
                    } label: {
                        SearchBarView(expandSearchbar: $mainViewModel.searchOpened, searchText: $mainViewModel.searchedQuery)
                    }
                    .offset(x: mainViewModel.searchOpened ? 0 : 42)
                    .animation(.spring(), value: mainViewModel.searchOpened)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width - 48)
                }
                .padding(.top, 32)
                Spacer()
                
                VStack {
                    ForEach(Array(zip(mainViewModel.allWeatherInfo.indices, mainViewModel.allWeatherInfo)), id: \.1.id) { ix, weatherInfo in
                        HStack {
                            Text("\(weatherInfo.cityName)")
                                .font(Montserrat.bold.font(size: 38))
                            
                            Spacer()
                            
                            Text("\(weatherInfo.climateInfo.temperature.clean(places: 1))")
                                .font(Avenir.bold.font(size: 42))
                                .opacity(0.9)
                                .padding(.top, 2)
                        }
                        .onTapGesture {
                            withAnimation(.snappy) {
                                self.mainViewModel.currentPage = ix
                            }
                        }
                        .opacity(mainViewModel.currentPage ?? 0 == ix ? 1 : 0.5)
                        .padding(.vertical, 12)
                    }
                }
                .opacity(mainViewModel.searchOpened ? 0 : 1)
                .animation(.snappy, value: mainViewModel.searchOpened)
                .padding(.bottom, 112)
            }
            
            
            VStack(spacing: 44) {
                ForEach(mainViewModel.searchedCities, id: \.self.city) { city in
                    HStack {
                        Text("\(city.city)")
                            .font(Montserrat.bold.font(size: 26))
                        
                        Spacer()
                        
                        Text(city.countryCode)
                            .font(Montserrat.semibold.font(size: 12))
                            .textCase(.uppercase)
                    }
                }
            }
            .padding(.top, 172)
            .opacity(mainViewModel.searchedState == .searched ? 1 : 0)
            .animation(.snappy, value: mainViewModel.searchedState)
            
            GeometryReader { proxy in
                let width: CGFloat = proxy.size.width
                let height: CGFloat = proxy.size.height

                TriangleLoader()
                    .frame(width: width, height: height, alignment: .center)
                    .scaleEffect(0.7)
                    .opacity(mainViewModel.searchedState == .searching ? 1 : 0)
                    .animation(.smooth, value: mainViewModel.searchedState)
            }
            
        }
        .environment(mainViewModel)
    }
}

#Preview {
    CitiesInfoView(mainViewModel: MainViewModel(forTest: true))
        .padding(24)
}
