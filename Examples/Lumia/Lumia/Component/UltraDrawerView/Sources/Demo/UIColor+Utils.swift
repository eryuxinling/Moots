import UIKit

internal extension UIColor {

    convenience init(rgba value: UInt) {
        self.init(
            byteRed: UInt8((value >> 24) & 0xff),
            green: UInt8((value >> 16) & 0xff),
            blue: UInt8((value >> 8) & 0xff),
            alpha: UInt8(value & 0xff)
        )
    }

    static var random: UIColor {
        return UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1.0)
    }
    
    static var randomLight: UIColor {
        return UIColor(red: 0.8 + 0.2 * rand(), green: 0.8 + 0.2 * rand(), blue: 0.8 + 0.2 * rand(), alpha: 1.0)
    }
    
    static var randomExtraLight: UIColor {
        return UIColor(red: 0.92 + 0.08 * rand(), green: 0.92 + 0.08 * rand(), blue: 0.92 + 0.08 * rand(), alpha: 1.0)
    }
    
    static var randomDark: UIColor {
        return UIColor(red: 0.7 * rand(), green: 0.7 * rand(), blue: 0.7 * rand(), alpha: 1.0)
    }
    
    private static func rand() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

}
