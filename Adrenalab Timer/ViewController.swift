//
//  ViewController.swift
//  Adrenalab Timer
//
//  Created by Riyad on 5/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

struct wodtimer {
    var name: String = ""
    enum wodtypes: Int32 {
        case stopwatch, countdown, interval
    }
    var numintervals: Int = 1
    var timervalue: Int = 0
    
    var type = wodtypes.stopwatch

    //default constuctor with only name we will assume it is a stopwatch
    init(name: String) {
        self.name = name
        self.type = wodtypes.stopwatch
    }
    //countdown constructor
    init(name: String, type: wodtypes, timervalue: Int) {
        self.name = name
        self.type = type
        self.timervalue = timervalue
    }
    //interval type
    init(name: String, type: wodtypes, timervalue: Int, numintervals: Int) {
        self.name = name
        self.type = type
        self.timervalue = timervalue
        self.numintervals = numintervals
    }
}



class ViewController: UITableViewController {

    var timers: [[Wodtimer]] = [[],[],[]]
    let STOPWATCH = 0
    let COUNTDOWN = 1
    let INTERVAL = 2

    override func viewDidAppear(_ animated: Bool) {
        fetchUserTimers()

    }
    
    func fetchUserTimers() {
        timers = [[],[],[]]
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let entityFromCD = try? context.fetch(Wodtimer.fetchRequest()) {
                if let tempEntityFromCD = entityFromCD as? [Wodtimer] {
                    for timer in tempEntityFromCD {
                        if timer.type == STOPWATCH {
                            timers[STOPWATCH].append(timer)
                        } else if timer.type == COUNTDOWN {
                            timers[COUNTDOWN].append(timer)
                        } else if timer.type == INTERVAL {
                            timers[INTERVAL].append(timer)
                        }
                    }
                    tableView.reloadData()
                }
            }
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = timers[indexPath.section][indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return timers[section].count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let objToDelete = timers[indexPath.section][indexPath.row]
                
                context.delete(objToDelete)
                do {
                    try context.save()
                } catch {
                    print("couldn't save error!")
                }
            }
        }
        fetchUserTimers()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case STOPWATCH:
            return "Stopwatch"
        case COUNTDOWN:
            return "Countdown"
        case INTERVAL:
            return "Interval"
        default:
            return "\(section)"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return timers.count
    }

    @IBAction func AddButton(_ sender: Any) {
        let type: Int32 = wodtimer.wodtypes.countdown.rawValue
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let currtimer = Wodtimer(context: context)
            
            currtimer.name = "int"
            currtimer.numintervals = 1
            currtimer.timervalue = 1
            currtimer.type = type
            print(currtimer)
            //saving
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        fetchUserTimers()
    }

}

