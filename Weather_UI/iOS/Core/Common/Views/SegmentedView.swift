//
//  SegmentedView.swift
//  Weather_UI
//
//  Created by Nikunj on 15/05/24.
//

import SwiftUI

struct SegmentedView: View {
    
    // MARK: - Variables
    @Environment(MainViewModel.self) var mainViewModel
        
    // MARK: - Views
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0 ..< mainViewModel.allWeatherInfo.count, id: \.self) { ix in
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: ix == (mainViewModel.currentPage ?? 0) ? 12 : 6, height: 6)
                    .foregroundColor(ix == (mainViewModel.currentPage ?? 0) ? Color.label : Color.label.opacity(0.4))
                    .animation(.smooth(duration: 0.4), value: mainViewModel.currentPage)
            }
        }
        .animation(.snappy, value: (mainViewModel.currentPage ?? 0))
    }
}


#Preview {
    SegmentedView()
        .environment(MainViewModel(forTest: true))
}
