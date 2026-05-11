// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// About
  internal static let about = L10n.tr("Localizable", "About", fallback: "About")
  /// Account
  internal static let account = L10n.tr("Localizable", "Account", fallback: "Account")
  /// Account management
  internal static let accountManagement = L10n.tr("Localizable", "accountManagement", fallback: "Account management")
  /// Radiofy uses industry-standard encryption to protect the confidentiality of your personal information.
  internal static let accountSecurityFooter = L10n.tr("Localizable", "accountSecurityFooter", fallback: "Radiofy uses industry-standard encryption to protect the confidentiality of your personal information.")
  /// This action cannot be undone.
  internal static let actionCannotBeUndone = L10n.tr("Localizable", "actionCannotBeUndone", fallback: "This action cannot be undone.")
  /// Almost there
  internal static let almostThere = L10n.tr("Localizable", "almostThere", fallback: "Almost there")
  /// An email was sent to
  internal static let anEmailWasSentTo = L10n.tr("Localizable", "An email was sent to", fallback: "An email was sent to")
  /// Apple credential is missing.
  internal static let appleCredentialMissing = L10n.tr("Localizable", "appleCredentialMissing", fallback: "Apple credential is missing.")
  /// Apple identity token is missing.
  internal static let appleIdentityTokenMissing = L10n.tr("Localizable", "appleIdentityTokenMissing", fallback: "Apple identity token is missing.")
  /// Apple sign in failed.
  internal static let appleSignInFailed = L10n.tr("Localizable", "appleSignInFailed", fallback: "Apple sign in failed.")
  /// This action requires you to enter your password.
  internal static let askPassword = L10n.tr("Localizable", "askPassword", fallback: "This action requires you to enter your password.")
  /// Back
  internal static let back = L10n.tr("Localizable", "back", fallback: "Back")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "Cancel", fallback: "Cancel")
  /// Cancel
  internal static let cancelButton = L10n.tr("Localizable", "cancelButton", fallback: "Cancel")
  /// Change profile photo
  internal static let changeProfilePhoto = L10n.tr("Localizable", "Change profile photo", fallback: "Change profile photo")
  /// Choose from library
  internal static let chooseFromLibrary = L10n.tr("Localizable", "Choose from library", fallback: "Choose from library")
  /// Your code has expired. Please request a new one.
  internal static let codeExpiredRequestNew = L10n.tr("Localizable", "codeExpiredRequestNew", fallback: "Your code has expired. Please request a new one.")
  /// Code expires in %@.
  internal static func codeExpiresIn(_ p1: Any) -> String {
    return L10n.tr("Localizable", "codeExpiresIn", String(describing: p1), fallback: "Code expires in %@.")
  }
  /// Could not get info, try later.
  internal static let couldNotGetInfoTryLater = L10n.tr("Localizable", "Could not get info, try later.", fallback: "Could not get info, try later.")
  /// Could not open document, try later.
  internal static let couldNotOpenDocumentTryLater = L10n.tr("Localizable", "Could not open document, try later.", fallback: "Could not open document, try later.")
  /// Localizable.strings
  ///   Radiofy
  /// 
  ///   Created by Fabrice Etiennette on 05/05/2020.
  ///   Copyright © 2020 Fabrice Etiennette. All rights reserved.
  internal static let createAccount = L10n.tr("Localizable", "Create account", fallback: "Create account")
  /// Create a Radiofy ID
  internal static let createRadiofyId = L10n.tr("Localizable", "createRadiofyId", fallback: "Create a Radiofy ID")
  /// Delete Account
  internal static let deleteAccount = L10n.tr("Localizable", "DeleteAccount", fallback: "Delete Account")
  /// Delete account failed
  internal static let deleteAccountFailed = L10n.tr("Localizable", "deleteAccountFailed", fallback: "Delete account failed")
  /// Delete your account?
  internal static let deleteYourAccountQuestion = L10n.tr("Localizable", "deleteYourAccountQuestion", fallback: "Delete your account?")
  /// Done
  internal static let done = L10n.tr("Localizable", "done", fallback: "Done")
  /// Duration
  internal static let duration = L10n.tr("Localizable", "Duration", fallback: "Duration")
  /// Edit Profile
  internal static let editProfile = L10n.tr("Localizable", "Edit Profile", fallback: "Edit Profile")
  /// This could be your first name or a nickname.
  internal static let editNickname = L10n.tr("Localizable", "edit_Nickname", fallback: "This could be your first name or a nickname.")
  /// Email
  internal static let email = L10n.tr("Localizable", "email", fallback: "Email")
  /// Email entered is not valid.
  internal static let emailInvalid = L10n.tr("Localizable", "email_invalid", fallback: "Email entered is not valid.")
  /// You can add your favorite radio stations here.
  internal static let emptyLibraryMessage = L10n.tr("Localizable", "empty_Library_Message", fallback: "You can add your favorite radio stations here.")
  /// Episodes
  internal static let episodes = L10n.tr("Localizable", "Episodes", fallback: "Episodes")
  /// Error
  internal static let error = L10n.tr("Localizable", "Error", fallback: "Error")
  /// Error saving user data
  internal static let errorSavingUserData = L10n.tr("Localizable", "Error saving user data", fallback: "Error saving user data")
  /// Error Unavailable
  internal static let errorUnavailable = L10n.tr("Localizable", "Error Unavailable", fallback: "Error Unavailable")
  /// Forgot password
  internal static let forgotPassword = L10n.tr("Localizable", "forgotPassword", fallback: "Forgot password")
  /// Forgot your password?
  internal static let forgotYourPassword = L10n.tr("Localizable", "forgotYourPassword", fallback: "Forgot your password?")
  /// Getting things ready
  internal static let gettingThingsReady = L10n.tr("Localizable", "gettingThingsReady", fallback: "Getting things ready")
  /// Good Afternoon
  internal static let goodAfternoon = L10n.tr("Localizable", "Good Afternoon", fallback: "Good Afternoon")
  /// Good Evening
  internal static let goodEvening = L10n.tr("Localizable", "Good Evening", fallback: "Good Evening")
  /// Good Morning
  internal static let goodMorning = L10n.tr("Localizable", "Good Morning", fallback: "Good Morning")
  /// Good Night
  internal static let goodNight = L10n.tr("Localizable", "Good Night", fallback: "Good Night")
  /// Go Premium
  internal static let goPremium = L10n.tr("Localizable", "goPremium", fallback: "Go Premium")
  /// Hide password
  internal static let hidePassword = L10n.tr("Localizable", "hidePassword", fallback: "Hide password")
  /// Home
  internal static let home = L10n.tr("Localizable", "Home", fallback: "Home")
  /// is temporarily unavailable.
  internal static let isTemporarilyUnavailable = L10n.tr("Localizable", "is temporarily unavailable.", fallback: "is temporarily unavailable.")
  /// Just
  internal static let just = L10n.tr("Localizable", "Just", fallback: "Just")
  /// Library
  internal static let library = L10n.tr("Localizable", "library", fallback: "Library")
  /// Wait 12 hours before start listening again or go premium!
  internal static let limitMessage = L10n.tr("Localizable", "limitMessage", fallback: "Wait 12 hours before start listening again or go premium!")
  /// Listening Limit Reached
  internal static let limitReached = L10n.tr("Localizable", "limitReached", fallback: "Listening Limit Reached")
  /// LIVE
  internal static let live = L10n.tr("Localizable", "LIVE", fallback: "LIVE")
  /// Live Radio
  internal static let liveRadio = L10n.tr("Localizable", "Live Radio", fallback: "Live Radio")
  /// Loading...
  internal static let loading = L10n.tr("Localizable", "Loading...", fallback: "Loading...")
  /// Loading
  internal static let loadingTitle = L10n.tr("Localizable", "loadingTitle", fallback: "Loading")
  /// Log in
  internal static let logIn = L10n.tr("Localizable", "Log in", fallback: "Log in")
  /// Log out
  internal static let logOut = L10n.tr("Localizable", "Log out", fallback: "Log out")
  /// Log in to Radiofy
  internal static let logInToRadiofy = L10n.tr("Localizable", "logInToRadiofy", fallback: "Log in to Radiofy")
  /// This will sign you out of Radiofy on this device.
  internal static let logoutMessage = L10n.tr("Localizable", "logoutMessage", fallback: "This will sign you out of Radiofy on this device.")
  /// Are you sure you want to log out?
  internal static let logOutMessage = L10n.tr("Localizable", "LogOutMessage", fallback: "Are you sure you want to log out?")
  /// Radiofy
  internal static let mainTitle = L10n.tr("Localizable", "main_title", fallback: "Radiofy")
  /// /month.
  internal static let month = L10n.tr("Localizable", "month.", fallback: "/month.")
  /// Name entered is not valid. 2 characters minimum & 15 Maximum.
  internal static let nameInvalid = L10n.tr("Localizable", "name_invalid", fallback: "Name entered is not valid. 2 characters minimum & 15 Maximum.")
  /// New password
  internal static let newPassword = L10n.tr("Localizable", "newPassword", fallback: "New password")
  /// New Podcast
  internal static let newPodcast = L10n.tr("Localizable", "newPodcast", fallback: "New Podcast")
  /// Get notified when a new podcast episode is available.
  internal static let newPodcastDescription = L10n.tr("Localizable", "newPodcastDescription", fallback: "Get notified when a new podcast episode is available.")
  /// No prior purchases found for your account.
  internal static let noPriorPurchasesFoundForYourAccount = L10n.tr("Localizable", "No prior purchases found for your account.", fallback: "No prior purchases found for your account.")
  /// Notifications
  internal static let notifications = L10n.tr("Localizable", "notifications", fallback: "Notifications")
  /// Radiofy uses your notification preferences to decide which alerts to send. You can change your preferences anytime in your account.
  internal static let notificationsFooter = L10n.tr("Localizable", "notificationsFooter", fallback: "Radiofy uses your notification preferences to decide which alerts to send. You can change your preferences anytime in your account.")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok", fallback: "OK")
  /// The best radio stations and podcasts on
  internal static let onboardingOne = L10n.tr("Localizable", "onboarding_one", fallback: "The best radio stations and podcasts on")
  /// Or
  internal static let or = L10n.tr("Localizable", "or", fallback: "Or")
  /// Password
  internal static let password = L10n.tr("Localizable", "password", fallback: "Password")
  /// Please make sure your password contain a least 8 characters, 1 special character and 1 number.
  internal static let passwordInvalid = L10n.tr("Localizable", "password_invalid", fallback: "Please make sure your password contain a least 8 characters, 1 special character and 1 number.")
  /// Enter the email address associated with your account and we’ll send you a verification code.
  internal static let passwordResetInstructions = L10n.tr("Localizable", "passwordResetInstructions", fallback: "Enter the email address associated with your account and we’ll send you a verification code.")
  /// Photo invalid, try again.
  internal static let photoInvalidTryAgain = L10n.tr("Localizable", "Photo invalid, try again.", fallback: "Photo invalid, try again.")
  /// Play
  internal static let play = L10n.tr("Localizable", "play", fallback: "Play")
  /// Please wait
  internal static let pleaseWait = L10n.tr("Localizable", "pleaseWait", fallback: "Please wait")
  /// Podcast
  internal static let podcast = L10n.tr("Localizable", "podcast", fallback: "Podcast")
  /// Privacy
  internal static let privacy = L10n.tr("Localizable", "privacy", fallback: "Privacy")
  /// Privacy Policy
  internal static let privacyPolicy = L10n.tr("Localizable", "Privacy Policy", fallback: "Privacy Policy")
  /// Radio
  internal static let radio = L10n.tr("Localizable", "radio", fallback: "Radio")
  /// Could not get radio station, try later
  internal static let radioTryLater = L10n.tr("Localizable", "radio_try_later", fallback: "Could not get radio station, try later")
  /// Ready
  internal static let ready = L10n.tr("Localizable", "Ready", fallback: "Ready")
  /// Remove current photo
  internal static let removeCurrentPhoto = L10n.tr("Localizable", "Remove current photo", fallback: "Remove current photo")
  /// Resend code
  internal static let resendCode = L10n.tr("Localizable", "resendCode", fallback: "Resend code")
  /// Reset password
  internal static let resetPassword = L10n.tr("Localizable", "Reset password", fallback: "Reset password")
  /// Reset your password
  internal static let resetYourPassword = L10n.tr("Localizable", "resetYourPassword", fallback: "Reset your password")
  /// Restore Unsuccessful
  internal static let restoreUnsuccessful = L10n.tr("Localizable", "Restore Unsuccessful", fallback: "Restore Unsuccessful")
  /// Save
  internal static let save = L10n.tr("Localizable", "Save", fallback: "Save")
  /// Search
  internal static let search = L10n.tr("Localizable", "Search", fallback: "Search")
  /// Search your radio
  internal static let searchYourRadio = L10n.tr("Localizable", "Search your radio", fallback: "Search your radio")
  /// Search
  internal static let searchTab = L10n.tr("Localizable", "SearchTab", fallback: "Search")
  /// Send
  internal static let send = L10n.tr("Localizable", "send", fallback: "Send")
  /// Send code
  internal static let sendCode = L10n.tr("Localizable", "sendCode", fallback: "Send code")
  /// Session
  internal static let session = L10n.tr("Localizable", "session", fallback: "Session")
  /// Settings
  internal static let settings = L10n.tr("Localizable", "Settings", fallback: "Settings")
  /// Show password
  internal static let showPassword = L10n.tr("Localizable", "showPassword", fallback: "Show password")
  /// SIGN UP
  internal static let signUp = L10n.tr("Localizable", "SIGN UP", fallback: "SIGN UP")
  /// Signed in
  internal static let signedIn = L10n.tr("Localizable", "signedIn", fallback: "Signed in")
  /// By signing up, you confirm that you have read and accept the Privacy Policy.
  internal static let signUpPrivacyConfirmation = L10n.tr("Localizable", "signUpPrivacyConfirmation", fallback: "By signing up, you confirm that you have read and accept the Privacy Policy.")
  /// 6-digit code
  internal static let sixDigitCode = L10n.tr("Localizable", "sixDigitCode", fallback: "6-digit code")
  /// Station unavaible, try later
  internal static let stationUnavaibleTryLater = L10n.tr("Localizable", "Station unavaible, try later", fallback: "Station unavaible, try later")
  /// Take photo
  internal static let takePhoto = L10n.tr("Localizable", "Take photo", fallback: "Take photo")
  /// Terms of Service
  internal static let termsOfService = L10n.tr("Localizable", "Terms of Service", fallback: "Terms of Service")
  /// Terms & Conditions
  internal static let termsAndConditions = L10n.tr("Localizable", "termsAndConditions", fallback: "Terms & Conditions")
  /// Unknown error
  internal static let unknownError = L10n.tr("Localizable", "unknownError", fallback: "Unknown error")
  /// Verification code expired. Please request a new code.
  internal static let verificationCodeExpiredRequestNew = L10n.tr("Localizable", "verificationCodeExpiredRequestNew", fallback: "Verification code expired. Please request a new code.")
  /// Please verify your email first
  internal static let verifiedEmailFirst = L10n.tr("Localizable", "verified_Email_First", fallback: "Please verify your email first")
  /// Verify
  internal static let verify = L10n.tr("Localizable", "verify", fallback: "Verify")
  /// We sent a 6-digit code to %@. Check your junk/spam folder.
  internal static func verifyEmailInfo(_ p1: Any) -> String {
    return L10n.tr("Localizable", "verifyEmailInfo", String(describing: p1), fallback: "We sent a 6-digit code to %@. Check your junk/spam folder.")
  }
  /// Verify your email
  internal static let verifyYourEmail = L10n.tr("Localizable", "verifyYourEmail", fallback: "Verify your email")
  /// You can resend in %@
  internal static func youCanResendIn(_ p1: Any) -> String {
    return L10n.tr("Localizable", "youCanResendIn", String(describing: p1), fallback: "You can resend in %@")
  }
  /// Your Library
  internal static let yourLibrary = L10n.tr("Localizable", "Your Library", fallback: "Your Library")
  internal enum AnErrorHadOccurred {
    /// An error had occurred. Try later.
    internal static let tryLater = L10n.tr("Localizable", "An error had occurred. Try later.", fallback: "An error had occurred. Try later.")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
