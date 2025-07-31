import Testing
import Foundation
@testable import SwiftLTC

struct LTCTest {

    @Test func TestEncoding() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let encoder = Encoder()
        encoder.setUserBits(10)
        let timeCode = TimeCode(timezone: "+0800", years: 25, months: 3, days: 16, hours: 1, mins: 2, secs: 3, frame: 10)
        encoder.setTimecode(timeCode)
        encoder.setVolume(-10)
        
        var audioBuffer = Data()
        for _ in 0..<30 {
            encoder.encodeFrame()
            encoder.incrementTimecode()
            audioBuffer.append(encoder.getBuffer())
        }
        #expect(audioBuffer.count == 48000)
    }

}
