//
//  StopwatchVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class StopwatchVC: UIViewController {

    var timer: Wodtimer? = nil
    
    @IBOutlet weak var TimerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)

        guard let timertype = timer?.type else {
            print("error unwrapping")
            return
        }
        
        if (timertype == Timermodel.wodtypes.countdown.rawValue) {
            guard let timervalue = timer?.timervalue else {
                print("invalid value")
                return
            }
            TimerLabel.text = Timermodel.secondsToTimer(totalseconds: timervalue)
            print("i'm a countdown with timer value of \(timervalue)")
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    @IBAction func ResetButton(_ sender: Any) {
    }
    @IBAction func PlayPauseButton(_ sender: Any) {
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
