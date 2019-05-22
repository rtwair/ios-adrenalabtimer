//
//  NewCountdownVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class NewCountdownVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timernamelabel: UITextField!
    @IBOutlet weak var countdown: UIDatePicker!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    var pickerData: [[Int]] = [[Int]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        parent?.title = "Add Countdown"
        // Connect data:
        self.picker.delegate = self
        self.picker.dataSource = self

        // Input the data into the array
        let hours = Array(0...9)
        let minutes = Array(0...59)
        let seconds = Array(0...59)
        pickerData = [hours,minutes,seconds]
        saveButton.layer.cornerRadius = 4



    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //picker.setValue(UIColor.white, forKeyPath: "textColor")
        
        // Do any additional setup after loading the view.
    }
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
    }
    
    //formatting using a delegate?
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var titleData = ""
        
        switch component {
        case 0:
            titleData = "\(pickerData[component][row]) Hour"
        case 1:
            titleData = "\(pickerData[component][row]) Mins"
        case 2:
            titleData = "\(pickerData[component][row]) Secs"
        default:
            titleData = String(pickerData[component][row])
        }

        
        //let titleData = "\(pickerData[component][row])"
        //let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Avenir-Heavy", size: 18.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
        pickerLabel.text = titleData
        pickerLabel.font = UIFont(name: "Avenir", size: 19.0)
        pickerLabel.textAlignment = .center
            
            return pickerLabel

    }
    // The data to return fopr the row and component (column) that's being passed in
   /* func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    }*/


    @IBAction func savebutton(_ sender: Any) {
        let type: Int32 = Timermodel.wodtypes.countdown.rawValue
        let totalTimeSelected = picker.selectedRow(inComponent: 0) * 3600 + picker.selectedRow(inComponent: 1) * 60 + picker.selectedRow(inComponent: 2)
        if totalTimeSelected == 0 {
            let alert = UIAlertController(title: "No Duration", message: "Please choose a countodwn timer duration.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert,animated: true)
            return
        }

        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)
            if timernamelabel.text != "" {
                currtimer.name = timernamelabel.text
            } else {
                currtimer.name = "Countdown"
            }
            currtimer.numintervals = 0
            currtimer.timervalue = Int32(totalTimeSelected)

            currtimer.type = type
            //saving
            do {
                try context.save()
            } catch {
                print("Failed to save context")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}

