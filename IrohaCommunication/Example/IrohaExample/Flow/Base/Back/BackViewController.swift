//
//  BackViewController.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 16.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit


class BackViewController: UIViewController {
    
     var logicLayer = BackLogicLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBack()
    }
    
    func setupBack() {
        let back = (configure(UIButton(type: .system), at: view, constraints: {make in
            make.width.equalTo(40);
            make.height.equalTo(40);
            make.right.equalTo(-20);
            make.top.equalTo(40);
        }).c_setTitle("\u{2718}", for: .normal).c_addTarget(logicLayer, action: #selector(logicLayer.backCallback), for: .touchUpInside) as! UIButton).c_setTitleColor(Palette.orange, for: .normal)
        back.titleLabel?.c_setFont(UIFont.systemFont(ofSize: 30)).c_setTextAlignment(.right)
    }
}


