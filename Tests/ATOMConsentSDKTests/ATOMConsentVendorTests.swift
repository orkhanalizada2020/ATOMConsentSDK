//
//  ATOMConsentVendorTests.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 28.11.24.
//

import XCTest
@testable import ATOMConsentSDK

class ATOMTCFConsentVendorTests: XCTestCase {
    
    let tcf: String = "CP24RUAP4HX0AAFADCENAiEgAKAAAAAAAAYgJmtF5Gd_YSZq8Dr3aZt0eYVP99hbasQhBhcBE2QBxLvW_BgRx2ExNA2qpiIKmBIEuXZAIQBlHIHURViAaogVogFkYkGcATEIB6BkgEMQE2cYCFRvmYtjWQCY59p5diax2D8tNYnEzdzjTsVHl3c5NmUkIBCcQ58JDbH9bRKb85IOJ_xsv4r0cF_rgG_WCVn_lcrrbBuudFMavHUiChC9AARAAoAC4AKAAqABwADwAIAASAAugBgAGMANAA1ABwADwAI4ATAAoQBSAFMAKoAWwAxABmADQAG8APQAfgBCACGgEQARIAjgBLACaAE4AKMAYEAygDLAGiAOQAdEA7gDvAHsAPiAfYB-wD_AQAAg4BFICLAIwARqAjgCOgEiAJKASkAmgBOwCfgFBgKgAqIBVwC5gF1AL0AX0Az4BogDXgG0ANwAcQA44B0gDqAHbAPaAfYBEwCL4EeAR7AkQCRYEqASqAmcBNoCdoFHgUiApOBTQFNgKfAVDAqQCpQFVAKsAV2AsKBYgFigLKAWiAtQBbIC3AFwALoAXaAu-BeQF5gL6AX-AwQBgwDDQGIAMhgZGBkgDJwGVAMsAZmAzkBngDRAGjANNAamA1WBrAGsgNeAbQA26BuYG6gN8AcAA4IBx4Dk4HLAcuA58B1gDtgHcgPFAePA8kDygHxQPkA-UB9ID64H2gfdA_YD9wIAgQEAgYBA8CCMEEwQUAgwBBsCEIEKIIWghcBDOCHIIdQQ8BD0CH4EUwI0gRrAjeBHECOgEdgI9gR_AkIBIgCRQEjQJIASSAkoBJkCUYEqAJaQS3BLgCXYEvoJgAmCBMMCYoExwJkwTMBM0IKAAAAA.YAAAAAAAAAAA"
    
    func testVendor_99_NOT_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertFalse(sut.isVendorAllowed(99), "Vendor 99 should **not** be allowed")
    }
    
    func testVendor_494_NOT_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertFalse(sut.isVendorAllowed(494), "Vendor 494 should **not** be allowed")
    }
    
    func testVendor_100_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertTrue(sut.isVendorAllowed(100), "Vendor 100 should be allowed")
    }
    
    func testVendor_512_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertTrue(sut.isVendorAllowed(512), "Vendor 512 should be allowed")
    }
    
    func testDirectTCFConsentInit() throws {
        let tcfConsent = try ATOMTCFConsent(withConsentString: tcf)
        XCTAssertTrue(tcfConsent.isVendorAllowed(100), "Direct TCFConsent should report vendor 100 as allowed")
        XCTAssertFalse(tcfConsent.isVendorAllowed(99), "Direct TCFConsent should report vendor 99 as not allowed")
    }
    
    func testInvalidTCFString() {
        XCTAssertThrowsError(try ATOMConsentSDK(tcfConsentString: "invalidString")) { error in
            XCTAssertTrue(error is ATOMConsentError, "Should throw ATOMConsentError")
        }
    }
    
    func testVendorIDOutOfRange() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertFalse(sut.isVendorAllowed(10000), "Vendor 10000 should be out of range and not allowed")
    }
    
    func testEdgeCaseVendorIDs() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        
        // Test with vendor ID 0 (should be invalid)
        XCTAssertFalse(sut.isVendorAllowed(0), "Vendor 0 should not be allowed (invalid ID)")
        
        // Test with max valid vendor ID from the consent data
        let validator = try ATOMTCFConsentValidator(consentData: try ATOMConsentDataParser.parse(consentString: tcf.split(separator: ".").first.map(String.init) ?? tcf))
        let maxVendorId = validator.maxVendorIdForConsents
        
        XCTAssertFalse(sut.isVendorAllowed(Int16(Int(maxVendorId) + 1)), "Vendor beyond max should not be allowed")
    }
    
    func testMultipleVendors() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        
        let allowedVendors: [Int16] = [100, 512]
        for vendorId in allowedVendors {
            XCTAssertTrue(sut.isVendorAllowed(vendorId), "Vendor \(vendorId) should be allowed")
        }
        
        let disallowedVendors: [Int16] = [99, 494]
        for vendorId in disallowedVendors {
            XCTAssertFalse(sut.isVendorAllowed(vendorId), "Vendor \(vendorId) should not be allowed")
        }
    }
    
}
