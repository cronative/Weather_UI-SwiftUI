//
//  ViewExtensions.swift
//  Weather_UI
//
//  Created by Nikunj on 10/05/24.
//

import SwiftUI
import Combine

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct ShadowView<T: Shape>: ViewModifier {
    // MARK: - Variables
    let shape: T
    
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    var opacity: Double
    var lineWidth: CGFloat = 3
    
    var backgroundColor: Color
    
    var needsBrightness: Bool
    var colorScheme: ColorScheme
    
    var needStrokeColor: Bool
    var strokeColor: Color
    
    init(xOffset: CGFloat, yOffset: CGFloat, lineWidth: CGFloat = 3, opacity: Double = 1, backgroundColor: Color = Color.background, needsBrightness: Bool = false, colorScheme: ColorScheme, needsStrokeColor: Bool = false, strokeColor: Color = .label, @ViewBuilder shapeView: () -> T) {
        self.xOffset = xOffset
        self.yOffset = yOffset
        
        self.lineWidth = lineWidth
        self.opacity = opacity
        
        self.backgroundColor = backgroundColor
        self.needsBrightness = needsBrightness
        
        self.colorScheme = colorScheme
        
        self.needStrokeColor = needsStrokeColor
        self.strokeColor = strokeColor
        
        self.shape = shapeView()
    }
    
    // MARK: - Functions
    func body(content: Content) -> some View {
        ZStack {
            shape
                .offset(x: xOffset, y: yOffset)
                .opacity(opacity)
            
            shape
                .foregroundColor(backgroundColor)
                .if(needsBrightness, transform: { view in
                    view
                        .brightness(0.075)
                })
            
            shape
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .opacity(opacity)
                .if(needStrokeColor) { view in
                    view
                        .foregroundColor(strokeColor)
                }
            
            content
        }
        .colorScheme(colorScheme)
    }
}

extension View {
    func shadowOverlay<V: Shape>(xOffset: CGFloat = 9, yOffset: CGFloat = 10, lineWidth: CGFloat = 3, opacity: Double = 1, backgroundColor: Color = Color.background, needsBrightness: Bool = false, colorScheme: ColorScheme, needsStrokeColor: Bool = false, strokeColor: Color = .label, content: V) -> some View {
        modifier(
            ShadowView(xOffset: xOffset, yOffset: yOffset, lineWidth: lineWidth, opacity: opacity, backgroundColor: backgroundColor, needsBrightness: needsBrightness, colorScheme: colorScheme, needsStrokeColor: needsStrokeColor, strokeColor: strokeColor) {
                content
            }
        )
    }
}


struct XToolbar<T: View>: ViewModifier {
    
    // MARK: - Variables
    @Environment(\.dismiss) var dismiss
    @State var viewAppeared = false
    
    let view: T
    
    init(@ViewBuilder view: () -> T) {
        self.view = view()
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 24, weight: .light, design: .monospaced))
                        .opacity(viewAppeared ? 1 : 0)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .onAppear() {
                withAnimation(.smooth) {
                    self.viewAppeared = true
                }
            }
    }
}


extension View {
    func backButtonToolbar() -> some View {
        modifier(
            XToolbar(view: {
                self
            })
        )
    }
}


extension Shape {
    func shadowShapeOverlay(xOffset: CGFloat = 9, yOffset: CGFloat = 10, colorScheme: ColorScheme) -> some View {
        modifier(
            ShadowView(xOffset: xOffset, yOffset: yOffset, colorScheme: colorScheme) {
                self
            }
        )
    }
}


extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
