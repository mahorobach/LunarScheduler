import SwiftUI

struct CalendarView: View {
    @StateObject private var eventManager = EventManager()
    @StateObject private var groupManager = GroupManager()
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false
    @State private var showingEditEvent: Event?
    @State private var calendarType: CalendarType = .western
    @State private var showingAlert = false
    @State private var alertMessage = ""
        
        private let calendarExporter = CalendarExporter()
    
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
                HStack(spacing: 8) {
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
                    ForEach(filteredEvents()) { event in
                        EventRowView(
                            event: event,
                            onShare: { shareEvent(event) },
                            onEdit: { showingEditEvent = event },
                            onDelete: { deleteEvent(event) },
                            onExport: { exportEvent(event) }
                        )
                    }
                    // アラート表示を追加
                        .alert("カレンダー", isPresented: $showingAlert) {
                            Button("OK") {}
                        } message: {
                            Text(alertMessage)
                        }
                }
                .listStyle(PlainListStyle())
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
            .sheet(item: $showingEditEvent) { event in
                EditEventView(
                    event: event,
                    eventManager: eventManager,
                    groupManager: groupManager
                )
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
        // 共有機能の実装
    }
    
    private func deleteEvent(_ event: Event) {
        eventManager.events.removeAll { $0.id == event.id }
        eventManager.saveEvents()
    }
    
    // エクスポート機能を追加
        private func exportEvent(_ event: Event) {
            Task {
                do {
                    try await calendarExporter.exportEvent(event)
                    await MainActor.run {
                        alertMessage = "カレンダーに追加しました"
                        showingAlert = true
                    }
                } catch {
                    await MainActor.run {
                        alertMessage = "カレンダーへの追加に失敗しました"
                        showingAlert = true
                    }
                }
            }
        }
}
