//
//  TTBaseTableView.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 23.02.2023.
//

import UIKit

enum TaskType: CaseIterable {
    case active
    case completed
    case none
}


class TTBaseTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.backgroundColor = App.Colors.background
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(TableViewCell.self, forCellReuseIdentifier: id)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = TableAnimationFactory.makeFadeAnimation(duration: 0.77, delayFactor: 0.07)
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewCell(style: .default, reuseIdentifier: id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TableViewCell().tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) { }
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation){ }
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) { }
    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) { }
}
