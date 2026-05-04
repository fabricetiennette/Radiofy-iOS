import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public enum AuthEndpoint {
    case register
    case login
    case refresh
    case verifyEmail
    case resendVerification
    case forgotPassword
    case resetPassword
    case appleSignIn
    case me
    case deleteMe
    
    private var apiVersion: String { AppConfig.apiVersion }

    var path: String {
        switch self {
        case .register: return "\(apiVersion)/auth/register"
        case .login: return "\(apiVersion)/auth/login"
        case .refresh: return "\(apiVersion)/auth/refresh"
        case .verifyEmail: return "\(apiVersion)/auth/verify-email"
        case .resendVerification: return "\(apiVersion)/auth/verify-email/resend"
        case .forgotPassword: return "\(apiVersion)/auth/forgot-password"
        case .resetPassword: return "\(apiVersion)/auth/reset-password"
        case .appleSignIn: return "\(apiVersion)/auth/apple"
        case .me: return "\(apiVersion)/user/me"
        case .deleteMe: return "\(apiVersion)/user/me"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .register, .login, .refresh, .appleSignIn, .verifyEmail, .resendVerification, .forgotPassword, .resetPassword:
            return .post
        case .me:
            return .get
        case .deleteMe:
            return .delete
        }
    }
}
