//
//  TaskEditView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.08.2023.
//

import SwiftUI

struct TaskEditView: View {
    
    @State private var isPickerVisible = false
    @State private var selectedDate = Date()
    
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
    }
    var DatePickerSection: some View {
        Section(header: Text("Дедлайн")) {
            Toggle(isOn: $isPickerVisible) { Text("Показать") }
            
            if isPickerVisible {
                DatePicker("Дата", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название")) {
                    TextField("Введите название заметки", text: $task.taskName)
                }
                Section(header: Text("Текст заметки")) {
                    TextEditor(text: $task.taskInfo)
                        .frame(height: 150)
                }
                DatePickerSection
                
                Section {
                    Button("Готово") {
                        CoreDataMamanager.shared.updateTask(with: task.id,
                                                            taskName: task.taskName == "" ? "Безымянная" : task.taskName,
                                                            taskInfo: task.taskInfo, isDone: task.isDone,
                                                            importance: task.importance,
                                                            deadline: isPickerVisible ? selectedDate : nil)
                        onTaskUpdated()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(uiColor: App.Colors.active))
                }
            }
            .navigationBarTitle("Заметка")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { menu }
            }
        }
    }
}
