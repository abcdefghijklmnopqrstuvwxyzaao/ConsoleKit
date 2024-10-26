import ConsoleUI
import OSLog
import SwiftUI

struct ContentView: View {

  @State
  var logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: #file
  )

  var body: some View {
    ConsoleView()
      .task {
        logger.debug("debug")
        logger.info("info")
        logger.notice("notice")
        logger.error("error")
        logger.fault("fault")
      }
  }
}
