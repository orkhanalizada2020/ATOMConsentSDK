//
//  ATOMData+BitOperations.swift
//  ATOMConsentSDK
//
//  Created by Orkhan Alizada on 19.11.24.
//

public extension Data {
    
    /*
     Returns byte number for bit with error correction for length
     */
    func byte(forBit bit:Int64) -> Int? {
        let lastBit = count * 8 - 1
        if bit > lastBit {
            return nil
        }
        if bit < 0 {
            return nil
        }
        return Int(bit / 8)
    }
    
    func bytes(fromBit startBit:Int64, toBit endBit:Int64) -> [UInt8] {
        let byteCount = count
        let lastBit = Int64(byteCount * 8 - 1)
        var byteArray = [UInt8]()
        if startBit > lastBit {
            return byteArray
        }
        var realEndBit = endBit
        //limit to length of data
        if endBit > lastBit {
            realEndBit = lastBit
        }
        //limit to 64 bits
        if endBit - startBit > 63 {
            realEndBit = startBit + 63
        }
        if startBit <= endBit, let startByte = byte(forBit: startBit), let endByte = byte(forBit: realEndBit) {
            if startByte == endByte {
                //avoid complexity by removing the case where startBit and endBit are on the same byte
                let leftShift = startBit % 8
                let rightShift =  8 - (realEndBit % 8) - 1
                byteArray.append((self[startByte] << leftShift) >> (rightShift + leftShift))
            } else {
                let rightShift = 8 - (realEndBit % 8) - 1
                let leftShift = 8 - rightShift
                let finalLeftShift = startBit % 8
                var currentByte = endByte
                //addendum is required for when first byte pull is less than next bite push
                let addendum = finalLeftShift > leftShift ? 1 : 0
                while currentByte > startByte + addendum {
                    let beggining = self[currentByte - 1] << leftShift
                    let ending = self[currentByte] >> rightShift
                    byteArray.insert(beggining | ending, at:0)
                    currentByte -= 1
                }
                let finalRightShift =  finalLeftShift + rightShift
                
                if addendum == 0  {
                    //means that there's some bits on the first byte that need to be added
                    byteArray.insert((self[currentByte] << finalLeftShift) >> finalRightShift , at: 0)
                } else {
                    //means that there's some bits on the second byte and some from the first byte totaling less than a byte
                    let rightBits = (self[currentByte] >> rightShift)
                    let leftBits = (self[currentByte - 1] << finalLeftShift) >> (finalLeftShift - (8 - rightShift))
                    byteArray.insert(leftBits | rightBits , at: 0)
                }
            }
        }
        return byteArray
    }
    
    func data(fromBit startBit:Int64, toBit endBit:Int64) -> Data {
        let byteArray = bytes(fromBit: startBit, toBit: endBit)
        return Data(byteArray)
    }
    
    func intValue(fromBit startBit:Int64, toBit endBit:Int64) -> Int64 {
        var dataValue = data(fromBit: startBit, toBit: endBit)
        while dataValue.count < 8 {
            dataValue.insert(0, at: 0)
        }
        let value = UInt64(bigEndian: dataValue.withUnsafeBytes { $0.load(as: UInt64.self) })
        return Int64(value)
    }
    
    func intValue(for range: NSRange) -> Int64 {
        return intValue(fromBit: Int64(range.lowerBound), toBit: Int64(range.upperBound - 1))
    }
    
    func data(for range: NSRange) -> Data {
        return data(fromBit: Int64(range.lowerBound), toBit: Int64(range.upperBound - 1))
    }
    
}
