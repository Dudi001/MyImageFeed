//
//  MyImageFeedUITests.swift
//  MyImageFeedUITests
//
//  Created by Мурад Манапов on 07.05.2023.
//

import XCTest

final class MyImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    let account = ""
    let password = ""
    let userName = ""
    let fullName = ""
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    
    
    func testFeed() {
        sleep(3)
        let tableView = app.tables
        let cell = tableView.children(matching: .cell).element(boundBy: 2)
        cell.swipeUp()
        
        XCTAssertTrue(app.waitForExistence(timeout: 3))
        
        let cellToLike = tableView.children(matching: .cell).element(boundBy: 1)
        let likeButton = cellToLike.buttons["LikeButton"]
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
        
        likeButton.tap()
        sleep(3)
        
        cell.tap()
        sleep(3)

        let image = app.scrollViews.images.element(boundBy: 0)
        sleep(4)
        image.pinch(withScale: 3, velocity: 1)
        sleep(2)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["BackButton"]
        backButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
    }
    
    func testProfile() {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(3)
        
        XCTAssertTrue(app.staticTexts[fullName].exists)
        XCTAssertTrue(app.staticTexts[userName].exists)
        
        let logoutButton = app.buttons["LogoutButton"]
        logoutButton.tap()
        
        sleep(1)
        
        app.alerts["Уже уходите?"].scrollViews.otherElements.buttons["Да"].tap()
    }
    
    func testAuth() throws {
        app.buttons["AuthenticateButton"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        loginTextField.tap()
        loginTextField.typeText(account)
        
        webView.swipeUp()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        passwordTextField.tap()
        passwordTextField.typeText(password)
        XCTAssertTrue(webView.waitForExistence(timeout: 1))

        let loginButton = webView.descendants(matching: .button).element
        XCTAssertTrue(webView.waitForExistence(timeout: 1))
        loginButton.tap()
        
        let tableView = app.tables
        let cell = tableView.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

}
