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

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.setValue(UIColor.white, forKeyPath: "textColor")
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
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(pickerData[component][row])
    }


    @IBAction func savebutton(_ sender: Any) {
        let type: Int32 = Timermodel.wodtypes.countdown.rawValue
        let totalTimeSelected = picker.selectedRow(inComponent: 0) * 3600 + picker.selectedRow(inComponent: 1) * 60 + picker.selectedRow(inComponent: 2)
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
                print("Failed saving")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}

