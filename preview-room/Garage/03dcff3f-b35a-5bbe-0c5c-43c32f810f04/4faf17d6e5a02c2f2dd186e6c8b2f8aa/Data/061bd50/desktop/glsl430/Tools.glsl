#version 430
//#include <required.glsl> // [HACK 4/6/2023] See SCC shader_merger.cpp
#define sc_StereoRendering_Disabled 0
#define sc_StereoRendering_InstancedClipped 1
#define sc_StereoRendering_Multiview 2
#ifdef VERTEX_SHADER
#define scOutPos(clipPosition) gl_Position=clipPosition
#define MAIN main
#endif
#ifdef SC_ENABLE_INSTANCED_RENDERING
#ifndef sc_EnableInstancing
#define sc_EnableInstancing 1
#endif
#endif
#define mod(x,y) (x-y*floor((x+1e-6)/y))
#if __VERSION__<300
#define isinf(x) (x!=0.0&&x*2.0==x ? true : false)
#define isnan(x) (x>0.0||x<0.0||x==0.0 ? false : true)
#define inverse(M) M
#endif
#ifdef sc_EnableStereoClipDistance
#if defined(GL_APPLE_clip_distance)
#extension GL_APPLE_clip_distance : require
#elif defined(GL_EXT_clip_cull_distance)
#extension GL_EXT_clip_cull_distance : require
#else
#error Clip distance is requested but not supported by this device.
#endif
#endif
#ifdef sc_EnableMultiviewStereoRendering
#define sc_StereoRenderingMode sc_StereoRendering_Multiview
#extension GL_OVR_multiview2 : require
#ifdef VERTEX_SHADER
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID*2+gl_InstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#endif
#define sc_LocalInstanceID sc_GlobalInstanceID
#define sc_StereoViewID int(gl_ViewID_OVR)
#endif
#elif defined(sc_EnableInstancedClippedStereoRendering)
#ifndef sc_EnableInstancing
#error Instanced-clipped stereo rendering requires enabled instancing.
#endif
#ifndef sc_EnableStereoClipDistance
#define sc_StereoRendering_IsClipDistanceEnabled 0
#else
#define sc_StereoRendering_IsClipDistanceEnabled 1
#endif
#define sc_StereoRenderingMode sc_StereoRendering_InstancedClipped
#define sc_NumStereoClipPlanes 1
#ifdef VERTEX_SHADER
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID*2+gl_InstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#endif
#define sc_LocalInstanceID (sc_GlobalInstanceID/2)
#define sc_StereoViewID (sc_GlobalInstanceID%2)
#endif
#else
#define sc_StereoRenderingMode sc_StereoRendering_Disabled
#endif
#if defined(sc_EnableInstancing)&&defined(VERTEX_SHADER)
#ifdef GL_ARB_draw_instanced
#extension GL_ARB_draw_instanced : require
#define gl_InstanceID gl_InstanceIDARB
#endif
#ifdef GL_EXT_draw_instanced
#extension GL_EXT_draw_instanced : require
#define gl_InstanceID gl_InstanceIDEXT
#endif
#ifndef sc_InstanceID
#define sc_InstanceID gl_InstanceID
#endif
#ifndef sc_GlobalInstanceID
#ifdef sc_EnableInstancingFallback
#define sc_GlobalInstanceID (sc_FallbackInstanceID)
#define sc_LocalInstanceID (sc_FallbackInstanceID)
#else
#define sc_GlobalInstanceID gl_InstanceID
#define sc_LocalInstanceID gl_InstanceID
#endif
#endif
#endif
#ifndef GL_ES
#extension GL_EXT_gpu_shader4 : enable
#extension GL_ARB_shader_texture_lod : enable
#define precision
#define lowp
#define mediump
#define highp
#define sc_FragmentPrecision
#endif
#ifdef GL_ES
#ifdef sc_FramebufferFetch
#if defined(GL_EXT_shader_framebuffer_fetch)
#extension GL_EXT_shader_framebuffer_fetch : require
#elif defined(GL_ARM_shader_framebuffer_fetch)
#extension GL_ARM_shader_framebuffer_fetch : require
#else
#error Framebuffer fetch is requested but not supported by this device.
#endif
#endif
#ifdef GL_FRAGMENT_PRECISION_HIGH
#define sc_FragmentPrecision highp
#else
#define sc_FragmentPrecision mediump
#endif
#ifdef FRAGMENT_SHADER
precision highp int;
precision highp float;
#endif
#endif
#ifdef VERTEX_SHADER
#ifdef sc_EnableMultiviewStereoRendering
layout(num_views=sc_NumStereoViews) in;
#endif
#endif
#define SC_INT_FALLBACK_FLOAT int
#define SC_INTERPOLATION_FLAT flat
#define SC_INTERPOLATION_CENTROID centroid
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_TextureRenderingLayout_Regular
#define sc_TextureRenderingLayout_Regular 0
#define sc_TextureRenderingLayout_StereoInstancedClipped 1
#define sc_TextureRenderingLayout_StereoMultiview 2
#endif
#if defined VERTEX_SHADER
struct sc_Vertex_t
{
vec4 position;
vec3 normal;
vec3 tangent;
vec2 texture0;
vec2 texture1;
};
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_StereoViewID
#define sc_StereoViewID 0
#endif
#ifndef sc_RenderingSpace
#define sc_RenderingSpace -1
#endif
#ifndef sc_TAAEnabled
#define sc_TAAEnabled 0
#elif sc_TAAEnabled==1
#undef sc_TAAEnabled
#define sc_TAAEnabled 1
#endif
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_SkinBonesCount
#define sc_SkinBonesCount 0
#endif
#ifndef sc_VertexBlending
#define sc_VertexBlending 0
#elif sc_VertexBlending==1
#undef sc_VertexBlending
#define sc_VertexBlending 1
#endif
#ifndef sc_VertexBlendingUseNormals
#define sc_VertexBlendingUseNormals 0
#elif sc_VertexBlendingUseNormals==1
#undef sc_VertexBlendingUseNormals
#define sc_VertexBlendingUseNormals 1
#endif
#ifndef sc_DepthBufferMode
#define sc_DepthBufferMode 0
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef sc_Voxelization
#define sc_Voxelization 0
#elif sc_Voxelization==1
#undef sc_Voxelization
#define sc_Voxelization 1
#endif
#ifndef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#elif UseViewSpaceDepthVariant==1
#undef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#endif
#ifndef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 0
#elif sc_OITDepthGatherPass==1
#undef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 1
#endif
#ifndef sc_OITCompositingPass
#define sc_OITCompositingPass 0
#elif sc_OITCompositingPass==1
#undef sc_OITCompositingPass
#define sc_OITCompositingPass 1
#endif
#ifndef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 0
#elif sc_OITDepthBoundsPass==1
#undef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 1
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
#endif
#ifndef sc_OutputBounds
#define sc_OutputBounds 0
#elif sc_OutputBounds==1
#undef sc_OutputBounds
#define sc_OutputBounds 1
#endif
uniform mat4 sc_ModelMatrix;
uniform mat4 sc_ProjectorMatrix;
uniform vec2 sc_TAAJitterOffset;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_PrevFrameViewProjectionMatrixArray[sc_NumStereoViews];
uniform mat4 sc_PrevFrameModelMatrix;
uniform mat4 sc_ModelMatrixInverse;
uniform int sc_FallbackInstanceID;
uniform vec4 sc_StereoClipPlanes[sc_NumStereoViews];
uniform vec4 sc_UniformConstants;
uniform int sc_ViewMask;
uniform vec4 sc_BoneMatrices[(sc_SkinBonesCount*3)+1];
uniform mat3 sc_SkinBonesNormalMatrices[sc_SkinBonesCount+1];
uniform vec4 weights0;
uniform vec4 weights1;
uniform mat4 sc_ProjectionMatrixInverseArray[sc_NumStereoViews];
uniform mat4 sc_ViewMatrixArray[sc_NumStereoViews];
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform sc_Camera_t sc_Camera;
uniform vec4 voxelization_params_0;
uniform vec4 voxelization_params_frustum_lrbt;
uniform vec4 voxelization_params_frustum_nf;
uniform vec3 voxelization_params_camera_pos;
uniform mat4 sc_ModelMatrixVoxelization;
uniform mat3 sc_NormalMatrix;
uniform int PreviewEnabled;
out vec4 varPosAndMotion;
out vec4 varNormalAndMotion;
out float varClipDistance;
flat out int varStereoViewID;
in vec4 boneData;
in vec3 blendShape0Pos;
in vec3 blendShape0Normal;
in vec3 blendShape1Pos;
in vec3 blendShape1Normal;
in vec3 blendShape2Pos;
in vec3 blendShape2Normal;
in vec3 blendShape3Pos;
in vec3 blendShape4Pos;
in vec3 blendShape5Pos;
in vec4 position;
in vec3 normal;
in vec4 tangent;
in vec2 texture0;
in vec2 texture1;
out vec4 varScreenPos;
out vec4 varTex01;
out vec4 varTangent;
out vec4 varColor;
in vec4 color;
out float varViewSpaceDepth;
out vec2 varShadowTex;
out vec4 PreviewVertexColor;
out float PreviewVertexSaved;
out vec2 varScreenTexturePos;
in vec3 positionNext;
in vec3 positionPrevious;
in vec4 strandProperties;
int sc_GetLocalInstanceIDInternal(int id)
{
#ifdef sc_LocalInstanceID
return sc_LocalInstanceID;
#else
return 0;
#endif
}
void blendTargetShapeWithNormal(inout sc_Vertex_t v,vec3 position_1,vec3 normal_1,float weight)
{
vec3 l9_0=v.position.xyz+(position_1*weight);
v=sc_Vertex_t(vec4(l9_0.x,l9_0.y,l9_0.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
v.normal+=(normal_1*weight);
}
void sc_BlendVertex(inout sc_Vertex_t v)
{
#if (sc_VertexBlending)
{
#if (sc_VertexBlendingUseNormals)
{
blendTargetShapeWithNormal(v,blendShape0Pos,blendShape0Normal,weights0.x);
blendTargetShapeWithNormal(v,blendShape1Pos,blendShape1Normal,weights0.y);
blendTargetShapeWithNormal(v,blendShape2Pos,blendShape2Normal,weights0.z);
}
#else
{
vec3 l9_0=v.position.xyz+(blendShape0Pos*weights0.x);
v=sc_Vertex_t(vec4(l9_0.x,l9_0.y,l9_0.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_1=v.position.xyz+(blendShape1Pos*weights0.y);
v=sc_Vertex_t(vec4(l9_1.x,l9_1.y,l9_1.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_2=v.position.xyz+(blendShape2Pos*weights0.z);
v=sc_Vertex_t(vec4(l9_2.x,l9_2.y,l9_2.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_3=v.position.xyz+(blendShape3Pos*weights0.w);
v=sc_Vertex_t(vec4(l9_3.x,l9_3.y,l9_3.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_4=v.position.xyz+(blendShape4Pos*weights1.x);
v=sc_Vertex_t(vec4(l9_4.x,l9_4.y,l9_4.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
vec3 l9_5=v.position.xyz+(blendShape5Pos*weights1.y);
v=sc_Vertex_t(vec4(l9_5.x,l9_5.y,l9_5.z,v.position.w),v.normal,v.tangent,v.texture0,v.texture1);
}
#endif
}
#endif
}
vec4 sc_GetBoneWeights()
{
vec4 l9_0;
#if (sc_SkinBonesCount>0)
{
vec4 l9_1=vec4(1.0,fract(boneData.yzw));
vec4 l9_2=l9_1;
l9_2.x=1.0-dot(l9_1.yzw,vec3(1.0));
l9_0=l9_2;
}
#else
{
l9_0=vec4(0.0);
}
#endif
return l9_0;
}
void sc_GetBoneMatrix(int index,out vec4 m0,out vec4 m1,out vec4 m2)
{
int l9_0=3*index;
m0=sc_BoneMatrices[l9_0];
m1=sc_BoneMatrices[l9_0+1];
m2=sc_BoneMatrices[l9_0+2];
}
vec3 skinVertexPosition(int i,vec4 v)
{
vec3 l9_0;
#if (sc_SkinBonesCount>0)
{
vec4 param_1;
vec4 param_2;
vec4 param_3;
sc_GetBoneMatrix(i,param_1,param_2,param_3);
l9_0=vec3(dot(v,param_1),dot(v,param_2),dot(v,param_3));
}
#else
{
l9_0=v.xyz;
}
#endif
return l9_0;
}
void sc_SkinPosition(inout vec4 position_1)
{
#if (sc_SkinBonesCount>0)
{
vec4 l9_0=sc_GetBoneWeights();
vec3 l9_1=(((skinVertexPosition(int(boneData.x),position_1)*l9_0.x)+(skinVertexPosition(int(boneData.y),position_1)*l9_0.y))+(skinVertexPosition(int(boneData.z),position_1)*l9_0.z))+(skinVertexPosition(int(boneData.w),position_1)*l9_0.w);
position_1=vec4(l9_1.x,l9_1.y,l9_1.z,position_1.w);
}
#endif
}
void sc_SkinNormal(inout vec3 normal_1)
{
#if (sc_SkinBonesCount>0)
{
vec4 l9_0=sc_GetBoneWeights();
normal_1=((((sc_SkinBonesNormalMatrices[int(boneData.x)]*normal_1)*l9_0.x)+((sc_SkinBonesNormalMatrices[int(boneData.y)]*normal_1)*l9_0.y))+((sc_SkinBonesNormalMatrices[int(boneData.z)]*normal_1)*l9_0.z))+((sc_SkinBonesNormalMatrices[int(boneData.w)]*normal_1)*l9_0.w);
}
#endif
}
void sc_SkinTangent(inout vec3 tangent_1)
{
#if (sc_SkinBonesCount>0)
{
vec4 l9_0=sc_GetBoneWeights();
tangent_1=((((sc_SkinBonesNormalMatrices[int(boneData.x)]*tangent_1)*l9_0.x)+((sc_SkinBonesNormalMatrices[int(boneData.y)]*tangent_1)*l9_0.y))+((sc_SkinBonesNormalMatrices[int(boneData.z)]*tangent_1)*l9_0.z))+((sc_SkinBonesNormalMatrices[int(boneData.w)]*tangent_1)*l9_0.w);
}
#endif
}
void sc_SkinVertex(inout sc_Vertex_t v)
{
sc_SkinPosition(v.position);
sc_SkinNormal(v.normal);
sc_SkinTangent(v.tangent);
}
int sc_GetStereoViewIndex()
{
int l9_0;
#if (sc_StereoRenderingMode==0)
{
l9_0=0;
}
#else
{
l9_0=sc_StereoViewID;
}
#endif
return l9_0;
}
void sc_SetClipDistancePlatform(float dstClipDistance)
{
#if sc_StereoRenderingMode==sc_StereoRendering_InstancedClipped&&sc_StereoRendering_IsClipDistanceEnabled
gl_ClipDistance[0]=dstClipDistance;
#endif
}
void sc_SetClipDistance(float dstClipDistance)
{
#if (sc_StereoRendering_IsClipDistanceEnabled==1)
{
sc_SetClipDistancePlatform(dstClipDistance);
}
#else
{
varClipDistance=dstClipDistance;
}
#endif
}
void sc_SetClipDistance(vec4 clipPosition)
{
#if (sc_StereoRenderingMode==1)
{
sc_SetClipDistance(dot(clipPosition,sc_StereoClipPlanes[sc_StereoViewID]));
}
#endif
}
void sc_SetClipPosition(vec4 clipPosition)
{
#if (sc_ShaderCacheConstant!=0)
{
clipPosition.x+=(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
}
#endif
#if (sc_StereoRenderingMode>0)
{
if ((sc_ViewMask&(1<<sc_StereoViewID))==0)
{
gl_Position=vec4(0.0,0.0,-2.0,1.0);
return;
}
varStereoViewID=sc_StereoViewID;
}
#endif
sc_SetClipDistance(clipPosition);
gl_Position=clipPosition;
}
mat4 createVoxelOrthoMatrix(float left,float right,float bottom,float top,float near,float far)
{
return mat4(vec4(2.0/(right-left),0.0,0.0,(-(right+left))/(right-left)),vec4(0.0,2.0/(top-bottom),0.0,(-(top+bottom))/(top-bottom)),vec4(0.0,0.0,(-2.0)/(far-near),(-(far+near))/(far-near)),vec4(0.0,0.0,0.0,1.0));
}
void main()
{
PreviewVertexColor=vec4(0.5);
PreviewVertexSaved=0.0;
sc_Vertex_t l9_0=sc_Vertex_t(position,normal,tangent.xyz,texture0,texture1);
sc_BlendVertex(l9_0);
sc_SkinVertex(l9_0);
#if (sc_RenderingSpace==3)
{
varPosAndMotion=vec4(vec3(0.0).x,vec3(0.0).y,vec3(0.0).z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_0.normal.x,l9_0.normal.y,l9_0.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_0.tangent.x,l9_0.tangent.y,l9_0.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==4)
{
varPosAndMotion=vec4(vec3(0.0).x,vec3(0.0).y,vec3(0.0).z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_0.normal.x,l9_0.normal.y,l9_0.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_0.tangent.x,l9_0.tangent.y,l9_0.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_0.position.x,l9_0.position.y,l9_0.position.z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_0.normal.x,l9_0.normal.y,l9_0.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_0.tangent.x,l9_0.tangent.y,l9_0.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_1=sc_ModelMatrix*l9_0.position;
varPosAndMotion=vec4(l9_1.x,l9_1.y,l9_1.z,varPosAndMotion.w);
vec3 l9_2=sc_NormalMatrix*l9_0.normal;
varNormalAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varNormalAndMotion.w);
vec3 l9_3=sc_NormalMatrix*l9_0.tangent;
varTangent=vec4(l9_3.x,l9_3.y,l9_3.z,varTangent.w);
}
#endif
}
#endif
}
#endif
}
#endif
bool l9_4=PreviewEnabled==1;
vec2 l9_5;
if (l9_4)
{
vec2 l9_6=l9_0.texture0;
l9_6.x=1.0-l9_0.texture0.x;
l9_5=l9_6;
}
else
{
l9_5=l9_0.texture0;
}
varColor=color;
vec3 l9_7;
vec3 l9_8;
vec3 l9_9;
if (l9_4)
{
l9_9=varTangent.xyz;
l9_8=varNormalAndMotion.xyz;
l9_7=varPosAndMotion.xyz;
}
else
{
l9_9=varTangent.xyz;
l9_8=varNormalAndMotion.xyz;
l9_7=varPosAndMotion.xyz;
}
varPosAndMotion=vec4(l9_7.x,l9_7.y,l9_7.z,varPosAndMotion.w);
vec3 l9_10=normalize(l9_8);
varNormalAndMotion=vec4(l9_10.x,l9_10.y,l9_10.z,varNormalAndMotion.w);
vec3 l9_11=normalize(l9_9);
varTangent=vec4(l9_11.x,l9_11.y,l9_11.z,varTangent.w);
varTangent.w=tangent.w;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
vec4 l9_12;
#if (sc_RenderingSpace==3)
{
l9_12=sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()]*l9_0.position;
}
#else
{
vec4 l9_13;
#if (sc_RenderingSpace==2)
{
l9_13=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_0.position;
}
#else
{
vec4 l9_14;
#if (sc_RenderingSpace==1)
{
l9_14=(sc_ViewMatrixArray[sc_GetStereoViewIndex()]*sc_ModelMatrix)*l9_0.position;
}
#else
{
l9_14=l9_0.position;
}
#endif
l9_13=l9_14;
}
#endif
l9_12=l9_13;
}
#endif
varViewSpaceDepth=-l9_12.z;
}
#endif
vec4 l9_15;
#if (sc_RenderingSpace==3)
{
l9_15=l9_0.position;
}
#else
{
vec4 l9_16;
#if (sc_RenderingSpace==4)
{
l9_16=((sc_ViewMatrixArray[sc_GetStereoViewIndex()]*sc_ModelMatrix)*l9_0.position)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0);
}
#else
{
vec4 l9_17;
#if (sc_RenderingSpace==2)
{
l9_17=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
}
#else
{
vec4 l9_18;
#if (sc_RenderingSpace==1)
{
l9_18=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
}
#else
{
l9_18=vec4(0.0);
}
#endif
l9_17=l9_18;
}
#endif
l9_16=l9_17;
}
#endif
l9_15=l9_16;
}
#endif
varTex01=vec4(l9_5,l9_0.texture1);
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_19;
#if (sc_RenderingSpace==1)
{
l9_19=sc_ModelMatrix*l9_0.position;
}
#else
{
l9_19=l9_0.position;
}
#endif
vec4 l9_20=sc_ProjectorMatrix*l9_19;
varShadowTex=((l9_20.xy/vec2(l9_20.w))*0.5)+vec2(0.5);
}
#endif
vec4 l9_21;
#if (sc_DepthBufferMode==1)
{
vec4 l9_22;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_23=l9_15;
l9_23.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_15.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_15.w;
l9_22=l9_23;
}
else
{
l9_22=l9_15;
}
l9_21=l9_22;
}
#else
{
l9_21=l9_15;
}
#endif
vec4 l9_24;
#if (sc_TAAEnabled)
{
vec2 l9_25=l9_21.xy+(sc_TAAJitterOffset*l9_21.w);
l9_24=vec4(l9_25.x,l9_25.y,l9_21.z,l9_21.w);
}
#else
{
l9_24=l9_21;
}
#endif
sc_SetClipPosition(l9_24);
#if (sc_Voxelization)
{
sc_Vertex_t l9_26=sc_Vertex_t(l9_0.position,l9_0.normal,l9_0.tangent,l9_5,l9_0.texture1);
sc_BlendVertex(l9_26);
sc_SkinVertex(l9_26);
int l9_27=sc_GetLocalInstanceIDInternal(sc_FallbackInstanceID);
int l9_28=int(voxelization_params_0.w);
vec4 l9_29=createVoxelOrthoMatrix(voxelization_params_frustum_lrbt.x,voxelization_params_frustum_lrbt.y,voxelization_params_frustum_lrbt.z,voxelization_params_frustum_lrbt.w,voxelization_params_frustum_nf.x,voxelization_params_frustum_nf.y)*vec4(((sc_ModelMatrixVoxelization*l9_26.position).xyz+vec3(float(l9_27%l9_28)*voxelization_params_0.y,float(l9_27/l9_28)*voxelization_params_0.y,(float(l9_27)*(voxelization_params_0.y/voxelization_params_0.z))+voxelization_params_frustum_nf.x))-voxelization_params_camera_pos,1.0);
l9_29.w=1.0;
varScreenPos=l9_29;
sc_SetClipPosition(l9_29*1.0);
}
#else
{
#if (sc_OutputBounds)
{
sc_Vertex_t l9_30=sc_Vertex_t(l9_0.position,l9_0.normal,l9_0.tangent,l9_5,l9_0.texture1);
sc_BlendVertex(l9_30);
sc_SkinVertex(l9_30);
vec2 l9_31=((l9_30.position.xy/vec2(l9_30.position.w))*0.5)+vec2(0.5);
varTex01=vec4(l9_31.x,l9_31.y,varTex01.z,varTex01.w);
vec4 l9_32=sc_ModelMatrixVoxelization*l9_30.position;
vec3 l9_33=l9_32.xyz-voxelization_params_camera_pos;
varPosAndMotion=vec4(l9_33.x,l9_33.y,l9_33.z,varPosAndMotion.w);
vec3 l9_34=normalize(l9_30.normal);
varNormalAndMotion=vec4(l9_34.x,l9_34.y,l9_34.z,varNormalAndMotion.w);
vec4 l9_35=createVoxelOrthoMatrix(voxelization_params_frustum_lrbt.x,voxelization_params_frustum_lrbt.y,voxelization_params_frustum_lrbt.z,voxelization_params_frustum_lrbt.w,voxelization_params_frustum_nf.x,voxelization_params_frustum_nf.y)*vec4(l9_33.x,l9_33.y,l9_33.z,l9_32.w);
vec4 l9_36=vec4(l9_35.x,l9_35.y,l9_35.z,vec4(0.0).w);
l9_36.w=1.0;
varScreenPos=l9_36;
sc_SetClipPosition(l9_36*1.0);
}
#endif
}
#endif
vec4 l9_37=varPosAndMotion;
#if (sc_MotionVectorsPass)
{
vec4 l9_38=vec4(l9_37.xyz,1.0);
#if (sc_MotionVectorsPass)
{
vec4 l9_39=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_38;
vec4 l9_40=sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(((sc_PrevFrameModelMatrix*sc_ModelMatrixInverse)*l9_38).xyz,1.0);
vec2 l9_41=((l9_39.xy/vec2(l9_39.w)).xy-(l9_40.xy/vec2(l9_40.w)).xy)*0.5;
varPosAndMotion.w=l9_41.x;
varNormalAndMotion.w=l9_41.y;
}
#endif
}
#endif
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
struct ShadowMapParameters
{
vec4 lightSpacePos;
float shadowDensity;
vec3 lightDirection;
float bias;
float radius;
vec3 L;
vec3 N;
float NdotL;
vec2 spotOuterAngleAndCos;
float lightNear;
float lightFar;
};
struct SurfaceProperties
{
vec3 albedo;
float opacity;
vec3 normal;
vec3 positionWS;
vec3 viewDirWS;
float metallic;
float roughness;
vec3 emissive;
vec3 ao;
vec3 specularAo;
vec3 bakedShadows;
vec3 specColor;
};
struct LightingComponents
{
vec3 directDiffuse;
vec3 directSpecular;
vec3 indirectDiffuse;
vec3 indirectSpecular;
vec3 emitted;
vec3 transmitted;
};
struct LightProperties
{
vec3 direction;
vec3 color;
float attenuation;
};
struct sc_SphericalGaussianLight_t
{
vec3 color;
float sharpness;
vec3 axis;
};
struct ssGlobals
{
float gTimeElapsed;
float gTimeDelta;
float gTimeElapsedShifted;
vec3 BumpedNormal;
vec3 ViewDirWS;
vec3 PositionWS;
vec4 VertexColor;
vec2 Surface_UVCoord0;
vec2 Surface_UVCoord1;
vec2 gScreenCoord;
vec3 VertexTangent_WorldSpace;
vec3 VertexNormal_WorldSpace;
vec3 VertexBinormal_WorldSpace;
};
#ifndef sc_StereoRenderingMode
#define sc_StereoRenderingMode 0
#endif
#ifndef sc_EnvmapDiffuseHasSwappedViews
#define sc_EnvmapDiffuseHasSwappedViews 0
#elif sc_EnvmapDiffuseHasSwappedViews==1
#undef sc_EnvmapDiffuseHasSwappedViews
#define sc_EnvmapDiffuseHasSwappedViews 1
#endif
#ifndef sc_EnvmapDiffuseLayout
#define sc_EnvmapDiffuseLayout 0
#endif
#ifndef sc_EnvmapSpecularHasSwappedViews
#define sc_EnvmapSpecularHasSwappedViews 0
#elif sc_EnvmapSpecularHasSwappedViews==1
#undef sc_EnvmapSpecularHasSwappedViews
#define sc_EnvmapSpecularHasSwappedViews 1
#endif
#ifndef sc_EnvmapSpecularLayout
#define sc_EnvmapSpecularLayout 0
#endif
#ifndef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 0
#elif sc_ScreenTextureHasSwappedViews==1
#undef sc_ScreenTextureHasSwappedViews
#define sc_ScreenTextureHasSwappedViews 1
#endif
#ifndef sc_ScreenTextureLayout
#define sc_ScreenTextureLayout 0
#endif
#ifndef sc_BlendMode
#define sc_BlendMode 0
#endif
#ifndef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 0
#elif sc_ProjectiveShadowsReceiver==1
#undef sc_ProjectiveShadowsReceiver
#define sc_ProjectiveShadowsReceiver 1
#endif
struct ShadowMapParams_t
{
mat4 params;
mat4 lightSpaceMatrix;
mat4 invLightSpaceMatrix;
};
#ifndef sc_ShadowMapHardwarePCF
#define sc_ShadowMapHardwarePCF 0
#elif sc_ShadowMapHardwarePCF==1
#undef sc_ShadowMapHardwarePCF
#define sc_ShadowMapHardwarePCF 1
#endif
struct sc_DirectionalLight_t
{
vec3 direction;
vec4 color;
int shadowMapParamsIndex;
};
#ifndef sc_DirectionalLightsCount
#define sc_DirectionalLightsCount 0
#endif
struct sc_PointLight_t
{
float falloffRangeSqr;
float falloffRangeNegInvSqrSqr;
float angleScale;
float angleOffset;
vec3 direction;
vec3 position;
vec4 color;
int shadowMapParamsIndex;
};
#ifndef sc_PointLightsCount
#define sc_PointLightsCount 0
#endif
#ifndef sc_ShadowMapReceiver
#define sc_ShadowMapReceiver 0
#elif sc_ShadowMapReceiver==1
#undef sc_ShadowMapReceiver
#define sc_ShadowMapReceiver 1
#endif
#ifndef sc_ShadowMapIsSoftShadow
#define sc_ShadowMapIsSoftShadow 0
#elif sc_ShadowMapIsSoftShadow==1
#undef sc_ShadowMapIsSoftShadow
#define sc_ShadowMapIsSoftShadow 1
#endif
#ifndef sc_ShadowMapIsRandomSampling
#define sc_ShadowMapIsRandomSampling 0
#elif sc_ShadowMapIsRandomSampling==1
#undef sc_ShadowMapIsRandomSampling
#define sc_ShadowMapIsRandomSampling 1
#endif
#ifndef sc_TAAEnabled
#define sc_TAAEnabled 0
#elif sc_TAAEnabled==1
#undef sc_TAAEnabled
#define sc_TAAEnabled 1
#endif
#ifndef sc_ShadowMapSampleCount
#define sc_ShadowMapSampleCount 16
#endif
#ifndef sc_MotionVectorsPass
#define sc_MotionVectorsPass 0
#elif sc_MotionVectorsPass==1
#undef sc_MotionVectorsPass
#define sc_MotionVectorsPass 1
#endif
#ifndef sc_StereoRendering_IsClipDistanceEnabled
#define sc_StereoRendering_IsClipDistanceEnabled 0
#endif
#ifndef sc_ShaderCacheConstant
#define sc_ShaderCacheConstant 0
#endif
#ifndef sc_FramebufferFetch
#define sc_FramebufferFetch 0
#elif sc_FramebufferFetch==1
#undef sc_FramebufferFetch
#define sc_FramebufferFetch 1
#endif
#ifndef sc_SSAOEnabled
#define sc_SSAOEnabled 0
#elif sc_SSAOEnabled==1
#undef sc_SSAOEnabled
#define sc_SSAOEnabled 1
#endif
#ifndef sc_NumStereoViews
#define sc_NumStereoViews 1
#endif
#ifndef SC_DEVICE_CLASS
#define SC_DEVICE_CLASS -1
#endif
#ifndef intensityTextureHasSwappedViews
#define intensityTextureHasSwappedViews 0
#elif intensityTextureHasSwappedViews==1
#undef intensityTextureHasSwappedViews
#define intensityTextureHasSwappedViews 1
#endif
#ifndef sc_SoftwareBlendMode
#define sc_SoftwareBlendMode 0
#endif
#ifndef intensityTextureLayout
#define intensityTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_intensityTexture
#define SC_USE_UV_TRANSFORM_intensityTexture 0
#elif SC_USE_UV_TRANSFORM_intensityTexture==1
#undef SC_USE_UV_TRANSFORM_intensityTexture
#define SC_USE_UV_TRANSFORM_intensityTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_intensityTexture
#define SC_SOFTWARE_WRAP_MODE_U_intensityTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_intensityTexture
#define SC_SOFTWARE_WRAP_MODE_V_intensityTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_intensityTexture
#define SC_USE_UV_MIN_MAX_intensityTexture 0
#elif SC_USE_UV_MIN_MAX_intensityTexture==1
#undef SC_USE_UV_MIN_MAX_intensityTexture
#define SC_USE_UV_MIN_MAX_intensityTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_intensityTexture
#define SC_USE_CLAMP_TO_BORDER_intensityTexture 0
#elif SC_USE_CLAMP_TO_BORDER_intensityTexture==1
#undef SC_USE_CLAMP_TO_BORDER_intensityTexture
#define SC_USE_CLAMP_TO_BORDER_intensityTexture 1
#endif
#ifndef sc_SkinBonesCount
#define sc_SkinBonesCount 0
#endif
#ifndef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#elif UseViewSpaceDepthVariant==1
#undef UseViewSpaceDepthVariant
#define UseViewSpaceDepthVariant 1
#endif
#ifndef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 0
#elif sc_OITDepthGatherPass==1
#undef sc_OITDepthGatherPass
#define sc_OITDepthGatherPass 1
#endif
#ifndef sc_OITCompositingPass
#define sc_OITCompositingPass 0
#elif sc_OITCompositingPass==1
#undef sc_OITCompositingPass
#define sc_OITCompositingPass 1
#endif
#ifndef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 0
#elif sc_OITDepthBoundsPass==1
#undef sc_OITDepthBoundsPass
#define sc_OITDepthBoundsPass 1
#endif
#ifndef sc_OITMaxLayers4Plus1
#define sc_OITMaxLayers4Plus1 0
#elif sc_OITMaxLayers4Plus1==1
#undef sc_OITMaxLayers4Plus1
#define sc_OITMaxLayers4Plus1 1
#endif
#ifndef sc_OITMaxLayersVisualizeLayerCount
#define sc_OITMaxLayersVisualizeLayerCount 0
#elif sc_OITMaxLayersVisualizeLayerCount==1
#undef sc_OITMaxLayersVisualizeLayerCount
#define sc_OITMaxLayersVisualizeLayerCount 1
#endif
#ifndef sc_OITMaxLayers8
#define sc_OITMaxLayers8 0
#elif sc_OITMaxLayers8==1
#undef sc_OITMaxLayers8
#define sc_OITMaxLayers8 1
#endif
#ifndef sc_OITFrontLayerPass
#define sc_OITFrontLayerPass 0
#elif sc_OITFrontLayerPass==1
#undef sc_OITFrontLayerPass
#define sc_OITFrontLayerPass 1
#endif
#ifndef sc_OITDepthPrepass
#define sc_OITDepthPrepass 0
#elif sc_OITDepthPrepass==1
#undef sc_OITDepthPrepass
#define sc_OITDepthPrepass 1
#endif
#ifndef ENABLE_STIPPLE_PATTERN_TEST
#define ENABLE_STIPPLE_PATTERN_TEST 0
#elif ENABLE_STIPPLE_PATTERN_TEST==1
#undef ENABLE_STIPPLE_PATTERN_TEST
#define ENABLE_STIPPLE_PATTERN_TEST 1
#endif
#ifndef sc_ProjectiveShadowsCaster
#define sc_ProjectiveShadowsCaster 0
#elif sc_ProjectiveShadowsCaster==1
#undef sc_ProjectiveShadowsCaster
#define sc_ProjectiveShadowsCaster 1
#endif
#ifndef sc_RenderAlphaToColor
#define sc_RenderAlphaToColor 0
#elif sc_RenderAlphaToColor==1
#undef sc_RenderAlphaToColor
#define sc_RenderAlphaToColor 1
#endif
#ifndef sc_BlendMode_Custom
#define sc_BlendMode_Custom 0
#elif sc_BlendMode_Custom==1
#undef sc_BlendMode_Custom
#define sc_BlendMode_Custom 1
#endif
#ifndef sc_Voxelization
#define sc_Voxelization 0
#elif sc_Voxelization==1
#undef sc_Voxelization
#define sc_Voxelization 1
#endif
#ifndef sc_OutputBounds
#define sc_OutputBounds 0
#elif sc_OutputBounds==1
#undef sc_OutputBounds
#define sc_OutputBounds 1
#endif
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef sc_EnvLightMode
#define sc_EnvLightMode 0
#endif
#ifndef sc_AmbientLightMode_EnvironmentMap
#define sc_AmbientLightMode_EnvironmentMap 0
#endif
#ifndef sc_AmbientLightMode_FromCamera
#define sc_AmbientLightMode_FromCamera 0
#endif
#ifndef sc_LightEstimation
#define sc_LightEstimation 0
#elif sc_LightEstimation==1
#undef sc_LightEstimation
#define sc_LightEstimation 1
#endif
struct sc_LightEstimationData_t
{
sc_SphericalGaussianLight_t sg[12];
vec3 ambientLight;
};
#ifndef sc_LightEstimationSGCount
#define sc_LightEstimationSGCount 0
#endif
#ifndef sc_HasSpecularCubemap
#define sc_HasSpecularCubemap 0
#elif sc_HasSpecularCubemap==1
#undef sc_HasSpecularCubemap
#define sc_HasSpecularCubemap 1
#endif
#ifndef sc_HasDiffuseEnvmap
#define sc_HasDiffuseEnvmap 0
#elif sc_HasDiffuseEnvmap==1
#undef sc_HasDiffuseEnvmap
#define sc_HasDiffuseEnvmap 1
#endif
#ifndef sc_AmbientLightMode_SphericalHarmonics
#define sc_AmbientLightMode_SphericalHarmonics 0
#endif
#ifndef sc_AmbientLightsCount
#define sc_AmbientLightsCount 0
#endif
#ifndef sc_AmbientLightMode0
#define sc_AmbientLightMode0 0
#endif
#ifndef sc_AmbientLightMode_Constant
#define sc_AmbientLightMode_Constant 0
#endif
struct sc_AmbientLight_t
{
vec3 color;
float intensity;
};
#ifndef sc_AmbientLightMode1
#define sc_AmbientLightMode1 0
#endif
#ifndef sc_AmbientLightMode2
#define sc_AmbientLightMode2 0
#endif
#ifndef sc_IsEditor
#define sc_IsEditor 0
#elif sc_IsEditor==1
#undef sc_IsEditor
#define sc_IsEditor 1
#endif
#ifndef Tweak_N121
#define Tweak_N121 0
#elif Tweak_N121==1
#undef Tweak_N121
#define Tweak_N121 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 0
#elif SC_USE_UV_TRANSFORM_baseTex==1
#undef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseTex
#define SC_SOFTWARE_WRAP_MODE_U_baseTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseTex
#define SC_SOFTWARE_WRAP_MODE_V_baseTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 0
#elif SC_USE_UV_MIN_MAX_baseTex==1
#undef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 0
#elif SC_USE_CLAMP_TO_BORDER_baseTex==1
#undef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 1
#endif
#ifndef sc_DepthOnly
#define sc_DepthOnly 0
#elif sc_DepthOnly==1
#undef sc_DepthOnly
#define sc_DepthOnly 1
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
uniform vec4 sc_CurrentRenderTargetDims;
uniform float sc_ShadowDensity;
uniform vec4 sc_ShadowColor;
uniform ShadowMapParams_t sc_ShadowMapParams[1];
uniform sc_DirectionalLight_t sc_DirectionalLights[sc_DirectionalLightsCount+1];
uniform sc_PointLight_t sc_PointLights[sc_PointLightsCount+1];
uniform vec4 sc_ShadowMapTextureSize;
uniform vec4 sc_Time;
uniform vec4 sc_UniformConstants;
uniform mat4 sc_ViewProjectionMatrixArray[sc_NumStereoViews];
uniform float correctedIntensity;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform mat4 sc_ProjectionMatrixArray[sc_NumStereoViews];
uniform float alphaTestThreshold;
uniform sc_LightEstimationData_t sc_LightEstimationData;
uniform vec2 sc_EnvmapRotationSinCos;
uniform vec3 sc_EnvmapRotation;
uniform vec4 sc_EnvmapSpecularSize;
uniform vec4 sc_EnvmapDiffuseSize;
uniform float sc_EnvmapExposure;
uniform vec3 sc_Sh[9];
uniform float sc_ShIntensity;
uniform sc_AmbientLight_t sc_AmbientLights[sc_AmbientLightsCount+1];
uniform vec4 baseColor;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec4 Port_Default_N369;
uniform sc_Camera_t sc_Camera;
uniform float Port_Default_N204;
uniform float Port_Input2_N072;
uniform vec3 Port_Emissive_N036;
uniform vec3 Port_AO_N036;
uniform int PreviewEnabled;
uniform sampler2D baseTex;
uniform sampler2DArray baseTexArrSC;
uniform sampler2D sc_SSAOTexture;
uniform sampler2D sc_ShadowTexture;
uniform sampler2DShadow sc_ShadowMapTexture;
uniform sampler2D sc_EnvmapSpecular;
uniform sampler2DArray sc_EnvmapSpecularArrSC;
uniform sampler2D sc_EnvmapDiffuse;
uniform sampler2DArray sc_EnvmapDiffuseArrSC;
uniform samplerCube sc_SpecularCubemap;
uniform sampler2D sc_ScreenTexture;
uniform sampler2DArray sc_ScreenTextureArrSC;
uniform sampler2D intensityTexture;
uniform sampler2DArray intensityTextureArrSC;
uniform sampler2D sc_OITFrontDepthTexture;
uniform sampler2D sc_OITDepthHigh0;
uniform sampler2D sc_OITDepthLow0;
uniform sampler2D sc_OITAlpha0;
uniform sampler2D sc_OITDepthHigh1;
uniform sampler2D sc_OITDepthLow1;
uniform sampler2D sc_OITAlpha1;
uniform sampler2D sc_OITFilteredDepthBoundsTexture;
flat in int varStereoViewID;
in vec2 varShadowTex;
in vec4 varPosAndMotion;
in vec4 varNormalAndMotion;
in float varClipDistance;
#if sc_FramebufferFetch&&defined(GL_EXT_shader_framebuffer_fetch)
#define out inout
#endif
layout(location=0) out vec4 sc_FragData0;
#if sc_FramebufferFetch&&defined(GL_EXT_shader_framebuffer_fetch)
#undef out
#endif
in vec4 varScreenPos;
in float varViewSpaceDepth;
in vec4 PreviewVertexColor;
in float PreviewVertexSaved;
in vec4 varColor;
in vec4 varTex01;
in vec4 varTangent;
in vec2 varScreenTexturePos;
int sc_GetStereoViewIndex()
{
int l9_0;
#if (sc_StereoRenderingMode==0)
{
l9_0=0;
}
#else
{
l9_0=varStereoViewID;
}
#endif
return l9_0;
}
vec2 sc_SamplingCoordsGlobalToView(vec3 uvi,int renderingLayout,int viewIndex)
{
if (renderingLayout==1)
{
uvi.y=((2.0*uvi.y)+float(viewIndex))-1.0;
}
return uvi.xy;
}
vec2 sc_ScreenCoordsGlobalToView(vec2 uv)
{
vec2 l9_0;
#if (sc_StereoRenderingMode==1)
{
l9_0=sc_SamplingCoordsGlobalToView(vec3(uv,0.0),1,sc_GetStereoViewIndex());
}
#else
{
l9_0=uv;
}
#endif
return l9_0;
}
int baseTexGetStereoViewIndex()
{
int l9_0;
#if (baseTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
void sc_SoftwareWrapEarly(inout float uv,int softwareWrapMode)
{
if (softwareWrapMode==1)
{
uv=fract(uv);
}
else
{
if (softwareWrapMode==2)
{
float l9_0=fract(uv);
uv=mix(l9_0,1.0-l9_0,clamp(step(0.25,fract((uv-l9_0)*0.5)),0.0,1.0));
}
}
}
void sc_ClampUV(inout float value,float minValue,float maxValue,bool useClampToBorder,inout float clampToBorderFactor)
{
float l9_0=clamp(value,minValue,maxValue);
float l9_1=step(abs(value-l9_0),9.9999997e-06);
clampToBorderFactor*=(l9_1+((1.0-float(useClampToBorder))*(1.0-l9_1)));
value=l9_0;
}
vec2 sc_TransformUV(vec2 uv,bool useUvTransform,mat3 uvTransform)
{
if (useUvTransform)
{
uv=vec2((uvTransform*vec3(uv,1.0)).xy);
}
return uv;
}
void sc_SoftwareWrapLate(inout float uv,int softwareWrapMode,bool useClampToBorder,inout float clampToBorderFactor)
{
if ((softwareWrapMode==0)||(softwareWrapMode==3))
{
sc_ClampUV(uv,0.0,1.0,useClampToBorder,clampToBorderFactor);
}
}
vec3 sc_SamplingCoordsViewToGlobal(vec2 uv,int renderingLayout,int viewIndex)
{
vec3 l9_0;
if (renderingLayout==0)
{
l9_0=vec3(uv,0.0);
}
else
{
vec3 l9_1;
if (renderingLayout==1)
{
l9_1=vec3(uv.x,(uv.y*0.5)+(0.5-(float(viewIndex)*0.5)),0.0);
}
else
{
l9_1=vec3(uv,float(viewIndex));
}
l9_0=l9_1;
}
return l9_0;
}
void Node369_If_else(float Bool1,vec4 Value1,vec4 Default,out vec4 Result,ssGlobals Globals)
{
#if (Tweak_N121)
{
vec4 l9_0;
#if (baseTexLayout==2)
{
bool l9_1=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseTex)!=0));
float l9_2=Globals.Surface_UVCoord0.x;
sc_SoftwareWrapEarly(l9_2,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x);
float l9_3=l9_2;
float l9_4=Globals.Surface_UVCoord0.y;
sc_SoftwareWrapEarly(l9_4,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y);
float l9_5=l9_4;
vec2 l9_6;
float l9_7;
#if (SC_USE_UV_MIN_MAX_baseTex)
{
bool l9_8;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_8=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x==3;
}
#else
{
l9_8=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_9=l9_3;
float l9_10=1.0;
sc_ClampUV(l9_9,baseTexUvMinMax.x,baseTexUvMinMax.z,l9_8,l9_10);
float l9_11=l9_9;
float l9_12=l9_10;
bool l9_13;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_13=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y==3;
}
#else
{
l9_13=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_14=l9_5;
float l9_15=l9_12;
sc_ClampUV(l9_14,baseTexUvMinMax.y,baseTexUvMinMax.w,l9_13,l9_15);
l9_7=l9_15;
l9_6=vec2(l9_11,l9_14);
}
#else
{
l9_7=1.0;
l9_6=vec2(l9_3,l9_5);
}
#endif
vec2 l9_16=sc_TransformUV(l9_6,(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform);
float l9_17=l9_16.x;
float l9_18=l9_7;
sc_SoftwareWrapLate(l9_17,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x,l9_1,l9_18);
float l9_19=l9_16.y;
float l9_20=l9_18;
sc_SoftwareWrapLate(l9_19,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y,l9_1,l9_20);
float l9_21=l9_20;
vec3 l9_22=sc_SamplingCoordsViewToGlobal(vec2(l9_17,l9_19),baseTexLayout,baseTexGetStereoViewIndex());
vec4 l9_23=texture(baseTexArrSC,l9_22,0.0);
vec4 l9_24;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_24=mix(baseTexBorderColor,l9_23,vec4(l9_21));
}
#else
{
l9_24=l9_23;
}
#endif
l9_0=l9_24;
}
#else
{
bool l9_25=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseTex)!=0));
float l9_26=Globals.Surface_UVCoord0.x;
sc_SoftwareWrapEarly(l9_26,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x);
float l9_27=l9_26;
float l9_28=Globals.Surface_UVCoord0.y;
sc_SoftwareWrapEarly(l9_28,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y);
float l9_29=l9_28;
vec2 l9_30;
float l9_31;
#if (SC_USE_UV_MIN_MAX_baseTex)
{
bool l9_32;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_32=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x==3;
}
#else
{
l9_32=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_33=l9_27;
float l9_34=1.0;
sc_ClampUV(l9_33,baseTexUvMinMax.x,baseTexUvMinMax.z,l9_32,l9_34);
float l9_35=l9_33;
float l9_36=l9_34;
bool l9_37;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_37=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y==3;
}
#else
{
l9_37=(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0);
}
#endif
float l9_38=l9_29;
float l9_39=l9_36;
sc_ClampUV(l9_38,baseTexUvMinMax.y,baseTexUvMinMax.w,l9_37,l9_39);
l9_31=l9_39;
l9_30=vec2(l9_35,l9_38);
}
#else
{
l9_31=1.0;
l9_30=vec2(l9_27,l9_29);
}
#endif
vec2 l9_40=sc_TransformUV(l9_30,(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform);
float l9_41=l9_40.x;
float l9_42=l9_31;
sc_SoftwareWrapLate(l9_41,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).x,l9_25,l9_42);
float l9_43=l9_40.y;
float l9_44=l9_42;
sc_SoftwareWrapLate(l9_43,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex).y,l9_25,l9_44);
float l9_45=l9_44;
vec3 l9_46=sc_SamplingCoordsViewToGlobal(vec2(l9_41,l9_43),baseTexLayout,baseTexGetStereoViewIndex());
vec4 l9_47=texture(baseTex,l9_46.xy,0.0);
vec4 l9_48;
#if (SC_USE_CLAMP_TO_BORDER_baseTex)
{
l9_48=mix(baseTexBorderColor,l9_47,vec4(l9_45));
}
#else
{
l9_48=l9_47;
}
#endif
l9_0=l9_48;
}
#endif
Value1=l9_0;
Result=Value1;
}
#else
{
Result=Default;
}
#endif
}
vec3 ssSRGB_to_Linear(vec3 value)
{
vec3 l9_0;
#if (SC_DEVICE_CLASS>=2)
{
l9_0=vec3(pow(value.x,2.2),pow(value.y,2.2),pow(value.z,2.2));
}
#else
{
l9_0=value*value;
}
#endif
return l9_0;
}
vec3 evaluateSSAO(vec3 positionWS)
{
#if (sc_SSAOEnabled)
{
vec4 l9_0=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(positionWS,1.0);
return vec3(texture(sc_SSAOTexture,((l9_0.xyz/vec3(l9_0.w)).xy*0.5)+vec2(0.5)).x);
}
#else
{
return vec3(1.0);
}
#endif
}
ShadowMapParameters setupShadowMapParameters(bool isDirectional,int lightId,vec3 L)
{
vec3 l9_0;
float l9_1;
float l9_2;
vec2 l9_3;
float l9_4;
float l9_5;
vec3 l9_6;
float l9_7;
vec4 l9_8;
if (isDirectional)
{
l9_8=sc_ShadowMapParams[sc_DirectionalLights[lightId].shadowMapParamsIndex].lightSpaceMatrix*vec4(varPosAndMotion.xyz,1.0);
l9_7=sc_ShadowMapParams[sc_DirectionalLights[lightId].shadowMapParamsIndex].params[1].w;
l9_6=sc_DirectionalLights[lightId].direction;
l9_5=sc_ShadowMapParams[sc_DirectionalLights[lightId].shadowMapParamsIndex].params[3].x;
l9_4=sc_ShadowMapParams[sc_DirectionalLights[lightId].shadowMapParamsIndex].params[2].x;
l9_3=vec2(0.0);
l9_2=sc_ShadowMapParams[sc_DirectionalLights[lightId].shadowMapParamsIndex].params[2].y;
l9_1=sc_ShadowMapParams[sc_DirectionalLights[lightId].shadowMapParamsIndex].params[2].z;
l9_0=-sc_DirectionalLights[lightId].direction;
}
else
{
l9_8=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].lightSpaceMatrix*vec4(varPosAndMotion.xyz,1.0);
l9_7=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[1].w;
l9_6=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[2].xyz;
l9_5=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[2].w;
l9_4=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[1].x;
l9_3=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[3].xy;
l9_2=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[1].y;
l9_1=sc_ShadowMapParams[sc_PointLights[lightId].shadowMapParamsIndex].params[1].z;
l9_0=L;
}
vec3 l9_9=normalize(varNormalAndMotion.xyz);
return ShadowMapParameters(l9_8,l9_7,l9_6,l9_5,l9_4,l9_0,l9_9,dot(l9_9,l9_0),l9_3,l9_2,l9_1);
}
float CalculateWitnessBias(ShadowMapParameters shadowMapParams)
{
float l9_0=clamp(-shadowMapParams.NdotL,0.0,1.0);
float l9_1=sqrt(clamp(1.0-(l9_0*l9_0),0.0,1.0));
return ((1.0+l9_1)+(1.5*min(2.0,l9_1/max(l9_0,0.001))))/max(shadowMapParams.lightFar-shadowMapParams.lightNear,1e-06);
}
float sampleHardwarePCF(vec2 coords,float currentDepth,float bias)
{
#if (sc_ShadowMapHardwarePCF)
{
float l9_0=currentDepth-bias;
return texture(sc_ShadowMapTexture,vec3(vec3(coords,l9_0).xy,l9_0));
}
#else
{
return step(currentDepth-bias,texture(sc_ShadowTexture,coords).x);
}
#endif
}
int sc_ShadowHash(vec2 pixelCoord,float frame)
{
uvec2 l9_0=uvec2(pixelCoord);
uint l9_1=(l9_0.x+(l9_0.y*1931u))+(uint(frame)*2903u);
uint l9_2=(l9_1^(l9_1>>16u))*73244475u;
uint l9_3=(l9_2^(l9_2>>16u))*73244475u;
return int((l9_3^(l9_3>>16u))&255u);
}
float evaluateShadowMap(bool isDirectional,int lightId,vec3 L)
{
float l9_0;
#if (sc_ShadowMapReceiver)
{
ShadowMapParameters l9_1=setupShadowMapParameters(isDirectional,lightId,L);
vec4 l9_2=l9_1.lightSpacePos;
float l9_3=l9_1.shadowDensity;
vec2 l9_4=l9_1.spotOuterAngleAndCos;
float l9_5=l9_2.w;
if (l9_5<=0.0)
{
return 1.0;
}
float l9_6=1.0/l9_5;
vec2 l9_7=((l9_2.xy*l9_6)*0.5)+vec2(0.5);
float l9_8=l9_4.y;
bool l9_9=l9_8>0.0;
bool l9_10;
if (l9_9)
{
l9_10=dot(l9_1.L,l9_1.lightDirection)<l9_8;
}
else
{
l9_10=l9_9;
}
if (l9_10)
{
return 1.0;
}
float l9_11=l9_7.x;
bool l9_12=l9_11<0.0;
bool l9_13;
if (!l9_12)
{
l9_13=l9_11>1.0;
}
else
{
l9_13=l9_12;
}
bool l9_14;
if (!l9_13)
{
l9_14=l9_7.y<0.0;
}
else
{
l9_14=l9_13;
}
bool l9_15;
if (!l9_14)
{
l9_15=l9_7.y>1.0;
}
else
{
l9_15=l9_14;
}
if (l9_15)
{
return 1.0;
}
if (l9_1.NdotL>0.0)
{
return 1.0;
}
float l9_16=((l9_2.z*l9_6)*0.5)+0.5;
float l9_17=CalculateWitnessBias(l9_1);
float l9_18=l9_1.bias*l9_17;
float l9_19;
#if (sc_ShadowMapIsSoftShadow)
{
float l9_20;
#if (sc_ShadowMapIsRandomSampling)
{
float l9_21;
#if (sc_TAAEnabled)
{
l9_21=floor(sc_Time.x*60.0);
}
#else
{
l9_21=0.0;
}
#endif
float l9_22;
vec2 l9_23;
l9_23=fract(vec2(0.5)+(vec2(float(sc_ShadowHash(gl_FragCoord.xy,l9_21)),float(sc_ShadowHash(gl_FragCoord.xy+vec2(0.5,0.25),l9_21+1.0)))/vec2(256.0)));
l9_22=0.0;
vec2 param_8;
float param_9;
float param_10;
int l9_24=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_24<sc_ShadowMapSampleCount)
{
vec2 l9_25=(l9_23*2.0)-vec2(1.0);
vec2 l9_26=l9_25.yx;
l9_23=fract(l9_23+vec2(0.75487769,0.56984031));
l9_22+=sampleHardwarePCF(((l9_7*sc_ShadowMapTextureSize.xy)+((l9_25-(l9_25*((l9_26*0.2929)*l9_26)))*max((l9_1.radius*sc_ShadowMapTextureSize.x)/512.0,1.0)))*sc_ShadowMapTextureSize.zw,l9_16,l9_18);
l9_24++;
continue;
}
else
{
break;
}
}
l9_20=l9_22/float(sc_ShadowMapSampleCount);
}
#else
{
vec2 l9_27=(l9_7*sc_ShadowMapTextureSize.xy)-vec2(0.5);
vec2 l9_28=(floor(l9_27)+vec2(0.5))*sc_ShadowMapTextureSize.zw;
vec2 l9_29=fract(l9_27);
float l9_30=l9_29.x;
float l9_31=l9_29.y;
float l9_32=3.0*l9_30;
float l9_33=4.0-l9_32;
float l9_34=1.0+l9_32;
float l9_35=(((3.0-(2.0*l9_30))/l9_33)-2.0)*sc_ShadowMapTextureSize.z;
float l9_36=((3.0+l9_30)/7.0)*sc_ShadowMapTextureSize.z;
float l9_37=((l9_30/l9_34)+2.0)*sc_ShadowMapTextureSize.z;
float l9_38=3.0*l9_31;
float l9_39=4.0-l9_38;
float l9_40=1.0+l9_38;
float l9_41=(((3.0-(2.0*l9_31))/l9_39)-2.0)*sc_ShadowMapTextureSize.w;
float l9_42=((3.0+l9_31)/7.0)*sc_ShadowMapTextureSize.w;
float l9_43=((l9_31/l9_40)+2.0)*sc_ShadowMapTextureSize.w;
l9_20=((((((((((l9_33*l9_39)*sampleHardwarePCF(l9_28+vec2(l9_35,l9_41),l9_16,l9_18))+((7.0*l9_39)*sampleHardwarePCF(l9_28+vec2(l9_36,l9_41),l9_16,l9_18)))+((l9_34*l9_39)*sampleHardwarePCF(l9_28+vec2(l9_37,l9_41),l9_16,l9_18)))+((l9_33*7.0)*sampleHardwarePCF(l9_28+vec2(l9_35,l9_42),l9_16,l9_18)))+(49.0*sampleHardwarePCF(l9_28+vec2(l9_36,l9_42),l9_16,l9_18)))+((l9_34*7.0)*sampleHardwarePCF(l9_28+vec2(l9_37,l9_42),l9_16,l9_18)))+((l9_33*l9_40)*sampleHardwarePCF(l9_28+vec2(l9_35,l9_43),l9_16,l9_18)))+((7.0*l9_40)*sampleHardwarePCF(l9_28+vec2(l9_36,l9_43),l9_16,l9_18)))+((l9_34*l9_40)*sampleHardwarePCF(l9_28+vec2(l9_37,l9_43),l9_16,l9_18)))*0.0069444445;
}
#endif
l9_19=l9_20;
}
#else
{
l9_19=sampleHardwarePCF(l9_7,l9_16,l9_18);
}
#endif
l9_0=(1.0-l9_3)+(l9_3*l9_19);
}
#else
{
l9_0=1.0;
}
#endif
return l9_0;
}
float evaluateDirectionalShadowMap(int lightId)
{
#if (sc_ShadowMapReceiver)
{
if (sc_DirectionalLights[lightId].shadowMapParamsIndex!=(-1))
{
return evaluateShadowMap(true,lightId,vec3(0.0));
}
}
#endif
return 1.0;
}
vec3 fresnelSchlickSub(float cosTheta,vec3 F0,vec3 fresnelMax)
{
float l9_0=1.0-cosTheta;
float l9_1=l9_0*l9_0;
return F0+((fresnelMax-F0)*((l9_1*l9_1)*l9_0));
}
float Dggx(float NdotH,float roughness)
{
float l9_0=roughness*roughness;
float l9_1=l9_0*l9_0;
float l9_2=((NdotH*NdotH)*(l9_1-1.0))+1.0;
return l9_1/((l9_2*l9_2)+9.9999999e-09);
}
vec3 calculateDirectSpecular(SurfaceProperties surfaceProperties,vec3 L,vec3 V)
{
float l9_0=surfaceProperties.roughness;
float l9_1=max(l9_0,0.029999999);
vec3 l9_2=surfaceProperties.specColor;
vec3 l9_3=surfaceProperties.normal;
vec3 l9_4=L;
vec3 l9_5=V;
vec3 l9_6=normalize(l9_4+l9_5);
vec3 l9_7=L;
float l9_8=clamp(dot(l9_3,l9_7),0.0,1.0);
vec3 l9_9=V;
float l9_10=clamp(dot(l9_3,l9_6),0.0,1.0);
vec3 l9_11=V;
float l9_12=clamp(dot(l9_11,l9_6),0.0,1.0);
#if (SC_DEVICE_CLASS>=2)
{
float l9_13=l9_1+1.0;
float l9_14=(l9_13*l9_13)*0.125;
float l9_15=1.0-l9_14;
return fresnelSchlickSub(l9_12,l9_2,vec3(1.0))*(((Dggx(l9_10,l9_1)*(1.0/(((l9_8*l9_15)+l9_14)*((clamp(dot(l9_3,l9_9),0.0,1.0)*l9_15)+l9_14))))*0.25)*l9_8);
}
#else
{
float l9_16=exp2(11.0-(10.0*l9_1));
return ((fresnelSchlickSub(l9_12,l9_2,vec3(1.0))*((l9_16*0.125)+0.25))*pow(l9_10,l9_16))*l9_8;
}
#endif
}
LightingComponents accumulateLight(LightingComponents lighting,LightProperties light,SurfaceProperties surfaceProperties,vec3 V)
{
lighting.directDiffuse+=((vec3(clamp(dot(surfaceProperties.normal,light.direction),0.0,1.0))*light.color)*light.attenuation);
lighting.directSpecular+=((calculateDirectSpecular(surfaceProperties,light.direction,V)*light.color)*light.attenuation);
return lighting;
}
float evaluatePointShadowMap(int lightId,vec3 L)
{
#if (sc_ShadowMapReceiver)
{
if (sc_PointLights[lightId].shadowMapParamsIndex!=(-1))
{
return evaluateShadowMap(false,lightId,L);
}
}
#endif
return 1.0;
}
vec2 calcPanoramicTexCoordsFromDir(vec3 reflDir,float rotationDegrees)
{
float l9_0=-reflDir.z;
vec2 l9_1=vec2((((reflDir.x<0.0) ? (-1.0) : 1.0)*acos(clamp(l9_0/length(vec2(reflDir.x,l9_0)),-1.0,1.0)))-1.5707964,acos(reflDir.y))/vec2(6.2831855,3.1415927);
float l9_2=l9_1.x+(rotationDegrees/360.0);
vec2 l9_3=vec2(l9_2,1.0-l9_1.y);
l9_3.x=fract((l9_2+floor(l9_2))+1.0);
return l9_3;
}
int sc_EnvmapSpecularGetStereoViewIndex()
{
int l9_0;
#if (sc_EnvmapSpecularHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
vec4 sc_EnvmapSpecularSampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (sc_EnvmapSpecularLayout==2)
{
l9_0=texture(sc_EnvmapSpecularArrSC,sc_SamplingCoordsViewToGlobal(uv,sc_EnvmapSpecularLayout,sc_EnvmapSpecularGetStereoViewIndex()),bias);
}
#else
{
l9_0=texture(sc_EnvmapSpecular,sc_SamplingCoordsViewToGlobal(uv,sc_EnvmapSpecularLayout,sc_EnvmapSpecularGetStereoViewIndex()).xy,bias);
}
#endif
return l9_0;
}
vec2 calcSeamlessPanoramicUvsForSampling(vec2 uv,vec2 topMipRes,float lod)
{
#if (SC_DEVICE_CLASS>=2)
{
vec2 l9_0=max(vec2(1.0),topMipRes/vec2(exp2(lod)));
return ((uv*(l9_0-vec2(1.0)))/l9_0)+(vec2(0.5)/l9_0);
}
#else
{
return uv;
}
#endif
}
int sc_EnvmapDiffuseGetStereoViewIndex()
{
int l9_0;
#if (sc_EnvmapDiffuseHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
int sc_ScreenTextureGetStereoViewIndex()
{
int l9_0;
#if (sc_ScreenTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
vec4 sc_ScreenTextureSampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (sc_ScreenTextureLayout==2)
{
l9_0=texture(sc_ScreenTextureArrSC,sc_SamplingCoordsViewToGlobal(uv,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()),bias);
}
#else
{
l9_0=texture(sc_ScreenTexture,sc_SamplingCoordsViewToGlobal(uv,sc_ScreenTextureLayout,sc_ScreenTextureGetStereoViewIndex()).xy,bias);
}
#endif
return l9_0;
}
vec4 sc_readFragData0()
{
#if sc_FramebufferFetch
#ifdef GL_EXT_shader_framebuffer_fetch
return sc_FragData0;
#elif defined(GL_ARM_shader_framebuffer_fetch)
return gl_LastFragColorARM;
#endif
#else
return vec4(0.0);
#endif
}
vec4 sc_GetFramebufferColor()
{
vec4 l9_0;
#if (sc_FramebufferFetch)
{
l9_0=sc_readFragData0();
}
#else
{
l9_0=sc_ScreenTextureSampleViewBias(sc_ScreenCoordsGlobalToView(gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw),0.0);
}
#endif
return l9_0;
}
float srgbToLinear(float x)
{
#if (SC_DEVICE_CLASS>=2)
{
return pow(x,2.2);
}
#else
{
return x*x;
}
#endif
}
float linearToSrgb(float x)
{
#if (SC_DEVICE_CLASS>=2)
{
return pow(x,0.45454547);
}
#else
{
return sqrt(x);
}
#endif
}
int intensityTextureGetStereoViewIndex()
{
int l9_0;
#if (intensityTextureHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
return l9_0;
}
float transformSingleColor(float original,float intMap,float target)
{
#if (((sc_SoftwareBlendMode==40)||(sc_SoftwareBlendMode==43))||(sc_SoftwareBlendMode==44))
{
return original/pow(1.0-target,intMap);
}
#else
{
#if (sc_SoftwareBlendMode==41)
{
return original/(1.0-target);
}
#else
{
#if (sc_SoftwareBlendMode==42)
{
return original/pow(1.0-target,2.0-(2.0*original));
}
#endif
}
#endif
}
#endif
return 0.0;
}
vec3 RGBtoHCV(vec3 rgb)
{
vec4 l9_0;
if (rgb.y<rgb.z)
{
l9_0=vec4(rgb.zy,-1.0,0.66666669);
}
else
{
l9_0=vec4(rgb.yz,0.0,-0.33333334);
}
vec4 l9_1;
if (rgb.x<l9_0.x)
{
l9_1=vec4(l9_0.xyw,rgb.x);
}
else
{
l9_1=vec4(rgb.x,l9_0.yzx);
}
float l9_2=l9_1.x-min(l9_1.w,l9_1.y);
return vec3(abs(((l9_1.w-l9_1.y)/((6.0*l9_2)+1e-07))+l9_1.z),l9_2,l9_1.x);
}
vec3 RGBToHSL(vec3 rgb)
{
vec3 l9_0=RGBtoHCV(rgb);
float l9_1=l9_0.y;
float l9_2=l9_0.z-(l9_1*0.5);
return vec3(l9_0.x,l9_1/((1.0-abs((2.0*l9_2)-1.0))+1e-07),l9_2);
}
vec3 HUEtoRGB(float hue)
{
return clamp(vec3(abs((6.0*hue)-3.0)-1.0,2.0-abs((6.0*hue)-2.0),2.0-abs((6.0*hue)-4.0)),vec3(0.0),vec3(1.0));
}
vec3 HSLToRGB(vec3 hsl)
{
return ((HUEtoRGB(hsl.x)-vec3(0.5))*((1.0-abs((2.0*hsl.z)-1.0))*hsl.y))+vec3(hsl.z);
}
vec3 transformColor(float yValue,vec3 original,vec3 target,float weight,float intMap)
{
#if (sc_SoftwareBlendMode==45)
{
return mix(original,HSLToRGB(vec3(target.x,target.y,RGBToHSL(original).z)),vec3(weight));
}
#else
{
return mix(original,clamp(vec3(transformSingleColor(yValue,intMap,target.x),transformSingleColor(yValue,intMap,target.y),transformSingleColor(yValue,intMap,target.z)),vec3(0.0),vec3(1.0)),vec3(weight));
}
#endif
}
vec3 definedBlend(vec3 a,vec3 b)
{
#if (sc_SoftwareBlendMode==19)
{
return max(a,b);
}
#else
{
#if (sc_SoftwareBlendMode==17)
{
return min(a,b);
}
#else
{
#if (sc_SoftwareBlendMode==35)
{
return (a+b)*0.5;
}
#else
{
#if (sc_SoftwareBlendMode==30)
{
return max((a+b)-vec3(1.0),vec3(0.0));
}
#else
{
#if (sc_SoftwareBlendMode==28)
{
return abs(a-b);
}
#else
{
#if (sc_SoftwareBlendMode==36)
{
return vec3(1.0)-abs((vec3(1.0)-a)-b);
}
#else
{
#if (sc_SoftwareBlendMode==29)
{
return (a+b)-((a*2.0)*b);
}
#else
{
#if (sc_SoftwareBlendMode==21)
{
float l9_0;
if (a.x<0.5)
{
l9_0=(2.0*a.x)*b.x;
}
else
{
l9_0=1.0-((2.0*(1.0-a.x))*(1.0-b.x));
}
float l9_1;
if (a.y<0.5)
{
l9_1=(2.0*a.y)*b.y;
}
else
{
l9_1=1.0-((2.0*(1.0-a.y))*(1.0-b.y));
}
float l9_2;
if (a.z<0.5)
{
l9_2=(2.0*a.z)*b.z;
}
else
{
l9_2=1.0-((2.0*(1.0-a.z))*(1.0-b.z));
}
return vec3(l9_0,l9_1,l9_2);
}
#else
{
#if (sc_SoftwareBlendMode==22)
{
return (((vec3(1.0)-(b*2.0))*a)*a)+((a*2.0)*b);
}
#else
{
#if (sc_SoftwareBlendMode==23)
{
float l9_3;
if (b.x<0.5)
{
l9_3=(2.0*b.x)*a.x;
}
else
{
l9_3=1.0-((2.0*(1.0-b.x))*(1.0-a.x));
}
float l9_4;
if (b.y<0.5)
{
l9_4=(2.0*b.y)*a.y;
}
else
{
l9_4=1.0-((2.0*(1.0-b.y))*(1.0-a.y));
}
float l9_5;
if (b.z<0.5)
{
l9_5=(2.0*b.z)*a.z;
}
else
{
l9_5=1.0-((2.0*(1.0-b.z))*(1.0-a.z));
}
return vec3(l9_3,l9_4,l9_5);
}
#else
{
#if (sc_SoftwareBlendMode==20)
{
float l9_6;
if (b.x==1.0)
{
l9_6=b.x;
}
else
{
l9_6=min(a.x/(1.0-b.x),1.0);
}
float l9_7;
if (b.y==1.0)
{
l9_7=b.y;
}
else
{
l9_7=min(a.y/(1.0-b.y),1.0);
}
float l9_8;
if (b.z==1.0)
{
l9_8=b.z;
}
else
{
l9_8=min(a.z/(1.0-b.z),1.0);
}
return vec3(l9_6,l9_7,l9_8);
}
#else
{
#if (sc_SoftwareBlendMode==18)
{
float l9_9;
if (b.x==0.0)
{
l9_9=b.x;
}
else
{
l9_9=max(1.0-((1.0-a.x)/b.x),0.0);
}
float l9_10;
if (b.y==0.0)
{
l9_10=b.y;
}
else
{
l9_10=max(1.0-((1.0-a.y)/b.y),0.0);
}
float l9_11;
if (b.z==0.0)
{
l9_11=b.z;
}
else
{
l9_11=max(1.0-((1.0-a.z)/b.z),0.0);
}
return vec3(l9_9,l9_10,l9_11);
}
#else
{
#if (sc_SoftwareBlendMode==25)
{
float l9_12;
if (b.x<0.5)
{
l9_12=max((a.x+(2.0*b.x))-1.0,0.0);
}
else
{
l9_12=min(a.x+(2.0*(b.x-0.5)),1.0);
}
float l9_13;
if (b.y<0.5)
{
l9_13=max((a.y+(2.0*b.y))-1.0,0.0);
}
else
{
l9_13=min(a.y+(2.0*(b.y-0.5)),1.0);
}
float l9_14;
if (b.z<0.5)
{
l9_14=max((a.z+(2.0*b.z))-1.0,0.0);
}
else
{
l9_14=min(a.z+(2.0*(b.z-0.5)),1.0);
}
return vec3(l9_12,l9_13,l9_14);
}
#else
{
#if (sc_SoftwareBlendMode==24)
{
float l9_15;
if (b.x<0.5)
{
float l9_16;
if ((2.0*b.x)==0.0)
{
l9_16=2.0*b.x;
}
else
{
l9_16=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_15=l9_16;
}
else
{
float l9_17;
if ((2.0*(b.x-0.5))==1.0)
{
l9_17=2.0*(b.x-0.5);
}
else
{
l9_17=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_15=l9_17;
}
float l9_18;
if (b.y<0.5)
{
float l9_19;
if ((2.0*b.y)==0.0)
{
l9_19=2.0*b.y;
}
else
{
l9_19=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_18=l9_19;
}
else
{
float l9_20;
if ((2.0*(b.y-0.5))==1.0)
{
l9_20=2.0*(b.y-0.5);
}
else
{
l9_20=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_18=l9_20;
}
float l9_21;
if (b.z<0.5)
{
float l9_22;
if ((2.0*b.z)==0.0)
{
l9_22=2.0*b.z;
}
else
{
l9_22=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_21=l9_22;
}
else
{
float l9_23;
if ((2.0*(b.z-0.5))==1.0)
{
l9_23=2.0*(b.z-0.5);
}
else
{
l9_23=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_21=l9_23;
}
return vec3(l9_15,l9_18,l9_21);
}
#else
{
#if (sc_SoftwareBlendMode==26)
{
float l9_24;
if (b.x<0.5)
{
l9_24=min(a.x,2.0*b.x);
}
else
{
l9_24=max(a.x,2.0*(b.x-0.5));
}
float l9_25;
if (b.y<0.5)
{
l9_25=min(a.y,2.0*b.y);
}
else
{
l9_25=max(a.y,2.0*(b.y-0.5));
}
float l9_26;
if (b.z<0.5)
{
l9_26=min(a.z,2.0*b.z);
}
else
{
l9_26=max(a.z,2.0*(b.z-0.5));
}
return vec3(l9_24,l9_25,l9_26);
}
#else
{
#if (sc_SoftwareBlendMode==27)
{
float l9_27;
if (b.x<0.5)
{
float l9_28;
if ((2.0*b.x)==0.0)
{
l9_28=2.0*b.x;
}
else
{
l9_28=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_27=l9_28;
}
else
{
float l9_29;
if ((2.0*(b.x-0.5))==1.0)
{
l9_29=2.0*(b.x-0.5);
}
else
{
l9_29=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_27=l9_29;
}
bool l9_30=l9_27<0.5;
float l9_31;
if (b.y<0.5)
{
float l9_32;
if ((2.0*b.y)==0.0)
{
l9_32=2.0*b.y;
}
else
{
l9_32=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_31=l9_32;
}
else
{
float l9_33;
if ((2.0*(b.y-0.5))==1.0)
{
l9_33=2.0*(b.y-0.5);
}
else
{
l9_33=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_31=l9_33;
}
bool l9_34=l9_31<0.5;
float l9_35;
if (b.z<0.5)
{
float l9_36;
if ((2.0*b.z)==0.0)
{
l9_36=2.0*b.z;
}
else
{
l9_36=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_35=l9_36;
}
else
{
float l9_37;
if ((2.0*(b.z-0.5))==1.0)
{
l9_37=2.0*(b.z-0.5);
}
else
{
l9_37=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_35=l9_37;
}
return vec3(l9_30 ? 0.0 : 1.0,l9_34 ? 0.0 : 1.0,(l9_35<0.5) ? 0.0 : 1.0);
}
#else
{
#if (sc_SoftwareBlendMode==37)
{
float l9_38;
if (b.x==1.0)
{
l9_38=b.x;
}
else
{
l9_38=min((a.x*a.x)/(1.0-b.x),1.0);
}
float l9_39;
if (b.y==1.0)
{
l9_39=b.y;
}
else
{
l9_39=min((a.y*a.y)/(1.0-b.y),1.0);
}
float l9_40;
if (b.z==1.0)
{
l9_40=b.z;
}
else
{
l9_40=min((a.z*a.z)/(1.0-b.z),1.0);
}
return vec3(l9_38,l9_39,l9_40);
}
#else
{
#if (sc_SoftwareBlendMode==38)
{
float l9_41;
if (a.x==1.0)
{
l9_41=a.x;
}
else
{
l9_41=min((b.x*b.x)/(1.0-a.x),1.0);
}
float l9_42;
if (a.y==1.0)
{
l9_42=a.y;
}
else
{
l9_42=min((b.y*b.y)/(1.0-a.y),1.0);
}
float l9_43;
if (a.z==1.0)
{
l9_43=a.z;
}
else
{
l9_43=min((b.z*b.z)/(1.0-a.z),1.0);
}
return vec3(l9_41,l9_42,l9_43);
}
#else
{
#if (sc_SoftwareBlendMode==39)
{
return (min(a,b)-max(a,b))+vec3(1.0);
}
#else
{
#if (sc_SoftwareBlendMode==31)
{
return HSLToRGB(vec3(RGBToHSL(b).x,RGBToHSL(a).yz));
}
#else
{
#if (sc_SoftwareBlendMode==32)
{
vec3 l9_44=RGBToHSL(a);
return HSLToRGB(vec3(l9_44.x,RGBToHSL(b).y,l9_44.z));
}
#else
{
#if (sc_SoftwareBlendMode==33)
{
return HSLToRGB(vec3(RGBToHSL(b).xy,RGBToHSL(a).z));
}
#else
{
#if (sc_SoftwareBlendMode==34)
{
return HSLToRGB(vec3(RGBToHSL(a).xy,RGBToHSL(b).z));
}
#else
{
vec3 l9_45=a;
vec3 l9_46=b;
float l9_47=((0.29899999*l9_45.x)+(0.58700001*l9_45.y))+(0.114*l9_45.z);
float l9_48=pow(l9_47,1.0/correctedIntensity);
vec4 l9_49;
#if (intensityTextureLayout==2)
{
bool l9_50=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_intensityTexture)!=0));
float l9_51=l9_48;
sc_SoftwareWrapEarly(l9_51,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x);
float l9_52=l9_51;
float l9_53=0.5;
sc_SoftwareWrapEarly(l9_53,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y);
float l9_54=l9_53;
vec2 l9_55;
float l9_56;
#if (SC_USE_UV_MIN_MAX_intensityTexture)
{
bool l9_57;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_57=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x==3;
}
#else
{
l9_57=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_58=l9_52;
float l9_59=1.0;
sc_ClampUV(l9_58,intensityTextureUvMinMax.x,intensityTextureUvMinMax.z,l9_57,l9_59);
float l9_60=l9_58;
float l9_61=l9_59;
bool l9_62;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_62=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y==3;
}
#else
{
l9_62=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_63=l9_54;
float l9_64=l9_61;
sc_ClampUV(l9_63,intensityTextureUvMinMax.y,intensityTextureUvMinMax.w,l9_62,l9_64);
l9_56=l9_64;
l9_55=vec2(l9_60,l9_63);
}
#else
{
l9_56=1.0;
l9_55=vec2(l9_52,l9_54);
}
#endif
vec2 l9_65=sc_TransformUV(l9_55,(int(SC_USE_UV_TRANSFORM_intensityTexture)!=0),intensityTextureTransform);
float l9_66=l9_65.x;
float l9_67=l9_56;
sc_SoftwareWrapLate(l9_66,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x,l9_50,l9_67);
float l9_68=l9_65.y;
float l9_69=l9_67;
sc_SoftwareWrapLate(l9_68,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y,l9_50,l9_69);
float l9_70=l9_69;
vec3 l9_71=sc_SamplingCoordsViewToGlobal(vec2(l9_66,l9_68),intensityTextureLayout,intensityTextureGetStereoViewIndex());
vec4 l9_72=texture(intensityTextureArrSC,l9_71,0.0);
vec4 l9_73;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_73=mix(intensityTextureBorderColor,l9_72,vec4(l9_70));
}
#else
{
l9_73=l9_72;
}
#endif
l9_49=l9_73;
}
#else
{
bool l9_74=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_intensityTexture)!=0));
float l9_75=l9_48;
sc_SoftwareWrapEarly(l9_75,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x);
float l9_76=l9_75;
float l9_77=0.5;
sc_SoftwareWrapEarly(l9_77,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y);
float l9_78=l9_77;
vec2 l9_79;
float l9_80;
#if (SC_USE_UV_MIN_MAX_intensityTexture)
{
bool l9_81;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_81=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x==3;
}
#else
{
l9_81=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_82=l9_76;
float l9_83=1.0;
sc_ClampUV(l9_82,intensityTextureUvMinMax.x,intensityTextureUvMinMax.z,l9_81,l9_83);
float l9_84=l9_82;
float l9_85=l9_83;
bool l9_86;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_86=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y==3;
}
#else
{
l9_86=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
}
#endif
float l9_87=l9_78;
float l9_88=l9_85;
sc_ClampUV(l9_87,intensityTextureUvMinMax.y,intensityTextureUvMinMax.w,l9_86,l9_88);
l9_80=l9_88;
l9_79=vec2(l9_84,l9_87);
}
#else
{
l9_80=1.0;
l9_79=vec2(l9_76,l9_78);
}
#endif
vec2 l9_89=sc_TransformUV(l9_79,(int(SC_USE_UV_TRANSFORM_intensityTexture)!=0),intensityTextureTransform);
float l9_90=l9_89.x;
float l9_91=l9_80;
sc_SoftwareWrapLate(l9_90,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).x,l9_74,l9_91);
float l9_92=l9_89.y;
float l9_93=l9_91;
sc_SoftwareWrapLate(l9_92,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture).y,l9_74,l9_93);
float l9_94=l9_93;
vec3 l9_95=sc_SamplingCoordsViewToGlobal(vec2(l9_90,l9_92),intensityTextureLayout,intensityTextureGetStereoViewIndex());
vec4 l9_96=texture(intensityTexture,l9_95.xy,0.0);
vec4 l9_97;
#if (SC_USE_CLAMP_TO_BORDER_intensityTexture)
{
l9_97=mix(intensityTextureBorderColor,l9_96,vec4(l9_94));
}
#else
{
l9_97=l9_96;
}
#endif
l9_49=l9_97;
}
#endif
float l9_98=((((l9_49.x*256.0)+l9_49.y)+(l9_49.z/256.0))/257.00391)*16.0;
float l9_99;
#if (sc_SoftwareBlendMode==43)
{
l9_99=max(l9_98,1.0);
}
#else
{
l9_99=l9_98;
}
#endif
float l9_100;
#if (sc_SoftwareBlendMode==44)
{
l9_100=min(l9_99,1.0);
}
#else
{
l9_100=l9_99;
}
#endif
return transformColor(l9_47,l9_45,l9_46,1.0,l9_100);
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
vec4 sc_OutputMotionVectorIfNeeded(vec4 finalColor)
{
#if (sc_MotionVectorsPass)
{
float l9_0=floor(((varPosAndMotion.w*5.0)+0.5)*65535.0);
float l9_1=floor(l9_0*0.00390625);
float l9_2=floor(((varNormalAndMotion.w*5.0)+0.5)*65535.0);
float l9_3=floor(l9_2*0.00390625);
return vec4(l9_1/255.0,(l9_0-(l9_1*256.0))/255.0,l9_3/255.0,(l9_2-(l9_3*256.0))/255.0);
}
#else
{
return finalColor;
}
#endif
}
void sc_writeFragData0(vec4 col)
{
#if (sc_ShaderCacheConstant!=0)
{
col.x+=(sc_UniformConstants.x*float(sc_ShaderCacheConstant));
}
#endif
sc_FragData0=col;
}
float getFrontLayerZTestEpsilon()
{
#if (sc_SkinBonesCount>0)
{
return 5e-07;
}
#else
{
return 5.0000001e-08;
}
#endif
}
void unpackValues(float channel,int passIndex,inout int values[8])
{
#if (sc_OITCompositingPass)
{
channel=floor((channel*255.0)+0.5);
int l9_0=((passIndex+1)*4)-1;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_0>=(passIndex*4))
{
values[l9_0]=(values[l9_0]*4)+int(floor(mod(channel,4.0)));
channel=floor(channel/4.0);
l9_0--;
continue;
}
else
{
break;
}
}
}
#endif
}
float getDepthOrderingEpsilon()
{
#if (sc_SkinBonesCount>0)
{
return 0.001;
}
#else
{
return 0.0;
}
#endif
}
int encodeDepth(float depth,vec2 depthBounds)
{
float l9_0=(1.0-depthBounds.x)*1000.0;
return int(clamp((depth-l9_0)/((depthBounds.y*1000.0)-l9_0),0.0,1.0)*65535.0);
}
float viewSpaceDepth()
{
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
return varViewSpaceDepth;
}
#else
{
return sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((gl_FragCoord.z*2.0)-1.0));
}
#endif
}
float packValue(inout int value)
{
#if (sc_OITDepthGatherPass)
{
int l9_0=value;
value/=4;
return floor(floor(mod(float(l9_0),4.0))*64.0)/255.0;
}
#else
{
return 0.0;
}
#endif
}
void main()
{
#if (sc_DepthOnly)
{
return;
}
#endif
#if ((sc_StereoRenderingMode==1)&&(sc_StereoRendering_IsClipDistanceEnabled==0))
{
if (varClipDistance<0.0)
{
discard;
}
}
#endif
vec3 l9_0=normalize(sc_Camera.position-varPosAndMotion.xyz);
vec2 l9_1=gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw;
vec3 l9_2=normalize(varTangent.xyz);
vec3 l9_3=normalize(varNormalAndMotion.xyz);
ssGlobals l9_4=ssGlobals(sc_Time.x,sc_Time.y,0.0,vec3(0.0),l9_0,varPosAndMotion.xyz,varColor,varTex01.xy,varTex01.zw,sc_ScreenCoordsGlobalToView(l9_1),l9_2,l9_3,cross(l9_3,l9_2)*varTangent.w);
vec4 l9_5;
Node369_If_else(0.0,vec4(0.0),Port_Default_N369,l9_5,l9_4);
vec4 l9_6=l9_5;
vec4 param_3;
Node369_If_else(0.0,vec4(0.0),Port_Default_N369,param_3,l9_4);
vec4 l9_7=param_3;
float l9_8=dot(l9_3,l9_3);
float l9_9;
if (l9_8>0.0)
{
l9_9=1.0/sqrt(l9_8);
}
else
{
l9_9=0.0;
}
vec3 l9_10=l9_3*l9_9;
vec3 l9_11;
#if (!sc_ProjectiveShadowsCaster)
{
l9_11=l9_10;
}
#else
{
l9_11=vec3(0.0);
}
#endif
float l9_12=clamp(((baseColor*l9_7).w*Port_Default_N204)*Port_Input2_N072,0.0,1.0);
#if (sc_BlendMode==8)
{
if (l9_12<alphaTestThreshold)
{
discard;
}
}
#endif
#if (ENABLE_STIPPLE_PATTERN_TEST)
{
if (l9_12<((mod(dot(floor(mod(gl_FragCoord.xy,vec2(4.0))),vec2(4.0,1.0))*9.0,16.0)+1.0)/17.0))
{
discard;
}
}
#endif
vec3 l9_13=max((baseColor*l9_6).xyz,vec3(0.0));
vec4 l9_14;
#if (sc_ProjectiveShadowsCaster)
{
l9_14=vec4(l9_13,l9_12);
}
#else
{
vec3 l9_15=ssSRGB_to_Linear(l9_13);
vec3 l9_16=normalize(l9_11);
vec3 l9_17=ssSRGB_to_Linear(Port_Emissive_N036);
vec3 l9_18;
#if (sc_SSAOEnabled)
{
l9_18=evaluateSSAO(varPosAndMotion.xyz);
}
#else
{
l9_18=Port_AO_N036;
}
#endif
vec3 l9_19=l9_15*(1.0-0.0);
SurfaceProperties l9_20=SurfaceProperties(l9_19,l9_12,l9_16,varPosAndMotion.xyz,l9_0,0.0,1.0,l9_17,l9_18,vec3(1.0),vec3(1.0),vec3(0.039999999));
vec4 l9_21=vec4(1.0);
vec3 l9_22;
vec3 l9_23;
vec3 l9_24;
vec3 l9_25;
vec3 l9_26;
int l9_27;
vec3 l9_28;
#if (sc_DirectionalLightsCount>0)
{
vec3 l9_29;
vec3 l9_30;
vec3 l9_31;
vec3 l9_32;
vec3 l9_33;
int l9_34;
vec3 l9_35;
l9_35=vec3(1.0);
l9_34=0;
l9_33=vec3(0.0);
l9_32=vec3(0.0);
l9_31=vec3(0.0);
l9_30=vec3(0.0);
l9_29=vec3(0.0);
int l9_36;
vec3 l9_37;
vec3 l9_38;
vec3 l9_39;
vec3 l9_40;
vec3 l9_41;
vec3 l9_42;
int l9_43=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_43<sc_DirectionalLightsCount)
{
float l9_44=l9_21[(l9_34<3) ? l9_34 : 3];
vec3 l9_45;
#if (sc_ShadowMapReceiver)
{
vec3 l9_46;
if (sc_ShadowMapParams[sc_DirectionalLights[l9_43].shadowMapParamsIndex].params[1].w>0.0)
{
l9_46=mix(sc_ShadowMapParams[sc_DirectionalLights[l9_43].shadowMapParamsIndex].params[0].xyz,sc_DirectionalLights[l9_43].color.xyz,vec3(evaluateDirectionalShadowMap(l9_43)));
}
else
{
l9_46=sc_DirectionalLights[l9_43].color.xyz;
}
l9_45=l9_46;
}
#else
{
l9_45=sc_DirectionalLights[l9_43].color.xyz;
}
#endif
l9_36=l9_34+1;
LightingComponents l9_47=accumulateLight(LightingComponents(l9_29,l9_30,l9_35,l9_33,l9_32,l9_31),LightProperties(sc_DirectionalLights[l9_43].direction,l9_45,sc_DirectionalLights[l9_43].color.w*l9_44),l9_20,l9_0);
l9_37=l9_47.directDiffuse;
l9_38=l9_47.directSpecular;
l9_39=l9_47.indirectDiffuse;
l9_40=l9_47.indirectSpecular;
l9_41=l9_47.emitted;
l9_42=l9_47.transmitted;
l9_35=l9_39;
l9_34=l9_36;
l9_33=l9_40;
l9_32=l9_41;
l9_31=l9_42;
l9_30=l9_38;
l9_29=l9_37;
l9_43++;
continue;
}
else
{
break;
}
}
l9_28=l9_35;
l9_27=l9_34;
l9_26=l9_33;
l9_25=l9_32;
l9_24=l9_31;
l9_23=l9_30;
l9_22=l9_29;
}
#else
{
l9_28=vec3(1.0);
l9_27=0;
l9_26=vec3(0.0);
l9_25=vec3(0.0);
l9_24=vec3(0.0);
l9_23=vec3(0.0);
l9_22=vec3(0.0);
}
#endif
vec3 l9_48;
vec3 l9_49;
vec3 l9_50;
#if (sc_PointLightsCount>0)
{
vec3 l9_51;
vec3 l9_52;
vec3 l9_53;
vec3 l9_54;
vec3 l9_55;
vec3 l9_56;
l9_56=l9_28;
l9_55=l9_26;
l9_54=l9_25;
l9_53=l9_24;
l9_52=l9_23;
l9_51=l9_22;
int l9_57;
vec3 l9_58;
vec3 l9_59;
vec3 l9_60;
vec3 l9_61;
vec3 l9_62;
vec3 l9_63;
int l9_64=0;
int l9_65=l9_27;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_64<sc_PointLightsCount)
{
vec3 l9_66=sc_PointLights[l9_64].position-varPosAndMotion.xyz;
float l9_67=dot(l9_66,l9_66);
bool l9_68=sc_PointLights[l9_64].falloffRangeSqr>0.0;
if (!(l9_68&&(l9_67>sc_PointLights[l9_64].falloffRangeSqr)))
{
float l9_69=inversesqrt(l9_67);
vec3 l9_70=l9_66*l9_69;
float l9_71=l9_21[(l9_65<3) ? l9_65 : 3];
float l9_72=clamp((dot(l9_70,sc_PointLights[l9_64].direction)*sc_PointLights[l9_64].angleScale)+sc_PointLights[l9_64].angleOffset,0.0,1.0);
float l9_73=(sc_PointLights[l9_64].color.w*l9_71)*(l9_72*l9_72);
float l9_74;
if (l9_68)
{
float l9_75;
if (sc_PointLights[l9_64].falloffRangeNegInvSqrSqr!=0.0)
{
l9_75=max(10000.0+((l9_67*l9_67)*sc_PointLights[l9_64].falloffRangeNegInvSqrSqr),0.0);
}
else
{
l9_75=10000.0;
}
l9_74=l9_73*(l9_75*(l9_69*l9_69));
}
else
{
l9_74=l9_73;
}
vec3 l9_76;
#if (sc_ShadowMapReceiver)
{
vec3 l9_77;
if (sc_ShadowMapParams[sc_PointLights[l9_64].shadowMapParamsIndex].params[1].w>0.0)
{
l9_77=mix(sc_ShadowMapParams[sc_PointLights[l9_64].shadowMapParamsIndex].params[0].xyz,sc_PointLights[l9_64].color.xyz,vec3(evaluatePointShadowMap(l9_64,-l9_70)));
}
else
{
l9_77=sc_PointLights[l9_64].color.xyz;
}
l9_76=l9_77;
}
#else
{
l9_76=sc_PointLights[l9_64].color.xyz;
}
#endif
LightingComponents l9_78=accumulateLight(LightingComponents(l9_51,l9_52,l9_56,l9_55,l9_54,l9_53),LightProperties(l9_70,l9_76,l9_74),l9_20,l9_0);
l9_63=l9_78.indirectDiffuse;
l9_62=l9_78.indirectSpecular;
l9_61=l9_78.emitted;
l9_60=l9_78.transmitted;
l9_59=l9_78.directSpecular;
l9_58=l9_78.directDiffuse;
}
else
{
l9_63=l9_56;
l9_62=l9_55;
l9_61=l9_54;
l9_60=l9_53;
l9_59=l9_52;
l9_58=l9_51;
}
l9_57=l9_65+1;
l9_56=l9_63;
l9_65=l9_57;
l9_55=l9_62;
l9_54=l9_61;
l9_53=l9_60;
l9_52=l9_59;
l9_51=l9_58;
l9_64++;
continue;
}
else
{
break;
}
}
l9_50=l9_55;
l9_49=l9_53;
l9_48=l9_51;
}
#else
{
l9_50=l9_26;
l9_49=l9_24;
l9_48=l9_22;
}
#endif
vec3 l9_79;
#if (sc_ProjectiveShadowsReceiver)
{
vec3 l9_80;
#if (sc_ProjectiveShadowsReceiver)
{
vec2 l9_81=abs(varShadowTex-vec2(0.5));
vec4 l9_82=texture(sc_ShadowTexture,varShadowTex)*step(max(l9_81.x,l9_81.y),0.5);
l9_80=mix(vec3(1.0),mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_82.xyz,vec3(sc_ShadowColor.w)),vec3(l9_82.w*sc_ShadowDensity));
}
#else
{
l9_80=vec3(1.0);
}
#endif
l9_79=l9_48*l9_80;
}
#else
{
l9_79=l9_48;
}
#endif
vec3 l9_83;
#if ((sc_EnvLightMode==sc_AmbientLightMode_EnvironmentMap)||(sc_EnvLightMode==sc_AmbientLightMode_FromCamera))
{
vec4 l9_84;
#if (sc_EnvLightMode==sc_AmbientLightMode_FromCamera)
{
vec2 l9_85=calcPanoramicTexCoordsFromDir(l9_16,sc_EnvmapRotation.y);
vec2 l9_86;
#if (SC_DEVICE_CLASS>=2)
{
l9_86=calcSeamlessPanoramicUvsForSampling(l9_85,sc_EnvmapSpecularSize.xy,5.0);
}
#else
{
l9_86=l9_85;
}
#endif
l9_84=sc_EnvmapSpecularSampleViewBias(l9_86,13.0);
}
#else
{
vec4 l9_87;
#if (sc_HasSpecularCubemap)
{
float l9_88=l9_16.z;
float l9_89=l9_16.x;
float l9_90=((-l9_88)*sc_EnvmapRotationSinCos.y)-(l9_89*sc_EnvmapRotationSinCos.x);
float l9_91=l9_16.y;
float l9_92=(l9_88*sc_EnvmapRotationSinCos.x)-(l9_89*sc_EnvmapRotationSinCos.y);
vec3 l9_93=vec3(l9_90,l9_91,l9_92);
vec3 l9_94;
if (abs(l9_92)<0.99000001)
{
l9_94=vec3(-l9_91,l9_90,0.0);
}
else
{
l9_94=vec3(0.0,-l9_92,l9_91);
}
vec3 l9_95=normalize(l9_94);
vec3 l9_96=l9_95*(-0.5);
vec3 l9_97=cross(l9_93,l9_95)*0.86602539;
l9_87=((textureLod(sc_SpecularCubemap,l9_93+(((l9_95*1.0)+vec3(0.0))*0.18000001),4.5)+textureLod(sc_SpecularCubemap,l9_93+((l9_96+l9_97)*0.18000001),4.5))+textureLod(sc_SpecularCubemap,l9_93+((l9_96-l9_97)*0.18000001),4.5))*0.33333334;
}
#else
{
vec2 l9_98=calcPanoramicTexCoordsFromDir(l9_16,sc_EnvmapRotation.y);
vec4 l9_99;
#if (sc_HasDiffuseEnvmap)
{
vec2 l9_100=calcSeamlessPanoramicUvsForSampling(l9_98,sc_EnvmapDiffuseSize.xy,0.0);
vec4 l9_101;
#if (sc_EnvmapDiffuseLayout==2)
{
l9_101=texture(sc_EnvmapDiffuseArrSC,sc_SamplingCoordsViewToGlobal(l9_100,sc_EnvmapDiffuseLayout,sc_EnvmapDiffuseGetStereoViewIndex()),-13.0);
}
#else
{
l9_101=texture(sc_EnvmapDiffuse,sc_SamplingCoordsViewToGlobal(l9_100,sc_EnvmapDiffuseLayout,sc_EnvmapDiffuseGetStereoViewIndex()).xy,-13.0);
}
#endif
l9_99=l9_101;
}
#else
{
l9_99=sc_EnvmapSpecularSampleViewBias(l9_98,13.0);
}
#endif
l9_87=l9_99;
}
#endif
l9_84=l9_87;
}
#endif
l9_83=(l9_84.xyz*(1.0/max(l9_84.w,0.0039215689)))*sc_EnvmapExposure;
}
#else
{
vec3 l9_102;
#if (sc_EnvLightMode==sc_AmbientLightMode_SphericalHarmonics)
{
vec3 l9_103=-l9_16;
float l9_104=l9_103.x;
float l9_105=l9_103.y;
float l9_106=l9_103.z;
l9_102=(((((((sc_Sh[8]*0.42904299)*((l9_104*l9_104)-(l9_105*l9_105)))+((sc_Sh[6]*0.74312502)*(l9_106*l9_106)))+(sc_Sh[0]*0.88622701))-(sc_Sh[6]*0.24770799))+((((sc_Sh[4]*(l9_104*l9_105))+(sc_Sh[7]*(l9_104*l9_106)))+(sc_Sh[5]*(l9_105*l9_106)))*0.85808599))+((((sc_Sh[3]*l9_104)+(sc_Sh[1]*l9_105))+(sc_Sh[2]*l9_106))*1.0233279))*sc_ShIntensity;
}
#else
{
l9_102=vec3(0.0);
}
#endif
l9_83=l9_102;
}
#endif
vec3 l9_107;
#if (sc_AmbientLightsCount>0)
{
vec3 l9_108;
#if (sc_AmbientLightMode0==sc_AmbientLightMode_Constant)
{
l9_108=l9_83+(sc_AmbientLights[0].color*sc_AmbientLights[0].intensity);
}
#else
{
vec3 l9_109=l9_83;
l9_109.x=l9_83.x+(1e-06*sc_AmbientLights[0].color.x);
l9_108=l9_109;
}
#endif
l9_107=l9_108;
}
#else
{
l9_107=l9_83;
}
#endif
vec3 l9_110;
#if (sc_AmbientLightsCount>1)
{
vec3 l9_111;
#if (sc_AmbientLightMode1==sc_AmbientLightMode_Constant)
{
l9_111=l9_107+(sc_AmbientLights[1].color*sc_AmbientLights[1].intensity);
}
#else
{
vec3 l9_112=l9_107;
l9_112.x=l9_107.x+(1e-06*sc_AmbientLights[1].color.x);
l9_111=l9_112;
}
#endif
l9_110=l9_111;
}
#else
{
l9_110=l9_107;
}
#endif
vec3 l9_113;
#if (sc_AmbientLightsCount>2)
{
vec3 l9_114;
#if (sc_AmbientLightMode2==sc_AmbientLightMode_Constant)
{
l9_114=l9_110+(sc_AmbientLights[2].color*sc_AmbientLights[2].intensity);
}
#else
{
vec3 l9_115=l9_110;
l9_115.x=l9_110.x+(1e-06*sc_AmbientLights[2].color.x);
l9_114=l9_115;
}
#endif
l9_113=l9_114;
}
#else
{
l9_113=l9_110;
}
#endif
vec3 l9_116;
#if (sc_LightEstimation)
{
vec3 l9_117;
l9_117=sc_LightEstimationData.ambientLight;
vec3 l9_118;
int l9_119=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_119<sc_LightEstimationSGCount)
{
float l9_120=dot(sc_LightEstimationData.sg[l9_119].axis,l9_16);
float l9_121=exp(-sc_LightEstimationData.sg[l9_119].sharpness);
float l9_122=l9_121*l9_121;
float l9_123=1.0/sc_LightEstimationData.sg[l9_119].sharpness;
float l9_124=(1.0+(2.0*l9_122))-l9_123;
float l9_125=sqrt(1.0-l9_124);
float l9_126=0.36000001*l9_120;
float l9_127=(1.0/(4.0*0.36000001))*l9_125;
float l9_128=l9_126+l9_127;
float l9_129;
if (step(abs(l9_126),l9_127)>0.5)
{
l9_129=(l9_128*l9_128)/l9_125;
}
else
{
l9_129=clamp(l9_120,0.0,1.0);
}
l9_118=l9_117+((((sc_LightEstimationData.sg[l9_119].color/vec3(sc_LightEstimationData.sg[l9_119].sharpness))*6.2831855)*((l9_124*l9_129)+(((l9_121-l9_122)*l9_123)-l9_122)))/vec3(3.1415927));
l9_117=l9_118;
l9_119++;
continue;
}
else
{
break;
}
}
l9_116=l9_113+l9_117;
}
#else
{
l9_116=l9_113;
}
#endif
float l9_130;
vec3 l9_131;
vec3 l9_132;
vec3 l9_133;
#if (sc_BlendMode==9)
{
l9_133=vec3(0.0);
l9_132=vec3(0.0);
l9_131=ssSRGB_to_Linear(sc_GetFramebufferColor().xyz)*mix(vec3(1.0),l9_19,vec3(l9_12));
l9_130=1.0;
}
#else
{
l9_133=l9_79;
l9_132=l9_116;
l9_131=l9_49;
l9_130=l9_12;
}
#endif
bool l9_134;
#if (sc_BlendMode==4)
{
l9_134=true;
}
#else
{
l9_134=false;
}
#endif
vec3 l9_135=l9_132*l9_18;
vec3 l9_136=l9_133+l9_135;
vec3 l9_137=l9_19*l9_136;
vec3 l9_138=l9_50*vec3(1.0);
vec3 l9_139;
if (l9_134)
{
l9_139=l9_137*srgbToLinear(l9_130);
}
else
{
l9_139=l9_137;
}
vec3 l9_140=l9_139+(vec3(0.0)+l9_138);
vec3 l9_141=(l9_140+l9_17)+l9_131;
float l9_142=l9_141.x;
vec4 l9_143=vec4(l9_142,l9_141.yz,l9_130);
vec4 l9_144;
#if (sc_IsEditor)
{
vec4 l9_145=l9_143;
l9_145.x=l9_142+((l9_18.x*1.0)*9.9999997e-06);
l9_144=l9_145;
}
#else
{
l9_144=l9_143;
}
#endif
vec4 l9_146;
#if (sc_BlendMode!=1)
{
vec3 l9_147=l9_144.xyz*1.8;
vec3 l9_148=(l9_144.xyz*(l9_147+vec3(1.4)))/((l9_144.xyz*(l9_147+vec3(0.5)))+vec3(1.5));
l9_146=vec4(l9_148.x,l9_148.y,l9_148.z,l9_144.w);
}
#else
{
l9_146=l9_144;
}
#endif
vec3 l9_149=vec3(linearToSrgb(l9_146.x),linearToSrgb(l9_146.y),linearToSrgb(l9_146.z));
l9_14=vec4(l9_149.x,l9_149.y,l9_149.z,l9_146.w);
}
#endif
vec4 l9_150=max(l9_14,vec4(0.0));
vec4 l9_151;
#if (sc_ProjectiveShadowsCaster)
{
float l9_152;
#if ((((sc_BlendMode==0)||(sc_BlendMode==5))||(sc_BlendMode==14))||(sc_BlendMode==16))
{
l9_152=l9_150.w;
}
#else
{
float l9_153;
#if (sc_BlendMode==4)
{
l9_153=clamp(l9_150.w*2.0,0.0,1.0);
}
#else
{
float l9_154;
#if (sc_BlendMode==8)
{
l9_154=1.0;
}
#else
{
float l9_155;
#if (sc_BlendMode==1)
{
l9_155=(1.0-dot(l9_150.xyz,vec3(0.33333001)))*l9_150.w;
}
#else
{
float l9_156;
#if (sc_BlendMode==10)
{
l9_156=(1.0-clamp(dot(l9_150.xyz,vec3(1.0)),0.0,1.0))*l9_150.w;
}
#else
{
float l9_157;
#if (sc_BlendMode==9)
{
l9_157=clamp(dot(l9_150.xyz,vec3(1.0)),0.0,1.0)*l9_150.w;
}
#else
{
float l9_158;
#if (sc_BlendMode==2)
{
l9_158=clamp(dot(l9_150.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_159;
#if (sc_BlendMode==7)
{
l9_159=clamp(dot(l9_150.xyz,vec3(1.0)),0.0,1.0)*l9_150.w;
}
#else
{
float l9_160;
#if (sc_BlendMode==3)
{
l9_160=dot(l9_150.xyz,vec3(0.33333001))*l9_150.w;
}
#else
{
float l9_161;
#if (sc_BlendMode==11)
{
l9_161=1.0-clamp(dot(l9_150.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_162;
#if (sc_BlendMode==12)
{
l9_162=clamp(dot(l9_150.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
l9_162=1.0;
}
#endif
l9_161=l9_162;
}
#endif
l9_160=l9_161;
}
#endif
l9_159=l9_160;
}
#endif
l9_158=l9_159;
}
#endif
l9_157=l9_158;
}
#endif
l9_156=l9_157;
}
#endif
l9_155=l9_156;
}
#endif
l9_154=l9_155;
}
#endif
l9_153=l9_154;
}
#endif
l9_152=l9_153;
}
#endif
l9_151=vec4(mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_150.xyz,vec3(sc_ShadowColor.w)),sc_ShadowDensity*l9_152);
}
#else
{
vec4 l9_163;
#if (sc_RenderAlphaToColor)
{
l9_163=vec4(l9_150.w);
}
#else
{
vec4 l9_164;
#if (sc_BlendMode_Custom)
{
vec3 l9_165=sc_GetFramebufferColor().xyz;
vec3 l9_166=mix(l9_165,definedBlend(l9_165,l9_150.xyz).xyz,vec3(l9_150.w));
vec4 l9_167=vec4(l9_166.x,l9_166.y,l9_166.z,vec4(0.0).w);
l9_167.w=1.0;
l9_164=l9_167;
}
#else
{
vec4 l9_168;
#if (sc_Voxelization)
{
l9_168=vec4(varScreenPos.xyz,1.0);
}
#else
{
vec4 l9_169;
#if (sc_OutputBounds)
{
float l9_170=clamp(abs(gl_FragCoord.z),0.0,1.0);
l9_169=vec4(l9_170,1.0-l9_170,1.0,1.0);
}
#else
{
vec4 l9_171;
#if (sc_BlendMode==10)
{
float l9_172=l9_150.w;
l9_171=vec4(mix(vec3(1.0),l9_150.xyz,vec3(l9_172)),l9_172);
}
#else
{
vec4 l9_173;
#if ((sc_BlendMode==3)||(sc_BlendMode==16))
{
float l9_174=l9_150.w;
float l9_175;
#if (sc_BlendMode==16)
{
l9_175=clamp(l9_174,0.0,1.0);
}
#else
{
l9_175=l9_174;
}
#endif
l9_173=vec4(l9_150.xyz*l9_175,l9_175);
}
#else
{
l9_173=l9_150;
}
#endif
l9_171=l9_173;
}
#endif
l9_169=l9_171;
}
#endif
l9_168=l9_169;
}
#endif
l9_164=l9_168;
}
#endif
l9_163=l9_164;
}
#endif
l9_151=l9_163;
}
#endif
vec4 l9_176;
if (PreviewEnabled==1)
{
vec4 l9_177;
if (((PreviewVertexSaved*1.0)!=0.0) ? true : false)
{
l9_177=PreviewVertexColor;
}
else
{
l9_177=vec4(0.0);
}
l9_176=l9_177;
}
else
{
l9_176=l9_151;
}
vec4 l9_178=sc_OutputMotionVectorIfNeeded(max(l9_176,vec4(0.0)));
vec4 l9_179=clamp(l9_178,vec4(0.0),vec4(1.0));
#if (sc_OITDepthBoundsPass)
{
#if (sc_OITDepthBoundsPass)
{
float l9_180=clamp(viewSpaceDepth()/1000.0,0.0,1.0);
sc_writeFragData0(vec4(max(0.0,1.0-(l9_180-0.0039215689)),min(1.0,l9_180+0.0039215689),0.0,0.0));
}
#endif
}
#else
{
#if (sc_OITDepthPrepass)
{
sc_writeFragData0(vec4(1.0));
}
#else
{
#if (sc_OITDepthGatherPass)
{
#if (sc_OITDepthGatherPass)
{
vec2 l9_181=sc_ScreenCoordsGlobalToView(l9_1);
#if (sc_OITMaxLayers4Plus1)
{
if ((gl_FragCoord.z-texture(sc_OITFrontDepthTexture,l9_181).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int l9_182=encodeDepth(viewSpaceDepth(),texture(sc_OITFilteredDepthBoundsTexture,l9_181).xy);
float l9_183=packValue(l9_182);
int l9_190=int(l9_179.w*255.0);
float l9_191=packValue(l9_190);
sc_writeFragData0(vec4(packValue(l9_182),packValue(l9_182),packValue(l9_182),packValue(l9_182)));
}
#endif
}
#else
{
#if (sc_OITCompositingPass)
{
#if (sc_OITCompositingPass)
{
vec2 l9_194=sc_ScreenCoordsGlobalToView(l9_1);
#if (sc_OITMaxLayers4Plus1)
{
if ((gl_FragCoord.z-texture(sc_OITFrontDepthTexture,l9_194).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int l9_195[8];
int l9_196[8];
int l9_197=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_197<8)
{
l9_195[l9_197]=0;
l9_196[l9_197]=0;
l9_197++;
continue;
}
else
{
break;
}
}
int l9_198;
#if (sc_OITMaxLayers8)
{
l9_198=2;
}
#else
{
l9_198=1;
}
#endif
int l9_199=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_199<l9_198)
{
vec4 l9_200;
vec4 l9_201;
vec4 l9_202;
if (l9_199==0)
{
l9_202=texture(sc_OITAlpha0,l9_194);
l9_201=texture(sc_OITDepthLow0,l9_194);
l9_200=texture(sc_OITDepthHigh0,l9_194);
}
else
{
l9_202=vec4(0.0);
l9_201=vec4(0.0);
l9_200=vec4(0.0);
}
vec4 l9_203;
vec4 l9_204;
vec4 l9_205;
if (l9_199==1)
{
l9_205=texture(sc_OITAlpha1,l9_194);
l9_204=texture(sc_OITDepthLow1,l9_194);
l9_203=texture(sc_OITDepthHigh1,l9_194);
}
else
{
l9_205=l9_202;
l9_204=l9_201;
l9_203=l9_200;
}
if (any(notEqual(l9_203,vec4(0.0)))||any(notEqual(l9_204,vec4(0.0))))
{
int l9_206[8]=l9_195;
unpackValues(l9_203.w,l9_199,l9_206);
unpackValues(l9_203.z,l9_199,l9_206);
unpackValues(l9_203.y,l9_199,l9_206);
unpackValues(l9_203.x,l9_199,l9_206);
unpackValues(l9_204.w,l9_199,l9_206);
unpackValues(l9_204.z,l9_199,l9_206);
unpackValues(l9_204.y,l9_199,l9_206);
unpackValues(l9_204.x,l9_199,l9_206);
int l9_215[8]=l9_196;
unpackValues(l9_205.w,l9_199,l9_215);
unpackValues(l9_205.z,l9_199,l9_215);
unpackValues(l9_205.y,l9_199,l9_215);
unpackValues(l9_205.x,l9_199,l9_215);
}
l9_199++;
continue;
}
else
{
break;
}
}
vec4 l9_220=texture(sc_OITFilteredDepthBoundsTexture,l9_194);
vec2 l9_221=l9_220.xy;
int l9_222;
#if (sc_SkinBonesCount>0)
{
l9_222=encodeDepth(((1.0-l9_220.x)*1000.0)+getDepthOrderingEpsilon(),l9_221);
}
#else
{
l9_222=0;
}
#endif
int l9_223=encodeDepth(viewSpaceDepth(),l9_221);
vec4 l9_224;
l9_224=l9_179*l9_179.w;
vec4 l9_225;
int l9_226=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_226<8)
{
int l9_227=l9_195[l9_226];
int l9_228=l9_223-l9_222;
bool l9_229=l9_227<l9_228;
bool l9_230;
if (l9_229)
{
l9_230=l9_195[l9_226]>0;
}
else
{
l9_230=l9_229;
}
if (l9_230)
{
vec3 l9_231=l9_224.xyz*(1.0-(float(l9_196[l9_226])/255.0));
l9_225=vec4(l9_231.x,l9_231.y,l9_231.z,l9_224.w);
}
else
{
l9_225=l9_224;
}
l9_224=l9_225;
l9_226++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(l9_224);
#if (sc_OITMaxLayersVisualizeLayerCount)
{
discard;
}
#endif
}
#endif
}
#else
{
#if (sc_OITFrontLayerPass)
{
#if (sc_OITFrontLayerPass)
{
if (abs(gl_FragCoord.z-texture(sc_OITFrontDepthTexture,sc_ScreenCoordsGlobalToView(l9_1)).x)>getFrontLayerZTestEpsilon())
{
discard;
}
sc_writeFragData0(l9_179);
}
#endif
}
#else
{
sc_writeFragData0(l9_178);
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
