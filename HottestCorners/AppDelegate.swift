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
    //lazy because have to defer till app is loaded
    lazy var mouse = MouseController()
    let corners = Corners.shared
    
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        
        appMenu.populate()
        
        mouseEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [
            NSEvent.EventTypeMask.mouseMoved
            ], handler: self.mouse.checkLocation)
        
        screenEventMonitor = NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: NSApplication.shared, queue: OperationQueue.main) {
            notification -> Void in
            self.corners.get()
        }
        
            _ = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .localDomainMask, true)
            //let hcConfig = libraryDir[0] + "/Preferences/com.apple.dock.plist"
            //let theDict = NSDictionary.init(contentsOfFile: hcConfig)
            //print(theDict!)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
