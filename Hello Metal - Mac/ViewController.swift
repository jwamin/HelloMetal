//
//  ViewController.swift
//  Hello Metal - Mac
//
//  Created by Joss Manger on 8/15/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import Cocoa
import MetalKit
import ModelIO
import SceneKit.ModelIO

class ViewController: NSViewController {
    
    ///IDIOT!!!!
    var renderer:MetalRenderer!
    var device:MTLDevice!
    
    var metalView:MTKView! {
        get{
            return self.view as! MTKView
        }
    }
    
    var metalMesh:MTKMesh!
    
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
        
        self.device = device
        
        renderer = MetalRenderer(metalView: metalView, device: device)
        
        renderer.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        (view as! MTKView).delegate = renderer
        // Do any additional setup after loading the view.
        
        loadSCNGraph()
        
        
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

    func loadSCNGraph(){
        
        guard let scene = SCNScene(named: "NeXT.scn") else {
            print("error loading scene")
            return
        }
        
       
        let allocator = MTKMeshBufferAllocator(device: device)
        let sceneMetalAsset = MDLAsset(scnScene: scene, bufferAllocator: allocator)
        //print(sceneMetalAsset)
        //let iomesh = sceneMetalAsset.childObjects(of: MDLMesh.self)[0] as! MDLMesh
        //print(iomesh.self)
        
        
        
        do{

            var mtkmesh:[MTKMesh] = []
            //destructure!!!
            (_, mtkmesh) = try MTKMesh.newMeshes(asset: sceneMetalAsset, device: device)
            
            if let isMesh = mtkmesh.first{
                
                 metalMesh = isMesh
            }
           
            for buffer in metalMesh.vertexBuffers{
                print(buffer.buffer.contents())
            }
 
        } catch {
            print(error)
        }
        
        
       
        
        
        
    }

}

