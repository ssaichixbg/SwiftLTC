import CLibLTC

public extension LTCFrame {
    /// Create a fresh LTCFrame (reset sync word & parity)
    static func empty() -> LTCFrame {
        var frame = LTCFrame()
        ltc_frame_reset(&frame)
        return frame
    }

    /// Initialize from SMPTETimecode
    init(from timecode: SMPTETimecodeSwift, standard: LTC_TV_STANDARD, flags: Int32) {
        var frame = LTCFrame.empty()
        var st = timecode.toC()
        ltc_time_to_frame(&frame, &st, standard, flags)
        self = frame
    }

    /// Reset to default
    mutating func reset() {
        ltc_frame_reset(&self)
    }

    /// Convert to SMPTETimecodeSwift
    func toTimecode(flags: Int32) -> SMPTETimecodeSwift {
        var st = SMPTETimecode()
        var frame = self
        ltc_frame_to_time(&st, &frame, flags)
        return SMPTETimecodeSwift(from: st)
    }

    /// Increment frame (returns true if wrapped)
    @discardableResult
    mutating func increment(fps: Int32, standard: LTC_TV_STANDARD, flags: Int32) -> Bool {
        return ltc_frame_increment(&self, fps, standard, flags) != 0
    }

    /// Decrement frame (returns true if wrapped)
    @discardableResult
    mutating func decrement(fps: Int32, standard: LTC_TV_STANDARD, flags: Int32) -> Bool {
        return ltc_frame_decrement(&self, fps, standard, flags) != 0
    }

    /// Parse binary-group flags
    func parseBGFlags(standard: LTC_TV_STANDARD) -> Int32 {
        var frame = self
        return ltc_frame_parse_bcg_flags(&frame, standard)
    }
}
