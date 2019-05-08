//
//  NewIntervalVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class NewIntervalVC: UIViewController {

    @IBOutlet weak var timername: UITextField!
    @IBOutlet weak var rounds: UITextField!
    @IBOutlet weak var countdown: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func savebutton(_ sender: Any) {
        let type: Int32 = Timermodel.wodtypes.interval.rawValue
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)
            
            if timername.text != "" {
                currtimer.name = timername.text
            } else {
                currtimer.name = "Interval"
            }
            guard let numintervalstext = rounds.text else {
                let alert = UIAlertController(title: "Enter Rounds", message: "Please enter number of rounds.", preferredStyle: .alert)
                self.present(alert, animated: true)
                return
            }
            guard let numintervalsnum = Int32(numintervalstext) else {
                return
            }
            currtimer.numintervals = numintervalsnum
            currtimer.timervalue = Int32(countdown.countDownDuration)
            print("timervalue while creating is \(currtimer.timervalue)")
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
