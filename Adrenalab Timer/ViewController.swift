//
//  ViewController.swift
//  Adrenalab Timer
//
//  Created by Riyad on 5/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {

    var timers: [[Wodtimer]] = [[],[],[]]
    let STOPWATCH = Int(Timermodel.wodtypes.stopwatch.rawValue)
    let COUNTDOWN = Int(Timermodel.wodtypes.countdown.rawValue)
    let INTERVAL = Int(Timermodel.wodtypes.interval.rawValue)

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
        case Int(Timermodel.wodtypes.stopwatch.rawValue):
            return "Stopwatch"
        case Int(Timermodel.wodtypes.countdown.rawValue):
            return "Countdown"
        case Int(Timermodel.wodtypes.interval.rawValue):
            return "Interval"
        default:
            return "\(section)"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return timers.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimer: Wodtimer = timers[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "toTimerVC", sender: selectedTimer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let swatchvc = segue.destination as? StopwatchVC {
            if let selectedtimer = sender as? Wodtimer {
                swatchvc.timer = selectedtimer
            }
        }
    }
    
    @IBAction func AddButton(_ sender: Any) {
    }

}

