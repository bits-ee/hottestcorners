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
        for ll in Corners.shared.lowerLeft {
            if isNear(mouse: mouse, target: ll) {
                launchApp(cornerKey: "llApp")
                return
            }
        }
        
        //check if mouse is in lower right corner
        for lr in Corners.shared.lowerRight {
            if isNear(mouse: mouse, target: lr) {
                launchApp(cornerKey: "lrApp")
                return
            }
        }
        
        //check if mouse is in upper left corner
        for ul in Corners.shared.upperLeft {
            if isNear(mouse: mouse, target: ul) {
                launchApp(cornerKey: "ulApp")
                return
            }
        }

        //check if mouse is in upper right corner
        for ur in Corners.shared.upperRight {
            if isNear(mouse: mouse, target: ur) {
                launchApp(cornerKey: "urApp")
                return
            }
        }
    }
    
    func launchApp(cornerKey: String) {
        let appName = UserDefaults.standard.string(forKey: cornerKey) ?? ""
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
