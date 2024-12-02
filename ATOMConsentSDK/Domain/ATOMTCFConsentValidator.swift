//
//  ATOMTCFConsentValidator.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

import Foundation

public final class ATOMTCFConsentValidator {
    
    private let vendorIdentifierSize: Int = 16
    private let bitFieldVendorConsentStart: Int = 230
    private let rangeEntryOffset: Int = 186
    
    private let consentData: Data
    private let consentInfo: ATOMConsentInfo
    
    public var maxVendorIdForConsents: ATOMVendorIdentifier {
        return ATOMVendorIdentifier(consentData.intValue(for: NSRange.maxVendorIdentifierForConsent))
    }
    
    public init(consentData: Data) throws {
        self.consentData = consentData
        self.consentInfo = try ATOMConsentInfo(withConsentData: consentData)
    }
    
    public func isVendorAllowed(vendorId: ATOMVendorIdentifier) -> Bool {
        if vendorId > maxVendorIdForConsents {
            return false
        }
        let isRange = consentData.intValue(for: NSRange.encodingTypeForVendorConsents) == 1
        if isRange {
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
                    if vendorId == thisVendorId {
                        return true
                    }
                    rangeStart += 17
                } else if entryType == 1 {
                    let vendorStart = consentData.intValue(fromBit: rangeStart + 1, toBit: rangeStart + vendorIdentifierSize)
                    let vendorFinish = consentData.intValue(fromBit: rangeStart + 1 + vendorIdentifierSize + 1, toBit: rangeStart + vendorIdentifierSize * 2)
                    if vendorStart <= vendorId && vendorId <= vendorFinish {
                        //if vendorId falls within range, then return opposite of default consent
                        return true
                    }
                    rangeStart += 33
                }
            }
            return false
        } else {
            let vendorBitField = Int64(bitFieldVendorConsentStart) + Int64(vendorId) - 1
            // not enough bits
            guard vendorBitField < consentData.count * 8 else {
                return false
            }
            let value = consentData.intValue(fromBit: vendorBitField, toBit: vendorBitField)
            if value == 0 {
                return false
            } else {
                return true
            }
        }
    }
    
    public func isPurposeConsentAllowed(_ purposeId: ATOMPurposeIdentifier) -> Bool {
        self.consentInfo.purposeConsents.contains(purposeId)
    }
    
}
