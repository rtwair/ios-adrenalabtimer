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
    var currTimerValue: Int32 = 0
    
    var countingTimer: Timer?
    var timerRunning: Bool = false
    @IBOutlet weak var TimerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        resetView()
    }
    func resetView() {
        guard let timertype = timer?.type else {
            print("error unwrapping")
            return
        }
        if (timertype == Timermodel.wodtypes.stopwatch.rawValue) {
            currTimerValue = 0
            TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
        }
        else if (timertype == Timermodel.wodtypes.countdown.rawValue) {
            guard let timervalue = timer?.timervalue else {
                print("invalid value")
                return
            }
            currTimerValue = timervalue
            TimerLabel.text = Timermodel.secondsToTimer(totalseconds: timervalue)

        } else if (timertype == Timermodel.wodtypes.interval.rawValue) {
            //set up interval view
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    @objc func stopwatchTimer() {
        currTimerValue += 1
        TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
    }
    @objc func countdownTimer() {
        currTimerValue -= 1
        TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
    }
    @IBAction func ResetButton(_ sender: Any) {
        if !timerRunning {
            resetView()
        }
    }
    
    @IBAction func PlayPauseButton(_ sender: Any) {
        guard let timertype = timer?.type else {
            print("invalid type")
            return
        }
        if !timerRunning {
            if (timertype == Timermodel.wodtypes.stopwatch.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopwatchTimer), userInfo: "Tick", repeats: true)
                
            } else if (timertype == Timermodel.wodtypes.countdown.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownTimer), userInfo: "Tick", repeats: true)
            } else if (timertype == Timermodel.wodtypes.interval.rawValue) {
                
            }
            timerRunning = true
        } else {
            countingTimer?.invalidate() // pauses aka stops the timer
            timerRunning = false
        }

    }

}
