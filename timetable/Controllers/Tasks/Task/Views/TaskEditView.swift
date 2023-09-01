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
    @State private var isImportant = false
    
    @Binding var task: Task
    
    @Environment(\.presentationMode) var presentationMode
    
    var onTaskUpdated: () -> Void
    
    init(task: Binding<Task>, onTaskUpdated: @escaping () -> Void) {
        self._isImportant = State(initialValue: task.wrappedValue.isImportant)
        self._task = task
        self.onTaskUpdated = onTaskUpdated
    }
    
    var menu: some View {
        Menu {
            Button(action: { }) { Label("Copy", systemImage: "doc.on.doc") }
            Button(action: { }) { Label("Duplicate", systemImage: "plus.square.on.square") }
            if task.deadline != nil { Button(action: { isDatePickerPresented.toggle() }) { Label("Notification", systemImage: "bell") } }
            else { Button(action: { isDatePickerPresented.toggle() }) { Label("Notification", systemImage: "bell.slash") } }
            Button(action: {
                CoreDataMamanager.shared.deletaTask(with: task.id)
                onTaskUpdated()
                presentationMode.wrappedValue.dismiss()
            }) { Label("Delete", systemImage: "trash") }
            Button(action: { }) { Label("Share", systemImage: "square.and.arrow.up")  }
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
    var taskNameTextField: some View {
        TextField("Без Названия", text: $task.taskName)
            .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -15))
            .font(.system(size: 18, weight: .bold))
    }
    var taskInfoTextEditor: some View {
        TextEditor(text: $task.taskInfo)
            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
            .font(.system(size: 16))
            .frame(height: 200)
    }
    var buttonSave: some View {
        Button("Готово") {
            CoreDataMamanager.shared.updateTask(with: task.id,
                                                taskName: task.taskName == "" ? "Без названия" : task.taskName,
                                                taskInfo: task.taskInfo, isDone: task.isDone,
                                                isImportant: task.isImportant,
                                                deadline: task.deadline)
            onTaskUpdated()
            presentationMode.wrappedValue.dismiss()
        }
        .foregroundColor(Color(uiColor: App.Colors.active))
    }
    var buttonIsImportant: some View {
        Button {
            isImportant.toggle()
            task.isImportant = isImportant
        } label: {
            Image(systemName: task.isImportant ? "star.fill" : "star")
                .foregroundColor(Color(uiColor: App.Colors.purple))
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section { taskNameTextField } header: { Text("название") }
                
                Section {
                    taskInfoTextEditor
                } header: {
                    Text("текст заметки")
                } footer: {
                    Text(task.deadline == nil ? "" : "Дедлайн: \(Date().formattedDeadline(task.deadline))")
                }
                Section { buttonSave }
            }
            .navigationBarTitle("Заметка", displayMode: .large)
            .navigationBarItems(trailing: menu)
            .navigationBarItems(trailing: buttonIsImportant)
        }
    }
}


