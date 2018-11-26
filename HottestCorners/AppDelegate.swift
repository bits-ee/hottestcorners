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
    
    let debug = true
    
    var appMenu = MenuController()
    //lazy because have to defer till app is loaded
    lazy var scr = ScreenController(debugMode: debug)
    lazy var mouse = MouseController()
    
    func applicationWillFinishLaunching(_ aNotification: Notification) {
        
        //print(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String) //version number
        
        appMenu.populate()
        scr.getCorners()
        
        mouseEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [
            NSEvent.EventTypeMask.mouseMoved
            ], handler: self.mouse.checkLocation)
        
        screenEventMonitor = NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: NSApplication.shared, queue: OperationQueue.main) {
            notification -> Void in
            self.scr.getCorners()
        }
        
        if debug {
            _ = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .localDomainMask, true)
            //let hcConfig = libraryDir[0] + "/Preferences/com.apple.dock.plist"
            //let theDict = NSDictionary.init(contentsOfFile: hcConfig)
            //print(theDict!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}
