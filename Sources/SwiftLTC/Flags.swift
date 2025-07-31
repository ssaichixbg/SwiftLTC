import CLibLTC

public struct LTCBGFlags: OptionSet, Sendable {
    public let rawValue: Int32
    public init(rawValue: Int32) { self.rawValue = rawValue }

    /// Use date in frame/timecode conversion
    public static let useDate      = LTCBGFlags(rawValue: Int32(LTC_USE_DATE.rawValue))
    /// Timecode is wall-clock (freerun)
    public static let tcClock      = LTCBGFlags(rawValue: Int32(LTC_TC_CLOCK.rawValue))
    /// Do not touch binary-group-flag bits on init
    public static let dontTouch    = LTCBGFlags(rawValue: Int32(LTC_BGF_DONT_TOUCH.rawValue))
    /// Do not modify parity bit
    public static let noParity     = LTCBGFlags(rawValue: Int32(LTC_NO_PARITY.rawValue))
}
