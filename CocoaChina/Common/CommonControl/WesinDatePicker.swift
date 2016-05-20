//
//  WesinDatePicker.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/5/12.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

enum DatePickMode {
    case DateAll
    case Month
    case Year
}

protocol WesinDatePickerDelegate:class {
    func datePicker(picker:WesinDatePicker, date:NSDate)
}

class WesinDatePicker: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var datePicker:UIPickerView?
    var btnOK:UIButton?
    var btnCancel:UIButton?
    
    var dateFormat:DatePickMode = .DateAll {
        didSet {
            if dateFormat != oldValue {
                datePicker?.reloadAllComponents()
            }
        }
    }
    
    private var beginDate = NSDate(timeIntervalSince1970: 0)
    private var endDate = NSDate()
    var margin:CGFloat = 10
    var buttonHeight:CGFloat = 22
    var buttonWidth:CGFloat = 22
    
    var startDate:NSDate = NSDate() {
        didSet {
            scrollToDate(startDate)
        }
    }
    
    weak var delegate:WesinDatePickerDelegate?
    
    override func drawRect(rect: CGRect) {

//        self.layer.borderColor = UIColor.brownColor().CGColor
//        self.layer.borderWidth = 1
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(bounds)
        if datePicker == nil  {
            self.backgroundColor = UIColor.whiteColor()
            endDate = beginDate.dateByAddingYears(100)
            datePicker = UIPickerView()
            datePicker?.delegate = self
            self.addSubview(datePicker!)
            datePicker?.frame = CGRect(x: 0, y: buttonHeight + margin, width: bounds.width, height: 216)
            
            btnOK = UIButton()
            btnOK?.setImage(UIImage(named: "ok")!, forState: UIControlState.Normal)
//            btnOK?.setTitle("确定", forState: UIControlState.Normal)
//            btnOK?.setTitleColor(UIColor.blackColor(), forState: .Normal)
            btnOK?.addTarget(self, action: #selector(WesinDatePicker.btnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(btnOK!)
            btnOK?.frame = CGRect(x: bounds.width - buttonWidth - margin, y: margin, width: buttonWidth, height: buttonHeight)
            
//            btnCancel = UIButton()
//            btnCancel?.setTitle("取消", forState: UIControlState.Normal)
//            btnCancel?.setTitleColor(UIColor.blackColor(), forState: .Normal)
//            btnCancel?.addTarget(self, action: Selector("btnClick:"), forControlEvents: UIControlEvents.TouchUpInside)
//            self.addSubview(btnCancel!)
//            btnCancel?.frame = CGRect(x: margin, y: margin, width: buttonWidth, height: buttonHeight)
            scrollToDate(startDate)
        }
    }
    
    func btnClick(button:UIButton) {
        if button == btnOK {
            delegate?.datePicker(self, date: getDate())
        } else {
            self.removeFromSuperview()
        }
    }
    
    //MARK:PickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch dateFormat {
        case .DateAll:
            return 3
        case .Month:
            return 2
        case .Year:
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return endDate.yearsFrom(beginDate)
        case 1:
            return 12
        case 2:
            return getDayCount()
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(beginDate.year() + row)年"
        case 1:
            return "\(row + 1)月"
        case 2:
            return "\(row + 1)日"
        default:
            return ""
        }
    }
    
    //MARK:PickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 && dateFormat == .DateAll {
            pickerView.reloadComponent(2)
        }
    }
    

    private func scrollToDate(date:NSDate) {
        let year = date.yearsFrom(beginDate)
        let month = date.month()
        switch dateFormat {
        case .Year:
             datePicker?.selectRow(year, inComponent: 0, animated: false)
        case .Month:
            datePicker?.selectRow(year, inComponent: 0, animated: false)
            datePicker?.selectRow(month - 1, inComponent: 1, animated: false)
        case .DateAll:
            let day = date.day()
            datePicker?.selectRow(year, inComponent: 0, animated: false)
            datePicker?.selectRow(month - 1, inComponent: 1, animated: false)
            datePicker?.selectRow(day - 1, inComponent: 2, animated: false)
        }
    }
    
    //MARK:Private
    private func getDayCount() -> Int {
        let year = beginDate.dateByAddingYears(datePicker!.selectedRowInComponent(0))
        let month = year.dateByAddingMonths(datePicker!.selectedRowInComponent(1))
        return month.daysInMonth()
    }
    
    private func getDate() -> NSDate {
        switch dateFormat {
        case .Year:
            return beginDate.dateByAddingYears(datePicker!.selectedRowInComponent(0))
        case .Month:
            return beginDate.dateByAddingYears(datePicker!.selectedRowInComponent(0)).dateByAddingMonths(datePicker!.selectedRowInComponent(1))
        case .DateAll:
            return beginDate.dateByAddingYears(datePicker!.selectedRowInComponent(0)).dateByAddingMonths(datePicker!.selectedRowInComponent(1)).dateByAddingDays(datePicker!.selectedRowInComponent(2))
        }
    }
    
    
    
}
