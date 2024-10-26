import ConsoleCore
import SwiftUI

struct FilterMenu: View {
    @State
    var viewModel: ViewModel

    func isOn(_ level: Log.Level) -> Binding<Bool> {
        Binding(
            get: {
                viewModel.filterTypes.contains(level)
            },
            set: { isOn in
                if isOn {
                    viewModel.filterTypes.insert(level)
                } else {
                    viewModel.filterTypes.remove(level)
                }
            }
        )
    }

    var body: some View {
        Menu {
            Section {
                Toggle(isOn: isOn(.debug)) {
                    Text("Debug", bundle: .module)
                }

                Toggle(isOn: isOn(.info)) {
                    Text("Info", bundle: .module)
                }

                Toggle(isOn: isOn(.notice)) {
                    Text("Notice", bundle: .module)
                }

                Toggle(isOn: isOn(.error)) {
                    Text("Error", bundle: .module)
                }

                Toggle(isOn: isOn(.fault)) {
                    Text("Fault", bundle: .module)
                }
            } header: {
                Text("Type", bundle: .module)
            }

            if let subsystem = viewModel.subsystem {
                let isOn = Binding(
                    get: { true },
                    set: {
                        if !$0 {
                            viewModel.subsystem = nil
                        }
                    }
                )

                Toggle(isOn: isOn) {
                    Text("Subsystem", bundle: .module)
                    Text(subsystem)
                }
            }

            if let category = viewModel.category {
                let isOn = Binding(
                    get: { true },
                    set: {
                        if !$0 {
                            viewModel.category = nil
                        }
                    }
                )

                Toggle(isOn: isOn) {
                    Text("Category", bundle: .module)
                    Text(category)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
        .menuOrder(.fixed)
        .menuActionDismissBehavior(.disabled)
    }
}
