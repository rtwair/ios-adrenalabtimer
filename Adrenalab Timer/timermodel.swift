//
//  timermodel.swift
//  Adrenalab Timer
//
//  Created by Riyad Twair on 6/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import Foundation
import UIKit
struct Timermodel {
    public let STOPWATCH: Int32 = 0
    public let COUNTDOWN: Int32 = 1
    public let INTERVAL: Int32 = 2
    
    enum wodtypes: Int32 {
        case stopwatch, countdown, interval
    }

    static func secondsToTimer(totalseconds: Int32) -> String {
        var minutes: Int32 = 0
        var seconds: Int32 = 0
        minutes = totalseconds / 60
        seconds = totalseconds % 60
        let minsStr = String(format: "%2d", arguments: [minutes])
        let secsStr = String(format: "%02d", arguments: [seconds])
        return minsStr+":"+secsStr
    }
} 
