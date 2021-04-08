import XCTest
@testable import InterfaceKit

final class InterfaceKitTests: XCTestCase {
    func testGeneratingWeekDataForCalendar() {
        let calendar = Calendar.current
        
        guard let weeks = calendar.createWeeks(6, fromStartDate: Date(timeIntervalSinceReferenceDate: 639436707)) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(weeks[0].day(at: 0), Date(timeIntervalSinceReferenceDate: 639205200))
        XCTAssertEqual(weeks[1].day(at: 0), Date(timeIntervalSinceReferenceDate: 639810000))
        XCTAssertEqual(weeks[2].day(at: 0), Date(timeIntervalSinceReferenceDate: 640414800))
        XCTAssertEqual(weeks[3].day(at: 0), Date(timeIntervalSinceReferenceDate: 641019600))
        XCTAssertEqual(weeks[4].day(at: 0), Date(timeIntervalSinceReferenceDate: 641624400))
        XCTAssertEqual(weeks[5].day(at: 0), Date(timeIntervalSinceReferenceDate: 642229200))
    }
}
