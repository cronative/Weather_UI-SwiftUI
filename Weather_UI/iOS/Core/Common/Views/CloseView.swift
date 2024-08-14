//
//  CloseView.swift
//  RetroToDo
//
//  Created by Nikunj Singh on 30/09/23.
//

import SwiftUI

struct CloseView: View {
    
    // MARK: - Variables
    @State var upperOpacity: Double = 0
    @State var rotationDegrees: Angle = Angle.degrees(-90)
    @State var lowerRotationDegrees: Angle = .degrees(3)
    @State var closeOpacity: Double = 0
    
    @Binding var isAnimating: Bool
    
    var animationDuration: TimeInterval = 0.25
    var isRow: Bool = false
    var needsAnimation = true
    
    var buttonAction: () -> () = {}

    
    // MARK: - Views
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            
            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.label.opacity(0.5))
                    .frame(width: width / 10, height: height)
                    .opacity(upperOpacity)
                    .rotationEffect(lowerRotationDegrees)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.label)
                    .frame(width: width / 10, height: height)
                    .rotationEffect(rotationDegrees)
            }
            .offset(x: width / 2)
            .opacity(closeOpacity)
            
            .onAppear() {
                if (needsAnimation) {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { closeTimer in
                        if (isAnimating) {
                            Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
                                animateClose()
                            }
                        } else {
                            closeBack()
                        }
                    }
                } else {
                    rotationDegrees = .degrees(135)
                    closeOpacity = 1
                    upperOpacity = 1
                    lowerRotationDegrees = .degrees(223)
                }
            }
            .onTapGesture {
                if (isRow) {
                    buttonAction()
                } else {
                    self.isAnimating.toggle()
                }
                
            }
        }
    }
    
    // MARK: - Functions
    func animateClose() {
        withAnimation(Animation.easeInOut(duration: animationDuration)) {
            rotationDegrees = .degrees(135)
            closeOpacity = 1
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration / 4, repeats: false) { _ in
            withAnimation(Animation.spring()) {
                upperOpacity = 1
            }
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: animationDuration / 2)) {
                lowerRotationDegrees = .degrees(223)
            }
        }
    }
    
    func delete() {
        withAnimation(.default) {
            lowerRotationDegrees = .degrees(-90)
        }
    }
    
    func closeBack() {
        withAnimation(Animation.default) {
            rotationDegrees = .degrees(-90)
            closeOpacity = 0
            upperOpacity = 0
            lowerRotationDegrees = .degrees(3)
        }
    }
}

struct CloseView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            CloseView(isAnimating: .constant(true))
                .frame(width: 44, height: 44)
        }
    }
}
