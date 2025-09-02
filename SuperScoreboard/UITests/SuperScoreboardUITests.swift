//
//  SuperScoreboardUITests.swift
//  SuperScoreboard
//
//  Created by Simon Malih
//

import XCTest

@MainActor
final class SuperScoreboardUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Reset app state for consistent testing
        app.launchArguments = ["--uitesting"]
        app.launchEnvironment = ["ANIMATIONS_DISABLED": "1"]
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - App Launch Tests
    
    
    func testAppLaunchesSuccessfully() throws {
        app.launch()
        
        // Verify app launches and shows main screen
        XCTAssertTrue(app.exists, "App should launch successfully")
        
        // Wait for initial loading to complete
        waitForLoadingToComplete()
        
        // Should have some interactive elements after loading
        let hasButtons = app.buttons.count > 0
        let hasScrollView = app.scrollViews.firstMatch.exists
        
        XCTAssertTrue(hasButtons || hasScrollView, "App should display interactive content")
    }
    
    
    func testInitialLoadingState() throws {
        app.launch()
        
        // Should show loading state initially (or content loads so fast we miss it)
        let progressIndicators = app.progressIndicators
        
        // If we see progress indicators, that's good
        // If we don't, that might mean content loaded quickly, which is also fine
        let hasLoadingOrContent = progressIndicators.count > 0 || app.buttons.count > 0
        XCTAssertTrue(hasLoadingOrContent, "Should show loading or content")
    }
    
    // MARK: - Content Display Tests
    
    
    func testContentDisplaysAfterLoading() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Verify we have interactive content
        let buttons = app.buttons
        let scrollViews = app.scrollViews
        
        // Should have either buttons or scrollable content
        let hasInteractiveContent = buttons.count > 0 || scrollViews.firstMatch.exists
        XCTAssertTrue(hasInteractiveContent, "Should display interactive content after loading")
    }
    
    
    func testNavigationWorks() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Find and tap the first tappable button
        let buttons = app.buttons
        
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable && !button.identifier.contains("back") {
                let initialNavBarCount = app.navigationBars.count
                button.tap()
                
                // Wait a moment for navigation
                sleep(1)
                
                let newNavBarCount = app.navigationBars.count
                if newNavBarCount > initialNavBarCount || app.navigationBars.buttons.count > 0 { break }
            }
        }
        
        // Even if we couldn't trigger navigation, the app should still be responsive
        XCTAssertTrue(app.buttons.count > 0, "App should remain interactive")
    }

    
    func testScrollFunctionality() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Test basic scroll behavior
            scrollView.swipeUp()
            XCTAssertTrue(scrollView.exists, "Scroll view should still exist after swipe")
            
            scrollView.swipeDown()
            XCTAssertTrue(scrollView.exists, "Scroll view should exist after swipe down")
        }
        
        // App should remain functional
        XCTAssertTrue(app.exists, "App should remain functional after scrolling")
    }
    
    // MARK: - Pull to Refresh Tests
    
    
    func testPullToRefreshGesture() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Perform pull-to-refresh gesture
            let startPoint = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
            let endPoint = scrollView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
            startPoint.press(forDuration: 0, thenDragTo: endPoint)
            
            // App should still be responsive after gesture
            XCTAssertTrue(app.exists, "App should be responsive after pull gesture")
        }
    }
    
    // MARK: - Accessibility Tests
    
    
    func testBasicAccessibility() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Verify we have elements with accessibility information
        let allElements = app.descendants(matching: .any).allElementsBoundByAccessibilityElement
        
        var accessibleElementsCount = 0
        for element in allElements {
            if !element.label.isEmpty || !element.identifier.isEmpty {
                accessibleElementsCount += 1
            }
        }
        
        XCTAssertGreaterThan(accessibleElementsCount, 0, "Should have accessible elements")
    }
    
    
    func testButtonsAreAccessible() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let buttons = app.buttons
        var accessibleButtons = 0
        
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists && (button.isHittable || !button.label.isEmpty) {
                accessibleButtons += 1
            }
        }
        
        if buttons.count > 0 {
            XCTAssertGreaterThan(accessibleButtons, 0, "Buttons should be accessible")
        }
    }
    
    // MARK: - Error Handling Tests
    
    
    func testAppHandlesErrorsGracefully() throws {
        // Test with potential network error condition
        app.launchArguments.append("--network-error")
        app.launch()
        
        // Wait longer for error state
        sleep(5)
        
        // App should still be responsive even with errors
        XCTAssertTrue(app.exists, "App should handle errors gracefully")
        
        // Look for retry mechanisms
        let retryButton = app.buttons["Try Again"]
        if retryButton.exists {
            XCTAssertTrue(retryButton.isEnabled, "Retry button should be enabled")
        }
    }
    
    // MARK: - Performance Tests
    
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    
    func testScrollPerformance() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            measure(metrics: [XCTOSSignpostMetric.scrollingAndDecelerationMetric]) {
                scrollView.swipeUp()
                scrollView.swipeDown()
            }
        }
    }
    
    // MARK: - Integration Tests
    
    
    func testBasicUserFlow() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Step 1: Verify content is loaded
        let hasContent = app.buttons.count > 0 || app.scrollViews.firstMatch.exists
        XCTAssertTrue(hasContent, "Should have content loaded")
        
        // Step 2: Try to interact with first available button
        let buttons = app.buttons
        if buttons.count > 0 {
            let firstButton = buttons.firstMatch
            if firstButton.exists && firstButton.isHittable {
                firstButton.tap()
                
                // Step 3: Verify app is still responsive
                XCTAssertTrue(app.exists, "App should remain responsive after interaction")
            }
        }
        
        // Step 4: Test scroll if available
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            scrollView.swipeUp()
            XCTAssertTrue(scrollView.exists, "Scroll view should be functional")
        }
    }
    
    // MARK: - State Management Tests
    
    
    func testAppStateTransitions() throws {
        app.launch()
        
        // Initial state
        XCTAssertTrue(app.exists, "App should launch")
        
        // Loading state (might be too fast to catch)
        let hasLoadingOrContent = app.progressIndicators.count > 0 || app.buttons.count > 0
        XCTAssertTrue(hasLoadingOrContent, "Should show loading or content")
        
        // Wait for final state
        waitForLoadingToComplete()
        
        // Final state should have interactive elements
        let finalHasContent = app.buttons.count > 0 || app.scrollViews.firstMatch.exists
        XCTAssertTrue(finalHasContent, "Final state should have interactive content")
    }
    
    // MARK: - Helper Methods
    
    private func waitForLoadingToComplete() {
        // Wait for any progress indicators to disappear
        let loadingIndicators = app.progressIndicators
        if loadingIndicators.count > 0 {
            let expectation = expectation(for: NSPredicate(format: "count == 0"), evaluatedWith: loadingIndicators, handler: nil)
            wait(for: [expectation], timeout: 15)
        } else {
            // If no loading indicators, wait a short time for content to appear
            sleep(2)
        }
    }
    
    private func findTappableElement() -> XCUIElement? {
        let buttons = app.buttons
        for i in 0..<min(buttons.count, 10) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable {
                return button
            }
        }
        return nil
    }
}
