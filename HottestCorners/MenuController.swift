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
        newStatusBarItem.button?.title = "HC" //without icon
        setAppStatusIcon()
        
        let m = NSMenu()

        let lbl = NSMenuItem(title: "Hottest Corners", action: nil, keyEquivalent: "")
            lbl.attributedTitle = NSAttributedString(string: "Speed up access to your apps", attributes: [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12.0)])
        m.addItem(lbl)

        let ll = m.addItem(withTitle: "⤦ Lower Left", action: nil, keyEquivalent: "")
        ll.tag = 1
        m.setSubmenu(getApplications(cornerKey: "llApp"), for: ll)
        
        let ul = m.addItem(withTitle: "⤣ Upper Left", action: nil, keyEquivalent: "")
        ul.tag = 2
        m.setSubmenu(getApplications(cornerKey: "ulApp"), for: ul)
        
        let ur = m.addItem(withTitle: "⤤ Upper Right", action: nil, keyEquivalent: "")
        ur.tag = 3
        m.setSubmenu(getApplications(cornerKey: "urApp"), for: ur)

        let lr = m.addItem(withTitle: "⤥ Lower Right", action: nil, keyEquivalent: "")
        lr.tag = 4
        m.setSubmenu(getApplications(cornerKey: "lrApp"), for: lr)
        
        m.addItem(NSMenuItem.separator())
        
        let p = m.addItem(withTitle: "Pause", action: #selector(togglePause(_:)), keyEquivalent: "")
            p.target = self
        
        let isPaused = UserDefaults.standard.bool(forKey: "isPaused")
        if (isPaused) {
            p.state = NSControl.StateValue.on
            newStatusBarItem.button?.image = NSImage(named:"StatusIconPaused")
            newStatusBarItem.button?.alternateImage = NSImage(named: "StatusIconPausedSelected")
        } else {
            p.state = NSControl.StateValue.off
            newStatusBarItem.button?.image = NSImage(named:"StatusIcon")
            newStatusBarItem.button?.alternateImage = NSImage(named: "StatusIconSelected")
        }
        
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
    
    func getApplications(cornerKey: String) -> NSMenu {
        
        let m = NSMenu()
        let nothing = NSMenuItem(title: "Do Nothing", action: #selector(setDoNothing(_:)), keyEquivalent: "")
        nothing.target = self //wft? menu items are disables without it
        nothing.tag = -1 //just a magic number encoding "Nothing"
        m.addItem(nothing)
        m.addItem(NSMenuItem.separator())
        
        let selectedApp = Corners.shared.getApp(cornerKey: cornerKey)
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
            UserDefaults.standard.set(nil, forKey: cornerKey)
            m.item(at: 0)?.state = NSControl.StateValue.on
        }
        
        return m
    }
    
    @objc func setApplication(_ sender: NSMenuItem) {
        
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        switch sender.parent!.tag {
        case 1:
            UserDefaults.standard.set(sender.title, forKey: "llApp")
        case 2:
            UserDefaults.standard.set(sender.title, forKey: "ulApp")
        case 3:
            UserDefaults.standard.set(sender.title, forKey: "urApp")
        case 4:
            UserDefaults.standard.set(sender.title, forKey: "lrApp")
        default:
            //FIXME, should be never called, but cannot be omitted
            UserDefaults.standard.set(sender.title, forKey: "err")
        }
    }
    
    @objc func setDoNothing(_ sender: NSMenuItem) {
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        switch sender.parent!.tag {
        case 1:
            UserDefaults.standard.set(nil, forKey: "llApp")
        case 2:
            UserDefaults.standard.set(nil, forKey: "ulApp")
        case 3:
            UserDefaults.standard.set(nil, forKey: "urApp")
        case 4:
            UserDefaults.standard.set(nil, forKey: "lrApp")
        default:
            //FIXME, should be never called, but cannot be omitted
            UserDefaults.standard.set(nil, forKey: "err")
        }
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
    
    @objc func togglePause(_ sender: NSMenuItem) {
        if sender.state == NSControl.StateValue.on {
            UserDefaults.standard.set(false, forKey: "isPaused")
            sender.state = NSControl.StateValue.off
            setAppStatusIcon()
        } else {
            UserDefaults.standard.set(true, forKey: "isPaused")
            sender.state = NSControl.StateValue.on
            setAppStatusIcon(isPaused: true)
        }
    }
    
    func setAppStatusIcon(isPaused: Bool = false) {
        if isPaused {
            newStatusBarItem.button?.image = NSImage(named:"StatusIconPaused")
            newStatusBarItem.button?.alternateImage = NSImage(named: "StatusIconPausedSelected")
        } else {
            newStatusBarItem.button?.image = NSImage(named:"StatusIcon")
            newStatusBarItem.button?.alternateImage = NSImage(named: "StatusIconSelected")
        }
    }
}
