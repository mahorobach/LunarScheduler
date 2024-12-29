//
//  MoonPhaseView.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import SwiftUI

struct MoonPhaseView: View {
    let phase: Double // 0-1の値
        let size: CGFloat
    var body: some View {
        GeometryReader { geometry in
                    ZStack {
                        // 月の基本形（円）
                        Circle()
                            .fill(Color.white)
                            .frame(width: size, height: size)
                        
                        // 影の部分
                        Path { path in

                            path.addArc(center: CGPoint(x: size/2, y: size/2),
                                      radius: size/2,
                                      startAngle: .degrees(-90),
                                      endAngle: .degrees(270),
                                      clockwise: true)
                            
                            // 月の満ち欠けに応じて影の形を変える
                            let controlX: CGFloat
                            if phase < 0.5 {
                                controlX = size * (1 - phase * 2)
                                path.addQuadCurve(to: CGPoint(x: size/2, y: size),
                                                control: CGPoint(x: controlX, y: size/2))
                            } else {
                                controlX = size * ((phase - 0.5) * 2)
                                path.addQuadCurve(to: CGPoint(x: size/2, y: 0),
                                                control: CGPoint(x: controlX, y: size/2))
                            }
                        }
                        .fill(Color.black)
                    }
                }
                .frame(width: size, height: size)
    }
}


