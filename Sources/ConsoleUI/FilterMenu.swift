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
          Text("Debug")
        }

        Toggle(isOn: isOn(.info)) {
          Text("Info")
        }

        Toggle(isOn: isOn(.notice)) {
          Text("Notice")
        }

        Toggle(isOn: isOn(.error)) {
          Text("Error")
        }

        Toggle(isOn: isOn(.fault)) {
          Text("Fault")
        }
      } header: {
        Text("Type")
      }

      if let subsystem = viewModel.subsystem {
        let isOn = Binding(
          get: { true },
          set: {
            if !$0 {
              viewModel.subsystem = nil
            }
          })

        Toggle(isOn: isOn) {
          Text("Subsystem")
          Text("\(subsystem)")
        }
      }

      if let category = viewModel.category {
        let isOn = Binding(
          get: { true },
          set: {
            if !$0 {
              viewModel.category = nil
            }
          })

        Toggle(isOn: isOn) {
          Text("Category")
          Text("\(category)")
        }
      }
    } label: {
      Image(systemName: "line.3.horizontal.decrease.circle")
    }
    .menuOrder(.fixed)
    .menuActionDismissBehavior(.disabled)
  }

}
