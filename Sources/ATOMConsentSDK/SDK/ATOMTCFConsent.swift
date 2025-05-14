//
//  ATOMConsentManager.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import Foundation

public final class ATOMTCFConsent {
        
    private let consentData: Data
    
    private lazy var validator: ATOMTCFConsentValidator? = {
        try? ATOMTCFConsentValidator(consentData: consentData)
    }()
    
    /// Initialize with a TCF consent string
    /// - Parameter consentString: The TCF consent string
    /// - Throws: ATOMConsentError if the string cannot be parsed
    public init(withConsentString consentString: String) throws {
        do {
            let consentString = consentString.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: ".").first.map(String.init) ?? consentString
            consentData = try ATOMConsentDataParser.parse(consentString: consentString)
        } catch ATOMConsentError.invalidBase64Encoding {
            throw ATOMConsentError.invalidBase64Encoding
        } catch {
            throw ATOMConsentError.parsingFailed
        }
    }
    
    /// Check if a vendor has consent
    /// - Parameter vendorId: The vendor ID to check
    /// - Returns: True if the vendor has consent
    public func isVendorAllowed(_ vendorId: ATOMVendorIdentifier) -> Bool {
        guard let validator else { return false }
        return validator.isVendorAllowed(vendorID: vendorId)
    }
    
    /// Check if a purpose has consent
    /// - Parameter purposeId: The purpose ID to check
    /// - Returns: True if the purpose has consent
    public func isPurposeAllowed(_ purposeId: ATOMPurposeIdentifier) -> Bool {
        guard let validator else { return false }
        return validator.isPurposeConsentAllowed(purposeId)
    }
    
    /// Check if all specified purposes have consent
    /// - Parameter purposeIds: Array of purpose IDs to check
    /// - Returns: True if all purposes have consent
    public func arePurposesAllowed(_ purposeIds: [ATOMPurposeIdentifier]) -> Bool {
        guard let validator else { return false }
        
        for purposeId in purposeIds {
            if !validator.isPurposeConsentAllowed(purposeId) { return false }
        }
        
        return true
    }
    
}
