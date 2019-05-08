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
    var currRound = 1
    var totalRounds = 1
    
    var countingTimer: Timer?
    var timerRunning: Bool = false
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var RoundNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        resetView()
    }
    func resetView() {
        RoundNumber.isHidden = true
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
            guard let timervalue = timer?.timervalue else {
                return
            }
            guard let numrounds = timer?.numintervals else {
                return
            }
            currTimerValue = timervalue
            print("currtimevalue is = \(currTimerValue)")
            totalRounds = Int(numrounds)
            RoundNumber.isHidden = false
            TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
            RoundNumber.text = "Round \(currRound) / \(numrounds)"
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
        if currTimerValue > 0 {
            currTimerValue -= 1
            TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
        } else {
            countingTimer?.invalidate()
            timerRunning = false
        }
    }
    
    @objc func intervalTimer() {
        if (currRound <= totalRounds) {
            if currTimerValue > 0 {
                currTimerValue -= 1
                TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
            } else {
                currRound += 1
                if currRound > totalRounds {
                    currRound = totalRounds
                    countingTimer?.invalidate()
                    timerRunning = false
                    playPauseBtn.setImage(UIImage(named: "play.png"), for: UIControl.State.normal)

                } else {
                    resetView()
                }
            }
        }
    }
    
    @IBAction func ResetButton(_ sender: Any) {
        if !timerRunning {
            resetView()
        }
    }
    
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBAction func PlayPauseButton(_ sender: Any) {
        guard let timertype = timer?.type else {
            print("invalid type")
            return
        }
        if !timerRunning {
            resetView()

            playPauseBtn.setImage(UIImage(named: "pause.png"), for: UIControl.State.normal)

            if (timertype == Timermodel.wodtypes.stopwatch.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopwatchTimer), userInfo: "Tick", repeats: true)
            } else if (timertype == Timermodel.wodtypes.countdown.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownTimer), userInfo: "Tick", repeats: true)
            } else if (timertype == Timermodel.wodtypes.interval.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(intervalTimer), userInfo: "Tick", repeats: true)
            }
            timerRunning = true
        } else {
            countingTimer?.invalidate() // pauses aka stops the timer
            timerRunning = false
            playPauseBtn.setImage(UIImage(named: "play.png"), for: UIControl.State.normal)
        }
    }

}
