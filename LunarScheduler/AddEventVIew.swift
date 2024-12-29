//
//  AddEventVIew.swift
//  LunarScheduler
//
//  Created by 赤尾浩史 on 2024/12/28.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var eventManager: EventManager
    @ObservedObject var groupManager: GroupManager
    
    @State private var title = ""
    @State private var selectedDate = Date()
    @State private var memo = ""
    @State private var sharingType: Event.SharingType = .private_
    @State private var selectedGroupIds: Set<UUID> = []
    
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
            .navigationTitle("予定を追加")
            .navigationBarItems(
                leading: Button("キャンセル") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveEvent()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func saveEvent() {
        let newEvent = Event(
            title: title,
            solarDate: selectedDate,
            memo: memo.isEmpty ? nil : memo,
            sharingType: sharingType,
            sharedWith: selectedGroupIds
        )
        
        eventManager.addEvent(newEvent)
        
        // グループに追加
        if sharingType == .shared {
            for groupId in selectedGroupIds {
                groupManager.addEventToGroup(groupId: groupId, eventId: newEvent.id)
            }
        }
        
        dismiss()
    }
}
