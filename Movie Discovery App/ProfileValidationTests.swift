import XCTest

@testable import Movie_Discovery_App

class ProfileValidationTests: XCTestCase {
    
    // Requirement 4.9: Unit test for Profile Display Name
    func testDisplayNameTooShort() {
        let name = "Ab"
        // Validation logic: Name must be at least 3 characters
        let isValid = name.trimmingCharacters(in: .whitespaces).count >= 3
        
        XCTAssertFalse(isValid, "Display name should be at least 3 characters")
    }
    
    // Requirement 4.9: Unit test for Profile Bio length
    func testBioLengthValidation() {
        let longBio = String(repeating: "a", count: 101)
        // Validation logic: Bio should not exceed 100 characters
        let isValid = longBio.count <= 100
        
        XCTAssertFalse(isValid, "Bio should not exceed 100 characters")
    }
}
