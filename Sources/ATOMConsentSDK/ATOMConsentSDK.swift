//
//  ATOMConsentSDK.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 09.05.25.
//

public final class ATOMConsentSDK {
    
    private var tcfConsent: ATOMTCFConsent?
    private var ccpaConsent: ATOMCCPAConsent?
    
    /// Initialize with optional TCF and CCPA consent instances
    /// - Parameters:
    ///   - tcfConsent: TCF consent instance
    ///   - ccpaConsent: CCPA consent instance
    init(tcfConsent: ATOMTCFConsent? = nil, ccpaConsent: ATOMCCPAConsent? = nil) {
        self.tcfConsent = tcfConsent
        self.ccpaConsent = ccpaConsent
    }
    
    /// Initialize with TCF consent only
    /// - Parameter tcfConsent: TCF consent instance
    convenience init(tcfConsent: ATOMTCFConsent) {
        self.init(tcfConsent: tcfConsent, ccpaConsent: nil)
    }
    
    /// Initialize with CCPA consent only
    /// - Parameter ccpaConsent: CCPA consent instance
    convenience init(ccpaConsent: ATOMCCPAConsent) {
        self.init(tcfConsent: nil, ccpaConsent: ccpaConsent)
    }
    
    /// Initialize with consent strings
    /// - Parameters:
    ///   - tcfConsentString: TCF consent string
    /// - Throws: ATOMConsentError if any consent string is invalid
    public convenience init(tcfConsentString: String? = nil) throws {
        var tcfConsent: ATOMTCFConsent?
        
        if let tcfString = tcfConsentString {
            tcfConsent = try ATOMTCFConsent(withConsentString: tcfString)
        }
        
        self.init(tcfConsent: tcfConsent)
    }
    
    /// Initialize with consent strings
    /// - Parameters:
    ///   - ccpaConsentString: CCPA consent string
    /// - Throws: ATOMConsentError if any consent string is invalid
    public convenience init(ccpaConsentString: String? = nil) throws {
        var ccpaConsent: ATOMCCPAConsent?
        
        if let ccpaString = ccpaConsentString {
            ccpaConsent = try ATOMCCPAConsent(consentString: ccpaString)
        }
        
        self.init(ccpaConsent: ccpaConsent)
    }
    
    /// Initialize with consent strings
    /// - Parameters:
    ///   - tcfConsentString: TCF consent string
    /// - Throws: ATOMConsentError if any consent string is invalid
    public convenience init(tcfConsentString: String? = nil, ccpaConsentString: String? = nil) throws {
        var tcfConsent: ATOMTCFConsent?
        var ccpaConsent: ATOMCCPAConsent?
                
        if let tcfString = tcfConsentString {
            tcfConsent = try ATOMTCFConsent(withConsentString: tcfString)
        }
        
        if let ccpaString = ccpaConsentString {
            ccpaConsent = try ATOMCCPAConsent(consentString: ccpaString)
        }
        
        self.init(tcfConsent: tcfConsent, ccpaConsent: ccpaConsent)
    }
    
    
    public func isSubjectToGDPR() -> Bool {
        ATOMGDPRLocationDetector.isSubjectToLocationAware()
    }
    
    public func isSubjectToCCPA() -> Bool {
        ATOMLGPDLocationDetector.isSubjectToLocationAware()
    }
    
    /// Check if a vendor has consent based on TCF
    /// - Parameter vendorId: The vendor ID to check
    /// - Returns: True if the vendor has consent, false if no consent or TCF not available
    public func isVendorAllowed(_ vendorID: ATOMVendorIdentifier) -> Bool {
        return tcfConsent?.isVendorAllowed(vendorID) ?? false
    }
    
    /// Check if a purpose has consent based on TCF
    /// - Parameter purposeId: The purpose ID to check
    /// - Returns: True if the purpose has consent, false if no consent or TCF not available
    public func isPurposeAllowed(_ purposeID: ATOMPurposeIdentifier) -> Bool {
        return tcfConsent?.isPurposeAllowed(purposeID) ?? false
    }
    
    /// Check if all purposes have consent based on TCF
    /// - Parameter purposesID: The purpose IDs to check
    /// - Returns: True if all the purposes have consent, false if no consent or TCF not available
    public func arePurposesAllowed(_ purposesID: [ATOMPurposeIdentifier]) -> Bool {
        return tcfConsent?.arePurposesAllowed(purposesID) ?? false
    }
    
    /// Check if sale of personal information is allowed based on CCPA
    /// - Returns: True if sale is allowed, false if user opted out or CCPA not available
    public func isSaleAllowed() -> Bool {
        return ccpaConsent?.isSaleAllowed() ?? false
    }
    
    /// Check if tracking is allowed based on all available consent frameworks
    /// - Parameters:
    ///   - vendorId: Optional vendor ID for TCF check
    ///   - purposeIds: Optional purpose IDs for TCF check
    /// - Returns: True if tracking is allowed across all applicable frameworks
    public func isTrackingAllowed(vendorID: ATOMVendorIdentifier? = nil,
                                  purposeIDs: [ATOMPurposeIdentifier]? = nil) -> Bool {
        // If CCPA is present and user opted out, tracking is not allowed
        if let ccpa = ccpaConsent, !ccpa.isSaleAllowed() {
            return false
        }
        
        // If TCF is present, check vendor and purposes
        if let tcf = tcfConsent {
            if let vendorID, !tcf.isVendorAllowed(vendorID) {
                return false
            }
            
            if let purposeIDs, !tcf.arePurposesAllowed(purposeIDs) {
                return false
            }
        }
        
        // Default to allowed if no restrictions found
        return true
    }
    
}
