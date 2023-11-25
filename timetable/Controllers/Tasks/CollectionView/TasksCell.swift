//
//  TasksCell.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 24.11.2022.
//

import UIKit
import SnapKit

final class TasksCell: BaseCell {
    
    override class var reuseIdentifier: String { return String(describing: TasksCell.self) }
    weak var delegate: UICollectionViewUpdatable?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    private let noteNameLabel: TTLabel = {
        let label = TTLabel(fontSize: 17, lineBreakMode: .byCharWrapping)
        label.numberOfLines = 1
        return label
    }()
    private let noteInfoLabel: TTLabel = {
        let label = TTLabel(textColor: R.color.subtitle(),
                            fontSize: 15,
                            lineBreakMode: .byCharWrapping)
        label.numberOfLines = 1
        return label
    }()
    private let deadlineLabel = TTLabel(fontSize: 13)
    private let buttonCheckmarkView = TTButton(with: .primary)
    
    private var task: Task?
    
    func configure(task: Task) {
        self.task = task
        self.noteNameLabel.text = task.name
        self.noteInfoLabel.text = task.info
        buttonCheckmarkView.setImage(task.isDone ? R.image.checkmark_circle() : R.image.circle(),
                                     for: .normal)
        if let deadline = task.deadline {
            deadlineLabel.isHidden = false
            let calendar = Calendar.current
            if calendar.isDateInToday(deadline) {
                deadlineLabel.text = "Дедлайн сегодня: " + Date().formattedDeadline(deadline)
                deadlineLabel.textColor = R.color.red()
            }
            else {
                if deadline > Date.now {
                    deadlineLabel.text = "Дедлайн: " + Date().formattedDeadline(deadline)
                    deadlineLabel.textColor = R.color.active()
                } else {
                    deadlineLabel.text = "Дедлайн был: " + Date().formattedDeadline(deadline)
                    deadlineLabel.textColor = R.color.subtitle()
                }
            }
        } else {
            deadlineLabel.isHidden = true
            deadlineLabel.text = nil
        }
        drawGradientTriangle(task.isImportant)

        noteInfoLabel.isHidden = false
        if task.info == "" { noteInfoLabel.isHidden = true }
    }
    private func drawGradientTriangle(_ needDraw: Bool) {
        if needDraw {
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: bounds.width - 40, y: 0))
            trianglePath.addLine(to: CGPoint(x: bounds.width, y: 40))
            trianglePath.addLine(to: CGPoint(x: bounds.width, y: 16))
            trianglePath.addLine(to: CGPoint(x: bounds.width - 16, y: 0))
            trianglePath.close()
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            guard let purple = R.color.purple(), let active = R.color.active() else { return }
            gradientLayer.colors = [purple.cgColor, active.cgColor]
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = trianglePath.cgPath
            gradientLayer.mask = maskLayer
            
            layer.addSublayer(gradientLayer)
        } else {
            if let sublayers = layer.sublayers {
                for sublayer in sublayers where sublayer is CAGradientLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    override func isHighlighted() { self.backgroundColor = R.color.secondary()!.withAlphaComponent(0.4) }
    override func isUnHighlighted() { self.backgroundColor = R.color.blackWhite() }
    
    @IBAction func updateCheckmarkView() {
        guard let task = self.task else { return }
        task.isDone = !task.isDone
        self.buttonCheckmarkView.setImage(task.isDone ? R.image.checkmark_circle() : R.image.circle(),
                                          for: .normal)
        CoreDataMamanager.shared.updataTypeTask(with: task.id, isDone: task.isDone)
        self.task = task
        self.delegate?.updateCollectionView()
    }
}

extension TasksCell {
    override func setupViews() {
        addSubview(buttonCheckmarkView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(noteNameLabel)
        stackView.addArrangedSubview(noteInfoLabel)
        stackView.addArrangedSubview(deadlineLabel)
    }
    override func layoutViews() {
        buttonCheckmarkView.snp.makeConstraints { make in
            make.height.width.equalTo(28)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(buttonCheckmarkView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    override func configureViews() {
        self.backgroundColor = R.color.blackWhite()
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        buttonCheckmarkView.addTarget(self, action: #selector(updateCheckmarkView), for: .touchUpInside)
    }
}
