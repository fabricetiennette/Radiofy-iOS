
public protocol HealthServicing {
    func pingHealth() async -> Bool
}
