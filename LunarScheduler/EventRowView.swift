//
//  EventRowView.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/28.
//

import SwiftUI

struct EventRowView: View {
    let event: Event
    let onShare: () -> Void
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        HStack {
            // 時間とイベント情報を左右に分けて表示
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(timeFormatter.string(from: event.solarDate))
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    // 共有状態アイコン
                    switch event.sharingType {
                    case .public_:
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                    case .shared:
                        Image(systemName: "person.2")
                            .foregroundColor(.blue)
                    case .private_:
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                    }
                }
                
                Text(event.title)
                    .font(.headline)
                
                if let memo = event.memo {
                    Text(memo)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            // 共有ボタン
            Button(action: onShare) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.blue)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
    }
}

