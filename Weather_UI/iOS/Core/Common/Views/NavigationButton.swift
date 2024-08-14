//
//  NavigationButton.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import SwiftUI

struct NavigationButton: View {
    
    // MARK: - variables
    @State var lineWidth: CGFloat = 0
    @State var smallerLineWidth: CGFloat = 0
    
    let color: Color
    let buttonAction: () -> ()
    
    // MARK: - views
    var body: some View {
        ZStack {
            Button(action: {
                buttonAction()
            })
            {
                VStack(alignment: .leading) {
                    Capsule(style: .continuous)
                        .frame(width: lineWidth, height: 3)
                    Capsule(style: .continuous)
                        .frame(width:  smallerLineWidth, height: 3)
                }
            }
            .foregroundColor(color)
            .onAppear() {
                withAnimation(Animation.easeOut(duration: 0.5)) {
                    self.lineWidth = 40
                }
                
                Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                    withAnimation(Animation.easeOut(duration: 0.35)) {
                        self.smallerLineWidth = 18
                    }
                }
            }
        }
        .frame(width: 44, height: 44, alignment: .trailing)
    }
}

#Preview {
    NavigationButton(color: Color.black, buttonAction: {})
}
