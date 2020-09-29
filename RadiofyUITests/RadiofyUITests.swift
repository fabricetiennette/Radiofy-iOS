//swiftlint:disable force_cast type_body_length
//
//  RadiofyUITests.swift
//  RadiofyUITests
//
//  Created by Fabrice Etiennette on 20/04/2020.
//  Copyright © 2020 Fabrice Etiennette. All rights reserved.
//

import XCTest

class RadiofyUITests: XCTestCase {

   var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func logOutUser() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let signningOutButton = app.buttons.element(matching: .button, identifier: "SignOutButtonView")
        sleep(2)
        if settingButton.exists {
            settingButton.tap()
            signningOutButton.tap()
            app.alerts["Log out"].buttons["OK"].tap()
        }
        sleep(2)
    }

    func isUserLogIn() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let buttonLogIn = app.buttons.element(matching: .button, identifier: "LogInButtonView")
        let emailFields = app.textFields.element(matching: .textField, identifier: "emailLogInFields")
        let passwordFields = app.secureTextFields.element(matching: .secureTextField, identifier: "passwordLogInFields")
        let logIn = app.buttons.element(matching: .button, identifier: "LogInStartButton")
        if !settingButton.exists {
            sleep(2)
            buttonLogIn.tap()
            emailFields.tap()
            emailFields.typeText("radiofytest@gmail.com")
            passwordFields.tap()
            passwordFields.typeText("Qwerty10*")
            logIn.tap()
            sleep(2)
        }
    }

    func testStartPageAppear() {
        let buttonSignUp = app.buttons.element(matching: .button, identifier: "SignUpButtonView")
        let buttonLogIn = app.buttons.element(matching: .button, identifier: "LogInButtonView")
        logOutUser()
        XCTAssertEqual(buttonSignUp.label, "SIGN UP")
        XCTAssertEqual(buttonLogIn.label, "LOG IN")
    }

    func testStartButton() {
        let backButton = app.navigationBars.buttons["Back"]
        let buttonSignUp = app.buttons.element(matching: .button, identifier: "SignUpButtonView")
        let buttonLogIn = app.buttons.element(matching: .button, identifier: "LogInButtonView")
        logOutUser()
        buttonSignUp.tap()
        backButton.tap()
        buttonLogIn.tap()
        backButton.tap()
    }

    func testCreateUserWithError() {
        let buttonSignUp = app.buttons.element(matching: .button, identifier: "SignUpButtonView")
        let signUp = app.buttons.element(matching: .button, identifier: "signUpStartButton")
        let nameFields = app.textFields.element(matching: .textField, identifier: "nameTextSign")
        let emailFields = app.textFields.element(matching: .textField, identifier: "emailTextSign")
        let passwordFields = app.secureTextFields.element(matching: .secureTextField, identifier: "passwordTextSign")
        let errorLabel = app.staticTexts["errorSignUpLabel"]
        sleep(3)
        logOutUser()
        buttonSignUp.tap()
        passwordFields.tap()
        nameFields.tap()
        emailFields.tap()
        nameFields.tap()
        nameFields.typeText("tester12")
        while (nameFields.value as! String).count > 0 {
            app.keys["delete"].tap()
        }
        emailFields.tap()
        emailFields.typeText("tester12@oups")
        nameFields.tap()
        nameFields.typeText(" ")
        passwordFields.tap()
        passwordFields.typeText("tester12")
        nameFields.tap()
        nameFields.typeText("tester12")
        app.toolbars.buttons["Done"].tap()
        signUp.tap()
        sleep(2)
        XCTAssertEqual(errorLabel.label, "Email entered is not valid.")
    }

    func testLogInUserWithError() {
        let buttonLogIn = app.buttons.element(matching: .button, identifier: "LogInButtonView")
        let logIn = app.buttons.element(matching: .button, identifier: "LogInStartButton")
        let emailFields = app.textFields.element(matching: .textField, identifier: "emailLogInFields")
        let passwordFields = app.secureTextFields.element(matching: .secureTextField, identifier: "passwordLogInFields")
        let errorLabel = app.staticTexts["logInErrorLabel"]
        sleep(3)
        logOutUser()
        buttonLogIn.tap()
        passwordFields.tap()
        emailFields.tap()
        emailFields.typeText("tester12@")
        while (emailFields.value as! String).count > 0 {
            app.keys["delete"].tap()
        }
        passwordFields.tap()
        emailFields.tap()
        emailFields.typeText(" ")
        passwordFields.tap()
        passwordFields.typeText("tester12")
        emailFields.tap()
        emailFields.typeText("tester12@oups")
        logIn.tap()
        sleep(2)
        XCTAssertEqual(errorLabel.label, "Email entered is not valid.")
    }

    func testUserPasswordResetWithError() {
        let buttonLogIn = app.buttons.element(matching: .button, identifier: "LogInButtonView")
        let forgetPasswordButton = app.buttons.element(matching: .button, identifier: "forgetMyPasswordButton")
        let resetPassWord = app.buttons.element(matching: .button, identifier: "ResetPasswordBUTTON")
        let emailFields = app.textFields.element(matching: .textField, identifier: "emailResetFields")
        let errorLabel = app.staticTexts["errorResetPassWordLabel"]
        sleep(3)
        logOutUser()
        buttonLogIn.tap()
        app.toolbars.buttons["Done"].tap()
        forgetPasswordButton.tap()
        resetPassWord.tap()
        emailFields.tap()
        emailFields.typeText(" ")
        emailFields.typeText("tester12@")
        while (emailFields.value as! String).count > 0 {
            app.keys["delete"].tap()
        }
        emailFields.typeText(" ")
        resetPassWord.tap()
        emailFields.tap()
        emailFields.typeText("tester12@")
        resetPassWord.tap()
        sleep(2)
        XCTAssertEqual(errorLabel.label, "Email entered is not valid.")
    }

    func testUserPasswordResetWithSuccess() {
        let buttonLogIn = app.buttons.element(matching: .button, identifier: "LogInButtonView")
        let forgetPasswordButton = app.buttons.element(matching: .button, identifier: "forgetMyPasswordButton")
        let resetPassWord = app.buttons.element(matching: .button, identifier: "ResetPasswordBUTTON")
        let emailFields = app.textFields.element(matching: .textField, identifier: "emailResetFields")
        let errorLabel = app.staticTexts["errorResetPassWordLabel"]
        sleep(3)
        logOutUser()
        buttonLogIn.tap()
        app.toolbars.buttons["Done"].tap()
        forgetPasswordButton.tap()
        emailFields.tap()
        emailFields.typeText("radiofytest@gmail.com")
        resetPassWord.tap()
        sleep(2)
        XCTAssertEqual(errorLabel.label, "An email was send to radiofytest@gmail.com.")
    }

    func testHomeViewWithSuccess() {
        isUserLogIn()
    }

    func testHomeViewSelectRadioWithSuccess() {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)
        let myTable = app.tables.matching(identifier: "HomeTableView")
        let cell = myTable.cells.element(boundBy: 2)

        isUserLogIn()
        app.swipeUp()
        cell.tap()
        sleep(1)
        backButton.tap()
    }

    func testHomeViewSwipUpDownWithSuccess() {
        isUserLogIn()
        app.swipeUp()
        sleep(1)
        app.swipeDown()
    }

    func testPlayRadioStationWithSucces() {
        let myTable = app.tables.matching(identifier: "HomeTableView")
        let cell = myTable.cells.element(boundBy: 2)
        let play = app.buttons.element(matching: .button, identifier: "playButtonRadioView")
        let miniPlay = app.buttons.element(matching: .button, identifier: "MiniPlayButtonFromBar")
        let bar = app.staticTexts["BarTitleLabel"]
        let playButton = app.buttons.element(matching: .button, identifier: "radioPlayerPlayButton")
        let closeButton = app.buttons.element(matching: .button, identifier: "closeRadioPlayerButton")

        isUserLogIn()
        sleep(2)
        app.swipeUp()
        sleep(2)
        cell.tap()
        play.tap()
        sleep(5)
        miniPlay.tap()
        bar.tap()
        playButton.tap()
        closeButton.tap()
    }

    func testSearchViewWithSuccess() {
        let backButton = app.navigationBars.buttons["Search"]
        let textField = app.searchFields.element(matching: .searchField, identifier: "RadioSearchTextField")
        let searchButton = app.keyboards.buttons["Search"]
        let cell = app.collectionViews.cells.element(boundBy: 0)
        let del = app.keys["delete"]
        isUserLogIn()
        sleep(2)
        app.tabBars.buttons["Search"].tap()
        sleep(1)
        textField.tap()
        textField.typeText("france")
        searchButton.tap()
        cell.tap()
        backButton.tap()
        sleep(1)
        textField.doubleTap()
        sleep(1)
        del.tap()
        cell.tap()
        backButton.tap()
    }

    func testFavoriteWithSuccess() {
        let myTable = app.tables.matching(identifier: "HomeTableView")
        let cell = myTable.cells.element(boundBy: 2)
        let listTable = app.tables.matching(identifier: "favListId")
        let favCell = listTable.cells.element(matching: .cell, identifier: "favoriteRadioCell_0")
        let favButton = app.navigationBars.buttons["favoriteBtnItem"]
        let play = app.buttons.element(matching: .button, identifier: "playButtonRadioView")
        let bar = app.staticTexts["BarTitleLabel"]
        let favBtnRadioPlayer = app.buttons.element(matching: .button, identifier: "heartRadioPLayerButton")
        let back = app.navigationBars.buttons.element(boundBy: 0)

        isUserLogIn()
        app.tabBars.buttons["Your Library"].tap()
        if favCell.exists {
            favCell.tap()
            favButton.tap()
            back.tap()
        }
        app.tabBars.buttons["Home"].tap()
        app.swipeUp()
        cell.tap()
        favButton.tap()
        play.tap()
        sleep(5)
        bar.tap()
        sleep(1)
        app.swipeDown()
        app.tabBars.buttons["Your Library"].tap()
        favCell.tap()
        favButton.tap()
        back.tap()
        app.tabBars.buttons["Home"].tap()
        bar.tap()
        favBtnRadioPlayer.tap()
        app.swipeDown()
        app.tabBars.buttons["Your Library"].tap()
    }

    func testAboutViewWithSuccess() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(boundBy: 2)
        let thirdPartyButton = app.buttons["Third-party software"]
        let showPrivacyButton = app.buttons["Show Privacy Policy"]
        let done = app.buttons["Done"]

        isUserLogIn()
        settingButton.tap()
        cell.tap()
        sleep(1)
        thirdPartyButton.tap()
        sleep(2)
        done.tap()
        showPrivacyButton.tap()
        sleep(2)
        done.tap()
    }

    func testAccountViewWithFailure() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(boundBy: 1)
        let deleteButton = app.buttons["DELETE ACCOUNT"]

        isUserLogIn()
        settingButton.tap()
        cell.tap()
        sleep(1)
        deleteButton.tap()
        sleep(2)
        app.alerts["Delete Account"].buttons["Delete Account"].tap()
    }

    func testAccountViewWithSuccess() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let myTable = app.tables.matching(identifier: "SettingTableView")
        let cell = myTable.cells.element(boundBy: 1)
        let deleteButton = app.buttons["DELETE ACCOUNT"]

        isUserLogIn()
        settingButton.tap()
        cell.tap()
        sleep(1)
        deleteButton.tap()
        sleep(2)
        app.alerts["Delete Account"].buttons["Cancel"].tap()
    }

    func testEditProfileWithSave() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let editButton = app.buttons["EDIT YOUR PROFILE"]
        let changePhotoButton = app.buttons["CHANGE PHOTO"]
        let textField = app.textFields.element(matching: .textField, identifier: "nameChangeTextfield")

        isUserLogIn()
        settingButton.tap()
        sleep(1)
        editButton.tap()
        sleep(1)
        changePhotoButton.tap()
        app.sheets.buttons["Choose from library"].tap()
        sleep(2)
        app.otherElements.tables.cells["Moments"].tap()
        sleep(1)
        app.otherElements.collectionViews.cells["Photo, Landscape, August 08, 2012, 8:52 PM"].tap()
        sleep(1)
        app.buttons["Choose"].tap()
        textField.doubleTap()
        sleep(1)
        textField.typeText("1")
        app.toolbars.buttons["Done"].tap()
        app.buttons["Save"].tap()
        sleep(3)
    }

    func testEditProfileWithCancelAndFailure() {
        let settingButton = app.buttons.element(matching: .button, identifier: "SettingButtonView")
        let editButton = app.buttons["EDIT YOUR PROFILE"]
        let textField = app.textFields.element(matching: .textField, identifier: "nameChangeTextfield")
        let imageView = app.images.element(matching: .image, identifier: "imageViewChangePhoto")

        isUserLogIn()
        settingButton.tap()
        sleep(1)
        editButton.tap()
        sleep(1)
        imageView.tap()
        sleep(1)
        app.sheets.buttons["Choose from library"].tap()
        sleep(2)
        app.otherElements.tables.cells["Moments"].tap()
        sleep(1)
        app.otherElements.collectionViews.cells.firstMatch.tap()
        sleep(1)
        app.buttons["Choose"].tap()
        sleep(1)
        imageView.tap()
        sleep(1)
        app.sheets.buttons["Remove current photo"].tap()
        sleep(2)
        textField.doubleTap()
        sleep(1)
        textField.typeText("onetesterfive")
        app.toolbars.buttons["Done"].tap()
        app.buttons["Save"].tap()
        sleep(2)
        app.buttons["Cancel"].tap()
    }
}
