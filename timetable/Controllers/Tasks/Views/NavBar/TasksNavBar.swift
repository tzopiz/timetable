//
//  TasksNavBar.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 22.02.2023.
//

import UIKit

enum TypeTasks: CaseIterable {
    case current
    case completed
}

final class TasksNavBar: TTBaseView {
    
    private var currentTasks: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(App.Strings.Tasks.currentTasks, for: .normal)
        button.tintColor = App.Colors.active
        return button
    }()

    private let completedTasks: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(App.Strings.Tasks.completedTasks, for: .normal)
        button.tintColor = App.Colors.inactive
        return button
    }()
    private let midleSeparator: TTBaseView = {
        let view = TTBaseView()
        view.backgroundColor = App.Colors.active
        return view
    }()
    private let bottomSeparator: TTBaseView = {
        let view = TTBaseView()
        view.backgroundColor = App.Colors.active
        return view
    }()
    
    func currentTasksAction(_ action: Selector, with target: Any?) {
        currentTasks.addTarget(target, action: action, for: .touchUpInside)
    }
    func competedTasksAction(_ action: Selector, with target: Any?) {
        completedTasks.addTarget(target, action: action, for: .touchUpInside)
    }
    func changeTasksList(to type: TypeTasks) {
        switch type {
        case .completed:
            if currentTasks.tintColor != App.Colors.inactive {
                TTBaseView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    var basketTopFrame = self.bottomSeparator.frame
                    basketTopFrame.origin.x += basketTopFrame.size.width
                 
                    self.bottomSeparator.frame = basketTopFrame
                  }, completion:  {_ in })
            }
            currentTasks.tintColor = App.Colors.inactive
            completedTasks.tintColor = App.Colors.active
           
        case .current:
            if currentTasks.tintColor != App.Colors.active {
                TTBaseView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    var basketTopFrame = self.bottomSeparator.frame
                    basketTopFrame.origin.x -= basketTopFrame.size.width
                 
                    self.bottomSeparator.frame = basketTopFrame
                  }, completion:  {_ in })
            }
            currentTasks.tintColor = App.Colors.active
            completedTasks.tintColor = App.Colors.inactive
        }
        
    }
}
extension TasksNavBar {
    override func setupViews() {
        super.setupViews()
        
        setupView(midleSeparator)
        setupView(currentTasks)
        setupView(completedTasks)
        setupView(bottomSeparator)

    }

    override func constaintViews() {
        super.constaintViews()
        
        NSLayoutConstraint.activate([
            
            midleSeparator.centerXAnchor.constraint(equalTo: centerXAnchor),
            midleSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            midleSeparator.widthAnchor.constraint(equalToConstant: 3),
            midleSeparator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            bottomSeparator.heightAnchor.constraint(equalToConstant: 3),
            bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: midleSeparator.leadingAnchor),
            
            currentTasks.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentTasks.trailingAnchor.constraint(equalTo: midleSeparator.leadingAnchor),
            currentTasks.bottomAnchor.constraint(equalTo: bottomAnchor),
            currentTasks.heightAnchor.constraint(equalToConstant: 47),
            
            completedTasks.trailingAnchor.constraint(equalTo: trailingAnchor),
            completedTasks.leadingAnchor.constraint(equalTo: midleSeparator.trailingAnchor),
            completedTasks.bottomAnchor.constraint(equalTo: bottomAnchor),
            completedTasks.heightAnchor.constraint(equalToConstant: 47)
                    
        ])
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
