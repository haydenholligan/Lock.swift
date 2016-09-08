// OptionBuildable.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/**
 *  Lock options
 */
public protocol OptionBuildable: Options {

        /// Allows Lock to be dismissed. By default is false.
    var closable: Bool { get set }

        /// ToS URL. By default is Auth0's.
    var termsOfServiceURL: NSURL { get set }

        /// Privacy Policy URL. By default is Auth0's.
    var privacyPolicyURL: NSURL { get set }

        /// Log level for Lock. By default is `Off`.
    var logLevel: LoggerLevel { get set }

        /// Log output used when Log is enabled. By default a simple `print` statement is used.
    var loggerOutput: LoggerOutput? { get set }

        /// If request from Auth0.swift should be logged or not.
    var logHttpRequest: Bool { get set }

        /// Scope used for authentication. By default is `openid`.
    var scope: String { get set }

        /// Authentication parameters sent with every authentication requests. By default is an empty dictionary.
    var parameters: [String: AnyObject] { get set }

        /// What database modes are allowed and must be at least one. By default all modes are allowed.
    var allow: DatabaseMode { get set }

        /// Initial screen displayed by Lock when a database connection is available. By default is Login
    var initialScreen: DatabaseScreen { get set }

    /**
     Specify what type of identifier the database login will require to the user when the connection `requires_username` flag is true.
     The possible values are email, username or both and by default it will require both.
     - important: This option is ignored if the database does not require a username (when `requires_username` is false)
    */
    var usernameStyle: DatabaseIdentifierStyle { get set }
}

internal extension OptionBuildable {
    func validate() -> UnrecoverableError? {
        guard !self.allow.isEmpty else { return UnrecoverableError.InvalidOptions(cause: "Must allow at least one database mode") }
        guard !self.usernameStyle.isEmpty else { return UnrecoverableError.InvalidOptions(cause: "Must specify at least one username style") }
        return nil
    }
}

public extension OptionBuildable {

        /// ToS URL. By default is Auth0's
    var termsOfService: String {
        get {
            return self.termsOfServiceURL.absoluteString
        }
        set {
            guard let url = NSURL(string: newValue) else { return } // FIXME: log error
            self.termsOfServiceURL = url
        }
    }

        /// Privacy Policy URL. By default is Auth0's
    var privacyPolicy: String {
        get {
            return self.privacyPolicyURL.absoluteString
        }
        set {
            guard let url = NSURL(string: newValue) else { return } // FIXME: log error
            self.privacyPolicyURL = url
        }
    }
}