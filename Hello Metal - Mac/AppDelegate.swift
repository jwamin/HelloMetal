//
//  AppDelegate.swift
//  Hello Metal - Mac
//
//  Created by Joss Manger on 8/15/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("app del")
        let viewCOntroller = ViewController()
        let window = NSWindow(contentViewController: viewCOntroller)
        //window.frame = NSRect(origin: .zerp, size: CGSize(width: 400, height: 200))
        let windowController = NSWindowController(window: window)
        window.makeKeyAndOrderFront(self)
        windowController.showWindow(window)
      
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

