//
//  NewCountdownVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class NewCountdownVC: UIViewController {

    let STOPWATCH: Int32 = 0
    let COUNTDOWN: Int32 = 1
    let INTERVAL: Int32 = 2

    @IBOutlet weak var timernamelabel: UITextField!
    @IBOutlet weak var countdown: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func savebutton(_ sender: Any) {
        let type: Int32 = COUNTDOWN
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

    }
    
}