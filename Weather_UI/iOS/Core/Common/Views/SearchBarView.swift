//
//  SearchBarView.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//

import SwiftUI

struct SearchBarView: View {
    
    // MARK: - variables
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var expandSearchbar: Bool
    @Binding var searchText: String
    
    @State var barWidth: CGFloat = 105
    @State var barHeight: CGFloat = 44
    @State var barXOffset: CGFloat = -28
    
    @State var symbolXOffset: CGFloat = 24
    @State var overlayOffset: CGFloat = 0
    @State var overlayWidth: CGFloat = 0
    
    @State var fillerColor: Color = Color.green
    @State var searchStarted: Bool = false
    
    @Environment(MainViewModel.self) var mainViewModel
    
    let animationDuration: TimeInterval = 0.4

    
    // MARK: - views
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
            HStack {
                CloseView(isAnimating: $expandSearchbar, animationDuration: animationDuration, isRow: true) {
                    mainViewModel.resetSearch()
                }
                    .frame(width: 44, height: 44)
                    .offset(x: -8)
                Spacer()
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                    Capsule()
                        .stroke(style: StrokeStyle(lineWidth: 4))
                        .fill(Color.label.opacity(0.75))
                        .overlay(
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 19, weight: .bold))
                                .offset(x: symbolXOffset)
                        )
                        .overlay(
                            TextField("Search for cities", text: $searchText, onCommit:  {
                                self.mainViewModel.searchedQuery = searchText
                            })
                            .font(Montserrat.regular.font(size: 16))
                            .offset(x: 55)
                            .foregroundColor(Color.label)
                            .textFieldStyle(PlainTextFieldStyle())
                            .accentColor(.label)
                            .opacity(self.expandSearchbar ? 1 : 0)
                            .disabled(self.expandSearchbar ? false : true)
                            .disableAutocorrection(true)
                            .animation(.default, value: expandSearchbar)
                        )
                        .frame(width: barWidth, height: barHeight, alignment: .leading)
                }
//                .shadowOverlay(xOffset: 5, yOffset: 8, lineWidth: 3.5, opacity: colorScheme == .dark ? Constants.darkOpacity : 1, colorScheme: colorScheme, content: RoundedRectangle(cornerRadius: 24))
                .offset(x: barXOffset)
                .fixedSize()
            }
            .padding()
        }
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { barTimer in
                if (expandSearchbar) {
                    expandBar()
                } else {
                    closeBar()
                }
            }
        }
        .padding([.leading, .trailing])
    }
    
    // MARK: - functions
    func expandBar() {
        withAnimation(Animation.spring(response: animationDuration)) {
            barWidth =  UIScreen.main.bounds.width * 0.75
            barXOffset = 0
            barHeight = 50
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.3, repeats: false) { _ in
            withAnimation(Animation.easeIn(duration: animationDuration  * 0.7)) {
                symbolXOffset = -( UIScreen.main.bounds.width * 0.3)
            }
        }
    }
    
    func closeBar() {
        withAnimation(Animation.spring(response: animationDuration)) {
            barWidth = 105
            barXOffset = -28
            barHeight = 44
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.3, repeats: false) { _ in
            withAnimation(Animation.easeIn(duration: animationDuration  * 0.7)) {
                symbolXOffset = 24
            }
        }
    }
    
    func animateFiller() {
        self.overlayWidth = 0
        self.overlayOffset = 0
        withAnimation(Animation.easeOut(duration: animationDuration / 2)) {
            self.overlayWidth = UIScreen.main.bounds.width * 0.75 + 4
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                self.overlayOffset = UIScreen.main.bounds.width * 0.75 + 4
            }
        }
    }
}

struct SearchbarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            SearchBarView(expandSearchbar: .constant(true), searchText: .constant(""))
                .environment(MainViewModel(forTest: true))
        }
    }
}
