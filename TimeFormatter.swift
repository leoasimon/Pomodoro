//
//  TimeFormatter.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-11.
//

import Foundation

final class TimeFormatter {
    static private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumIntegerDigits = 2
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return nf
    }()

    static func secToTimeStr(for seconds: Int) -> String {
        let h = seconds / (60 * 60)
        let m = (seconds / 60) % 60
        let s = seconds % 60

        let hStr = numberFormatter.string(from: NSNumber(value: h)) ?? "\(h)"
        let mStr = numberFormatter.string(from: NSNumber(value: m)) ?? "\(m)"
        let sStr = numberFormatter.string(from: NSNumber(value: s)) ?? "\(s)"

        return "\(hStr):\(mStr):\(sStr)"
    }
}
