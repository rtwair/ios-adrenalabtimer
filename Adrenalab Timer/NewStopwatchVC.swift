//
//  NewStopwatchVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class NewStopwatchVC: UIViewController {
    @IBOutlet weak var TimerNameLabel: UITextField!

    @IBOutlet weak var save: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        parent?.title = "Add Stopwatch"
        save.layer.cornerRadius = 4
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        

    }
    
    @IBAction func AddTapped(_ sender: Any) {
        let type: Int32 = Timermodel.wodtypes.stopwatch.rawValue
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)
            if TimerNameLabel.text != "" {
                currtimer.name = TimerNameLabel.text
            } else {
                currtimer.name = "Stopwatch"
            }
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
        navigationController?.popViewController(animated: true)
    }

}
