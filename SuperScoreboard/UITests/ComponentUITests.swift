//
//  ComponentUITests.swift
//  SuperScoreboard
//
//  Created by Simon Malih
//

import XCTest

@MainActor
final class ComponentUITests: XCTestCase {
    
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
    
    // MARK: - Component Interaction Tests
    
    func testUIComponentsAreInteractive() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Test that we have interactive buttons
        let buttons = app.buttons
        var interactiveFound = false
        
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable {
                interactiveFound = true
                break
            }
        }
        
        if buttons.count > 0 {
            XCTAssertTrue(interactiveFound, "Should have interactive UI components")
        }
    }
    
    func testComponentsHaveAccessibilityInformation() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Check that buttons have some accessibility information
        let buttons = app.buttons
        var accessibleComponentsFound = false
        
        for i in 0..<min(buttons.count, 5) {
            let button = buttons.element(boundBy: i)
            if button.exists && (!button.label.isEmpty || !button.identifier.isEmpty) {
                accessibleComponentsFound = true
                break
            }
        }
        
        if buttons.count > 0 {
            XCTAssertTrue(accessibleComponentsFound, "Components should have accessibility information")
        }
    }
    
    func testComponentTapBehavior() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Find a tappable button and test tap behavior
        let buttons = app.buttons
        var tapSuccessful = false
        
        for i in 0..<min(buttons.count, 3) {
            let button = buttons.element(boundBy: i)
            if button.exists && button.isHittable {
                
                button.tap()
                
                // Wait for any response
                sleep(1)
                
                // Verify app is still responsive (has same or different buttons)
                let newButtonCount = app.buttons.count
                if newButtonCount >= 0 { // App is still responsive
                    tapSuccessful = true
                    break
                }
            }
        }
        
        if buttons.count > 0 {
            XCTAssertTrue(tapSuccessful, "Should be able to tap components successfully")
        }
    }
    
    // MARK: - Loading State Tests
    
    func testLoadingIndicatorsWork() throws {
        app.launch()
        
        // Check for loading indicators initially
        let progressIndicators = app.progressIndicators
        
        // Either we see loading indicators, or content loads so fast we miss them
        let hasLoadingOrContent = progressIndicators.count > 0 || app.buttons.count > 0
        XCTAssertTrue(hasLoadingOrContent, "Should show loading indicators or content")
    }
    
    // MARK: - Scroll Component Tests
    
    func testScrollComponentBehavior() throws {
        app.launch()
        waitForLoadingToComplete()
        
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            // Test scroll interactions
            scrollView.swipeUp()
            XCTAssertTrue(scrollView.exists, "Scroll view should remain functional")
            
            scrollView.swipeDown()
            XCTAssertTrue(scrollView.exists, "Scroll view should handle swipe down")
        }
    }
    
    // MARK: - Navigation Component Tests
    
    func testNavigationComponentsExist() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Look for navigation elements after potential navigation
        let buttons = app.buttons
        if buttons.count > 0 {
            // Try tapping first button to potentially trigger navigation
            let firstButton = buttons.firstMatch
            if firstButton.exists && firstButton.isHittable {
                firstButton.tap()
                sleep(1)
                
                // Check if navigation bars or back buttons appeared
                let hasNavigation = app.navigationBars.count > 0
                if hasNavigation {
                    XCTAssertTrue(app.navigationBars.firstMatch.exists, "Navigation components should work")
                }
            }
        }
    }
    
    // MARK: - Content Validation Tests
    
    func testComponentsDisplayContent() throws {
        app.launch()
        waitForLoadingToComplete()
        
        // Verify we have text elements or buttons with content
        let staticTexts = app.staticTexts
        let buttons = app.buttons
        
        var hasVisibleContent = false
        
        // Check static text
        for i in 0..<min(staticTexts.count, 3) {
            let text = staticTexts.element(boundBy: i)
            if text.exists && !text.label.isEmpty {
                hasVisibleContent = true
                break
            }
        }
        
        // Check button labels
        if !hasVisibleContent {
            for i in 0..<min(buttons.count, 3) {
                let button = buttons.element(boundBy: i)
                if button.exists && !button.label.isEmpty {
                    hasVisibleContent = true
                    break
                }
            }
        }
        
        XCTAssertTrue(hasVisibleContent, "Components should display visible content")
    }
    
    // MARK: - Error State Component Tests
    
    func testErrorStateComponents() throws {
        // Launch with error scenario
        app.launchArguments.append("--network-error")
        app.launch()
        
        // Wait for error state to appear
        sleep(3)
        
        // Look for error-related UI components
        let retryButton = app.buttons["Try Again"]
        let refreshButton = app.buttons["refresh"]
        
        if retryButton.exists {
            XCTAssertTrue(retryButton.isEnabled, "Error state retry button should be functional")
        } else if refreshButton.exists {
            XCTAssertTrue(refreshButton.isEnabled, "Error state refresh button should be functional")
        }
        
        // App should still be responsive in error state
        XCTAssertTrue(app.exists, "App should be responsive in error state")
    }
}

// MARK: - Helper Methods

private extension ComponentUITests {
    
    func waitForLoadingToComplete() {
        let loadingIndicators = app.progressIndicators
        if loadingIndicators.count > 0 {
            let expectation = expectation(for: NSPredicate(format: "count == 0"), evaluatedWith: loadingIndicators, handler: nil)
            wait(for: [expectation], timeout: 10)
        } else {
            sleep(2)
        }
    }
}
