//
//  AccessToken.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation
import ObjectMapper
import RxSwift
import RxOptional

protocol Expirable {
    var expiryDate: Date? { get }

    /// If the token is going to expire in less than this, consider it expired and just get a new token
    var shouldExpireBefore: TimeInterval { get }
}

extension Expirable {
    var expired: Bool {
        if let expiryDate = expiryDate {
            return expiryDate < Date()
        }
        return true
    }

    var willExpireAt: TimeInterval {
        return expiryDate?.timeIntervalSinceNow ?? 0
    }

    var expiresSoon: Observable<Void> {
        let expiresSoonAt = willExpireAt - shouldExpireBefore

        guard expiresSoonAt > 0 else {
            return .just(()) // fire now if it expiresSoonAlready
        }

        return Observable<Int>.timer(expiresSoonAt, scheduler: MainScheduler.instance).map { _ in }
    }
}

public let authenticatioErrorDomain = "AuthenticatioErrorDomain"

struct AccessToken: Expirable {

    let username: String?
    let password: String?
    let accessToken: String?
    let tokenType: String?
    let refreshToken: String?
    let expiryDate: Date?

    var shouldExpireBefore: TimeInterval { return 0 }

    // MARK: - Initializers
    init() {
        self.username = nil
        self.password = nil
        self.accessToken = nil
        self.tokenType = nil
        self.refreshToken = nil
        self.expiryDate = Date()
    }

    init(username: String?, password: String?, accessToken: String?, tokenType: String?, refreshToken: String?, expiryDate: Date?) {
        self.username = username
        self.password = password
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.expiryDate = expiryDate
    }

    var isValid: Bool {
        if let accessToken = accessToken {
            return !accessToken.isEmpty && !expired
        }

        return false
    }

    var shouldRefreshTokenSoon: Observable<String> {
        return expiresSoon
            .map { _ in self.refreshToken }
            .filterNil()
            .filterEmpty()
    }
}

extension AccessToken: ImmutableMappable {

    init(map: Map) throws {
        username = nil
        password = nil

        accessToken = try map.value("accessToken")
        tokenType = try map.value("tokenType")
        refreshToken = try map.value("rememberToken")
        let expiryTimeInterval: Int = try map.value("expiresIn")
        expiryDate = Date().addingTimeInterval(Double(expiryTimeInterval))
    }
}
