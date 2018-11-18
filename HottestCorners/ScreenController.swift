//
//  ScreenController.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 18.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class ScreenController: NSObject {
    
    let debugMode: Bool

    init(_ debugMode: Bool) { //_ is used to supress need for label name when calling
        self.debugMode = debugMode
    }
    
    func recalculate() {
        if debugMode {
            print("Screen settings changed")
        }
    }
    
    func printScreenInfo() {
        for scr in NSScreen.screens {
            debugPrint(scr.frame)
        }
        
        let currentScreen = NSScreen.main
        debugPrint(currentScreen!.frame)
    }
}
