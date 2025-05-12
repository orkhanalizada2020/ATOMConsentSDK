//
//  ATOMConsentCCPATests.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 29.11.24.
//

import XCTest
@testable import ATOMConsentSDK

class ATOMConsentCCPATests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    // MARK: - CCPA Format Tests
    
    func testCCPA_Allowed_With_N() throws {
        let sut = try ATOMConsentSDK(ccpaConsentString: "--N-")
        XCTAssertTrue(sut.isSaleAllowed())
    }
    
    func testCCPA_Allowed_With_Dash() throws {
        let sut = try ATOMConsentSDK(ccpaConsentString: "----")
        XCTAssertTrue(sut.isSaleAllowed())
    }
    
    func testCCPA_NOT_Allowed_With_Y() throws {
        let sut = try ATOMConsentSDK(ccpaConsentString: "--Y-")
        XCTAssertFalse(sut.isSaleAllowed())
    }
    
    func testCCPA_NOT_Allowed_With_MoreThan4Characters_5Chars() throws {
        XCTAssertThrowsError(try ATOMConsentSDK(ccpaConsentString: "--Y--")) { error in
            XCTAssertEqual(error as? ATOMConsentError, .invalidFormat)
        }
    }
    
    func testCCPA_NOT_Allowed_With_LessThan4Characters_3Chars() {
        XCTAssertThrowsError(try ATOMConsentSDK(ccpaConsentString: "--Y")) { error in
            XCTAssertEqual(error as? ATOMConsentError, .invalidFormat)
        }
    }
    
    func testCCPA_Case_Sensitivity() throws {
        let sut1 = try ATOMConsentSDK(ccpaConsentString: "--y-")
        XCTAssertFalse(sut1.isSaleAllowed(), "Should recognize lowercase 'y' as opt-out")
        
        let sut2 = try ATOMConsentSDK(ccpaConsentString: "--n-")
        XCTAssertTrue(sut2.isSaleAllowed(), "Should recognize lowercase 'n' as not opted-out")
    }
    
    func testCCPAConsent_Direct_Initialization() throws {
        let consent = try ATOMCCPAConsent(consentString: "--N-")
        XCTAssertTrue(consent.isSaleAllowed())
        
        let consentOptOut = try ATOMCCPAConsent(consentString: "--Y-")
        XCTAssertFalse(consentOptOut.isSaleAllowed())
    }
    
    func testCCPA_With_Unusual_Characters() throws {
        let sut = try ATOMConsentSDK(ccpaConsentString: "?X!N")
        XCTAssertTrue(sut.isSaleAllowed(), "Sale should be allowed with valid length and 'N' opt-out")
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}
