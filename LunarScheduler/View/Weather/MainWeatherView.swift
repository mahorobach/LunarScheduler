import SwiftUI


struct MainWeatherView: View {
    @State private var location = "中津川市"
    @State private var date = Date()
    @State private var currentTemp = 3.0
    @State private var highTemp = 4.0
    @State private var lowTemp = -2.0
    @State private var weatherCondition: WeatherCondition = .cloudyWithSunny
    @State private var tides: [TideInfo] = TideInfo.sampleData()
    
    // 時刻フォーマット用の関数
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack {
                    // 背景グラデーション
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "64B5F6"), Color(hex: "1E88E5")]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        // 場所と日付
                        VStack(spacing: 8) {
                            Text(location)
                                .font(.system(size: 34, weight: .medium))
                                .foregroundColor(.white)
                            
                            Text(formatDate(date))
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        // 天気と月の状態
                        HStack(spacing: 25) {
                            weatherCondition.icon
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            MoonPhaseView(phase: MoonPhaseCalculator.calculatePhase(for: date), size: 40)
                        }
                        
                        // 気温表示
                        VStack(spacing: 10) {
                            Text("\(Int(currentTemp))°")
                                .font(.system(size: 96, weight: .thin))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                Text("最高 \(Int(highTemp))°")
                                Text("最低 \(Int(lowTemp))°")
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        }
                        TideView(tides: tides)
                    }
                    .padding()
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "64B5F6"), Color(hex: "1E88E5")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日(E)"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// プレビュー用
#Preview {
    MainWeatherView()
}
    
