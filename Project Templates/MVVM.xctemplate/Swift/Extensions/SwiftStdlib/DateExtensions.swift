//
//  DateExtensions.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation

public extension Date {
    // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
    public var iso8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }

    /// SwifterSwift: Check if date is within the current week.
    public var isInCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    public var isInHour: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .hour)
    }
}
