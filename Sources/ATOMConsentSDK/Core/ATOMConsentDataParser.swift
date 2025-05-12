//
//  ATOMConsentDataParser.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import Foundation

public final class ATOMConsentDataParser {
    
    /// Parses a Base64 encoded consent string into Data.
    ///
    /// - Parameter consentString: The Base64 encoded consent string.
    /// - Returns: The decoded Data.
    /// - Throws: `ATOMConsentError.invalidBase64Encoding` if the string is not valid Base64.
    public static func parse(consentString: String) throws -> Data {
        let paddedString = consentString.base64Padded
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        guard let data = Data(
            base64Encoded: paddedString
        ) else {
            throw ATOMConsentError.invalidBase64Encoding
        }
        
        return data
    }
    
}
