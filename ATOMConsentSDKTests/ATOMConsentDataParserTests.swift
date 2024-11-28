//
//  ATOMConsentDataParserTests.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import XCTest
@testable import ATOMConsentSDK

class ATOMConsentDataParserTests: XCTestCase {
    
    func testParseValidBase64String() {
        let validBase64String = "dGVzdA==" // "test" in Base64
        do {
            let data = try ATOMConsentDataParser.parse(consentString: validBase64String)
            XCTAssertEqual(String(data: data, encoding: .utf8), "test")
        } catch {
            XCTFail("Parsing failed for a valid Base64 string")
        }
    }
    
    func testParseInvalidBase64String() {
        let invalidBase64String = "invalid.base64"
        XCTAssertThrowsError(try ATOMConsentDataParser.parse(consentString: invalidBase64String)) { error in
            XCTAssertEqual(error as? ATOMConsentError, ATOMConsentError.invalidBase64Encoding)
        }
    }
}
