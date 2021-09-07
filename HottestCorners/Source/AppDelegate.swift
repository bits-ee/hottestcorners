//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.

import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {

    var mouseEventMonitor: Any?
    var screenEventMonitor: Any?

    lazy var mouse = MouseController()  // Lazy because have to defer till app is loaded

    func applicationWillFinishLaunching(_ aNotification: Notification) {

        StatusBarConfigurator.updateIcon()
        let menu = MainMenu()
        StatusBarConfigurator.addMenu(menu)

        mouseEventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [NSEvent.EventTypeMask.mouseMoved],
            handler: self.mouse.checkLocation
        )

        screenEventMonitor = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: NSApplication.shared,
            queue: OperationQueue.main
        ) { _ in
            Corners.shared.updateScreenPoints()
        }
    }

}
