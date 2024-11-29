//
//  ATOMConsentCCPATests.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 29.11.24.
//

import XCTest
@testable import ATOMConsentSDK

class ATOMConsentCCPATests: XCTestCase {
    
    var sut: ATOMCCPAConsent?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    func testCCPA_Allowed_With_N() {
        guard let sut = try? ATOMCCPAConsent(consentString: "--N-") else {
            fatalError("Could not initialize ATOMCCPAConsent.")
        }
        
        XCTAssertTrue(sut.isCCPACompliant())
    }
    
    func testCCPA_Allowed_With_Dash() {
        guard let sut = try? ATOMCCPAConsent(consentString: "----") else {
            fatalError("Could not initialize ATOMCCPAConsent.")
        }
        
        XCTAssertTrue(sut.isCCPACompliant())
    }
    
    func testCCPA_NOT_Allowed_With_Y() {
        guard let sut = try? ATOMCCPAConsent(consentString: "--Y-") else {
            fatalError("Could not initialize ATOMCCPAConsent.")
        }
        
        XCTAssertFalse(sut.isCCPACompliant())
    }
    
    func testCCPA_NOT_Allowed_With_MoreThan4Characters_5Chars() {
        guard let sut = try? ATOMCCPAConsent(consentString: "--Y--") else {
            fatalError("Could not initialize ATOMCCPAConsent.")
        }
        
        XCTAssertFalse(sut.isCCPACompliant())
    }
    
    func testCCPA_NOT_Allowed_With_LessThan4Characters_3Chars() {
        guard let sut = try? ATOMCCPAConsent(consentString: "--Y") else {
            fatalError("Could not initialize ATOMCCPAConsent.")
        }
        
        XCTAssertFalse(sut.isCCPACompliant())
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
}
