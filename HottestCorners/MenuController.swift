//
//  MenuController.swift
//  HottestCorners
//
//  Created by Zahhar Kirillov on 18.11.18.
//  Copyright © 2018 Baltic IT Solutions OÜ. All rights reserved.
//

import Cocoa

class MenuController: NSObject {
    
    var newStatusBarItem : NSStatusItem! //hard reference - wtf?!
    
    func populate() {
        newStatusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength) //.squareLength to display icon
        newStatusBarItem.button?.title = "HC" //tobe: newStatusBarItem.button?.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        
        let m = NSMenu()
        
        let lbl = NSMenuItem(title: "Hottest Corners", action: nil, keyEquivalent: "")
            lbl.attributedTitle = NSAttributedString(string: "Speed up access to your apps", attributes: [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12.0)])
        
        m.addItem(lbl)
        
        m.addItem(withTitle: "⤣ Upper Left", action: nil, keyEquivalent: "")
        m.addItem(withTitle: "⤤ Upper Right", action: nil, keyEquivalent: "")
        
        let ll = NSMenuItem(title: "⤦ Lower Left", action: nil, keyEquivalent: "")
        m.addItem(ll)
        m.setSubmenu(getApplications(), for: ll)
        
        m.addItem(withTitle: "⤥ Lower Right", action: nil, keyEquivalent: "")
        
        m.addItem(NSMenuItem.separator())
        
        let autorun = NSMenuItem(title: "Launch at Startup", action: nil, keyEquivalent: "")
        //todo: set state based on value saved to UserDefaults
        m.addItem(autorun)
        
        m.addItem(NSMenuItem.separator())
        
        m.addItem(withTitle: "Quit Hottest Corners", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        newStatusBarItem.menu = m
    }
    
    func getApplications() -> NSMenu {
        
        let m = NSMenu()
        let nothing = NSMenuItem(title: "Do Nothing", action: #selector(clearCorner(_:)), keyEquivalent: "")
        nothing.target = self //wft? menu items are disables without it
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
    
    //https://www.bignerdranch.com/blog/hannibal-selector/
    @objc func setApplication(_ sender: NSMenuItem) {
        
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        UserDefaults.standard.set(sender.title, forKey: "llApp")
        
        //print(sender.parent!.title)
        //print(sender.title)
    }
    
    @objc func clearCorner(_ sender: NSMenuItem) {
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        UserDefaults.standard.set(nil, forKey: "llApp")
    }
}
