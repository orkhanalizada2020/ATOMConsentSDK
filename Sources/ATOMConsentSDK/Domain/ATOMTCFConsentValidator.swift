//
//  ATOMTCFConsentValidator.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import Foundation

public final class ATOMTCFConsentValidator {
    
    // MARK: - Constants
    
    private let vendorIdentifierSize: Int = 16
    private let bitFieldVendorConsentStart: Int = 230
    private let rangeEntryOffset: Int = 186
    
    // MARK: - Properties
    
    private let consentData: Data
    private let consentInfo: ATOMConsentInfo
    
    public var maxVendorIdForConsents: ATOMVendorIdentifier {
        return ATOMVendorIdentifier(consentData.intValue(for: NSRange.maxVendorIdentifierForConsent))
    }
    
    /// Initialize with consent data
    /// - Parameter consentData: The decoded consent data
    /// - Throws: Error if consent data is invalid
    public init(consentData: Data) throws {
        self.consentData = consentData
        self.consentInfo = try ATOMConsentInfo(withConsentData: consentData)
    }
    
    /// Check if a vendor has user consent
    /// - Parameter vendorId: The vendor ID to check
    /// - Returns: True if the vendor has consent
    public func isVendorAllowed(vendorID: ATOMVendorIdentifier) -> Bool {
        if vendorID > maxVendorIdForConsents {
            return false
        }
        
        let isRange = consentData.intValue(for: NSRange.encodingTypeForVendorConsents) == 1
        
        if isRange {
            return checkVendorInRange(forVendorID: vendorID)
        } else {
            return checkVendorInBitField(forVendorID: vendorID)
        }
    }
    
    /// Check if a vendor has consent in range
    private func checkVendorInRange(forVendorID vendorID: ATOMVendorIdentifier) -> Bool {
        let vendorIdentifierSize = Int64(vendorIdentifierSize)
        let consentDataMaxBit = consentData.count * 8 - 1
        let rangesCount = Int(consentData.intValue(for: NSRange.numEntriesForVendorConsent))
        var rangeStart = Int64(NSRange.numEntriesForVendorConsent.location + NSRange.numEntriesForVendorConsent.length)
        
        for _ in 0..<rangesCount {
            let entryType = consentData.intValue(fromBit: rangeStart, toBit: rangeStart)
            
            if consentDataMaxBit < rangeStart + 1 + vendorIdentifierSize + (entryType * vendorIdentifierSize) { //typebit + either 16 or 32
                return false
            }
            
            if entryType == 0 {
                let thisVendorId = consentData.intValue(fromBit: rangeStart + 1, toBit: rangeStart + vendorIdentifierSize)
                
                if vendorID == thisVendorId {
                    return true
                }
                
                rangeStart += 17
            } else if entryType == 1 {
                let vendorStart = consentData.intValue(fromBit: rangeStart + 1, toBit: rangeStart + vendorIdentifierSize)
                let vendorFinish = consentData.intValue(fromBit: rangeStart + 1 + vendorIdentifierSize + 1, toBit: rangeStart + vendorIdentifierSize * 2)
                
                if vendorStart <= vendorID && vendorID <= vendorFinish {
                    //if vendorId falls within range, then return opposite of default consent
                    return true
                }
                
                rangeStart += 33
            }
        }
        
        return false
    }
    
    /// Check if a vendor has consent in bit field
    private func checkVendorInBitField(forVendorID vendorID: ATOMVendorIdentifier) -> Bool {
        let vendorBitField = Int64(bitFieldVendorConsentStart) + Int64(vendorID) - 1
        // not enough bits
        
        guard vendorBitField < consentData.count * 8 else {
            return false
        }
        
        let value = consentData.intValue(fromBit: vendorBitField, toBit: vendorBitField)
        
        return value != 0
    }
    
    /// Check if a purpose has user consent
    /// - Parameter purposeId: The purpose ID to check
    /// - Returns: True if the purpose has consent
    public func isPurposeConsentAllowed(_ purposeId: ATOMPurposeIdentifier) -> Bool {
        self.consentInfo.purposeConsents.contains(purposeId)
    }
    
}
