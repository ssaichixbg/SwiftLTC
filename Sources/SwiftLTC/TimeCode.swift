import CLibLTC

public typealias SMPTETimecodeSwift = TimeCode

public struct TimeCode {
    public var timezone: String   // "+HHMM" or "-HHMM"
    public var years: UInt8       // 0..99
    public var months: UInt8      // 1..12
    public var days: UInt8        // 1..31
    public var hours: UInt8       // 0..23
    public var mins: UInt8        // 0..59
    public var secs: UInt8        // 0..59
    public var frame: UInt8       // 0..(FPS-1)

    internal func toC() -> SMPTETimecode {
        var cTime = SMPTETimecode()
        // Copy timezone as C char[6]
        let tzUTF8 = timezone.utf8
        withUnsafeMutablePointer(to: &cTime.timezone) { ptr in
            ptr.withMemoryRebound(to: CChar.self, capacity: 6) { tzPtr in
                tzUTF8.prefix(5).enumerated().forEach { idx, byte in
                    tzPtr[idx] = CChar(byte)
                }
                tzPtr[min(tzUTF8.count, 5)] = 0
            }
        }
        cTime.years = years
        cTime.months = months
        cTime.days = days
        cTime.hours = hours
        cTime.mins = mins
        cTime.secs = secs
        cTime.frame = frame
        return cTime
    }

    internal init(from cTime: SMPTETimecode) {
        // Read timezone C string
        timezone = withUnsafePointer(to: cTime.timezone) { ptr in
            String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        years = cTime.years
        months = cTime.months
        days = cTime.days
        hours = cTime.hours
        mins = cTime.mins
        secs = cTime.secs
        frame = cTime.frame
    }
    
    public init(timezone: String = "+0000", years: UInt8 = 0, months: UInt8 = 1, days: UInt8 = 1, hours: UInt8 = 0, mins: UInt8 = 0, secs: UInt8 = 0, frame: UInt8 = 0) {
        self.timezone = timezone
        self.years = years
        self.months = months
        self.days = days
        self.hours = hours
        self.mins = mins
        self.secs = secs
        self.frame = frame
    }
}

