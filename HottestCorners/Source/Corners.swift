import Cocoa

final class Corners {

    static let shared = Corners()
    private init() {
        updateScreenPoints()
    }

    var lowerLeft = [NSPoint]()
    var upperRight = [NSPoint]()
    var lowerRight = [NSPoint]()
    var upperLeft = [NSPoint]()

    var llApp: String? { UserDefaults.lowerLeftAppName }
    var lrApp: String? { UserDefaults.lowerRightAppName }
    var ulApp: String? { UserDefaults.upperLeftAppName }
    var urApp: String? { UserDefaults.upperRightAppName }

    func updateScreenPoints() {
        lowerLeft = [NSPoint]()
        upperRight = [NSPoint]()
        lowerRight = [NSPoint]()
        upperLeft = [NSPoint]()
        
        for screen in NSScreen.screens {
            self.printScreenInfo(scr: screen)
            
            let ll = NSPoint(x: Int(screen.frame.minX), y: Int(screen.frame.minY))
            let ul = NSPoint(x: Int(screen.frame.minX), y: Int(screen.frame.maxY))
            let lr = NSPoint(x: Int(screen.frame.maxX), y: Int(screen.frame.minY))
            let ur = NSPoint(x: Int(screen.frame.maxX), y: Int(screen.frame.maxY))

            for secondScreen in NSScreen.screens {
                //checking lower left corner
                if
                    !NSPointInRect(NSPoint(x: ll.x, y: ll.y-1), secondScreen.frame) &&
                    !NSPointInRect(NSPoint(x: ll.x-1, y: ll.y), secondScreen.frame)
                {
                    lowerLeft.append(ll)
                }
                
                //checking for upper left corner
                if
                    !NSPointInRect(NSPoint(x: ul.x, y: ul.y+1), secondScreen.frame) &&
                    !NSPointInRect(NSPoint(x: ul.x-1, y: ul.y), secondScreen.frame)
                {
                    upperRight.append(ur)
                }
                
                //checking for lower right corner
                if
                    !NSPointInRect(NSPoint(x: lr.x, y: lr.y-1), secondScreen.frame) &&
                    !NSPointInRect(NSPoint(x: lr.x+1, y: lr.y), secondScreen.frame)
                {
                    lowerRight.append(lr)
                }
                
                //checking for upper right corner
                if
                    !NSPointInRect(NSPoint(x: ur.x, y: ur.y+1), secondScreen.frame) &&
                    !NSPointInRect(NSPoint(x: ur.x+1, y: ur.y), secondScreen.frame)
                {
                    upperLeft.append(ul)
                }
            }
        }
        
        log(string: "Upper left corners: \(upperLeft)")
        log(string: "Lower left corners: \(lowerLeft)")
        log(string: "Lower right corners: \(lowerRight)")
        log(string: "Upper right corners: \(upperRight)")
    }

    func printScreenInfo(scr: NSScreen) {
        #if DEBUG
            print("Screen \(scr.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! NSNumber) info")
            print(scr.frame.height)
            print(scr.frame.width)
            print(scr.frame.maxX)
            print(scr.frame.maxY)
            print(scr.frame.minX)
            print(scr.frame.minY)
        #endif
    }

    func log(string: String ) {
        // conditional compiling, expects debug flag set to -DDEBUG
        // under Project—>Build settings-> Other Swift Flags
        #if DEBUG
            debugPrint(string)
        #endif
    }

}
