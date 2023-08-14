//
//  NoteEditView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 14.08.2023.
//

import SwiftUI

struct NoteEditView: View {
    
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    
    var onTaskUpdated: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Заголовок")) {
                    TextField("Введите название заметки", text: $task.taskName)
                }

                Section(header: Text("Текст заметки")) {
                    TextEditor(text: $task.taskInfo)
                        .frame(height: 150)
                }

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
            .navigationBarTitle("Редактирование")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CustomMenuButton()
                }
            }
        }
    }
}
struct CustomMenuButton: View {
    var body: some View {
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
                // Действие для удаления
            }) {
                Label("Delete", systemImage: "trash")
            }
            Button(action: {
                // Действие для обмена
            }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title3)
                .foregroundColor(.blue)
        }
    }
}

