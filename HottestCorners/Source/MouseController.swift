//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.

import Cocoa

final class MouseController {

    func isNear(mouse: NSPoint, target: NSPoint) -> Bool {
        let tolerance: CGFloat = 2 //pixels
        return ((pow((mouse.x - target.x), 2) + pow((mouse.y - target.y), 2)).squareRoot() < tolerance)
    }

    func checkLocation(_ event: NSEvent) {
        let mouse = NSEvent.mouseLocation
        
        //check if mouse is in lower left corner
        if let name = UserDefaults.lowerLeftAppName {
            for ll in Corners.shared.lowerLeft {
                if isNear(mouse: mouse, target: ll) {
                    launchApp(name: name)
                    return
                }
            }
        }
        
        //check if mouse is in lower right corner
        if let name = UserDefaults.lowerRightAppName {
            for lr in Corners.shared.lowerRight {
                if isNear(mouse: mouse, target: lr) {
                    launchApp(name: name)
                    return
                }
            }
        }

        //check if mouse is in upper left corner
        if let name = UserDefaults.upperLeftAppName {
            for ul in Corners.shared.upperLeft {
                if isNear(mouse: mouse, target: ul) {
                    launchApp(name: name)
                    return
                }
            }
        }

        //check if mouse is in upper right corner
        if let name = UserDefaults.upperRightAppName {
            for ur in Corners.shared.upperRight {
                if isNear(mouse: mouse, target: ur) {
                    launchApp(name: name)
                    return
                }
            }
        }
    }

    func launchApp(name: String) {
        if !UserDefaults.isPaused {
            NSWorkspace.shared.launchApplication(name)
        }
        
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
