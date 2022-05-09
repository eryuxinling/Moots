//
//  PolygonController.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/7.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class PolygonController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!

    fileprivate lazy var quartzPolygonView: QuartzPolygonView = {
        let quartzPolygonView = QuartzPolygonView()
        quartzPolygonView.translatesAutoresizingMaskIntoConstraints = false
        return quartzPolygonView
    }()
    
    let drawModes: [String] = [
        "Fill",//0
        "EOFill",//1
        "Stroke",//2
        "FillStroke",//3
        "EOFillStroke"//4
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(Int(quartzPolygonView.drawingMode.rawValue), inComponent: 0, animated: false)

        
        view.insertSubview(quartzPolygonView, at: 0)
        quartzPolygonView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quartzPolygonView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quartzPolygonView.topAnchor.constraint(equalTo: view.safeTopAnchor).isActive = true
        quartzPolygonView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -264).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PolygonController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drawModes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        quartzPolygonView.drawingMode = CGPathDrawingMode(rawValue: Int32(row))!
    }
}

extension PolygonController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drawModes.count
    }
}
