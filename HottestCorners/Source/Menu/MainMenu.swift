import Cocoa
import ServiceManagement

final class MainMenu: NSMenu {

    init() {
        super.init(title: "MainMenu")

        ApplicationsList.shared.update()

        addTitleMenuItem()
        addSeparator()
        addCornerMenuItem(cornerType: .lowerLeft)
        addCornerMenuItem(cornerType: .upperLeft)
        addCornerMenuItem(cornerType: .upperRight)
        addCornerMenuItem(cornerType: .lowerRight)
        addSeparator()
        addPauseItem()
        addSeparator()
        addLaunchAtLoginItem()
        addSeparator()
        addQuitItem()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Add methods

private extension MainMenu {

    func addTitleMenuItem() {
        let item = addItem(
            withTitle: "Hottest Corners",
            action: nil,
            keyEquivalent: ""
        )
        item.attributedTitle = NSAttributedString(
            string: "Speed up access to your apps",
            attributes: [.font: NSFont.systemFont(ofSize: 12.0)]
        )
    }

    func addCornerMenuItem(cornerType: MainMenu.CornerType) {
        let item = addItem(
            withTitle: cornerType.menuTitle(appName: cornerType.applicationName),
            action: nil,
            keyEquivalent: ""
        )
        item.tag = cornerType.menuTag
        setSubmenu(
            ApplicationsMenu(corner: cornerType),
            for: item
        )
    }

    func addPauseItem() {
        let item = addItem(
            withTitle: "Pause",
            action: #selector(togglePause(_:)),
            keyEquivalent: ""
        )
        item.target = self

        if UserDefaults.isPaused {
            item.state = .on
        } else {
            item.state = .off
        }
    }

    func addLaunchAtLoginItem() {
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == Bundle.main.bundleIdentifier
        }
        let item = addItem(
            withTitle: "Launch at Login",
            action: #selector(toggleLaunchAtLogin(_:)),
            keyEquivalent: ""
        )
        item.target = self
        item.state = foundHelper ? .on : .off
    }

    func addQuitItem() {
        addItem(
            withTitle: "Quit Hottest Corners",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
    }

}

extension NSMenu {

    func addSeparator() {
        addItem(
            NSMenuItem.separator()
        )
    }

}

// MARK: - Menu actions

@objc
private extension MainMenu {

    func toggleLaunchAtLogin(_ sender: NSMenuItem) {
        guard let bundleName = Bundle.main.bundleIdentifier else { return }
        if sender.state == .on {
            SMLoginItemSetEnabled(bundleName as CFString, false)
            sender.state = .off
        } else {
            SMLoginItemSetEnabled(bundleName as CFString, true)
            sender.state = .on
        }
    }

    func togglePause(_ sender: NSMenuItem) {
        if sender.state == .on {
            UserDefaults.setPaused(false)
            sender.state = .off
        } else {
            UserDefaults.setPaused(true)
            sender.state = .on
        }
        StatusBarConfigurator.updateIcon()
    }

}

// MARK: - Corner type

extension MainMenu {

    enum CornerType: CaseIterable {
        case lowerLeft
        case lowerRight
        case upperLeft
        case upperRight

        private var emoji: String {
            switch self {
            case .lowerLeft:
                return "↙️"
            case .lowerRight:
                return "↘️"
            case .upperLeft:
                return "↖️"
            case .upperRight:
                return "↗️"
            }
        }

        private var defaultTitle: String {
            switch self {
            case .lowerLeft:
                return "Lower Left"
            case .lowerRight:
                return "Lower Right"
            case .upperLeft:
                return "Upper Left"
            case .upperRight:
                return "Upper Right"
            }
        }

        func menuTitle(appName: String? = nil) -> String {
            emoji + " " + (appName ?? defaultTitle)
        }

        var menuTag: Int {
            switch self {
            case .lowerLeft:
                return 1
            case .lowerRight:
                return 4
            case .upperLeft:
                return 2
            case .upperRight:
                return 3
            }
        }
    }

}
