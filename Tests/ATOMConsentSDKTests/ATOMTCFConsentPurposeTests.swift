//
//  ATOMConsent.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 28.11.24.
//

import XCTest
@testable import ATOMConsentSDK

class ATOMTCFConsentPurposeTests: XCTestCase {
    
    let tcf: String = "CP24RUAP4HX0AAFADCENAiEgAKAAAAAAAAYgJmtF5Gd_YSZq8Dr3aZt0eYVP99hbasQhBhcBE2QBxLvW_BgRx2ExNA2qpiIKmBIEuXZAIQBlHIHURViAaogVogFkYkGcATEIB6BkgEMQE2cYCFRvmYtjWQCY59p5diax2D8tNYnEzdzjTsVHl3c5NmUkIBCcQ58JDbH9bRKb85IOJ_xsv4r0cF_rgG_WCVn_lcrrbBuudFMavHUiChC9AARAAoAC4AKAAqABwADwAIAASAAugBgAGMANAA1ABwADwAI4ATAAoQBSAFMAKoAWwAxABmADQAG8APQAfgBCACGgEQARIAjgBLACaAE4AKMAYEAygDLAGiAOQAdEA7gDvAHsAPiAfYB-wD_AQAAg4BFICLAIwARqAjgCOgEiAJKASkAmgBOwCfgFBgKgAqIBVwC5gF1AL0AX0Az4BogDXgG0ANwAcQA44B0gDqAHbAPaAfYBEwCL4EeAR7AkQCRYEqASqAmcBNoCdoFHgUiApOBTQFNgKfAVDAqQCpQFVAKsAV2AsKBYgFigLKAWiAtQBbIC3AFwALoAXaAu-BeQF5gL6AX-AwQBgwDDQGIAMhgZGBkgDJwGVAMsAZmAzkBngDRAGjANNAamA1WBrAGsgNeAbQA26BuYG6gN8AcAA4IBx4Dk4HLAcuA58B1gDtgHcgPFAePA8kDygHxQPkA-UB9ID64H2gfdA_YD9wIAgQEAgYBA8CCMEEwQUAgwBBsCEIEKIIWghcBDOCHIIdQQ8BD0CH4EUwI0gRrAjeBHECOgEdgI9gR_AkIBIgCRQEjQJIASSAkoBJkCUYEqAJaQS3BLgCXYEvoJgAmCBMMCYoExwJkwTMBM0IKAAAAA.YAAAAAAAAAAA"
    
    func testPurpose_1_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertTrue(sut.isPurposeAllowed(1), "Purpose 1 should be allowed")
    }
    
    func testPurpose_2_NOT_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertFalse(sut.isPurposeAllowed(2), "Purpose 2 should **not** be allowed")
    }
    
    func testPurpose_3_Allowed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertTrue(sut.isPurposeAllowed(3), "Purpose 3 should be allowed")
    }
    
    func testMultiplePurposes_1_3_Allowed_Should_Succeed() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertTrue(sut.arePurposesAllowed([1, 3]), "Purposes 1 and 3 should be allowed")
    }
    
    func testMultiplePurposes_1_3_Allowed_7_9_10_NOT_Allowed_Should_Fail() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertFalse(sut.arePurposesAllowed([1, 3, 7, 9, 10]), "Purposes 1, 3, 7, 9, and 10 should be allowed")
    }
    
    func testMultiplePurposes_1_3_7_9_10_Allowed_5_NOT_Allowed_Should_Fail() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        XCTAssertFalse(sut.arePurposesAllowed([1, 3, 5, 7, 9, 10]), "Purposes 1, 3, 7, 9, and 10 should be allowed, 5 **not** should be allowed and test should fail.")
    }
    
    func testPurposeBoundaries() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        
        // Test with purpose ID 0 (should be invalid)
        XCTAssertFalse(sut.isPurposeAllowed(0), "Purpose 0 should not be allowed (invalid ID)")
        
        // Test with large purpose ID
        XCTAssertFalse(sut.isPurposeAllowed(50), "Purpose 50 should not be allowed (out of range)")
        
        // Test empty purpose array
        XCTAssertTrue(sut.arePurposesAllowed([]), "Empty purpose array should return true")
    }
    
    func testPurposeCombinations() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        
        // Mix of multiple allowed and disallowed purposes
        XCTAssertFalse(sut.arePurposesAllowed([1, 2, 3]), "Should fail with mix of allowed and disallowed purposes")
        
        // Duplicate purposes
        XCTAssertTrue(sut.arePurposesAllowed([1, 1, 3]), "Duplicate allowed purposes should still be allowed")
        XCTAssertFalse(sut.arePurposesAllowed([1, 2, 2]), "Duplicate disallowed purposes should still be disallowed")
        
        // Purpose IDs in non-sequential order
        XCTAssertTrue(sut.arePurposesAllowed([3, 1]), "Non-sequential allowed purposes should be allowed")
    }
    
    func testTrackingAllowedWithPurposes() throws {
        let sut = try ATOMConsentSDK(tcfConsentString: tcf)
        
        // Test tracking allowed with only purposes, no vendor
        XCTAssertTrue(sut.isTrackingAllowed(purposeIDs: [1, 3]), "Tracking should be allowed with allowed purposes")
        XCTAssertFalse(sut.isTrackingAllowed(purposeIDs: [1, 2]), "Tracking should not be allowed with disallowed purpose")
        
        // Test with empty purpose array
        XCTAssertTrue(sut.isTrackingAllowed(purposeIDs: []), "Tracking should be allowed with empty purpose array")
    }
    
    func testInvalidTCFString() {
        XCTAssertThrowsError(try ATOMConsentSDK(tcfConsentString: "invalidString")) { error in
            XCTAssertTrue(error is ATOMConsentError, "Should throw ATOMConsentError")
        }
    }
    
}
