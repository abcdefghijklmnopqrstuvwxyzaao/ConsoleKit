import ConsoleCore
import OSLog
import SwiftUI
import os

public struct ConsoleConfiguration: Sendable {
    public static let `default` = ConsoleConfiguration(subsystem: nil, category: nil)
    public let subsystem: String?
    public let category: String?

    public init(subsystem: String?, category: String?) {
        self.subsystem = subsystem
        self.category = category
    }
}

public struct ConsoleView: View {
    @State
    var viewModel: ViewModel

    public init(_ configuration: ConsoleConfiguration = .default) {
        _viewModel = .init(initialValue: ViewModel(configuration: configuration))
    }

    public var body: some View {
        NavigationStack(root: {
            contentView
                .navigationTitle(Text("Console", bundle: .module))
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        MetadataMenu(viewModel: viewModel)
                    }
                    ToolbarItem(placement: .bottomBar) {
                        FilterMenu(viewModel: viewModel)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        ShareLink(
                            item: Document(logs: viewModel.logs),
                            preview: SharePreview(Text("Diagnostics Log", bundle: .module))
                        )
                        .disabled(viewModel.disabledShareLink)
                    }
                    ToolbarItem(placement: .secondaryAction) {
                        Button {
                            Task {
                                await viewModel.getDocument()
                            }
                        } label: {
                            Label {
                                Text("Reload", bundle: .module)
                            } icon: {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                    }
                    ToolbarItem(placement: .secondaryAction) {
                        Button {
                            viewModel.logs = []
                        } label: {
                            Label {
                                Text("Clear", bundle: .module)
                            } icon: {
                                Image(systemName: "xmark.circle")
                            }
                        }
                    }
                }
        })
        .inspector(isPresented: isInspectorPresented) {
            InspectorView(log: viewModel.inspectoringLog)
        }
    }

    var isInspectorPresented: Binding<Bool> {
        .init(
            get: { viewModel.inspectoringLog != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.inspectoringLog = nil
                }
            }
        )
    }

    @ViewBuilder
    var contentView: some View {
        if let error = viewModel.error {
            ContentUnavailableView {
                Text(error.localizedDescription)
            }
        } else {
            logsView
                .task { [viewModel] in
                    await viewModel.getDocument()
                }
                .onChange(of: viewModel.category) {
                    Task { [viewModel] in
                        await viewModel.getDocument()
                    }
                }
                .onChange(of: viewModel.subsystem) {
                    Task { [viewModel] in
                        await viewModel.getDocument()
                    }
                }
                .onChange(of: viewModel.filterTypes) {
                    Task { [viewModel] in
                        await viewModel.getDocument()
                    }
                }
                .onChange(of: viewModel.query) {
                    Task { [viewModel] in
                        await viewModel.getDocument()
                    }
                }
        }
    }

    @ViewBuilder
    var logsView: some View {
        List {
            // 最新順に並び替え
            ForEach(viewModel.logs.reversed()) { log in
                Button {
                    viewModel.inspectoringLog = log
                } label: {
                    LogView(log: log, viewModel: viewModel)
                }

            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.query, prompt: Text("Filter", bundle: .module))
    }
}
