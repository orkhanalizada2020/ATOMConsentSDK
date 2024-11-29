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
    
    var sut: ATOMTCFConsent?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    func testPurpose_1_Allowed() {
        guard let sut = try? ATOMTCFConsent(withConsentString: tcf) else {
            fatalError("Could not initialize ATOMConsent.")
        }
        
        XCTAssertTrue(sut.isPurposeAllowed(1), "Purpose 1 should be allowed")
    }
    
    func testPurpose_2_NOT_Allowed() {
        guard let sut = try? ATOMTCFConsent(withConsentString: tcf) else {
            fatalError("Could not initialize ATOMConsent.")
        }
        
        XCTAssertFalse(sut.isPurposeAllowed(2), "Purpose 2 should **not** be allowed")
    }
    
    func testPurpose_3_Allowed() {
        guard let sut = try? ATOMTCFConsent(withConsentString: tcf) else {
            fatalError("Could not initialize ATOMConsent.")
        }
        
        XCTAssertTrue(sut.isPurposeAllowed(3), "Purpose 3 should be allowed")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
}
