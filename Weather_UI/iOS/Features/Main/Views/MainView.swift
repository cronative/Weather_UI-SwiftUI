//
//  ContentView.swift
//  Weather_UI
//
//  Created by Nikunj on 12/05/24.
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Variables
    @State var mainViewModel: MainViewModel
    
    @State var currentOffset: CGFloat = 0
    
    let dragOffset: CGFloat = 24
    let offsetLimit: CGFloat = -70
    let segmentPadding: CGFloat = 72
    
    let segmentOffsetLimit: CGFloat = -150
    
    @State var scrollViewProxy: ScrollViewProxy?
    
    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            let width: CGFloat = proxy.size.width
            let height: CGFloat = proxy.size.height
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                Color.background
                    .ignoresSafeArea()
                
                ScrollViewReader { scrollView in
                    CustomScrollView(axes: .vertical, showsIndicators: false, offsetChanged: { offset in
                        computeScrollOffsets(offset: offset, height: height, scrollView: scrollView)
                    }) {
                        VStack(alignment: .leading) {
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    SegmentedView()
                                    Spacer()
                                }
                                .padding(.top, segmentPadding)
                                .opacity(currentScale - (temperatureScale * 100))
                                .animation(.smooth, value: temperatureScale)
                                .opacity(currentOffset < segmentOffsetLimit ? 0 : 1)
                                .animation(.default, value: currentOffset)
                                
                                
                                CurrentWeatherInfoScrollView(mainViewModel: mainViewModel)
                                    .scaleEffect(currentScale - temperatureScale)
                                    .opacity(currentScale - (temperatureScale * 12.5))
                                    .animation(.smooth, value: temperatureScale)
                                    .padding(.horizontal, -24)
                                    .padding(.top, segmentPadding - 20)
                                
                                HStack {
                                    Spacer()
                                    
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 20, weight: .semibold))
                                        .tint(.label)
                                        .frame(width: 44, height: 44, alignment: .center)
                                        .onTapGesture {
                                            withAnimation(.smooth(duration: 0.75)) {
                                                scrollView.scrollTo(1, anchor: .center)
                                            }
                                        }
                                    Spacer()
                                }
                                .offset(y: 44)
                                .opacity(currentOffset < -150 ? 0 : 1)
                                .animation(.default, value: currentOffset)
                            }
                            .padding(.vertical, 12)
                            .padding([.bottom, .horizontal], 24)
                            .overlay(alignment: .leading) {
                                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.14) {
                                    ViewBuilders.GenerateTemperatureLabelView(temperatureLabel: "High")
                                    ViewBuilders.GenerateTemperatureLabelView(temperatureLabel: "Now")
                                    ViewBuilders.GenerateTemperatureLabelView(temperatureLabel: "Low")
                                    Spacer()
                                }
                                .offset(x: 4)
                                .fixedSize()
                                .offset(y: UIScreen.main.bounds.height * 0.0575)
                                .background {
                                    Color.background
                                        .padding(.top, -24)
                                }
                                .opacity(currentScale - (temperatureScale * 20))
                            }
                            .id(0)
                            
                            WeeklyTemperatureView()
                                .opacity(0 + (temperatureScale * 15))
                                .frame(width: width, height: height)
                                .id(1)
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                }
                .offset(x: !showOptions ? 0 : width)
                .animation(.snappy(duration: 0.5), value: showOptions)
                .overlay(alignment: .top) {
                    ZStack {
                        HStack {
                            if showOptions {
                                Button {
                                    showOptions = false
                                    
                                    withAnimation(.smooth) {
                                        self.scrollViewProxy?.scrollTo(0, anchor: .center)
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 26, weight: .medium))
                                }
                                .tint(.label)
                                .frame(width: 44, height: 44)
                                .opacity(mainViewModel.searchOpened ? 0 : 1)
                                .animation(.bouncy, value: mainViewModel.searchOpened)
                            } else {
                                NavigationButton(color: .label) {
                                    showOptions.toggle()
                                }
                            }
                            
                            Spacer()
                            
                            Text(mainViewModel.getCurrentWeather().cityName)
                                .textCase(.uppercase)
                                .font(Montserrat.semibold.font(size: 14))
                                .animation(.smooth, value: mainViewModel.currentPage)
                                .opacity(!showOptions ? 1 : 0)
                                .animation(.default)
                            
                            Spacer()
                            Spacer()
                                .frame(width: 44, height: 44)
                        }
                        .opacity(dailyTemperatureOpened ? 0 : 1)
                        .animation(.snappy, value: dailyTemperatureOpened)
                        
                        
                        HStack {
                            Button {
                                withAnimation(.smooth) {
                                    self.scrollViewProxy?.scrollTo(0, anchor: .center)
                                }
                            } label: {
                                Image(systemName: "multiply")
                                    .font(.system(size: 22, weight: .medium))
                            }
                            .tint(.label)
                            .frame(width: 44, height: 44)
                            
                            Spacer()
                            
                            Text("Forecast")
                                .textCase(.uppercase)
                                .font(Montserrat.semibold.font(size: 14))
                            
                            Spacer()
                            
                            Spacer()
                                .frame(width: 44, height: 44)
                        }
                        .opacity(dailyTemperatureOpened ? 1 : 0)
                        .animation(.snappy, value: dailyTemperatureOpened)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                }
                
                CitiesInfoView(mainViewModel: mainViewModel)
                    .padding(24)
                    .offset(x: showOptions ? 0 : -width)
                    .animation(.snappy(duration: 0.75), value: showOptions)
                
            }
        }
        .environment(mainViewModel)
    }
    
    // MARK: - Functions
    func computeScrollOffsets(offset: CGPoint, height: CGFloat, scrollView: ScrollViewProxy) {
        currentOffset = offset.y
        scrollViewProxy = scrollView
        
        if currentOffset < 0 {
            temperatureScale = abs(currentOffset / 1000) / 8
        }
        
        if currentOffset < offsetLimit {
            withAnimation(.smooth) {
                dailyTemperatureOpened = true
            }
        } else {
            withAnimation(.bouncy) {
                dailyTemperatureOpened = false
            }
        }
        
        /// decide how to change top label
        print("Current offset", currentOffset, height)
        
    }
    
    @State var temperatureScale: Double = 0
    @State var currentScale: Double = 1
    
    @State var dailyTemperatureOpened = false
    @State var showOptions = false
    
    
}

#Preview {
    ZStack {
        MainView(mainViewModel: MainViewModel(forTest: true))
        
        //        RoundedRectangle(cornerRadius: 2)
        //            .frame(width: 1)
        //            .edgesIgnoringSafeArea(.all)
        //
        //        RoundedRectangle(cornerRadius: 2)
        //            .frame(height: 1)
        //            .edgesIgnoringSafeArea(.all)
    }
    .preferredColorScheme(.dark)
}
