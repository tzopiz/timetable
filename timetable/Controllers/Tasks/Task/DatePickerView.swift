//
//  DatePickerView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 01.09.2023.
//

import SwiftUI


struct DatePickerView: View {
    @Binding var selectedDate: Date?
    @Binding var isPresented: Bool
    @State private var unoptionalSelectedDate: Date
    
    init(selectedDate: Binding<Date?>, isPresented: Binding<Bool>) {
        _isPresented = isPresented
        _selectedDate = selectedDate
        _unoptionalSelectedDate = State(initialValue: selectedDate.wrappedValue ?? Date())
    }
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            DatePicker("Select a Date", selection: $unoptionalSelectedDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.graphical) // Или любой другой стиль, который тебе нравится
                .padding()
            
            HStack {
                Button(action: {
                    isPresented = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Отмена")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    isPresented = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Готово")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}
