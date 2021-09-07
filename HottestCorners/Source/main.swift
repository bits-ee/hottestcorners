//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.

import Cocoa

autoreleasepool {
    let delegate = AppDelegate()
    withExtendedLifetime(delegate, {
        let application = NSApplication.shared
        application.delegate = delegate
        application.run()
        application.delegate = nil
    })
}
