//
//  Triangle.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//

import SwiftUI

struct Triangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        let cX: CGFloat = rect.midX
        
        var path = Path()
        path.move(to: CGPoint(x: cX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: cX, y: rect.minY))
        
        path.move(to: CGPoint(x: cX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.85))
        path.addLine(to: CGPoint(x: cX, y: rect.minY))

        return path
    }
    
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
            .trim(from: 0, to: 1)
            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
            .frame(width: 120, height: 120)
    }
}
