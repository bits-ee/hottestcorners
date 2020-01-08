//
//  AppDelegate.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 14.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mouseEventMonitor: Any?
    var screenEventMonitor: Any?
    
    var appMenu = MenuController()
    lazy var mouse = MouseController() //lazy because have to defer till app is loaded
    
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        
        appMenu.populate()
        
        mouseEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [
            NSEvent.EventTypeMask.mouseMoved
            ], handler: self.mouse.checkLocation)
        
        screenEventMonitor = NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: NSApplication.shared, queue: OperationQueue.main) {
            notification -> Void in
            Corners.shared.getCoordinates()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
