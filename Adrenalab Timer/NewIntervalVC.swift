//
//  NewIntervalVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class NewIntervalVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timername: UITextField!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var roundPicker: UIPickerView!
    
    var pickerData: [[Int]] = [[Int]]()
    var totalRounds: [Int] = [Int]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        parent?.title = "Add Interval Timer"
        
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self
        
        self.roundPicker.delegate = self
        self.roundPicker.dataSource = self
        
        totalRounds = Array(1...99)
        // Input the data into the array
        let hours = Array(0...9)
        let minutes = Array(0...59)
        let seconds = Array(0...59)
        pickerData = [hours,minutes,seconds]

    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        timername.endEditing(true)
    }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 3

        } else {
            return 1
        }
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return pickerData[component].count

        } else {
            return totalRounds.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return "\(pickerData[component][row]) Hour"
            case 1:
                return "\(pickerData[component][row]) Mins"
            case 2:
                return "\(pickerData[component][row]) Secs"
            default:
                return String(pickerData[component][row])
            }
            //return String(pickerData[component][row])

        } else {
            return "\(totalRounds[row]) rounds"
        }
    }

    @IBAction func savebutton(_ sender: Any) {
        let type: Int32 = Timermodel.wodtypes.interval.rawValue
        let totalTimeSelected = picker.selectedRow(inComponent: 0) * 3600 + picker.selectedRow(inComponent: 1) * 60 + picker.selectedRow(inComponent: 2)
        if totalTimeSelected == 0 {
            let alert = UIAlertController(title: "ERROR", message: "Interval countdown timer is currently set to 0.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert,animated: true)
            return
        }
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)
            
            if timername.text != "" {
                currtimer.name = timername.text
            } else {
                currtimer.name = "Interval"
            }
            let numintervalsnum: Int32 = Int32(roundPicker.selectedRow(inComponent: 0))
            currtimer.numintervals = numintervalsnum
            currtimer.timervalue = Int32(totalTimeSelected)
            currtimer.type = type
            //saving
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
