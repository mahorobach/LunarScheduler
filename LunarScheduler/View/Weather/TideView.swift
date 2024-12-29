//
//  TideView.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import SwiftUI

struct TideView: View {
    let tides: [TideInfo]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("潮汐情報")
                .font(.headline)
                .foregroundColor(.white)
            
            ForEach(tides, id: \.time) { tide in
                HStack(spacing: 15) {
                    Image(systemName: tide.type.icon)
                        .foregroundColor(.white)
                    
                    Text(formatTime(tide.time))
                        .foregroundColor(.white)
                    
                    Text(tide.type.description)
                        .foregroundColor(.white)
                    
                    Text(String(format: "%.1fm", tide.height))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}


#Preview {
    TideView(tides: TideInfo.sampleData())
}
