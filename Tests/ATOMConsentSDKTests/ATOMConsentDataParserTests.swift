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
    
    func testParseUnpaddedBase64String() {
        // Base64 strings should normally be padded with = to make the length a multiple of 4
        // "test" in Base64 is "dGVzdA==" but we'll test with the unpadded "dGVzdA"
        let unpaddedBase64 = "dGVzdA"
        
        do {
            let data = try ATOMConsentDataParser.parse(consentString: unpaddedBase64)
            XCTAssertEqual(String(data: data, encoding: .utf8), "test")
        } catch {
            XCTFail("Parsing failed for unpadded Base64: \(error)")
        }
    }
    
    func testParseEmptyString() {
        let emptyString = ""
        
        do {
            let data = try ATOMConsentDataParser.parse(consentString: emptyString)
            XCTAssertTrue(data.isEmpty, "Empty string should result in empty data")
        } catch {
            XCTFail("Parsing failed for empty string: \(error)")
        }
    }
    
    func testParseBase64WithSpecialCharacters() {
        // Base64 with + and / (which should be preserved)
        let specialCharBase64 = "abc+/12=="
        
        do {
            let data = try ATOMConsentDataParser.parse(consentString: specialCharBase64)
            XCTAssertFalse(data.isEmpty)
        } catch {
            XCTFail("Parsing failed for Base64 with special characters: \(error)")
        }
    }
    
    func testParseBase64WithWhitespace() {
        // Base64 with whitespace (should fail)
        let whitespaceBase64 = "dGVz dA=="
        
        XCTAssertThrowsError(try ATOMConsentDataParser.parse(consentString: whitespaceBase64)) { error in
            XCTAssertEqual(error as? ATOMConsentError, ATOMConsentError.invalidBase64Encoding)
        }
    }
    
}
