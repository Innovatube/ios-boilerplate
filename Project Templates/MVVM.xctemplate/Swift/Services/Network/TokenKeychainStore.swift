//
//  TokenKeychainStore.swift
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  ___COPYRIGHT___
//

import Foundation
import KeychainAccess
import RxSwift

private let usernameKey = "AuthUsername"
private let passwordKey = "AuthPassword"
private let tokenKey = "AccessToken"
private let tokenRefreshKey = "AccessTokenRefresh"
private let tokenTypeKey = "AccessTokenType"
private let expiryDateKey = "AccessTokenExpiryDate"

struct TokenKeychainStore {
    static let `default`: TokenKeychainStore = TokenKeychainStore()
    private let tokenSubject = PublishSubject<AccessToken>()
    private let keychain: Keychain

    // swiftlint:disable force_unwrapping
    init(keychain: Keychain = Keychain(service: Bundle.main.bundleIdentifier!)) {
        self.keychain = keychain
    }
    // swiftlint:enable force_unwrapping

    func store(token: AccessToken) {
        keychain[usernameKey] = token.username
        keychain[passwordKey] = token.password
        keychain[tokenKey] = token.accessToken
        keychain[tokenRefreshKey] = token.refreshToken
        keychain[tokenTypeKey] = token.tokenType
        keychain[expiryDateKey] = token.expiryDate?.iso8601String

        tokenSubject.onNext(token)
    }

    var currentToken: AccessToken {

        let username = keychain[usernameKey]
        let password = keychain[passwordKey]
        let accessToken = keychain[tokenKey]
        let tokenType = keychain[tokenTypeKey]
        let refreshToken = keychain[tokenRefreshKey]
        let expiryDate = keychain[expiryDateKey]?.iso8601Date

        let token = AccessToken(username: username, password: password, accessToken: accessToken, tokenType: tokenType, refreshToken: refreshToken, expiryDate: expiryDate)
        return token
    }

    func clearToken() {
        keychain[usernameKey] = nil
        keychain[passwordKey] = nil
        keychain[tokenKey] = nil
        keychain[tokenRefreshKey] = nil
        keychain[tokenTypeKey] = nil
        keychain[expiryDateKey] = nil

        tokenSubject.onNext(AccessToken())
    }

    func observeToken() -> Observable<AccessToken> {
        return tokenSubject.startWith(currentToken)
    }
}
