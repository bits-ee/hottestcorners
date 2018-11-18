//
//  MouseController.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 18.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class MouseController: NSObject {
    let spotSize = 5 //pixels
    
    func checkLocation(_ event: NSEvent) {
        let mouse = NSEvent.mouseLocation
        let (mouseX, mouseY) = (Int(mouse.x), Int(mouse.y))
        
        //print(String(format: "%.0f, %.0f", mouse.x, mouse.y)) //print mouse coordinates realtime
        
        if mouseX < spotSize && mouseY < spotSize {
            launchApp()
        }
    }
    
    func launchApp() {
        
        let appName = UserDefaults.standard.string(forKey: "ulApp") ?? ""
        NSWorkspace.shared.launchApplication(appName)
        
        // Other ways to launch applicayion
        // by bundler identifier:
        // NSWorkspace.shared.launchApplication(withBundleIdentifier: "pro.writer.mac",
        //                            options: .andHideOthers,
        //                            additionalEventParamDescriptor: nil,
        //                            launchIdentifier: nil)
        //
        // to launch an app by URL:
        // newapp = try! workspace.launchApplication(at: URL(string: "file:///Applications/Calculator.app/")!,
        // options: .andHideOthers,
        // configuration: [:])
        // newapp.activate(options: .activateIgnoringOtherApps) // bad practice, should be omitted
    }
}
