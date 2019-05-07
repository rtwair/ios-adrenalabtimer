//
//  NewCountdownVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class NewCountdownVC: UIViewController {

    @IBOutlet weak var timernamelabel: UITextField!
    @IBOutlet weak var countdown: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func savebutton(_ sender: Any) {
        let type: Int32 = Timermodel.wodtypes.countdown.rawValue
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)

            currtimer.name = timernamelabel.text
            currtimer.numintervals = 0
            currtimer.timervalue = Int32(countdown.countDownDuration)

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
