import ConsoleCore
import SwiftUI

extension Log.Level {
    public var image: Image {
        switch self {
        case .debug:
            Image(systemName: "stethoscope")
        case .info:
            Image(systemName: "info")
        case .notice:
            Image(systemName: "bell.fill")
        case .error:
            Image(systemName: "exclamationmark.2")
        case .fault:
            Image(systemName: "exclamationmark.3")
        default:
            Image(systemName: "questionmark")
        }
    }

    public var color: Color {
        switch self {
        case .debug: .gray
        case .info: .blue
        case .notice: .gray
        case .error: .yellow
        case .fault: .red
        default: .gray
        }
    }

    public var tintColor: Color? {
        switch self {
        case .error: .yellow
        case .fault: .red
        default: .none
        }
    }

    @ViewBuilder
    func icon(width: Double, height: Double) -> some View {
        image
            .resizable()
            .scaledToFit()
            .padding(width / 4)
            .foregroundStyle(.white)
            .frame(width: width, height: height)
            .background(content: {
                RoundedRectangle(cornerRadius: width / 4)
                    .foregroundStyle(color)
            })
    }
}
