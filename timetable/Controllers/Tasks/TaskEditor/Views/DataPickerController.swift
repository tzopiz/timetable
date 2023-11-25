//
//  DataPickerController.swift
//  timetable
//
//  Created by Дмитрий Корчагин on 09.10.2023.
//

import UIKit

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
        view.setupView(dataPicker)
        view.insertSubview(swipeAreaView, belowSubview: dataPicker)
    }
    override func constraintViews() {
        dataPicker.anchor(top: view.topAnchor, paddingTop: 16,
                          left: view.leadingAnchor, right: view.trailingAnchor)
        swipeAreaView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, paddingBottom: 30,
                             left: view.leadingAnchor, right: view.trailingAnchor)
    }
    override func configureAppearance() {
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
