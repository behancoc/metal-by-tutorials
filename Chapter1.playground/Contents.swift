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
let mdlMesh = MDLMesh(sphereWithExtent: [0.75, 0.75, 0.75],
                      segments: [100, 100],
                      inwardNormals: false,
                      geometryType: .triangles,
                      allocator: allocator)

//Conveting the model_mesh to a metal_kit mesh so that it can be used by MetalKit
let mesh = try MTKMesh(mesh: mdlMesh, device: device)

guard let commandQueue = device.makeCommandQueue() else {
    fatalError("Could not create a command queue"   )
}


//Shader function containing teo shader functions: vertex shader and fragment shader
//Normally create seperate  file  with a .metal extension
let shader = """
#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[ attribute(0 ]];
};

vertex float4 vertex_main(const VertexIn vertex_in [[ stage_in]]) {
    return vertex_in.position;
}

fragment float4 fragment_main() {
    return float4(1, 0, 0, 1);
}
"""

let library = try device.makeLibrary(source: shader, options: nil)

let vertexFunction = library.makeFunction(name: "vertex_main")
let fragmentFunction = library.makeFunction(name: "fragment_main")
