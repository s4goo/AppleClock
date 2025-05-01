//
//  WorldClockTableViewCell.swift
//  AppleClock
//
//  Created by Gunwoo Sun on 4/29/25.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {
    
     
    @IBOutlet weak var timeOffsetLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var timePeriodLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet var spacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabelTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        timeLabel.backgroundColor = .systemBackground
        timePeriodLabel.backgroundColor = .systemBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if (self.superview as? UITableView) == nil {
            return
        }
        
        timePeriodLabel.isHidden = editing
        timeLabel.isHidden = editing
        spacingConstraint.isActive = !editing
        timeLabelTrailingConstraint.constant = editing ? -40 : 0
        
        UIView.animate(withDuration: 0.3,) {
            self.layoutIfNeeded()
        }
    }
}
