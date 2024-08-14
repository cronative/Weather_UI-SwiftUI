//
//  CurrentWeatherInfoScrollView.swift
//  Weather_UI
//
//  Created by Nikunj on 13/05/24.
//

import SwiftUI

struct CurrentWeatherInfoScrollView: View {
    
    // MARK: - Variables
    @Bindable var mainViewModel: MainViewModel
    
    let width: CGFloat = UIScreen.main.bounds.width
    
    // MARK: - Views
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(Array(zip(mainViewModel.allWeatherInfo.indices, mainViewModel.allWeatherInfo)), id: \.1.id) { (ix, weatherInfo) in
                        CurrentWeatherInfo(climateInfo: weatherInfo.climateInfo, weatherInfo: weatherInfo.weather)
                            .frame(width: width)
                            .id(ix)
                            .animation(.smooth, value: mainViewModel.currentPage)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .automatic))
            .scrollPosition(id: $mainViewModel.currentPage)
//            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    CurrentWeatherInfoScrollView(mainViewModel: MainViewModel(forTest: true))
}
