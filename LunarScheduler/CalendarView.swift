import SwiftUI

struct CalendarView: View {
    @StateObject private var eventManager = EventManager()
    @StateObject private var groupManager = GroupManager()
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false
    @State private var calendarType: CalendarType = .western
    
    var body: some View {
        NavigationStack {
            VStack {
                // 西暦/和暦の切り替え
                Picker("暦の種類", selection: $calendarType) {
                    Text("西暦").tag(CalendarType.western)
                    Text("和暦").tag(CalendarType.japanese)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // カレンダー
                DatePicker("日付を選択", selection: $selectedDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                // 旧暦表示（固定）
                HStack(spacing: 8) {  // VStackをHStackに変更し、適切な間隔を設定
                    let lunarInfo = LunarCalendar.getLunarInfo(for: selectedDate)
                    Text(lunarInfo.yearDisplay)
                        .font(.subheadline)
                    Text(lunarInfo.dateDisplay)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                // 選択された日付の行事一覧
                List {
                                    if filteredEvents().isEmpty {
                                        Text("予定はありません")
                                            .foregroundColor(.gray)
                                            .padding()
                                    } else {
                                        ForEach(filteredEvents()) { event in
                                            EventRowView(event: event) {
                                                shareEvent(event)
                                            }
                                            .listRowBackground(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.gray.opacity(0.1))
                                                    .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                                            )
                                        }
                                    }
                                }
                                .listStyle(PlainListStyle()) // リストのスタイルを調整
            }
            .navigationTitle(getNavigationTitle())
            .toolbar {
                Button {
                    showingAddEvent = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(eventManager: eventManager, groupManager: groupManager)
            }
        }
        .onAppear {
            eventManager.loadEvents()
        }
    }
    
    private func filteredEvents() -> [Event] {
        eventManager.events.filter { event in
            Calendar.current.isDate(event.solarDate, inSameDayAs: selectedDate)
        }
    }
    
    private func getNavigationTitle() -> String {
        let year = Calendar.current.component(.year, from: selectedDate)
        switch calendarType {
        case .western:
            return "\(year)年"
        case .japanese:
            return "令和\(year - 2018)年"
        }
    }
    
    private func shareEvent(_ event: Event) {
        let shareText = """
            イベント: \(event.title)
            日付: \(event.solarDate.formatted(date: .long, time: .omitted))
            \(event.memo ?? "")
            """
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let viewController = window.rootViewController {
            viewController.present(activityVC, animated: true)
        }
    }
}
