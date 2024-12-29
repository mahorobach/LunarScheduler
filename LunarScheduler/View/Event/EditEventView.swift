//
//  EditEventView.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/29.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var eventManager: EventManager
    @ObservedObject var groupManager: GroupManager
    
    let event: Event
    @State private var title: String
    @State private var selectedDate: Date
    @State private var memo: String
    @State private var sharingType: Event.SharingType
    @State private var selectedGroupIds: Set<UUID>
    
    init(event: Event, eventManager: EventManager, groupManager: GroupManager) {
        self.event = event
        self.eventManager = eventManager
        self.groupManager = groupManager
        _title = State(initialValue: event.title)
        _selectedDate = State(initialValue: event.solarDate)
        _memo = State(initialValue: event.memo ?? "")
        _sharingType = State(initialValue: event.sharingType)
        _selectedGroupIds = State(initialValue: event.sharedGroupIds)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本情報") {
                    TextField("タイトル", text: $title)
                    DatePicker("日時", selection: $selectedDate)
                    TextField("メモ", text: $memo)
                }
                
                Section("共有設定") {
                    Picker("共有タイプ", selection: $sharingType) {
                        Text("非公開").tag(Event.SharingType.private_)
                        Text("共有").tag(Event.SharingType.shared)
                        Text("全体公開").tag(Event.SharingType.public_)
                    }
                    
                    if sharingType == .shared {
                        ForEach(groupManager.groups) { group in
                            Toggle(group.name, isOn: Binding(
                                get: { selectedGroupIds.contains(group.id) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedGroupIds.insert(group.id)
                                    } else {
                                        selectedGroupIds.remove(group.id)
                                    }
                                }
                            ))
                        }
                    }
                }
            }
            .navigationTitle("予定を編集")
            .navigationBarItems(
                leading: Button("キャンセル") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveChanges()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func saveChanges() {
        let updatedEvent = Event(
            id: event.id,
            title: title,
            solarDate: selectedDate,
            memo: memo.isEmpty ? nil : memo,
            sharingType: sharingType,
            sharedGroupIds: selectedGroupIds
        )
        
        eventManager.updateEvent(updatedEvent)
        dismiss()
    }
}
