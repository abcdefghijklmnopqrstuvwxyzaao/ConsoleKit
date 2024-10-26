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

    nonisolated func getDocument() async {
        func makePredicate(
            subsystem: String?,
            category: String?,
            query: String,
            filterTypes: Set<Log.Level>
        ) -> NSPredicate? {
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
                }
            )
            predicates.append(levelPredicate)

            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        do {
            let store = try OSLogStore(scope: .currentProcessIdentifier)
            let position = store.position(timeIntervalSinceLatestBoot: 0)
            let predicate = await makePredicate(
                subsystem: subsystem,
                category: category,
                query: query,
                filterTypes: filterTypes
            )
            let entries = try store.getEntries(at: position, matching: predicate)
            let logs = entries.compactMap({ $0 as? OSLogEntryLog })
                .map({ Log(id: UUID(), entry: $0) })
            await MainActor.run {
                self.logs = logs
                self.error = nil
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
}

@globalActor
struct TestActor {
  actor ActorType { }

  static let shared: ActorType = ActorType()
}
