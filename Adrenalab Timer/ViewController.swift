//
//  ViewController.swift
//  Adrenalab Timer
//
//  Created by Riyad on 5/5/19.
//  Copyright © 2019 rtp. All rights reserved.
//

import UIKit

class listingCell: UITableViewCell {
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
}
class ViewController: UITableViewController {

    var timers: [[Wodtimer]] = [[],[],[]]
    let STOPWATCH = Int(Timermodel.wodtypes.stopwatch.rawValue)
    let COUNTDOWN = Int(Timermodel.wodtypes.countdown.rawValue)
    let INTERVAL = Int(Timermodel.wodtypes.interval.rawValue)

    let sectionImages: [UIImage] = [#imageLiteral(resourceName: "timer"),#imageLiteral(resourceName: "hourglass"),#imageLiteral(resourceName: "stopwatch")]
    
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
        //let cell = listingCell()
        let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell", for: indexPath) as! listingCell
        
        var info = ""
        let valueNum =  Int32(timers[indexPath.section][indexPath.row].timervalue)
        let valueAsStr = Timermodel.secondsToTimer(totalseconds: valueNum)
        
        guard let name = timers[indexPath.section][indexPath.row].name else {
            return cell
        }
        if (indexPath.section == STOPWATCH) {
            info = "stopwatch"
        } else if (indexPath.section == COUNTDOWN) {
            info = "\(valueAsStr)"
        } else if (indexPath.section == INTERVAL) {
            info = "\(timers[indexPath.section][indexPath.row].numintervals) rounds of \(valueAsStr)"
        }

        cell.infoLabel?.text = "\(info)"
        cell.titleLabel?.text = "\(name) \n\(info)"
        
        cell.backgroundColor = .clear
        cell.titleLabel?.textColor = .black
        
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var titleOfSection = ""
        switch section {
        case Int(Timermodel.wodtypes.stopwatch.rawValue):
            titleOfSection = "Stopwatch"
        case Int(Timermodel.wodtypes.countdown.rawValue):
            titleOfSection = "Countdown"
        case Int(Timermodel.wodtypes.interval.rawValue):
            titleOfSection = "Interval"
        default:
            titleOfSection = "\(section)"
        }
        titleOfSection += " timers"
        let view = UIView()

        let label = UILabel()
        label.text = titleOfSection
        label.frame = CGRect(x: 45, y: 5, width: 200, height: 35)
        guard let myfont = UIFont.init(name: "Avenir-Heavy", size: 20) else {
            return nil
        }
        
        label.font = myfont
        
        view.addSubview(label)

        view.backgroundColor = UIColor.init(displayP3Red: 0.42, green: 0.55, blue: 0.62, alpha: 1)
        let image = UIImageView(image: sectionImages[section])
        image.frame = CGRect(x: 5, y: 7, width: 30, height: 30)
        view.addSubview(image)
        
        return view

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(integerLiteral: 45)
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

    @IBAction func editButton(_ sender: Any) {
        setEditing(!isEditing, animated: true)
    }
}

