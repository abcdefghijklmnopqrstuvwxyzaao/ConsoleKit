import ConsoleCore
import SwiftUI

struct LogView: View {
  let log: Log

  @State
  var viewModel: ViewModel

  var body: some View {
    VStack(alignment: .leading) {
      Text(log.composedMessage)
        .monospaced()
        .font(.callout)

      if viewModel.isMetadataOn {
        HStack {
          metadata

          Spacer()
        }
        .font(.caption2)
        .monospaced()
        .foregroundStyle(Color.gray)
        .lineLimit(1)
      }
    }
    .contextMenu(menuItems: {
      Section {
        Button {
          UIPasteboard.general.string = log.description
        } label: {
          Text("Copy Row without Metadata")
        }

        Button {
          UIPasteboard.general.string = log.composedMessage
        } label: {
          Text("Copy Row with All Metadata")
        }
      }

      Section {
        Button {
          viewModel.category = log.category
        } label: {
          Text("Category")
          Text("'\(log.category)'")
        }

        Button {
          viewModel.subsystem = log.subsystem
        } label: {
          Text("Subsystem")
          Text("'\(log.subsystem)'")
        }
      }
    })
    .listRowBackground(viewModel.isMetadataOn ? log.level.tintColor.opacity(0.1) : nil)
  }

  @ViewBuilder
  var metadata: some View {
    if viewModel.isTypeOn {
      log.level.icon(width: 16, height: 16)
    }

    if viewModel.isTimestampOn {
      Text(log.date.formatted(date: .omitted, time: .standard))
        .truncationMode(.head)
    }

    if viewModel.isLibraryOn {
      Label {
        Text(log.process)
          .truncationMode(.middle)
      } icon: {
        Image(systemName: "building.columns")
      }.labelStyle(MetadataLabelStyle())
    }

    if viewModel.isPIDTIDOn {
      Label {
        let pid = Text(log.processIdentifier.formatted(.number.grouping(.never)))
        let tid = Text(String(format: "%#llx", log.threadIdentifier))
        (pid + Text(":") + tid).truncationMode(.middle)
      } icon: {
        Image(systemName: "tag")
      }.labelStyle(MetadataLabelStyle())
    }

    if viewModel.isSubsystemOn {
      Label {
        Text(log.subsystem)
          .truncationMode(.middle)
      } icon: {
        Image(systemName: "gearshape.2")
      }.labelStyle(MetadataLabelStyle())
    }

    if viewModel.isCategoryOn {
      Label {
        Text(log.category)
          .truncationMode(.middle)
      } icon: {
        Image(systemName: "circle.grid.3x3")
      }.labelStyle(MetadataLabelStyle())
    }
  }
}
