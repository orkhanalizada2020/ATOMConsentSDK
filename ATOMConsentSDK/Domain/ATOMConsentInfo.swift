//
//  ATOMConsentInfo.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import Foundation

public typealias ATOMVendorIdentifier = Int16
public typealias ATOMPurposeIdentifier = Int16

public struct ATOMConsentInfo {
    
    private let consentData: Data
    
    /// Initialize with consent data
    /// - Parameter consentData: The decoded consent data
    /// - Throws: `ATOMConsentError.emptyData` if the data is empty
    init(withConsentData consentData: Data) throws {
        guard !consentData.isEmpty else {
            throw ATOMConsentError.emptyData
        }
        self.consentData = consentData
    }
    
    /// The date when the consent was created
    public var dateCreated: Date {
        dateFromDeciSeconds(consentData.intValue(for: NSRange.created))
    }
    
    /// The date when the consent was last updated
    public var dateUpdated: Date {
        dateFromDeciSeconds(consentData.intValue(for: NSRange.created))
    }
    
    /// The ID of the Consent Management Platform
    public var cmpId: Int {
        Int(consentData.intValue(for: NSRange.cmpIdentifier))
    }
    
    /// The consent screen ID
    public var consentScreen: Int {
        Int(consentData.intValue(for: NSRange.consentScreen))
    }
    
    /// The language of the consent
    public var consentLanguage: String {
        extractString(from: consentData.data(for: .consentLanguage))
    }
    
    /// The publisher's country code
    public var publisherCC: String {
        extractString(from: consentData.data(for: NSRange.publisherCC))
    }
    
    /// The version of the vendor list
    public var vendorListVersion: Int16 {
        ATOMVendorIdentifier(consentData.intValue(for: NSRange.vendorListVersion))
    }
    
    /// The version of the TCF policy
    public var tfcPolicyVersion: Int16 {
        Int16(consentData.intValue(for: NSRange.tcfPolicyVersion))
    }
    
    /// Indicates if the consent is service specific
    public var isServiceSpecific: Bool {
        Int16(consentData.intValue(for: NSRange.isServiceSpecific)) == 1
    }
    
    /// Indicates if non-standard texts were used
    public var useNonStandardTexts: Bool {
        Int16(consentData.intValue(for: NSRange.useNonStandardTexts)) == 1
    }
    
    /// Special treatment for purpose one
    public var purposeOneTreatment: Int16 {
        ATOMPurposeIdentifier(consentData.intValue(for: NSRange.purposeOneTreatment))
    }
    
    /// Set of purpose IDs that have user consent
    public var purposeConsents: Set<ATOMPurposeIdentifier> {
        extractPurposes(from: NSRange.purposesConsent)
    }
    
    /// Check if a specific purpose has consent
    /// - Parameter purposeId: The purpose ID to check
    /// - Returns: True if the purpose has consent
    public func purposeConsent(forPurposeId purposeId: ATOMPurposeIdentifier) -> Bool {
        purposeConsents.contains(purposeId)
    }
    
    /// Set of purpose IDs that have legitimate interest
    public var purposeLegitimateInterests: Set<ATOMPurposeIdentifier> {
        extractPurposes(from: NSRange.purposesLITransparency)
    }
    
    /// Check if a specific purpose has legitimate interest
    /// - Parameter purposeId: The purpose ID to check
    /// - Returns: True if the purpose has legitimate interest
    public func purposeLegitimateInterest(forPurposeId purposeId: ATOMPurposeIdentifier) -> Bool {
        purposeLegitimateInterests.contains(purposeId)
    }
    
}

// MARK: - Helpers

extension ATOMConsentInfo {
    
    private func dateFromDeciSeconds(_ deciSeconds: Int64) -> Date {
        let timeIntervalDecseconds = Int(deciSeconds)
        let timeInterval = TimeInterval(timeIntervalDecseconds / 10)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    private func extractString(from data: Data) -> String {
        var data = data
        data.insert(0, at: 0)
        let string = data.base64EncodedString()
        return String(string[string.index(string.startIndex, offsetBy: 2)...])
    }
    
    private func extractPurposes(from range: NSRange) -> Set<ATOMPurposeIdentifier> {
        var results = Set<ATOMPurposeIdentifier>()
        for purposeId in 1...range.length {
            let purposeBit = Int64(range.lowerBound - 1 + purposeId)
            let value = Int(consentData.intValue(fromBit: purposeBit, toBit: purposeBit))
            if value > 0 {
                results.insert(ATOMPurposeIdentifier(purposeId))
            }
        }
        return results
    }
}
