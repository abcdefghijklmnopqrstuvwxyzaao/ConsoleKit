import Foundation

package struct Log: Identifiable, Sendable, Codable {
    package let id: UUID
    package let date: Date
    package let composedMessage: String
    package let level: Level
    package let subsystem: String
    package let category: String
    package let process: String
    package let processIdentifier: pid_t
    package let threadIdentifier: UInt64

    package var pidtid: String {
        let pid = processIdentifier.formatted(.number.grouping(.never))
        let tid = String(format: "%#llx", threadIdentifier)
        return "\(pid):\(tid)"
    }
}

extension Log {
    package enum Level: String, CaseIterable, Codable {
        case debug
        case info
        case notice
        case error
        case fault
        case unknown

        // workaround: For logEvent and traceEvent, the type of the message itself: default, info, debug, error or fault.
        package var messageType: String {
            switch self {
            case .debug: rawValue
            case .info: rawValue
            case .notice: "default"
            case .error: rawValue
            case .fault: rawValue
            case .unknown: "default"
            }
        }
    }
}

extension Sequence where Element == Log {
    package func write(
        to url: URL,
        createFileIfNeeded: Bool = true,
        maxLength: Int = .max
    ) throws {
        if createFileIfNeeded {
            FileManager.default.createFileIfNeeded(url)
        }

        let fileHandle = try FileHandle(forWritingTo: url)
        fileHandle.seekToEndOfFile()

        for log in suffix(maxLength) {
            let data = Data(log.formatted(.diagnostics).utf8)
            try fileHandle.write(contentsOf: data)
            try fileHandle.write(contentsOf: Data("\n".utf8))
        }
        try fileHandle.close()
    }
}
