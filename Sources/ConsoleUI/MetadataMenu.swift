import SwiftUI

struct MetadataMenu: View {
  @State
  var viewModel: ViewModel

  var body: some View {
    Menu {
      Toggle(isOn: $viewModel.isMetadataOn) {
        Text("Metadata")
      }

      Section {
        Toggle(isOn: $viewModel.isTypeOn) {
          Text("Type")
        }

        Toggle(isOn: $viewModel.isTimestampOn) {
          Text("Timestamp")
        }

        Toggle(isOn: $viewModel.isLibraryOn) {
          Label {
            Text("Library")
          } icon: {
            Image(systemName: "building.columns")
          }
        }

        Toggle(isOn: $viewModel.isPIDTIDOn) {
          Label {
            Text("PID:TID")
          } icon: {
            Image(systemName: "tag")
          }
        }

        Toggle(isOn: $viewModel.isSubsystemOn) {
          Label {
            Text("Subsystem")
          } icon: {
            Image(systemName: "gearshape.2")
          }
        }

        Toggle(isOn: $viewModel.isCategoryOn) {
          Label {
            Text("Category")
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
    .menuActionDismissBehavior(.disabled)
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
