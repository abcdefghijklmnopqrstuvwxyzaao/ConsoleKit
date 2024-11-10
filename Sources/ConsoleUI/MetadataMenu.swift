import SwiftUI

@available(watchOS, unavailable)
struct MetadataMenu: View {
    @State
    var viewModel: ViewModel

    var body: some View {
        Menu {
            Toggle(isOn: $viewModel.isMetadataOn) {
                Text("Metadata", bundle: .module)
            }

            Section {
                Toggle(isOn: $viewModel.isTypeOn) {
                    Text("Type", bundle: .module)
                }

                Toggle(isOn: $viewModel.isTimestampOn) {
                    Text("Timestamp", bundle: .module)
                }

                Toggle(isOn: $viewModel.isLibraryOn) {
                    Label {
                        Text("Library", bundle: .module)
                    } icon: {
                        Image(systemName: "building.columns")
                    }
                }

                Toggle(isOn: $viewModel.isPIDTIDOn) {
                    Label {
                        Text("PID:TID", bundle: .module)
                    } icon: {
                        Image(systemName: "tag")
                    }
                }

                Toggle(isOn: $viewModel.isSubsystemOn) {
                    Label {
                        Text("Subsystem", bundle: .module)
                    } icon: {
                        Image(systemName: "gearshape.2")
                    }
                }

                Toggle(isOn: $viewModel.isCategoryOn) {
                    Label {
                        Text("Category", bundle: .module)
                    } icon: {
                        Image(systemName: "circle.grid.3x3")
                    }
                }
            }
            .disabled(!viewModel.isMetadataOn)
        } label: {
            Image(systemName: "switch.2")
        }
        .menuOrder(.fixed)
#if os(iOS)
        .menuActionDismissBehavior(.disabled)
#endif
    }
}

struct MetadataLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 2) {
            configuration.icon
            configuration.title
        }
    }
}
