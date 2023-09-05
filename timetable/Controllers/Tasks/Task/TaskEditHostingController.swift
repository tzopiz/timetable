//
//  TaskEditHostingController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 15.08.2023.
//

import SwiftUI

final class TaskEditHostingController: UIHostingController<TaskEditView> {
    init(task: Binding<Task>, onTaskUpdated: @escaping () -> Void) {
        let rootView = TaskEditView(task: task, onTaskUpdated: onTaskUpdated)
        super.init(rootView: rootView)
    }
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
