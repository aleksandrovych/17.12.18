//
//  TextStackView+Chaining.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 18.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit

protocol TextStackViewChaining {
    @discardableResult
    func c_getText(_ recivedText: inout String) -> TextStackViewView;
    
    @discardableResult
    func c_ShowError(_ show: Bool) -> TextStackViewView;
}

extension TextStackViewView: TextStackViewChaining {
    @discardableResult
    func c_ShowError(_ show: Bool) -> TextStackViewView {
        self.logicLayer.isDataValid = show
        return self
    }
    
    @discardableResult
    func c_getText(_ recivedText: inout String) -> TextStackViewView {
        recivedText = self.logicLayer.fieldText
        return self
    }
    
}
