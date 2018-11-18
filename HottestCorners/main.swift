//
//  main.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 17.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

autoreleasepool {
    let delegate = AppDelegate()
    // NSApplication delegate is a weak reference,
    // so we have to make sure it's not deallocated.
    // In Objective-C you would use NS_VALID_UNTIL_END_OF_SCOPE
    withExtendedLifetime(delegate, {
        let application = NSApplication.shared
        application.delegate = delegate
        application.run()
        application.delegate = nil
    })
}
