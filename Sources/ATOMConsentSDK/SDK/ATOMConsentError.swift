//
//  ATOMConsentError.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import Foundation

enum ATOMConsentError: Error {
    case invalidBase64Encoding
    case parsingFailed
    case emptyData
    case invalidFormat
    case vendorIdOutOfRange
}

extension ATOMConsentError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .invalidBase64Encoding:
                return "The consent string is not valid Base64 encoding"
            case .parsingFailed:
                return "Failed to parse the consent data"
            case .emptyData:
                return "The consent data is empty"
            case .invalidFormat:
                return "The consent string format is invalid"
            case .vendorIdOutOfRange:
                return "The vendor ID is out of the allowed range"
        }
    }
}
