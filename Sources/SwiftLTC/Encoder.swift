import CLibLTC
import Foundation

public enum LTC {
    public class Encoder {
        private var encoder: UnsafeMutablePointer<LTCEncoder>!
        
        /// Create a new encoder
        /// - Parameters:
        ///   - sampleRate: audio sample rate (e.g. 48000)
        ///   - fps: frames per second (e.g. 25.0)
        ///   - standard: LTC TV standard
        ///   - flags: combination of LTCBGFlags
        public init(sampleRate: Double = 48000.0, fps: Double = 30.0, standard: LTC_TV_STANDARD = LTC_TV_525_60, flags: LTCBGFlags = []) {
            self.encoder = ltc_encoder_create(sampleRate, fps, standard, flags.rawValue)
            precondition(self.encoder != nil, "Failed to create LTCEncoder")
        }

        deinit {
            ltc_encoder_free(encoder)
        }

        /// Set current timecode
        public func setTimecode(_ timecode: SMPTETimecodeSwift) {
            var cTime = timecode.toC()
            ltc_encoder_set_timecode(encoder, &cTime)
        }

        /// Get current timecode
        public var timecode:  SMPTETimecodeSwift {
            var cTime = SMPTETimecode()
            ltc_encoder_get_timecode(encoder, &cTime)
            return SMPTETimecodeSwift(from: cTime)
        }

        /// Set user bits (32-bit data)
        public func setUserBits(_ data: UInt) {
            ltc_encoder_set_user_bits(encoder, data)
        }

        /// Get user bits from current frame
        public var userBits: UInt {
            // Fetch internal frame
            var frame = LTCFrame()
            ltc_encoder_get_frame(encoder, &frame)
            return ltc_frame_get_user_bits(&frame)
        }

        /// Increment timecode by one frame
        @discardableResult
        public func incrementTimecode() -> Bool {
            return ltc_encoder_inc_timecode(encoder) != 0
        }

        /// Decrement timecode by one frame
        @discardableResult
        public func decrementTimecode() -> Bool {
            return ltc_encoder_dec_timecode(encoder) != 0
        }

        /// Get pointer to internal buffer and optionally flush
        public func getBuffer(flush: Bool = true) -> Data {
            var bufPtr: UnsafeMutablePointer<ltcsnd_sample_t>? = nil
            let used = ltc_encoder_get_bufferptr(encoder, &bufPtr, flush ? 1 : 0)
            guard let ptr = bufPtr, used > 0 else { return Data() }
            return Data(bytes: ptr, count: Int(used))
        }

        /// Flush internal buffer
        public func bufferFlush() {
            ltc_encoder_buffer_flush(encoder)
        }

        /// Get allocated buffer size
        public var bufferSize: Int {
            return Int(ltc_encoder_get_buffersize(encoder))
        }

        /// Reinitialize encoder settings
        @discardableResult
        public func reinit(sampleRate: Double, fps: Double, standard: LTC_TV_STANDARD, flags: LTCBGFlags) -> Bool {
            return ltc_encoder_reinit(encoder, sampleRate, fps, standard, flags.rawValue) == 0
        }

        /// Reset encoder state
        public func reset() {
            ltc_encoder_reset(encoder)
        }

        /// Get current volume (dBFS <= 0.0)
        public var volume: Double {
            return ltc_encoder_get_volume(encoder)
        }

        /// Set encoder volume (dBFS <= 0.0)
        @discardableResult
        public func setVolume(_ dbfs: Double) -> Bool {
            return ltc_encoder_set_volume(encoder, dbfs) == 0
        }

        /// Get filter rise-time in microseconds
        public var filter: Double {
            return ltc_encoder_get_filter(encoder)
        }

        /// Set filter rise-time (use 0 for perfect square wave)
        public func setFilter(_ riseTimeUs: Double) {
            ltc_encoder_set_filter(encoder, riseTimeUs)
        }

        /// Encode a single byte of LTC frame at given speed
        @discardableResult
        public func encodeByte(_ byte: Int, speed: Double = 1.0) -> Bool {
            return ltc_encoder_encode_byte(encoder, Int32(byte), speed) == 0
        }

        /// Terminate encoding
        @discardableResult
        public func endEncode() -> Bool {
            return ltc_encoder_end_encode(encoder) == 0
        }

        /// Encode full LTC frame at normal speed
        public func encodeFrame() {
            ltc_encoder_encode_frame(encoder)
        }

        /// Encode full LTC frame in reverse
        public func encodeReversedFrame() {
            ltc_encoder_encode_reversed_frame(encoder)
        }
    }

}
