//  Copyright © 2021 Baltic IT Solutions OÜ. All rights reserved.

import Cocoa
import ServiceManagement

final class ApplicationsMenu: NSMenu {

    init(corner: MainMenu.CornerType) {
        super.init(title: "ApplicationsMenu-\(corner.menuTitle())")

        addDoNothingItem()
        addSeparator()

        var selectedNothing = true
        ApplicationsList.shared.favoritesAppName.forEach  {
            addApplication(corner: corner, appName: $0)
            if corner.applicationName == $0 { selectedNothing = false }
        }
        addSeparator()
        ApplicationsList.shared.otherAppNames.forEach  {
            addApplication(corner: corner, appName: $0)
            if corner.applicationName == $0 { selectedNothing = false }
        }
        if selectedNothing {
            corner.removeApplication()
            item(at: 0)?.state = .on
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Add methods

private extension ApplicationsMenu {

    func addDoNothingItem() {
        let item = addItem(
            withTitle: "Do Nothing",
            action: #selector(setDoNothing(_:)),
            keyEquivalent: ""
        )
        item.target = self
        item.tag = -1  // Just a magic number encoding "Nothing"
    }

    func addApplication(corner: MainMenu.CornerType, appName: String) {
        let item = addItem(
            withTitle: appName,
            action: #selector(setApplication(_:)),
            keyEquivalent: ""
        )
        item.target = self
        if corner.applicationName == appName {
            item.state = .on
        }
    }

}

// MARK: - Menu actions

@objc
private extension ApplicationsMenu {

    func setApplication(_ sender: NSMenuItem) {
        guard
            let parentTag = sender.parent?.tag,
            let menuItems = sender.parent?.submenu?.items
        else {
            return
        }

        for item in menuItems {
            item.state = .off
        }
        sender.state = .on

        MainMenu.CornerType.getType(tag: parentTag)?.saveApplication(name: sender.title)
        StatusBarConfigurator.reloadMenu()
    }
    
    func setDoNothing(_ sender: NSMenuItem) {
        guard
            let parentTag = sender.parent?.tag,
            let menuItems = sender.parent?.submenu?.items
        else {
            return
        }

        for item in menuItems {
            item.state = .off
        }
        sender.state = .on

        MainMenu.CornerType.getType(tag: parentTag)?.removeApplication()
        StatusBarConfigurator.reloadMenu()
    }

}

// MARK: - Corner type extension

extension MainMenu.CornerType {

    static func getType(tag: Int) -> MainMenu.CornerType? {
        MainMenu.CornerType.allCases.first(where: { $0.menuTag == tag })
    }

    var applicationName: String? {
        switch self {
        case .lowerLeft:
            return UserDefaults.lowerLeftAppName
        case .lowerRight:
            return UserDefaults.lowerRightAppName
        case .upperLeft:
            return UserDefaults.upperLeftAppName
        case .upperRight:
            return UserDefaults.upperRightAppName
        }
    }

    func saveApplication(name: String) {
        switch self {
        case .lowerLeft:
            UserDefaults.setLowerLeftAppName(name)
        case .lowerRight:
            UserDefaults.setLowerRightAppName(name)
        case .upperLeft:
            UserDefaults.setUpperLeftAppName(name)
        case .upperRight:
            UserDefaults.setUpperRightAppName(name)
        }
    }

    func removeApplication() {
        switch self {
        case .lowerLeft:
            UserDefaults.removeLowerLeftAppName()
        case .lowerRight:
            UserDefaults.removeLowerRightAppName()
        case .upperLeft:
            UserDefaults.removeUpperLeftAppName()
        case .upperRight:
            UserDefaults.removeUpperRightAppName()
        }
    }

}
