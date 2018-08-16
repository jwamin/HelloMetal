#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;

struct VertexIn {
    packed_float2 position;
    packed_float4 color;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_main(uint vertexId [[vertex_id]],
                             constant VertexIn *vertices [[buffer(0)]],
                             constant vector_uint2 *viewportSizePointer [[buffer(1)]],
                             constant float4x4 &transformation [[buffer(2)]]) {
    
    VertexOut out;
    
    float4 position = float4(vertices[vertexId].position,0.0,1.0);
    
    float4 transformed = position * transformation;
    
    float2 pixelSpacePosition = transformed.xy;
    
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    
    out.position = vector_float4(0.0,0.0,0.0,1.0);
    
    out.position.xy = pixelSpacePosition.xy / (viewportSize / 2.0);
    
    out.color = vertices[vertexId].color;
    
    return out;
    
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    
    return in.color;
    
}
