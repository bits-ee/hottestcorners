//
//  MouseController.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 18.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class MouseController: NSObject {
    
    func isNear(mouse: NSPoint, target: NSPoint) -> Bool {
        let tolerance: CGFloat = 5 //pixels
        return ((pow((mouse.x - target.x), 2) + pow((mouse.y - target.y), 2)).squareRoot() < tolerance)
    }
    
    func checkLocation(_ event: NSEvent) {
        let mouse = NSEvent.mouseLocation
        //print(String(format: "%.0f, %.0f", mouse.x, mouse.y)) //print mouse coordinates realtime
        
        //check if mouse is in lower left corner
        for ll in Corners.ll {
            if isNear(mouse: mouse, target: ll) {
                launchApp(corner: "llApp")
                return
            }
        }
        
        //check if mouse is in lower right corner
        for lr in Corners.lr {
            if isNear(mouse: mouse, target: lr) {
                launchApp(corner: "lrApp")
                return
            }
        }
        
        //check if mouse is in upper left corner
        for ul in Corners.ul {
            if isNear(mouse: mouse, target: ul) {
                launchApp(corner: "ulApp")
                return
            }
        }

        //check if mouse is in upper right corner
        for ur in Corners.ur {
            if isNear(mouse: mouse, target: ur) {
                launchApp(corner: "urApp")
                return
            }
        }
    }
    
    func launchApp(corner: String) {
        let appName = UserDefaults.standard.string(forKey: corner) ?? ""
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
