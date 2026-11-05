#version 300 es
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
uniform vec4 sc_BoneMatrices[((sc_SkinBonesCount*3)+1)];
uniform mat3 sc_SkinBonesNormalMatrices[(sc_SkinBonesCount+1)];
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
sc_Vertex_t l9_0=sc_Vertex_t(position,normal,tangent.xyz,texture0,texture1);
sc_BlendVertex(l9_0);
sc_SkinVertex(l9_0);
sc_Vertex_t l9_1=l9_0;
#if (sc_RenderingSpace==3)
{
varPosAndMotion=vec4(vec3(0.0).x,vec3(0.0).y,vec3(0.0).z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_1.normal.x,l9_1.normal.y,l9_1.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_1.tangent.x,l9_1.tangent.y,l9_1.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==4)
{
varPosAndMotion=vec4(vec3(0.0).x,vec3(0.0).y,vec3(0.0).z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_1.normal.x,l9_1.normal.y,l9_1.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_1.tangent.x,l9_1.tangent.y,l9_1.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPosAndMotion=vec4(l9_1.position.x,l9_1.position.y,l9_1.position.z,varPosAndMotion.w);
varNormalAndMotion=vec4(l9_1.normal.x,l9_1.normal.y,l9_1.normal.z,varNormalAndMotion.w);
varTangent=vec4(l9_1.tangent.x,l9_1.tangent.y,l9_1.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
vec4 l9_2=sc_ModelMatrix*l9_1.position;
varPosAndMotion=vec4(l9_2.x,l9_2.y,l9_2.z,varPosAndMotion.w);
vec3 l9_3=sc_NormalMatrix*l9_1.normal;
varNormalAndMotion=vec4(l9_3.x,l9_3.y,l9_3.z,varNormalAndMotion.w);
vec3 l9_4=sc_NormalMatrix*l9_1.tangent;
varTangent=vec4(l9_4.x,l9_4.y,l9_4.z,varTangent.w);
}
#endif
}
#endif
}
#endif
}
#endif
varColor=color;
varPosAndMotion=vec4(varPosAndMotion.x,varPosAndMotion.y,varPosAndMotion.z,varPosAndMotion.w);
vec3 l9_5=normalize(varNormalAndMotion.xyz);
varNormalAndMotion=vec4(l9_5.x,l9_5.y,l9_5.z,varNormalAndMotion.w);
vec3 l9_6=normalize(varTangent.xyz);
varTangent=vec4(l9_6.x,l9_6.y,l9_6.z,varTangent.w);
varTangent.w=tangent.w;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
vec4 l9_7;
#if (sc_RenderingSpace==3)
{
l9_7=sc_ProjectionMatrixInverseArray[sc_GetStereoViewIndex()]*l9_1.position;
}
#else
{
vec4 l9_8;
#if (sc_RenderingSpace==2)
{
l9_8=sc_ViewMatrixArray[sc_GetStereoViewIndex()]*l9_1.position;
}
#else
{
vec4 l9_9;
#if (sc_RenderingSpace==1)
{
l9_9=(sc_ViewMatrixArray[sc_GetStereoViewIndex()]*sc_ModelMatrix)*l9_1.position;
}
#else
{
l9_9=l9_1.position;
}
#endif
l9_8=l9_9;
}
#endif
l9_7=l9_8;
}
#endif
varViewSpaceDepth=-l9_7.z;
}
#endif
vec4 l9_10;
#if (sc_RenderingSpace==3)
{
l9_10=l9_1.position;
}
#else
{
vec4 l9_11;
#if (sc_RenderingSpace==4)
{
l9_11=((sc_ViewMatrixArray[sc_GetStereoViewIndex()]*sc_ModelMatrix)*l9_1.position)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0);
}
#else
{
vec4 l9_12;
#if (sc_RenderingSpace==2)
{
l9_12=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
}
#else
{
vec4 l9_13;
#if (sc_RenderingSpace==1)
{
l9_13=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPosAndMotion.xyz,1.0);
}
#else
{
l9_13=vec4(0.0);
}
#endif
l9_12=l9_13;
}
#endif
l9_11=l9_12;
}
#endif
l9_10=l9_11;
}
#endif
varTex01=vec4(l9_1.texture0,l9_1.texture1);
#if (sc_ProjectiveShadowsReceiver)
{
vec4 l9_14;
#if (sc_RenderingSpace==1)
{
l9_14=sc_ModelMatrix*l9_1.position;
}
#else
{
l9_14=l9_1.position;
}
#endif
vec4 l9_15=sc_ProjectorMatrix*l9_14;
varShadowTex=((l9_15.xy/vec2(l9_15.w))*0.5)+vec2(0.5);
}
#endif
vec4 l9_16;
#if (sc_DepthBufferMode==1)
{
vec4 l9_17;
if (sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].w!=0.0)
{
vec4 l9_18=l9_10;
l9_18.z=((log2(max(sc_Camera.clipPlanes.x,1.0+l9_10.w))*(2.0/log2(sc_Camera.clipPlanes.y+1.0)))-1.0)*l9_10.w;
l9_17=l9_18;
}
else
{
l9_17=l9_10;
}
l9_16=l9_17;
}
#else
{
l9_16=l9_10;
}
#endif
vec4 l9_19;
#if (sc_TAAEnabled)
{
vec2 l9_20=l9_16.xy+(sc_TAAJitterOffset*l9_16.w);
l9_19=vec4(l9_20.x,l9_20.y,l9_16.z,l9_16.w);
}
#else
{
l9_19=l9_16;
}
#endif
sc_SetClipPosition(l9_19);
#if (sc_Voxelization)
{
sc_Vertex_t l9_21=l9_1;
sc_BlendVertex(l9_21);
sc_SkinVertex(l9_21);
int l9_22=sc_GetLocalInstanceIDInternal(sc_FallbackInstanceID);
int l9_23=int(voxelization_params_0.w);
vec4 l9_24=createVoxelOrthoMatrix(voxelization_params_frustum_lrbt.x,voxelization_params_frustum_lrbt.y,voxelization_params_frustum_lrbt.z,voxelization_params_frustum_lrbt.w,voxelization_params_frustum_nf.x,voxelization_params_frustum_nf.y)*vec4(((sc_ModelMatrixVoxelization*l9_21.position).xyz+vec3(float(l9_22%l9_23)*voxelization_params_0.y,float(l9_22/l9_23)*voxelization_params_0.y,(float(l9_22)*(voxelization_params_0.y/voxelization_params_0.z))+voxelization_params_frustum_nf.x))-voxelization_params_camera_pos,1.0);
l9_24.w=1.0;
varScreenPos=l9_24;
sc_SetClipPosition(l9_24*1.0);
}
#else
{
#if (sc_OutputBounds)
{
sc_Vertex_t l9_25=l9_1;
sc_BlendVertex(l9_25);
sc_SkinVertex(l9_25);
vec2 l9_26=((l9_25.position.xy/vec2(l9_25.position.w))*0.5)+vec2(0.5);
varTex01=vec4(l9_26.x,l9_26.y,varTex01.z,varTex01.w);
vec4 l9_27=sc_ModelMatrixVoxelization*l9_25.position;
vec3 l9_28=l9_27.xyz-voxelization_params_camera_pos;
varPosAndMotion=vec4(l9_28.x,l9_28.y,l9_28.z,varPosAndMotion.w);
vec3 l9_29=normalize(l9_25.normal);
varNormalAndMotion=vec4(l9_29.x,l9_29.y,l9_29.z,varNormalAndMotion.w);
vec4 l9_30=createVoxelOrthoMatrix(voxelization_params_frustum_lrbt.x,voxelization_params_frustum_lrbt.y,voxelization_params_frustum_lrbt.z,voxelization_params_frustum_lrbt.w,voxelization_params_frustum_nf.x,voxelization_params_frustum_nf.y)*vec4(l9_28.x,l9_28.y,l9_28.z,l9_27.w);
vec4 l9_31=vec4(l9_30.x,l9_30.y,l9_30.z,vec4(0.0).w);
l9_31.w=1.0;
varScreenPos=l9_31;
sc_SetClipPosition(l9_31*1.0);
}
#endif
}
#endif
vec4 l9_32=varPosAndMotion;
#if (sc_MotionVectorsPass)
{
vec4 l9_33=vec4(l9_32.xyz,1.0);
#if (sc_MotionVectorsPass)
{
vec4 l9_34=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*l9_33;
vec4 l9_35=sc_PrevFrameViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(((sc_PrevFrameModelMatrix*sc_ModelMatrixInverse)*l9_33).xyz,1.0);
vec2 l9_36=((l9_34.xy/vec2(l9_34.w)).xy-(l9_35.xy/vec2(l9_35.w)).xy)*0.5;
varPosAndMotion.w=l9_36.x;
varNormalAndMotion.w=l9_36.y;
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
vec3 SurfacePosition_WorldSpace;
vec3 VertexNormal_WorldSpace;
vec3 VertexTangent_WorldSpace;
vec3 VertexBinormal_WorldSpace;
vec2 Surface_UVCoord0;
vec2 Surface_UVCoord1;
vec2 gScreenCoord;
vec4 VertexColor;
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
#ifndef SC_GL_FRAGMENT_PRECISION_HIGH
#define SC_GL_FRAGMENT_PRECISION_HIGH 0
#elif SC_GL_FRAGMENT_PRECISION_HIGH==1
#undef SC_GL_FRAGMENT_PRECISION_HIGH
#define SC_GL_FRAGMENT_PRECISION_HIGH 1
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
#ifndef emissiveTextureHasSwappedViews
#define emissiveTextureHasSwappedViews 0
#elif emissiveTextureHasSwappedViews==1
#undef emissiveTextureHasSwappedViews
#define emissiveTextureHasSwappedViews 1
#endif
#ifndef normalTextureHasSwappedViews
#define normalTextureHasSwappedViews 0
#elif normalTextureHasSwappedViews==1
#undef normalTextureHasSwappedViews
#define normalTextureHasSwappedViews 1
#endif
#ifndef metallicRoughnessTextureHasSwappedViews
#define metallicRoughnessTextureHasSwappedViews 0
#elif metallicRoughnessTextureHasSwappedViews==1
#undef metallicRoughnessTextureHasSwappedViews
#define metallicRoughnessTextureHasSwappedViews 1
#endif
#ifndef transmissionTextureHasSwappedViews
#define transmissionTextureHasSwappedViews 0
#elif transmissionTextureHasSwappedViews==1
#undef transmissionTextureHasSwappedViews
#define transmissionTextureHasSwappedViews 1
#endif
#ifndef screenTextureHasSwappedViews
#define screenTextureHasSwappedViews 0
#elif screenTextureHasSwappedViews==1
#undef screenTextureHasSwappedViews
#define screenTextureHasSwappedViews 1
#endif
#ifndef sheenColorTextureHasSwappedViews
#define sheenColorTextureHasSwappedViews 0
#elif sheenColorTextureHasSwappedViews==1
#undef sheenColorTextureHasSwappedViews
#define sheenColorTextureHasSwappedViews 1
#endif
#ifndef sheenRoughnessTextureHasSwappedViews
#define sheenRoughnessTextureHasSwappedViews 0
#elif sheenRoughnessTextureHasSwappedViews==1
#undef sheenRoughnessTextureHasSwappedViews
#define sheenRoughnessTextureHasSwappedViews 1
#endif
#ifndef clearcoatTextureHasSwappedViews
#define clearcoatTextureHasSwappedViews 0
#elif clearcoatTextureHasSwappedViews==1
#undef clearcoatTextureHasSwappedViews
#define clearcoatTextureHasSwappedViews 1
#endif
#ifndef clearcoatRoughnessTextureHasSwappedViews
#define clearcoatRoughnessTextureHasSwappedViews 0
#elif clearcoatRoughnessTextureHasSwappedViews==1
#undef clearcoatRoughnessTextureHasSwappedViews
#define clearcoatRoughnessTextureHasSwappedViews 1
#endif
#ifndef clearcoatNormalTextureHasSwappedViews
#define clearcoatNormalTextureHasSwappedViews 0
#elif clearcoatNormalTextureHasSwappedViews==1
#undef clearcoatNormalTextureHasSwappedViews
#define clearcoatNormalTextureHasSwappedViews 1
#endif
#ifndef baseColorTextureHasSwappedViews
#define baseColorTextureHasSwappedViews 0
#elif baseColorTextureHasSwappedViews==1
#undef baseColorTextureHasSwappedViews
#define baseColorTextureHasSwappedViews 1
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
#ifndef emissiveTextureLayout
#define emissiveTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_emissiveTexture
#define SC_USE_UV_TRANSFORM_emissiveTexture 0
#elif SC_USE_UV_TRANSFORM_emissiveTexture==1
#undef SC_USE_UV_TRANSFORM_emissiveTexture
#define SC_USE_UV_TRANSFORM_emissiveTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_emissiveTexture
#define SC_SOFTWARE_WRAP_MODE_U_emissiveTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_emissiveTexture
#define SC_SOFTWARE_WRAP_MODE_V_emissiveTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_emissiveTexture
#define SC_USE_UV_MIN_MAX_emissiveTexture 0
#elif SC_USE_UV_MIN_MAX_emissiveTexture==1
#undef SC_USE_UV_MIN_MAX_emissiveTexture
#define SC_USE_UV_MIN_MAX_emissiveTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_emissiveTexture
#define SC_USE_CLAMP_TO_BORDER_emissiveTexture 0
#elif SC_USE_CLAMP_TO_BORDER_emissiveTexture==1
#undef SC_USE_CLAMP_TO_BORDER_emissiveTexture
#define SC_USE_CLAMP_TO_BORDER_emissiveTexture 1
#endif
#ifndef normalTextureLayout
#define normalTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_normalTexture
#define SC_USE_UV_TRANSFORM_normalTexture 0
#elif SC_USE_UV_TRANSFORM_normalTexture==1
#undef SC_USE_UV_TRANSFORM_normalTexture
#define SC_USE_UV_TRANSFORM_normalTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_normalTexture
#define SC_SOFTWARE_WRAP_MODE_U_normalTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_normalTexture
#define SC_SOFTWARE_WRAP_MODE_V_normalTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_normalTexture
#define SC_USE_UV_MIN_MAX_normalTexture 0
#elif SC_USE_UV_MIN_MAX_normalTexture==1
#undef SC_USE_UV_MIN_MAX_normalTexture
#define SC_USE_UV_MIN_MAX_normalTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_normalTexture
#define SC_USE_CLAMP_TO_BORDER_normalTexture 0
#elif SC_USE_CLAMP_TO_BORDER_normalTexture==1
#undef SC_USE_CLAMP_TO_BORDER_normalTexture
#define SC_USE_CLAMP_TO_BORDER_normalTexture 1
#endif
#ifndef metallicRoughnessTextureLayout
#define metallicRoughnessTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_metallicRoughnessTexture
#define SC_USE_UV_TRANSFORM_metallicRoughnessTexture 0
#elif SC_USE_UV_TRANSFORM_metallicRoughnessTexture==1
#undef SC_USE_UV_TRANSFORM_metallicRoughnessTexture
#define SC_USE_UV_TRANSFORM_metallicRoughnessTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture
#define SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture
#define SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_metallicRoughnessTexture
#define SC_USE_UV_MIN_MAX_metallicRoughnessTexture 0
#elif SC_USE_UV_MIN_MAX_metallicRoughnessTexture==1
#undef SC_USE_UV_MIN_MAX_metallicRoughnessTexture
#define SC_USE_UV_MIN_MAX_metallicRoughnessTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture
#define SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture 0
#elif SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture==1
#undef SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture
#define SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture 1
#endif
#ifndef transmissionTextureLayout
#define transmissionTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_transmissionTexture
#define SC_USE_UV_TRANSFORM_transmissionTexture 0
#elif SC_USE_UV_TRANSFORM_transmissionTexture==1
#undef SC_USE_UV_TRANSFORM_transmissionTexture
#define SC_USE_UV_TRANSFORM_transmissionTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_transmissionTexture
#define SC_SOFTWARE_WRAP_MODE_U_transmissionTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_transmissionTexture
#define SC_SOFTWARE_WRAP_MODE_V_transmissionTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_transmissionTexture
#define SC_USE_UV_MIN_MAX_transmissionTexture 0
#elif SC_USE_UV_MIN_MAX_transmissionTexture==1
#undef SC_USE_UV_MIN_MAX_transmissionTexture
#define SC_USE_UV_MIN_MAX_transmissionTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_transmissionTexture
#define SC_USE_CLAMP_TO_BORDER_transmissionTexture 0
#elif SC_USE_CLAMP_TO_BORDER_transmissionTexture==1
#undef SC_USE_CLAMP_TO_BORDER_transmissionTexture
#define SC_USE_CLAMP_TO_BORDER_transmissionTexture 1
#endif
#ifndef screenTextureLayout
#define screenTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_screenTexture
#define SC_USE_UV_TRANSFORM_screenTexture 0
#elif SC_USE_UV_TRANSFORM_screenTexture==1
#undef SC_USE_UV_TRANSFORM_screenTexture
#define SC_USE_UV_TRANSFORM_screenTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_screenTexture
#define SC_SOFTWARE_WRAP_MODE_U_screenTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_screenTexture
#define SC_SOFTWARE_WRAP_MODE_V_screenTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_screenTexture
#define SC_USE_UV_MIN_MAX_screenTexture 0
#elif SC_USE_UV_MIN_MAX_screenTexture==1
#undef SC_USE_UV_MIN_MAX_screenTexture
#define SC_USE_UV_MIN_MAX_screenTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_screenTexture
#define SC_USE_CLAMP_TO_BORDER_screenTexture 0
#elif SC_USE_CLAMP_TO_BORDER_screenTexture==1
#undef SC_USE_CLAMP_TO_BORDER_screenTexture
#define SC_USE_CLAMP_TO_BORDER_screenTexture 1
#endif
#ifndef sheenColorTextureLayout
#define sheenColorTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sheenColorTexture
#define SC_USE_UV_TRANSFORM_sheenColorTexture 0
#elif SC_USE_UV_TRANSFORM_sheenColorTexture==1
#undef SC_USE_UV_TRANSFORM_sheenColorTexture
#define SC_USE_UV_TRANSFORM_sheenColorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture
#define SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture
#define SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sheenColorTexture
#define SC_USE_UV_MIN_MAX_sheenColorTexture 0
#elif SC_USE_UV_MIN_MAX_sheenColorTexture==1
#undef SC_USE_UV_MIN_MAX_sheenColorTexture
#define SC_USE_UV_MIN_MAX_sheenColorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sheenColorTexture
#define SC_USE_CLAMP_TO_BORDER_sheenColorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sheenColorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sheenColorTexture
#define SC_USE_CLAMP_TO_BORDER_sheenColorTexture 1
#endif
#ifndef sheenRoughnessTextureLayout
#define sheenRoughnessTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_sheenRoughnessTexture
#define SC_USE_UV_TRANSFORM_sheenRoughnessTexture 0
#elif SC_USE_UV_TRANSFORM_sheenRoughnessTexture==1
#undef SC_USE_UV_TRANSFORM_sheenRoughnessTexture
#define SC_USE_UV_TRANSFORM_sheenRoughnessTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture
#define SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture
#define SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_sheenRoughnessTexture
#define SC_USE_UV_MIN_MAX_sheenRoughnessTexture 0
#elif SC_USE_UV_MIN_MAX_sheenRoughnessTexture==1
#undef SC_USE_UV_MIN_MAX_sheenRoughnessTexture
#define SC_USE_UV_MIN_MAX_sheenRoughnessTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture
#define SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture 0
#elif SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture==1
#undef SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture
#define SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture 1
#endif
#ifndef clearcoatTextureLayout
#define clearcoatTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_clearcoatTexture
#define SC_USE_UV_TRANSFORM_clearcoatTexture 0
#elif SC_USE_UV_TRANSFORM_clearcoatTexture==1
#undef SC_USE_UV_TRANSFORM_clearcoatTexture
#define SC_USE_UV_TRANSFORM_clearcoatTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture
#define SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture
#define SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_clearcoatTexture
#define SC_USE_UV_MIN_MAX_clearcoatTexture 0
#elif SC_USE_UV_MIN_MAX_clearcoatTexture==1
#undef SC_USE_UV_MIN_MAX_clearcoatTexture
#define SC_USE_UV_MIN_MAX_clearcoatTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_clearcoatTexture
#define SC_USE_CLAMP_TO_BORDER_clearcoatTexture 0
#elif SC_USE_CLAMP_TO_BORDER_clearcoatTexture==1
#undef SC_USE_CLAMP_TO_BORDER_clearcoatTexture
#define SC_USE_CLAMP_TO_BORDER_clearcoatTexture 1
#endif
#ifndef clearcoatRoughnessTextureLayout
#define clearcoatRoughnessTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture
#define SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture 0
#elif SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture==1
#undef SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture
#define SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture
#define SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture
#define SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture
#define SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture 0
#elif SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture==1
#undef SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture
#define SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture
#define SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture 0
#elif SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture==1
#undef SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture
#define SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture 1
#endif
#ifndef clearcoatNormalTextureLayout
#define clearcoatNormalTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_clearcoatNormalTexture
#define SC_USE_UV_TRANSFORM_clearcoatNormalTexture 0
#elif SC_USE_UV_TRANSFORM_clearcoatNormalTexture==1
#undef SC_USE_UV_TRANSFORM_clearcoatNormalTexture
#define SC_USE_UV_TRANSFORM_clearcoatNormalTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture
#define SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture
#define SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_clearcoatNormalTexture
#define SC_USE_UV_MIN_MAX_clearcoatNormalTexture 0
#elif SC_USE_UV_MIN_MAX_clearcoatNormalTexture==1
#undef SC_USE_UV_MIN_MAX_clearcoatNormalTexture
#define SC_USE_UV_MIN_MAX_clearcoatNormalTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture
#define SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture 0
#elif SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture==1
#undef SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture
#define SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture 1
#endif
struct sc_Camera_t
{
vec3 position;
float aspect;
vec2 clipPlanes;
};
#ifndef ENABLE_EMISSIVE
#define ENABLE_EMISSIVE 0
#elif ENABLE_EMISSIVE==1
#undef ENABLE_EMISSIVE
#define ENABLE_EMISSIVE 1
#endif
#ifndef ENABLE_NORMALMAP
#define ENABLE_NORMALMAP 0
#elif ENABLE_NORMALMAP==1
#undef ENABLE_NORMALMAP
#define ENABLE_NORMALMAP 1
#endif
#ifndef METALLIC_ROUGHNESS_TEX_SWIZZLE_RB
#define METALLIC_ROUGHNESS_TEX_SWIZZLE_RB 0
#elif METALLIC_ROUGHNESS_TEX_SWIZZLE_RB==1
#undef METALLIC_ROUGHNESS_TEX_SWIZZLE_RB
#define METALLIC_ROUGHNESS_TEX_SWIZZLE_RB 1
#endif
#ifndef ENABLE_METALLIC_ROUGHNESS_TEX
#define ENABLE_METALLIC_ROUGHNESS_TEX 0
#elif ENABLE_METALLIC_ROUGHNESS_TEX==1
#undef ENABLE_METALLIC_ROUGHNESS_TEX
#define ENABLE_METALLIC_ROUGHNESS_TEX 1
#endif
#ifndef ENABLE_TRANSMISSION
#define ENABLE_TRANSMISSION 0
#elif ENABLE_TRANSMISSION==1
#undef ENABLE_TRANSMISSION
#define ENABLE_TRANSMISSION 1
#endif
#ifndef ENABLE_TRANSMISSION_TEX
#define ENABLE_TRANSMISSION_TEX 0
#elif ENABLE_TRANSMISSION_TEX==1
#undef ENABLE_TRANSMISSION_TEX
#define ENABLE_TRANSMISSION_TEX 1
#endif
#ifndef ENABLE_SHEEN
#define ENABLE_SHEEN 0
#elif ENABLE_SHEEN==1
#undef ENABLE_SHEEN
#define ENABLE_SHEEN 1
#endif
#ifndef ENABLE_SHEEN_COLOR_TEX
#define ENABLE_SHEEN_COLOR_TEX 0
#elif ENABLE_SHEEN_COLOR_TEX==1
#undef ENABLE_SHEEN_COLOR_TEX
#define ENABLE_SHEEN_COLOR_TEX 1
#endif
#ifndef ENABLE_SHEEN_ROUGHNESS_TEX
#define ENABLE_SHEEN_ROUGHNESS_TEX 0
#elif ENABLE_SHEEN_ROUGHNESS_TEX==1
#undef ENABLE_SHEEN_ROUGHNESS_TEX
#define ENABLE_SHEEN_ROUGHNESS_TEX 1
#endif
#ifndef ENABLE_CLEARCOAT
#define ENABLE_CLEARCOAT 0
#elif ENABLE_CLEARCOAT==1
#undef ENABLE_CLEARCOAT
#define ENABLE_CLEARCOAT 1
#endif
#ifndef ENABLE_CLEARCOAT_TEX
#define ENABLE_CLEARCOAT_TEX 0
#elif ENABLE_CLEARCOAT_TEX==1
#undef ENABLE_CLEARCOAT_TEX
#define ENABLE_CLEARCOAT_TEX 1
#endif
#ifndef ENABLE_CLEARCOAT_ROUGHNESS_TEX
#define ENABLE_CLEARCOAT_ROUGHNESS_TEX 0
#elif ENABLE_CLEARCOAT_ROUGHNESS_TEX==1
#undef ENABLE_CLEARCOAT_ROUGHNESS_TEX
#define ENABLE_CLEARCOAT_ROUGHNESS_TEX 1
#endif
#ifndef ENABLE_CLEARCOAT_NORMAL_TEX
#define ENABLE_CLEARCOAT_NORMAL_TEX 0
#elif ENABLE_CLEARCOAT_NORMAL_TEX==1
#undef ENABLE_CLEARCOAT_NORMAL_TEX
#define ENABLE_CLEARCOAT_NORMAL_TEX 1
#endif
#ifndef baseColorTextureLayout
#define baseColorTextureLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_baseColorTexture
#define SC_USE_UV_TRANSFORM_baseColorTexture 0
#elif SC_USE_UV_TRANSFORM_baseColorTexture==1
#undef SC_USE_UV_TRANSFORM_baseColorTexture
#define SC_USE_UV_TRANSFORM_baseColorTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseColorTexture
#define SC_SOFTWARE_WRAP_MODE_U_baseColorTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseColorTexture
#define SC_SOFTWARE_WRAP_MODE_V_baseColorTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseColorTexture
#define SC_USE_UV_MIN_MAX_baseColorTexture 0
#elif SC_USE_UV_MIN_MAX_baseColorTexture==1
#undef SC_USE_UV_MIN_MAX_baseColorTexture
#define SC_USE_UV_MIN_MAX_baseColorTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseColorTexture
#define SC_USE_CLAMP_TO_BORDER_baseColorTexture 0
#elif SC_USE_CLAMP_TO_BORDER_baseColorTexture==1
#undef SC_USE_CLAMP_TO_BORDER_baseColorTexture
#define SC_USE_CLAMP_TO_BORDER_baseColorTexture 1
#endif
#ifndef ENABLE_VERTEX_COLOR_BASE
#define ENABLE_VERTEX_COLOR_BASE 0
#elif ENABLE_VERTEX_COLOR_BASE==1
#undef ENABLE_VERTEX_COLOR_BASE
#define ENABLE_VERTEX_COLOR_BASE 1
#endif
#ifndef ENABLE_BASE_TEX
#define ENABLE_BASE_TEX 0
#elif ENABLE_BASE_TEX==1
#undef ENABLE_BASE_TEX
#define ENABLE_BASE_TEX 1
#endif
#ifndef ENABLE_TEXTURE_TRANSFORM
#define ENABLE_TEXTURE_TRANSFORM 0
#elif ENABLE_TEXTURE_TRANSFORM==1
#undef ENABLE_TEXTURE_TRANSFORM
#define ENABLE_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_BASE_TEXTURE_TRANSFORM
#define ENABLE_BASE_TEXTURE_TRANSFORM 0
#elif ENABLE_BASE_TEXTURE_TRANSFORM==1
#undef ENABLE_BASE_TEXTURE_TRANSFORM
#define ENABLE_BASE_TEXTURE_TRANSFORM 1
#endif
#ifndef NODE_7_DROPLIST_ITEM
#define NODE_7_DROPLIST_ITEM 0
#endif
#ifndef ENABLE_EMISSIVE_TEXTURE_TRANSFORM
#define ENABLE_EMISSIVE_TEXTURE_TRANSFORM 0
#elif ENABLE_EMISSIVE_TEXTURE_TRANSFORM==1
#undef ENABLE_EMISSIVE_TEXTURE_TRANSFORM
#define ENABLE_EMISSIVE_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_NORMAL_TEXTURE_TRANSFORM
#define ENABLE_NORMAL_TEXTURE_TRANSFORM 0
#elif ENABLE_NORMAL_TEXTURE_TRANSFORM==1
#undef ENABLE_NORMAL_TEXTURE_TRANSFORM
#define ENABLE_NORMAL_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM
#define ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM 0
#elif ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM==1
#undef ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM
#define ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_TRANSMISSION_TEXTURE_TRANSFORM
#define ENABLE_TRANSMISSION_TEXTURE_TRANSFORM 0
#elif ENABLE_TRANSMISSION_TEXTURE_TRANSFORM==1
#undef ENABLE_TRANSMISSION_TEXTURE_TRANSFORM
#define ENABLE_TRANSMISSION_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM
#define ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM 0
#elif ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM==1
#undef ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM
#define ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM
#define ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM 0
#elif ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM==1
#undef ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM
#define ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_CLEARCOAT_TEXTURE_TRANSFORM
#define ENABLE_CLEARCOAT_TEXTURE_TRANSFORM 0
#elif ENABLE_CLEARCOAT_TEXTURE_TRANSFORM==1
#undef ENABLE_CLEARCOAT_TEXTURE_TRANSFORM
#define ENABLE_CLEARCOAT_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM
#define ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM 0
#elif ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM==1
#undef ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM
#define ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM 1
#endif
#ifndef ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM
#define ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM 0
#elif ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM==1
#undef ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM
#define ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM 1
#endif
#ifndef NODE_10_DROPLIST_ITEM
#define NODE_10_DROPLIST_ITEM 0
#endif
#ifndef NODE_8_DROPLIST_ITEM
#define NODE_8_DROPLIST_ITEM 0
#endif
#ifndef NODE_11_DROPLIST_ITEM
#define NODE_11_DROPLIST_ITEM 0
#endif
#ifndef Tweak_N30
#define Tweak_N30 0
#endif
#ifndef Tweak_N32
#define Tweak_N32 0
#endif
#ifndef Tweak_N37
#define Tweak_N37 0
#endif
#ifndef Tweak_N44
#define Tweak_N44 0
#endif
#ifndef Tweak_N60
#define Tweak_N60 0
#endif
#ifndef Tweak_N47
#define Tweak_N47 0
#endif
#ifndef ENABLE_GLTF_LIGHTING
#define ENABLE_GLTF_LIGHTING 0
#elif ENABLE_GLTF_LIGHTING==1
#undef ENABLE_GLTF_LIGHTING
#define ENABLE_GLTF_LIGHTING 1
#endif
#ifndef sc_DepthOnly
#define sc_DepthOnly 0
#elif sc_DepthOnly==1
#undef sc_DepthOnly
#define sc_DepthOnly 1
#endif
uniform vec4 sc_CurrentRenderTargetDims;
uniform float sc_ShadowDensity;
uniform vec4 sc_ShadowColor;
uniform ShadowMapParams_t sc_ShadowMapParams[1];
uniform sc_DirectionalLight_t sc_DirectionalLights[(sc_DirectionalLightsCount+1)];
uniform sc_PointLight_t sc_PointLights[(sc_PointLightsCount+1)];
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
uniform sc_AmbientLight_t sc_AmbientLights[(sc_AmbientLightsCount+1)];
uniform mat3 emissiveTextureTransform;
uniform vec4 emissiveTextureUvMinMax;
uniform vec4 emissiveTextureBorderColor;
uniform mat3 normalTextureTransform;
uniform vec4 normalTextureUvMinMax;
uniform vec4 normalTextureBorderColor;
uniform mat3 metallicRoughnessTextureTransform;
uniform vec4 metallicRoughnessTextureUvMinMax;
uniform vec4 metallicRoughnessTextureBorderColor;
uniform mat3 transmissionTextureTransform;
uniform vec4 transmissionTextureUvMinMax;
uniform vec4 transmissionTextureBorderColor;
uniform mat3 screenTextureTransform;
uniform vec4 screenTextureUvMinMax;
uniform vec4 screenTextureBorderColor;
uniform mat3 sheenColorTextureTransform;
uniform vec4 sheenColorTextureUvMinMax;
uniform vec4 sheenColorTextureBorderColor;
uniform mat3 sheenRoughnessTextureTransform;
uniform vec4 sheenRoughnessTextureUvMinMax;
uniform vec4 sheenRoughnessTextureBorderColor;
uniform mat3 clearcoatTextureTransform;
uniform vec4 clearcoatTextureUvMinMax;
uniform vec4 clearcoatTextureBorderColor;
uniform mat3 clearcoatRoughnessTextureTransform;
uniform vec4 clearcoatRoughnessTextureUvMinMax;
uniform vec4 clearcoatRoughnessTextureBorderColor;
uniform mat3 clearcoatNormalTextureTransform;
uniform vec4 clearcoatNormalTextureUvMinMax;
uniform vec4 clearcoatNormalTextureBorderColor;
uniform sc_Camera_t sc_Camera;
uniform vec3 emissiveFactor;
uniform float normalTextureScale;
uniform float metallicFactor;
uniform float roughnessFactor;
uniform float occlusionTextureStrength;
uniform float transmissionFactor;
uniform vec3 sheenColorFactor;
uniform float sheenRoughnessFactor;
uniform float clearcoatFactor;
uniform float clearcoatRoughnessFactor;
uniform mat3 baseColorTextureTransform;
uniform vec4 baseColorTextureUvMinMax;
uniform vec4 baseColorTextureBorderColor;
uniform vec4 baseColorFactor;
uniform vec2 baseColorTexture_offset;
uniform vec2 baseColorTexture_scale;
uniform float baseColorTexture_rotation;
uniform vec2 emissiveTexture_offset;
uniform vec2 emissiveTexture_scale;
uniform float emissiveTexture_rotation;
uniform vec2 normalTexture_offset;
uniform vec2 normalTexture_scale;
uniform float normalTexture_rotation;
uniform vec2 metallicRoughnessTexture_offset;
uniform vec2 metallicRoughnessTexture_scale;
uniform float metallicRoughnessTexture_rotation;
uniform vec2 transmissionTexture_offset;
uniform vec2 transmissionTexture_scale;
uniform float transmissionTexture_rotation;
uniform vec2 sheenColorTexture_offset;
uniform vec2 sheenColorTexture_scale;
uniform float sheenColorTexture_rotation;
uniform vec2 sheenRoughnessTexture_offset;
uniform vec2 sheenRoughnessTexture_scale;
uniform float sheenRoughnessTexture_rotation;
uniform vec2 clearcoatTexture_offset;
uniform vec2 clearcoatTexture_scale;
uniform float clearcoatTexture_rotation;
uniform vec2 clearcoatNormalTexture_offset;
uniform vec2 clearcoatNormalTexture_scale;
uniform float clearcoatNormalTexture_rotation;
uniform vec2 clearcoatRoughnessTexture_offset;
uniform vec2 clearcoatRoughnessTexture_scale;
uniform float clearcoatRoughnessTexture_rotation;
uniform mediump sampler2D baseColorTexture;
uniform mediump sampler2DArray baseColorTextureArrSC;
uniform mediump sampler2D emissiveTexture;
uniform mediump sampler2DArray emissiveTextureArrSC;
uniform mediump sampler2D normalTexture;
uniform mediump sampler2DArray normalTextureArrSC;
uniform mediump sampler2D metallicRoughnessTexture;
uniform mediump sampler2DArray metallicRoughnessTextureArrSC;
uniform mediump sampler2D screenTexture;
uniform mediump sampler2DArray screenTextureArrSC;
uniform mediump sampler2D transmissionTexture;
uniform mediump sampler2DArray transmissionTextureArrSC;
uniform mediump sampler2D sheenColorTexture;
uniform mediump sampler2DArray sheenColorTextureArrSC;
uniform mediump sampler2D sheenRoughnessTexture;
uniform mediump sampler2DArray sheenRoughnessTextureArrSC;
uniform mediump sampler2D sc_EnvmapSpecular;
uniform mediump sampler2DArray sc_EnvmapSpecularArrSC;
uniform mediump samplerCube sc_SpecularCubemap;
uniform mediump sampler2D clearcoatTexture;
uniform mediump sampler2DArray clearcoatTextureArrSC;
uniform mediump sampler2D clearcoatRoughnessTexture;
uniform mediump sampler2DArray clearcoatRoughnessTextureArrSC;
uniform mediump sampler2D clearcoatNormalTexture;
uniform mediump sampler2DArray clearcoatNormalTextureArrSC;
uniform mediump sampler2D sc_SSAOTexture;
uniform mediump sampler2D sc_ShadowTexture;
uniform mediump sampler2DShadow sc_ShadowMapTexture;
uniform mediump sampler2D sc_EnvmapDiffuse;
uniform mediump sampler2DArray sc_EnvmapDiffuseArrSC;
uniform mediump sampler2D sc_ScreenTexture;
uniform mediump sampler2DArray sc_ScreenTextureArrSC;
uniform mediump sampler2D intensityTexture;
uniform mediump sampler2DArray intensityTextureArrSC;
uniform mediump sampler2D sc_OITFrontDepthTexture;
uniform mediump sampler2D sc_OITDepthHigh0;
uniform mediump sampler2D sc_OITDepthLow0;
uniform mediump sampler2D sc_OITAlpha0;
uniform mediump sampler2D sc_OITDepthHigh1;
uniform mediump sampler2D sc_OITDepthLow1;
uniform mediump sampler2D sc_OITAlpha1;
uniform mediump sampler2D sc_OITFilteredDepthBoundsTexture;
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
in vec4 varTangent;
in vec4 varTex01;
in vec4 varColor;
in vec2 varScreenTexturePos;
ssGlobals tempGlobals;
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
void Node40_Bool_Parameter(out float Output,ssGlobals Globals)
{
#if (ENABLE_VERTEX_COLOR_BASE)
{
Output=1.001;
}
#else
{
Output=0.001;
}
#endif
Output-=0.001;
}
void Node121_Bool_Parameter(out float Output,ssGlobals Globals)
{
#if (ENABLE_BASE_TEX)
{
Output=1.001;
}
#else
{
Output=0.001;
}
#endif
Output-=0.001;
}
void Node48_Bool_Parameter(out float Output,ssGlobals Globals)
{
#if (ENABLE_TEXTURE_TRANSFORM)
{
Output=1.001;
}
#else
{
Output=0.001;
}
#endif
Output-=0.001;
}
void Node88_Bool_Parameter(out float Output,ssGlobals Globals)
{
#if (ENABLE_BASE_TEXTURE_TRANSFORM)
{
Output=1.001;
}
#else
{
Output=0.001;
}
#endif
Output-=0.001;
}
vec2 N35_getUV(int pickUV)
{
vec2 l9_0=tempGlobals.Surface_UVCoord0;
vec2 l9_1;
if (pickUV==0)
{
l9_1=tempGlobals.Surface_UVCoord0;
}
else
{
l9_1=l9_0;
}
vec2 l9_2;
if (pickUV==1)
{
l9_2=tempGlobals.Surface_UVCoord1;
}
else
{
l9_2=l9_1;
}
return l9_2;
}
vec2 N35_uvTransform(vec2 uvIn,vec2 offset,vec2 scale,float rotation)
{
return (((mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(offset.x,offset.y,1.0))*mat3(vec3(cos(rotation),sin(rotation),0.0),vec3(-sin(rotation),cos(rotation),0.0),vec3(0.0,0.0,1.0)))*mat3(vec3(scale.x,0.0,0.0),vec3(0.0,scale.y,0.0),vec3(0.0,0.0,1.0)))*vec3(uvIn,1.0)).xy;
}
int baseColorTextureGetStereoViewIndex()
{
int l9_0;
#if (baseColorTextureHasSwappedViews)
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
vec4 N35_BaseTexture_sample(vec2 coords)
{
vec4 l9_0;
#if (baseColorTextureLayout==2)
{
bool l9_1=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseColorTexture)!=0));
float l9_2=coords.x;
sc_SoftwareWrapEarly(l9_2,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).x);
float l9_3=l9_2;
float l9_4=coords.y;
sc_SoftwareWrapEarly(l9_4,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).y);
float l9_5=l9_4;
vec2 l9_6;
float l9_7;
#if (SC_USE_UV_MIN_MAX_baseColorTexture)
{
bool l9_8;
#if (SC_USE_CLAMP_TO_BORDER_baseColorTexture)
{
l9_8=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).x==3;
}
#else
{
l9_8=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture)!=0);
}
#endif
float l9_9=l9_3;
float l9_10=1.0;
sc_ClampUV(l9_9,baseColorTextureUvMinMax.x,baseColorTextureUvMinMax.z,l9_8,l9_10);
float l9_11=l9_9;
float l9_12=l9_10;
bool l9_13;
#if (SC_USE_CLAMP_TO_BORDER_baseColorTexture)
{
l9_13=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).y==3;
}
#else
{
l9_13=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture)!=0);
}
#endif
float l9_14=l9_5;
float l9_15=l9_12;
sc_ClampUV(l9_14,baseColorTextureUvMinMax.y,baseColorTextureUvMinMax.w,l9_13,l9_15);
l9_7=l9_15;
l9_6=vec2(l9_11,l9_14);
}
#else
{
l9_7=1.0;
l9_6=vec2(l9_3,l9_5);
}
#endif
vec2 l9_16=sc_TransformUV(l9_6,(int(SC_USE_UV_TRANSFORM_baseColorTexture)!=0),baseColorTextureTransform);
float l9_17=l9_16.x;
float l9_18=l9_7;
sc_SoftwareWrapLate(l9_17,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).x,l9_1,l9_18);
float l9_19=l9_16.y;
float l9_20=l9_18;
sc_SoftwareWrapLate(l9_19,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).y,l9_1,l9_20);
float l9_21=l9_20;
vec3 l9_22=sc_SamplingCoordsViewToGlobal(vec2(l9_17,l9_19),baseColorTextureLayout,baseColorTextureGetStereoViewIndex());
vec4 l9_23=texture(baseColorTextureArrSC,l9_22,0.0);
vec4 l9_24;
#if (SC_USE_CLAMP_TO_BORDER_baseColorTexture)
{
l9_24=mix(baseColorTextureBorderColor,l9_23,vec4(l9_21));
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
bool l9_25=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_baseColorTexture)!=0));
float l9_26=coords.x;
sc_SoftwareWrapEarly(l9_26,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).x);
float l9_27=l9_26;
float l9_28=coords.y;
sc_SoftwareWrapEarly(l9_28,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).y);
float l9_29=l9_28;
vec2 l9_30;
float l9_31;
#if (SC_USE_UV_MIN_MAX_baseColorTexture)
{
bool l9_32;
#if (SC_USE_CLAMP_TO_BORDER_baseColorTexture)
{
l9_32=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).x==3;
}
#else
{
l9_32=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture)!=0);
}
#endif
float l9_33=l9_27;
float l9_34=1.0;
sc_ClampUV(l9_33,baseColorTextureUvMinMax.x,baseColorTextureUvMinMax.z,l9_32,l9_34);
float l9_35=l9_33;
float l9_36=l9_34;
bool l9_37;
#if (SC_USE_CLAMP_TO_BORDER_baseColorTexture)
{
l9_37=ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).y==3;
}
#else
{
l9_37=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture)!=0);
}
#endif
float l9_38=l9_29;
float l9_39=l9_36;
sc_ClampUV(l9_38,baseColorTextureUvMinMax.y,baseColorTextureUvMinMax.w,l9_37,l9_39);
l9_31=l9_39;
l9_30=vec2(l9_35,l9_38);
}
#else
{
l9_31=1.0;
l9_30=vec2(l9_27,l9_29);
}
#endif
vec2 l9_40=sc_TransformUV(l9_30,(int(SC_USE_UV_TRANSFORM_baseColorTexture)!=0),baseColorTextureTransform);
float l9_41=l9_40.x;
float l9_42=l9_31;
sc_SoftwareWrapLate(l9_41,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).x,l9_25,l9_42);
float l9_43=l9_40.y;
float l9_44=l9_42;
sc_SoftwareWrapLate(l9_43,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture).y,l9_25,l9_44);
float l9_45=l9_44;
vec3 l9_46=sc_SamplingCoordsViewToGlobal(vec2(l9_41,l9_43),baseColorTextureLayout,baseColorTextureGetStereoViewIndex());
vec4 l9_47=texture(baseColorTexture,l9_46.xy,0.0);
vec4 l9_48;
#if (SC_USE_CLAMP_TO_BORDER_baseColorTexture)
{
l9_48=mix(baseColorTextureBorderColor,l9_47,vec4(l9_45));
}
#else
{
l9_48=l9_47;
}
#endif
l9_0=l9_48;
}
#endif
return l9_0;
}
vec4 ssSRGB_to_Linear(vec4 value)
{
vec4 l9_0;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
l9_0=vec4(pow(value.x,2.2),pow(value.y,2.2),pow(value.z,2.2),pow(value.w,2.2));
}
#else
{
l9_0=value*value;
}
#endif
return l9_0;
}
vec4 ssLinear_to_SRGB(vec4 value)
{
vec4 l9_0;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
l9_0=vec4(pow(value.x,0.45454544),pow(value.y,0.45454544),pow(value.z,0.45454544),pow(value.w,0.45454544));
}
#else
{
l9_0=sqrt(value);
}
#endif
return l9_0;
}
vec2 N3_getUV(int pickUV)
{
vec2 l9_0=tempGlobals.Surface_UVCoord0;
vec2 l9_1;
if (pickUV==0)
{
l9_1=tempGlobals.Surface_UVCoord0;
}
else
{
l9_1=l9_0;
}
vec2 l9_2;
if (pickUV==1)
{
l9_2=tempGlobals.Surface_UVCoord1;
}
else
{
l9_2=l9_1;
}
return l9_2;
}
vec2 N3_uvTransform(vec2 uvIn,vec2 offset,vec2 scale,float rotationAngle)
{
float l9_0=radians(rotationAngle);
float l9_1=cos(l9_0);
float l9_2=sin(l9_0);
return (((mat3(vec3(1.0,0.0,0.0),vec3(0.0,1.0,0.0),vec3(offset.x,offset.y,1.0))*mat3(vec3(l9_1,l9_2,0.0),vec3(-l9_2,l9_1,0.0),vec3(0.0,0.0,1.0)))*mat3(vec3(scale.x,0.0,0.0),vec3(0.0,scale.y,0.0),vec3(0.0,0.0,1.0)))*vec3(uvIn,1.0)).xy;
}
int emissiveTextureGetStereoViewIndex()
{
int l9_0;
#if (emissiveTextureHasSwappedViews)
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
vec3 ssSRGB_to_Linear(vec3 value)
{
vec3 l9_0;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
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
int normalTextureGetStereoViewIndex()
{
int l9_0;
#if (normalTextureHasSwappedViews)
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
int metallicRoughnessTextureGetStereoViewIndex()
{
int l9_0;
#if (metallicRoughnessTextureHasSwappedViews)
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
int screenTextureGetStereoViewIndex()
{
int l9_0;
#if (screenTextureHasSwappedViews)
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
int transmissionTextureGetStereoViewIndex()
{
int l9_0;
#if (transmissionTextureHasSwappedViews)
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
vec3 ssLinear_to_SRGB(vec3 value)
{
vec3 l9_0;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
l9_0=vec3(pow(value.x,0.45454544),pow(value.y,0.45454544),pow(value.z,0.45454544));
}
#else
{
l9_0=sqrt(value);
}
#endif
return l9_0;
}
int sheenColorTextureGetStereoViewIndex()
{
int l9_0;
#if (sheenColorTextureHasSwappedViews)
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
int sheenRoughnessTextureGetStereoViewIndex()
{
int l9_0;
#if (sheenRoughnessTextureHasSwappedViews)
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
float ssSRGB_to_Linear(float value)
{
float l9_0;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
l9_0=pow(value,2.2);
}
#else
{
l9_0=value*value;
}
#endif
return l9_0;
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
vec4 sc_EnvmapSpecularSampleViewLevel(vec2 uv,float level_)
{
vec4 l9_0;
#if (sc_EnvmapSpecularLayout==2)
{
l9_0=textureLod(sc_EnvmapSpecularArrSC,sc_SamplingCoordsViewToGlobal(uv,sc_EnvmapSpecularLayout,sc_EnvmapSpecularGetStereoViewIndex()),level_);
}
#else
{
l9_0=textureLod(sc_EnvmapSpecular,sc_SamplingCoordsViewToGlobal(uv,sc_EnvmapSpecularLayout,sc_EnvmapSpecularGetStereoViewIndex()).xy,level_);
}
#endif
return l9_0;
}
vec2 calcSeamlessPanoramicUvsForSampling(vec2 uv,vec2 topMipRes,float lod)
{
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
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
vec3 rotateEnvmapDir(vec3 R)
{
return vec3(((-R.z)*sc_EnvmapRotationSinCos.y)-(R.x*sc_EnvmapRotationSinCos.x),R.y,(R.z*sc_EnvmapRotationSinCos.x)-(R.x*sc_EnvmapRotationSinCos.y));
}
vec3 sampleSpecularEnvTextureLod(vec3 R,float lod)
{
vec4 l9_0;
#if (sc_HasSpecularCubemap)
{
l9_0=textureLod(sc_SpecularCubemap,rotateEnvmapDir(R),lod);
}
#else
{
vec2 l9_1=calcPanoramicTexCoordsFromDir(R,sc_EnvmapRotation.y);
vec4 l9_2;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
float l9_3=floor(lod);
float l9_4=ceil(lod);
l9_2=mix(sc_EnvmapSpecularSampleViewLevel(calcSeamlessPanoramicUvsForSampling(l9_1,sc_EnvmapSpecularSize.xy,l9_3),l9_3),sc_EnvmapSpecularSampleViewLevel(calcSeamlessPanoramicUvsForSampling(l9_1,sc_EnvmapSpecularSize.xy,l9_4),l9_4),vec4(lod-l9_3));
}
#else
{
l9_2=sc_EnvmapSpecularSampleViewLevel(l9_1,lod);
}
#endif
l9_0=l9_2;
}
#endif
return l9_0.xyz*(1.0/max(l9_0.w,0.0039215689));
}
float ssPow(float A,float B)
{
float l9_0;
if (A<=0.0)
{
l9_0=0.0;
}
else
{
l9_0=pow(A,B);
}
return l9_0;
}
float N3_charlieD(float roughness,float NdotH)
{
float l9_0=1.0/roughness;
return ((2.0+l9_0)*ssPow(1.0-(NdotH*NdotH),l9_0*0.5))/(2.0*3.1415927);
}
int clearcoatTextureGetStereoViewIndex()
{
int l9_0;
#if (clearcoatTextureHasSwappedViews)
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
int clearcoatRoughnessTextureGetStereoViewIndex()
{
int l9_0;
#if (clearcoatRoughnessTextureHasSwappedViews)
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
int clearcoatNormalTextureGetStereoViewIndex()
{
int l9_0;
#if (clearcoatNormalTextureHasSwappedViews)
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
void ngsAlphaTest(float opacity)
{
#if (sc_BlendMode==8)
{
if (opacity<alphaTestThreshold)
{
discard;
}
}
#endif
#if (ENABLE_STIPPLE_PATTERN_TEST)
{
if (opacity<((mod(dot(floor(mod(gl_FragCoord.xy,vec2(4.0))),vec2(4.0,1.0))*9.0,16.0)+1.0)/17.0))
{
discard;
}
}
#endif
}
SurfaceProperties defaultSurfaceProperties()
{
return SurfaceProperties(vec3(0.0),1.0,vec3(0.0),vec3(0.0),vec3(0.0),0.0,0.0,vec3(0.0),vec3(1.0),vec3(1.0),vec3(1.0),vec3(0.0));
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
void deriveAlbedoAndSpecColorFromSurfaceProperties(SurfaceProperties surfaceProperties,out vec3 albedo,out vec3 specColor)
{
specColor=mix(vec3(0.039999999),surfaceProperties.albedo*surfaceProperties.metallic,vec3(surfaceProperties.metallic));
albedo=mix(surfaceProperties.albedo*(1.0-surfaceProperties.metallic),vec3(0.0),vec3(surfaceProperties.metallic));
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
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
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
float computeDistanceAttenuation(float distanceToLightSqr,float distanceToLightInvSqr,float falloffRangeNegInvSqrSqr)
{
float l9_0;
if (falloffRangeNegInvSqrSqr!=0.0)
{
l9_0=max(10000.0+((distanceToLightSqr*distanceToLightSqr)*falloffRangeNegInvSqrSqr),0.0);
}
else
{
l9_0=10000.0;
}
return l9_0*distanceToLightInvSqr;
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
vec3 evaluateShadow()
{
vec3 l9_0;
#if (sc_ProjectiveShadowsReceiver)
{
vec2 l9_1=abs(varShadowTex-vec2(0.5));
vec4 l9_2=texture(sc_ShadowTexture,varShadowTex)*step(max(l9_1.x,l9_1.y),0.5);
l9_0=mix(vec3(1.0),mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_2.xyz,vec3(sc_ShadowColor.w)),vec3(l9_2.w*sc_ShadowDensity));
}
#else
{
l9_0=vec3(1.0);
}
#endif
return l9_0;
}
vec3 evaluateSh(vec3 L00,vec3 L1_1,vec3 L10,vec3 L11,vec3 L2_2,vec3 L2_1,vec3 L20,vec3 L21,vec3 L22,vec3 n)
{
return ((((((L22*0.42904299)*((n.x*n.x)-(n.y*n.y)))+((L20*0.74312502)*(n.z*n.z)))+(L00*0.88622701))-(L20*0.24770799))+((((L2_2*(n.x*n.y))+(L21*(n.x*n.z)))+(L2_1*(n.y*n.z)))*0.85808599))+((((L11*n.x)+(L1_1*n.y))+(L10*n.z))*1.0233279);
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
vec4 sc_EnvmapDiffuseSampleViewBias(vec2 uv,float bias)
{
vec4 l9_0;
#if (sc_EnvmapDiffuseLayout==2)
{
l9_0=texture(sc_EnvmapDiffuseArrSC,sc_SamplingCoordsViewToGlobal(uv,sc_EnvmapDiffuseLayout,sc_EnvmapDiffuseGetStereoViewIndex()),bias);
}
#else
{
l9_0=texture(sc_EnvmapDiffuse,sc_SamplingCoordsViewToGlobal(uv,sc_EnvmapDiffuseLayout,sc_EnvmapDiffuseGetStereoViewIndex()).xy,bias);
}
#endif
return l9_0;
}
vec4 sampleDiffuseCubemap3Tap(vec3 N)
{
N=rotateEnvmapDir(N);
vec3 l9_0;
if (abs(N.z)<0.99000001)
{
l9_0=vec3(-N.y,N.x,0.0);
}
else
{
l9_0=vec3(0.0,-N.z,N.y);
}
vec3 l9_1=normalize(l9_0);
vec3 l9_2=l9_1*(-0.5);
vec3 l9_3=cross(N,l9_1)*0.86602539;
return ((textureLod(sc_SpecularCubemap,N+(((l9_1*1.0)+vec3(0.0))*0.18000001),4.5)+textureLod(sc_SpecularCubemap,N+((l9_2+l9_3)*0.18000001),4.5))+textureLod(sc_SpecularCubemap,N+((l9_2-l9_3)*0.18000001),4.5))*0.33333334;
}
vec3 sampleDiffuseEnvmap(vec3 N)
{
vec4 l9_0;
#if (sc_EnvLightMode==sc_AmbientLightMode_FromCamera)
{
vec2 l9_1=calcPanoramicTexCoordsFromDir(N,sc_EnvmapRotation.y);
vec2 l9_2;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
l9_2=calcSeamlessPanoramicUvsForSampling(l9_1,sc_EnvmapSpecularSize.xy,5.0);
}
#else
{
l9_2=l9_1;
}
#endif
l9_0=sc_EnvmapSpecularSampleViewBias(l9_2,13.0);
}
#else
{
vec4 l9_3;
#if (sc_HasSpecularCubemap)
{
l9_3=sampleDiffuseCubemap3Tap(N);
}
#else
{
vec2 l9_4=calcPanoramicTexCoordsFromDir(N,sc_EnvmapRotation.y);
vec4 l9_5;
#if (sc_HasDiffuseEnvmap)
{
l9_5=sc_EnvmapDiffuseSampleViewBias(calcSeamlessPanoramicUvsForSampling(l9_4,sc_EnvmapDiffuseSize.xy,0.0),-13.0);
}
#else
{
l9_5=sc_EnvmapSpecularSampleViewBias(l9_4,13.0);
}
#endif
l9_3=l9_5;
}
#endif
l9_0=l9_3;
}
#endif
return (l9_0.xyz*(1.0/max(l9_0.w,0.0039215689)))*sc_EnvmapExposure;
}
vec3 DiffuseTermSG(sc_SphericalGaussianLight_t lightingLobe,vec3 normal)
{
vec3 l9_0=lightingLobe.axis;
vec3 l9_1=normal;
float l9_2=dot(l9_0,l9_1);
float l9_3=lightingLobe.sharpness;
float l9_4=exp(-l9_3);
float l9_5=l9_4*l9_4;
float l9_6=1.0/l9_3;
float l9_7=(1.0+(2.0*l9_5))-l9_6;
float l9_8=sqrt(1.0-l9_7);
float l9_9=0.36000001*l9_2;
float l9_10=(1.0/(4.0*0.36000001))*l9_8;
float l9_11=l9_9+l9_10;
float l9_12;
if (step(abs(l9_9),l9_10)>0.5)
{
l9_12=(l9_11*l9_11)/l9_8;
}
else
{
l9_12=clamp(l9_2,0.0,1.0);
}
return (((lightingLobe.color/vec3(lightingLobe.sharpness))*6.2831855)*((l9_7*l9_12)+(((l9_4-l9_5)*l9_6)-l9_5)))/vec3(3.1415927);
}
vec3 calculateLightEstimationDiffuse(vec3 N)
{
vec3 l9_0;
l9_0=sc_LightEstimationData.ambientLight;
sc_SphericalGaussianLight_t param;
vec3 param_1;
int l9_1=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1<sc_LightEstimationSGCount)
{
l9_0+=DiffuseTermSG(sc_LightEstimationData.sg[l9_1],N);
l9_1++;
continue;
}
else
{
break;
}
}
return l9_0;
}
vec3 calculateDiffuseIrradiance(vec3 N)
{
vec3 l9_0;
#if ((sc_EnvLightMode==sc_AmbientLightMode_EnvironmentMap)||(sc_EnvLightMode==sc_AmbientLightMode_FromCamera))
{
l9_0=sampleDiffuseEnvmap(N);
}
#else
{
vec3 l9_1;
#if (sc_EnvLightMode==sc_AmbientLightMode_SphericalHarmonics)
{
l9_1=evaluateSh(sc_Sh[0],sc_Sh[1],sc_Sh[2],sc_Sh[3],sc_Sh[4],sc_Sh[5],sc_Sh[6],sc_Sh[7],sc_Sh[8],-N)*sc_ShIntensity;
}
#else
{
l9_1=vec3(0.0);
}
#endif
l9_0=l9_1;
}
#endif
vec3 l9_2;
#if (sc_AmbientLightsCount>0)
{
vec3 l9_3;
#if (sc_AmbientLightMode0==sc_AmbientLightMode_Constant)
{
l9_3=l9_0+(sc_AmbientLights[0].color*sc_AmbientLights[0].intensity);
}
#else
{
vec3 l9_4=l9_0;
l9_4.x=l9_0.x+(1e-06*sc_AmbientLights[0].color.x);
l9_3=l9_4;
}
#endif
l9_2=l9_3;
}
#else
{
l9_2=l9_0;
}
#endif
vec3 l9_5;
#if (sc_AmbientLightsCount>1)
{
vec3 l9_6;
#if (sc_AmbientLightMode1==sc_AmbientLightMode_Constant)
{
l9_6=l9_2+(sc_AmbientLights[1].color*sc_AmbientLights[1].intensity);
}
#else
{
vec3 l9_7=l9_2;
l9_7.x=l9_2.x+(1e-06*sc_AmbientLights[1].color.x);
l9_6=l9_7;
}
#endif
l9_5=l9_6;
}
#else
{
l9_5=l9_2;
}
#endif
vec3 l9_8;
#if (sc_AmbientLightsCount>2)
{
vec3 l9_9;
#if (sc_AmbientLightMode2==sc_AmbientLightMode_Constant)
{
l9_9=l9_5+(sc_AmbientLights[2].color*sc_AmbientLights[2].intensity);
}
#else
{
vec3 l9_10=l9_5;
l9_10.x=l9_5.x+(1e-06*sc_AmbientLights[2].color.x);
l9_9=l9_10;
}
#endif
l9_8=l9_9;
}
#else
{
l9_8=l9_5;
}
#endif
vec3 l9_11;
#if (sc_LightEstimation)
{
l9_11=l9_8+calculateLightEstimationDiffuse(N);
}
#else
{
l9_11=l9_8;
}
#endif
return l9_11;
}
vec3 getSpecularDominantDir(vec3 N,vec3 R,float roughness)
{
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
return normalize(mix(R,N,vec3((roughness*roughness)*roughness)));
}
#else
{
return R;
}
#endif
}
vec2 envBRDFApproxSub(float roughness,float NdotV)
{
vec4 l9_0=(vec4(-1.0,-0.0275,-0.57200003,0.022)*roughness)+vec4(1.0,0.0425,1.04,-0.039999999);
float l9_1=l9_0.x;
return (vec2(-1.04,1.04)*((min(l9_1*l9_1,exp2((-9.2799997)*NdotV))*l9_1)+l9_0.y))+l9_0.zw;
}
vec3 envBRDFApprox(SurfaceProperties surfaceProperties,float NdotV)
{
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
vec2 l9_0=envBRDFApproxSub(surfaceProperties.roughness,NdotV);
return max((surfaceProperties.specColor*l9_0.x)+vec3(l9_0.y),vec3(0.0));
}
#else
{
return fresnelSchlickSub(NdotV,surfaceProperties.specColor,max(vec3(1.0-surfaceProperties.roughness),surfaceProperties.specColor));
}
#endif
}
vec3 calculateIndirectSpecularEnvmap(SurfaceProperties surfaceProperties,vec3 V)
{
return (sampleSpecularEnvTextureLod(getSpecularDominantDir(surfaceProperties.normal,reflect(-V,surfaceProperties.normal),surfaceProperties.roughness),clamp(pow(surfaceProperties.roughness,0.66666669),0.0,1.0)*5.0)*sc_EnvmapExposure)*envBRDFApprox(surfaceProperties,abs(dot(surfaceProperties.normal,V)));
}
sc_SphericalGaussianLight_t DistributionTermSG(vec3 direction,float roughness)
{
float l9_0=roughness*roughness;
return sc_SphericalGaussianLight_t(vec3(1.0/(3.1415927*l9_0)),2.0/l9_0,direction);
}
sc_SphericalGaussianLight_t WarpDistributionSG(sc_SphericalGaussianLight_t ndf,vec3 view)
{
return sc_SphericalGaussianLight_t(ndf.color,ndf.sharpness/(4.0*max(dot(ndf.axis,view),9.9999997e-05)),reflect(-view,ndf.axis));
}
vec3 SGInnerProduct(sc_SphericalGaussianLight_t lhs,sc_SphericalGaussianLight_t rhs)
{
float l9_0=length((lhs.axis*lhs.sharpness)+(rhs.axis*rhs.sharpness));
return ((((lhs.color*exp((l9_0-lhs.sharpness)-rhs.sharpness))*rhs.color)*6.2831855)*(1.0-exp((-2.0)*l9_0)))/vec3(l9_0);
}
vec3 SpecularTermSG(sc_SphericalGaussianLight_t light,vec3 normal,float roughness,vec3 view,vec3 specColor)
{
sc_SphericalGaussianLight_t l9_0=WarpDistributionSG(DistributionTermSG(normal,roughness),view);
vec3 l9_1=l9_0.axis;
float l9_2=roughness*roughness;
float l9_3=clamp(dot(normal,l9_1),0.0,1.0);
float l9_4=clamp(dot(normal,view),0.0,1.0);
float l9_5=1.0-l9_2;
return ((SGInnerProduct(l9_0,light)*((1.0/(l9_3+sqrt(l9_2+((l9_5*l9_3)*l9_3))))*(1.0/(l9_4+sqrt(l9_2+((l9_5*l9_4)*l9_4))))))*(specColor+((vec3(1.0)-specColor)*pow(1.0-clamp(dot(l9_1,normalize(l9_1+view)),0.0,1.0),5.0))))*l9_3;
}
vec3 calculateLightEstimationSpecular(SurfaceProperties surfaceProperties,vec3 V)
{
float l9_0=surfaceProperties.roughness;
float l9_1=surfaceProperties.roughness;
vec3 l9_2;
l9_2=sc_LightEstimationData.ambientLight*surfaceProperties.specColor;
sc_SphericalGaussianLight_t param;
vec3 param_1;
float param_2;
vec3 param_3;
vec3 param_4;
int l9_3=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_3<sc_LightEstimationSGCount)
{
l9_2+=SpecularTermSG(sc_LightEstimationData.sg[l9_3],surfaceProperties.normal,clamp(l9_0*l9_1,0.0099999998,1.0),V,surfaceProperties.specColor);
l9_3++;
continue;
}
else
{
break;
}
}
return l9_2;
}
vec3 calculateIndirectSpecular(SurfaceProperties surfaceProperties,vec3 V)
{
vec3 l9_0;
#if ((sc_EnvLightMode==sc_AmbientLightMode_EnvironmentMap)||(sc_EnvLightMode==sc_AmbientLightMode_FromCamera))
{
l9_0=vec3(0.0)+calculateIndirectSpecularEnvmap(surfaceProperties,V);
}
#else
{
l9_0=vec3(0.0);
}
#endif
vec3 l9_1;
#if (sc_LightEstimation)
{
l9_1=l9_0+calculateLightEstimationSpecular(surfaceProperties,V);
}
#else
{
l9_1=l9_0;
}
#endif
return l9_1;
}
LightingComponents evaluateLighting(SurfaceProperties surfaceProperties)
{
vec3 l9_0=surfaceProperties.viewDirWS;
vec4 bakedShadows=vec4(surfaceProperties.bakedShadows,1.0);
vec3 l9_1;
vec3 l9_2;
vec3 l9_3;
vec3 l9_4;
int l9_5;
vec3 l9_6;
vec3 l9_7;
#if (sc_DirectionalLightsCount>0)
{
vec3 l9_8;
vec3 l9_9;
vec3 l9_10;
vec3 l9_11;
int l9_12;
vec3 l9_13;
vec3 l9_14;
l9_14=vec3(1.0);
l9_13=vec3(0.0);
l9_12=0;
l9_11=vec3(0.0);
l9_10=vec3(0.0);
l9_9=vec3(0.0);
l9_8=vec3(0.0);
int l9_15;
vec3 l9_16;
vec3 l9_17;
vec3 l9_18;
vec3 l9_19;
vec3 l9_20;
vec3 l9_21;
int l9_22=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_22<sc_DirectionalLightsCount)
{
float l9_23=bakedShadows[(l9_12<3) ? l9_12 : 3];
vec3 l9_24;
#if (sc_ShadowMapReceiver)
{
vec3 l9_25;
if (sc_ShadowMapParams[sc_DirectionalLights[l9_22].shadowMapParamsIndex].params[1].w>0.0)
{
l9_25=mix(sc_ShadowMapParams[sc_DirectionalLights[l9_22].shadowMapParamsIndex].params[0].xyz,sc_DirectionalLights[l9_22].color.xyz,vec3(evaluateDirectionalShadowMap(l9_22)));
}
else
{
l9_25=sc_DirectionalLights[l9_22].color.xyz;
}
l9_24=l9_25;
}
#else
{
l9_24=sc_DirectionalLights[l9_22].color.xyz;
}
#endif
l9_15=l9_12+1;
LightingComponents l9_26=accumulateLight(LightingComponents(l9_8,l9_9,l9_14,l9_13,l9_11,l9_10),LightProperties(sc_DirectionalLights[l9_22].direction,l9_24,sc_DirectionalLights[l9_22].color.w*l9_23),surfaceProperties,l9_0);
l9_16=l9_26.directDiffuse;
l9_17=l9_26.directSpecular;
l9_18=l9_26.indirectDiffuse;
l9_19=l9_26.indirectSpecular;
l9_20=l9_26.emitted;
l9_21=l9_26.transmitted;
l9_14=l9_18;
l9_13=l9_19;
l9_12=l9_15;
l9_11=l9_20;
l9_10=l9_21;
l9_9=l9_17;
l9_8=l9_16;
l9_22++;
continue;
}
else
{
break;
}
}
l9_7=l9_14;
l9_6=l9_13;
l9_5=l9_12;
l9_4=l9_11;
l9_3=l9_10;
l9_2=l9_9;
l9_1=l9_8;
}
#else
{
l9_7=vec3(1.0);
l9_6=vec3(0.0);
l9_5=0;
l9_4=vec3(0.0);
l9_3=vec3(0.0);
l9_2=vec3(0.0);
l9_1=vec3(0.0);
}
#endif
vec3 l9_27;
vec3 l9_28;
vec3 l9_29;
vec3 l9_30;
#if (sc_PointLightsCount>0)
{
vec3 l9_31;
vec3 l9_32;
vec3 l9_33;
vec3 l9_34;
vec3 l9_35;
vec3 l9_36;
l9_36=l9_7;
l9_35=l9_6;
l9_34=l9_4;
l9_33=l9_3;
l9_32=l9_2;
l9_31=l9_1;
int l9_37;
vec3 l9_38;
vec3 l9_39;
vec3 l9_40;
vec3 l9_41;
vec3 l9_42;
vec3 l9_43;
int l9_44=0;
int l9_45=l9_5;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_44<sc_PointLightsCount)
{
vec3 l9_46=surfaceProperties.positionWS;
vec3 l9_47=sc_PointLights[l9_44].position-l9_46;
float l9_48=dot(l9_47,l9_47);
bool l9_49=sc_PointLights[l9_44].falloffRangeSqr>0.0;
if (!(l9_49&&(l9_48>sc_PointLights[l9_44].falloffRangeSqr)))
{
float l9_50=inversesqrt(l9_48);
vec3 l9_51=l9_47*l9_50;
float l9_52=bakedShadows[(l9_45<3) ? l9_45 : 3];
float l9_53=clamp((dot(l9_51,sc_PointLights[l9_44].direction)*sc_PointLights[l9_44].angleScale)+sc_PointLights[l9_44].angleOffset,0.0,1.0);
float l9_54=(sc_PointLights[l9_44].color.w*l9_52)*(l9_53*l9_53);
float l9_55;
if (l9_49)
{
l9_55=l9_54*computeDistanceAttenuation(l9_48,l9_50*l9_50,sc_PointLights[l9_44].falloffRangeNegInvSqrSqr);
}
else
{
l9_55=l9_54;
}
vec3 l9_56;
#if (sc_ShadowMapReceiver)
{
vec3 l9_57;
if (sc_ShadowMapParams[sc_PointLights[l9_44].shadowMapParamsIndex].params[1].w>0.0)
{
l9_57=mix(sc_ShadowMapParams[sc_PointLights[l9_44].shadowMapParamsIndex].params[0].xyz,sc_PointLights[l9_44].color.xyz,vec3(evaluatePointShadowMap(l9_44,-l9_51)));
}
else
{
l9_57=sc_PointLights[l9_44].color.xyz;
}
l9_56=l9_57;
}
#else
{
l9_56=sc_PointLights[l9_44].color.xyz;
}
#endif
LightingComponents l9_58=accumulateLight(LightingComponents(l9_31,l9_32,l9_36,l9_35,l9_34,l9_33),LightProperties(l9_51,l9_56,l9_55),surfaceProperties,l9_0);
l9_43=l9_58.indirectDiffuse;
l9_42=l9_58.indirectSpecular;
l9_41=l9_58.emitted;
l9_40=l9_58.transmitted;
l9_39=l9_58.directSpecular;
l9_38=l9_58.directDiffuse;
}
else
{
l9_43=l9_36;
l9_42=l9_35;
l9_41=l9_34;
l9_40=l9_33;
l9_39=l9_32;
l9_38=l9_31;
}
l9_37=l9_45+1;
l9_36=l9_43;
l9_35=l9_42;
l9_45=l9_37;
l9_34=l9_41;
l9_33=l9_40;
l9_32=l9_39;
l9_31=l9_38;
l9_44++;
continue;
}
else
{
break;
}
}
l9_30=l9_34;
l9_29=l9_33;
l9_28=l9_32;
l9_27=l9_31;
}
#else
{
l9_30=l9_4;
l9_29=l9_3;
l9_28=l9_2;
l9_27=l9_1;
}
#endif
vec3 l9_59;
vec3 l9_60;
#if (sc_ProjectiveShadowsReceiver)
{
vec3 l9_61=evaluateShadow();
l9_60=l9_27*l9_61;
l9_59=l9_28*l9_61;
}
#else
{
l9_60=l9_27;
l9_59=l9_28;
}
#endif
return LightingComponents(l9_60,l9_59,calculateDiffuseIrradiance(surfaceProperties.normal),calculateIndirectSpecular(surfaceProperties,l9_0),l9_30,l9_29);
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
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
return pow(x,2.2);
}
#else
{
return x*x;
}
#endif
}
vec3 combineSurfacePropertiesWithLighting(SurfaceProperties surfaceProperties,LightingComponents lighting,bool enablePremultipliedAlpha)
{
vec3 l9_0=surfaceProperties.albedo;
vec3 l9_1=lighting.directDiffuse;
vec3 l9_2=lighting.indirectDiffuse;
vec3 l9_3=surfaceProperties.ao;
vec3 l9_4=l9_0*(l9_1+(l9_2*l9_3));
vec3 l9_5=lighting.directSpecular;
vec3 l9_6=lighting.indirectSpecular;
vec3 l9_7=surfaceProperties.specularAo;
vec3 l9_8=surfaceProperties.emissive;
vec3 l9_9=lighting.transmitted;
vec3 l9_10;
if (enablePremultipliedAlpha)
{
l9_10=l9_4*srgbToLinear(surfaceProperties.opacity);
}
else
{
l9_10=l9_4;
}
return ((l9_10+(l9_5+(l9_6*l9_7)))+l9_8)+l9_9;
}
vec3 linearToneMapping(vec3 x)
{
return (x*((x*1.8)+vec3(1.4)))/((x*((x*1.8)+vec3(0.5)))+vec3(1.5));
}
float linearToSrgb(float x)
{
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
return pow(x,0.45454547);
}
#else
{
return sqrt(x);
}
#endif
}
vec4 ngsCalculateLighting(vec3 albedo,float opacity,vec3 normal,vec3 position,vec3 viewDir,vec3 emissive,float metallic,float roughness,vec3 ao,vec3 specularAO)
{
SurfaceProperties l9_0=defaultSurfaceProperties();
vec3 l9_1=l9_0.bakedShadows;
float l9_2=opacity;
vec3 l9_3=ssSRGB_to_Linear(albedo);
vec3 l9_4=normal;
vec3 l9_5=normalize(l9_4);
vec3 l9_6=position;
vec3 l9_7=viewDir;
vec3 l9_8=ssSRGB_to_Linear(emissive);
float l9_9=metallic;
float l9_10=roughness;
vec3 l9_11=ao;
vec3 l9_12=specularAO;
vec3 l9_13;
#if (sc_SSAOEnabled)
{
l9_13=evaluateSSAO(l9_6);
}
#else
{
l9_13=l9_11;
}
#endif
vec3 l9_14;
vec3 l9_15;
deriveAlbedoAndSpecColorFromSurfaceProperties(SurfaceProperties(l9_3,l9_2,l9_5,l9_6,l9_7,l9_9,l9_10,l9_8,l9_13,l9_12,l9_1,l9_0.specColor),l9_14,l9_15);
vec3 l9_16=l9_14;
vec3 l9_17=l9_15;
LightingComponents l9_18=evaluateLighting(SurfaceProperties(l9_16,l9_2,l9_5,l9_6,l9_7,l9_9,l9_10,l9_8,l9_13,l9_12,l9_1,l9_17));
float l9_19;
vec3 l9_20;
vec3 l9_21;
vec3 l9_22;
#if (sc_BlendMode==9)
{
l9_22=vec3(0.0);
l9_21=vec3(0.0);
l9_20=ssSRGB_to_Linear(sc_GetFramebufferColor().xyz)*mix(vec3(1.0),l9_16,vec3(l9_2));
l9_19=1.0;
}
#else
{
l9_22=l9_18.directDiffuse;
l9_21=l9_18.indirectDiffuse;
l9_20=l9_18.transmitted;
l9_19=l9_2;
}
#endif
bool l9_23;
#if (sc_BlendMode==4)
{
l9_23=true;
}
#else
{
l9_23=false;
}
#endif
vec3 l9_24=combineSurfacePropertiesWithLighting(SurfaceProperties(l9_16,l9_19,l9_5,l9_6,l9_7,l9_9,l9_10,l9_8,l9_13,l9_12,l9_1,l9_17),LightingComponents(l9_22,l9_18.directSpecular,l9_21,l9_18.indirectSpecular,l9_18.emitted,l9_20),l9_23);
float l9_25=l9_24.x;
vec4 l9_26=vec4(l9_25,l9_24.yz,l9_19);
vec4 l9_27;
#if (sc_IsEditor)
{
vec4 l9_28=l9_26;
l9_28.x=l9_25+((l9_13.x*l9_12.x)*9.9999997e-06);
l9_27=l9_28;
}
#else
{
l9_27=l9_26;
}
#endif
vec4 l9_29;
#if (sc_BlendMode!=1)
{
vec3 l9_30=linearToneMapping(l9_27.xyz);
l9_29=vec4(l9_30.x,l9_30.y,l9_30.z,l9_27.w);
}
#else
{
l9_29=l9_27;
}
#endif
vec3 l9_31=vec3(linearToSrgb(l9_29.x),linearToSrgb(l9_29.y),linearToSrgb(l9_29.z));
return vec4(l9_31.x,l9_31.y,l9_31.z,l9_29.w);
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
vec3 l9_1=normalize(varNormalAndMotion.xyz);
vec3 l9_2=normalize(varTangent.xyz);
vec3 l9_3=cross(l9_1,l9_2)*varTangent.w;
vec2 l9_4=gl_FragCoord.xy*sc_CurrentRenderTargetDims.zw;
vec2 l9_5=sc_ScreenCoordsGlobalToView(l9_4);
ssGlobals l9_6=ssGlobals(sc_Time.x,sc_Time.y,0.0,vec3(0.0),l9_0,varPosAndMotion.xyz,varPosAndMotion.xyz,l9_1,l9_2,l9_3,varTex01.xy,varTex01.zw,l9_5,varColor);
vec4 l9_7;
#if (ENABLE_GLTF_LIGHTING)
{
float l9_8;
#if (ENABLE_NORMALMAP)
{
l9_8=normalTextureScale;
}
#else
{
l9_8=0.0;
}
#endif
float l9_9;
#if (ENABLE_METALLIC_ROUGHNESS_TEX)
{
l9_9=occlusionTextureStrength;
}
#else
{
l9_9=0.0;
}
#endif
float l9_10;
Node40_Bool_Parameter(l9_10,l9_6);
float l9_11;
Node121_Bool_Parameter(l9_11,l9_6);
float l9_12;
Node48_Bool_Parameter(l9_12,l9_6);
float l9_13;
Node88_Bool_Parameter(l9_13,l9_6);
tempGlobals=l9_6;
vec4 l9_14;
#if (ENABLE_BASE_TEX)
{
vec2 l9_15=N35_getUV(NODE_7_DROPLIST_ITEM);
vec2 l9_16;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_BASE_TEXTURE_TRANSFORM)!=0))
{
l9_16=N35_uvTransform(l9_15,baseColorTexture_offset,baseColorTexture_scale,baseColorTexture_rotation);
}
else
{
l9_16=l9_15;
}
l9_14=baseColorFactor*ssSRGB_to_Linear(N35_BaseTexture_sample(l9_16));
}
#else
{
l9_14=baseColorFactor;
}
#endif
vec4 l9_17;
#if (ENABLE_VERTEX_COLOR_BASE)
{
l9_17=l9_14*tempGlobals.VertexColor;
}
#else
{
l9_17=l9_14;
}
#endif
tempGlobals=l9_6;
vec3 l9_18;
#if (ENABLE_EMISSIVE)
{
vec2 l9_19=N3_getUV(NODE_10_DROPLIST_ITEM);
vec2 l9_20;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_EMISSIVE_TEXTURE_TRANSFORM)!=0))
{
l9_20=N3_uvTransform(l9_19,emissiveTexture_offset,emissiveTexture_scale,emissiveTexture_rotation);
}
else
{
l9_20=l9_19;
}
vec4 l9_21;
#if (emissiveTextureLayout==2)
{
bool l9_22=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_emissiveTexture)!=0));
float l9_23=l9_20.x;
sc_SoftwareWrapEarly(l9_23,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).x);
float l9_24=l9_23;
float l9_25=l9_20.y;
sc_SoftwareWrapEarly(l9_25,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).y);
float l9_26=l9_25;
vec2 l9_27;
float l9_28;
#if (SC_USE_UV_MIN_MAX_emissiveTexture)
{
bool l9_29;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTexture)
{
l9_29=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).x==3;
}
#else
{
l9_29=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture)!=0);
}
#endif
float l9_30=l9_24;
float l9_31=1.0;
sc_ClampUV(l9_30,emissiveTextureUvMinMax.x,emissiveTextureUvMinMax.z,l9_29,l9_31);
float l9_32=l9_30;
float l9_33=l9_31;
bool l9_34;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTexture)
{
l9_34=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).y==3;
}
#else
{
l9_34=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture)!=0);
}
#endif
float l9_35=l9_26;
float l9_36=l9_33;
sc_ClampUV(l9_35,emissiveTextureUvMinMax.y,emissiveTextureUvMinMax.w,l9_34,l9_36);
l9_28=l9_36;
l9_27=vec2(l9_32,l9_35);
}
#else
{
l9_28=1.0;
l9_27=vec2(l9_24,l9_26);
}
#endif
vec2 l9_37=sc_TransformUV(l9_27,(int(SC_USE_UV_TRANSFORM_emissiveTexture)!=0),emissiveTextureTransform);
float l9_38=l9_37.x;
float l9_39=l9_28;
sc_SoftwareWrapLate(l9_38,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).x,l9_22,l9_39);
float l9_40=l9_37.y;
float l9_41=l9_39;
sc_SoftwareWrapLate(l9_40,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).y,l9_22,l9_41);
float l9_42=l9_41;
vec3 l9_43=sc_SamplingCoordsViewToGlobal(vec2(l9_38,l9_40),emissiveTextureLayout,emissiveTextureGetStereoViewIndex());
vec4 l9_44=texture(emissiveTextureArrSC,l9_43,0.0);
vec4 l9_45;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTexture)
{
l9_45=mix(emissiveTextureBorderColor,l9_44,vec4(l9_42));
}
#else
{
l9_45=l9_44;
}
#endif
l9_21=l9_45;
}
#else
{
bool l9_46=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_emissiveTexture)!=0));
float l9_47=l9_20.x;
sc_SoftwareWrapEarly(l9_47,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).x);
float l9_48=l9_47;
float l9_49=l9_20.y;
sc_SoftwareWrapEarly(l9_49,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).y);
float l9_50=l9_49;
vec2 l9_51;
float l9_52;
#if (SC_USE_UV_MIN_MAX_emissiveTexture)
{
bool l9_53;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTexture)
{
l9_53=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).x==3;
}
#else
{
l9_53=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture)!=0);
}
#endif
float l9_54=l9_48;
float l9_55=1.0;
sc_ClampUV(l9_54,emissiveTextureUvMinMax.x,emissiveTextureUvMinMax.z,l9_53,l9_55);
float l9_56=l9_54;
float l9_57=l9_55;
bool l9_58;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTexture)
{
l9_58=ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).y==3;
}
#else
{
l9_58=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture)!=0);
}
#endif
float l9_59=l9_50;
float l9_60=l9_57;
sc_ClampUV(l9_59,emissiveTextureUvMinMax.y,emissiveTextureUvMinMax.w,l9_58,l9_60);
l9_52=l9_60;
l9_51=vec2(l9_56,l9_59);
}
#else
{
l9_52=1.0;
l9_51=vec2(l9_48,l9_50);
}
#endif
vec2 l9_61=sc_TransformUV(l9_51,(int(SC_USE_UV_TRANSFORM_emissiveTexture)!=0),emissiveTextureTransform);
float l9_62=l9_61.x;
float l9_63=l9_52;
sc_SoftwareWrapLate(l9_62,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).x,l9_46,l9_63);
float l9_64=l9_61.y;
float l9_65=l9_63;
sc_SoftwareWrapLate(l9_64,ivec2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture).y,l9_46,l9_65);
float l9_66=l9_65;
vec3 l9_67=sc_SamplingCoordsViewToGlobal(vec2(l9_62,l9_64),emissiveTextureLayout,emissiveTextureGetStereoViewIndex());
vec4 l9_68=texture(emissiveTexture,l9_67.xy,0.0);
vec4 l9_69;
#if (SC_USE_CLAMP_TO_BORDER_emissiveTexture)
{
l9_69=mix(emissiveTextureBorderColor,l9_68,vec4(l9_66));
}
#else
{
l9_69=l9_68;
}
#endif
l9_21=l9_69;
}
#endif
l9_18=ssSRGB_to_Linear(l9_21.xyz)*ssSRGB_to_Linear(emissiveFactor);
}
#else
{
l9_18=emissiveFactor;
}
#endif
vec3 l9_70=tempGlobals.VertexNormal_WorldSpace;
vec3 l9_71=normalize(l9_70);
vec3 l9_72;
#if (ENABLE_NORMALMAP)
{
vec2 l9_73=N3_getUV(NODE_8_DROPLIST_ITEM);
vec2 l9_74;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_NORMAL_TEXTURE_TRANSFORM)!=0))
{
l9_74=N3_uvTransform(l9_73,normalTexture_offset,normalTexture_scale,normalTexture_rotation);
}
else
{
l9_74=l9_73;
}
vec4 l9_75;
#if (normalTextureLayout==2)
{
bool l9_76=(int(SC_USE_CLAMP_TO_BORDER_normalTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_normalTexture)!=0));
float l9_77=l9_74.x;
sc_SoftwareWrapEarly(l9_77,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).x);
float l9_78=l9_77;
float l9_79=l9_74.y;
sc_SoftwareWrapEarly(l9_79,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).y);
float l9_80=l9_79;
vec2 l9_81;
float l9_82;
#if (SC_USE_UV_MIN_MAX_normalTexture)
{
bool l9_83;
#if (SC_USE_CLAMP_TO_BORDER_normalTexture)
{
l9_83=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).x==3;
}
#else
{
l9_83=(int(SC_USE_CLAMP_TO_BORDER_normalTexture)!=0);
}
#endif
float l9_84=l9_78;
float l9_85=1.0;
sc_ClampUV(l9_84,normalTextureUvMinMax.x,normalTextureUvMinMax.z,l9_83,l9_85);
float l9_86=l9_84;
float l9_87=l9_85;
bool l9_88;
#if (SC_USE_CLAMP_TO_BORDER_normalTexture)
{
l9_88=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).y==3;
}
#else
{
l9_88=(int(SC_USE_CLAMP_TO_BORDER_normalTexture)!=0);
}
#endif
float l9_89=l9_80;
float l9_90=l9_87;
sc_ClampUV(l9_89,normalTextureUvMinMax.y,normalTextureUvMinMax.w,l9_88,l9_90);
l9_82=l9_90;
l9_81=vec2(l9_86,l9_89);
}
#else
{
l9_82=1.0;
l9_81=vec2(l9_78,l9_80);
}
#endif
vec2 l9_91=sc_TransformUV(l9_81,(int(SC_USE_UV_TRANSFORM_normalTexture)!=0),normalTextureTransform);
float l9_92=l9_91.x;
float l9_93=l9_82;
sc_SoftwareWrapLate(l9_92,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).x,l9_76,l9_93);
float l9_94=l9_91.y;
float l9_95=l9_93;
sc_SoftwareWrapLate(l9_94,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).y,l9_76,l9_95);
float l9_96=l9_95;
vec3 l9_97=sc_SamplingCoordsViewToGlobal(vec2(l9_92,l9_94),normalTextureLayout,normalTextureGetStereoViewIndex());
vec4 l9_98=texture(normalTextureArrSC,l9_97,0.0);
vec4 l9_99;
#if (SC_USE_CLAMP_TO_BORDER_normalTexture)
{
l9_99=mix(normalTextureBorderColor,l9_98,vec4(l9_96));
}
#else
{
l9_99=l9_98;
}
#endif
l9_75=l9_99;
}
#else
{
bool l9_100=(int(SC_USE_CLAMP_TO_BORDER_normalTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_normalTexture)!=0));
float l9_101=l9_74.x;
sc_SoftwareWrapEarly(l9_101,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).x);
float l9_102=l9_101;
float l9_103=l9_74.y;
sc_SoftwareWrapEarly(l9_103,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).y);
float l9_104=l9_103;
vec2 l9_105;
float l9_106;
#if (SC_USE_UV_MIN_MAX_normalTexture)
{
bool l9_107;
#if (SC_USE_CLAMP_TO_BORDER_normalTexture)
{
l9_107=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).x==3;
}
#else
{
l9_107=(int(SC_USE_CLAMP_TO_BORDER_normalTexture)!=0);
}
#endif
float l9_108=l9_102;
float l9_109=1.0;
sc_ClampUV(l9_108,normalTextureUvMinMax.x,normalTextureUvMinMax.z,l9_107,l9_109);
float l9_110=l9_108;
float l9_111=l9_109;
bool l9_112;
#if (SC_USE_CLAMP_TO_BORDER_normalTexture)
{
l9_112=ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).y==3;
}
#else
{
l9_112=(int(SC_USE_CLAMP_TO_BORDER_normalTexture)!=0);
}
#endif
float l9_113=l9_104;
float l9_114=l9_111;
sc_ClampUV(l9_113,normalTextureUvMinMax.y,normalTextureUvMinMax.w,l9_112,l9_114);
l9_106=l9_114;
l9_105=vec2(l9_110,l9_113);
}
#else
{
l9_106=1.0;
l9_105=vec2(l9_102,l9_104);
}
#endif
vec2 l9_115=sc_TransformUV(l9_105,(int(SC_USE_UV_TRANSFORM_normalTexture)!=0),normalTextureTransform);
float l9_116=l9_115.x;
float l9_117=l9_106;
sc_SoftwareWrapLate(l9_116,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).x,l9_100,l9_117);
float l9_118=l9_115.y;
float l9_119=l9_117;
sc_SoftwareWrapLate(l9_118,ivec2(SC_SOFTWARE_WRAP_MODE_U_normalTexture,SC_SOFTWARE_WRAP_MODE_V_normalTexture).y,l9_100,l9_119);
float l9_120=l9_119;
vec3 l9_121=sc_SamplingCoordsViewToGlobal(vec2(l9_116,l9_118),normalTextureLayout,normalTextureGetStereoViewIndex());
vec4 l9_122=texture(normalTexture,l9_121.xy,0.0);
vec4 l9_123;
#if (SC_USE_CLAMP_TO_BORDER_normalTexture)
{
l9_123=mix(normalTextureBorderColor,l9_122,vec4(l9_120));
}
#else
{
l9_123=l9_122;
}
#endif
l9_75=l9_123;
}
#endif
l9_72=normalize(mat3(tempGlobals.VertexTangent_WorldSpace,tempGlobals.VertexBinormal_WorldSpace,l9_71)*mix(vec3(0.0,0.0,1.0),(l9_75.xyz*1.9921875)-vec3(1.0),vec3(l9_8)));
}
#else
{
l9_72=l9_71;
}
#endif
float l9_124;
vec4 l9_125;
float l9_126;
#if (ENABLE_METALLIC_ROUGHNESS_TEX)
{
vec2 l9_127=N3_getUV(NODE_11_DROPLIST_ITEM);
vec2 l9_128;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM)!=0))
{
l9_128=N3_uvTransform(l9_127,metallicRoughnessTexture_offset,metallicRoughnessTexture_scale,metallicRoughnessTexture_rotation);
}
else
{
l9_128=l9_127;
}
vec4 l9_129;
#if (metallicRoughnessTextureLayout==2)
{
bool l9_130=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_metallicRoughnessTexture)!=0));
float l9_131=l9_128.x;
sc_SoftwareWrapEarly(l9_131,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).x);
float l9_132=l9_131;
float l9_133=l9_128.y;
sc_SoftwareWrapEarly(l9_133,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).y);
float l9_134=l9_133;
vec2 l9_135;
float l9_136;
#if (SC_USE_UV_MIN_MAX_metallicRoughnessTexture)
{
bool l9_137;
#if (SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)
{
l9_137=ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).x==3;
}
#else
{
l9_137=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)!=0);
}
#endif
float l9_138=l9_132;
float l9_139=1.0;
sc_ClampUV(l9_138,metallicRoughnessTextureUvMinMax.x,metallicRoughnessTextureUvMinMax.z,l9_137,l9_139);
float l9_140=l9_138;
float l9_141=l9_139;
bool l9_142;
#if (SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)
{
l9_142=ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).y==3;
}
#else
{
l9_142=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)!=0);
}
#endif
float l9_143=l9_134;
float l9_144=l9_141;
sc_ClampUV(l9_143,metallicRoughnessTextureUvMinMax.y,metallicRoughnessTextureUvMinMax.w,l9_142,l9_144);
l9_136=l9_144;
l9_135=vec2(l9_140,l9_143);
}
#else
{
l9_136=1.0;
l9_135=vec2(l9_132,l9_134);
}
#endif
vec2 l9_145=sc_TransformUV(l9_135,(int(SC_USE_UV_TRANSFORM_metallicRoughnessTexture)!=0),metallicRoughnessTextureTransform);
float l9_146=l9_145.x;
float l9_147=l9_136;
sc_SoftwareWrapLate(l9_146,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).x,l9_130,l9_147);
float l9_148=l9_145.y;
float l9_149=l9_147;
sc_SoftwareWrapLate(l9_148,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).y,l9_130,l9_149);
float l9_150=l9_149;
vec3 l9_151=sc_SamplingCoordsViewToGlobal(vec2(l9_146,l9_148),metallicRoughnessTextureLayout,metallicRoughnessTextureGetStereoViewIndex());
vec4 l9_152=texture(metallicRoughnessTextureArrSC,l9_151,0.0);
vec4 l9_153;
#if (SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)
{
l9_153=mix(metallicRoughnessTextureBorderColor,l9_152,vec4(l9_150));
}
#else
{
l9_153=l9_152;
}
#endif
l9_129=l9_153;
}
#else
{
bool l9_154=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_metallicRoughnessTexture)!=0));
float l9_155=l9_128.x;
sc_SoftwareWrapEarly(l9_155,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).x);
float l9_156=l9_155;
float l9_157=l9_128.y;
sc_SoftwareWrapEarly(l9_157,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).y);
float l9_158=l9_157;
vec2 l9_159;
float l9_160;
#if (SC_USE_UV_MIN_MAX_metallicRoughnessTexture)
{
bool l9_161;
#if (SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)
{
l9_161=ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).x==3;
}
#else
{
l9_161=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)!=0);
}
#endif
float l9_162=l9_156;
float l9_163=1.0;
sc_ClampUV(l9_162,metallicRoughnessTextureUvMinMax.x,metallicRoughnessTextureUvMinMax.z,l9_161,l9_163);
float l9_164=l9_162;
float l9_165=l9_163;
bool l9_166;
#if (SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)
{
l9_166=ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).y==3;
}
#else
{
l9_166=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)!=0);
}
#endif
float l9_167=l9_158;
float l9_168=l9_165;
sc_ClampUV(l9_167,metallicRoughnessTextureUvMinMax.y,metallicRoughnessTextureUvMinMax.w,l9_166,l9_168);
l9_160=l9_168;
l9_159=vec2(l9_164,l9_167);
}
#else
{
l9_160=1.0;
l9_159=vec2(l9_156,l9_158);
}
#endif
vec2 l9_169=sc_TransformUV(l9_159,(int(SC_USE_UV_TRANSFORM_metallicRoughnessTexture)!=0),metallicRoughnessTextureTransform);
float l9_170=l9_169.x;
float l9_171=l9_160;
sc_SoftwareWrapLate(l9_170,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).x,l9_154,l9_171);
float l9_172=l9_169.y;
float l9_173=l9_171;
sc_SoftwareWrapLate(l9_172,ivec2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture).y,l9_154,l9_173);
float l9_174=l9_173;
vec3 l9_175=sc_SamplingCoordsViewToGlobal(vec2(l9_170,l9_172),metallicRoughnessTextureLayout,metallicRoughnessTextureGetStereoViewIndex());
vec4 l9_176=texture(metallicRoughnessTexture,l9_175.xy,0.0);
vec4 l9_177;
#if (SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture)
{
l9_177=mix(metallicRoughnessTextureBorderColor,l9_176,vec4(l9_174));
}
#else
{
l9_177=l9_176;
}
#endif
l9_129=l9_177;
}
#endif
vec3 l9_178;
#if (METALLIC_ROUGHNESS_TEX_SWIZZLE_RB)
{
l9_178=l9_129.zyx;
}
#else
{
l9_178=l9_129.xyz;
}
#endif
vec4 l9_179=vec4(0.0);
l9_179.w=l9_9;
vec3 l9_180=vec3(1.0+(l9_9*(l9_178.z-1.0)));
l9_126=roughnessFactor*l9_178.y;
l9_125=vec4(l9_180.x,l9_180.y,l9_180.z,l9_179.w);
l9_124=metallicFactor*l9_178.x;
}
#else
{
l9_126=roughnessFactor;
l9_125=vec4(1.0,1.0,1.0,0.0);
l9_124=metallicFactor;
}
#endif
vec3 l9_181;
vec3 l9_182;
vec3 l9_183;
#if (ENABLE_TRANSMISSION)
{
vec2 l9_184=tempGlobals.gScreenCoord;
vec4 l9_185;
#if (screenTextureLayout==2)
{
bool l9_186=(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_screenTexture)!=0));
float l9_187=l9_184.x;
sc_SoftwareWrapEarly(l9_187,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).x);
float l9_188=l9_187;
float l9_189=l9_184.y;
sc_SoftwareWrapEarly(l9_189,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).y);
float l9_190=l9_189;
vec2 l9_191;
float l9_192;
#if (SC_USE_UV_MIN_MAX_screenTexture)
{
bool l9_193;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_193=ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).x==3;
}
#else
{
l9_193=(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0);
}
#endif
float l9_194=l9_188;
float l9_195=1.0;
sc_ClampUV(l9_194,screenTextureUvMinMax.x,screenTextureUvMinMax.z,l9_193,l9_195);
float l9_196=l9_194;
float l9_197=l9_195;
bool l9_198;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_198=ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).y==3;
}
#else
{
l9_198=(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0);
}
#endif
float l9_199=l9_190;
float l9_200=l9_197;
sc_ClampUV(l9_199,screenTextureUvMinMax.y,screenTextureUvMinMax.w,l9_198,l9_200);
l9_192=l9_200;
l9_191=vec2(l9_196,l9_199);
}
#else
{
l9_192=1.0;
l9_191=vec2(l9_188,l9_190);
}
#endif
vec2 l9_201=sc_TransformUV(l9_191,(int(SC_USE_UV_TRANSFORM_screenTexture)!=0),screenTextureTransform);
float l9_202=l9_201.x;
float l9_203=l9_192;
sc_SoftwareWrapLate(l9_202,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).x,l9_186,l9_203);
float l9_204=l9_201.y;
float l9_205=l9_203;
sc_SoftwareWrapLate(l9_204,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).y,l9_186,l9_205);
float l9_206=l9_205;
vec3 l9_207=sc_SamplingCoordsViewToGlobal(vec2(l9_202,l9_204),screenTextureLayout,screenTextureGetStereoViewIndex());
vec4 l9_208=texture(screenTextureArrSC,l9_207,0.0);
vec4 l9_209;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_209=mix(screenTextureBorderColor,l9_208,vec4(l9_206));
}
#else
{
l9_209=l9_208;
}
#endif
l9_185=l9_209;
}
#else
{
bool l9_210=(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_screenTexture)!=0));
float l9_211=l9_184.x;
sc_SoftwareWrapEarly(l9_211,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).x);
float l9_212=l9_211;
float l9_213=l9_184.y;
sc_SoftwareWrapEarly(l9_213,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).y);
float l9_214=l9_213;
vec2 l9_215;
float l9_216;
#if (SC_USE_UV_MIN_MAX_screenTexture)
{
bool l9_217;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_217=ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).x==3;
}
#else
{
l9_217=(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0);
}
#endif
float l9_218=l9_212;
float l9_219=1.0;
sc_ClampUV(l9_218,screenTextureUvMinMax.x,screenTextureUvMinMax.z,l9_217,l9_219);
float l9_220=l9_218;
float l9_221=l9_219;
bool l9_222;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_222=ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).y==3;
}
#else
{
l9_222=(int(SC_USE_CLAMP_TO_BORDER_screenTexture)!=0);
}
#endif
float l9_223=l9_214;
float l9_224=l9_221;
sc_ClampUV(l9_223,screenTextureUvMinMax.y,screenTextureUvMinMax.w,l9_222,l9_224);
l9_216=l9_224;
l9_215=vec2(l9_220,l9_223);
}
#else
{
l9_216=1.0;
l9_215=vec2(l9_212,l9_214);
}
#endif
vec2 l9_225=sc_TransformUV(l9_215,(int(SC_USE_UV_TRANSFORM_screenTexture)!=0),screenTextureTransform);
float l9_226=l9_225.x;
float l9_227=l9_216;
sc_SoftwareWrapLate(l9_226,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).x,l9_210,l9_227);
float l9_228=l9_225.y;
float l9_229=l9_227;
sc_SoftwareWrapLate(l9_228,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTexture,SC_SOFTWARE_WRAP_MODE_V_screenTexture).y,l9_210,l9_229);
float l9_230=l9_229;
vec3 l9_231=sc_SamplingCoordsViewToGlobal(vec2(l9_226,l9_228),screenTextureLayout,screenTextureGetStereoViewIndex());
vec4 l9_232=texture(screenTexture,l9_231.xy,0.0);
vec4 l9_233;
#if (SC_USE_CLAMP_TO_BORDER_screenTexture)
{
l9_233=mix(screenTextureBorderColor,l9_232,vec4(l9_230));
}
#else
{
l9_233=l9_232;
}
#endif
l9_185=l9_233;
}
#endif
vec3 l9_234=ssSRGB_to_Linear(l9_185.xyz);
float l9_235;
#if (ENABLE_TRANSMISSION_TEX)
{
vec2 l9_236=N3_getUV(Tweak_N30);
vec2 l9_237;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_TRANSMISSION_TEXTURE_TRANSFORM)!=0))
{
l9_237=N3_uvTransform(l9_236,transmissionTexture_offset,transmissionTexture_scale,transmissionTexture_rotation);
}
else
{
l9_237=l9_236;
}
vec4 l9_238;
#if (transmissionTextureLayout==2)
{
bool l9_239=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_transmissionTexture)!=0));
float l9_240=l9_237.x;
sc_SoftwareWrapEarly(l9_240,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).x);
float l9_241=l9_240;
float l9_242=l9_237.y;
sc_SoftwareWrapEarly(l9_242,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).y);
float l9_243=l9_242;
vec2 l9_244;
float l9_245;
#if (SC_USE_UV_MIN_MAX_transmissionTexture)
{
bool l9_246;
#if (SC_USE_CLAMP_TO_BORDER_transmissionTexture)
{
l9_246=ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).x==3;
}
#else
{
l9_246=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture)!=0);
}
#endif
float l9_247=l9_241;
float l9_248=1.0;
sc_ClampUV(l9_247,transmissionTextureUvMinMax.x,transmissionTextureUvMinMax.z,l9_246,l9_248);
float l9_249=l9_247;
float l9_250=l9_248;
bool l9_251;
#if (SC_USE_CLAMP_TO_BORDER_transmissionTexture)
{
l9_251=ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).y==3;
}
#else
{
l9_251=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture)!=0);
}
#endif
float l9_252=l9_243;
float l9_253=l9_250;
sc_ClampUV(l9_252,transmissionTextureUvMinMax.y,transmissionTextureUvMinMax.w,l9_251,l9_253);
l9_245=l9_253;
l9_244=vec2(l9_249,l9_252);
}
#else
{
l9_245=1.0;
l9_244=vec2(l9_241,l9_243);
}
#endif
vec2 l9_254=sc_TransformUV(l9_244,(int(SC_USE_UV_TRANSFORM_transmissionTexture)!=0),transmissionTextureTransform);
float l9_255=l9_254.x;
float l9_256=l9_245;
sc_SoftwareWrapLate(l9_255,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).x,l9_239,l9_256);
float l9_257=l9_254.y;
float l9_258=l9_256;
sc_SoftwareWrapLate(l9_257,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).y,l9_239,l9_258);
float l9_259=l9_258;
vec3 l9_260=sc_SamplingCoordsViewToGlobal(vec2(l9_255,l9_257),transmissionTextureLayout,transmissionTextureGetStereoViewIndex());
vec4 l9_261=texture(transmissionTextureArrSC,l9_260,0.0);
vec4 l9_262;
#if (SC_USE_CLAMP_TO_BORDER_transmissionTexture)
{
l9_262=mix(transmissionTextureBorderColor,l9_261,vec4(l9_259));
}
#else
{
l9_262=l9_261;
}
#endif
l9_238=l9_262;
}
#else
{
bool l9_263=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_transmissionTexture)!=0));
float l9_264=l9_237.x;
sc_SoftwareWrapEarly(l9_264,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).x);
float l9_265=l9_264;
float l9_266=l9_237.y;
sc_SoftwareWrapEarly(l9_266,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).y);
float l9_267=l9_266;
vec2 l9_268;
float l9_269;
#if (SC_USE_UV_MIN_MAX_transmissionTexture)
{
bool l9_270;
#if (SC_USE_CLAMP_TO_BORDER_transmissionTexture)
{
l9_270=ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).x==3;
}
#else
{
l9_270=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture)!=0);
}
#endif
float l9_271=l9_265;
float l9_272=1.0;
sc_ClampUV(l9_271,transmissionTextureUvMinMax.x,transmissionTextureUvMinMax.z,l9_270,l9_272);
float l9_273=l9_271;
float l9_274=l9_272;
bool l9_275;
#if (SC_USE_CLAMP_TO_BORDER_transmissionTexture)
{
l9_275=ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).y==3;
}
#else
{
l9_275=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture)!=0);
}
#endif
float l9_276=l9_267;
float l9_277=l9_274;
sc_ClampUV(l9_276,transmissionTextureUvMinMax.y,transmissionTextureUvMinMax.w,l9_275,l9_277);
l9_269=l9_277;
l9_268=vec2(l9_273,l9_276);
}
#else
{
l9_269=1.0;
l9_268=vec2(l9_265,l9_267);
}
#endif
vec2 l9_278=sc_TransformUV(l9_268,(int(SC_USE_UV_TRANSFORM_transmissionTexture)!=0),transmissionTextureTransform);
float l9_279=l9_278.x;
float l9_280=l9_269;
sc_SoftwareWrapLate(l9_279,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).x,l9_263,l9_280);
float l9_281=l9_278.y;
float l9_282=l9_280;
sc_SoftwareWrapLate(l9_281,ivec2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture).y,l9_263,l9_282);
float l9_283=l9_282;
vec3 l9_284=sc_SamplingCoordsViewToGlobal(vec2(l9_279,l9_281),transmissionTextureLayout,transmissionTextureGetStereoViewIndex());
vec4 l9_285=texture(transmissionTexture,l9_284.xy,0.0);
vec4 l9_286;
#if (SC_USE_CLAMP_TO_BORDER_transmissionTexture)
{
l9_286=mix(transmissionTextureBorderColor,l9_285,vec4(l9_283));
}
#else
{
l9_286=l9_285;
}
#endif
l9_238=l9_286;
}
#endif
l9_235=l9_238.x;
}
#else
{
l9_235=1.0;
}
#endif
vec3 l9_287=vec3(l9_235*transmissionFactor);
vec3 l9_288=vec3(l9_124);
l9_183=l9_234;
l9_182=mix(mix(vec3(0.0),l9_17.xyz,l9_287)*l9_234,vec3(0.0),l9_288)+l9_18;
l9_181=mix(mix(l9_17.xyz,vec3(0.0),l9_287),l9_17.xyz,l9_288);
}
#else
{
l9_183=vec3(0.0);
l9_182=l9_18;
l9_181=l9_17.xyz;
}
#endif
vec3 l9_289=ssLinear_to_SRGB(l9_181);
float l9_290;
#if ((SC_DEVICE_CLASS>=2)&&SC_GL_FRAGMENT_PRECISION_HIGH)
{
l9_290=pow(l9_17.w,0.45454544);
}
#else
{
l9_290=sqrt(l9_17.w);
}
#endif
vec3 l9_291=ssLinear_to_SRGB(l9_182);
vec4 l9_292;
#if (ENABLE_SHEEN)
{
vec3 l9_293;
#if (ENABLE_SHEEN_COLOR_TEX)
{
vec2 l9_294=N3_getUV(Tweak_N32);
vec2 l9_295;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM)!=0))
{
l9_295=N3_uvTransform(l9_294,sheenColorTexture_offset,sheenColorTexture_scale,sheenColorTexture_rotation);
}
else
{
l9_295=l9_294;
}
vec4 l9_296;
#if (sheenColorTextureLayout==2)
{
bool l9_297=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_sheenColorTexture)!=0));
float l9_298=l9_295.x;
sc_SoftwareWrapEarly(l9_298,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).x);
float l9_299=l9_298;
float l9_300=l9_295.y;
sc_SoftwareWrapEarly(l9_300,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).y);
float l9_301=l9_300;
vec2 l9_302;
float l9_303;
#if (SC_USE_UV_MIN_MAX_sheenColorTexture)
{
bool l9_304;
#if (SC_USE_CLAMP_TO_BORDER_sheenColorTexture)
{
l9_304=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).x==3;
}
#else
{
l9_304=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture)!=0);
}
#endif
float l9_305=l9_299;
float l9_306=1.0;
sc_ClampUV(l9_305,sheenColorTextureUvMinMax.x,sheenColorTextureUvMinMax.z,l9_304,l9_306);
float l9_307=l9_305;
float l9_308=l9_306;
bool l9_309;
#if (SC_USE_CLAMP_TO_BORDER_sheenColorTexture)
{
l9_309=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).y==3;
}
#else
{
l9_309=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture)!=0);
}
#endif
float l9_310=l9_301;
float l9_311=l9_308;
sc_ClampUV(l9_310,sheenColorTextureUvMinMax.y,sheenColorTextureUvMinMax.w,l9_309,l9_311);
l9_303=l9_311;
l9_302=vec2(l9_307,l9_310);
}
#else
{
l9_303=1.0;
l9_302=vec2(l9_299,l9_301);
}
#endif
vec2 l9_312=sc_TransformUV(l9_302,(int(SC_USE_UV_TRANSFORM_sheenColorTexture)!=0),sheenColorTextureTransform);
float l9_313=l9_312.x;
float l9_314=l9_303;
sc_SoftwareWrapLate(l9_313,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).x,l9_297,l9_314);
float l9_315=l9_312.y;
float l9_316=l9_314;
sc_SoftwareWrapLate(l9_315,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).y,l9_297,l9_316);
float l9_317=l9_316;
vec3 l9_318=sc_SamplingCoordsViewToGlobal(vec2(l9_313,l9_315),sheenColorTextureLayout,sheenColorTextureGetStereoViewIndex());
vec4 l9_319=texture(sheenColorTextureArrSC,l9_318,0.0);
vec4 l9_320;
#if (SC_USE_CLAMP_TO_BORDER_sheenColorTexture)
{
l9_320=mix(sheenColorTextureBorderColor,l9_319,vec4(l9_317));
}
#else
{
l9_320=l9_319;
}
#endif
l9_296=l9_320;
}
#else
{
bool l9_321=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_sheenColorTexture)!=0));
float l9_322=l9_295.x;
sc_SoftwareWrapEarly(l9_322,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).x);
float l9_323=l9_322;
float l9_324=l9_295.y;
sc_SoftwareWrapEarly(l9_324,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).y);
float l9_325=l9_324;
vec2 l9_326;
float l9_327;
#if (SC_USE_UV_MIN_MAX_sheenColorTexture)
{
bool l9_328;
#if (SC_USE_CLAMP_TO_BORDER_sheenColorTexture)
{
l9_328=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).x==3;
}
#else
{
l9_328=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture)!=0);
}
#endif
float l9_329=l9_323;
float l9_330=1.0;
sc_ClampUV(l9_329,sheenColorTextureUvMinMax.x,sheenColorTextureUvMinMax.z,l9_328,l9_330);
float l9_331=l9_329;
float l9_332=l9_330;
bool l9_333;
#if (SC_USE_CLAMP_TO_BORDER_sheenColorTexture)
{
l9_333=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).y==3;
}
#else
{
l9_333=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture)!=0);
}
#endif
float l9_334=l9_325;
float l9_335=l9_332;
sc_ClampUV(l9_334,sheenColorTextureUvMinMax.y,sheenColorTextureUvMinMax.w,l9_333,l9_335);
l9_327=l9_335;
l9_326=vec2(l9_331,l9_334);
}
#else
{
l9_327=1.0;
l9_326=vec2(l9_323,l9_325);
}
#endif
vec2 l9_336=sc_TransformUV(l9_326,(int(SC_USE_UV_TRANSFORM_sheenColorTexture)!=0),sheenColorTextureTransform);
float l9_337=l9_336.x;
float l9_338=l9_327;
sc_SoftwareWrapLate(l9_337,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).x,l9_321,l9_338);
float l9_339=l9_336.y;
float l9_340=l9_338;
sc_SoftwareWrapLate(l9_339,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture).y,l9_321,l9_340);
float l9_341=l9_340;
vec3 l9_342=sc_SamplingCoordsViewToGlobal(vec2(l9_337,l9_339),sheenColorTextureLayout,sheenColorTextureGetStereoViewIndex());
vec4 l9_343=texture(sheenColorTexture,l9_342.xy,0.0);
vec4 l9_344;
#if (SC_USE_CLAMP_TO_BORDER_sheenColorTexture)
{
l9_344=mix(sheenColorTextureBorderColor,l9_343,vec4(l9_341));
}
#else
{
l9_344=l9_343;
}
#endif
l9_296=l9_344;
}
#endif
l9_293=sheenColorFactor*ssSRGB_to_Linear(l9_296.xyz);
}
#else
{
l9_293=sheenColorFactor;
}
#endif
float l9_345;
#if (ENABLE_SHEEN_ROUGHNESS_TEX)
{
vec2 l9_346=N3_getUV(Tweak_N37);
vec2 l9_347;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM)!=0))
{
l9_347=N3_uvTransform(l9_346,sheenRoughnessTexture_offset,sheenRoughnessTexture_scale,sheenRoughnessTexture_rotation);
}
else
{
l9_347=l9_346;
}
vec4 l9_348;
#if (sheenRoughnessTextureLayout==2)
{
bool l9_349=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_sheenRoughnessTexture)!=0));
float l9_350=l9_347.x;
sc_SoftwareWrapEarly(l9_350,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).x);
float l9_351=l9_350;
float l9_352=l9_347.y;
sc_SoftwareWrapEarly(l9_352,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).y);
float l9_353=l9_352;
vec2 l9_354;
float l9_355;
#if (SC_USE_UV_MIN_MAX_sheenRoughnessTexture)
{
bool l9_356;
#if (SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)
{
l9_356=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).x==3;
}
#else
{
l9_356=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)!=0);
}
#endif
float l9_357=l9_351;
float l9_358=1.0;
sc_ClampUV(l9_357,sheenRoughnessTextureUvMinMax.x,sheenRoughnessTextureUvMinMax.z,l9_356,l9_358);
float l9_359=l9_357;
float l9_360=l9_358;
bool l9_361;
#if (SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)
{
l9_361=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).y==3;
}
#else
{
l9_361=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)!=0);
}
#endif
float l9_362=l9_353;
float l9_363=l9_360;
sc_ClampUV(l9_362,sheenRoughnessTextureUvMinMax.y,sheenRoughnessTextureUvMinMax.w,l9_361,l9_363);
l9_355=l9_363;
l9_354=vec2(l9_359,l9_362);
}
#else
{
l9_355=1.0;
l9_354=vec2(l9_351,l9_353);
}
#endif
vec2 l9_364=sc_TransformUV(l9_354,(int(SC_USE_UV_TRANSFORM_sheenRoughnessTexture)!=0),sheenRoughnessTextureTransform);
float l9_365=l9_364.x;
float l9_366=l9_355;
sc_SoftwareWrapLate(l9_365,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).x,l9_349,l9_366);
float l9_367=l9_364.y;
float l9_368=l9_366;
sc_SoftwareWrapLate(l9_367,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).y,l9_349,l9_368);
float l9_369=l9_368;
vec3 l9_370=sc_SamplingCoordsViewToGlobal(vec2(l9_365,l9_367),sheenRoughnessTextureLayout,sheenRoughnessTextureGetStereoViewIndex());
vec4 l9_371=texture(sheenRoughnessTextureArrSC,l9_370,0.0);
vec4 l9_372;
#if (SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)
{
l9_372=mix(sheenRoughnessTextureBorderColor,l9_371,vec4(l9_369));
}
#else
{
l9_372=l9_371;
}
#endif
l9_348=l9_372;
}
#else
{
bool l9_373=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_sheenRoughnessTexture)!=0));
float l9_374=l9_347.x;
sc_SoftwareWrapEarly(l9_374,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).x);
float l9_375=l9_374;
float l9_376=l9_347.y;
sc_SoftwareWrapEarly(l9_376,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).y);
float l9_377=l9_376;
vec2 l9_378;
float l9_379;
#if (SC_USE_UV_MIN_MAX_sheenRoughnessTexture)
{
bool l9_380;
#if (SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)
{
l9_380=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).x==3;
}
#else
{
l9_380=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)!=0);
}
#endif
float l9_381=l9_375;
float l9_382=1.0;
sc_ClampUV(l9_381,sheenRoughnessTextureUvMinMax.x,sheenRoughnessTextureUvMinMax.z,l9_380,l9_382);
float l9_383=l9_381;
float l9_384=l9_382;
bool l9_385;
#if (SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)
{
l9_385=ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).y==3;
}
#else
{
l9_385=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)!=0);
}
#endif
float l9_386=l9_377;
float l9_387=l9_384;
sc_ClampUV(l9_386,sheenRoughnessTextureUvMinMax.y,sheenRoughnessTextureUvMinMax.w,l9_385,l9_387);
l9_379=l9_387;
l9_378=vec2(l9_383,l9_386);
}
#else
{
l9_379=1.0;
l9_378=vec2(l9_375,l9_377);
}
#endif
vec2 l9_388=sc_TransformUV(l9_378,(int(SC_USE_UV_TRANSFORM_sheenRoughnessTexture)!=0),sheenRoughnessTextureTransform);
float l9_389=l9_388.x;
float l9_390=l9_379;
sc_SoftwareWrapLate(l9_389,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).x,l9_373,l9_390);
float l9_391=l9_388.y;
float l9_392=l9_390;
sc_SoftwareWrapLate(l9_391,ivec2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture).y,l9_373,l9_392);
float l9_393=l9_392;
vec3 l9_394=sc_SamplingCoordsViewToGlobal(vec2(l9_389,l9_391),sheenRoughnessTextureLayout,sheenRoughnessTextureGetStereoViewIndex());
vec4 l9_395=texture(sheenRoughnessTexture,l9_394.xy,0.0);
vec4 l9_396;
#if (SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture)
{
l9_396=mix(sheenRoughnessTextureBorderColor,l9_395,vec4(l9_393));
}
#else
{
l9_396=l9_395;
}
#endif
l9_348=l9_396;
}
#endif
l9_345=sheenRoughnessFactor*ssSRGB_to_Linear(l9_348.w);
}
#else
{
l9_345=sheenRoughnessFactor;
}
#endif
float l9_397=max(l9_345,9.9999997e-05);
vec3 l9_398=tempGlobals.SurfacePosition_WorldSpace;
vec3 l9_399=normalize(sc_Camera.position-l9_398);
float l9_400=dot(l9_72,l9_399);
float l9_401=max(clamp(l9_400,0.0,1.0),9.9999997e-05);
float l9_402=l9_397*l9_397;
vec3 l9_403=reflect(-l9_399,l9_72);
bool l9_404=l9_397<0.25;
float l9_405;
if (l9_404)
{
l9_405=(((-339.20001)*l9_402)+(161.39999*l9_397))-25.9;
}
else
{
l9_405=(((-8.4799995)*l9_402)+(14.3*l9_397))-9.9499998;
}
float l9_406;
if (l9_404)
{
l9_406=((44.0*l9_402)-(23.700001*l9_397))+3.26;
}
else
{
l9_406=((1.97*l9_402)-(3.27*l9_397))+0.72000003;
}
float l9_407=l9_405*l9_401;
float l9_408=l9_407+l9_406;
float l9_409;
if (l9_404)
{
l9_409=0.0;
}
else
{
l9_409=0.1*(l9_397-0.25);
}
float l9_410=exp(l9_408)+l9_409;
vec3 l9_411=sampleSpecularEnvTextureLod(normalize(l9_403),3.0+((((l9_397*4.0)-0.0)*2.0)/5.000001));
vec3 l9_412=(l9_411*sc_EnvmapExposure)*l9_293;
vec3 l9_413=(vec3(0.0)+(l9_412*clamp(l9_410*3.1415927,0.0,1.0))).xyz;
vec3 l9_414;
if (sc_DirectionalLightsCount>0)
{
vec3 l9_415;
l9_415=vec3(0.0);
vec3 l9_416;
int l9_417=0;
bool l9_418;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_418=l9_417<sc_DirectionalLightsCount;
if (l9_418)
{
vec3 l9_419;
if (l9_418)
{
l9_419=sc_DirectionalLights[l9_417].color.xyz;
}
else
{
l9_419=vec3(0.0);
}
float l9_420;
if (l9_418)
{
l9_420=sc_DirectionalLights[l9_417].color.w;
}
else
{
l9_420=0.0;
}
vec3 l9_421=l9_419*l9_420;
vec3 l9_422;
if (l9_418)
{
l9_422=-sc_DirectionalLights[l9_417].direction;
}
else
{
l9_422=vec3(0.0);
}
vec3 l9_423=normalize(-l9_422);
float l9_424=clamp(dot(l9_72,l9_423),0.0,1.0);
l9_416=l9_415+(((((l9_421*3.1415901)*l9_293)*N3_charlieD(l9_402,clamp(dot(l9_72,normalize(l9_423+l9_399)),0.0,1.0)))*(1.0/(4.0*((l9_424+l9_401)-(l9_424*l9_401)))))*l9_424);
l9_415=l9_416;
l9_417++;
continue;
}
else
{
break;
}
}
l9_414=l9_415;
}
else
{
l9_414=vec3(0.0);
}
vec3 l9_425;
if (sc_PointLightsCount>0)
{
vec3 l9_426;
l9_426=l9_414;
vec3 l9_427;
int l9_428=0;
bool l9_429;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_429=l9_428<sc_PointLightsCount;
if (l9_429)
{
vec3 l9_430;
if (l9_429)
{
l9_430=sc_PointLights[l9_428].color.xyz;
}
else
{
l9_430=vec3(0.0);
}
float l9_431;
if (l9_429)
{
l9_431=sc_PointLights[l9_428].color.w;
}
else
{
l9_431=0.0;
}
vec3 l9_432=l9_430*l9_431;
vec3 l9_433;
if (l9_429)
{
l9_433=sc_PointLights[l9_428].position;
}
else
{
l9_433=vec3(0.0);
}
vec3 l9_434=normalize(l9_433-tempGlobals.SurfacePosition_WorldSpace);
float l9_435=clamp(dot(l9_72,l9_434),0.0,1.0);
l9_427=l9_426+(((((l9_432*3.1415901)*l9_293)*N3_charlieD(l9_402,clamp(dot(l9_72,normalize(l9_434+l9_399)),0.0,1.0)))*(1.0/(4.0*((l9_435+l9_401)-(l9_435*l9_401)))))*l9_435);
l9_426=l9_427;
l9_428++;
continue;
}
else
{
break;
}
}
l9_425=l9_426;
}
else
{
l9_425=l9_414;
}
vec3 l9_436;
if (sc_AmbientLightsCount>0)
{
vec3 l9_437;
l9_437=l9_425;
vec3 l9_438;
int l9_439=0;
bool l9_440;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
l9_440=l9_439<sc_AmbientLightsCount;
if (l9_440)
{
vec3 l9_441;
if (l9_440)
{
l9_441=sc_AmbientLights[l9_439].color;
}
else
{
l9_441=vec3(0.0);
}
float l9_442;
if (l9_440)
{
l9_442=sc_AmbientLights[l9_439].intensity;
}
else
{
l9_442=0.0;
}
l9_438=l9_437+(((l9_441*l9_442)/vec3(3.1415901))*l9_293);
l9_437=l9_438;
l9_439++;
continue;
}
else
{
break;
}
}
l9_436=l9_437;
}
else
{
l9_436=l9_425;
}
vec3 l9_443=mix(l9_413,l9_413*l9_125.xyz,vec3(l9_125.w)).xyz+l9_436;
vec4 l9_444=vec4(l9_443.x,l9_443.y,l9_443.z,vec4(0.0).w);
l9_444.w=1.0-(max(max(l9_293.x,l9_293.y),l9_293.z)*0.15700001);
l9_292=l9_444;
}
#else
{
l9_292=vec4(0.0);
}
#endif
float l9_445;
vec3 l9_446;
float l9_447;
#if (ENABLE_CLEARCOAT)
{
float l9_448;
#if (ENABLE_CLEARCOAT_TEX)
{
vec2 l9_449=N3_getUV(Tweak_N44);
vec2 l9_450;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_CLEARCOAT_TEXTURE_TRANSFORM)!=0))
{
l9_450=N3_uvTransform(l9_449,clearcoatTexture_offset,clearcoatTexture_scale,clearcoatTexture_rotation);
}
else
{
l9_450=l9_449;
}
vec4 l9_451;
#if (clearcoatTextureLayout==2)
{
bool l9_452=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_clearcoatTexture)!=0));
float l9_453=l9_450.x;
sc_SoftwareWrapEarly(l9_453,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).x);
float l9_454=l9_453;
float l9_455=l9_450.y;
sc_SoftwareWrapEarly(l9_455,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).y);
float l9_456=l9_455;
vec2 l9_457;
float l9_458;
#if (SC_USE_UV_MIN_MAX_clearcoatTexture)
{
bool l9_459;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatTexture)
{
l9_459=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).x==3;
}
#else
{
l9_459=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture)!=0);
}
#endif
float l9_460=l9_454;
float l9_461=1.0;
sc_ClampUV(l9_460,clearcoatTextureUvMinMax.x,clearcoatTextureUvMinMax.z,l9_459,l9_461);
float l9_462=l9_460;
float l9_463=l9_461;
bool l9_464;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatTexture)
{
l9_464=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).y==3;
}
#else
{
l9_464=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture)!=0);
}
#endif
float l9_465=l9_456;
float l9_466=l9_463;
sc_ClampUV(l9_465,clearcoatTextureUvMinMax.y,clearcoatTextureUvMinMax.w,l9_464,l9_466);
l9_458=l9_466;
l9_457=vec2(l9_462,l9_465);
}
#else
{
l9_458=1.0;
l9_457=vec2(l9_454,l9_456);
}
#endif
vec2 l9_467=sc_TransformUV(l9_457,(int(SC_USE_UV_TRANSFORM_clearcoatTexture)!=0),clearcoatTextureTransform);
float l9_468=l9_467.x;
float l9_469=l9_458;
sc_SoftwareWrapLate(l9_468,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).x,l9_452,l9_469);
float l9_470=l9_467.y;
float l9_471=l9_469;
sc_SoftwareWrapLate(l9_470,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).y,l9_452,l9_471);
float l9_472=l9_471;
vec3 l9_473=sc_SamplingCoordsViewToGlobal(vec2(l9_468,l9_470),clearcoatTextureLayout,clearcoatTextureGetStereoViewIndex());
vec4 l9_474=texture(clearcoatTextureArrSC,l9_473,0.0);
vec4 l9_475;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatTexture)
{
l9_475=mix(clearcoatTextureBorderColor,l9_474,vec4(l9_472));
}
#else
{
l9_475=l9_474;
}
#endif
l9_451=l9_475;
}
#else
{
bool l9_476=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_clearcoatTexture)!=0));
float l9_477=l9_450.x;
sc_SoftwareWrapEarly(l9_477,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).x);
float l9_478=l9_477;
float l9_479=l9_450.y;
sc_SoftwareWrapEarly(l9_479,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).y);
float l9_480=l9_479;
vec2 l9_481;
float l9_482;
#if (SC_USE_UV_MIN_MAX_clearcoatTexture)
{
bool l9_483;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatTexture)
{
l9_483=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).x==3;
}
#else
{
l9_483=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture)!=0);
}
#endif
float l9_484=l9_478;
float l9_485=1.0;
sc_ClampUV(l9_484,clearcoatTextureUvMinMax.x,clearcoatTextureUvMinMax.z,l9_483,l9_485);
float l9_486=l9_484;
float l9_487=l9_485;
bool l9_488;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatTexture)
{
l9_488=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).y==3;
}
#else
{
l9_488=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture)!=0);
}
#endif
float l9_489=l9_480;
float l9_490=l9_487;
sc_ClampUV(l9_489,clearcoatTextureUvMinMax.y,clearcoatTextureUvMinMax.w,l9_488,l9_490);
l9_482=l9_490;
l9_481=vec2(l9_486,l9_489);
}
#else
{
l9_482=1.0;
l9_481=vec2(l9_478,l9_480);
}
#endif
vec2 l9_491=sc_TransformUV(l9_481,(int(SC_USE_UV_TRANSFORM_clearcoatTexture)!=0),clearcoatTextureTransform);
float l9_492=l9_491.x;
float l9_493=l9_482;
sc_SoftwareWrapLate(l9_492,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).x,l9_476,l9_493);
float l9_494=l9_491.y;
float l9_495=l9_493;
sc_SoftwareWrapLate(l9_494,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture).y,l9_476,l9_495);
float l9_496=l9_495;
vec3 l9_497=sc_SamplingCoordsViewToGlobal(vec2(l9_492,l9_494),clearcoatTextureLayout,clearcoatTextureGetStereoViewIndex());
vec4 l9_498=texture(clearcoatTexture,l9_497.xy,0.0);
vec4 l9_499;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatTexture)
{
l9_499=mix(clearcoatTextureBorderColor,l9_498,vec4(l9_496));
}
#else
{
l9_499=l9_498;
}
#endif
l9_451=l9_499;
}
#endif
l9_448=ssSRGB_to_Linear(l9_451.x);
}
#else
{
l9_448=1.0;
}
#endif
float l9_500=l9_448*clearcoatFactor;
float l9_501;
#if (ENABLE_CLEARCOAT_ROUGHNESS_TEX)
{
vec2 l9_502=N3_getUV(Tweak_N60);
vec2 l9_503;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM)!=0))
{
l9_503=N3_uvTransform(l9_502,clearcoatRoughnessTexture_offset,clearcoatRoughnessTexture_scale,clearcoatRoughnessTexture_rotation);
}
else
{
l9_503=l9_502;
}
vec4 l9_504;
#if (clearcoatRoughnessTextureLayout==2)
{
bool l9_505=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture)!=0));
float l9_506=l9_503.x;
sc_SoftwareWrapEarly(l9_506,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).x);
float l9_507=l9_506;
float l9_508=l9_503.y;
sc_SoftwareWrapEarly(l9_508,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).y);
float l9_509=l9_508;
vec2 l9_510;
float l9_511;
#if (SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture)
{
bool l9_512;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)
{
l9_512=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).x==3;
}
#else
{
l9_512=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)!=0);
}
#endif
float l9_513=l9_507;
float l9_514=1.0;
sc_ClampUV(l9_513,clearcoatRoughnessTextureUvMinMax.x,clearcoatRoughnessTextureUvMinMax.z,l9_512,l9_514);
float l9_515=l9_513;
float l9_516=l9_514;
bool l9_517;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)
{
l9_517=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).y==3;
}
#else
{
l9_517=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)!=0);
}
#endif
float l9_518=l9_509;
float l9_519=l9_516;
sc_ClampUV(l9_518,clearcoatRoughnessTextureUvMinMax.y,clearcoatRoughnessTextureUvMinMax.w,l9_517,l9_519);
l9_511=l9_519;
l9_510=vec2(l9_515,l9_518);
}
#else
{
l9_511=1.0;
l9_510=vec2(l9_507,l9_509);
}
#endif
vec2 l9_520=sc_TransformUV(l9_510,(int(SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture)!=0),clearcoatRoughnessTextureTransform);
float l9_521=l9_520.x;
float l9_522=l9_511;
sc_SoftwareWrapLate(l9_521,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).x,l9_505,l9_522);
float l9_523=l9_520.y;
float l9_524=l9_522;
sc_SoftwareWrapLate(l9_523,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).y,l9_505,l9_524);
float l9_525=l9_524;
vec3 l9_526=sc_SamplingCoordsViewToGlobal(vec2(l9_521,l9_523),clearcoatRoughnessTextureLayout,clearcoatRoughnessTextureGetStereoViewIndex());
vec4 l9_527=texture(clearcoatRoughnessTextureArrSC,l9_526,0.0);
vec4 l9_528;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)
{
l9_528=mix(clearcoatRoughnessTextureBorderColor,l9_527,vec4(l9_525));
}
#else
{
l9_528=l9_527;
}
#endif
l9_504=l9_528;
}
#else
{
bool l9_529=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture)!=0));
float l9_530=l9_503.x;
sc_SoftwareWrapEarly(l9_530,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).x);
float l9_531=l9_530;
float l9_532=l9_503.y;
sc_SoftwareWrapEarly(l9_532,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).y);
float l9_533=l9_532;
vec2 l9_534;
float l9_535;
#if (SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture)
{
bool l9_536;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)
{
l9_536=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).x==3;
}
#else
{
l9_536=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)!=0);
}
#endif
float l9_537=l9_531;
float l9_538=1.0;
sc_ClampUV(l9_537,clearcoatRoughnessTextureUvMinMax.x,clearcoatRoughnessTextureUvMinMax.z,l9_536,l9_538);
float l9_539=l9_537;
float l9_540=l9_538;
bool l9_541;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)
{
l9_541=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).y==3;
}
#else
{
l9_541=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)!=0);
}
#endif
float l9_542=l9_533;
float l9_543=l9_540;
sc_ClampUV(l9_542,clearcoatRoughnessTextureUvMinMax.y,clearcoatRoughnessTextureUvMinMax.w,l9_541,l9_543);
l9_535=l9_543;
l9_534=vec2(l9_539,l9_542);
}
#else
{
l9_535=1.0;
l9_534=vec2(l9_531,l9_533);
}
#endif
vec2 l9_544=sc_TransformUV(l9_534,(int(SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture)!=0),clearcoatRoughnessTextureTransform);
float l9_545=l9_544.x;
float l9_546=l9_535;
sc_SoftwareWrapLate(l9_545,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).x,l9_529,l9_546);
float l9_547=l9_544.y;
float l9_548=l9_546;
sc_SoftwareWrapLate(l9_547,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture).y,l9_529,l9_548);
float l9_549=l9_548;
vec3 l9_550=sc_SamplingCoordsViewToGlobal(vec2(l9_545,l9_547),clearcoatRoughnessTextureLayout,clearcoatRoughnessTextureGetStereoViewIndex());
vec4 l9_551=texture(clearcoatRoughnessTexture,l9_550.xy,0.0);
vec4 l9_552;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture)
{
l9_552=mix(clearcoatRoughnessTextureBorderColor,l9_551,vec4(l9_549));
}
#else
{
l9_552=l9_551;
}
#endif
l9_504=l9_552;
}
#endif
l9_501=ssSRGB_to_Linear(l9_504.y);
}
#else
{
l9_501=1.0;
}
#endif
float l9_553=l9_501*clearcoatRoughnessFactor;
vec3 l9_554;
#if (ENABLE_CLEARCOAT_NORMAL_TEX)
{
vec2 l9_555=N3_getUV(Tweak_N47);
vec2 l9_556;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM)!=0))
{
l9_556=N3_uvTransform(l9_555,clearcoatNormalTexture_offset,clearcoatNormalTexture_scale,clearcoatNormalTexture_rotation);
}
else
{
l9_556=l9_555;
}
vec4 l9_557;
#if (clearcoatNormalTextureLayout==2)
{
bool l9_558=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_clearcoatNormalTexture)!=0));
float l9_559=l9_556.x;
sc_SoftwareWrapEarly(l9_559,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).x);
float l9_560=l9_559;
float l9_561=l9_556.y;
sc_SoftwareWrapEarly(l9_561,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).y);
float l9_562=l9_561;
vec2 l9_563;
float l9_564;
#if (SC_USE_UV_MIN_MAX_clearcoatNormalTexture)
{
bool l9_565;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)
{
l9_565=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).x==3;
}
#else
{
l9_565=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)!=0);
}
#endif
float l9_566=l9_560;
float l9_567=1.0;
sc_ClampUV(l9_566,clearcoatNormalTextureUvMinMax.x,clearcoatNormalTextureUvMinMax.z,l9_565,l9_567);
float l9_568=l9_566;
float l9_569=l9_567;
bool l9_570;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)
{
l9_570=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).y==3;
}
#else
{
l9_570=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)!=0);
}
#endif
float l9_571=l9_562;
float l9_572=l9_569;
sc_ClampUV(l9_571,clearcoatNormalTextureUvMinMax.y,clearcoatNormalTextureUvMinMax.w,l9_570,l9_572);
l9_564=l9_572;
l9_563=vec2(l9_568,l9_571);
}
#else
{
l9_564=1.0;
l9_563=vec2(l9_560,l9_562);
}
#endif
vec2 l9_573=sc_TransformUV(l9_563,(int(SC_USE_UV_TRANSFORM_clearcoatNormalTexture)!=0),clearcoatNormalTextureTransform);
float l9_574=l9_573.x;
float l9_575=l9_564;
sc_SoftwareWrapLate(l9_574,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).x,l9_558,l9_575);
float l9_576=l9_573.y;
float l9_577=l9_575;
sc_SoftwareWrapLate(l9_576,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).y,l9_558,l9_577);
float l9_578=l9_577;
vec3 l9_579=sc_SamplingCoordsViewToGlobal(vec2(l9_574,l9_576),clearcoatNormalTextureLayout,clearcoatNormalTextureGetStereoViewIndex());
vec4 l9_580=texture(clearcoatNormalTextureArrSC,l9_579,0.0);
vec4 l9_581;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)
{
l9_581=mix(clearcoatNormalTextureBorderColor,l9_580,vec4(l9_578));
}
#else
{
l9_581=l9_580;
}
#endif
l9_557=l9_581;
}
#else
{
bool l9_582=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)!=0)&&(!(int(SC_USE_UV_MIN_MAX_clearcoatNormalTexture)!=0));
float l9_583=l9_556.x;
sc_SoftwareWrapEarly(l9_583,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).x);
float l9_584=l9_583;
float l9_585=l9_556.y;
sc_SoftwareWrapEarly(l9_585,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).y);
float l9_586=l9_585;
vec2 l9_587;
float l9_588;
#if (SC_USE_UV_MIN_MAX_clearcoatNormalTexture)
{
bool l9_589;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)
{
l9_589=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).x==3;
}
#else
{
l9_589=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)!=0);
}
#endif
float l9_590=l9_584;
float l9_591=1.0;
sc_ClampUV(l9_590,clearcoatNormalTextureUvMinMax.x,clearcoatNormalTextureUvMinMax.z,l9_589,l9_591);
float l9_592=l9_590;
float l9_593=l9_591;
bool l9_594;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)
{
l9_594=ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).y==3;
}
#else
{
l9_594=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)!=0);
}
#endif
float l9_595=l9_586;
float l9_596=l9_593;
sc_ClampUV(l9_595,clearcoatNormalTextureUvMinMax.y,clearcoatNormalTextureUvMinMax.w,l9_594,l9_596);
l9_588=l9_596;
l9_587=vec2(l9_592,l9_595);
}
#else
{
l9_588=1.0;
l9_587=vec2(l9_584,l9_586);
}
#endif
vec2 l9_597=sc_TransformUV(l9_587,(int(SC_USE_UV_TRANSFORM_clearcoatNormalTexture)!=0),clearcoatNormalTextureTransform);
float l9_598=l9_597.x;
float l9_599=l9_588;
sc_SoftwareWrapLate(l9_598,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).x,l9_582,l9_599);
float l9_600=l9_597.y;
float l9_601=l9_599;
sc_SoftwareWrapLate(l9_600,ivec2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture).y,l9_582,l9_601);
float l9_602=l9_601;
vec3 l9_603=sc_SamplingCoordsViewToGlobal(vec2(l9_598,l9_600),clearcoatNormalTextureLayout,clearcoatNormalTextureGetStereoViewIndex());
vec4 l9_604=texture(clearcoatNormalTexture,l9_603.xy,0.0);
vec4 l9_605;
#if (SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture)
{
l9_605=mix(clearcoatNormalTextureBorderColor,l9_604,vec4(l9_602));
}
#else
{
l9_605=l9_604;
}
#endif
l9_557=l9_605;
}
#endif
l9_554=l9_557.xyz*0.9921875;
}
#else
{
l9_554=vec3(0.0,0.0,1.0);
}
#endif
l9_447=l9_553;
l9_446=l9_554;
l9_445=l9_500;
}
#else
{
l9_447=0.0;
l9_446=vec3(0.0);
l9_445=0.0;
}
#endif
vec3 l9_606;
#if (!sc_ProjectiveShadowsCaster)
{
l9_606=l9_72;
}
#else
{
l9_606=vec3(0.0);
}
#endif
float l9_607=clamp(l9_290,0.0,1.0);
ngsAlphaTest(l9_607);
vec3 l9_608=max(l9_289,vec3(0.0));
vec4 l9_609;
#if (sc_ProjectiveShadowsCaster)
{
l9_609=vec4(l9_608,l9_607);
}
#else
{
l9_609=ngsCalculateLighting(l9_608,l9_607,l9_606,varPosAndMotion.xyz,l9_0,max(l9_291,vec3(0.0)),clamp(l9_124,0.0,1.0),clamp(l9_126,0.0,1.0),clamp(l9_125.xyz,vec3(0.0),vec3(1.0)),vec3(1.0));
}
#endif
vec4 l9_610=max(l9_609,vec4(0.0));
vec3 l9_611;
#if (!sc_ProjectiveShadowsCaster)
{
l9_611=mat3(l9_2,l9_3,l9_1)*l9_446;
}
#else
{
l9_611=vec3(0.0);
}
#endif
ngsAlphaTest(1.0);
vec4 l9_612;
#if (sc_ProjectiveShadowsCaster)
{
l9_612=vec4(0.0,0.0,0.0,1.0);
}
#else
{
l9_612=ngsCalculateLighting(vec3(0.0),1.0,l9_611,varPosAndMotion.xyz,l9_0,vec3(0.0),0.0,clamp(l9_447,0.0,1.0),vec3(1.0),vec3(1.0));
}
#endif
vec4 l9_613=max(l9_612,vec4(0.0));
tempGlobals=l9_6;
vec4 l9_614;
if (((int(ENABLE_SHEEN)!=0)||(int(ENABLE_TRANSMISSION)!=0))||(int(ENABLE_CLEARCOAT)!=0))
{
vec4 l9_615=ssSRGB_to_Linear(l9_610);
vec4 l9_616;
#if (ENABLE_SHEEN)
{
vec3 l9_617=(l9_615.xyz*l9_292.w)+l9_292.xyz;
l9_616=vec4(l9_617.x,l9_617.y,l9_617.z,l9_615.w);
}
#else
{
l9_616=l9_615;
}
#endif
vec4 l9_618;
#if (ENABLE_TRANSMISSION)
{
vec4 l9_619=mix(vec4(l9_183,1.0),l9_616,vec4(ssSRGB_to_Linear(l9_290)));
l9_619.w=1.0;
l9_618=l9_619;
}
#else
{
l9_618=l9_616;
}
#endif
vec4 l9_620;
#if (ENABLE_CLEARCOAT)
{
vec3 l9_621=l9_618.xyz+(ssSRGB_to_Linear(l9_613)*l9_445).xyz;
l9_620=vec4(l9_621.x,l9_621.y,l9_621.z,l9_618.w);
}
#else
{
l9_620=l9_618;
}
#endif
l9_614=ssLinear_to_SRGB(l9_620);
}
else
{
l9_614=l9_610;
}
l9_7=l9_614;
}
#else
{
float l9_622;
Node40_Bool_Parameter(l9_622,l9_6);
float l9_623;
Node121_Bool_Parameter(l9_623,l9_6);
float l9_624;
Node48_Bool_Parameter(l9_624,l9_6);
float l9_625;
Node88_Bool_Parameter(l9_625,l9_6);
tempGlobals=l9_6;
vec4 l9_626;
#if (ENABLE_BASE_TEX)
{
vec2 l9_627=N35_getUV(NODE_7_DROPLIST_ITEM);
vec2 l9_628;
if ((int(ENABLE_TEXTURE_TRANSFORM)!=0)&&(int(ENABLE_BASE_TEXTURE_TRANSFORM)!=0))
{
l9_628=N35_uvTransform(l9_627,baseColorTexture_offset,baseColorTexture_scale,baseColorTexture_rotation);
}
else
{
l9_628=l9_627;
}
l9_626=baseColorFactor*ssSRGB_to_Linear(N35_BaseTexture_sample(l9_628));
}
#else
{
l9_626=baseColorFactor;
}
#endif
vec4 l9_629;
#if (ENABLE_VERTEX_COLOR_BASE)
{
l9_629=l9_626*tempGlobals.VertexColor;
}
#else
{
l9_629=l9_626;
}
#endif
l9_7=ssLinear_to_SRGB(l9_629);
}
#endif
vec4 l9_630;
#if (sc_ProjectiveShadowsCaster)
{
float l9_631;
#if ((((sc_BlendMode==0)||(sc_BlendMode==5))||(sc_BlendMode==14))||(sc_BlendMode==16))
{
l9_631=l9_7.w;
}
#else
{
float l9_632;
#if (sc_BlendMode==4)
{
l9_632=clamp(l9_7.w*2.0,0.0,1.0);
}
#else
{
float l9_633;
#if (sc_BlendMode==8)
{
l9_633=1.0;
}
#else
{
float l9_634;
#if (sc_BlendMode==1)
{
l9_634=(1.0-dot(l9_7.xyz,vec3(0.33333001)))*l9_7.w;
}
#else
{
float l9_635;
#if (sc_BlendMode==10)
{
l9_635=(1.0-clamp(dot(l9_7.xyz,vec3(1.0)),0.0,1.0))*l9_7.w;
}
#else
{
float l9_636;
#if (sc_BlendMode==9)
{
l9_636=clamp(dot(l9_7.xyz,vec3(1.0)),0.0,1.0)*l9_7.w;
}
#else
{
float l9_637;
#if (sc_BlendMode==2)
{
l9_637=clamp(dot(l9_7.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_638;
#if (sc_BlendMode==7)
{
l9_638=clamp(dot(l9_7.xyz,vec3(1.0)),0.0,1.0)*l9_7.w;
}
#else
{
float l9_639;
#if (sc_BlendMode==3)
{
l9_639=dot(l9_7.xyz,vec3(0.33333001))*l9_7.w;
}
#else
{
float l9_640;
#if (sc_BlendMode==11)
{
l9_640=1.0-clamp(dot(l9_7.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
float l9_641;
#if (sc_BlendMode==12)
{
l9_641=clamp(dot(l9_7.xyz,vec3(1.0)),0.0,1.0);
}
#else
{
l9_641=1.0;
}
#endif
l9_640=l9_641;
}
#endif
l9_639=l9_640;
}
#endif
l9_638=l9_639;
}
#endif
l9_637=l9_638;
}
#endif
l9_636=l9_637;
}
#endif
l9_635=l9_636;
}
#endif
l9_634=l9_635;
}
#endif
l9_633=l9_634;
}
#endif
l9_632=l9_633;
}
#endif
l9_631=l9_632;
}
#endif
l9_630=vec4(mix(sc_ShadowColor.xyz,sc_ShadowColor.xyz*l9_7.xyz,vec3(sc_ShadowColor.w)),sc_ShadowDensity*l9_631);
}
#else
{
vec4 l9_642;
#if (sc_RenderAlphaToColor)
{
l9_642=vec4(l9_7.w);
}
#else
{
vec4 l9_643;
#if (sc_BlendMode_Custom)
{
vec3 l9_644=sc_GetFramebufferColor().xyz;
vec3 l9_645=mix(l9_644,definedBlend(l9_644,l9_7.xyz).xyz,vec3(l9_7.w));
vec4 l9_646=vec4(l9_645.x,l9_645.y,l9_645.z,vec4(0.0).w);
l9_646.w=1.0;
l9_643=l9_646;
}
#else
{
vec4 l9_647;
#if (sc_Voxelization)
{
l9_647=vec4(varScreenPos.xyz,1.0);
}
#else
{
vec4 l9_648;
#if (sc_OutputBounds)
{
float l9_649=clamp(abs(gl_FragCoord.z),0.0,1.0);
l9_648=vec4(l9_649,1.0-l9_649,1.0,1.0);
}
#else
{
vec4 l9_650;
#if (sc_BlendMode==10)
{
l9_650=vec4(mix(vec3(1.0),l9_7.xyz,vec3(l9_7.w)),l9_7.w);
}
#else
{
vec4 l9_651;
#if ((sc_BlendMode==3)||(sc_BlendMode==16))
{
float l9_652;
#if (sc_BlendMode==16)
{
l9_652=clamp(l9_7.w,0.0,1.0);
}
#else
{
l9_652=l9_7.w;
}
#endif
l9_651=vec4(l9_7.xyz*l9_652,l9_652);
}
#else
{
l9_651=l9_7;
}
#endif
l9_650=l9_651;
}
#endif
l9_648=l9_650;
}
#endif
l9_647=l9_648;
}
#endif
l9_643=l9_647;
}
#endif
l9_642=l9_643;
}
#endif
l9_630=l9_642;
}
#endif
vec4 l9_653=sc_OutputMotionVectorIfNeeded(max(l9_630,vec4(0.0)));
vec4 l9_654=clamp(l9_653,vec4(0.0),vec4(1.0));
#if (sc_OITDepthBoundsPass)
{
#if (sc_OITDepthBoundsPass)
{
float l9_655=clamp(viewSpaceDepth()/1000.0,0.0,1.0);
sc_writeFragData0(vec4(max(0.0,1.0-(l9_655-0.0039215689)),min(1.0,l9_655+0.0039215689),0.0,0.0));
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
vec2 l9_656=sc_ScreenCoordsGlobalToView(l9_4);
#if (sc_OITMaxLayers4Plus1)
{
if ((gl_FragCoord.z-texture(sc_OITFrontDepthTexture,l9_656).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int l9_657=encodeDepth(viewSpaceDepth(),texture(sc_OITFilteredDepthBoundsTexture,l9_656).xy);
float l9_658=packValue(l9_657);
int l9_665=int(l9_654.w*255.0);
float l9_666=packValue(l9_665);
sc_writeFragData0(vec4(packValue(l9_657),packValue(l9_657),packValue(l9_657),packValue(l9_657)));
}
#endif
}
#else
{
#if (sc_OITCompositingPass)
{
#if (sc_OITCompositingPass)
{
vec2 l9_669=sc_ScreenCoordsGlobalToView(l9_4);
#if (sc_OITMaxLayers4Plus1)
{
if ((gl_FragCoord.z-texture(sc_OITFrontDepthTexture,l9_669).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int l9_670[8];
int l9_671[8];
int l9_672=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_672<8)
{
l9_670[l9_672]=0;
l9_671[l9_672]=0;
l9_672++;
continue;
}
else
{
break;
}
}
int l9_673;
#if (sc_OITMaxLayers8)
{
l9_673=2;
}
#else
{
l9_673=1;
}
#endif
int l9_674=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_674<l9_673)
{
vec4 l9_675;
vec4 l9_676;
vec4 l9_677;
if (l9_674==0)
{
l9_677=texture(sc_OITAlpha0,l9_669);
l9_676=texture(sc_OITDepthLow0,l9_669);
l9_675=texture(sc_OITDepthHigh0,l9_669);
}
else
{
l9_677=vec4(0.0);
l9_676=vec4(0.0);
l9_675=vec4(0.0);
}
vec4 l9_678;
vec4 l9_679;
vec4 l9_680;
if (l9_674==1)
{
l9_680=texture(sc_OITAlpha1,l9_669);
l9_679=texture(sc_OITDepthLow1,l9_669);
l9_678=texture(sc_OITDepthHigh1,l9_669);
}
else
{
l9_680=l9_677;
l9_679=l9_676;
l9_678=l9_675;
}
if (any(notEqual(l9_678,vec4(0.0)))||any(notEqual(l9_679,vec4(0.0))))
{
int l9_681[8]=l9_670;
unpackValues(l9_678.w,l9_674,l9_681);
unpackValues(l9_678.z,l9_674,l9_681);
unpackValues(l9_678.y,l9_674,l9_681);
unpackValues(l9_678.x,l9_674,l9_681);
unpackValues(l9_679.w,l9_674,l9_681);
unpackValues(l9_679.z,l9_674,l9_681);
unpackValues(l9_679.y,l9_674,l9_681);
unpackValues(l9_679.x,l9_674,l9_681);
int l9_690[8]=l9_671;
unpackValues(l9_680.w,l9_674,l9_690);
unpackValues(l9_680.z,l9_674,l9_690);
unpackValues(l9_680.y,l9_674,l9_690);
unpackValues(l9_680.x,l9_674,l9_690);
}
l9_674++;
continue;
}
else
{
break;
}
}
mediump vec4 l9_695=texture(sc_OITFilteredDepthBoundsTexture,l9_669);
vec2 l9_696=l9_695.xy;
int l9_697;
#if (sc_SkinBonesCount>0)
{
l9_697=encodeDepth(((1.0-l9_695.x)*1000.0)+getDepthOrderingEpsilon(),l9_696);
}
#else
{
l9_697=0;
}
#endif
int l9_698=encodeDepth(viewSpaceDepth(),l9_696);
vec4 l9_699;
l9_699=l9_654*l9_654.w;
vec4 l9_700;
int l9_701=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_701<8)
{
int l9_702=l9_670[l9_701];
int l9_703=l9_698-l9_697;
bool l9_704=l9_702<l9_703;
bool l9_705;
if (l9_704)
{
l9_705=l9_670[l9_701]>0;
}
else
{
l9_705=l9_704;
}
if (l9_705)
{
vec3 l9_706=l9_699.xyz*(1.0-(float(l9_671[l9_701])/255.0));
l9_700=vec4(l9_706.x,l9_706.y,l9_706.z,l9_699.w);
}
else
{
l9_700=l9_699;
}
l9_699=l9_700;
l9_701++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(l9_699);
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
if (abs(gl_FragCoord.z-texture(sc_OITFrontDepthTexture,sc_ScreenCoordsGlobalToView(l9_4)).x)>getFrontLayerZTestEpsilon())
{
discard;
}
sc_writeFragData0(l9_654);
}
#endif
}
#else
{
sc_writeFragData0(l9_653);
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
