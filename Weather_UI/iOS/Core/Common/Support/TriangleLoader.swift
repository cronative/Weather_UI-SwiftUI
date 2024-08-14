//
//  TriangleLoader.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//


import SwiftUI

/// Rotation States
enum TriangleState {
    case begin
    case phaseOne
    case phaseTwo
    case stop
    
    func getStrokes() -> (CGFloat, CGFloat) {
        switch self {
        case .begin:
            return (0.335, 0.665)
        case .phaseOne:
            return (0.5, 0.825)
        case .phaseTwo:
            return (0.675, 1)
        case .stop:
            return (0.175, 0.5)
        }
    }
    
    func getCircleOffset() -> (CGFloat, CGFloat) {
        switch self {
            /// you'll have to change the offset values here if you want to increase/decrease the size of the circle
        case .begin:
            return (0, 35)
        case .phaseOne:
            return (30, -5)
        case .phaseTwo:
            return (-30, -5)
        case .stop:
            return (-30, 0)
        }
    }
}



struct TriangleLoader: View {
    
    // MARK:- Variables
    @State var strokeStart: CGFloat = 0
    @State var strokeEnd: CGFloat = 0
    
    @State var circleOffset: CGSize = CGSize(width: 0, height: 0)
    
    let animationDuration: TimeInterval = 0.7
    var circleColor: Color = Color.blue
    
    
    // MARK:- Views
    var body: some View {
        ZStack {
            Triangle()
                .trim(from: strokeStart, to: strokeEnd)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            Circle()
                .offset(circleOffset)
                .foregroundColor(circleColor)
                .frame(width: 15, height: 15)
        }
        .frame(width: 100, height: 100)
        .offset(y: -75)
        .onAppear() {
            setStroke(state: .begin)
            setCircleOffset(state: .begin)
            animate()
            Timer.scheduledTimer(withTimeInterval: animationDuration * 4.2, repeats: true) { _ in
                animate()
            }
        }
    }
    
    
    // MARK:- Functions
    func animate() {
        Timer.scheduledTimer(withTimeInterval: animationDuration / 2, repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .phaseOne)
            }
            
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .phaseOne)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 2 , repeats: false) { _ in
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .phaseTwo)
            }
            
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .phaseTwo)
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 3.5, repeats: false) { _ in
            setStroke(state: .stop)
            
            withAnimation(.easeInOut(duration: animationDuration)) {
                setStroke(state: .begin)
            }
            
            withAnimation(.spring(response: animationDuration * 2, dampingFraction: 0.85)) {
                setCircleOffset(state: .begin)
            }
        }
    }
    
    func setStroke(state: TriangleState) {
        (self.strokeStart, self.strokeEnd) = state.getStrokes()
    }
    
    func setCircleOffset(state: TriangleState) {
        let offset = state.getCircleOffset()
        self.circleOffset = CGSize(width: offset.0, height: offset.1)
    }
}

struct TriangleLoader_Previews: PreviewProvider {
    static var previews: some View {
        TriangleLoader()
            .colorScheme(.dark)
    }
}
