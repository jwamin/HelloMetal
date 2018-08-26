//
//  ViewController.swift
//  Hello Metal - Mac
//
//  Created by Joss Manger on 8/15/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
    
    ///IDIOT!!!!
    var renderer:MetalRenderer!
    
    var metalView:MTKView! {
        get{
            return self.view as! MTKView
        }
    }
    
    override func loadView() {
        
        self.view = MTKView(frame:NSRect(x: 0, y: 0, width: 700, height: 400))
          print(view.bounds)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let device = MTLCreateSystemDefaultDevice() else {
            print("no metal")
            return
        }
        
        renderer = MetalRenderer(metalView: metalView, device: device)
        
        renderer.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        (view as! MTKView).delegate = renderer
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func mouseDown(with event: NSEvent) {
        renderer.setTouchInProgress(true)
    }
    
    override func mouseUp(with event: NSEvent) {
        renderer.setTouchInProgress(false)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

