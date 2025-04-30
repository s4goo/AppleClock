//
//  TimeZone+Util.swift
//  AppleClock
//
//  Created by Gunwoo Sun on 4/29/25.
//

import Foundation


fileprivate let formatter = DateFormatter()
fileprivate let offsetFormatter = DateComponentsFormatter()

extension TimeZone {
    var currentTime: String? {
        formatter.timeZone = self
        formatter.dateFormat = "h:mm"
        
        return formatter.string(from: .now)
    }
    
    var timePeriod: String? {
        formatter.timeZone = self
        formatter.dateFormat = "a"
        
        return formatter.string(from: .now)
    }
    
    var city: String? {
        let id = identifier
        let city = id.components(separatedBy: "/").last
        return city
    }
    
    var timeOffset: String? {
        let offset = secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let comp = DateComponents(second: offset)
        let prefix = offset >= 0 ? "+" : ""
        
        
        if offset.isMultiple(of: 3600) {
            offsetFormatter.allowedUnits = [.hour]
            offsetFormatter.unitsStyle = .full
        } else {
            offsetFormatter.allowedUnits = [.hour, .minute]
            offsetFormatter.unitsStyle = .positional
        }
        
        let offsetStr = offsetFormatter.string(from: comp) ?? "\(offset / 3600)시간"
        
        let time = Date(timeIntervalSinceNow: TimeInterval(offset))
        
        let cal = Calendar.current
        if cal.isDateInToday(time) {
            return "오늘, \(prefix)\(offsetStr)"
        } else if cal.isDateInYesterday(time) {
            return "어제, \(prefix)\(offsetStr)"
        } else if cal.isDateInTomorrow(time) {
            return "내일, \(prefix)\(offsetStr)"
        } else {
            return nil
        }
        
    }
}
