import UIKit

class WorldClockViewController: UIViewController {
    
    @IBOutlet weak var worldClockTableView: UITableView!
    
    var timer: Timer?
    
    var list = [
        TimeZone(identifier: "America/Anchorage")!,
        TimeZone(identifier: "Asia/Seoul")!,
        TimeZone(identifier: "Europe/Paris")!,
        TimeZone(identifier: "America/New_York")!,
        TimeZone(identifier: "Asia/Tehran")!
    ]
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        worldClockTableView.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(forName: .timeZoneDidSelect, object: nil, queue: .main) { [weak self] noti in
            guard let self, let timeZone = noti.userInfo?["timeZone"] as? TimeZone else {
                return
            }
            guard !list.contains(timeZone) else { return }
            
            self.list.append(timeZone)
            self.worldClockTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in guard Date.now.minuteChanged, let self else { return }
            
            for cell in self.worldClockTableView.visibleCells {
                guard let clockCell = cell as? WorldClockTableViewCell else { continue }
                guard let indexPath = self.worldClockTableView.indexPath(for: cell) else { continue }
                
                let target = list[indexPath.row]
                clockCell.timeLabel.text = target.currentTime
                if target.timePeriod == "AM" {
                    clockCell.timePeriodLabel.text = "  오전"
                } else if target.timePeriod == "PM" {
                    clockCell.timePeriodLabel.text = "  오후"
                } else {
                    clockCell.timePeriodLabel.text = "  "
                }
                clockCell.timeOffsetLabel.text = target.timeOffset
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
}


extension WorldClockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WorldClockTableViewCell.self), for: indexPath) as! WorldClockTableViewCell
        
        let target = list[indexPath.row]
        cell.timeLabel.text = target.currentTime
        if target.timePeriod == "AM" {
            cell.timePeriodLabel.text = "  오전"
        } else if target.timePeriod == "PM" {
            cell.timePeriodLabel.text = "  오후"
        } else {
            cell.timePeriodLabel.text = "  "
        }
        
        cell.timeZoneLabel.text = target.city
        cell.timeOffsetLabel.text = target.timeOffset
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let target = list.remove(at: sourceIndexPath.row)
        
        
        list.insert(target, at: destinationIndexPath.row)
    }
}

