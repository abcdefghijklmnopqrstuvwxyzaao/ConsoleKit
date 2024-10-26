import Foundation

extension Log {
    package struct WithMetadataFormatStyle: Foundation.FormatStyle {
        package typealias FormatInput = Log
        package typealias FormatOutput = String
        
        package func format(_ value: Log) -> String {
            let metadata = [
                "Type: \(value.level.rawValue.capitalized)",
                "Timestamp: \(value.date.formatted())",
                "Process: \(value.process)",
                "Subsystem: \(value.subsystem)",
                "Category: \(value.category)",
                "TID: \(String(format: "%#llx", value.threadIdentifier))",
            ]
            return """
                \(value.composedMessage)
                \(metadata.joined(separator: " | "))
                """
        }
    }
    
    package struct DiagnosticsFormatStyle: Foundation.FormatStyle {
        package typealias FormatInput = Log
        package typealias FormatOutput = String
        
        package func format(_ value: Log) -> String {
            "[\(value.date.formatted())] [\(value.level.rawValue.uppercased())] \(value.composedMessage)"
        }
    }
}

extension Foundation.FormatStyle where Self == Log.WithMetadataFormatStyle {
    package static var withMetadata: Self { Self() }
}

extension Foundation.FormatStyle where Self == Log.DiagnosticsFormatStyle {
    package static var diagnostics: Self { Self() }
}

extension Log {
    package func formatted<T: Foundation.FormatStyle>(_ style: T) -> T.FormatOutput where T.FormatInput == Log {
        style.format(self)
    }
}
