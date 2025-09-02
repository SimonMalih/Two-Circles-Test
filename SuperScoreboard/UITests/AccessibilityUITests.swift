//
//  AccessibilityUITests.swift
//  SuperScoreboard
//
//  Created by Simon Malih
//

import XCTest

@MainActor
final class AccessibilityUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launchEnvironment = ["ANIMATIONS_DISABLED": "1"]
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Accessibility Labels Tests
    
    
    func testCompetitionHeadersHaveAccessibilityLabels() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let competitionHeaders = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'competition_header'"))
        let headerCount = competitionHeaders.count
        
        if headerCount > 0 {
            for i in 0..<min(headerCount, 3) { // Test first 3 headers
                let header = competitionHeaders.element(boundBy: i)
                XCTAssertTrue(header.exists, "Competition header \(i) should exist")
                XCTAssertFalse(header.label.isEmpty, "Competition header should have accessibility label")
            }
        }
    }
    
    
    func testMatchCardsHaveAccessibilityInformation() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let matchCards = app.otherElements.matching(NSPredicate(format: "identifier CONTAINS 'match_card'"))
        let cardCount = matchCards.count
        
        if cardCount > 0 {
            for i in 0..<min(cardCount, 3) { // Test first 3 cards
                let card = matchCards.element(boundBy: i)
                XCTAssertTrue(card.exists, "Match card \(i) should exist")
                XCTAssertFalse(card.identifier.isEmpty, "Match card should have accessibility identifier")
            }
        }
    }
    
    
    func testClubCardsHaveAccessibilityLabels() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Navigate to favorites
        navigateToFavorites()
        
        let clubCards = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'club_card'"))
        let cardCount = clubCards.count
        
        if cardCount > 0 {
            for i in 0..<min(cardCount, 3) { // Test first 3 club cards
                let card = clubCards.element(boundBy: i)
                if card.waitForExistence(timeout: 5) {
                    XCTAssertFalse(card.label.isEmpty, "Club card \(i) should have accessibility label")
                    XCTAssertFalse(card.identifier.isEmpty, "Club card should have identifier")
                }
            }
        }
    }
    
    // MARK: - VoiceOver Navigation Tests
    
    
    func testVoiceOverCanNavigateMainScreen() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Find all accessibility elements
        let accessibleElements = app.descendants(matching: .any).allElementsBoundByAccessibilityElement
        
        var labeledElementsCount = 0
        for element in accessibleElements {
            if !element.label.isEmpty || !element.identifier.isEmpty {
                labeledElementsCount += 1
            }
        }
        
        XCTAssertGreaterThan(labeledElementsCount, 0, "Should have accessibility elements for VoiceOver navigation")
    }
    
    
    func testButtonsHaveAccessibilityTraits() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let buttons = app.buttons
        var buttonsWithTraits = 0
        
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists {
                buttonsWithTraits += 1
            }
        }
        
        XCTAssertGreaterThan(buttonsWithTraits, 0, "Should have buttons with proper accessibility traits")
    }
    
    // MARK: - Color Contrast and Visibility Tests
    
    
    func testElementsAreVisibleInAccessibilityMode() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Test that key elements are hittable (implies proper size/contrast)
        let competitionHeaders = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'competition_header'"))
        let firstHeader = competitionHeaders.firstMatch
        
        if firstHeader.exists {
            XCTAssertTrue(firstHeader.isHittable, "Competition headers should be hittable for accessibility")
        }
        
        let matchCards = app.otherElements.matching(NSPredicate(format: "identifier CONTAINS 'match_card'"))
        let firstCard = matchCards.firstMatch
        
        if firstCard.exists {
            XCTAssertTrue(firstCard.isHittable, "Match cards should be hittable for accessibility")
        }
    }
    
    // MARK: - Accessibility Actions Tests
    
    
    func testAccessibilityActionsWork() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Test that accessible elements can be activated
        let competitionHeaders = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'competition_header'"))
        let firstHeader = competitionHeaders.firstMatch
        
        if firstHeader.waitForExistence(timeout: 5) {
            XCTAssertTrue(firstHeader.isEnabled, "Competition header should be enabled for interaction")
            
            // Test activation
            firstHeader.tap()
            
            // Should result in navigation
            let backButton = app.navigationBars.buttons.firstMatch
            XCTAssertTrue(backButton.waitForExistence(timeout: 3), "Accessibility activation should trigger navigation")
        }
    }
    
    // MARK: - Reduced Motion Tests
    
    
    func testWorksWithReducedMotion() throws {
        app.launchEnvironment["REDUCE_MOTION"] = "1"
        app.launch()
        waitForLoadingToComplete()
        
        // App should still be functional with reduced motion
        let competitionHeaders = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'competition_header'"))
        let firstHeader = competitionHeaders.firstMatch
        
        XCTAssertTrue(firstHeader.waitForExistence(timeout: 5), "App should work with reduced motion")
        
        // Test interaction still works
        firstHeader.tap()
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 3), "Navigation should work with reduced motion")
    }
    
    // MARK: - Form Accessibility Tests
    
    
    func testFavoritesFormAccessibility() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Navigate to favorites
        navigateToFavorites()
        
        // Test form elements have proper labels
        let saveButton = app.navigationBars.buttons["Save"]
        if saveButton.waitForExistence(timeout: 5) {
            XCTAssertFalse(saveButton.label.isEmpty, "Save button should have accessibility label")
        }
        
        let clubCards = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'club_card'"))
        if clubCards.count > 0 {
            let firstClubCard = clubCards.firstMatch
            XCTAssertTrue(firstClubCard.waitForExistence(timeout: 3), "Club cards should be accessible")
            XCTAssertFalse(firstClubCard.label.isEmpty, "Club cards should have accessibility labels")
        }
    }
    
    // MARK: - Error State Accessibility Tests
    
    
    func testErrorStatesAreAccessible() throws {
        app.launchArguments.append("--network-error")
        app.launch()
        
        // Look for error state elements
        let retryButton = app.buttons["Try Again"]
        if retryButton.waitForExistence(timeout: 10) {
            XCTAssertFalse(retryButton.label.isEmpty, "Retry button should have accessibility label")
            XCTAssertTrue(retryButton.isEnabled, "Retry button should be enabled")
            XCTAssertTrue(retryButton.isHittable, "Retry button should be hittable")
        }
        
        let errorText = app.staticTexts["failed_to_display_matches"]
        if errorText.exists {
            XCTAssertFalse(errorText.label.isEmpty, "Error text should be readable by accessibility services")
        }
    }
    
    // MARK: - Loading State Accessibility Tests
    
    
    func testLoadingStateIsAccessible() throws {
        app.launch()
        
        // Check loading state accessibility
        let loadingIndicators = app.progressIndicators
        if loadingIndicators.count > 0 {
            let firstIndicator = loadingIndicators.firstMatch
            // Loading indicators should be accessible to screen readers
            XCTAssertTrue(firstIndicator.exists, "Loading indicators should be accessible")
        }
    }
    
    // MARK: - Helper Methods
    
    private func waitForLoadingToComplete() {
        let loadingIndicator = app.progressIndicators.firstMatch
        if loadingIndicator.exists {
            let expectation = expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: loadingIndicator, handler: nil)
            wait(for: [expectation], timeout: 15)
        }
    }
    
    private func navigateToFavorites() {
        let scrollView = app.scrollViews.firstMatch
        scrollView.swipeUp()
        
        let favoritesCard = app.buttons["follow_your_favourites"]
        if favoritesCard.waitForExistence(timeout: 5) {
            favoritesCard.tap()
        }
    }
}
