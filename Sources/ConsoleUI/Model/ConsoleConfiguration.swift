public struct ConsoleConfiguration: Sendable {
    public static let `default` = ConsoleConfiguration(subsystem: nil, category: nil)
    public let subsystem: String?
    public let category: String?

    public init(subsystem: String? = nil, category: String? = nil) {
        self.subsystem = subsystem
        self.category = category
    }
}
