import Testing
import Foundation
@testable import SuperScoreboard

@Suite struct Int64FormattedKickoffTests {
    
    @Test("formattedKickoffTime formats valid timestamp correctly")
    func formattedKickoffTime_formatsValidTimestampCorrectly() async throws {
        // Given
        let timestamp: Int64 = 1735660800000 // Mon 31 Dec 2024, 20:00 GMT
        
        // When
        let formatted = timestamp.formattedKickoffTime
        
        // Then
        // The result will depend on system timezone, so just verify it's a valid time format
        let timePattern = /^\d{2}:\d{2}$/
        #expect(formatted.wholeMatch(of: timePattern) != nil)
        #expect(formatted.count == 5)
    }
    
    @Test("formattedKickoffTime handles different hours correctly")
    func formattedKickoffTime_handlesDifferentHoursCorrectly() async throws {
        // Given - Use timestamps that are 4 hours apart
        let firstTimestamp: Int64 = 1735632000000 // Mon 31 Dec 2024, 12:00 GMT
        let secondTimestamp: Int64 = 1735646400000 // Mon 31 Dec 2024, 16:00 GMT
        let thirdTimestamp: Int64 = 1735660800000 // Mon 31 Dec 2024, 20:00 GMT
        
        // When
        let firstFormatted = firstTimestamp.formattedKickoffTime
        let secondFormatted = secondTimestamp.formattedKickoffTime
        let thirdFormatted = thirdTimestamp.formattedKickoffTime
        
        // Then - Verify all are valid time formats and are different
        let timePattern = /^\d{2}:\d{2}$/
        #expect(firstFormatted.wholeMatch(of: timePattern) != nil)
        #expect(secondFormatted.wholeMatch(of: timePattern) != nil)
        #expect(thirdFormatted.wholeMatch(of: timePattern) != nil)
        #expect(firstFormatted != secondFormatted)
        #expect(secondFormatted != thirdFormatted)
    }
    
    @Test("formattedKickoffTime handles minutes correctly")
    func formattedKickoffTime_handlesMinutesCorrectly() async throws {
        // Given - Use timestamps with different minute values
        let baseTimestamp: Int64 = 1735660800000 // Base time
        let timestamp30Min = baseTimestamp + (30 * 60 * 1000) // +30 minutes
        let timestamp15Min = baseTimestamp + (15 * 60 * 1000) // +15 minutes
        let timestamp45Min = baseTimestamp + (45 * 60 * 1000) // +45 minutes
        
        // When
        let formatted30 = timestamp30Min.formattedKickoffTime
        let formatted15 = timestamp15Min.formattedKickoffTime
        let formatted45 = timestamp45Min.formattedKickoffTime
        
        // Then - Verify all end with correct minute values regardless of timezone
        #expect(formatted30.hasSuffix(":30"))
        #expect(formatted15.hasSuffix(":15"))
        #expect(formatted45.hasSuffix(":45"))
    }
    
    @Test("formattedKickoffTime handles zero timestamp")
    func formattedKickoffTime_handlesZeroTimestamp() async throws {
        // Given
        let timestamp: Int64 = 0 // Unix epoch start
        
        // When
        let formatted = timestamp.formattedKickoffTime
        
        // Then
        // Zero timestamp represents 1970-01-01 00:00:00 GMT, but result depends on system timezone
        let timePattern = /^\d{2}:\d{2}$/
        #expect(formatted.wholeMatch(of: timePattern) != nil)
        #expect(formatted.count == 5)
    }
    
    @Test("formattedKickoffTime handles large timestamp")
    func formattedKickoffTime_handlesLargeTimestamp() async throws {
        // Given
        let timestamp: Int64 = 4102444800000 // 1 Jan 2100, 00:00 GMT
        
        // When
        let formatted = timestamp.formattedKickoffTime
        
        // Then
        // Should format without crashing and produce valid time format
        let timePattern = /^\d{2}:\d{2}$/
        #expect(formatted.wholeMatch(of: timePattern) != nil)
    }
    
    @Test("formattedKickoffTime produces consistent format")
    func formattedKickoffTime_producesConsistentFormat() async throws {
        // Given
        let timestamps: [Int64] = [
            1735632000000, // 12:00
            1735635600000, // 13:00
            1735660800000, // 20:00
            1735664400000  // 21:00
        ]
        
        // When
        let formattedTimes = timestamps.map { $0.formattedKickoffTime }
        
        // Then
        let timePattern = /^\d{2}:\d{2}$/
        for time in formattedTimes {
            #expect(time.wholeMatch(of: timePattern) != nil)
            #expect(time.count == 5) // "HH:MM" is always 5 characters
        }
    }
    
    @Test("mock timestamp constants are valid")
    func mockTimestampConstants_areValid() async throws {
        // Given & When
        let completedFormatted = Int64.completedMatchKickoff.formattedKickoffTime
        let liveFormatted = Int64.liveMatchKickoff.formattedKickoffTime
        let upcomingFormatted = Int64.upcomingMatchKickoff.formattedKickoffTime
        
        // Then - Verify they are all valid time formats
        let timePattern = /^\d{2}:\d{2}$/
        #expect(completedFormatted.wholeMatch(of: timePattern) != nil)
        #expect(liveFormatted.wholeMatch(of: timePattern) != nil)
        #expect(upcomingFormatted.wholeMatch(of: timePattern) != nil)
        
        // Verify they are sequential (1 hour apart)
        #expect(Int64.liveMatchKickoff - Int64.completedMatchKickoff == 3600000) // 1 hour in milliseconds
        #expect(Int64.upcomingMatchKickoff - Int64.liveMatchKickoff == 3600000) // 1 hour in milliseconds
    }
    
    @Test("mock timestamp constants represent correct dates")
    func mockTimestampConstants_representCorrectDates() async throws {
        // Given
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        // When
        let completedDate = Date(timeIntervalSince1970: Double(Int64.completedMatchKickoff) / 1000.0)
        let liveDate = Date(timeIntervalSince1970: Double(Int64.liveMatchKickoff) / 1000.0)
        let upcomingDate = Date(timeIntervalSince1970: Double(Int64.upcomingMatchKickoff) / 1000.0)
        
        // Then
        #expect(dateFormatter.string(from: completedDate) == "2024-12-31")
        #expect(dateFormatter.string(from: liveDate) == "2024-12-31")
        #expect(dateFormatter.string(from: upcomingDate) == "2024-12-31")
    }
}