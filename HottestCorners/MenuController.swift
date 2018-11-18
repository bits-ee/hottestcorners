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
        let sm = getApplications()
        
        let lbl = NSMenuItem(title: "Hottest Corners", action: nil, keyEquivalent: "")
            lbl.attributedTitle = NSAttributedString(string: "Run any app in screen corner", attributes: [ NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12.0)])
        
        m.addItem(lbl)
        
        let ul = NSMenuItem(title: "⤣ Upper Left", action: nil, keyEquivalent: "")
        m.addItem(ul)
        
        m.setSubmenu(sm, for: ul)
        
        m.addItem(withTitle: "⤤ Upper Right", action: nil, keyEquivalent: "")
        m.addItem(withTitle: "⤦ Lower Left", action: nil, keyEquivalent: "")
        m.addItem(withTitle: "⤥ Lower Right", action: nil, keyEquivalent: "")
        
        m.addItem(NSMenuItem.separator())
        
        let autorun = NSMenuItem(title: "Run on System Startup", action: nil, keyEquivalent: "")
        //todo: set state based on value saved to UserDefaults
        m.addItem(autorun)
        
        m.addItem(NSMenuItem.separator())
        
        m.addItem(withTitle: "Quit Hottest Corners", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        
        newStatusBarItem.menu = m
    }
    
    func getApplications() -> NSMenu {
        
        let m = NSMenu()
        
        let dir = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask)[0] //might have several /Application directories?
        
        let apps = try! FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: [], options:  [.skipsHiddenFiles, .skipsSubdirectoryDescendants]).filter{ $0.pathExtension == "app" }.sorted {a,b in
            a.absoluteString.lowercased() < b.absoluteString.lowercased() //cannot sort [URL] type, have to stringify first
        }
        for a in apps as [URL] {
            let appName = a.deletingPathExtension().lastPathComponent
            let item = NSMenuItem(title: appName, action: #selector(setApplication(_:)), keyEquivalent: "")
            item.target = self //wft? menu items are disables without it
            m.addItem(item)
        }
        
        return m
    }
    
    //https://www.bignerdranch.com/blog/hannibal-selector/
    @objc func setApplication(_ sender: NSMenuItem) {
        for i in (sender.parent?.submenu?.items)! {
            i.state = NSControl.StateValue.off
        }
        sender.state = NSControl.StateValue.on
        
        UserDefaults.standard.set(sender.title, forKey: "ulApp")
        
        //print(sender.parent!.title)
        //print(sender.title)
    }
}
