import PlaygroundSupport
import MetalKit

guard let device = MTLCreateSystemDefaultDevice() else {
    fatalError("GPU is not suported!")
}

//Setting up the view.. Configures it for the MetalRenderergit
let frame  = CGRect(x: 0, y: 0, width: 600, height: 600)
let view = MTKView(frame: frame, device: device)
view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)

//This manages the memory for the model
let allocator = MTKMeshBufferAllocator(device: device)

//Creates a primitive with a specified size; returns the mesh with vertex information in buffers
let mdlMesh = MDLMesh(sphereWithExtent: [0.75, 0.75, 0.75], segments: [100, 100], inwardNormals: false, geometryType: .triangles, allocator: allocator)

//Conveting the model_mesh to a metal_kit mesh so that it can be used by MetalKit
let mesh = try MTKMesh(mesh: mdlMesh, device: device)
