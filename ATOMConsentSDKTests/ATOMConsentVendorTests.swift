//
//  ATOMConsentVendorTests.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 28.11.24.
//

import XCTest
@testable import ATOMConsentSDK

class ATOMConsentVendorTests: XCTestCase {
    
    let tcf: String = "CP24RUAP4HX0AAFADCENAiEgAKAAAAAAAAYgJmtF5Gd_YSZq8Dr3aZt0eYVP99hbasQhBhcBE2QBxLvW_BgRx2ExNA2qpiIKmBIEuXZAIQBlHIHURViAaogVogFkYkGcATEIB6BkgEMQE2cYCFRvmYtjWQCY59p5diax2D8tNYnEzdzjTsVHl3c5NmUkIBCcQ58JDbH9bRKb85IOJ_xsv4r0cF_rgG_WCVn_lcrrbBuudFMavHUiChC9AARAAoAC4AKAAqABwADwAIAASAAugBgAGMANAA1ABwADwAI4ATAAoQBSAFMAKoAWwAxABmADQAG8APQAfgBCACGgEQARIAjgBLACaAE4AKMAYEAygDLAGiAOQAdEA7gDvAHsAPiAfYB-wD_AQAAg4BFICLAIwARqAjgCOgEiAJKASkAmgBOwCfgFBgKgAqIBVwC5gF1AL0AX0Az4BogDXgG0ANwAcQA44B0gDqAHbAPaAfYBEwCL4EeAR7AkQCRYEqASqAmcBNoCdoFHgUiApOBTQFNgKfAVDAqQCpQFVAKsAV2AsKBYgFigLKAWiAtQBbIC3AFwALoAXaAu-BeQF5gL6AX-AwQBgwDDQGIAMhgZGBkgDJwGVAMsAZmAzkBngDRAGjANNAamA1WBrAGsgNeAbQA26BuYG6gN8AcAA4IBx4Dk4HLAcuA58B1gDtgHcgPFAePA8kDygHxQPkA-UB9ID64H2gfdA_YD9wIAgQEAgYBA8CCMEEwQUAgwBBsCEIEKIIWghcBDOCHIIdQQ8BD0CH4EUwI0gRrAjeBHECOgEdgI9gR_AkIBIgCRQEjQJIASSAkoBJkCUYEqAJaQS3BLgCXYEvoJgAmCBMMCYoExwJkwTMBM0IKAAAAA.YAAAAAAAAAAA"
    
    var sut: ATOMConsent?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    func testVendor_99_NOT_Allowed() {
        guard let sut = try? ATOMConsent(withConsentString: tcf) else {
            fatalError("Could not initialize ATOMConsent.")
        }
        
        XCTAssertFalse(sut.isVendorAllowed(99), "Vendor 99 should **not** be allowed")
    }
    
    func testVendor_100_Allowed() {
        guard let sut = try? ATOMConsent(withConsentString: tcf) else {
            fatalError("Could not initialize ATOMConsent.")
        }
        
        XCTAssertTrue(sut.isVendorAllowed(100), "Vendor 100 should be allowed")
    }
    
    func testVendor_512_NOT_Allowed() {
        guard let sut = try? ATOMConsent(withConsentString: tcf) else {
            fatalError("Could not initialize ATOMConsent.")
        }
        
        XCTAssertTrue(sut.isVendorAllowed(512), "Vendor 512 should be allowed")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
}
