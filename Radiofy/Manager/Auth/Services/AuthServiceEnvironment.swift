import SwiftUI

private struct AuthServiceKey: EnvironmentKey {
    static var defaultValue: AuthServicing? = nil
}

extension EnvironmentValues {
    var authService: AuthServicing? {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}
