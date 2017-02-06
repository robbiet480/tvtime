/******************************************************************************
 *
 * Date+Extensions.swift
 *
 ******************************************************************************/

public extension Date {

    func daySuffix() -> String {

        let calendar = NSCalendar.current
        let dayOfMonth = calendar.component(.day, from: self)

        switch dayOfMonth {
        case 1: fallthrough
        case 21: fallthrough
        case 31: return "st"
        case 2: fallthrough
        case 22: return "nd"
        case 3: fallthrough
        case 23: return "rd"
        default: return "th"
        }
    }
}
