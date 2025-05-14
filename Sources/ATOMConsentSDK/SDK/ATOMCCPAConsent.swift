//
//  ATOMCCPAConsent.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 29.11.24.
//

final class ATOMCCPAConsent {
    
    /// Standard CCPA string length (1YNY format)
    private let standardCCPALength = 4
    
    /// Position of the opt-out flag in the CCPA string
    private let optOutFlagPosition = 2
    
    private let consentString: String
    
    /// Initialize with a CCPA consent string
    /// - Parameter consentString: The CCPA consent string (e.g. "1YNY")
    /// - Throws: ATOMConsentError.invalidFormat if string is not valid CCPA format
    init(consentString: String) throws {
        let consentString = consentString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard consentString.count == self.standardCCPALength else {
            throw ATOMConsentError.invalidFormat
        }
        
        self.consentString = consentString
    }
    
    /// Checks if the user has opted out of sale of personal information
    /// Based on the US Privacy string format where:
    /// - Position 1: Version
    /// - Position 2: Notice & Opportunity to Opt-Out of Sale of Personal Information Provided
    /// - Position 3: Opt-Out of Sale of Personal Information (Y = Yes, user opted out)
    /// - Position 4: LSPA Covered Transaction
    ///
    /// return true if CCPA compliant (user has opted out), false otherwise
    private func isOptedOut() -> Bool {
        let optOutFlag = consentString.uppercased().dropFirst(2).first
        
        return optOutFlag == "Y"
    }
    
    public func isSaleAllowed() -> Bool {
        !isOptedOut()
    }
    
}
