import Metal
import MetalKit
import simd
import GLKit

struct vertex {
    let position: (Float,Float)
    let color: (Float,Float,Float,Float)
    func floatBuffer()->[Float]{
        return [position.0,position.1,color.0,color.1,color.2,color.3]
    }
}

class MetalRenderer:NSObject, MTKViewDelegate {
    
    var mtkview:MTKView!
    var device:MTLDevice!
    var drawableSize:vector_int2!
    var commandQueue:MTLCommandQueue!
    var pipelineState:MTLRenderPipelineState!
    let identity = simd_float4x4(diagonal: float4(1,1,1,1))
    var rotationMatrix:matrix_float4x4 = simd_float4x4(diagonal: float4(1,1,1,1))
    var transformationUniform:MTLBuffer!
    var rotationAngle:Float = 0.0
    
    private var touchInProgress:Bool = false
    
    func setTouchInProgress(_ touchStatus:Bool){
        touchInProgress = touchStatus
    }
    
    
    
    @objc func animationStep(){
        
        if(touchInProgress){
            rotationAngle += 1.0
            if(rotationAngle>360.0){
                rotationAngle = 0.0
            }
            
            let glrotationMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(rotationAngle), 1.0, 1.0, 1.0)
            
            //reincorporate matrix here
            
            rotationMatrix = matrix_float4x4(float4(glrotationMatrix.m00, glrotationMatrix.m01, glrotationMatrix.m02, glrotationMatrix.m03), float4(glrotationMatrix.m10, glrotationMatrix.m11, glrotationMatrix.m12, glrotationMatrix.m13), float4(glrotationMatrix.m20, glrotationMatrix.m21, glrotationMatrix.m22, glrotationMatrix.m23), float4(glrotationMatrix.m30, glrotationMatrix.m31, glrotationMatrix.m32, glrotationMatrix.m33))
        } else {
            //rotationMatrix = rotationMatrix
        }
    }
    
    init(metalView:MTKView,device:MTLDevice){
        super.init()
        self.mtkview = metalView
        self.device = device
        self.mtkview.device = device
        
        self.mtkview.enableSetNeedsDisplay = false
        self.mtkview.isPaused = false
        self.mtkview.canDrawConcurrently = true
        
        commandQueue = device.makeCommandQueue()
        do {
            
            let library = device.makeDefaultLibrary()!
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.colorAttachments[0].pixelFormat = mtkview.colorPixelFormat
            pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertex_main")
            pipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragment_main")
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            print(library)
        } catch {
            fatalError("error loading shader lib")
        }
        
        mtkview.preferredFramesPerSecond = 60
        mtkview.delegate = self
        
        
        
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        drawableSize = vector_int2(Int32(size.width), Int32(size.height))
        print(drawableSize)
    }
    
    func draw(in view: MTKView) {
   
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let passDescriptor = view.currentRenderPassDescriptor else { return }
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor) else { return }
        
        let swiftVertices:[vertex] = [
            vertex(position: (-250,-250), color: (1.0, 0.0, 0.0, 1.0)),
            vertex(position: (250, -250), color: (0.0,1.0,0.0,1.0)),
            vertex(position:(0,250),color:(0.0,0.0,1.0,1.0))
        ]
        
        let swiftVerticesWhite:[vertex] = [
            vertex(position: (-250,-250), color: (1.0, 1.0, 1.0, 1.0)),
            vertex(position: (250, -250), color: (1.0,1.0,1.0,1.0)),
            vertex(position:(0,250),color:(1.0,1.0,1.0,1.0))
        ]
        
        var swiftVertexData = Array<Float>()
        var swiftWhiteVertexData = Array<Float>()
        
        for (index,vertex) in swiftVertices.enumerated(){
            swiftVertexData += vertex.floatBuffer()
            swiftWhiteVertexData += swiftVerticesWhite[index].floatBuffer()
        }
        
        //        let vertexData: [Float] = [
        //            -0.5, -0.5, 0, 1, 0, 0,
        //            0.5, -0.5, 0, 0, 1, 0,
        //            0,  0.5, 0, 0, 0, 1 ];
        
        let color = (touchInProgress) ? swiftVertexData : swiftWhiteVertexData
        
        encoder.setVertexBytes(color, length: swiftVertexData.count * MemoryLayout.size(ofValue: swiftVertexData), index: 0)
        
        encoder.setVertexBytes(&drawableSize, length: MemoryLayout.size(ofValue: drawableSize), index: 1)
        
        encoder.setVertexBytes(&rotationMatrix, length: MemoryLayout.size(ofValue: rotationMatrix), index: 2)
        encoder.setRenderPipelineState(pipelineState)
        
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()

    }
    
}
