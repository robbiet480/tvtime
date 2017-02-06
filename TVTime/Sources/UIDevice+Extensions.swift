/******************************************************************************
 *
 * UIDevice+Extensions.swift
 *
 ******************************************************************************/

import Foundation

public enum ScreenType: CGFloat {
    
    case iPhone4 = 480.0
    case iPhone5 = 568.0
    case iPhone6 = 667.0
    case iPhone6Plus = 736.0
    case iPadPro = 1366.0
}

public extension UIDevice {
    
    private var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    private var iPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    
    public var screenType: ScreenType? {
        
        guard iPhone
            else {
                return nil
        }
        
        switch UIScreen.main.bounds.height {
        case ScreenType.iPhone4.rawValue:
            return .iPhone4
        case ScreenType.iPhone5.rawValue:
            return .iPhone5
        case ScreenType.iPhone6.rawValue:
            return .iPhone6
        case ScreenType.iPhone6Plus.rawValue:
            return .iPhone6Plus
        default:
            return nil
        }
        
    }
    
    public var screenTypePad: ScreenType?{
        guard iPad
            else {
                return nil
        }
        
        switch UIScreen.main.bounds.width {
        case ScreenType.iPadPro.rawValue:
            return .iPadPro
        default:
            return nil
        }
    }
}
