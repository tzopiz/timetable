//
//  NoteEditHostingController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 15.08.2023.
//

import SwiftUI

class NoteEditHostingController: UIHostingController<NoteEditView> {
    init(task: Binding<Task>, onTaskUpdated: @escaping () -> Void) {
        let rootView = NoteEditView(task: task, onTaskUpdated: onTaskUpdated)
        super.init(rootView: rootView)
    }
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
