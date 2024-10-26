import ConsoleCore
import SwiftUI

struct InspectorView: View {
    let log: Log?

    var body: some View {
        if let log {
            List {
                LabeledContent {
                    Text(log.level.rawValue.capitalized)
                } label: {
                    Text("Type", bundle: .module)
                }
                LabeledContent {
                    Text(log.date.formatted())
                } label: {
                    Text("Timestamp", bundle: .module)
                }
                LabeledContent {
                    Text(log.process)
                } label: {
                    Text("Library", bundle: .module)
                }
                LabeledContent {
                    Text(log.pidtid)
                } label: {
                    Text("PID : TID", bundle: .module)
                }
                LabeledContent {
                    Text(log.subsystem)
                } label: {
                    Text("Subsystem", bundle: .module)
                }
                LabeledContent {
                    Text(log.category)
                } label: {
                    Text("Category", bundle: .module)
                }
            }
        }
    }
}
