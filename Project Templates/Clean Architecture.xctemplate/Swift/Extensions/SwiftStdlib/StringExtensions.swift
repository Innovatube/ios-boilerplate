//
//  StringExtensions.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation

public extension String {
    public var iso8601Date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        return dateFormatter.date(from: self)
    }

    public var localized: String {
        return NSLocalizedString(self, comment: self)
    }

    /// Check if string is valid email format.
    public var isEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return matches(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }

    /// Check if string is valid password format.
    public var isPassword: Bool {
        return matches(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$")
    }

    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Verify if string matches the regex pattern.
    public func matches(pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
}
