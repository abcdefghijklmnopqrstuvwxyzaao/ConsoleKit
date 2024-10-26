import ConsoleCore
import CoreTransferable
import OSLog
import Observation

@MainActor
@Observable
final class ViewModel {
  init(configuration: ConsoleConfiguration) {
    self.subsystem = configuration.subsystem
    self.category = configuration.category
  }

  var logs: [Log] = []
  var inspectoringLog: Log? = nil

  var error: (any Error)? = nil

  var isMetadataOn: Bool = true

  var isTypeOn: Bool = true
  var isTimestampOn: Bool = true
  var isLibraryOn: Bool = false
  var isPIDTIDOn: Bool = false
  var isSubsystemOn: Bool = false
  var isCategoryOn: Bool = false

  var filterTypes: Set<Log.Level> = [
    .error,
    .fault,
  ]
  var subsystem: String? = nil
  var category: String? = nil
  var query: String = ""

  var disabledShareLink: Bool {
    error != nil || logs.isEmpty
  }

  func getDocument() async {
    do {
      let store = try OSLogStore(scope: .currentProcessIdentifier)
      let position = store.position(timeIntervalSinceLatestBoot: 0)
      let entries = try store.getEntries(at: position, matching: predicate)
      let logs = entries.compactMap({ $0 as? OSLogEntryLog }).map({ Log(id: UUID(), entry: $0) })
      self.logs = logs
      self.error = nil
    } catch {
      self.error = error
    }
  }

  var predicate: NSPredicate? {
    var predicates: [NSPredicate] = []
    if let subsystem {
      predicates.append(NSPredicate(format: "subsystem == %@", subsystem))
    }
    if let category {
      predicates.append(NSPredicate(format: "category == %@", category))
    }
    if !query.isEmpty {
      predicates.append(NSPredicate(format: "eventMessage CONTAINS %@", query))
    }

    let levelPredicate = NSCompoundPredicate(
      orPredicateWithSubpredicates: filterTypes.map { level in
        NSPredicate(format: "messageType == %@", level.messageType)
      })
    predicates.append(levelPredicate)

    return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
  }
}

extension ViewModel: @preconcurrency Transferable {
  static var transferRepresentation: some TransferRepresentation {
    FileRepresentation(exportedContentType: .text) {
      let logs = await $0.logs
      let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("export.log")
      try logs.write(
        to: url
      )
      return .init(url)
    }
  }
}
