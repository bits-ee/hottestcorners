//
//  MenuController.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 18.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa
import ServiceManagement

class MenuController: NSObject {
    
    var newStatusBarItem : NSStatusItem! //hard reference - wtf?!
    let helperBundleName = "ee.bits.HottestCornersHelper"
    
    func populate() {
        newStatusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) //.squareLength to display icon
        newStatusBarItem.button?.title = "HC" //tobe: newStatusBarItem.button?.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        
        let m = NSMenu()
        let sm = getApplications()
        let sm2 = getApplications()
        
        
        let lbl = NSMenuItem(title: "Hottest Corners", action: nil, keyEquivalent: "")
            lbl.attributedTitle = NSAttributedString(string: "Speed up access to your apps", attributes: [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12.0)])
        m.addItem(lbl)
        
        let ul = m.addItem(withTitle: "⤣ Upper Left", action: nil, keyEquivalent: "")
        m.setSubmenu(sm, for: ul)
        let ur = m.addItem(withTitle: "⤤ Upper Right", action: nil, keyEquivalent: "")
        m.setSubmenu(sm2, for: ur)
        let ll = m.addItem(withTitle: "⤦ Lower Left", action: nil, keyEquivalent: "")
        //m.setSubmenu(sm.copy() as? NSMenu, for: ll)
        let lr = m.addItem(withTitle: "⤥ Lower Right", action: nil, keyEquivalent: "")
        //m.setSubmenu(sm.copy() as? NSMenu, for: lr)
        
        m.addItem(NSMenuItem.separator())

        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }

        let lal = m.addItem(withTitle: "Launch at Login", action: #selector(toggleLaL(_:)), keyEquivalent: "")
            lal.target = self
            lal.state = foundHelper ? .on : .off
        
        m.addItem(NSMenuItem.separator())
        
        m.addItem(withTitle: "Quit Hottest Corners", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        newStatusBarItem.menu = m
    }
    
    func getApplications() -> NSMenu {
        
        let m = NSMenu()
        let nothing = NSMenuItem(title: "Do Nothing", action: #selector(setDoNothing(_:)), keyEquivalent: "")
        nothing.target = self //wft? menu items are disables without it
        nothing.tag = -1 //just a magic number
        m.addItem(nothing)
        m.addItem(NSMenuItem.separator())
        
        let selectedApp = UserDefaults.standard.string(forKey: "llApp") ?? nil
        var hasSelectedApp = false

        let dir = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask)[0] //might have several /Application directories?
        
        let apps = try! FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants]).filter{ $0.pathExtension == "app" }.sorted {a,b in
            a.absoluteString.lowercased() < b.absoluteString.lowercased() //cannot sort [URL] type, have to stringify first
        }
        for a in apps as [URL] {
            let appName = a.deletingPathExtension().lastPathComponent
            let item = NSMenuItem(title: appName, action: #selector(setApplication(_:)), keyEquivalent: "")
            item.target = self //wft? menu items are disables without it
            if appName == selectedApp {
                item.state = NSControl.StateValue.on
                hasSelectedApp = true
            }
            m.addItem(item)
        }
        
        if !hasSelectedApp {
            UserDefaults.standard.set(nil, forKey: "llApp")
            m.item(at: 0)?.state = NSControl.StateValue.on
        }
        
        return m
    }
    
    @objc func setApplication(_ sender: NSMenuItem) {
        
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        UserDefaults.standard.set(sender.title, forKey: "llApp")
        
        print(sender.parent!.title)
        print(sender.title)
    }
    
    @objc func setDoNothing(_ sender: NSMenuItem) {
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        UserDefaults.standard.set(nil, forKey: "llApp")
    }
    
    @objc func toggleLaL(_ sender: NSMenuItem) {
        if sender.state == NSControl.StateValue.on {
            SMLoginItemSetEnabled(helperBundleName as CFString, false)
            sender.state = NSControl.StateValue.off
        } else {
            SMLoginItemSetEnabled(helperBundleName as CFString, true)
            sender.state = NSControl.StateValue.on
        }
    }
}
