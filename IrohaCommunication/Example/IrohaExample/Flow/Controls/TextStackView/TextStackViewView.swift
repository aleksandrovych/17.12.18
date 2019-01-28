//
//  TextStackView.swift
//  IrohaExample
//
//  Created by Allar-Alexey Alexandrovich on 18.01.2019.
//  Copyright © 2019 Russel. All rights reserved.
//

import UIKit
import SnapKit

/*
    Use logicLayer to setup data from outside
    Use error to configure how this label should look like
    Use field to configure how this textField should look like
 */
class TextStackViewView: UIView {
    public let logicLayer = TextStackViewLogicLayer()
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupUI()
    }
    
    deinit {
        logicLayer.removeObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.isDataValid));
    }
    
    public var error: UILabel? = nil
    public var field: UITextField? = nil
    
    func setupUI() {
        
        snp.c_m { make in
            make.height.equalTo(logicLayer.isDataValid ? 40 : 60)
        }
        
        func topGlued(_ marker: ConstraintMaker) {
            marker.left.equalTo(0);
            marker.right.equalTo(0);
            marker.top.equalTo(0);
        }
        
        let stack = configure(UIStackView(), at: self) { make in
            topGlued(make)
            make.bottom.equalTo(0)
        }.c_setSpacing(5).c_setAxis(.vertical).c_setAligment(.fill);
        
        field = configure(UITextField(), at: stack, constraints: { make in make.height.equalTo(40) }).c_setDelegate(self)
        
        error = ((configure(UILabel(), at: stack, constraints: { make in make.height.equalTo(15) }) as UILabel).c_setTextColor(Palette.red).c_setText("Invalid value").c_setTextAlignment(.center).c_setHidden(logicLayer.isDataValid) as UILabel)
        
        logicLayer.addObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.isDataValid), options: [.new], context: nil)
        logicLayer.addObserver(self, forKeyPath: #keyPath(TextStackViewLogicLayer.fieldText), options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(TextStackViewLogicLayer.isDataValid) {
            guard let error = self.error else {
                return
            }
            
            error.isHidden = (object as! TextStackViewLogicLayer).isDataValid
            
            snp.c_u { make in
                make.height.equalTo((object as! TextStackViewLogicLayer).isDataValid ? 40 : 60)
            }
            
        } else if keyPath == #keyPath(TextStackViewLogicLayer.fieldText) {
            guard let field = self.field else {
                return
            }
            
            field.c_setText((object as! TextStackViewLogicLayer).fieldText)
        }
        
    }
}

extension TextStackViewView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        
        let newString = NSString(string: text).replacingCharacters(in: range, with: string).lowercased()
        
        self.logicLayer.fieldText = newString
        
        return false
    }
}
