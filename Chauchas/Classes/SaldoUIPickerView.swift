//
//  SaldoUIPickerView.swift
//  Chauchas
//
//  Created by Alvaro Galia Valenzuela on 06-03-18.
//  Copyright © 2018 Alvaro Galia Valenzuela. All rights reserved.
//

import UIKit

class SaldoUIPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var multiplicador = 0
    var isNegativo = false
    var isRojoVerde = false
    var isChaucha = false
    var cantDecimales = 0
    var rowHeight = 30.0
    var valorAnterior = 0
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1000
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(isChaucha){
            return "CHA "
        }else{
            return "$\(row+multiplicador)"
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica", size: 30.0)
            
            pickerLabel?.textAlignment = .center
        }
        var valor = ""
        
        if(isNegativo){
            valor = "$-\(row+multiplicador)"
        }else{
            valor = "$\(row+multiplicador)"
        }
        
        if(isRojoVerde){
            if(isNegativo){
                pickerLabel?.text = valor
                pickerLabel?.textColor = UIColor.red
            }else{
                pickerLabel?.text = valor
                pickerLabel?.textColor = UIColor.green
            }
        }else{
            pickerLabel?.text = valor
            pickerLabel?.textColor = UIColor.lightGray
        }
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(self.rowHeight)
    }
    
}
