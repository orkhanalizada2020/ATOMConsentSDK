//
//  ATOMBase64Utils.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

public extension String {
    
    var base64Padded: String {
        return self.padding(toLength: ((self.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
    }
    
}
