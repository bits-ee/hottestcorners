//
//  Corners.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 28.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class Corners {
    //singleton pattern
    static let shared = Corners()
    private init(){ get() }
    
    var lowerLeft = [NSPoint]()
    var upperRight = [NSPoint]()
    var lowerRight = [NSPoint]()
    var upperLeft = [NSPoint]()
    
    let llApp = UserDefaults.standard.string(forKey: "llApp") ?? nil
    let lrApp = UserDefaults.standard.string(forKey: "lrApp") ?? nil
    let ulApp = UserDefaults.standard.string(forKey: "ulApp") ?? nil
    let urApp = UserDefaults.standard.string(forKey: "urlApp") ?? nil
    
    func get() -> Void {
        for s in NSScreen.screens {
            //self.printScreenInfo(scr: s)
            
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
            
            if !ulIsFalseCorner { upperLeft.append(ul) }
            if !llIsFalseCorner { lowerLeft.append(ll) }
            if !lrIsFalseCorner { lowerRight.append(lr) }
            if !urIsFalseCorner { upperRight.append(ur) }
        }
        
        log(string: "Upper left corners: \(upperLeft)")
        log(string: "Lower left corners: \(lowerLeft)")
        log(string: "Lower right corners: \(lowerRight)")
        log(string: "Upper right corners: \(upperRight)")
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
    
    func log(string: String ) {
        // conditional compiling, expects debug flag set to -DDEBUG
        //u nder Project—>Build settings-> Other Swift Flags
        #if DEBUG
            debugPrint(string)
        #endif
    }
}
