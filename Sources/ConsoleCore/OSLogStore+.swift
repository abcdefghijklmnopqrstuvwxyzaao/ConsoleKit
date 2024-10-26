import Foundation
import OSLog

extension FileManager {
  func createFileIfNeeded(_ url: URL) {
    guard !fileExists(atPath: url.path()) else { return }
    createFile(atPath: url.path(), contents: nil)
  }
}

extension Log {
  package init(id: UUID, entry: OSLogEntryLog) {
    self.id = id
    self.date = entry.date
    self.composedMessage = entry.composedMessage
    self.level = .init(entry.level)
    self.subsystem = entry.subsystem
    self.category = entry.category
    self.process = entry.process
    self.processIdentifier = entry.processIdentifier
    self.threadIdentifier = entry.threadIdentifier
  }
}

extension Log.Level {
  package init(_ level: OSLogEntryLog.Level) {
    self =
      switch level {
      case .undefined: .unknown
      case .debug: .debug
      case .info: .info
      case .notice: .notice
      case .error: .error
      case .fault: .fault
      default: .unknown
      }
  }
}
