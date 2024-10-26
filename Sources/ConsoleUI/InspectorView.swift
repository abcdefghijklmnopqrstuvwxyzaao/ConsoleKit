import ConsoleCore
import SwiftUI

struct InspectorView: View {
    let log: Log?

    var body: some View {
        if let log {
            List {
                LabeledContent("Type", value: log.level.rawValue.capitalized)
                LabeledContent("Timestamp", value: log.date.formatted())
                LabeledContent("Library", value: log.process)
                LabeledContent("PID : TID", value: log.pidtid)
                LabeledContent("Subsystem", value: log.subsystem)
                LabeledContent("Category", value: log.category)
            }
        }
    }
}
