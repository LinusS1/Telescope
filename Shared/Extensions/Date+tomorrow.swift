//
//  Date+tomorrow.swift
//  Date+tomorrow
//
//  Created by Linus Skucas on 9/4/21.
//

import Foundation

public extension Date {
    func sameTimeNextDay(
        inDirection direction: Calendar.SearchDirection = .forward,
        using calendar: Calendar = .current
    ) -> Date {
        let components = calendar.dateComponents(
            [.hour, .minute, .second, .nanosecond],
            from: self
        )
        
        return calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: .nextTime,
            direction: direction
        )!
    }
}

public extension Date {
    static var currentTimeTomorrow: Date {
        return Date().sameTimeNextDay()
    }
    
    static var currentTimeYesterday: Date {
        return Date().sameTimeNextDay(inDirection: .backward)
    }
}
