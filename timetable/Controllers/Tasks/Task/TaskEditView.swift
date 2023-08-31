//
//  TaskEditView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.08.2023.
//

import SwiftUI

struct TaskEditView: View {
    
    @State private var selectedDate = Date()
    @State private var isDatePickerPresented = false
    
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    
    var onTaskUpdated: () -> Void
    
    var menu: some View {
        Menu {
            Button(action: {
                // Действие для копирования
            }) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button(action: {
                // Действие для дублирования
            }) {
                Label("Duplicate", systemImage: "plus.square.on.square")
            }
            if task.deadline != nil { Button(action: { isDatePickerPresented.toggle() }) { Label("Notification", systemImage: "bell") } }
            else { Button(action: { isDatePickerPresented.toggle() }) { Label("Notification", systemImage: "bell.slash") } }
            Button(action: {
                CoreDataMamanager.shared.deletaTask(with: task.id)
                onTaskUpdated()
                presentationMode.wrappedValue.dismiss()
            }) {
                Label("Delete", systemImage: "trash")
            }
            Button(action: {
                // Действие для обмена
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "square.and.pencil")
                .foregroundColor(.blue)
        }
        .sheet(isPresented: $isDatePickerPresented) {
            DatePickerView(selectedDate: $task.deadline,
                           isPresented: $isDatePickerPresented)
            .presentationDetents([.medium])
        }
    }

    var body: some View {
        Form {
            Text("Заметка")
                .font(.largeTitle)
                .bold()
                .listRowBackground(Color.clear)
            Section {
                TextField("Без Названия", text: $task.taskName)
                    .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -15))
                    .font(.system(size: 18, weight: .bold))
            }
        header: { Text("название") }
            
            Section {
                TextEditor(text: $task.taskInfo)
                    .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
                    .font(.system(size: 16))
                    .frame(height: 200)
            }
        header: { Text("текст заметки") }
        footer: { Text(task.deadline == nil ? "" : "Дедлайн: \(Date().formattedDeadline(task.deadline))") }
            Section {
                Button("Готово") {
                    CoreDataMamanager.shared.updateTask(with: task.id,
                                                        taskName: task.taskName == "" ? "Безымянная" : task.taskName,
                                                        taskInfo: task.taskInfo, isDone: task.isDone,
                                                        importance: task.importance,
                                                        deadline: task.deadline)
                    onTaskUpdated()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color(uiColor: App.Colors.active))
            }
        }
    }
}


