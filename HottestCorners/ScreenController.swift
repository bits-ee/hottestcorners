//
//  ScreenController.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 18.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class ScreenController: NSObject {
    
    var debugMode: Bool
    
    init(debugMode: Bool) { //_ is used to supress need for label name when calling
        self.debugMode = debugMode
    }
    
    func getCorners() {
        for s in NSScreen.screens {
            //if self.debugMode { printScreenInfo(scr: s) }
        
            let ll = NSPoint(x: Int(s.frame.minX), y: Int(s.frame.minY))
            let ul = NSPoint(x: Int(s.frame.minX), y: Int(s.frame.maxY))
            let lr = NSPoint(x: Int(s.frame.maxX), y: Int(s.frame.minY))
            let ur = NSPoint(x: Int(s.frame.maxX), y: Int(s.frame.maxY))
            var llIsFalseCorner = false
            var ulIsFalseCorner = false
            var lrIsFalseCorner = false
            var urIsFalseCorner = false
            
            for s2 in NSScreen.screens {
                //checking lower left corner
                if(NSPointInRect(NSPoint(x: ll.x, y: ll.y-1), s2.frame) ||
                   NSPointInRect(NSPoint(x: ll.x-1, y: ll.y), s2.frame)) {
                    llIsFalseCorner = true
                }
                
                //checking for upper left corner
                if(NSPointInRect(NSPoint(x: ul.x, y: ul.y+1), s2.frame) ||
                    NSPointInRect(NSPoint(x: ul.x-1, y: ul.y), s2.frame)) {
                    ulIsFalseCorner = true
                }
                
                //checking for lower right corner
                if(NSPointInRect(NSPoint(x: lr.x, y: lr.y-1), s2.frame) ||
                    NSPointInRect(NSPoint(x: lr.x+1, y: lr.y), s2.frame)) {
                    lrIsFalseCorner = true
                }
                
                //checking for upper right corner
                if(NSPointInRect(NSPoint(x: ur.x, y: ur.y+1), s2.frame) ||
                    NSPointInRect(NSPoint(x: ur.x+1, y: ur.y), s2.frame)) {
                    urIsFalseCorner = true
                }
            }
            
            if !ulIsFalseCorner { Corners.ul.append(ul) }
            if !llIsFalseCorner { Corners.ll.append(ll) }
            if !lrIsFalseCorner { Corners.lr.append(lr) }
            if !urIsFalseCorner { Corners.ur.append(ur) }
        }
        
        if(self.debugMode) {
            print("Upper left corners: \(Corners.ul)")
            print("Lower left corners: \(Corners.ll)")
            print("Lower right corners: \(Corners.lr)")
            print("Upper right corners: \(Corners.ur)")
        }
    }
    
    func printScreenInfo(scr: NSScreen) {
        print("Screen \(scr.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! NSNumber) info")
        print(scr.frame.height)
        print(scr.frame.width)
        print(scr.frame.maxX)
        print(scr.frame.maxY)
        print(scr.frame.minX)
        print(scr.frame.minY)
    }
}
