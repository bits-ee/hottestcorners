import Cocoa

final class StatusBarConfigurator {

    static let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    static func updateIcon() {
        guard let button = item.button else { return }
        button.title = "HC"
        if UserDefaults.isPaused {
            button.image = NSImage(named:"StatusIconPaused")
            button.alternateImage = NSImage(named: "StatusIconPausedSelected")
        } else {
            button.image = NSImage(named:"StatusIcon")
            button.alternateImage = NSImage(named: "StatusIconSelected")
        }
    }

    static func reloadMenu() {
        item.menu = MainMenu()
    }

}
