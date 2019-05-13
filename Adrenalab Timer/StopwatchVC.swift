//
//  StopwatchVC.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit
import AVFoundation

class StopwatchVC: UIViewController {

    var timer: Wodtimer? = nil
    var currTimerValue: Int32 = 0
    var currRound = 1
    var totalRounds = 1
    var timerComplete = false
    
    var countingTimer: Timer?
    var timerRunning: Bool = false
    var countdownTime: Int = 3
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var resetBtnO: UIButton!
    @IBOutlet weak var TimerLabel: UILabel!
    @IBOutlet weak var RoundNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
        resetView()
        let sound = Bundle.main.path(forResource: "1000", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print("error")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        countingTimer?.invalidate()
        audioPlayer.stop()
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
        
        if countdownTime == -1 {
            audioPlayer.stop()

            currTimerValue += 1
            TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)

        } else {
            if countdownTime != 0 {
                TimerLabel.text = "\(countdownTime)"
            } else {
                TimerLabel.text = "GO!"
                audioPlayer.play()
            }
            countdownTime -= 1

        }
    }
    
    @objc func countdownTimer() {
        if countdownTime == -1 {
            audioPlayer.stop()

            if currTimerValue > 0 {
                currTimerValue -= 1
                TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
            } else {
                audioPlayer.play()
                countingTimer?.invalidate()
                timerRunning = false
                resetBtnO.isHidden = timerRunning
            }

        } else {
            if countdownTime != 0 {
                TimerLabel.text = "\(countdownTime)"
            } else {
                TimerLabel.text = "GO!"
                audioPlayer.play()

            }
            countdownTime -= 1

        }
    }
    
    @objc func intervalTimer() {
        if countdownTime == -1 {
            audioPlayer.stop()

            if (currRound <= totalRounds) {
                if currTimerValue > 0 {
                    currTimerValue -= 1
                    TimerLabel.text = Timermodel.secondsToTimer(totalseconds: currTimerValue)
                } else {
                    currRound += 1
                    audioPlayer.play()
                    if currRound > totalRounds {
                        currRound = totalRounds
                        timerComplete = true
                        countingTimer?.invalidate()
                        timerRunning = false
                        resetBtnO.isHidden = timerRunning
                        playPauseBtn.setImage(UIImage(named: "play.png"), for: UIControl.State.normal)
                        
                    } else {
                        resetView()
                    }
                }
            }
        } else {
            if countdownTime != 0 {
                TimerLabel.text = "\(countdownTime)"
            } else {
                TimerLabel.text = "GO!"
                audioPlayer.play()

            }
            countdownTime -= 1
        }

    }
    
    @IBAction func ResetButton(_ sender: Any) {
        //if !timerRunning {
        currRound = 1
        resetView()
        countdownTime = 3
        //}
    }
    
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBAction func PlayPauseButton(_ sender: Any) {
        guard let timertype = timer?.type else {
            print("invalid type")
            return
        }
        if timerComplete {
            resetView()
            timerComplete = false
        }
        if !timerRunning {
            //resetView()

            playPauseBtn.setImage(UIImage(named: "pause.png"), for: UIControl.State.normal)
            
            if (timertype == Timermodel.wodtypes.stopwatch.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(stopwatchTimer), userInfo: "Tick", repeats: true)
            } else if (timertype == Timermodel.wodtypes.countdown.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdownTimer), userInfo: "Tick", repeats: true)
            } else if (timertype == Timermodel.wodtypes.interval.rawValue) {
                countingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(intervalTimer), userInfo: "Tick", repeats: true)
            }
            timerRunning = true
            resetBtnO.isHidden = timerRunning
        } else {
            countingTimer?.invalidate() // pauses aka stops the timer
            timerRunning = false
            resetBtnO.isHidden = timerRunning
            playPauseBtn.setImage(UIImage(named: "play.png"), for: UIControl.State.normal)
        }
    }

}
