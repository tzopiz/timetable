//
//  DataPickerController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.10.2023.
//

import UIKit
import SnapKit

class DataPickerController: TTBaseController {
    private let dataPicker: UIDatePicker = {
        let dataPicker = UIDatePicker()
        dataPicker.datePickerMode = .date
        dataPicker.minimumDate = Date()
        dataPicker.preferredDatePickerStyle = .wheels
        return dataPicker
    }()
    private let swipeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.blackWhite()
        view.layer.cornerRadius = 16
        return view
    }()
}

extension DataPickerController {
    override func setupViews() {
        view.addSubview(dataPicker)
        view.insertSubview(swipeAreaView, belowSubview: dataPicker)
    }
    override func layoutViews() {
        dataPicker.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }
        swipeAreaView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(30)
        }
    }
    override func configureViews() {
        view.backgroundColor = .clear
        // TODO: - Fetch tap / watch other method to present
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGesture.direction = .down
        self.swipeAreaView.addGestureRecognizer(swipeDownGesture)
        
    }
}

extension DataPickerController {
    @IBAction func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.frame.origin.y += self.view.frame.size.height
            }) { (_) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
