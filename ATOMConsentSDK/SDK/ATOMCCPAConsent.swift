//
//  ATOMCCPAConsent.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 29.11.24.
//

public final class ATOMCCPAConsent {
    
    private let consentString: String
    
    public init(consentString: String) throws {
        self.consentString = consentString
    }
    
    public func isCCPACompliant() -> Bool {
        guard consentString.count == 4 else {
            return false // Invalid Length
        }
        
        return consentString.uppercased().dropFirst(2).first != "Y"
    }
    
}
