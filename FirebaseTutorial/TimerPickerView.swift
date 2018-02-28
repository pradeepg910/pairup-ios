//
//  TimerPickerView.swift
//  Pairup
//
//  Created by Ganesan, Pradeep (NonEmp) on 2/26/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class TimerPickerView: UIPickerView {

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }

}
