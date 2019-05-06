//
//  NewStopwatchVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit
//import timermodel.swift

class NewStopwatchVC: UIViewController {
    @IBOutlet weak var TimerNameLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let STOPWATCH: Int32 = 0
    let COUNTDOWN: Int32 = 1
    let INTERVAL:Int32 = 2

    @IBAction func AddTapped(_ sender: Any) {
        let type: Int32 = STOPWATCH
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)
            
            currtimer.name = TimerNameLabel.text
            currtimer.numintervals = 0
            currtimer.timervalue = 0
            currtimer.type = type
            print(currtimer)
            //saving
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
