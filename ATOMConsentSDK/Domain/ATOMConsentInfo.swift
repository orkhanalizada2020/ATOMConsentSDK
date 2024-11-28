//
//  ATOMConsentInfo.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

public typealias ATOMVendorIdentifier = Int16
public typealias ATOMPurposeIdentifier = Int16

public struct ATOMConsentInfo {
    
    private let consentData: Data
    
    init(withConsentData consentData: Data) throws {
        guard !consentData.isEmpty else {
            throw ATOMConsentError.emptyData
        }
        self.consentData = consentData
    }
    
    public var dateCreated: Date {
        let timeIntervalDecseconds = Int(consentData.intValue(for: NSRange.created))
        let timeInterval = TimeInterval(timeIntervalDecseconds / 10)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    public var dateUpdated: Date {
        let timeIntervalDecseconds = Int(consentData.intValue(for: NSRange.created))
        let timeInterval = TimeInterval(timeIntervalDecseconds / 10)
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    public var cmpId: Int {
        return Int(consentData.intValue(for: NSRange.cmpIdentifier))
    }
    
    public var consentScreen: Int {
        return Int(consentData.intValue(for: NSRange.consentScreen))
    }
    
    public var consentLanguage: String {
        var data = consentData.data(for: .consentLanguage)
        data.insert(0, at: 0)
        let string = data.base64EncodedString()
        return String(string[string.index(string.startIndex, offsetBy: 2)...])
    }
    
    public var publisherCC: String {
        var data = consentData.data(for: NSRange.publisherCC)
        data.insert(0, at: 0)
        let string = data.base64EncodedString()
        return String(string[string.index(string.startIndex, offsetBy: 2)...])
    }
    
    public var vendorListVersion: Int16 {
        return ATOMVendorIdentifier(consentData.intValue(for: NSRange.vendorListVersion))
    }
    
    public var tfcPolicyVersion: Int16 {
        return Int16(consentData.intValue(for: NSRange.tcfPolicyVersion))
    }
    
    public var isServiceSpecific: Int16 {
        return Int16(consentData.intValue(for: NSRange.isServiceSpecific))
    }
    
    public var useNonStandardTexts: Int16 {
        return Int16(consentData.intValue(for: NSRange.useNonStandardTexts))
    }
    
    public var purposeOneTreatment: Int16 {
        return ATOMPurposeIdentifier(consentData.intValue(for: NSRange.purposeOneTreatment))
    }
    
    public var purposeConsents: Set<ATOMPurposeIdentifier> {
        var results = Set<ATOMPurposeIdentifier>()
        for purposeId in 1...NSRange.purposesConsent.length {
            let purposeBit = Int64(NSRange.purposesConsent.lowerBound - 1 + purposeId)
            let value = Int(consentData.intValue(fromBit: purposeBit, toBit: purposeBit))
            if value > 0 {
                results.insert(ATOMPurposeIdentifier(purposeId))
            }
        }
        return results
    }
    
    public func purposeConsent(forPurposeId purposeId: ATOMPurposeIdentifier) -> Bool {
        purposeConsents.contains(purposeId)
    }
    
    public var purposeLegitimateInterests: Set<ATOMPurposeIdentifier> {
        var result = Set<ATOMPurposeIdentifier>()
        for purposeLegIntId in 1...NSRange.purposesLITransparency.length {
            let purposeLegIntBit = Int64(NSRange.purposesLITransparency.lowerBound - 1 + purposeLegIntId)
            let value = Int(consentData.intValue(fromBit: purposeLegIntBit, toBit: purposeLegIntBit))
            if value > 0 {
                result.insert(ATOMPurposeIdentifier(purposeLegIntId))
            }
        }
        return result
    }
    
    public func purposeLegitimateInterest(forPurposeId purposeId: ATOMPurposeIdentifier) -> Bool {
        purposeLegitimateInterests.contains(purposeId)
    }
    
}
