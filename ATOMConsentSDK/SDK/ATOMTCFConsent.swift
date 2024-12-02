//
//  ATOMConsentManager.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

public final class ATOMTCFConsent {
        
    private let consentData: Data
    
    public init(withConsentString consentString: String) throws {
        do {
            let consentString = consentString.split(separator: ".").first.map(String.init) ?? consentString
            consentData = try ATOMConsentDataParser.parse(consentString: consentString)
        } catch {
            throw ATOMConsentError.parsingFailed
        }
    }
    
    public func isVendorAllowed(_ vendorId: ATOMVendorIdentifier) -> Bool {
        guard let validator = try? ATOMTCFConsentValidator(consentData: consentData) else { return false }
        return validator.isVendorAllowed(vendorId: vendorId)
    }
    
    public func isPurposeAllowed(_ purposeId: ATOMPurposeIdentifier) -> Bool {
        guard let validator = try? ATOMTCFConsentValidator(consentData: consentData) else { return false }
        return validator.isPurposeConsentAllowed(purposeId)
    }
    
    public func arePurposesAllowed(_ purposeIds: [ATOMPurposeIdentifier]) -> Bool {
        guard let validator = try? ATOMTCFConsentValidator(consentData: consentData) else { return false }
        
        for purposeId in purposeIds {
            if !validator.isPurposeConsentAllowed(purposeId) { return false }
        }
        return true
    }
    
}
