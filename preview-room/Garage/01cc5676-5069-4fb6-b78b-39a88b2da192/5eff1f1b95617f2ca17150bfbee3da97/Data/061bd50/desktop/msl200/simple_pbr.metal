#pragma clang diagnostic ignored "-Wmissing-prototypes"
#include <metal_stdlib>
#include <simd/simd.h>
using namespace metal;
namespace SNAP_VS {
int sc_GetStereoViewIndex()
{
return 0;
}
}
#ifndef sc_TextureRenderingLayout_Regular
#define sc_TextureRenderingLayout_Regular 0
#define sc_TextureRenderingLayout_StereoInstancedClipped 1
#define sc_TextureRenderingLayout_StereoMultiview 2
#endif
constant bool ENABLE_STIPPLE_PATTERN_TEST [[function_constant(0)]];
constant bool ENABLE_STIPPLE_PATTERN_TEST_tmp = is_function_constant_defined(ENABLE_STIPPLE_PATTERN_TEST) ? ENABLE_STIPPLE_PATTERN_TEST : false;
constant bool SC_USE_CLAMP_TO_BORDER_baseTex [[function_constant(1)]];
constant bool SC_USE_CLAMP_TO_BORDER_baseTex_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_baseTex) ? SC_USE_CLAMP_TO_BORDER_baseTex : false;
constant bool SC_USE_CLAMP_TO_BORDER_intensityTexture [[function_constant(2)]];
constant bool SC_USE_CLAMP_TO_BORDER_intensityTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_intensityTexture) ? SC_USE_CLAMP_TO_BORDER_intensityTexture : false;
constant bool SC_USE_UV_MIN_MAX_baseTex [[function_constant(3)]];
constant bool SC_USE_UV_MIN_MAX_baseTex_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_baseTex) ? SC_USE_UV_MIN_MAX_baseTex : false;
constant bool SC_USE_UV_MIN_MAX_intensityTexture [[function_constant(4)]];
constant bool SC_USE_UV_MIN_MAX_intensityTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_intensityTexture) ? SC_USE_UV_MIN_MAX_intensityTexture : false;
constant bool SC_USE_UV_TRANSFORM_baseTex [[function_constant(5)]];
constant bool SC_USE_UV_TRANSFORM_baseTex_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_baseTex) ? SC_USE_UV_TRANSFORM_baseTex : false;
constant bool SC_USE_UV_TRANSFORM_intensityTexture [[function_constant(6)]];
constant bool SC_USE_UV_TRANSFORM_intensityTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_intensityTexture) ? SC_USE_UV_TRANSFORM_intensityTexture : false;
constant bool UseViewSpaceDepthVariant [[function_constant(7)]];
constant bool UseViewSpaceDepthVariant_tmp = is_function_constant_defined(UseViewSpaceDepthVariant) ? UseViewSpaceDepthVariant : true;
constant bool baseTexHasSwappedViews [[function_constant(8)]];
constant bool baseTexHasSwappedViews_tmp = is_function_constant_defined(baseTexHasSwappedViews) ? baseTexHasSwappedViews : false;
constant bool intensityTextureHasSwappedViews [[function_constant(9)]];
constant bool intensityTextureHasSwappedViews_tmp = is_function_constant_defined(intensityTextureHasSwappedViews) ? intensityTextureHasSwappedViews : false;
constant bool sc_BlendMode_Custom [[function_constant(10)]];
constant bool sc_BlendMode_Custom_tmp = is_function_constant_defined(sc_BlendMode_Custom) ? sc_BlendMode_Custom : false;
constant bool sc_DepthOnly [[function_constant(11)]];
constant bool sc_DepthOnly_tmp = is_function_constant_defined(sc_DepthOnly) ? sc_DepthOnly : false;
constant bool sc_EnvmapDiffuseHasSwappedViews [[function_constant(12)]];
constant bool sc_EnvmapDiffuseHasSwappedViews_tmp = is_function_constant_defined(sc_EnvmapDiffuseHasSwappedViews) ? sc_EnvmapDiffuseHasSwappedViews : false;
constant bool sc_EnvmapSpecularHasSwappedViews [[function_constant(13)]];
constant bool sc_EnvmapSpecularHasSwappedViews_tmp = is_function_constant_defined(sc_EnvmapSpecularHasSwappedViews) ? sc_EnvmapSpecularHasSwappedViews : false;
constant bool sc_FramebufferFetch [[function_constant(14)]];
constant bool sc_FramebufferFetch_tmp = is_function_constant_defined(sc_FramebufferFetch) ? sc_FramebufferFetch : false;
constant bool sc_HasDiffuseEnvmap [[function_constant(15)]];
constant bool sc_HasDiffuseEnvmap_tmp = is_function_constant_defined(sc_HasDiffuseEnvmap) ? sc_HasDiffuseEnvmap : false;
constant bool sc_HasSpecularCubemap [[function_constant(16)]];
constant bool sc_HasSpecularCubemap_tmp = is_function_constant_defined(sc_HasSpecularCubemap) ? sc_HasSpecularCubemap : false;
constant bool sc_LightEstimation [[function_constant(17)]];
constant bool sc_LightEstimation_tmp = is_function_constant_defined(sc_LightEstimation) ? sc_LightEstimation : false;
constant bool sc_MotionVectorsPass [[function_constant(18)]];
constant bool sc_MotionVectorsPass_tmp = is_function_constant_defined(sc_MotionVectorsPass) ? sc_MotionVectorsPass : false;
constant bool sc_OITCompositingPass [[function_constant(19)]];
constant bool sc_OITCompositingPass_tmp = is_function_constant_defined(sc_OITCompositingPass) ? sc_OITCompositingPass : false;
constant bool sc_OITDepthBoundsPass [[function_constant(20)]];
constant bool sc_OITDepthBoundsPass_tmp = is_function_constant_defined(sc_OITDepthBoundsPass) ? sc_OITDepthBoundsPass : false;
constant bool sc_OITDepthGatherPass [[function_constant(21)]];
constant bool sc_OITDepthGatherPass_tmp = is_function_constant_defined(sc_OITDepthGatherPass) ? sc_OITDepthGatherPass : false;
constant bool sc_OutputBounds [[function_constant(22)]];
constant bool sc_OutputBounds_tmp = is_function_constant_defined(sc_OutputBounds) ? sc_OutputBounds : false;
constant bool sc_ProjectiveShadowsCaster [[function_constant(23)]];
constant bool sc_ProjectiveShadowsCaster_tmp = is_function_constant_defined(sc_ProjectiveShadowsCaster) ? sc_ProjectiveShadowsCaster : false;
constant bool sc_ProjectiveShadowsReceiver [[function_constant(24)]];
constant bool sc_ProjectiveShadowsReceiver_tmp = is_function_constant_defined(sc_ProjectiveShadowsReceiver) ? sc_ProjectiveShadowsReceiver : false;
constant bool sc_RenderAlphaToColor [[function_constant(25)]];
constant bool sc_RenderAlphaToColor_tmp = is_function_constant_defined(sc_RenderAlphaToColor) ? sc_RenderAlphaToColor : false;
constant bool sc_SSAOEnabled [[function_constant(26)]];
constant bool sc_SSAOEnabled_tmp = is_function_constant_defined(sc_SSAOEnabled) ? sc_SSAOEnabled : false;
constant bool sc_ScreenTextureHasSwappedViews [[function_constant(27)]];
constant bool sc_ScreenTextureHasSwappedViews_tmp = is_function_constant_defined(sc_ScreenTextureHasSwappedViews) ? sc_ScreenTextureHasSwappedViews : false;
constant bool sc_ShadowMapHardwarePCF [[function_constant(28)]];
constant bool sc_ShadowMapHardwarePCF_tmp = is_function_constant_defined(sc_ShadowMapHardwarePCF) ? sc_ShadowMapHardwarePCF : false;
constant bool sc_ShadowMapIsRandomSampling [[function_constant(29)]];
constant bool sc_ShadowMapIsRandomSampling_tmp = is_function_constant_defined(sc_ShadowMapIsRandomSampling) ? sc_ShadowMapIsRandomSampling : false;
constant bool sc_ShadowMapIsSoftShadow [[function_constant(30)]];
constant bool sc_ShadowMapIsSoftShadow_tmp = is_function_constant_defined(sc_ShadowMapIsSoftShadow) ? sc_ShadowMapIsSoftShadow : false;
constant bool sc_ShadowMapReceiver [[function_constant(31)]];
constant bool sc_ShadowMapReceiver_tmp = is_function_constant_defined(sc_ShadowMapReceiver) ? sc_ShadowMapReceiver : false;
constant bool sc_TAAEnabled [[function_constant(32)]];
constant bool sc_TAAEnabled_tmp = is_function_constant_defined(sc_TAAEnabled) ? sc_TAAEnabled : false;
constant bool sc_VertexBlendingUseNormals [[function_constant(33)]];
constant bool sc_VertexBlendingUseNormals_tmp = is_function_constant_defined(sc_VertexBlendingUseNormals) ? sc_VertexBlendingUseNormals : false;
constant bool sc_VertexBlending [[function_constant(34)]];
constant bool sc_VertexBlending_tmp = is_function_constant_defined(sc_VertexBlending) ? sc_VertexBlending : false;
constant bool sc_Voxelization [[function_constant(35)]];
constant bool sc_Voxelization_tmp = is_function_constant_defined(sc_Voxelization) ? sc_Voxelization : false;
constant int SC_DEVICE_CLASS [[function_constant(36)]];
constant int SC_DEVICE_CLASS_tmp = is_function_constant_defined(SC_DEVICE_CLASS) ? SC_DEVICE_CLASS : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_baseTex [[function_constant(37)]];
constant int SC_SOFTWARE_WRAP_MODE_U_baseTex_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_baseTex) ? SC_SOFTWARE_WRAP_MODE_U_baseTex : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_intensityTexture [[function_constant(38)]];
constant int SC_SOFTWARE_WRAP_MODE_U_intensityTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_intensityTexture) ? SC_SOFTWARE_WRAP_MODE_U_intensityTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_baseTex [[function_constant(39)]];
constant int SC_SOFTWARE_WRAP_MODE_V_baseTex_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_baseTex) ? SC_SOFTWARE_WRAP_MODE_V_baseTex : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_intensityTexture [[function_constant(40)]];
constant int SC_SOFTWARE_WRAP_MODE_V_intensityTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_intensityTexture) ? SC_SOFTWARE_WRAP_MODE_V_intensityTexture : -1;
constant int baseTexLayout [[function_constant(41)]];
constant int baseTexLayout_tmp = is_function_constant_defined(baseTexLayout) ? baseTexLayout : 0;
constant int intensityTextureLayout [[function_constant(42)]];
constant int intensityTextureLayout_tmp = is_function_constant_defined(intensityTextureLayout) ? intensityTextureLayout : 0;
constant int sc_AmbientLightMode0 [[function_constant(43)]];
constant int sc_AmbientLightMode0_tmp = is_function_constant_defined(sc_AmbientLightMode0) ? sc_AmbientLightMode0 : 0;
constant int sc_AmbientLightMode1 [[function_constant(44)]];
constant int sc_AmbientLightMode1_tmp = is_function_constant_defined(sc_AmbientLightMode1) ? sc_AmbientLightMode1 : 0;
constant int sc_AmbientLightMode2 [[function_constant(45)]];
constant int sc_AmbientLightMode2_tmp = is_function_constant_defined(sc_AmbientLightMode2) ? sc_AmbientLightMode2 : 0;
constant int sc_AmbientLightMode_Constant [[function_constant(46)]];
constant int sc_AmbientLightMode_Constant_tmp = is_function_constant_defined(sc_AmbientLightMode_Constant) ? sc_AmbientLightMode_Constant : 0;
constant int sc_AmbientLightMode_EnvironmentMap [[function_constant(47)]];
constant int sc_AmbientLightMode_EnvironmentMap_tmp = is_function_constant_defined(sc_AmbientLightMode_EnvironmentMap) ? sc_AmbientLightMode_EnvironmentMap : 0;
constant int sc_AmbientLightMode_FromCamera [[function_constant(48)]];
constant int sc_AmbientLightMode_FromCamera_tmp = is_function_constant_defined(sc_AmbientLightMode_FromCamera) ? sc_AmbientLightMode_FromCamera : 0;
constant int sc_AmbientLightMode_SphericalHarmonics [[function_constant(49)]];
constant int sc_AmbientLightMode_SphericalHarmonics_tmp = is_function_constant_defined(sc_AmbientLightMode_SphericalHarmonics) ? sc_AmbientLightMode_SphericalHarmonics : 0;
constant int sc_AmbientLightsCount [[function_constant(50)]];
constant int sc_AmbientLightsCount_tmp = is_function_constant_defined(sc_AmbientLightsCount) ? sc_AmbientLightsCount : 0;
constant int sc_BlendMode [[function_constant(51)]];
constant int sc_BlendMode_tmp = is_function_constant_defined(sc_BlendMode) ? sc_BlendMode : 0;
constant int sc_DepthBufferMode [[function_constant(52)]];
constant int sc_DepthBufferMode_tmp = is_function_constant_defined(sc_DepthBufferMode) ? sc_DepthBufferMode : 0;
constant int sc_DirectionalLightsCount [[function_constant(53)]];
constant int sc_DirectionalLightsCount_tmp = is_function_constant_defined(sc_DirectionalLightsCount) ? sc_DirectionalLightsCount : 0;
constant int sc_EnvLightMode [[function_constant(54)]];
constant int sc_EnvLightMode_tmp = is_function_constant_defined(sc_EnvLightMode) ? sc_EnvLightMode : 0;
constant int sc_EnvmapDiffuseLayout [[function_constant(55)]];
constant int sc_EnvmapDiffuseLayout_tmp = is_function_constant_defined(sc_EnvmapDiffuseLayout) ? sc_EnvmapDiffuseLayout : 0;
constant int sc_EnvmapSpecularLayout [[function_constant(56)]];
constant int sc_EnvmapSpecularLayout_tmp = is_function_constant_defined(sc_EnvmapSpecularLayout) ? sc_EnvmapSpecularLayout : 0;
constant int sc_LightEstimationSGCount [[function_constant(57)]];
constant int sc_LightEstimationSGCount_tmp = is_function_constant_defined(sc_LightEstimationSGCount) ? sc_LightEstimationSGCount : 0;
constant int sc_PointLightsCount [[function_constant(58)]];
constant int sc_PointLightsCount_tmp = is_function_constant_defined(sc_PointLightsCount) ? sc_PointLightsCount : 0;
constant int sc_RenderingSpace [[function_constant(59)]];
constant int sc_RenderingSpace_tmp = is_function_constant_defined(sc_RenderingSpace) ? sc_RenderingSpace : -1;
constant int sc_ScreenTextureLayout [[function_constant(60)]];
constant int sc_ScreenTextureLayout_tmp = is_function_constant_defined(sc_ScreenTextureLayout) ? sc_ScreenTextureLayout : 0;
constant int sc_ShaderCacheConstant [[function_constant(61)]];
constant int sc_ShaderCacheConstant_tmp = is_function_constant_defined(sc_ShaderCacheConstant) ? sc_ShaderCacheConstant : 0;
constant int sc_ShadowMapSampleCount [[function_constant(62)]];
constant int sc_ShadowMapSampleCount_tmp = is_function_constant_defined(sc_ShadowMapSampleCount) ? sc_ShadowMapSampleCount : 16;
constant int sc_SkinBonesCount [[function_constant(63)]];
constant int sc_SkinBonesCount_tmp = is_function_constant_defined(sc_SkinBonesCount) ? sc_SkinBonesCount : 0;
constant int sc_SoftwareBlendMode [[function_constant(64)]];
constant int sc_SoftwareBlendMode_tmp = is_function_constant_defined(sc_SoftwareBlendMode) ? sc_SoftwareBlendMode : 0;
constant int sc_StereoRenderingMode [[function_constant(65)]];
constant int sc_StereoRenderingMode_tmp = is_function_constant_defined(sc_StereoRenderingMode) ? sc_StereoRenderingMode : 0;
constant int sc_StereoRendering_IsClipDistanceEnabled [[function_constant(66)]];
constant int sc_StereoRendering_IsClipDistanceEnabled_tmp = is_function_constant_defined(sc_StereoRendering_IsClipDistanceEnabled) ? sc_StereoRendering_IsClipDistanceEnabled : 0;

namespace SNAP_VS {
struct sc_Vertex_t
{
float4 position;
float3 normal;
float3 tangent;
float2 texture0;
float2 texture1;
};
struct sc_DrawCallUBO_obj
{
float4x4 sc_ModelMatrix;
float4x4 sc_ModelMatrixInverse;
float3x3 sc_NormalMatrix;
float4x4 sc_PrevFrameModelMatrix;
float sc_ShadowDensity;
float4 sc_ShadowColor;
float4x4 sc_ProjectorMatrix;
float4 weights0;
float4 weights1;
int sc_ViewMask;
};
struct ShadowMapParams_t
{
float4x4 params;
float4x4 lightSpaceMatrix;
float4x4 invLightSpaceMatrix;
};
struct userUniformsObj
{
ShadowMapParams_t sc_ShadowMapParams[1];
float2 sc_TAAJitterOffset;
float4 sc_ShadowMapTextureSize;
float4 voxelization_params_0;
float4 voxelization_params_frustum_lrbt;
float4 voxelization_params_frustum_nf;
float3 voxelization_params_camera_pos;
float4x4 sc_ModelMatrixVoxelization;
float correctedIntensity;
float3x3 intensityTextureTransform;
float4 intensityTextureUvMinMax;
float4 intensityTextureBorderColor;
int PreviewEnabled;
float alphaTestThreshold;
float4 baseColor;
float3x3 baseTexTransform;
float4 baseTexUvMinMax;
float4 baseTexBorderColor;
float metallic;
float roughness;
float3 Port_Normal_N006;
float3 Port_Emissive_N006;
float3 Port_AO_N006;
float3 Port_SpecularAO_N006;
};
struct sc_Camera_t
{
float3 position;
float aspect;
float2 clipPlanes;
};
struct sc_CameraUBO_obj
{
float4 sc_Time;
float4 sc_UniformConstants;
float4x4 sc_ViewProjectionMatrixArray[4];
float4x4 sc_ViewProjectionMatrixInverseArray[4];
float4x4 sc_ProjectionMatrixArray[4];
float4x4 sc_ProjectionMatrixInverseArray[4];
float4x4 sc_ViewMatrixArray[4];
float4x4 sc_ViewMatrixInverseArray[4];
float4x4 sc_PrevFrameViewProjectionMatrixArray[4];
float4 sc_CurrentRenderTargetDims;
float4 sc_WindowToViewportTransform;
float4 sc_StereoClipPlanes[2];
sc_Camera_t sc_Camera;
};
struct sc_Bone_t
{
float4 boneMatrix[3];
float4 normalMatrix[3];
};
struct sc_BonesUBO_obj
{
sc_Bone_t sc_Bones[1];
};
struct ssPreviewInfo
{
float4 Color;
bool Saved;
};
struct sc_PointLight_t
{
float falloffRangeSqr;
float falloffRangeNegInvSqrSqr;
float angleScale;
float angleOffset;
float3 direction;
float3 position;
float4 color;
int shadowMapParamsIndex;
};
struct sc_DirectionalLight_t
{
float3 direction;
float4 color;
int shadowMapParamsIndex;
};
struct sc_AmbientLight_t
{
float3 color;
float intensity;
};
struct sc_SphericalGaussianLight_t
{
float3 color;
float sharpness;
float3 axis;
};
struct sc_LightEstimationData_t
{
sc_SphericalGaussianLight_t sg[12];
float3 ambientLight;
};
struct sc_LightingUBO_obj
{
sc_PointLight_t sc_PointLights[5];
sc_DirectionalLight_t sc_DirectionalLights[3];
sc_AmbientLight_t sc_AmbientLights[3];
sc_LightEstimationData_t sc_LightEstimationData;
float3 sc_EnvmapRotation;
float2 sc_EnvmapRotationSinCos;
float sc_EnvmapExposure;
float3 sc_Sh[9];
float sc_ShIntensity;
float4 sc_EnvmapDiffuseSize;
float4 sc_EnvmapDiffuseDims;
float4 sc_EnvmapDiffuseView;
float4 sc_EnvmapSpecularSize;
float4 sc_EnvmapSpecularDims;
float4 sc_EnvmapSpecularView;
float4 sc_SpecularCubemapSize;
};
struct sc_Set0
{
constant userUniformsObj* UserUniforms [[id(0)]];
texture2d<float> baseTex [[id(1)]];
texture2d<float> intensityTexture [[id(2)]];
texture2d<float> sc_EnvmapDiffuse [[id(3)]];
texture2d<float> sc_EnvmapSpecular [[id(4)]];
texture2d<float> sc_SSAOTexture [[id(13)]];
texture2d<float> sc_ScreenTexture [[id(14)]];
depth2d<float> sc_ShadowMapTexture [[id(16)]];
texture2d<float> sc_ShadowTexture [[id(17)]];
texturecube<float> sc_SpecularCubemap [[id(18)]];
sampler baseTexSmpSC [[id(20)]];
sampler intensityTextureSmpSC [[id(21)]];
sampler sc_EnvmapDiffuseSmpSC [[id(22)]];
sampler sc_EnvmapSpecularSmpSC [[id(23)]];
sampler sc_SSAOTextureSmpSC [[id(25)]];
sampler sc_ScreenTextureSmpSC [[id(26)]];
sampler sc_ShadowMapTextureSmpSC [[id(28)]];
sampler sc_ShadowTextureSmpSC [[id(29)]];
sampler sc_SpecularCubemapSmpSC [[id(30)]];
};
struct sc_Set1
{
constant sc_LightingUBO_obj* sc_LightingUBO [[id(0)]];
constant sc_CameraUBO_obj* sc_CameraUBO [[id(1)]];
};
struct sc_Set2
{
constant sc_DrawCallUBO_obj* sc_DrawCallUBO [[id(3)]];
constant sc_BonesUBO_obj* sc_BonesUBO [[id(6)]];
};
struct main_vert_out
{
float4 varPosAndMotion [[user(locn0)]];
float4 varNormalAndMotion [[user(locn1)]];
float4 varTangent [[user(locn2)]];
float4 varTex01 [[user(locn3)]];
float4 varScreenPos [[user(locn4)]];
float2 varScreenTexturePos [[user(locn5)]];
float varViewSpaceDepth [[user(locn6)]];
float2 varShadowTex [[user(locn7)]];
int varStereoViewID [[user(locn8)]];
float varClipDistance [[user(locn9)]];
float4 varColor [[user(locn10)]];
float4 PreviewVertexColor [[user(locn11)]];
float PreviewVertexSaved [[user(locn12)]];
float4 gl_Position [[position]];
};
struct main_vert_in
{
float4 position [[attribute(0)]];
float3 normal [[attribute(1)]];
float4 tangent [[attribute(2)]];
float2 texture0 [[attribute(3)]];
float2 texture1 [[attribute(4)]];
float4 boneData [[attribute(5)]];
float3 blendShape0Pos [[attribute(6)]];
float3 blendShape1Pos [[attribute(7)]];
float3 blendShape2Pos [[attribute(8)]];
float3 blendShape3Pos [[attribute(9)]];
float3 blendShape4Pos [[attribute(10)]];
float3 blendShape5Pos [[attribute(11)]];
float3 blendShape0Normal [[attribute(12)]];
float3 blendShape1Normal [[attribute(13)]];
float3 blendShape2Normal [[attribute(14)]];
float3 positionNext [[attribute(15)]];
float3 positionPrevious [[attribute(16)]];
float4 strandProperties [[attribute(17)]];
float4 color [[attribute(18)]];
};
int sc_GetLocalInstanceID(thread uint& gl_InstanceIndex)
{
if (sc_StereoRenderingMode_tmp==1)
{
return gl_InstanceIndex/2;
}
else
{
return gl_InstanceIndex;
}
}
void sc_SetClipPosition(thread float4& clipPosition,thread uint& gl_InstanceIndex,thread float4& gl_Position,constant sc_DrawCallUBO_obj& sc_DrawCallUBO,constant sc_CameraUBO_obj& sc_CameraUBO,thread float& varClipDistance,thread int& varStereoViewID)
{
if (sc_ShaderCacheConstant_tmp!=0)
{
clipPosition.x+=(sc_CameraUBO.sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
if (sc_StereoRenderingMode_tmp>0)
{
if ((sc_DrawCallUBO.sc_ViewMask&(1<<(gl_InstanceIndex%2)))==0)
{
gl_Position=float4(0.0,0.0,-2.0,1.0);
return;
}
varStereoViewID=gl_InstanceIndex%2;
}
float4 param=clipPosition;
if (sc_StereoRenderingMode_tmp==1)
{
float l9_1=dot(param,sc_CameraUBO.sc_StereoClipPlanes[gl_InstanceIndex%2]);
float l9_2=l9_1;
if (sc_StereoRendering_IsClipDistanceEnabled_tmp==1)
{
}
else
{
varClipDistance=l9_2;
}
}
float4 fixedClipPosition=float4(clipPosition.x,-clipPosition.y,(clipPosition.z*0.5)+(clipPosition.w*0.5),clipPosition.w);
float4 param_1=fixedClipPosition;
gl_Position=param_1;
}
vertex main_vert_out main_vert(main_vert_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],constant sc_Set1& sc_set1 [[buffer(1)]],constant sc_Set2& sc_set2 [[buffer(2)]],uint gl_InstanceIndex [[instance_id]])
{
main_vert_out out={};
out.PreviewVertexColor=float4(0.5);
ssPreviewInfo PreviewInfo;
PreviewInfo.Color=float4(0.5);
PreviewInfo.Saved=false;
out.PreviewVertexSaved=0.0;
sc_Vertex_t l9_0;
l9_0.position=in.position;
l9_0.normal=in.normal;
l9_0.tangent=in.tangent.xyz;
l9_0.texture0=in.texture0;
l9_0.texture1=in.texture1;
sc_Vertex_t l9_1=l9_0;
sc_Vertex_t param=l9_1;
if ((int(sc_Voxelization_tmp)!=0))
{
sc_Vertex_t l9_2=param;
param=l9_2;
}
sc_Vertex_t l9_3=param;
if ((int(sc_VertexBlending_tmp)!=0))
{
if ((int(sc_VertexBlendingUseNormals_tmp)!=0))
{
sc_Vertex_t l9_4=l9_3;
float3 l9_5=in.blendShape0Pos;
float3 l9_6=in.blendShape0Normal;
float l9_7=(*sc_set2.sc_DrawCallUBO).weights0.x;
sc_Vertex_t l9_8=l9_4;
float3 l9_9=l9_5;
float l9_10=l9_7;
float3 l9_11=l9_8.position.xyz+(l9_9*l9_10);
l9_8.position=float4(l9_11.x,l9_11.y,l9_11.z,l9_8.position.w);
l9_4=l9_8;
l9_4.normal+=(l9_6*l9_7);
l9_3=l9_4;
sc_Vertex_t l9_12=l9_3;
float3 l9_13=in.blendShape1Pos;
float3 l9_14=in.blendShape1Normal;
float l9_15=(*sc_set2.sc_DrawCallUBO).weights0.y;
sc_Vertex_t l9_16=l9_12;
float3 l9_17=l9_13;
float l9_18=l9_15;
float3 l9_19=l9_16.position.xyz+(l9_17*l9_18);
l9_16.position=float4(l9_19.x,l9_19.y,l9_19.z,l9_16.position.w);
l9_12=l9_16;
l9_12.normal+=(l9_14*l9_15);
l9_3=l9_12;
sc_Vertex_t l9_20=l9_3;
float3 l9_21=in.blendShape2Pos;
float3 l9_22=in.blendShape2Normal;
float l9_23=(*sc_set2.sc_DrawCallUBO).weights0.z;
sc_Vertex_t l9_24=l9_20;
float3 l9_25=l9_21;
float l9_26=l9_23;
float3 l9_27=l9_24.position.xyz+(l9_25*l9_26);
l9_24.position=float4(l9_27.x,l9_27.y,l9_27.z,l9_24.position.w);
l9_20=l9_24;
l9_20.normal+=(l9_22*l9_23);
l9_3=l9_20;
}
else
{
sc_Vertex_t l9_28=l9_3;
float3 l9_29=in.blendShape0Pos;
float l9_30=(*sc_set2.sc_DrawCallUBO).weights0.x;
float3 l9_31=l9_28.position.xyz+(l9_29*l9_30);
l9_28.position=float4(l9_31.x,l9_31.y,l9_31.z,l9_28.position.w);
l9_3=l9_28;
sc_Vertex_t l9_32=l9_3;
float3 l9_33=in.blendShape1Pos;
float l9_34=(*sc_set2.sc_DrawCallUBO).weights0.y;
float3 l9_35=l9_32.position.xyz+(l9_33*l9_34);
l9_32.position=float4(l9_35.x,l9_35.y,l9_35.z,l9_32.position.w);
l9_3=l9_32;
sc_Vertex_t l9_36=l9_3;
float3 l9_37=in.blendShape2Pos;
float l9_38=(*sc_set2.sc_DrawCallUBO).weights0.z;
float3 l9_39=l9_36.position.xyz+(l9_37*l9_38);
l9_36.position=float4(l9_39.x,l9_39.y,l9_39.z,l9_36.position.w);
l9_3=l9_36;
sc_Vertex_t l9_40=l9_3;
float3 l9_41=in.blendShape3Pos;
float l9_42=(*sc_set2.sc_DrawCallUBO).weights0.w;
float3 l9_43=l9_40.position.xyz+(l9_41*l9_42);
l9_40.position=float4(l9_43.x,l9_43.y,l9_43.z,l9_40.position.w);
l9_3=l9_40;
sc_Vertex_t l9_44=l9_3;
float3 l9_45=in.blendShape4Pos;
float l9_46=(*sc_set2.sc_DrawCallUBO).weights1.x;
float3 l9_47=l9_44.position.xyz+(l9_45*l9_46);
l9_44.position=float4(l9_47.x,l9_47.y,l9_47.z,l9_44.position.w);
l9_3=l9_44;
sc_Vertex_t l9_48=l9_3;
float3 l9_49=in.blendShape5Pos;
float l9_50=(*sc_set2.sc_DrawCallUBO).weights1.y;
float3 l9_51=l9_48.position.xyz+(l9_49*l9_50);
l9_48.position=float4(l9_51.x,l9_51.y,l9_51.z,l9_48.position.w);
l9_3=l9_48;
}
}
param=l9_3;
sc_Vertex_t l9_52=param;
float4 l9_53=l9_52.position;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_54=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_54=float4(1.0,fract(in.boneData.yzw));
l9_54.x-=dot(l9_54.yzw,float3(1.0));
}
float4 l9_55=l9_54;
float4 l9_56=l9_55;
int l9_57=int(in.boneData.x);
int l9_58=int(in.boneData.y);
int l9_59=int(in.boneData.z);
int l9_60=int(in.boneData.w);
int l9_61=l9_57;
float4 l9_62=l9_53;
float3 l9_63=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_64=l9_61;
float4 l9_65=(*sc_set2.sc_BonesUBO).sc_Bones[l9_64].boneMatrix[0];
float4 l9_66=(*sc_set2.sc_BonesUBO).sc_Bones[l9_64].boneMatrix[1];
float4 l9_67=(*sc_set2.sc_BonesUBO).sc_Bones[l9_64].boneMatrix[2];
float4 l9_68[3];
l9_68[0]=l9_65;
l9_68[1]=l9_66;
l9_68[2]=l9_67;
l9_63=float3(dot(l9_62,l9_68[0]),dot(l9_62,l9_68[1]),dot(l9_62,l9_68[2]));
}
else
{
l9_63=l9_62.xyz;
}
float3 l9_69=l9_63;
float3 l9_70=l9_69;
float l9_71=l9_56.x;
int l9_72=l9_58;
float4 l9_73=l9_53;
float3 l9_74=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_75=l9_72;
float4 l9_76=(*sc_set2.sc_BonesUBO).sc_Bones[l9_75].boneMatrix[0];
float4 l9_77=(*sc_set2.sc_BonesUBO).sc_Bones[l9_75].boneMatrix[1];
float4 l9_78=(*sc_set2.sc_BonesUBO).sc_Bones[l9_75].boneMatrix[2];
float4 l9_79[3];
l9_79[0]=l9_76;
l9_79[1]=l9_77;
l9_79[2]=l9_78;
l9_74=float3(dot(l9_73,l9_79[0]),dot(l9_73,l9_79[1]),dot(l9_73,l9_79[2]));
}
else
{
l9_74=l9_73.xyz;
}
float3 l9_80=l9_74;
float3 l9_81=l9_80;
float l9_82=l9_56.y;
int l9_83=l9_59;
float4 l9_84=l9_53;
float3 l9_85=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_86=l9_83;
float4 l9_87=(*sc_set2.sc_BonesUBO).sc_Bones[l9_86].boneMatrix[0];
float4 l9_88=(*sc_set2.sc_BonesUBO).sc_Bones[l9_86].boneMatrix[1];
float4 l9_89=(*sc_set2.sc_BonesUBO).sc_Bones[l9_86].boneMatrix[2];
float4 l9_90[3];
l9_90[0]=l9_87;
l9_90[1]=l9_88;
l9_90[2]=l9_89;
l9_85=float3(dot(l9_84,l9_90[0]),dot(l9_84,l9_90[1]),dot(l9_84,l9_90[2]));
}
else
{
l9_85=l9_84.xyz;
}
float3 l9_91=l9_85;
float3 l9_92=l9_91;
float l9_93=l9_56.z;
int l9_94=l9_60;
float4 l9_95=l9_53;
float3 l9_96=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_97=l9_94;
float4 l9_98=(*sc_set2.sc_BonesUBO).sc_Bones[l9_97].boneMatrix[0];
float4 l9_99=(*sc_set2.sc_BonesUBO).sc_Bones[l9_97].boneMatrix[1];
float4 l9_100=(*sc_set2.sc_BonesUBO).sc_Bones[l9_97].boneMatrix[2];
float4 l9_101[3];
l9_101[0]=l9_98;
l9_101[1]=l9_99;
l9_101[2]=l9_100;
l9_96=float3(dot(l9_95,l9_101[0]),dot(l9_95,l9_101[1]),dot(l9_95,l9_101[2]));
}
else
{
l9_96=l9_95.xyz;
}
float3 l9_102=l9_96;
float3 l9_103=(((l9_70*l9_71)+(l9_81*l9_82))+(l9_92*l9_93))+(l9_102*l9_56.w);
l9_53=float4(l9_103.x,l9_103.y,l9_103.z,l9_53.w);
}
l9_52.position=l9_53;
float3 l9_104=l9_52.normal;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_105=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_105=float4(1.0,fract(in.boneData.yzw));
l9_105.x-=dot(l9_105.yzw,float3(1.0));
}
float4 l9_106=l9_105;
float4 l9_107=l9_106;
int l9_108=int(in.boneData.x);
int l9_109=int(in.boneData.y);
int l9_110=int(in.boneData.z);
int l9_111=int(in.boneData.w);
int l9_112=l9_108;
float3x3 l9_113=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_112].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_112].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_112].normalMatrix[2].xyz));
float3x3 l9_114=l9_113;
float3x3 l9_115=l9_114;
int l9_116=l9_109;
float3x3 l9_117=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_116].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_116].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_116].normalMatrix[2].xyz));
float3x3 l9_118=l9_117;
float3x3 l9_119=l9_118;
int l9_120=l9_110;
float3x3 l9_121=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_120].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_120].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_120].normalMatrix[2].xyz));
float3x3 l9_122=l9_121;
float3x3 l9_123=l9_122;
int l9_124=l9_111;
float3x3 l9_125=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_124].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_124].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_124].normalMatrix[2].xyz));
float3x3 l9_126=l9_125;
float3x3 l9_127=l9_126;
l9_104=((((l9_115*l9_104)*l9_107.x)+((l9_119*l9_104)*l9_107.y))+((l9_123*l9_104)*l9_107.z))+((l9_127*l9_104)*l9_107.w);
}
l9_52.normal=l9_104;
float3 l9_128=l9_52.tangent;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_129=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_129=float4(1.0,fract(in.boneData.yzw));
l9_129.x-=dot(l9_129.yzw,float3(1.0));
}
float4 l9_130=l9_129;
float4 l9_131=l9_130;
int l9_132=int(in.boneData.x);
int l9_133=int(in.boneData.y);
int l9_134=int(in.boneData.z);
int l9_135=int(in.boneData.w);
int l9_136=l9_132;
float3x3 l9_137=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_136].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_136].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_136].normalMatrix[2].xyz));
float3x3 l9_138=l9_137;
float3x3 l9_139=l9_138;
int l9_140=l9_133;
float3x3 l9_141=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_140].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_140].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_140].normalMatrix[2].xyz));
float3x3 l9_142=l9_141;
float3x3 l9_143=l9_142;
int l9_144=l9_134;
float3x3 l9_145=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_144].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_144].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_144].normalMatrix[2].xyz));
float3x3 l9_146=l9_145;
float3x3 l9_147=l9_146;
int l9_148=l9_135;
float3x3 l9_149=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_148].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_148].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_148].normalMatrix[2].xyz));
float3x3 l9_150=l9_149;
float3x3 l9_151=l9_150;
l9_128=((((l9_139*l9_128)*l9_131.x)+((l9_143*l9_128)*l9_131.y))+((l9_147*l9_128)*l9_131.z))+((l9_151*l9_128)*l9_131.w);
}
l9_52.tangent=l9_128;
param=l9_52;
if (sc_RenderingSpace_tmp==3)
{
out.varPosAndMotion=float4(float3(0.0).x,float3(0.0).y,float3(0.0).z,out.varPosAndMotion.w);
out.varNormalAndMotion=float4(param.normal.x,param.normal.y,param.normal.z,out.varNormalAndMotion.w);
out.varTangent=float4(param.tangent.x,param.tangent.y,param.tangent.z,out.varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==4)
{
out.varPosAndMotion=float4(float3(0.0).x,float3(0.0).y,float3(0.0).z,out.varPosAndMotion.w);
out.varNormalAndMotion=float4(param.normal.x,param.normal.y,param.normal.z,out.varNormalAndMotion.w);
out.varTangent=float4(param.tangent.x,param.tangent.y,param.tangent.z,out.varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==2)
{
out.varPosAndMotion=float4(param.position.xyz.x,param.position.xyz.y,param.position.xyz.z,out.varPosAndMotion.w);
out.varNormalAndMotion=float4(param.normal.x,param.normal.y,param.normal.z,out.varNormalAndMotion.w);
out.varTangent=float4(param.tangent.x,param.tangent.y,param.tangent.z,out.varTangent.w);
}
else
{
if (sc_RenderingSpace_tmp==1)
{
float3 l9_152=((*sc_set2.sc_DrawCallUBO).sc_ModelMatrix*param.position).xyz;
out.varPosAndMotion=float4(l9_152.x,l9_152.y,l9_152.z,out.varPosAndMotion.w);
float3 l9_153=(*sc_set2.sc_DrawCallUBO).sc_NormalMatrix*param.normal;
out.varNormalAndMotion=float4(l9_153.x,l9_153.y,l9_153.z,out.varNormalAndMotion.w);
float3 l9_154=(*sc_set2.sc_DrawCallUBO).sc_NormalMatrix*param.tangent;
out.varTangent=float4(l9_154.x,l9_154.y,l9_154.z,out.varTangent.w);
}
}
}
}
if ((*sc_set0.UserUniforms).PreviewEnabled==1)
{
param.texture0.x=1.0-param.texture0.x;
}
out.varColor=in.color;
sc_Vertex_t v=param;
float3 WorldPosition=out.varPosAndMotion.xyz;
float3 WorldNormal=out.varNormalAndMotion.xyz;
float3 WorldTangent=out.varTangent.xyz;
if ((*sc_set0.UserUniforms).PreviewEnabled==1)
{
WorldPosition=out.varPosAndMotion.xyz;
WorldNormal=out.varNormalAndMotion.xyz;
WorldTangent=out.varTangent.xyz;
}
sc_Vertex_t param_1=v;
float3 param_2=WorldPosition;
float3 param_3=WorldNormal;
float3 param_4=WorldTangent;
float4 param_5=v.position;
out.varPosAndMotion=float4(param_2.x,param_2.y,param_2.z,out.varPosAndMotion.w);
float3 l9_155=normalize(param_3);
out.varNormalAndMotion=float4(l9_155.x,l9_155.y,l9_155.z,out.varNormalAndMotion.w);
float3 l9_156=normalize(param_4);
out.varTangent=float4(l9_156.x,l9_156.y,l9_156.z,out.varTangent.w);
out.varTangent.w=in.tangent.w;
if ((int(UseViewSpaceDepthVariant_tmp)!=0)&&(((int(sc_OITDepthGatherPass_tmp)!=0)||(int(sc_OITCompositingPass_tmp)!=0))||(int(sc_OITDepthBoundsPass_tmp)!=0)))
{
float4 l9_157=param_1.position;
float4 l9_158=float4(0.0);
if (sc_RenderingSpace_tmp==3)
{
int l9_159=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_159=0;
}
else
{
l9_159=gl_InstanceIndex%2;
}
int l9_160=l9_159;
l9_158=(*sc_set1.sc_CameraUBO).sc_ProjectionMatrixInverseArray[l9_160]*l9_157;
}
else
{
if (sc_RenderingSpace_tmp==2)
{
int l9_161=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_161=0;
}
else
{
l9_161=gl_InstanceIndex%2;
}
int l9_162=l9_161;
l9_158=(*sc_set1.sc_CameraUBO).sc_ViewMatrixArray[l9_162]*l9_157;
}
else
{
if (sc_RenderingSpace_tmp==1)
{
int l9_163=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_163=0;
}
else
{
l9_163=gl_InstanceIndex%2;
}
int l9_164=l9_163;
l9_158=((*sc_set1.sc_CameraUBO).sc_ViewMatrixArray[l9_164]*(*sc_set2.sc_DrawCallUBO).sc_ModelMatrix)*l9_157;
}
else
{
l9_158=l9_157;
}
}
}
float4 l9_165=l9_158;
out.varViewSpaceDepth=-l9_165.z;
}
float4 l9_166=float4(0.0);
if (sc_RenderingSpace_tmp==3)
{
l9_166=param_5;
}
else
{
if (sc_RenderingSpace_tmp==4)
{
int l9_167=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_167=0;
}
else
{
l9_167=gl_InstanceIndex%2;
}
int l9_168=l9_167;
l9_166=(((*sc_set1.sc_CameraUBO).sc_ViewMatrixArray[l9_168]*(*sc_set2.sc_DrawCallUBO).sc_ModelMatrix)*param_1.position)*float4(1.0/(*sc_set1.sc_CameraUBO).sc_Camera.aspect,1.0,1.0,1.0);
}
else
{
if (sc_RenderingSpace_tmp==2)
{
int l9_169=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_169=0;
}
else
{
l9_169=gl_InstanceIndex%2;
}
int l9_170=l9_169;
l9_166=(*sc_set1.sc_CameraUBO).sc_ViewProjectionMatrixArray[l9_170]*float4(out.varPosAndMotion.xyz,1.0);
}
else
{
if (sc_RenderingSpace_tmp==1)
{
int l9_171=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_171=0;
}
else
{
l9_171=gl_InstanceIndex%2;
}
int l9_172=l9_171;
l9_166=(*sc_set1.sc_CameraUBO).sc_ViewProjectionMatrixArray[l9_172]*float4(out.varPosAndMotion.xyz,1.0);
}
}
}
}
out.varTex01=float4(param_1.texture0,param_1.texture1);
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float4 l9_173=param_1.position;
float4 l9_174=l9_173;
if (sc_RenderingSpace_tmp==1)
{
l9_174=(*sc_set2.sc_DrawCallUBO).sc_ModelMatrix*l9_173;
}
float4 l9_175=(*sc_set2.sc_DrawCallUBO).sc_ProjectorMatrix*l9_174;
float2 l9_176=((l9_175.xy/float2(l9_175.w))*0.5)+float2(0.5);
out.varShadowTex=l9_176;
}
float4 l9_177=l9_166;
if (sc_DepthBufferMode_tmp==1)
{
int l9_178=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_178=0;
}
else
{
l9_178=gl_InstanceIndex%2;
}
int l9_179=l9_178;
if ((*sc_set1.sc_CameraUBO).sc_ProjectionMatrixArray[l9_179][2].w!=0.0)
{
float l9_180=2.0/log2((*sc_set1.sc_CameraUBO).sc_Camera.clipPlanes.y+1.0);
l9_177.z=((log2(fast::max((*sc_set1.sc_CameraUBO).sc_Camera.clipPlanes.x,1.0+l9_177.w))*l9_180)-1.0)*l9_177.w;
}
}
float4 l9_181=l9_177;
l9_166=l9_181;
float4 l9_182=l9_166;
if ((int(sc_TAAEnabled_tmp)!=0))
{
float2 l9_183=l9_182.xy+((*sc_set0.UserUniforms).sc_TAAJitterOffset*l9_182.w);
l9_182=float4(l9_183.x,l9_183.y,l9_182.z,l9_182.w);
}
float4 l9_184=l9_182;
l9_166=l9_184;
float4 l9_185=l9_166;
sc_SetClipPosition(l9_185,gl_InstanceIndex,out.gl_Position,(*sc_set2.sc_DrawCallUBO),(*sc_set1.sc_CameraUBO),out.varClipDistance,out.varStereoViewID);
if ((int(sc_Voxelization_tmp)!=0))
{
sc_Vertex_t l9_186=param_1;
sc_Vertex_t l9_187=l9_186;
if ((int(sc_VertexBlending_tmp)!=0))
{
if ((int(sc_VertexBlendingUseNormals_tmp)!=0))
{
sc_Vertex_t l9_188=l9_187;
float3 l9_189=in.blendShape0Pos;
float3 l9_190=in.blendShape0Normal;
float l9_191=(*sc_set2.sc_DrawCallUBO).weights0.x;
sc_Vertex_t l9_192=l9_188;
float3 l9_193=l9_189;
float l9_194=l9_191;
float3 l9_195=l9_192.position.xyz+(l9_193*l9_194);
l9_192.position=float4(l9_195.x,l9_195.y,l9_195.z,l9_192.position.w);
l9_188=l9_192;
l9_188.normal+=(l9_190*l9_191);
l9_187=l9_188;
sc_Vertex_t l9_196=l9_187;
float3 l9_197=in.blendShape1Pos;
float3 l9_198=in.blendShape1Normal;
float l9_199=(*sc_set2.sc_DrawCallUBO).weights0.y;
sc_Vertex_t l9_200=l9_196;
float3 l9_201=l9_197;
float l9_202=l9_199;
float3 l9_203=l9_200.position.xyz+(l9_201*l9_202);
l9_200.position=float4(l9_203.x,l9_203.y,l9_203.z,l9_200.position.w);
l9_196=l9_200;
l9_196.normal+=(l9_198*l9_199);
l9_187=l9_196;
sc_Vertex_t l9_204=l9_187;
float3 l9_205=in.blendShape2Pos;
float3 l9_206=in.blendShape2Normal;
float l9_207=(*sc_set2.sc_DrawCallUBO).weights0.z;
sc_Vertex_t l9_208=l9_204;
float3 l9_209=l9_205;
float l9_210=l9_207;
float3 l9_211=l9_208.position.xyz+(l9_209*l9_210);
l9_208.position=float4(l9_211.x,l9_211.y,l9_211.z,l9_208.position.w);
l9_204=l9_208;
l9_204.normal+=(l9_206*l9_207);
l9_187=l9_204;
}
else
{
sc_Vertex_t l9_212=l9_187;
float3 l9_213=in.blendShape0Pos;
float l9_214=(*sc_set2.sc_DrawCallUBO).weights0.x;
float3 l9_215=l9_212.position.xyz+(l9_213*l9_214);
l9_212.position=float4(l9_215.x,l9_215.y,l9_215.z,l9_212.position.w);
l9_187=l9_212;
sc_Vertex_t l9_216=l9_187;
float3 l9_217=in.blendShape1Pos;
float l9_218=(*sc_set2.sc_DrawCallUBO).weights0.y;
float3 l9_219=l9_216.position.xyz+(l9_217*l9_218);
l9_216.position=float4(l9_219.x,l9_219.y,l9_219.z,l9_216.position.w);
l9_187=l9_216;
sc_Vertex_t l9_220=l9_187;
float3 l9_221=in.blendShape2Pos;
float l9_222=(*sc_set2.sc_DrawCallUBO).weights0.z;
float3 l9_223=l9_220.position.xyz+(l9_221*l9_222);
l9_220.position=float4(l9_223.x,l9_223.y,l9_223.z,l9_220.position.w);
l9_187=l9_220;
sc_Vertex_t l9_224=l9_187;
float3 l9_225=in.blendShape3Pos;
float l9_226=(*sc_set2.sc_DrawCallUBO).weights0.w;
float3 l9_227=l9_224.position.xyz+(l9_225*l9_226);
l9_224.position=float4(l9_227.x,l9_227.y,l9_227.z,l9_224.position.w);
l9_187=l9_224;
sc_Vertex_t l9_228=l9_187;
float3 l9_229=in.blendShape4Pos;
float l9_230=(*sc_set2.sc_DrawCallUBO).weights1.x;
float3 l9_231=l9_228.position.xyz+(l9_229*l9_230);
l9_228.position=float4(l9_231.x,l9_231.y,l9_231.z,l9_228.position.w);
l9_187=l9_228;
sc_Vertex_t l9_232=l9_187;
float3 l9_233=in.blendShape5Pos;
float l9_234=(*sc_set2.sc_DrawCallUBO).weights1.y;
float3 l9_235=l9_232.position.xyz+(l9_233*l9_234);
l9_232.position=float4(l9_235.x,l9_235.y,l9_235.z,l9_232.position.w);
l9_187=l9_232;
}
}
l9_186=l9_187;
sc_Vertex_t l9_236=l9_186;
float4 l9_237=l9_236.position;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_238=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_238=float4(1.0,fract(in.boneData.yzw));
l9_238.x-=dot(l9_238.yzw,float3(1.0));
}
float4 l9_239=l9_238;
float4 l9_240=l9_239;
int l9_241=int(in.boneData.x);
int l9_242=int(in.boneData.y);
int l9_243=int(in.boneData.z);
int l9_244=int(in.boneData.w);
int l9_245=l9_241;
float4 l9_246=l9_237;
float3 l9_247=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_248=l9_245;
float4 l9_249=(*sc_set2.sc_BonesUBO).sc_Bones[l9_248].boneMatrix[0];
float4 l9_250=(*sc_set2.sc_BonesUBO).sc_Bones[l9_248].boneMatrix[1];
float4 l9_251=(*sc_set2.sc_BonesUBO).sc_Bones[l9_248].boneMatrix[2];
float4 l9_252[3];
l9_252[0]=l9_249;
l9_252[1]=l9_250;
l9_252[2]=l9_251;
l9_247=float3(dot(l9_246,l9_252[0]),dot(l9_246,l9_252[1]),dot(l9_246,l9_252[2]));
}
else
{
l9_247=l9_246.xyz;
}
float3 l9_253=l9_247;
float3 l9_254=l9_253;
float l9_255=l9_240.x;
int l9_256=l9_242;
float4 l9_257=l9_237;
float3 l9_258=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_259=l9_256;
float4 l9_260=(*sc_set2.sc_BonesUBO).sc_Bones[l9_259].boneMatrix[0];
float4 l9_261=(*sc_set2.sc_BonesUBO).sc_Bones[l9_259].boneMatrix[1];
float4 l9_262=(*sc_set2.sc_BonesUBO).sc_Bones[l9_259].boneMatrix[2];
float4 l9_263[3];
l9_263[0]=l9_260;
l9_263[1]=l9_261;
l9_263[2]=l9_262;
l9_258=float3(dot(l9_257,l9_263[0]),dot(l9_257,l9_263[1]),dot(l9_257,l9_263[2]));
}
else
{
l9_258=l9_257.xyz;
}
float3 l9_264=l9_258;
float3 l9_265=l9_264;
float l9_266=l9_240.y;
int l9_267=l9_243;
float4 l9_268=l9_237;
float3 l9_269=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_270=l9_267;
float4 l9_271=(*sc_set2.sc_BonesUBO).sc_Bones[l9_270].boneMatrix[0];
float4 l9_272=(*sc_set2.sc_BonesUBO).sc_Bones[l9_270].boneMatrix[1];
float4 l9_273=(*sc_set2.sc_BonesUBO).sc_Bones[l9_270].boneMatrix[2];
float4 l9_274[3];
l9_274[0]=l9_271;
l9_274[1]=l9_272;
l9_274[2]=l9_273;
l9_269=float3(dot(l9_268,l9_274[0]),dot(l9_268,l9_274[1]),dot(l9_268,l9_274[2]));
}
else
{
l9_269=l9_268.xyz;
}
float3 l9_275=l9_269;
float3 l9_276=l9_275;
float l9_277=l9_240.z;
int l9_278=l9_244;
float4 l9_279=l9_237;
float3 l9_280=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_281=l9_278;
float4 l9_282=(*sc_set2.sc_BonesUBO).sc_Bones[l9_281].boneMatrix[0];
float4 l9_283=(*sc_set2.sc_BonesUBO).sc_Bones[l9_281].boneMatrix[1];
float4 l9_284=(*sc_set2.sc_BonesUBO).sc_Bones[l9_281].boneMatrix[2];
float4 l9_285[3];
l9_285[0]=l9_282;
l9_285[1]=l9_283;
l9_285[2]=l9_284;
l9_280=float3(dot(l9_279,l9_285[0]),dot(l9_279,l9_285[1]),dot(l9_279,l9_285[2]));
}
else
{
l9_280=l9_279.xyz;
}
float3 l9_286=l9_280;
float3 l9_287=(((l9_254*l9_255)+(l9_265*l9_266))+(l9_276*l9_277))+(l9_286*l9_240.w);
l9_237=float4(l9_287.x,l9_287.y,l9_287.z,l9_237.w);
}
l9_236.position=l9_237;
float3 l9_288=l9_236.normal;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_289=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_289=float4(1.0,fract(in.boneData.yzw));
l9_289.x-=dot(l9_289.yzw,float3(1.0));
}
float4 l9_290=l9_289;
float4 l9_291=l9_290;
int l9_292=int(in.boneData.x);
int l9_293=int(in.boneData.y);
int l9_294=int(in.boneData.z);
int l9_295=int(in.boneData.w);
int l9_296=l9_292;
float3x3 l9_297=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_296].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_296].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_296].normalMatrix[2].xyz));
float3x3 l9_298=l9_297;
float3x3 l9_299=l9_298;
int l9_300=l9_293;
float3x3 l9_301=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_300].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_300].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_300].normalMatrix[2].xyz));
float3x3 l9_302=l9_301;
float3x3 l9_303=l9_302;
int l9_304=l9_294;
float3x3 l9_305=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_304].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_304].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_304].normalMatrix[2].xyz));
float3x3 l9_306=l9_305;
float3x3 l9_307=l9_306;
int l9_308=l9_295;
float3x3 l9_309=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_308].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_308].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_308].normalMatrix[2].xyz));
float3x3 l9_310=l9_309;
float3x3 l9_311=l9_310;
l9_288=((((l9_299*l9_288)*l9_291.x)+((l9_303*l9_288)*l9_291.y))+((l9_307*l9_288)*l9_291.z))+((l9_311*l9_288)*l9_291.w);
}
l9_236.normal=l9_288;
float3 l9_312=l9_236.tangent;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_313=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_313=float4(1.0,fract(in.boneData.yzw));
l9_313.x-=dot(l9_313.yzw,float3(1.0));
}
float4 l9_314=l9_313;
float4 l9_315=l9_314;
int l9_316=int(in.boneData.x);
int l9_317=int(in.boneData.y);
int l9_318=int(in.boneData.z);
int l9_319=int(in.boneData.w);
int l9_320=l9_316;
float3x3 l9_321=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_320].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_320].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_320].normalMatrix[2].xyz));
float3x3 l9_322=l9_321;
float3x3 l9_323=l9_322;
int l9_324=l9_317;
float3x3 l9_325=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_324].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_324].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_324].normalMatrix[2].xyz));
float3x3 l9_326=l9_325;
float3x3 l9_327=l9_326;
int l9_328=l9_318;
float3x3 l9_329=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_328].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_328].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_328].normalMatrix[2].xyz));
float3x3 l9_330=l9_329;
float3x3 l9_331=l9_330;
int l9_332=l9_319;
float3x3 l9_333=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_332].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_332].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_332].normalMatrix[2].xyz));
float3x3 l9_334=l9_333;
float3x3 l9_335=l9_334;
l9_312=((((l9_323*l9_312)*l9_315.x)+((l9_327*l9_312)*l9_315.y))+((l9_331*l9_312)*l9_315.z))+((l9_335*l9_312)*l9_315.w);
}
l9_236.tangent=l9_312;
l9_186=l9_236;
float l9_336=(*sc_set0.UserUniforms).voxelization_params_0.y;
float l9_337=(*sc_set0.UserUniforms).voxelization_params_0.z;
float l9_338=(*sc_set0.UserUniforms).voxelization_params_0.w;
float l9_339=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.x;
float l9_340=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.y;
float l9_341=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.z;
float l9_342=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.w;
float l9_343=(*sc_set0.UserUniforms).voxelization_params_frustum_nf.x;
float l9_344=(*sc_set0.UserUniforms).voxelization_params_frustum_nf.y;
float3 l9_345=(*sc_set0.UserUniforms).voxelization_params_camera_pos;
float l9_346=l9_336/l9_337;
int l9_347=sc_GetLocalInstanceID(gl_InstanceIndex);
l9_186.position=(*sc_set0.UserUniforms).sc_ModelMatrixVoxelization*l9_186.position;
float3 l9_348=l9_186.position.xyz;
float3 l9_349=float3(float(l9_347%int(l9_338))*l9_336,float(l9_347/int(l9_338))*l9_336,(float(l9_347)*l9_346)+l9_343);
float3 l9_350=l9_348+l9_349;
float4 l9_351=float4(l9_350-l9_345,1.0);
float l9_352=l9_339;
float l9_353=l9_340;
float l9_354=l9_341;
float l9_355=l9_342;
float l9_356=l9_343;
float l9_357=l9_344;
float4x4 l9_358=float4x4(float4(2.0/(l9_353-l9_352),0.0,0.0,(-(l9_353+l9_352))/(l9_353-l9_352)),float4(0.0,2.0/(l9_355-l9_354),0.0,(-(l9_355+l9_354))/(l9_355-l9_354)),float4(0.0,0.0,(-2.0)/(l9_357-l9_356),(-(l9_357+l9_356))/(l9_357-l9_356)),float4(0.0,0.0,0.0,1.0));
float4x4 l9_359=l9_358;
float4 l9_360=l9_359*l9_351;
l9_360.w=1.0;
out.varScreenPos=l9_360;
float4 l9_361=l9_360*1.0;
sc_SetClipPosition(l9_361,gl_InstanceIndex,out.gl_Position,(*sc_set2.sc_DrawCallUBO),(*sc_set1.sc_CameraUBO),out.varClipDistance,out.varStereoViewID);
param_1=l9_186;
}
else
{
if ((int(sc_OutputBounds_tmp)!=0))
{
sc_Vertex_t l9_362=param_1;
sc_Vertex_t l9_363=l9_362;
if ((int(sc_VertexBlending_tmp)!=0))
{
if ((int(sc_VertexBlendingUseNormals_tmp)!=0))
{
sc_Vertex_t l9_364=l9_363;
float3 l9_365=in.blendShape0Pos;
float3 l9_366=in.blendShape0Normal;
float l9_367=(*sc_set2.sc_DrawCallUBO).weights0.x;
sc_Vertex_t l9_368=l9_364;
float3 l9_369=l9_365;
float l9_370=l9_367;
float3 l9_371=l9_368.position.xyz+(l9_369*l9_370);
l9_368.position=float4(l9_371.x,l9_371.y,l9_371.z,l9_368.position.w);
l9_364=l9_368;
l9_364.normal+=(l9_366*l9_367);
l9_363=l9_364;
sc_Vertex_t l9_372=l9_363;
float3 l9_373=in.blendShape1Pos;
float3 l9_374=in.blendShape1Normal;
float l9_375=(*sc_set2.sc_DrawCallUBO).weights0.y;
sc_Vertex_t l9_376=l9_372;
float3 l9_377=l9_373;
float l9_378=l9_375;
float3 l9_379=l9_376.position.xyz+(l9_377*l9_378);
l9_376.position=float4(l9_379.x,l9_379.y,l9_379.z,l9_376.position.w);
l9_372=l9_376;
l9_372.normal+=(l9_374*l9_375);
l9_363=l9_372;
sc_Vertex_t l9_380=l9_363;
float3 l9_381=in.blendShape2Pos;
float3 l9_382=in.blendShape2Normal;
float l9_383=(*sc_set2.sc_DrawCallUBO).weights0.z;
sc_Vertex_t l9_384=l9_380;
float3 l9_385=l9_381;
float l9_386=l9_383;
float3 l9_387=l9_384.position.xyz+(l9_385*l9_386);
l9_384.position=float4(l9_387.x,l9_387.y,l9_387.z,l9_384.position.w);
l9_380=l9_384;
l9_380.normal+=(l9_382*l9_383);
l9_363=l9_380;
}
else
{
sc_Vertex_t l9_388=l9_363;
float3 l9_389=in.blendShape0Pos;
float l9_390=(*sc_set2.sc_DrawCallUBO).weights0.x;
float3 l9_391=l9_388.position.xyz+(l9_389*l9_390);
l9_388.position=float4(l9_391.x,l9_391.y,l9_391.z,l9_388.position.w);
l9_363=l9_388;
sc_Vertex_t l9_392=l9_363;
float3 l9_393=in.blendShape1Pos;
float l9_394=(*sc_set2.sc_DrawCallUBO).weights0.y;
float3 l9_395=l9_392.position.xyz+(l9_393*l9_394);
l9_392.position=float4(l9_395.x,l9_395.y,l9_395.z,l9_392.position.w);
l9_363=l9_392;
sc_Vertex_t l9_396=l9_363;
float3 l9_397=in.blendShape2Pos;
float l9_398=(*sc_set2.sc_DrawCallUBO).weights0.z;
float3 l9_399=l9_396.position.xyz+(l9_397*l9_398);
l9_396.position=float4(l9_399.x,l9_399.y,l9_399.z,l9_396.position.w);
l9_363=l9_396;
sc_Vertex_t l9_400=l9_363;
float3 l9_401=in.blendShape3Pos;
float l9_402=(*sc_set2.sc_DrawCallUBO).weights0.w;
float3 l9_403=l9_400.position.xyz+(l9_401*l9_402);
l9_400.position=float4(l9_403.x,l9_403.y,l9_403.z,l9_400.position.w);
l9_363=l9_400;
sc_Vertex_t l9_404=l9_363;
float3 l9_405=in.blendShape4Pos;
float l9_406=(*sc_set2.sc_DrawCallUBO).weights1.x;
float3 l9_407=l9_404.position.xyz+(l9_405*l9_406);
l9_404.position=float4(l9_407.x,l9_407.y,l9_407.z,l9_404.position.w);
l9_363=l9_404;
sc_Vertex_t l9_408=l9_363;
float3 l9_409=in.blendShape5Pos;
float l9_410=(*sc_set2.sc_DrawCallUBO).weights1.y;
float3 l9_411=l9_408.position.xyz+(l9_409*l9_410);
l9_408.position=float4(l9_411.x,l9_411.y,l9_411.z,l9_408.position.w);
l9_363=l9_408;
}
}
l9_362=l9_363;
sc_Vertex_t l9_412=l9_362;
float4 l9_413=l9_412.position;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_414=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_414=float4(1.0,fract(in.boneData.yzw));
l9_414.x-=dot(l9_414.yzw,float3(1.0));
}
float4 l9_415=l9_414;
float4 l9_416=l9_415;
int l9_417=int(in.boneData.x);
int l9_418=int(in.boneData.y);
int l9_419=int(in.boneData.z);
int l9_420=int(in.boneData.w);
int l9_421=l9_417;
float4 l9_422=l9_413;
float3 l9_423=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_424=l9_421;
float4 l9_425=(*sc_set2.sc_BonesUBO).sc_Bones[l9_424].boneMatrix[0];
float4 l9_426=(*sc_set2.sc_BonesUBO).sc_Bones[l9_424].boneMatrix[1];
float4 l9_427=(*sc_set2.sc_BonesUBO).sc_Bones[l9_424].boneMatrix[2];
float4 l9_428[3];
l9_428[0]=l9_425;
l9_428[1]=l9_426;
l9_428[2]=l9_427;
l9_423=float3(dot(l9_422,l9_428[0]),dot(l9_422,l9_428[1]),dot(l9_422,l9_428[2]));
}
else
{
l9_423=l9_422.xyz;
}
float3 l9_429=l9_423;
float3 l9_430=l9_429;
float l9_431=l9_416.x;
int l9_432=l9_418;
float4 l9_433=l9_413;
float3 l9_434=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_435=l9_432;
float4 l9_436=(*sc_set2.sc_BonesUBO).sc_Bones[l9_435].boneMatrix[0];
float4 l9_437=(*sc_set2.sc_BonesUBO).sc_Bones[l9_435].boneMatrix[1];
float4 l9_438=(*sc_set2.sc_BonesUBO).sc_Bones[l9_435].boneMatrix[2];
float4 l9_439[3];
l9_439[0]=l9_436;
l9_439[1]=l9_437;
l9_439[2]=l9_438;
l9_434=float3(dot(l9_433,l9_439[0]),dot(l9_433,l9_439[1]),dot(l9_433,l9_439[2]));
}
else
{
l9_434=l9_433.xyz;
}
float3 l9_440=l9_434;
float3 l9_441=l9_440;
float l9_442=l9_416.y;
int l9_443=l9_419;
float4 l9_444=l9_413;
float3 l9_445=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_446=l9_443;
float4 l9_447=(*sc_set2.sc_BonesUBO).sc_Bones[l9_446].boneMatrix[0];
float4 l9_448=(*sc_set2.sc_BonesUBO).sc_Bones[l9_446].boneMatrix[1];
float4 l9_449=(*sc_set2.sc_BonesUBO).sc_Bones[l9_446].boneMatrix[2];
float4 l9_450[3];
l9_450[0]=l9_447;
l9_450[1]=l9_448;
l9_450[2]=l9_449;
l9_445=float3(dot(l9_444,l9_450[0]),dot(l9_444,l9_450[1]),dot(l9_444,l9_450[2]));
}
else
{
l9_445=l9_444.xyz;
}
float3 l9_451=l9_445;
float3 l9_452=l9_451;
float l9_453=l9_416.z;
int l9_454=l9_420;
float4 l9_455=l9_413;
float3 l9_456=float3(0.0);
if (sc_SkinBonesCount_tmp>0)
{
int l9_457=l9_454;
float4 l9_458=(*sc_set2.sc_BonesUBO).sc_Bones[l9_457].boneMatrix[0];
float4 l9_459=(*sc_set2.sc_BonesUBO).sc_Bones[l9_457].boneMatrix[1];
float4 l9_460=(*sc_set2.sc_BonesUBO).sc_Bones[l9_457].boneMatrix[2];
float4 l9_461[3];
l9_461[0]=l9_458;
l9_461[1]=l9_459;
l9_461[2]=l9_460;
l9_456=float3(dot(l9_455,l9_461[0]),dot(l9_455,l9_461[1]),dot(l9_455,l9_461[2]));
}
else
{
l9_456=l9_455.xyz;
}
float3 l9_462=l9_456;
float3 l9_463=(((l9_430*l9_431)+(l9_441*l9_442))+(l9_452*l9_453))+(l9_462*l9_416.w);
l9_413=float4(l9_463.x,l9_463.y,l9_463.z,l9_413.w);
}
l9_412.position=l9_413;
float3 l9_464=l9_412.normal;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_465=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_465=float4(1.0,fract(in.boneData.yzw));
l9_465.x-=dot(l9_465.yzw,float3(1.0));
}
float4 l9_466=l9_465;
float4 l9_467=l9_466;
int l9_468=int(in.boneData.x);
int l9_469=int(in.boneData.y);
int l9_470=int(in.boneData.z);
int l9_471=int(in.boneData.w);
int l9_472=l9_468;
float3x3 l9_473=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_472].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_472].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_472].normalMatrix[2].xyz));
float3x3 l9_474=l9_473;
float3x3 l9_475=l9_474;
int l9_476=l9_469;
float3x3 l9_477=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_476].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_476].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_476].normalMatrix[2].xyz));
float3x3 l9_478=l9_477;
float3x3 l9_479=l9_478;
int l9_480=l9_470;
float3x3 l9_481=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_480].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_480].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_480].normalMatrix[2].xyz));
float3x3 l9_482=l9_481;
float3x3 l9_483=l9_482;
int l9_484=l9_471;
float3x3 l9_485=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_484].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_484].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_484].normalMatrix[2].xyz));
float3x3 l9_486=l9_485;
float3x3 l9_487=l9_486;
l9_464=((((l9_475*l9_464)*l9_467.x)+((l9_479*l9_464)*l9_467.y))+((l9_483*l9_464)*l9_467.z))+((l9_487*l9_464)*l9_467.w);
}
l9_412.normal=l9_464;
float3 l9_488=l9_412.tangent;
if (sc_SkinBonesCount_tmp>0)
{
float4 l9_489=float4(0.0);
if (sc_SkinBonesCount_tmp>0)
{
l9_489=float4(1.0,fract(in.boneData.yzw));
l9_489.x-=dot(l9_489.yzw,float3(1.0));
}
float4 l9_490=l9_489;
float4 l9_491=l9_490;
int l9_492=int(in.boneData.x);
int l9_493=int(in.boneData.y);
int l9_494=int(in.boneData.z);
int l9_495=int(in.boneData.w);
int l9_496=l9_492;
float3x3 l9_497=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_496].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_496].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_496].normalMatrix[2].xyz));
float3x3 l9_498=l9_497;
float3x3 l9_499=l9_498;
int l9_500=l9_493;
float3x3 l9_501=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_500].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_500].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_500].normalMatrix[2].xyz));
float3x3 l9_502=l9_501;
float3x3 l9_503=l9_502;
int l9_504=l9_494;
float3x3 l9_505=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_504].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_504].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_504].normalMatrix[2].xyz));
float3x3 l9_506=l9_505;
float3x3 l9_507=l9_506;
int l9_508=l9_495;
float3x3 l9_509=float3x3(float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_508].normalMatrix[0].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_508].normalMatrix[1].xyz),float3((*sc_set2.sc_BonesUBO).sc_Bones[l9_508].normalMatrix[2].xyz));
float3x3 l9_510=l9_509;
float3x3 l9_511=l9_510;
l9_488=((((l9_499*l9_488)*l9_491.x)+((l9_503*l9_488)*l9_491.y))+((l9_507*l9_488)*l9_491.z))+((l9_511*l9_488)*l9_491.w);
}
l9_412.tangent=l9_488;
l9_362=l9_412;
float3 l9_512=(*sc_set0.UserUniforms).voxelization_params_camera_pos;
float2 l9_513=((l9_362.position.xy/float2(l9_362.position.w))*0.5)+float2(0.5);
out.varTex01=float4(l9_513.x,l9_513.y,out.varTex01.z,out.varTex01.w);
l9_362.position=(*sc_set0.UserUniforms).sc_ModelMatrixVoxelization*l9_362.position;
float3 l9_514=l9_362.position.xyz-l9_512;
l9_362.position=float4(l9_514.x,l9_514.y,l9_514.z,l9_362.position.w);
out.varPosAndMotion=float4(l9_362.position.xyz.x,l9_362.position.xyz.y,l9_362.position.xyz.z,out.varPosAndMotion.w);
float3 l9_515=normalize(l9_362.normal);
out.varNormalAndMotion=float4(l9_515.x,l9_515.y,l9_515.z,out.varNormalAndMotion.w);
float l9_516=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.x;
float l9_517=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.y;
float l9_518=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.z;
float l9_519=(*sc_set0.UserUniforms).voxelization_params_frustum_lrbt.w;
float l9_520=(*sc_set0.UserUniforms).voxelization_params_frustum_nf.x;
float l9_521=(*sc_set0.UserUniforms).voxelization_params_frustum_nf.y;
float l9_522=l9_516;
float l9_523=l9_517;
float l9_524=l9_518;
float l9_525=l9_519;
float l9_526=l9_520;
float l9_527=l9_521;
float4x4 l9_528=float4x4(float4(2.0/(l9_523-l9_522),0.0,0.0,(-(l9_523+l9_522))/(l9_523-l9_522)),float4(0.0,2.0/(l9_525-l9_524),0.0,(-(l9_525+l9_524))/(l9_525-l9_524)),float4(0.0,0.0,(-2.0)/(l9_527-l9_526),(-(l9_527+l9_526))/(l9_527-l9_526)),float4(0.0,0.0,0.0,1.0));
float4x4 l9_529=l9_528;
float4 l9_530=float4(0.0);
float3 l9_531=(l9_529*l9_362.position).xyz;
l9_530=float4(l9_531.x,l9_531.y,l9_531.z,l9_530.w);
l9_530.w=1.0;
out.varScreenPos=l9_530;
float4 l9_532=l9_530*1.0;
float4 l9_533=l9_532;
sc_SetClipPosition(l9_533,gl_InstanceIndex,out.gl_Position,(*sc_set2.sc_DrawCallUBO),(*sc_set1.sc_CameraUBO),out.varClipDistance,out.varStereoViewID);
param_1=l9_362;
}
}
v=param_1;
float3 param_6=out.varPosAndMotion.xyz;
if ((int(sc_MotionVectorsPass_tmp)!=0))
{
float4 l9_534=((*sc_set2.sc_DrawCallUBO).sc_PrevFrameModelMatrix*(*sc_set2.sc_DrawCallUBO).sc_ModelMatrixInverse)*float4(param_6,1.0);
float3 l9_535=param_6;
float3 l9_536=l9_534.xyz;
if ((int(sc_MotionVectorsPass_tmp)!=0))
{
int l9_537=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_537=0;
}
else
{
l9_537=gl_InstanceIndex%2;
}
int l9_538=l9_537;
float4 l9_539=(*sc_set1.sc_CameraUBO).sc_ViewProjectionMatrixArray[l9_538]*float4(l9_535,1.0);
float2 l9_540=l9_539.xy/float2(l9_539.w);
l9_539=float4(l9_540.x,l9_540.y,l9_539.z,l9_539.w);
int l9_541=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_541=0;
}
else
{
l9_541=gl_InstanceIndex%2;
}
int l9_542=l9_541;
float4 l9_543=(*sc_set1.sc_CameraUBO).sc_PrevFrameViewProjectionMatrixArray[l9_542]*float4(l9_536,1.0);
float2 l9_544=l9_543.xy/float2(l9_543.w);
l9_543=float4(l9_544.x,l9_544.y,l9_543.z,l9_543.w);
float2 l9_545=(l9_539.xy-l9_543.xy)*0.5;
out.varPosAndMotion.w=l9_545.x;
out.varNormalAndMotion.w=l9_545.y;
}
}
if (PreviewInfo.Saved)
{
out.PreviewVertexColor=float4(PreviewInfo.Color.xyz,1.0);
out.PreviewVertexSaved=1.0;
}
return out;
}
} // VERTEX SHADER


namespace SNAP_FS {
struct ShadowMapParameters
{
float4 lightSpacePos;
float shadowDensity;
float3 lightDirection;
float bias0;
float radius;
float3 L;
float3 N;
float NdotL;
float2 spotOuterAngleAndCos;
float lightNear;
float lightFar;
};
struct SurfaceProperties
{
float3 albedo;
float opacity;
float3 normal;
float3 positionWS;
float3 viewDirWS;
float metallic;
float roughness;
float3 emissive;
float3 ao;
float3 specularAo;
float3 bakedShadows;
float3 specColor;
};
struct LightingComponents
{
float3 directDiffuse;
float3 directSpecular;
float3 indirectDiffuse;
float3 indirectSpecular;
float3 emitted;
float3 transmitted;
};
struct LightProperties
{
float3 direction;
float3 color;
float attenuation;
};
struct sc_SphericalGaussianLight_t
{
float3 color;
float sharpness;
float3 axis;
};
struct ssGlobals
{
float gTimeElapsed;
float gTimeDelta;
float gTimeElapsedShifted;
float3 BumpedNormal;
float3 ViewDirWS;
float3 PositionWS;
float3 VertexNormal_WorldSpace;
float2 Surface_UVCoord0;
};
struct sc_Camera_t
{
float3 position;
float aspect;
float2 clipPlanes;
};
struct sc_CameraUBO_obj
{
float4 sc_Time;
float4 sc_UniformConstants;
float4x4 sc_ViewProjectionMatrixArray[4];
float4x4 sc_ViewProjectionMatrixInverseArray[4];
float4x4 sc_ProjectionMatrixArray[4];
float4x4 sc_ProjectionMatrixInverseArray[4];
float4x4 sc_ViewMatrixArray[4];
float4x4 sc_ViewMatrixInverseArray[4];
float4x4 sc_PrevFrameViewProjectionMatrixArray[4];
float4 sc_CurrentRenderTargetDims;
float4 sc_WindowToViewportTransform;
float4 sc_StereoClipPlanes[2];
sc_Camera_t sc_Camera;
};
struct sc_DrawCallUBO_obj
{
float4x4 sc_ModelMatrix;
float4x4 sc_ModelMatrixInverse;
float3x3 sc_NormalMatrix;
float4x4 sc_PrevFrameModelMatrix;
float sc_ShadowDensity;
float4 sc_ShadowColor;
float4x4 sc_ProjectorMatrix;
float4 weights0;
float4 weights1;
int sc_ViewMask;
};
struct ShadowMapParams_t
{
float4x4 params;
float4x4 lightSpaceMatrix;
float4x4 invLightSpaceMatrix;
};
struct userUniformsObj
{
ShadowMapParams_t sc_ShadowMapParams[1];
float2 sc_TAAJitterOffset;
float4 sc_ShadowMapTextureSize;
float4 voxelization_params_0;
float4 voxelization_params_frustum_lrbt;
float4 voxelization_params_frustum_nf;
float3 voxelization_params_camera_pos;
float4x4 sc_ModelMatrixVoxelization;
float correctedIntensity;
float3x3 intensityTextureTransform;
float4 intensityTextureUvMinMax;
float4 intensityTextureBorderColor;
int PreviewEnabled;
float alphaTestThreshold;
float4 baseColor;
float3x3 baseTexTransform;
float4 baseTexUvMinMax;
float4 baseTexBorderColor;
float metallic;
float roughness;
float3 Port_Normal_N006;
float3 Port_Emissive_N006;
float3 Port_AO_N006;
float3 Port_SpecularAO_N006;
};
struct sc_DirectionalLight_t
{
float3 direction;
float4 color;
int shadowMapParamsIndex;
};
struct sc_PointLight_t
{
float falloffRangeSqr;
float falloffRangeNegInvSqrSqr;
float angleScale;
float angleOffset;
float3 direction;
float3 position;
float4 color;
int shadowMapParamsIndex;
};
struct sc_AmbientLight_t
{
float3 color;
float intensity;
};
struct sc_LightEstimationData_t
{
sc_SphericalGaussianLight_t sg[12];
float3 ambientLight;
};
struct sc_LightingUBO_obj
{
sc_PointLight_t sc_PointLights[5];
sc_DirectionalLight_t sc_DirectionalLights[3];
sc_AmbientLight_t sc_AmbientLights[3];
sc_LightEstimationData_t sc_LightEstimationData;
float3 sc_EnvmapRotation;
float2 sc_EnvmapRotationSinCos;
float sc_EnvmapExposure;
float3 sc_Sh[9];
float sc_ShIntensity;
float4 sc_EnvmapDiffuseSize;
float4 sc_EnvmapDiffuseDims;
float4 sc_EnvmapDiffuseView;
float4 sc_EnvmapSpecularSize;
float4 sc_EnvmapSpecularDims;
float4 sc_EnvmapSpecularView;
float4 sc_SpecularCubemapSize;
};
struct ssPreviewInfo
{
float4 Color;
bool Saved;
};
struct sc_Bone_t
{
float4 boneMatrix[3];
float4 normalMatrix[3];
};
struct sc_BonesUBO_obj
{
sc_Bone_t sc_Bones[1];
};
struct sc_Set0
{
constant userUniformsObj* UserUniforms [[id(0)]];
texture2d<float> baseTex [[id(1)]];
texture2d<float> intensityTexture [[id(2)]];
texture2d<float> sc_EnvmapDiffuse [[id(3)]];
texture2d<float> sc_EnvmapSpecular [[id(4)]];
texture2d<float> sc_SSAOTexture [[id(13)]];
texture2d<float> sc_ScreenTexture [[id(14)]];
depth2d<float> sc_ShadowMapTexture [[id(16)]];
texture2d<float> sc_ShadowTexture [[id(17)]];
texturecube<float> sc_SpecularCubemap [[id(18)]];
sampler baseTexSmpSC [[id(20)]];
sampler intensityTextureSmpSC [[id(21)]];
sampler sc_EnvmapDiffuseSmpSC [[id(22)]];
sampler sc_EnvmapSpecularSmpSC [[id(23)]];
sampler sc_SSAOTextureSmpSC [[id(25)]];
sampler sc_ScreenTextureSmpSC [[id(26)]];
sampler sc_ShadowMapTextureSmpSC [[id(28)]];
sampler sc_ShadowTextureSmpSC [[id(29)]];
sampler sc_SpecularCubemapSmpSC [[id(30)]];
};
struct sc_Set1
{
constant sc_LightingUBO_obj* sc_LightingUBO [[id(0)]];
constant sc_CameraUBO_obj* sc_CameraUBO [[id(1)]];
};
struct sc_Set2
{
constant sc_DrawCallUBO_obj* sc_DrawCallUBO [[id(3)]];
constant sc_BonesUBO_obj* sc_BonesUBO [[id(6)]];
};
struct main_frag_out
{
float4 sc_FragData0 [[color(0)]];
};
struct main_frag_in
{
float4 varPosAndMotion [[user(locn0)]];
float4 varNormalAndMotion [[user(locn1)]];
float4 varTangent [[user(locn2)]];
float4 varTex01 [[user(locn3)]];
float4 varScreenPos [[user(locn4)]];
float2 varScreenTexturePos [[user(locn5)]];
float varViewSpaceDepth [[user(locn6)]];
float2 varShadowTex [[user(locn7)]];
int varStereoViewID [[user(locn8)]];
float varClipDistance [[user(locn9)]];
float4 varColor [[user(locn10)]];
float4 PreviewVertexColor [[user(locn11)]];
float PreviewVertexSaved [[user(locn12)]];
};
// Implementation of the GLSL mod() function,which is slightly different than Metal fmod()
template<typename Tx,typename Ty>
Tx mod(Tx x,Ty y)
{
return x-y*floor(x/y);
}
float3 evaluateSSAO(thread const float3& positionWS,thread int& varStereoViewID,constant sc_CameraUBO_obj& sc_CameraUBO,thread texture2d<float> sc_SSAOTexture,thread sampler sc_SSAOTextureSmpSC)
{
if ((int(sc_SSAOEnabled_tmp)!=0))
{
int l9_0=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_0=0;
}
else
{
l9_0=varStereoViewID;
}
int l9_1=l9_0;
float4 clipSpaceCoord=sc_CameraUBO.sc_ViewProjectionMatrixArray[l9_1]*float4(positionWS,1.0);
float3 l9_2=clipSpaceCoord.xyz/float3(clipSpaceCoord.w);
clipSpaceCoord=float4(l9_2.x,l9_2.y,l9_2.z,clipSpaceCoord.w);
float4 shadowSample=sc_SSAOTexture.sample(sc_SSAOTextureSmpSC,((clipSpaceCoord.xy*0.5)+float2(0.5)));
return float3(shadowSample.x);
}
else
{
return float3(1.0);
}
}
float sampleHardwarePCF(thread const float2& coords,thread const float& currentDepth,thread const float& bias0,thread texture2d<float> sc_ShadowTexture,thread sampler sc_ShadowTextureSmpSC,thread depth2d<float> sc_ShadowMapTexture,thread sampler sc_ShadowMapTextureSmpSC)
{
if ((int(sc_ShadowMapHardwarePCF_tmp)!=0))
{
float3 l9_0=float3(coords,currentDepth-bias0);
return sc_ShadowMapTexture.sample_compare(sc_ShadowMapTextureSmpSC,l9_0.xy,l9_0.z);
}
else
{
float shadowDepth=sc_ShadowTexture.sample(sc_ShadowTextureSmpSC,coords).x;
return step(currentDepth-bias0,shadowDepth);
}
}
float evaluateShadowMap(thread const bool& isDirectional,thread const int& lightId,thread const float3& L,thread float4& gl_FragCoord,constant sc_CameraUBO_obj& sc_CameraUBO,thread texture2d<float> sc_ShadowTexture,thread sampler sc_ShadowTextureSmpSC,constant userUniformsObj& UserUniforms,thread depth2d<float> sc_ShadowMapTexture,thread sampler sc_ShadowMapTextureSmpSC,constant sc_LightingUBO_obj& sc_LightingUBO,thread float4& varPosAndMotion,thread float4& varNormalAndMotion)
{
float ret=1.0;
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
bool param=isDirectional;
int param_1=lightId;
float3 param_2=L;
ShadowMapParameters l9_0;
if (param)
{
sc_DirectionalLight_t l9_1;
l9_1.direction=sc_LightingUBO.sc_DirectionalLights[param_1].direction;
l9_1.color=sc_LightingUBO.sc_DirectionalLights[param_1].color;
l9_1.shadowMapParamsIndex=sc_LightingUBO.sc_DirectionalLights[param_1].shadowMapParamsIndex;
ShadowMapParams_t l9_2;
l9_2.params=UserUniforms.sc_ShadowMapParams[l9_1.shadowMapParamsIndex].params;
l9_2.lightSpaceMatrix=UserUniforms.sc_ShadowMapParams[l9_1.shadowMapParamsIndex].lightSpaceMatrix;
l9_2.invLightSpaceMatrix=UserUniforms.sc_ShadowMapParams[l9_1.shadowMapParamsIndex].invLightSpaceMatrix;
float4x4 l9_3=l9_2.params;
l9_0.lightSpacePos=l9_2.lightSpaceMatrix*float4(varPosAndMotion.xyz,1.0);
l9_0.shadowDensity=l9_3[1].w;
l9_0.spotOuterAngleAndCos=float2(0.0);
l9_0.lightDirection=l9_1.direction;
l9_0.bias0=l9_3[3].x;
l9_0.radius=l9_3[2].x;
l9_0.lightNear=l9_3[2].y;
l9_0.lightFar=l9_3[2].z;
l9_0.L=-l9_0.lightDirection;
}
else
{
sc_PointLight_t l9_4;
l9_4.falloffRangeSqr=sc_LightingUBO.sc_PointLights[param_1].falloffRangeSqr;
l9_4.falloffRangeNegInvSqrSqr=sc_LightingUBO.sc_PointLights[param_1].falloffRangeNegInvSqrSqr;
l9_4.angleScale=sc_LightingUBO.sc_PointLights[param_1].angleScale;
l9_4.angleOffset=sc_LightingUBO.sc_PointLights[param_1].angleOffset;
l9_4.direction=sc_LightingUBO.sc_PointLights[param_1].direction;
l9_4.position=sc_LightingUBO.sc_PointLights[param_1].position;
l9_4.color=sc_LightingUBO.sc_PointLights[param_1].color;
l9_4.shadowMapParamsIndex=sc_LightingUBO.sc_PointLights[param_1].shadowMapParamsIndex;
ShadowMapParams_t l9_5;
l9_5.params=UserUniforms.sc_ShadowMapParams[l9_4.shadowMapParamsIndex].params;
l9_5.lightSpaceMatrix=UserUniforms.sc_ShadowMapParams[l9_4.shadowMapParamsIndex].lightSpaceMatrix;
l9_5.invLightSpaceMatrix=UserUniforms.sc_ShadowMapParams[l9_4.shadowMapParamsIndex].invLightSpaceMatrix;
float4x4 l9_6=l9_5.params;
l9_0.lightSpacePos=l9_5.lightSpaceMatrix*float4(varPosAndMotion.xyz,1.0);
l9_0.shadowDensity=l9_6[1].w;
l9_0.spotOuterAngleAndCos=l9_6[3].xy;
l9_0.lightDirection=l9_6[2].xyz;
l9_0.bias0=l9_6[2].w;
l9_0.radius=l9_6[1].x;
l9_0.lightNear=l9_6[1].y;
l9_0.lightFar=l9_6[1].z;
l9_0.L=param_2;
}
l9_0.N=normalize(varNormalAndMotion.xyz);
l9_0.NdotL=dot(l9_0.N,l9_0.L);
ShadowMapParameters l9_7=l9_0;
ShadowMapParameters p=l9_7;
float w=p.lightSpacePos.w;
if (w<=0.0)
{
return 1.0;
}
float invW=1.0/w;
float2 uv=((p.lightSpacePos.xy*invW)*0.5)+float2(0.5);
float l9_8=p.spotOuterAngleAndCos.y;
bool l9_9=l9_8>0.0;
bool l9_10;
if (l9_9)
{
l9_10=dot(p.L,p.lightDirection)<p.spotOuterAngleAndCos.y;
}
else
{
l9_10=l9_9;
}
if (l9_10)
{
return 1.0;
}
float l9_11=uv.x;
bool l9_12=l9_11<0.0;
bool l9_13;
if (!l9_12)
{
l9_13=uv.x>1.0;
}
else
{
l9_13=l9_12;
}
bool l9_14;
if (!l9_13)
{
l9_14=uv.y<0.0;
}
else
{
l9_14=l9_13;
}
bool l9_15;
if (!l9_14)
{
l9_15=uv.y>1.0;
}
else
{
l9_15=l9_14;
}
if (l9_15)
{
return 1.0;
}
if (p.NdotL>0.0)
{
return 1.0;
}
float depth=((p.lightSpacePos.z*invW)*0.5)+0.5;
ShadowMapParameters param_3=p;
float l9_16=fast::clamp(-param_3.NdotL,0.0,1.0);
float l9_17=sqrt(fast::clamp(1.0-(l9_16*l9_16),0.0,1.0));
float l9_18=fast::min(2.0,l9_17/fast::max(l9_16,0.001));
float l9_19=fast::max(param_3.lightFar-param_3.lightNear,1e-06);
float l9_20=((1.0+l9_17)+(1.5*l9_18))/l9_19;
float bias0=p.bias0*l9_20;
float visibility=0.0;
if ((int(sc_ShadowMapIsSoftShadow_tmp)!=0))
{
float2 texUV=uv*UserUniforms.sc_ShadowMapTextureSize.xy;
float2 invRes=UserUniforms.sc_ShadowMapTextureSize.zw;
if ((int(sc_ShadowMapIsRandomSampling_tmp)!=0))
{
float filterRadius=fast::max((p.radius*UserUniforms.sc_ShadowMapTextureSize.x)/512.0,1.0);
float l9_21;
if ((int(sc_TAAEnabled_tmp)!=0))
{
l9_21=floor(sc_CameraUBO.sc_Time.x*60.0);
}
else
{
l9_21=0.0;
}
float temporalFrame=l9_21;
float2 param_4=gl_FragCoord.xy;
float param_5=temporalFrame;
uint2 l9_22=uint2(param_4);
uint l9_23=(l9_22.x+(l9_22.y*1931u))+(uint(param_5)*2903u);
l9_23 ^= (l9_23>>16u);
l9_23*=73244475u;
l9_23 ^= (l9_23>>16u);
l9_23*=73244475u;
l9_23 ^= (l9_23>>16u);
int l9_24=int(l9_23&255u);
float2 param_6=gl_FragCoord.xy+float2(0.5,0.25);
float param_7=temporalFrame+1.0;
uint2 l9_25=uint2(param_6);
uint l9_26=(l9_25.x+(l9_25.y*1931u))+(uint(param_7)*2903u);
l9_26 ^= (l9_26>>16u);
l9_26*=73244475u;
l9_26 ^= (l9_26>>16u);
l9_26*=73244475u;
l9_26 ^= (l9_26>>16u);
int l9_27=int(l9_26&255u);
float2 r2=fract(float2(0.5)+(float2(float(l9_24),float(l9_27))/float2(256.0)));
float sum=0.0;
int i=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (i<sc_ShadowMapSampleCount_tmp)
{
float2 ab=(r2*2.0)-float2(1.0);
float2 disk=ab-(ab*((ab.yx*0.2929)*ab.yx));
float2 param_8=(texUV+(disk*filterRadius))*invRes;
float param_9=depth;
float param_10=bias0;
sum+=sampleHardwarePCF(param_8,param_9,param_10,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC);
r2=fract(r2+float2(0.75487769,0.56984031));
i++;
continue;
}
else
{
break;
}
}
visibility=sum/float(sc_ShadowMapSampleCount_tmp);
}
else
{
float2 fc=texUV-float2(0.5);
float2 base_uv=(floor(fc)+float2(0.5))*invRes;
float2 st=fract(fc);
float s=st.x;
float t=st.y;
float uw0=4.0-(3.0*s);
float uw2=1.0+(3.0*s);
float u0=(((3.0-(2.0*s))/uw0)-2.0)*invRes.x;
float u1=((3.0+s)/7.0)*invRes.x;
float u2=((s/uw2)+2.0)*invRes.x;
float vw0=4.0-(3.0*t);
float vw2=1.0+(3.0*t);
float v0=(((3.0-(2.0*t))/vw0)-2.0)*invRes.y;
float v1=((3.0+t)/7.0)*invRes.y;
float v2=((t/vw2)+2.0)*invRes.y;
float2 param_11=base_uv+float2(u0,v0);
float param_12=depth;
float param_13=bias0;
float2 param_14=base_uv+float2(u1,v0);
float param_15=depth;
float param_16=bias0;
float2 param_17=base_uv+float2(u2,v0);
float param_18=depth;
float param_19=bias0;
float2 param_20=base_uv+float2(u0,v1);
float param_21=depth;
float param_22=bias0;
float2 param_23=base_uv+float2(u1,v1);
float param_24=depth;
float param_25=bias0;
float2 param_26=base_uv+float2(u2,v1);
float param_27=depth;
float param_28=bias0;
float2 param_29=base_uv+float2(u0,v2);
float param_30=depth;
float param_31=bias0;
float2 param_32=base_uv+float2(u1,v2);
float param_33=depth;
float param_34=bias0;
float2 param_35=base_uv+float2(u2,v2);
float param_36=depth;
float param_37=bias0;
float sum_1=(((((((((uw0*vw0)*sampleHardwarePCF(param_11,param_12,param_13,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC))+((7.0*vw0)*sampleHardwarePCF(param_14,param_15,param_16,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+((uw2*vw0)*sampleHardwarePCF(param_17,param_18,param_19,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+((uw0*7.0)*sampleHardwarePCF(param_20,param_21,param_22,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+(49.0*sampleHardwarePCF(param_23,param_24,param_25,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+((uw2*7.0)*sampleHardwarePCF(param_26,param_27,param_28,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+((uw0*vw2)*sampleHardwarePCF(param_29,param_30,param_31,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+((7.0*vw2)*sampleHardwarePCF(param_32,param_33,param_34,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC)))+((uw2*vw2)*sampleHardwarePCF(param_35,param_36,param_37,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC));
visibility=sum_1*0.0069444445;
}
}
else
{
float2 param_38=uv;
float param_39=depth;
float param_40=bias0;
visibility=sampleHardwarePCF(param_38,param_39,param_40,sc_ShadowTexture,sc_ShadowTextureSmpSC,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC);
}
ret=(1.0-p.shadowDensity)+(p.shadowDensity*visibility);
}
return ret;
}
float evaluateDirectionalShadowMap(thread const int& lightId,thread float4& gl_FragCoord,constant sc_CameraUBO_obj& sc_CameraUBO,thread texture2d<float> sc_ShadowTexture,thread sampler sc_ShadowTextureSmpSC,constant userUniformsObj& UserUniforms,thread depth2d<float> sc_ShadowMapTexture,thread sampler sc_ShadowMapTextureSmpSC,constant sc_LightingUBO_obj& sc_LightingUBO,thread float4& varPosAndMotion,thread float4& varNormalAndMotion)
{
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
sc_DirectionalLight_t light;
light.direction=sc_LightingUBO.sc_DirectionalLights[lightId].direction;
light.color=sc_LightingUBO.sc_DirectionalLights[lightId].color;
light.shadowMapParamsIndex=sc_LightingUBO.sc_DirectionalLights[lightId].shadowMapParamsIndex;
if (light.shadowMapParamsIndex!=(-1))
{
bool param=true;
int param_1=lightId;
float3 param_2=float3(0.0);
return evaluateShadowMap(param,param_1,param_2,gl_FragCoord,sc_CameraUBO,sc_ShadowTexture,sc_ShadowTextureSmpSC,UserUniforms,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC,sc_LightingUBO,varPosAndMotion,varNormalAndMotion);
}
}
return 1.0;
}
float3 calculateDirectSpecular(thread const SurfaceProperties& surfaceProperties,thread const float3& L,thread const float3& V)
{
float r=fast::max(surfaceProperties.roughness,0.029999999);
float3 F0=surfaceProperties.specColor;
float3 N=surfaceProperties.normal;
float3 H=normalize(L+V);
float param=dot(N,L);
float l9_0=fast::clamp(param,0.0,1.0);
float NdotL=l9_0;
float param_1=dot(N,V);
float l9_1=fast::clamp(param_1,0.0,1.0);
float NdotV=l9_1;
float param_2=dot(N,H);
float l9_2=fast::clamp(param_2,0.0,1.0);
float NdotH=l9_2;
float param_3=dot(V,H);
float l9_3=fast::clamp(param_3,0.0,1.0);
float VdotH=l9_3;
if (SC_DEVICE_CLASS_tmp>=2)
{
float param_4=NdotH;
float param_5=r;
float l9_4=param_5*param_5;
float l9_5=l9_4*l9_4;
float l9_6=param_4*param_4;
float l9_7=(l9_6*(l9_5-1.0))+1.0;
float l9_8=l9_7*l9_7;
float l9_9=9.9999999e-09;
float l9_10=l9_5/(l9_8+l9_9);
float param_6=NdotL;
float param_7=NdotV;
float param_8=r;
float l9_11=param_6;
float l9_12=param_8;
float l9_13=l9_12+1.0;
l9_13=(l9_13*l9_13)*0.125;
float l9_14=(l9_11*(1.0-l9_13))+l9_13;
float l9_15=param_7;
float l9_16=param_8;
float l9_17=l9_16+1.0;
l9_17=(l9_17*l9_17)*0.125;
float l9_18=(l9_15*(1.0-l9_17))+l9_17;
float l9_19=1.0/(l9_14*l9_18);
float param_9=VdotH;
float3 param_10=F0;
float l9_20=param_9;
float3 l9_21=param_10;
float3 l9_22=float3(1.0);
float l9_23=1.0-l9_20;
float l9_24=l9_23*l9_23;
float l9_25=(l9_24*l9_24)*l9_23;
float3 l9_26=l9_21+((l9_22-l9_21)*l9_25);
float3 l9_27=l9_26;
return l9_27*(((l9_10*l9_19)*0.25)*NdotL);
}
else
{
float specPower=exp2(11.0-(10.0*r));
float param_11=VdotH;
float3 param_12=F0;
float l9_28=param_11;
float3 l9_29=param_12;
float3 l9_30=float3(1.0);
float l9_31=1.0-l9_28;
float l9_32=l9_31*l9_31;
float l9_33=(l9_32*l9_32)*l9_31;
float3 l9_34=l9_29+((l9_30-l9_29)*l9_33);
float3 l9_35=l9_34;
return ((l9_35*((specPower*0.125)+0.25))*pow(NdotH,specPower))*NdotL;
}
}
float evaluatePointShadowMap(thread const int& lightId,thread const float3& L,thread float4& gl_FragCoord,constant sc_CameraUBO_obj& sc_CameraUBO,thread texture2d<float> sc_ShadowTexture,thread sampler sc_ShadowTextureSmpSC,constant userUniformsObj& UserUniforms,thread depth2d<float> sc_ShadowMapTexture,thread sampler sc_ShadowMapTextureSmpSC,constant sc_LightingUBO_obj& sc_LightingUBO,thread float4& varPosAndMotion,thread float4& varNormalAndMotion)
{
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
sc_PointLight_t light;
light.falloffRangeSqr=sc_LightingUBO.sc_PointLights[lightId].falloffRangeSqr;
light.falloffRangeNegInvSqrSqr=sc_LightingUBO.sc_PointLights[lightId].falloffRangeNegInvSqrSqr;
light.angleScale=sc_LightingUBO.sc_PointLights[lightId].angleScale;
light.angleOffset=sc_LightingUBO.sc_PointLights[lightId].angleOffset;
light.direction=sc_LightingUBO.sc_PointLights[lightId].direction;
light.position=sc_LightingUBO.sc_PointLights[lightId].position;
light.color=sc_LightingUBO.sc_PointLights[lightId].color;
light.shadowMapParamsIndex=sc_LightingUBO.sc_PointLights[lightId].shadowMapParamsIndex;
if (light.shadowMapParamsIndex!=(-1))
{
bool param=false;
int param_1=lightId;
float3 param_2=L;
return evaluateShadowMap(param,param_1,param_2,gl_FragCoord,sc_CameraUBO,sc_ShadowTexture,sc_ShadowTextureSmpSC,UserUniforms,sc_ShadowMapTexture,sc_ShadowMapTextureSmpSC,sc_LightingUBO,varPosAndMotion,varNormalAndMotion);
}
}
return 1.0;
}
float2 calcSeamlessPanoramicUvsForSampling(thread const float2& uv,thread const float2& topMipRes,thread const float& lod)
{
if (SC_DEVICE_CLASS_tmp>=2)
{
float2 thisMipRes=fast::max(float2(1.0),topMipRes/float2(exp2(lod)));
return ((uv*(thisMipRes-float2(1.0)))/thisMipRes)+(float2(0.5)/thisMipRes);
}
else
{
return uv;
}
}
float3 getSpecularDominantDir(thread const float3& N,thread const float3& R,thread const float& roughness)
{
if (SC_DEVICE_CLASS_tmp>=2)
{
float lerpFactor=(roughness*roughness)*roughness;
return normalize(mix(R,N,float3(lerpFactor)));
}
else
{
return R;
}
}
float3 envBRDFApprox(thread const SurfaceProperties& surfaceProperties,thread const float& NdotV)
{
if (SC_DEVICE_CLASS_tmp>=2)
{
float param=surfaceProperties.roughness;
float param_1=NdotV;
float4 l9_0=(float4(-1.0,-0.0275,-0.57200003,0.022)*param)+float4(1.0,0.0425,1.04,-0.039999999);
float l9_1=(fast::min(l9_0.x*l9_0.x,exp2((-9.2799997)*param_1))*l9_0.x)+l9_0.y;
float2 l9_2=(float2(-1.04,1.04)*l9_1)+l9_0.zw;
float2 l9_3=l9_2;
float2 AB=l9_3;
return fast::max((surfaceProperties.specColor*AB.x)+float3(AB.y),float3(0.0));
}
else
{
float3 fresnelMax=fast::max(float3(1.0-surfaceProperties.roughness),surfaceProperties.specColor);
float param_2=NdotV;
float3 param_3=surfaceProperties.specColor;
float3 param_4=fresnelMax;
float l9_4=1.0-param_2;
float l9_5=l9_4*l9_4;
float l9_6=(l9_5*l9_5)*l9_4;
float3 l9_7=param_3+((param_4-param_3)*l9_6);
return l9_7;
}
}
float srgbToLinear(thread const float& x)
{
if (SC_DEVICE_CLASS_tmp>=2)
{
return pow(x,2.2);
}
else
{
return x*x;
}
}
float linearToSrgb(thread const float& x)
{
if (SC_DEVICE_CLASS_tmp>=2)
{
return pow(x,0.45454547);
}
else
{
return sqrt(x);
}
}
float transformSingleColor(thread const float& original,thread const float& intMap,thread const float& target)
{
if (((sc_SoftwareBlendMode_tmp==40)||(sc_SoftwareBlendMode_tmp==43))||(sc_SoftwareBlendMode_tmp==44))
{
return original/pow(1.0-target,intMap);
}
else
{
if (sc_SoftwareBlendMode_tmp==41)
{
return original/(1.0-target);
}
else
{
if (sc_SoftwareBlendMode_tmp==42)
{
return original/pow(1.0-target,2.0-(2.0*original));
}
}
}
return 0.0;
}
float3 transformColor(thread const float& yValue,thread const float3& original,thread const float3& target,thread const float& weight,thread const float& intMap)
{
if (sc_SoftwareBlendMode_tmp==45)
{
float3 param=original;
float3 l9_0=param;
float4 l9_1;
if (l9_0.y<l9_0.z)
{
l9_1=float4(l9_0.zy,-1.0,0.66666669);
}
else
{
l9_1=float4(l9_0.yz,0.0,-0.33333334);
}
float4 l9_2=l9_1;
float4 l9_3;
if (l9_0.x<l9_2.x)
{
l9_3=float4(l9_2.xyw,l9_0.x);
}
else
{
l9_3=float4(l9_0.x,l9_2.yzx);
}
float4 l9_4=l9_3;
float l9_5=l9_4.x-fast::min(l9_4.w,l9_4.y);
float l9_6=abs(((l9_4.w-l9_4.y)/((6.0*l9_5)+1e-07))+l9_4.z);
float l9_7=l9_4.x;
float3 l9_8=float3(l9_6,l9_5,l9_7);
float3 l9_9=l9_8;
float l9_10=l9_9.z-(l9_9.y*0.5);
float l9_11=l9_9.y/((1.0-abs((2.0*l9_10)-1.0))+1e-07);
float3 l9_12=float3(l9_9.x,l9_11,l9_10);
float3 hslOrig=l9_12;
float3 res=float3(0.0);
res.x=target.x;
res.y=target.y;
res.z=hslOrig.z;
float3 param_1=res;
float l9_13=param_1.x;
float l9_14=abs((6.0*l9_13)-3.0)-1.0;
float l9_15=2.0-abs((6.0*l9_13)-2.0);
float l9_16=2.0-abs((6.0*l9_13)-4.0);
float3 l9_17=fast::clamp(float3(l9_14,l9_15,l9_16),float3(0.0),float3(1.0));
float3 l9_18=l9_17;
float l9_19=(1.0-abs((2.0*param_1.z)-1.0))*param_1.y;
l9_18=((l9_18-float3(0.5))*l9_19)+float3(param_1.z);
float3 l9_20=l9_18;
res=l9_20;
float3 resColor=mix(original,res,float3(weight));
return resColor;
}
else
{
float3 tmpColor=float3(0.0);
float param_2=yValue;
float param_3=intMap;
float param_4=target.x;
tmpColor.x=transformSingleColor(param_2,param_3,param_4);
float param_5=yValue;
float param_6=intMap;
float param_7=target.y;
tmpColor.y=transformSingleColor(param_5,param_6,param_7);
float param_8=yValue;
float param_9=intMap;
float param_10=target.z;
tmpColor.z=transformSingleColor(param_8,param_9,param_10);
tmpColor=fast::clamp(tmpColor,float3(0.0),float3(1.0));
float3 resColor_1=mix(original,tmpColor,float3(weight));
return resColor_1;
}
}
float3 definedBlend(thread const float3& a,thread const float3& b,thread int& varStereoViewID,constant userUniformsObj& UserUniforms,thread texture2d<float> intensityTexture,thread sampler intensityTextureSmpSC)
{
if (sc_SoftwareBlendMode_tmp==19)
{
return fast::max(a,b);
}
else
{
if (sc_SoftwareBlendMode_tmp==17)
{
return fast::min(a,b);
}
else
{
if (sc_SoftwareBlendMode_tmp==35)
{
return (a+b)*0.5;
}
else
{
if (sc_SoftwareBlendMode_tmp==30)
{
return fast::max((a+b)-float3(1.0),float3(0.0));
}
else
{
if (sc_SoftwareBlendMode_tmp==28)
{
return abs(a-b);
}
else
{
if (sc_SoftwareBlendMode_tmp==36)
{
return float3(1.0)-abs((float3(1.0)-a)-b);
}
else
{
if (sc_SoftwareBlendMode_tmp==29)
{
return (a+b)-((a*2.0)*b);
}
else
{
if (sc_SoftwareBlendMode_tmp==21)
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
float l9_1=l9_0;
float l9_2;
if (a.y<0.5)
{
l9_2=(2.0*a.y)*b.y;
}
else
{
l9_2=1.0-((2.0*(1.0-a.y))*(1.0-b.y));
}
float l9_3=l9_2;
float l9_4;
if (a.z<0.5)
{
l9_4=(2.0*a.z)*b.z;
}
else
{
l9_4=1.0-((2.0*(1.0-a.z))*(1.0-b.z));
}
return float3(l9_1,l9_3,l9_4);
}
else
{
if (sc_SoftwareBlendMode_tmp==22)
{
return (((float3(1.0)-(b*2.0))*a)*a)+((a*2.0)*b);
}
else
{
if (sc_SoftwareBlendMode_tmp==23)
{
float l9_5;
if (b.x<0.5)
{
l9_5=(2.0*b.x)*a.x;
}
else
{
l9_5=1.0-((2.0*(1.0-b.x))*(1.0-a.x));
}
float l9_6=l9_5;
float l9_7;
if (b.y<0.5)
{
l9_7=(2.0*b.y)*a.y;
}
else
{
l9_7=1.0-((2.0*(1.0-b.y))*(1.0-a.y));
}
float l9_8=l9_7;
float l9_9;
if (b.z<0.5)
{
l9_9=(2.0*b.z)*a.z;
}
else
{
l9_9=1.0-((2.0*(1.0-b.z))*(1.0-a.z));
}
return float3(l9_6,l9_8,l9_9);
}
else
{
if (sc_SoftwareBlendMode_tmp==20)
{
float l9_10;
if (b.x==1.0)
{
l9_10=b.x;
}
else
{
l9_10=fast::min(a.x/(1.0-b.x),1.0);
}
float l9_11=l9_10;
float l9_12;
if (b.y==1.0)
{
l9_12=b.y;
}
else
{
l9_12=fast::min(a.y/(1.0-b.y),1.0);
}
float l9_13=l9_12;
float l9_14;
if (b.z==1.0)
{
l9_14=b.z;
}
else
{
l9_14=fast::min(a.z/(1.0-b.z),1.0);
}
return float3(l9_11,l9_13,l9_14);
}
else
{
if (sc_SoftwareBlendMode_tmp==18)
{
float l9_15;
if (b.x==0.0)
{
l9_15=b.x;
}
else
{
l9_15=fast::max(1.0-((1.0-a.x)/b.x),0.0);
}
float l9_16=l9_15;
float l9_17;
if (b.y==0.0)
{
l9_17=b.y;
}
else
{
l9_17=fast::max(1.0-((1.0-a.y)/b.y),0.0);
}
float l9_18=l9_17;
float l9_19;
if (b.z==0.0)
{
l9_19=b.z;
}
else
{
l9_19=fast::max(1.0-((1.0-a.z)/b.z),0.0);
}
return float3(l9_16,l9_18,l9_19);
}
else
{
if (sc_SoftwareBlendMode_tmp==25)
{
float l9_20;
if (b.x<0.5)
{
l9_20=fast::max((a.x+(2.0*b.x))-1.0,0.0);
}
else
{
l9_20=fast::min(a.x+(2.0*(b.x-0.5)),1.0);
}
float l9_21=l9_20;
float l9_22;
if (b.y<0.5)
{
l9_22=fast::max((a.y+(2.0*b.y))-1.0,0.0);
}
else
{
l9_22=fast::min(a.y+(2.0*(b.y-0.5)),1.0);
}
float l9_23=l9_22;
float l9_24;
if (b.z<0.5)
{
l9_24=fast::max((a.z+(2.0*b.z))-1.0,0.0);
}
else
{
l9_24=fast::min(a.z+(2.0*(b.z-0.5)),1.0);
}
return float3(l9_21,l9_23,l9_24);
}
else
{
if (sc_SoftwareBlendMode_tmp==24)
{
float l9_25;
if (b.x<0.5)
{
float l9_26;
if ((2.0*b.x)==0.0)
{
l9_26=2.0*b.x;
}
else
{
l9_26=fast::max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_25=l9_26;
}
else
{
float l9_27;
if ((2.0*(b.x-0.5))==1.0)
{
l9_27=2.0*(b.x-0.5);
}
else
{
l9_27=fast::min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_25=l9_27;
}
float l9_28=l9_25;
float l9_29;
if (b.y<0.5)
{
float l9_30;
if ((2.0*b.y)==0.0)
{
l9_30=2.0*b.y;
}
else
{
l9_30=fast::max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_29=l9_30;
}
else
{
float l9_31;
if ((2.0*(b.y-0.5))==1.0)
{
l9_31=2.0*(b.y-0.5);
}
else
{
l9_31=fast::min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_29=l9_31;
}
float l9_32=l9_29;
float l9_33;
if (b.z<0.5)
{
float l9_34;
if ((2.0*b.z)==0.0)
{
l9_34=2.0*b.z;
}
else
{
l9_34=fast::max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_33=l9_34;
}
else
{
float l9_35;
if ((2.0*(b.z-0.5))==1.0)
{
l9_35=2.0*(b.z-0.5);
}
else
{
l9_35=fast::min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_33=l9_35;
}
return float3(l9_28,l9_32,l9_33);
}
else
{
if (sc_SoftwareBlendMode_tmp==26)
{
float l9_36;
if (b.x<0.5)
{
l9_36=fast::min(a.x,2.0*b.x);
}
else
{
l9_36=fast::max(a.x,2.0*(b.x-0.5));
}
float l9_37=l9_36;
float l9_38;
if (b.y<0.5)
{
l9_38=fast::min(a.y,2.0*b.y);
}
else
{
l9_38=fast::max(a.y,2.0*(b.y-0.5));
}
float l9_39=l9_38;
float l9_40;
if (b.z<0.5)
{
l9_40=fast::min(a.z,2.0*b.z);
}
else
{
l9_40=fast::max(a.z,2.0*(b.z-0.5));
}
return float3(l9_37,l9_39,l9_40);
}
else
{
if (sc_SoftwareBlendMode_tmp==27)
{
float l9_41;
if (b.x<0.5)
{
float l9_42;
if ((2.0*b.x)==0.0)
{
l9_42=2.0*b.x;
}
else
{
l9_42=fast::max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_41=l9_42;
}
else
{
float l9_43;
if ((2.0*(b.x-0.5))==1.0)
{
l9_43=2.0*(b.x-0.5);
}
else
{
l9_43=fast::min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_41=l9_43;
}
float l9_44=l9_41;
float l9_45;
if (b.y<0.5)
{
float l9_46;
if ((2.0*b.y)==0.0)
{
l9_46=2.0*b.y;
}
else
{
l9_46=fast::max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_45=l9_46;
}
else
{
float l9_47;
if ((2.0*(b.y-0.5))==1.0)
{
l9_47=2.0*(b.y-0.5);
}
else
{
l9_47=fast::min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_45=l9_47;
}
float l9_48=l9_45;
float l9_49;
if (b.z<0.5)
{
float l9_50;
if ((2.0*b.z)==0.0)
{
l9_50=2.0*b.z;
}
else
{
l9_50=fast::max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_49=l9_50;
}
else
{
float l9_51;
if ((2.0*(b.z-0.5))==1.0)
{
l9_51=2.0*(b.z-0.5);
}
else
{
l9_51=fast::min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_49=l9_51;
}
return float3((l9_44<0.5) ? 0.0 : 1.0,(l9_48<0.5) ? 0.0 : 1.0,(l9_49<0.5) ? 0.0 : 1.0);
}
else
{
if (sc_SoftwareBlendMode_tmp==37)
{
float l9_52;
if (b.x==1.0)
{
l9_52=b.x;
}
else
{
l9_52=fast::min((a.x*a.x)/(1.0-b.x),1.0);
}
float l9_53=l9_52;
float l9_54;
if (b.y==1.0)
{
l9_54=b.y;
}
else
{
l9_54=fast::min((a.y*a.y)/(1.0-b.y),1.0);
}
float l9_55=l9_54;
float l9_56;
if (b.z==1.0)
{
l9_56=b.z;
}
else
{
l9_56=fast::min((a.z*a.z)/(1.0-b.z),1.0);
}
return float3(l9_53,l9_55,l9_56);
}
else
{
if (sc_SoftwareBlendMode_tmp==38)
{
float l9_57;
if (a.x==1.0)
{
l9_57=a.x;
}
else
{
l9_57=fast::min((b.x*b.x)/(1.0-a.x),1.0);
}
float l9_58=l9_57;
float l9_59;
if (a.y==1.0)
{
l9_59=a.y;
}
else
{
l9_59=fast::min((b.y*b.y)/(1.0-a.y),1.0);
}
float l9_60=l9_59;
float l9_61;
if (a.z==1.0)
{
l9_61=a.z;
}
else
{
l9_61=fast::min((b.z*b.z)/(1.0-a.z),1.0);
}
return float3(l9_58,l9_60,l9_61);
}
else
{
if (sc_SoftwareBlendMode_tmp==39)
{
return (fast::min(a,b)-fast::max(a,b))+float3(1.0);
}
else
{
if (sc_SoftwareBlendMode_tmp==31)
{
float3 param=a;
float3 param_1=b;
float3 l9_62=param;
float3 l9_63=l9_62;
float4 l9_64;
if (l9_63.y<l9_63.z)
{
l9_64=float4(l9_63.zy,-1.0,0.66666669);
}
else
{
l9_64=float4(l9_63.yz,0.0,-0.33333334);
}
float4 l9_65=l9_64;
float4 l9_66;
if (l9_63.x<l9_65.x)
{
l9_66=float4(l9_65.xyw,l9_63.x);
}
else
{
l9_66=float4(l9_63.x,l9_65.yzx);
}
float4 l9_67=l9_66;
float l9_68=l9_67.x-fast::min(l9_67.w,l9_67.y);
float l9_69=abs(((l9_67.w-l9_67.y)/((6.0*l9_68)+1e-07))+l9_67.z);
float l9_70=l9_67.x;
float3 l9_71=float3(l9_69,l9_68,l9_70);
float3 l9_72=l9_71;
float l9_73=l9_72.z-(l9_72.y*0.5);
float l9_74=l9_72.y/((1.0-abs((2.0*l9_73)-1.0))+1e-07);
float3 l9_75=float3(l9_72.x,l9_74,l9_73);
float3 l9_76=l9_75;
float3 l9_77=param_1;
float3 l9_78=l9_77;
float4 l9_79;
if (l9_78.y<l9_78.z)
{
l9_79=float4(l9_78.zy,-1.0,0.66666669);
}
else
{
l9_79=float4(l9_78.yz,0.0,-0.33333334);
}
float4 l9_80=l9_79;
float4 l9_81;
if (l9_78.x<l9_80.x)
{
l9_81=float4(l9_80.xyw,l9_78.x);
}
else
{
l9_81=float4(l9_78.x,l9_80.yzx);
}
float4 l9_82=l9_81;
float l9_83=l9_82.x-fast::min(l9_82.w,l9_82.y);
float l9_84=abs(((l9_82.w-l9_82.y)/((6.0*l9_83)+1e-07))+l9_82.z);
float l9_85=l9_82.x;
float3 l9_86=float3(l9_84,l9_83,l9_85);
float3 l9_87=l9_86;
float l9_88=l9_87.z-(l9_87.y*0.5);
float l9_89=l9_87.y/((1.0-abs((2.0*l9_88)-1.0))+1e-07);
float3 l9_90=float3(l9_87.x,l9_89,l9_88);
float3 l9_91=float3(l9_90.x,l9_76.y,l9_76.z);
float l9_92=l9_91.x;
float l9_93=abs((6.0*l9_92)-3.0)-1.0;
float l9_94=2.0-abs((6.0*l9_92)-2.0);
float l9_95=2.0-abs((6.0*l9_92)-4.0);
float3 l9_96=fast::clamp(float3(l9_93,l9_94,l9_95),float3(0.0),float3(1.0));
float3 l9_97=l9_96;
float l9_98=(1.0-abs((2.0*l9_91.z)-1.0))*l9_91.y;
l9_97=((l9_97-float3(0.5))*l9_98)+float3(l9_91.z);
float3 l9_99=l9_97;
float3 l9_100=l9_99;
return l9_100;
}
else
{
if (sc_SoftwareBlendMode_tmp==32)
{
float3 param_2=a;
float3 param_3=b;
float3 l9_101=param_2;
float3 l9_102=l9_101;
float4 l9_103;
if (l9_102.y<l9_102.z)
{
l9_103=float4(l9_102.zy,-1.0,0.66666669);
}
else
{
l9_103=float4(l9_102.yz,0.0,-0.33333334);
}
float4 l9_104=l9_103;
float4 l9_105;
if (l9_102.x<l9_104.x)
{
l9_105=float4(l9_104.xyw,l9_102.x);
}
else
{
l9_105=float4(l9_102.x,l9_104.yzx);
}
float4 l9_106=l9_105;
float l9_107=l9_106.x-fast::min(l9_106.w,l9_106.y);
float l9_108=abs(((l9_106.w-l9_106.y)/((6.0*l9_107)+1e-07))+l9_106.z);
float l9_109=l9_106.x;
float3 l9_110=float3(l9_108,l9_107,l9_109);
float3 l9_111=l9_110;
float l9_112=l9_111.z-(l9_111.y*0.5);
float l9_113=l9_111.y/((1.0-abs((2.0*l9_112)-1.0))+1e-07);
float3 l9_114=float3(l9_111.x,l9_113,l9_112);
float3 l9_115=l9_114;
float l9_116=l9_115.x;
float3 l9_117=param_3;
float3 l9_118=l9_117;
float4 l9_119;
if (l9_118.y<l9_118.z)
{
l9_119=float4(l9_118.zy,-1.0,0.66666669);
}
else
{
l9_119=float4(l9_118.yz,0.0,-0.33333334);
}
float4 l9_120=l9_119;
float4 l9_121;
if (l9_118.x<l9_120.x)
{
l9_121=float4(l9_120.xyw,l9_118.x);
}
else
{
l9_121=float4(l9_118.x,l9_120.yzx);
}
float4 l9_122=l9_121;
float l9_123=l9_122.x-fast::min(l9_122.w,l9_122.y);
float l9_124=abs(((l9_122.w-l9_122.y)/((6.0*l9_123)+1e-07))+l9_122.z);
float l9_125=l9_122.x;
float3 l9_126=float3(l9_124,l9_123,l9_125);
float3 l9_127=l9_126;
float l9_128=l9_127.z-(l9_127.y*0.5);
float l9_129=l9_127.y/((1.0-abs((2.0*l9_128)-1.0))+1e-07);
float3 l9_130=float3(l9_127.x,l9_129,l9_128);
float3 l9_131=float3(l9_116,l9_130.y,l9_115.z);
float l9_132=l9_131.x;
float l9_133=abs((6.0*l9_132)-3.0)-1.0;
float l9_134=2.0-abs((6.0*l9_132)-2.0);
float l9_135=2.0-abs((6.0*l9_132)-4.0);
float3 l9_136=fast::clamp(float3(l9_133,l9_134,l9_135),float3(0.0),float3(1.0));
float3 l9_137=l9_136;
float l9_138=(1.0-abs((2.0*l9_131.z)-1.0))*l9_131.y;
l9_137=((l9_137-float3(0.5))*l9_138)+float3(l9_131.z);
float3 l9_139=l9_137;
float3 l9_140=l9_139;
return l9_140;
}
else
{
if (sc_SoftwareBlendMode_tmp==33)
{
float3 param_4=a;
float3 param_5=b;
float3 l9_141=param_5;
float3 l9_142=l9_141;
float4 l9_143;
if (l9_142.y<l9_142.z)
{
l9_143=float4(l9_142.zy,-1.0,0.66666669);
}
else
{
l9_143=float4(l9_142.yz,0.0,-0.33333334);
}
float4 l9_144=l9_143;
float4 l9_145;
if (l9_142.x<l9_144.x)
{
l9_145=float4(l9_144.xyw,l9_142.x);
}
else
{
l9_145=float4(l9_142.x,l9_144.yzx);
}
float4 l9_146=l9_145;
float l9_147=l9_146.x-fast::min(l9_146.w,l9_146.y);
float l9_148=abs(((l9_146.w-l9_146.y)/((6.0*l9_147)+1e-07))+l9_146.z);
float l9_149=l9_146.x;
float3 l9_150=float3(l9_148,l9_147,l9_149);
float3 l9_151=l9_150;
float l9_152=l9_151.z-(l9_151.y*0.5);
float l9_153=l9_151.y/((1.0-abs((2.0*l9_152)-1.0))+1e-07);
float3 l9_154=float3(l9_151.x,l9_153,l9_152);
float3 l9_155=l9_154;
float l9_156=l9_155.x;
float l9_157=l9_155.y;
float3 l9_158=param_4;
float3 l9_159=l9_158;
float4 l9_160;
if (l9_159.y<l9_159.z)
{
l9_160=float4(l9_159.zy,-1.0,0.66666669);
}
else
{
l9_160=float4(l9_159.yz,0.0,-0.33333334);
}
float4 l9_161=l9_160;
float4 l9_162;
if (l9_159.x<l9_161.x)
{
l9_162=float4(l9_161.xyw,l9_159.x);
}
else
{
l9_162=float4(l9_159.x,l9_161.yzx);
}
float4 l9_163=l9_162;
float l9_164=l9_163.x-fast::min(l9_163.w,l9_163.y);
float l9_165=abs(((l9_163.w-l9_163.y)/((6.0*l9_164)+1e-07))+l9_163.z);
float l9_166=l9_163.x;
float3 l9_167=float3(l9_165,l9_164,l9_166);
float3 l9_168=l9_167;
float l9_169=l9_168.z-(l9_168.y*0.5);
float l9_170=l9_168.y/((1.0-abs((2.0*l9_169)-1.0))+1e-07);
float3 l9_171=float3(l9_168.x,l9_170,l9_169);
float3 l9_172=float3(l9_156,l9_157,l9_171.z);
float l9_173=l9_172.x;
float l9_174=abs((6.0*l9_173)-3.0)-1.0;
float l9_175=2.0-abs((6.0*l9_173)-2.0);
float l9_176=2.0-abs((6.0*l9_173)-4.0);
float3 l9_177=fast::clamp(float3(l9_174,l9_175,l9_176),float3(0.0),float3(1.0));
float3 l9_178=l9_177;
float l9_179=(1.0-abs((2.0*l9_172.z)-1.0))*l9_172.y;
l9_178=((l9_178-float3(0.5))*l9_179)+float3(l9_172.z);
float3 l9_180=l9_178;
float3 l9_181=l9_180;
return l9_181;
}
else
{
if (sc_SoftwareBlendMode_tmp==34)
{
float3 param_6=a;
float3 param_7=b;
float3 l9_182=param_6;
float3 l9_183=l9_182;
float4 l9_184;
if (l9_183.y<l9_183.z)
{
l9_184=float4(l9_183.zy,-1.0,0.66666669);
}
else
{
l9_184=float4(l9_183.yz,0.0,-0.33333334);
}
float4 l9_185=l9_184;
float4 l9_186;
if (l9_183.x<l9_185.x)
{
l9_186=float4(l9_185.xyw,l9_183.x);
}
else
{
l9_186=float4(l9_183.x,l9_185.yzx);
}
float4 l9_187=l9_186;
float l9_188=l9_187.x-fast::min(l9_187.w,l9_187.y);
float l9_189=abs(((l9_187.w-l9_187.y)/((6.0*l9_188)+1e-07))+l9_187.z);
float l9_190=l9_187.x;
float3 l9_191=float3(l9_189,l9_188,l9_190);
float3 l9_192=l9_191;
float l9_193=l9_192.z-(l9_192.y*0.5);
float l9_194=l9_192.y/((1.0-abs((2.0*l9_193)-1.0))+1e-07);
float3 l9_195=float3(l9_192.x,l9_194,l9_193);
float3 l9_196=l9_195;
float l9_197=l9_196.x;
float l9_198=l9_196.y;
float3 l9_199=param_7;
float3 l9_200=l9_199;
float4 l9_201;
if (l9_200.y<l9_200.z)
{
l9_201=float4(l9_200.zy,-1.0,0.66666669);
}
else
{
l9_201=float4(l9_200.yz,0.0,-0.33333334);
}
float4 l9_202=l9_201;
float4 l9_203;
if (l9_200.x<l9_202.x)
{
l9_203=float4(l9_202.xyw,l9_200.x);
}
else
{
l9_203=float4(l9_200.x,l9_202.yzx);
}
float4 l9_204=l9_203;
float l9_205=l9_204.x-fast::min(l9_204.w,l9_204.y);
float l9_206=abs(((l9_204.w-l9_204.y)/((6.0*l9_205)+1e-07))+l9_204.z);
float l9_207=l9_204.x;
float3 l9_208=float3(l9_206,l9_205,l9_207);
float3 l9_209=l9_208;
float l9_210=l9_209.z-(l9_209.y*0.5);
float l9_211=l9_209.y/((1.0-abs((2.0*l9_210)-1.0))+1e-07);
float3 l9_212=float3(l9_209.x,l9_211,l9_210);
float3 l9_213=float3(l9_197,l9_198,l9_212.z);
float l9_214=l9_213.x;
float l9_215=abs((6.0*l9_214)-3.0)-1.0;
float l9_216=2.0-abs((6.0*l9_214)-2.0);
float l9_217=2.0-abs((6.0*l9_214)-4.0);
float3 l9_218=fast::clamp(float3(l9_215,l9_216,l9_217),float3(0.0),float3(1.0));
float3 l9_219=l9_218;
float l9_220=(1.0-abs((2.0*l9_213.z)-1.0))*l9_213.y;
l9_219=((l9_219-float3(0.5))*l9_220)+float3(l9_213.z);
float3 l9_221=l9_219;
float3 l9_222=l9_221;
return l9_222;
}
else
{
float3 param_8=a;
float3 param_9=b;
float3 l9_223=param_8;
float l9_224=((0.29899999*l9_223.x)+(0.58700001*l9_223.y))+(0.114*l9_223.z);
float l9_225=l9_224;
float l9_226=1.0;
float l9_227=pow(l9_225,1.0/UserUniforms.correctedIntensity);
int l9_228;
if ((int(intensityTextureHasSwappedViews_tmp)!=0))
{
int l9_229=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_229=0;
}
else
{
l9_229=varStereoViewID;
}
int l9_230=l9_229;
l9_228=1-l9_230;
}
else
{
int l9_231=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_231=0;
}
else
{
l9_231=varStereoViewID;
}
int l9_232=l9_231;
l9_228=l9_232;
}
int l9_233=l9_228;
int l9_234=intensityTextureLayout_tmp;
int l9_235=l9_233;
float2 l9_236=float2(l9_227,0.5);
bool l9_237=(int(SC_USE_UV_TRANSFORM_intensityTexture_tmp)!=0);
float3x3 l9_238=UserUniforms.intensityTextureTransform;
int2 l9_239=int2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_intensityTexture_tmp);
bool l9_240=(int(SC_USE_UV_MIN_MAX_intensityTexture_tmp)!=0);
float4 l9_241=UserUniforms.intensityTextureUvMinMax;
bool l9_242=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture_tmp)!=0);
float4 l9_243=UserUniforms.intensityTextureBorderColor;
float l9_244=0.0;
bool l9_245=l9_242&&(!l9_240);
float l9_246=1.0;
float l9_247=l9_236.x;
int l9_248=l9_239.x;
if (l9_248==1)
{
l9_247=fract(l9_247);
}
else
{
if (l9_248==2)
{
float l9_249=fract(l9_247);
float l9_250=l9_247-l9_249;
float l9_251=step(0.25,fract(l9_250*0.5));
l9_247=mix(l9_249,1.0-l9_249,fast::clamp(l9_251,0.0,1.0));
}
}
l9_236.x=l9_247;
float l9_252=l9_236.y;
int l9_253=l9_239.y;
if (l9_253==1)
{
l9_252=fract(l9_252);
}
else
{
if (l9_253==2)
{
float l9_254=fract(l9_252);
float l9_255=l9_252-l9_254;
float l9_256=step(0.25,fract(l9_255*0.5));
l9_252=mix(l9_254,1.0-l9_254,fast::clamp(l9_256,0.0,1.0));
}
}
l9_236.y=l9_252;
if (l9_240)
{
bool l9_257=l9_242;
bool l9_258;
if (l9_257)
{
l9_258=l9_239.x==3;
}
else
{
l9_258=l9_257;
}
float l9_259=l9_236.x;
float l9_260=l9_241.x;
float l9_261=l9_241.z;
bool l9_262=l9_258;
float l9_263=l9_246;
float l9_264=fast::clamp(l9_259,l9_260,l9_261);
float l9_265=step(abs(l9_259-l9_264),9.9999997e-06);
l9_263*=(l9_265+((1.0-float(l9_262))*(1.0-l9_265)));
l9_259=l9_264;
l9_236.x=l9_259;
l9_246=l9_263;
bool l9_266=l9_242;
bool l9_267;
if (l9_266)
{
l9_267=l9_239.y==3;
}
else
{
l9_267=l9_266;
}
float l9_268=l9_236.y;
float l9_269=l9_241.y;
float l9_270=l9_241.w;
bool l9_271=l9_267;
float l9_272=l9_246;
float l9_273=fast::clamp(l9_268,l9_269,l9_270);
float l9_274=step(abs(l9_268-l9_273),9.9999997e-06);
l9_272*=(l9_274+((1.0-float(l9_271))*(1.0-l9_274)));
l9_268=l9_273;
l9_236.y=l9_268;
l9_246=l9_272;
}
float2 l9_275=l9_236;
bool l9_276=l9_237;
float3x3 l9_277=l9_238;
if (l9_276)
{
l9_275=float2((l9_277*float3(l9_275,1.0)).xy);
}
float2 l9_278=l9_275;
l9_236=l9_278;
float l9_279=l9_236.x;
int l9_280=l9_239.x;
bool l9_281=l9_245;
float l9_282=l9_246;
if ((l9_280==0)||(l9_280==3))
{
float l9_283=l9_279;
float l9_284=0.0;
float l9_285=1.0;
bool l9_286=l9_281;
float l9_287=l9_282;
float l9_288=fast::clamp(l9_283,l9_284,l9_285);
float l9_289=step(abs(l9_283-l9_288),9.9999997e-06);
l9_287*=(l9_289+((1.0-float(l9_286))*(1.0-l9_289)));
l9_283=l9_288;
l9_279=l9_283;
l9_282=l9_287;
}
l9_236.x=l9_279;
l9_246=l9_282;
float l9_290=l9_236.y;
int l9_291=l9_239.y;
bool l9_292=l9_245;
float l9_293=l9_246;
if ((l9_291==0)||(l9_291==3))
{
float l9_294=l9_290;
float l9_295=0.0;
float l9_296=1.0;
bool l9_297=l9_292;
float l9_298=l9_293;
float l9_299=fast::clamp(l9_294,l9_295,l9_296);
float l9_300=step(abs(l9_294-l9_299),9.9999997e-06);
l9_298*=(l9_300+((1.0-float(l9_297))*(1.0-l9_300)));
l9_294=l9_299;
l9_290=l9_294;
l9_293=l9_298;
}
l9_236.y=l9_290;
l9_246=l9_293;
float2 l9_301=l9_236;
int l9_302=l9_234;
int l9_303=l9_235;
float l9_304=l9_244;
float2 l9_305=l9_301;
int l9_306=l9_302;
int l9_307=l9_303;
float3 l9_308=float3(0.0);
if (l9_306==0)
{
l9_308=float3(l9_305,0.0);
}
else
{
if (l9_306==1)
{
l9_308=float3(l9_305.x,(l9_305.y*0.5)+(0.5-(float(l9_307)*0.5)),0.0);
}
else
{
l9_308=float3(l9_305,float(l9_307));
}
}
float3 l9_309=l9_308;
float3 l9_310=l9_309;
float4 l9_311=intensityTexture.sample(intensityTextureSmpSC,l9_310.xy,bias(l9_304));
float4 l9_312=l9_311;
if (l9_242)
{
l9_312=mix(l9_243,l9_312,float4(l9_246));
}
float4 l9_313=l9_312;
float3 l9_314=l9_313.xyz;
float3 l9_315=l9_314;
float l9_316=16.0;
float l9_317=((((l9_315.x*256.0)+l9_315.y)+(l9_315.z/256.0))/257.00391)*l9_316;
float l9_318=l9_317;
if (sc_SoftwareBlendMode_tmp==43)
{
l9_318=fast::max(l9_318,1.0);
}
if (sc_SoftwareBlendMode_tmp==44)
{
l9_318=fast::min(l9_318,1.0);
}
float l9_319=l9_225;
float3 l9_320=param_8;
float3 l9_321=param_9;
float l9_322=l9_226;
float l9_323=l9_318;
float3 l9_324=transformColor(l9_319,l9_320,l9_321,l9_322,l9_323);
return l9_324;
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
}
float4 sc_OutputMotionVectorIfNeeded(thread const float4& finalColor,thread float4& varPosAndMotion,thread float4& varNormalAndMotion)
{
if ((int(sc_MotionVectorsPass_tmp)!=0))
{
float2 param=float2(varPosAndMotion.w,varNormalAndMotion.w);
float l9_0=(param.x*5.0)+0.5;
float l9_1=floor(l9_0*65535.0);
float l9_2=floor(l9_1*0.00390625);
float2 l9_3=float2(l9_2/255.0,(l9_1-(l9_2*256.0))/255.0);
float l9_4=(param.y*5.0)+0.5;
float l9_5=floor(l9_4*65535.0);
float l9_6=floor(l9_5*0.00390625);
float2 l9_7=float2(l9_6/255.0,(l9_5-(l9_6*256.0))/255.0);
float4 l9_8=float4(l9_3,l9_7);
return l9_8;
}
else
{
return finalColor;
}
}
fragment main_frag_out main_frag(main_frag_in in [[stage_in]],constant sc_Set0& sc_set0 [[buffer(0)]],constant sc_Set1& sc_set1 [[buffer(1)]],constant sc_Set2& sc_set2 [[buffer(2)]],float4 gl_FragCoord [[position]])
{
main_frag_out out={};
if ((int(sc_DepthOnly_tmp)!=0))
{
return out;
}
if ((sc_StereoRenderingMode_tmp==1)&&(sc_StereoRendering_IsClipDistanceEnabled_tmp==0))
{
if (in.varClipDistance<0.0)
{
discard_fragment();
}
}
ssPreviewInfo PreviewInfo;
PreviewInfo.Color=in.PreviewVertexColor;
PreviewInfo.Saved=((in.PreviewVertexSaved*1.0)!=0.0) ? true : false;
float4 FinalColor=float4(1.0);
ssGlobals Globals;
Globals.gTimeElapsed=(*sc_set1.sc_CameraUBO).sc_Time.x;
Globals.gTimeDelta=(*sc_set1.sc_CameraUBO).sc_Time.y;
Globals.BumpedNormal=float3(0.0);
Globals.ViewDirWS=normalize((*sc_set1.sc_CameraUBO).sc_Camera.position-in.varPosAndMotion.xyz);
Globals.PositionWS=in.varPosAndMotion.xyz;
Globals.VertexNormal_WorldSpace=normalize(in.varNormalAndMotion.xyz);
Globals.Surface_UVCoord0=in.varTex01.xy;
float4 Output_N5=float4(0.0);
float4 param=(*sc_set0.UserUniforms).baseColor;
Output_N5=param;
float4 Output_N1=float4(0.0);
int l9_0;
if ((int(baseTexHasSwappedViews_tmp)!=0))
{
int l9_1=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1=0;
}
else
{
l9_1=in.varStereoViewID;
}
int l9_2=l9_1;
l9_0=1-l9_2;
}
else
{
int l9_3=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_3=0;
}
else
{
l9_3=in.varStereoViewID;
}
int l9_4=l9_3;
l9_0=l9_4;
}
int l9_5=l9_0;
int param_1=baseTexLayout_tmp;
int param_2=l9_5;
float2 param_3=Globals.Surface_UVCoord0;
bool param_4=(int(SC_USE_UV_TRANSFORM_baseTex_tmp)!=0);
float3x3 param_5=(*sc_set0.UserUniforms).baseTexTransform;
int2 param_6=int2(SC_SOFTWARE_WRAP_MODE_U_baseTex_tmp,SC_SOFTWARE_WRAP_MODE_V_baseTex_tmp);
bool param_7=(int(SC_USE_UV_MIN_MAX_baseTex_tmp)!=0);
float4 param_8=(*sc_set0.UserUniforms).baseTexUvMinMax;
bool param_9=(int(SC_USE_CLAMP_TO_BORDER_baseTex_tmp)!=0);
float4 param_10=(*sc_set0.UserUniforms).baseTexBorderColor;
float param_11=0.0;
bool l9_6=param_9&&(!param_7);
float l9_7=1.0;
float l9_8=param_3.x;
int l9_9=param_6.x;
if (l9_9==1)
{
l9_8=fract(l9_8);
}
else
{
if (l9_9==2)
{
float l9_10=fract(l9_8);
float l9_11=l9_8-l9_10;
float l9_12=step(0.25,fract(l9_11*0.5));
l9_8=mix(l9_10,1.0-l9_10,fast::clamp(l9_12,0.0,1.0));
}
}
param_3.x=l9_8;
float l9_13=param_3.y;
int l9_14=param_6.y;
if (l9_14==1)
{
l9_13=fract(l9_13);
}
else
{
if (l9_14==2)
{
float l9_15=fract(l9_13);
float l9_16=l9_13-l9_15;
float l9_17=step(0.25,fract(l9_16*0.5));
l9_13=mix(l9_15,1.0-l9_15,fast::clamp(l9_17,0.0,1.0));
}
}
param_3.y=l9_13;
if (param_7)
{
bool l9_18=param_9;
bool l9_19;
if (l9_18)
{
l9_19=param_6.x==3;
}
else
{
l9_19=l9_18;
}
float l9_20=param_3.x;
float l9_21=param_8.x;
float l9_22=param_8.z;
bool l9_23=l9_19;
float l9_24=l9_7;
float l9_25=fast::clamp(l9_20,l9_21,l9_22);
float l9_26=step(abs(l9_20-l9_25),9.9999997e-06);
l9_24*=(l9_26+((1.0-float(l9_23))*(1.0-l9_26)));
l9_20=l9_25;
param_3.x=l9_20;
l9_7=l9_24;
bool l9_27=param_9;
bool l9_28;
if (l9_27)
{
l9_28=param_6.y==3;
}
else
{
l9_28=l9_27;
}
float l9_29=param_3.y;
float l9_30=param_8.y;
float l9_31=param_8.w;
bool l9_32=l9_28;
float l9_33=l9_7;
float l9_34=fast::clamp(l9_29,l9_30,l9_31);
float l9_35=step(abs(l9_29-l9_34),9.9999997e-06);
l9_33*=(l9_35+((1.0-float(l9_32))*(1.0-l9_35)));
l9_29=l9_34;
param_3.y=l9_29;
l9_7=l9_33;
}
float2 l9_36=param_3;
bool l9_37=param_4;
float3x3 l9_38=param_5;
if (l9_37)
{
l9_36=float2((l9_38*float3(l9_36,1.0)).xy);
}
float2 l9_39=l9_36;
param_3=l9_39;
float l9_40=param_3.x;
int l9_41=param_6.x;
bool l9_42=l9_6;
float l9_43=l9_7;
if ((l9_41==0)||(l9_41==3))
{
float l9_44=l9_40;
float l9_45=0.0;
float l9_46=1.0;
bool l9_47=l9_42;
float l9_48=l9_43;
float l9_49=fast::clamp(l9_44,l9_45,l9_46);
float l9_50=step(abs(l9_44-l9_49),9.9999997e-06);
l9_48*=(l9_50+((1.0-float(l9_47))*(1.0-l9_50)));
l9_44=l9_49;
l9_40=l9_44;
l9_43=l9_48;
}
param_3.x=l9_40;
l9_7=l9_43;
float l9_51=param_3.y;
int l9_52=param_6.y;
bool l9_53=l9_6;
float l9_54=l9_7;
if ((l9_52==0)||(l9_52==3))
{
float l9_55=l9_51;
float l9_56=0.0;
float l9_57=1.0;
bool l9_58=l9_53;
float l9_59=l9_54;
float l9_60=fast::clamp(l9_55,l9_56,l9_57);
float l9_61=step(abs(l9_55-l9_60),9.9999997e-06);
l9_59*=(l9_61+((1.0-float(l9_58))*(1.0-l9_61)));
l9_55=l9_60;
l9_51=l9_55;
l9_54=l9_59;
}
param_3.y=l9_51;
l9_7=l9_54;
float2 l9_62=param_3;
int l9_63=param_1;
int l9_64=param_2;
float l9_65=param_11;
float2 l9_66=l9_62;
int l9_67=l9_63;
int l9_68=l9_64;
float3 l9_69=float3(0.0);
if (l9_67==0)
{
l9_69=float3(l9_66,0.0);
}
else
{
if (l9_67==1)
{
l9_69=float3(l9_66.x,(l9_66.y*0.5)+(0.5-(float(l9_68)*0.5)),0.0);
}
else
{
l9_69=float3(l9_66,float(l9_68));
}
}
float3 l9_70=l9_69;
float3 l9_71=l9_70;
float4 l9_72=sc_set0.baseTex.sample(sc_set0.baseTexSmpSC,l9_71.xy,bias(l9_65));
float4 l9_73=l9_72;
if (param_9)
{
l9_73=mix(param_10,l9_73,float4(l9_7));
}
float4 l9_74=l9_73;
Output_N1=l9_74;
float4 Output_N3=float4(0.0);
Output_N3=Output_N5*Output_N1;
float Output_N7=0.0;
Output_N7=Output_N3.w;
float Output_N2=0.0;
float param_12=(*sc_set0.UserUniforms).metallic;
Output_N2=param_12;
float Output_N0=0.0;
float param_13=(*sc_set0.UserUniforms).roughness;
Output_N0=param_13;
float4 Output_N6=float4(0.0);
float3 param_14=Output_N3.xyz;
float param_15=Output_N7;
float3 param_16=(*sc_set0.UserUniforms).Port_Emissive_N006;
float param_17=Output_N2;
float param_18=Output_N0;
float3 param_19=(*sc_set0.UserUniforms).Port_AO_N006;
float3 param_20=(*sc_set0.UserUniforms).Port_SpecularAO_N006;
ssGlobals param_22=Globals;
if (!(int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
param_22.BumpedNormal=param_22.VertexNormal_WorldSpace;
}
param_15=fast::clamp(param_15,0.0,1.0);
float l9_75=param_15;
if (sc_BlendMode_tmp==8)
{
if (l9_75<(*sc_set0.UserUniforms).alphaTestThreshold)
{
discard_fragment();
}
}
if ((int(ENABLE_STIPPLE_PATTERN_TEST_tmp)!=0))
{
float4 l9_76=gl_FragCoord;
float2 l9_77=floor(mod(l9_76.xy,float2(4.0)));
float l9_78=(mod(dot(l9_77,float2(4.0,1.0))*9.0,16.0)+1.0)/17.0;
if (l9_75<l9_78)
{
discard_fragment();
}
}
param_14=fast::max(param_14,float3(0.0));
float4 param_21;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
param_21=float4(param_14,param_15);
}
else
{
param_17=fast::clamp(param_17,0.0,1.0);
param_18=fast::clamp(param_18,0.0,1.0);
float3 l9_79=param_14;
float l9_80=param_15;
float3 l9_81=param_22.BumpedNormal;
float3 l9_82=param_22.PositionWS;
float3 l9_83=param_22.ViewDirWS;
float3 l9_84=param_16;
float l9_85=param_17;
float l9_86=param_18;
float3 l9_87=param_19;
float3 l9_88=param_20;
SurfaceProperties l9_89;
l9_89.albedo=float3(0.0);
l9_89.opacity=1.0;
l9_89.normal=float3(0.0);
l9_89.positionWS=float3(0.0);
l9_89.viewDirWS=float3(0.0);
l9_89.metallic=0.0;
l9_89.roughness=0.0;
l9_89.emissive=float3(0.0);
l9_89.ao=float3(1.0);
l9_89.specularAo=float3(1.0);
l9_89.bakedShadows=float3(1.0);
SurfaceProperties l9_90=l9_89;
SurfaceProperties l9_91=l9_90;
l9_91.opacity=l9_80;
float3 l9_92=l9_79;
float3 l9_93;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_93=float3(pow(l9_92.x,2.2),pow(l9_92.y,2.2),pow(l9_92.z,2.2));
}
else
{
l9_93=l9_92*l9_92;
}
float3 l9_94=l9_93;
l9_91.albedo=l9_94;
l9_91.normal=normalize(l9_81);
l9_91.positionWS=l9_82;
l9_91.viewDirWS=l9_83;
float3 l9_95=l9_84;
float3 l9_96;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_96=float3(pow(l9_95.x,2.2),pow(l9_95.y,2.2),pow(l9_95.z,2.2));
}
else
{
l9_96=l9_95*l9_95;
}
float3 l9_97=l9_96;
l9_91.emissive=l9_97;
l9_91.metallic=l9_85;
l9_91.roughness=l9_86;
l9_91.ao=l9_87;
l9_91.specularAo=l9_88;
if ((int(sc_SSAOEnabled_tmp)!=0))
{
float3 l9_98=l9_91.positionWS;
l9_91.ao=evaluateSSAO(l9_98,in.varStereoViewID,(*sc_set1.sc_CameraUBO),sc_set0.sc_SSAOTexture,sc_set0.sc_SSAOTextureSmpSC);
}
SurfaceProperties l9_99=l9_91;
SurfaceProperties l9_100=l9_99;
float3 l9_101=mix(float3(0.039999999),l9_100.albedo*l9_100.metallic,float3(l9_100.metallic));
float3 l9_102=mix(l9_100.albedo*(1.0-l9_100.metallic),float3(0.0),float3(l9_100.metallic));
l9_99.albedo=l9_102;
l9_99.specColor=l9_101;
SurfaceProperties l9_103=l9_99;
l9_91=l9_103;
SurfaceProperties l9_104=l9_91;
LightingComponents l9_105;
l9_105.directDiffuse=float3(0.0);
l9_105.directSpecular=float3(0.0);
l9_105.indirectDiffuse=float3(1.0);
l9_105.indirectSpecular=float3(0.0);
l9_105.emitted=float3(0.0);
l9_105.transmitted=float3(0.0);
LightingComponents l9_106=l9_105;
LightingComponents l9_107=l9_106;
float3 l9_108=l9_104.viewDirWS;
int l9_109=0;
float4 l9_110=float4(l9_104.bakedShadows,1.0);
if (sc_DirectionalLightsCount_tmp>0)
{
sc_DirectionalLight_t l9_111;
LightProperties l9_112;
int l9_113=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_113<sc_DirectionalLightsCount_tmp)
{
l9_111.direction=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_113].direction;
l9_111.color=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_113].color;
l9_111.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_113].shadowMapParamsIndex;
l9_112.direction=l9_111.direction;
l9_112.color=l9_111.color.xyz;
l9_112.attenuation=l9_111.color.w;
l9_112.attenuation*=l9_110[(l9_109<3) ? l9_109 : 3];
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_111.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_114=l9_113;
float l9_115=evaluateDirectionalShadowMap(l9_114,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_116=l9_111.shadowMapParamsIndex;
float3 l9_117=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_116].params[0].xyz;
float3 l9_118=l9_117;
l9_112.color=mix(l9_118,l9_112.color,float3(l9_115));
}
}
l9_109++;
LightingComponents l9_119=l9_107;
LightProperties l9_120=l9_112;
SurfaceProperties l9_121=l9_104;
float3 l9_122=l9_108;
SurfaceProperties l9_123=l9_121;
float3 l9_124=l9_120.direction;
float l9_125=dot(l9_123.normal,l9_124);
float l9_126=fast::clamp(l9_125,0.0,1.0);
float3 l9_127=float3(l9_126);
l9_119.directDiffuse+=((l9_127*l9_120.color)*l9_120.attenuation);
SurfaceProperties l9_128=l9_121;
float3 l9_129=l9_120.direction;
float3 l9_130=l9_122;
l9_119.directSpecular+=((calculateDirectSpecular(l9_128,l9_129,l9_130)*l9_120.color)*l9_120.attenuation);
LightingComponents l9_131=l9_119;
l9_107=l9_131;
l9_113++;
continue;
}
else
{
break;
}
}
}
if (sc_PointLightsCount_tmp>0)
{
sc_PointLight_t l9_132;
LightProperties l9_133;
int l9_134=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_134<sc_PointLightsCount_tmp)
{
l9_132.falloffRangeSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].falloffRangeSqr;
l9_132.falloffRangeNegInvSqrSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].falloffRangeNegInvSqrSqr;
l9_132.angleScale=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].angleScale;
l9_132.angleOffset=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].angleOffset;
l9_132.direction=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].direction;
l9_132.position=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].position;
l9_132.color=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].color;
l9_132.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_134].shadowMapParamsIndex;
float3 l9_135=l9_132.position-l9_104.positionWS;
float l9_136=dot(l9_135,l9_135);
float l9_137=l9_132.falloffRangeSqr;
float l9_138=l9_136;
float l9_139=l9_137;
bool l9_140=l9_139>0.0;
bool l9_141=l9_140&&(l9_138>l9_137);
if (!l9_141)
{
float l9_142=rsqrt(l9_136);
l9_133.direction=l9_135*l9_142;
l9_133.color=l9_132.color.xyz;
l9_133.attenuation=l9_132.color.w;
l9_133.attenuation*=l9_110[(l9_109<3) ? l9_109 : 3];
float3 l9_143=l9_133.direction;
float3 l9_144=l9_132.direction;
float l9_145=l9_132.angleScale;
float l9_146=l9_132.angleOffset;
float l9_147=dot(l9_143,l9_144);
float l9_148=fast::clamp((l9_147*l9_145)+l9_146,0.0,1.0);
float l9_149=l9_148*l9_148;
l9_133.attenuation*=l9_149;
float l9_150=l9_132.falloffRangeSqr;
bool l9_151=l9_150>0.0;
if (l9_151)
{
float l9_152=l9_142*l9_142;
float l9_153=l9_136;
float l9_154=l9_152;
float l9_155=l9_132.falloffRangeNegInvSqrSqr;
float l9_156=10000.0;
float l9_157=l9_155;
bool l9_158=l9_157!=0.0;
if (l9_158)
{
float l9_159=l9_153*l9_153;
l9_156+=(l9_159*l9_155);
l9_156=fast::max(l9_156,0.0);
}
float l9_160=l9_156*l9_154;
l9_133.attenuation*=l9_160;
}
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_132.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_161=l9_134;
float3 l9_162=-l9_133.direction;
float l9_163=evaluatePointShadowMap(l9_161,l9_162,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_164=l9_132.shadowMapParamsIndex;
float3 l9_165=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_164].params[0].xyz;
float3 l9_166=l9_165;
l9_133.color=mix(l9_166,l9_133.color,float3(l9_163));
}
}
LightingComponents l9_167=l9_107;
LightProperties l9_168=l9_133;
SurfaceProperties l9_169=l9_104;
float3 l9_170=l9_108;
SurfaceProperties l9_171=l9_169;
float3 l9_172=l9_168.direction;
float l9_173=dot(l9_171.normal,l9_172);
float l9_174=fast::clamp(l9_173,0.0,1.0);
float3 l9_175=float3(l9_174);
l9_167.directDiffuse+=((l9_175*l9_168.color)*l9_168.attenuation);
SurfaceProperties l9_176=l9_169;
float3 l9_177=l9_168.direction;
float3 l9_178=l9_170;
l9_167.directSpecular+=((calculateDirectSpecular(l9_176,l9_177,l9_178)*l9_168.color)*l9_168.attenuation);
LightingComponents l9_179=l9_167;
l9_107=l9_179;
}
l9_109++;
l9_134++;
continue;
}
else
{
break;
}
}
}
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float3 l9_180=float3(0.0);
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float2 l9_181=abs(in.varShadowTex-float2(0.5));
float l9_182=fast::max(l9_181.x,l9_181.y);
float l9_183=step(l9_182,0.5);
float4 l9_184=sc_set0.sc_ShadowTexture.sample(sc_set0.sc_ShadowTextureSmpSC,in.varShadowTex)*l9_183;
float3 l9_185=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_184.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float l9_186=l9_184.w*(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity;
l9_180=mix(float3(1.0),l9_185,float3(l9_186));
}
else
{
l9_180=float3(1.0);
}
float3 l9_187=l9_180;
float3 l9_188=l9_187;
l9_107.directDiffuse*=l9_188;
l9_107.directSpecular*=l9_188;
}
SurfaceProperties l9_189=l9_104;
float3 l9_190=l9_189.normal;
float3 l9_191=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
float3 l9_192=l9_190;
float4 l9_193=float4(0.0);
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp)
{
float3 l9_194=l9_192;
float l9_195=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_196=float2(0.0);
float l9_197=l9_194.x;
float l9_198=-l9_194.z;
float l9_199=(l9_197<0.0) ? (-1.0) : 1.0;
float l9_200=l9_199*acos(fast::clamp(l9_198/length(float2(l9_197,l9_198)),-1.0,1.0));
l9_196.x=l9_200-1.5707964;
l9_196.y=acos(l9_194.y);
l9_196/=float2(6.2831855,3.1415927);
l9_196.y=1.0-l9_196.y;
l9_196.x+=(l9_195/360.0);
l9_196.x=fract((l9_196.x+floor(l9_196.x))+1.0);
float2 l9_201=l9_196;
float2 l9_202=l9_201;
if (SC_DEVICE_CLASS_tmp>=2)
{
float2 l9_203=l9_202;
float2 l9_204=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_205=5.0;
l9_202=calcSeamlessPanoramicUvsForSampling(l9_203,l9_204,l9_205);
}
float2 l9_206=l9_202;
float l9_207=13.0;
int l9_208;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_209=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_209=0;
}
else
{
l9_209=in.varStereoViewID;
}
int l9_210=l9_209;
l9_208=1-l9_210;
}
else
{
int l9_211=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_211=0;
}
else
{
l9_211=in.varStereoViewID;
}
int l9_212=l9_211;
l9_208=l9_212;
}
int l9_213=l9_208;
float2 l9_214=l9_206;
int l9_215=sc_EnvmapSpecularLayout_tmp;
int l9_216=l9_213;
float l9_217=l9_207;
float2 l9_218=l9_214;
int l9_219=l9_215;
int l9_220=l9_216;
float3 l9_221=float3(0.0);
if (l9_219==0)
{
l9_221=float3(l9_218,0.0);
}
else
{
if (l9_219==1)
{
l9_221=float3(l9_218.x,(l9_218.y*0.5)+(0.5-(float(l9_220)*0.5)),0.0);
}
else
{
l9_221=float3(l9_218,float(l9_220));
}
}
float3 l9_222=l9_221;
float3 l9_223=l9_222;
float4 l9_224=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_223.xy,bias(l9_217));
float4 l9_225=l9_224;
l9_193=l9_225;
}
else
{
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_226=l9_192;
float l9_227=0.18000001;
float l9_228=4.5;
float3 l9_229=l9_226;
float3 l9_230=float3(((-l9_229.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_229.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_229.y,(l9_229.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_229.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
l9_226=l9_230;
float3 l9_231;
if (abs(l9_226.z)<0.99000001)
{
l9_231=float3(-l9_226.y,l9_226.x,0.0);
}
else
{
l9_231=float3(0.0,-l9_226.z,l9_226.y);
}
float3 l9_232=normalize(l9_231);
float3 l9_233=cross(l9_226,l9_232);
float3 l9_234=l9_226+(((l9_232*1.0)+(l9_233*0.0))*l9_227);
float3 l9_235=l9_226+(((l9_232*(-0.5))+(l9_233*0.86602539))*l9_227);
float3 l9_236=l9_226+(((l9_232*(-0.5))-(l9_233*0.86602539))*l9_227);
float3 l9_237=l9_234;
bool l9_238=true;
float l9_239=l9_228;
float4 l9_240;
if (l9_238)
{
l9_240=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_237,level(l9_239));
}
else
{
l9_240=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_237,bias(l9_239));
}
float4 l9_241=l9_240;
float4 l9_242=l9_241;
float3 l9_243=l9_235;
bool l9_244=true;
float l9_245=l9_228;
float4 l9_246;
if (l9_244)
{
l9_246=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_243,level(l9_245));
}
else
{
l9_246=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_243,bias(l9_245));
}
float4 l9_247=l9_246;
float4 l9_248=l9_247;
float3 l9_249=l9_236;
bool l9_250=true;
float l9_251=l9_228;
float4 l9_252;
if (l9_250)
{
l9_252=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_249,level(l9_251));
}
else
{
l9_252=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_249,bias(l9_251));
}
float4 l9_253=l9_252;
float4 l9_254=l9_253;
float4 l9_255=((l9_242+l9_248)+l9_254)*0.33333334;
l9_193=l9_255;
}
else
{
float3 l9_256=l9_192;
float l9_257=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_258=float2(0.0);
float l9_259=l9_256.x;
float l9_260=-l9_256.z;
float l9_261=(l9_259<0.0) ? (-1.0) : 1.0;
float l9_262=l9_261*acos(fast::clamp(l9_260/length(float2(l9_259,l9_260)),-1.0,1.0));
l9_258.x=l9_262-1.5707964;
l9_258.y=acos(l9_256.y);
l9_258/=float2(6.2831855,3.1415927);
l9_258.y=1.0-l9_258.y;
l9_258.x+=(l9_257/360.0);
l9_258.x=fract((l9_258.x+floor(l9_258.x))+1.0);
float2 l9_263=l9_258;
float2 l9_264=l9_263;
if ((int(sc_HasDiffuseEnvmap_tmp)!=0))
{
float2 l9_265=l9_264;
float2 l9_266=(*sc_set1.sc_LightingUBO).sc_EnvmapDiffuseSize.xy;
float l9_267=0.0;
l9_264=calcSeamlessPanoramicUvsForSampling(l9_265,l9_266,l9_267);
float2 l9_268=l9_264;
float l9_269=-13.0;
int l9_270;
if ((int(sc_EnvmapDiffuseHasSwappedViews_tmp)!=0))
{
int l9_271=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_271=0;
}
else
{
l9_271=in.varStereoViewID;
}
int l9_272=l9_271;
l9_270=1-l9_272;
}
else
{
int l9_273=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_273=0;
}
else
{
l9_273=in.varStereoViewID;
}
int l9_274=l9_273;
l9_270=l9_274;
}
int l9_275=l9_270;
float2 l9_276=l9_268;
int l9_277=sc_EnvmapDiffuseLayout_tmp;
int l9_278=l9_275;
float l9_279=l9_269;
float2 l9_280=l9_276;
int l9_281=l9_277;
int l9_282=l9_278;
float3 l9_283=float3(0.0);
if (l9_281==0)
{
l9_283=float3(l9_280,0.0);
}
else
{
if (l9_281==1)
{
l9_283=float3(l9_280.x,(l9_280.y*0.5)+(0.5-(float(l9_282)*0.5)),0.0);
}
else
{
l9_283=float3(l9_280,float(l9_282));
}
}
float3 l9_284=l9_283;
float3 l9_285=l9_284;
float4 l9_286=sc_set0.sc_EnvmapDiffuse.sample(sc_set0.sc_EnvmapDiffuseSmpSC,l9_285.xy,bias(l9_279));
float4 l9_287=l9_286;
l9_193=l9_287;
}
else
{
float2 l9_288=l9_264;
float l9_289=13.0;
int l9_290;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_291=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_291=0;
}
else
{
l9_291=in.varStereoViewID;
}
int l9_292=l9_291;
l9_290=1-l9_292;
}
else
{
int l9_293=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_293=0;
}
else
{
l9_293=in.varStereoViewID;
}
int l9_294=l9_293;
l9_290=l9_294;
}
int l9_295=l9_290;
float2 l9_296=l9_288;
int l9_297=sc_EnvmapSpecularLayout_tmp;
int l9_298=l9_295;
float l9_299=l9_289;
float2 l9_300=l9_296;
int l9_301=l9_297;
int l9_302=l9_298;
float3 l9_303=float3(0.0);
if (l9_301==0)
{
l9_303=float3(l9_300,0.0);
}
else
{
if (l9_301==1)
{
l9_303=float3(l9_300.x,(l9_300.y*0.5)+(0.5-(float(l9_302)*0.5)),0.0);
}
else
{
l9_303=float3(l9_300,float(l9_302));
}
}
float3 l9_304=l9_303;
float3 l9_305=l9_304;
float4 l9_306=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_305.xy,bias(l9_299));
float4 l9_307=l9_306;
l9_193=l9_307;
}
}
}
float4 l9_308=l9_193;
float3 l9_309=l9_308.xyz*(1.0/fast::max(l9_308.w,0.0039215689));
float3 l9_310=l9_309*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_191=l9_310;
}
else
{
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_SphericalHarmonics_tmp)
{
float3 l9_311=(*sc_set1.sc_LightingUBO).sc_Sh[0];
float3 l9_312=(*sc_set1.sc_LightingUBO).sc_Sh[1];
float3 l9_313=(*sc_set1.sc_LightingUBO).sc_Sh[2];
float3 l9_314=(*sc_set1.sc_LightingUBO).sc_Sh[3];
float3 l9_315=(*sc_set1.sc_LightingUBO).sc_Sh[4];
float3 l9_316=(*sc_set1.sc_LightingUBO).sc_Sh[5];
float3 l9_317=(*sc_set1.sc_LightingUBO).sc_Sh[6];
float3 l9_318=(*sc_set1.sc_LightingUBO).sc_Sh[7];
float3 l9_319=(*sc_set1.sc_LightingUBO).sc_Sh[8];
float3 l9_320=-l9_190;
float l9_321=0.0;
l9_321=l9_320.x;
float l9_322=l9_320.y;
float l9_323=l9_320.z;
float l9_324=l9_321*l9_321;
float l9_325=l9_322*l9_322;
float l9_326=l9_323*l9_323;
float l9_327=l9_321*l9_322;
float l9_328=l9_322*l9_323;
float l9_329=l9_321*l9_323;
float3 l9_330=((((((l9_319*0.42904299)*(l9_324-l9_325))+((l9_317*0.74312502)*l9_326))+(l9_311*0.88622701))-(l9_317*0.24770799))+((((l9_315*l9_327)+(l9_318*l9_329))+(l9_316*l9_328))*0.85808599))+((((l9_314*l9_321)+(l9_312*l9_322))+(l9_313*l9_323))*1.0233279);
l9_191=l9_330*(*sc_set1.sc_LightingUBO).sc_ShIntensity;
}
}
if (sc_AmbientLightsCount_tmp>0)
{
if (sc_AmbientLightMode0_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_191+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].intensity);
}
else
{
l9_191.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color.x);
}
}
if (sc_AmbientLightsCount_tmp>1)
{
if (sc_AmbientLightMode1_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_191+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].intensity);
}
else
{
l9_191.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color.x);
}
}
if (sc_AmbientLightsCount_tmp>2)
{
if (sc_AmbientLightMode2_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_191+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].intensity);
}
else
{
l9_191.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color.x);
}
}
if ((int(sc_LightEstimation_tmp)!=0))
{
float3 l9_331=l9_190;
float3 l9_332=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight;
sc_SphericalGaussianLight_t l9_333;
float l9_334;
int l9_335=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_335<sc_LightEstimationSGCount_tmp)
{
l9_333.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_335].color;
l9_333.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_335].sharpness;
l9_333.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_335].axis;
float3 l9_336=l9_331;
float l9_337=dot(l9_333.axis,l9_336);
float l9_338=l9_333.sharpness;
float l9_339=0.36000001;
float l9_340=1.0/(4.0*l9_339);
float l9_341=exp(-l9_338);
float l9_342=l9_341*l9_341;
float l9_343=1.0/l9_338;
float l9_344=(1.0+(2.0*l9_342))-l9_343;
float l9_345=((l9_341-l9_342)*l9_343)-l9_342;
float l9_346=sqrt(1.0-l9_344);
float l9_347=l9_339*l9_337;
float l9_348=l9_340*l9_346;
float l9_349=l9_347+l9_348;
float l9_350=l9_337;
float l9_351=fast::clamp(l9_350,0.0,1.0);
float l9_352=l9_351;
if (step(abs(l9_347),l9_348)>0.5)
{
l9_334=(l9_349*l9_349)/l9_346;
}
else
{
l9_334=l9_352;
}
l9_352=l9_334;
float l9_353=(l9_344*l9_352)+l9_345;
sc_SphericalGaussianLight_t l9_354=l9_333;
float3 l9_355=(l9_354.color/float3(l9_354.sharpness))*6.2831855;
float3 l9_356=(l9_355*l9_353)/float3(3.1415927);
l9_332+=l9_356;
l9_335++;
continue;
}
else
{
break;
}
}
float3 l9_357=l9_332;
l9_191+=l9_357;
}
float3 l9_358=l9_191;
float3 l9_359=l9_358;
l9_107.indirectDiffuse=l9_359;
SurfaceProperties l9_360=l9_104;
float3 l9_361=l9_108;
float3 l9_362=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
SurfaceProperties l9_363=l9_360;
float3 l9_364=l9_361;
float3 l9_365=l9_363.normal;
float3 l9_366=reflect(-l9_364,l9_365);
float3 l9_367=l9_365;
float3 l9_368=l9_366;
float l9_369=l9_363.roughness;
l9_366=getSpecularDominantDir(l9_367,l9_368,l9_369);
float l9_370=l9_363.roughness;
float l9_371=pow(l9_370,0.66666669);
float l9_372=fast::clamp(l9_371,0.0,1.0);
float l9_373=l9_372*5.0;
float l9_374=l9_373;
float l9_375=l9_374;
float3 l9_376=l9_366;
float l9_377=l9_375;
float3 l9_378=l9_376;
float l9_379=l9_377;
float4 l9_380=float4(0.0);
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_381=l9_378;
float3 l9_382=float3(((-l9_381.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_381.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_381.y,(l9_381.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_381.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
float3 l9_383=l9_382;
bool l9_384=true;
float l9_385=l9_379;
float4 l9_386;
if (l9_384)
{
l9_386=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_383,level(l9_385));
}
else
{
l9_386=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_383,bias(l9_385));
}
float4 l9_387=l9_386;
l9_380=l9_387;
}
else
{
float3 l9_388=l9_378;
float l9_389=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_390=float2(0.0);
float l9_391=l9_388.x;
float l9_392=-l9_388.z;
float l9_393=(l9_391<0.0) ? (-1.0) : 1.0;
float l9_394=l9_393*acos(fast::clamp(l9_392/length(float2(l9_391,l9_392)),-1.0,1.0));
l9_390.x=l9_394-1.5707964;
l9_390.y=acos(l9_388.y);
l9_390/=float2(6.2831855,3.1415927);
l9_390.y=1.0-l9_390.y;
l9_390.x+=(l9_389/360.0);
l9_390.x=fract((l9_390.x+floor(l9_390.x))+1.0);
float2 l9_395=l9_390;
float2 l9_396=l9_395;
if (SC_DEVICE_CLASS_tmp>=2)
{
float l9_397=floor(l9_379);
float l9_398=ceil(l9_379);
float l9_399=l9_379-l9_397;
float2 l9_400=l9_396;
float2 l9_401=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_402=l9_397;
float2 l9_403=calcSeamlessPanoramicUvsForSampling(l9_400,l9_401,l9_402);
float2 l9_404=l9_403;
float l9_405=l9_397;
float2 l9_406=l9_404;
float l9_407=l9_405;
int l9_408;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_409=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_409=0;
}
else
{
l9_409=in.varStereoViewID;
}
int l9_410=l9_409;
l9_408=1-l9_410;
}
else
{
int l9_411=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_411=0;
}
else
{
l9_411=in.varStereoViewID;
}
int l9_412=l9_411;
l9_408=l9_412;
}
int l9_413=l9_408;
float2 l9_414=l9_406;
int l9_415=sc_EnvmapSpecularLayout_tmp;
int l9_416=l9_413;
float l9_417=l9_407;
float2 l9_418=l9_414;
int l9_419=l9_415;
int l9_420=l9_416;
float3 l9_421=float3(0.0);
if (l9_419==0)
{
l9_421=float3(l9_418,0.0);
}
else
{
if (l9_419==1)
{
l9_421=float3(l9_418.x,(l9_418.y*0.5)+(0.5-(float(l9_420)*0.5)),0.0);
}
else
{
l9_421=float3(l9_418,float(l9_420));
}
}
float3 l9_422=l9_421;
float3 l9_423=l9_422;
float4 l9_424=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_423.xy,level(l9_417));
float4 l9_425=l9_424;
float4 l9_426=l9_425;
float4 l9_427=l9_426;
float2 l9_428=l9_396;
float2 l9_429=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_430=l9_398;
float2 l9_431=calcSeamlessPanoramicUvsForSampling(l9_428,l9_429,l9_430);
float2 l9_432=l9_431;
float l9_433=l9_398;
float2 l9_434=l9_432;
float l9_435=l9_433;
int l9_436;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_437=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_437=0;
}
else
{
l9_437=in.varStereoViewID;
}
int l9_438=l9_437;
l9_436=1-l9_438;
}
else
{
int l9_439=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_439=0;
}
else
{
l9_439=in.varStereoViewID;
}
int l9_440=l9_439;
l9_436=l9_440;
}
int l9_441=l9_436;
float2 l9_442=l9_434;
int l9_443=sc_EnvmapSpecularLayout_tmp;
int l9_444=l9_441;
float l9_445=l9_435;
float2 l9_446=l9_442;
int l9_447=l9_443;
int l9_448=l9_444;
float3 l9_449=float3(0.0);
if (l9_447==0)
{
l9_449=float3(l9_446,0.0);
}
else
{
if (l9_447==1)
{
l9_449=float3(l9_446.x,(l9_446.y*0.5)+(0.5-(float(l9_448)*0.5)),0.0);
}
else
{
l9_449=float3(l9_446,float(l9_448));
}
}
float3 l9_450=l9_449;
float3 l9_451=l9_450;
float4 l9_452=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_451.xy,level(l9_445));
float4 l9_453=l9_452;
float4 l9_454=l9_453;
float4 l9_455=l9_454;
l9_380=mix(l9_427,l9_455,float4(l9_399));
}
else
{
float2 l9_456=l9_396;
float l9_457=l9_379;
float2 l9_458=l9_456;
float l9_459=l9_457;
int l9_460;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_461=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_461=0;
}
else
{
l9_461=in.varStereoViewID;
}
int l9_462=l9_461;
l9_460=1-l9_462;
}
else
{
int l9_463=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_463=0;
}
else
{
l9_463=in.varStereoViewID;
}
int l9_464=l9_463;
l9_460=l9_464;
}
int l9_465=l9_460;
float2 l9_466=l9_458;
int l9_467=sc_EnvmapSpecularLayout_tmp;
int l9_468=l9_465;
float l9_469=l9_459;
float2 l9_470=l9_466;
int l9_471=l9_467;
int l9_472=l9_468;
float3 l9_473=float3(0.0);
if (l9_471==0)
{
l9_473=float3(l9_470,0.0);
}
else
{
if (l9_471==1)
{
l9_473=float3(l9_470.x,(l9_470.y*0.5)+(0.5-(float(l9_472)*0.5)),0.0);
}
else
{
l9_473=float3(l9_470,float(l9_472));
}
}
float3 l9_474=l9_473;
float3 l9_475=l9_474;
float4 l9_476=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_475.xy,level(l9_469));
float4 l9_477=l9_476;
float4 l9_478=l9_477;
l9_380=l9_478;
}
}
float4 l9_479=l9_380;
float3 l9_480=l9_479.xyz*(1.0/fast::max(l9_479.w,0.0039215689));
float3 l9_481=l9_480;
float3 l9_482=l9_481*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_482.x+=(*sc_set1.sc_CameraUBO).sc_UniformConstants.x;
float3 l9_483=l9_482;
float3 l9_484=l9_483;
float l9_485=abs(dot(l9_365,l9_364));
SurfaceProperties l9_486=l9_363;
float l9_487=l9_485;
float3 l9_488=l9_484*envBRDFApprox(l9_486,l9_487);
l9_362+=l9_488;
}
if ((int(sc_LightEstimation_tmp)!=0))
{
SurfaceProperties l9_489=l9_360;
float3 l9_490=l9_361;
float l9_491=fast::clamp(l9_489.roughness*l9_489.roughness,0.0099999998,1.0);
float3 l9_492=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight*l9_489.specColor;
sc_SphericalGaussianLight_t l9_493;
sc_SphericalGaussianLight_t l9_494;
sc_SphericalGaussianLight_t l9_495;
int l9_496=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_496<sc_LightEstimationSGCount_tmp)
{
l9_493.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_496].color;
l9_493.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_496].sharpness;
l9_493.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_496].axis;
float3 l9_497=l9_489.normal;
float l9_498=l9_491;
float3 l9_499=l9_490;
float3 l9_500=l9_489.specColor;
float3 l9_501=l9_497;
float l9_502=l9_498;
l9_494.axis=l9_501;
float l9_503=l9_502*l9_502;
l9_494.sharpness=2.0/l9_503;
l9_494.color=float3(1.0/(3.1415927*l9_503));
sc_SphericalGaussianLight_t l9_504=l9_494;
sc_SphericalGaussianLight_t l9_505=l9_504;
sc_SphericalGaussianLight_t l9_506=l9_505;
float3 l9_507=l9_499;
l9_495.axis=reflect(-l9_507,l9_506.axis);
l9_495.color=l9_506.color;
l9_495.sharpness=l9_506.sharpness;
l9_495.sharpness/=(4.0*fast::max(dot(l9_506.axis,l9_507),9.9999997e-05));
sc_SphericalGaussianLight_t l9_508=l9_495;
sc_SphericalGaussianLight_t l9_509=l9_508;
sc_SphericalGaussianLight_t l9_510=l9_509;
sc_SphericalGaussianLight_t l9_511=l9_493;
float l9_512=length((l9_510.axis*l9_510.sharpness)+(l9_511.axis*l9_511.sharpness));
float3 l9_513=(l9_510.color*exp((l9_512-l9_510.sharpness)-l9_511.sharpness))*l9_511.color;
float l9_514=1.0-exp((-2.0)*l9_512);
float3 l9_515=((l9_513*6.2831855)*l9_514)/float3(l9_512);
float3 l9_516=l9_515;
float3 l9_517=l9_509.axis;
float l9_518=l9_498*l9_498;
float l9_519=dot(l9_497,l9_517);
float l9_520=fast::clamp(l9_519,0.0,1.0);
float l9_521=l9_520;
float l9_522=dot(l9_497,l9_499);
float l9_523=fast::clamp(l9_522,0.0,1.0);
float l9_524=l9_523;
float3 l9_525=normalize(l9_509.axis+l9_499);
float l9_526=l9_518;
float l9_527=l9_521;
float l9_528=1.0/(l9_527+sqrt(l9_526+(((1.0-l9_526)*l9_527)*l9_527)));
float l9_529=l9_518;
float l9_530=l9_524;
float l9_531=1.0/(l9_530+sqrt(l9_529+(((1.0-l9_529)*l9_530)*l9_530)));
l9_516*=(l9_528*l9_531);
float l9_532=dot(l9_517,l9_525);
float l9_533=fast::clamp(l9_532,0.0,1.0);
float l9_534=pow(1.0-l9_533,5.0);
l9_516*=(l9_500+((float3(1.0)-l9_500)*l9_534));
l9_516*=l9_521;
float3 l9_535=l9_516;
l9_492+=l9_535;
l9_496++;
continue;
}
else
{
break;
}
}
float3 l9_536=l9_492;
l9_362+=l9_536;
}
float3 l9_537=l9_362;
l9_107.indirectSpecular=l9_537;
LightingComponents l9_538=l9_107;
LightingComponents l9_539=l9_538;
if (sc_BlendMode_tmp==9)
{
l9_539.directDiffuse=float3(0.0);
l9_539.indirectDiffuse=float3(0.0);
float4 l9_540=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_541=out.sc_FragData0;
l9_540=l9_541;
}
else
{
float4 l9_542=gl_FragCoord;
float2 l9_543=l9_542.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_544=l9_543;
float2 l9_545=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_546=1;
int l9_547=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_547=0;
}
else
{
l9_547=in.varStereoViewID;
}
int l9_548=l9_547;
int l9_549=l9_548;
float3 l9_550=float3(l9_544,0.0);
int l9_551=l9_546;
int l9_552=l9_549;
if (l9_551==1)
{
l9_550.y=((2.0*l9_550.y)+float(l9_552))-1.0;
}
float2 l9_553=l9_550.xy;
l9_545=l9_553;
}
else
{
l9_545=l9_544;
}
float2 l9_554=l9_545;
float2 l9_555=l9_554;
float2 l9_556=l9_555;
float2 l9_557=l9_556;
float l9_558=0.0;
int l9_559;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_560=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_560=0;
}
else
{
l9_560=in.varStereoViewID;
}
int l9_561=l9_560;
l9_559=1-l9_561;
}
else
{
int l9_562=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_562=0;
}
else
{
l9_562=in.varStereoViewID;
}
int l9_563=l9_562;
l9_559=l9_563;
}
int l9_564=l9_559;
float2 l9_565=l9_557;
int l9_566=sc_ScreenTextureLayout_tmp;
int l9_567=l9_564;
float l9_568=l9_558;
float2 l9_569=l9_565;
int l9_570=l9_566;
int l9_571=l9_567;
float3 l9_572=float3(0.0);
if (l9_570==0)
{
l9_572=float3(l9_569,0.0);
}
else
{
if (l9_570==1)
{
l9_572=float3(l9_569.x,(l9_569.y*0.5)+(0.5-(float(l9_571)*0.5)),0.0);
}
else
{
l9_572=float3(l9_569,float(l9_571));
}
}
float3 l9_573=l9_572;
float3 l9_574=l9_573;
float4 l9_575=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_574.xy,bias(l9_568));
float4 l9_576=l9_575;
float4 l9_577=l9_576;
l9_540=l9_577;
}
float4 l9_578=l9_540;
float3 l9_579=l9_578.xyz;
float3 l9_580;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_580=float3(pow(l9_579.x,2.2),pow(l9_579.y,2.2),pow(l9_579.z,2.2));
}
else
{
l9_580=l9_579*l9_579;
}
float3 l9_581=l9_580;
float3 l9_582=l9_581;
l9_539.transmitted=l9_582*mix(float3(1.0),l9_91.albedo,float3(l9_91.opacity));
l9_91.opacity=1.0;
}
bool l9_583=false;
if (sc_BlendMode_tmp==4)
{
l9_583=true;
}
SurfaceProperties l9_584=l9_91;
LightingComponents l9_585=l9_539;
bool l9_586=l9_583;
float3 l9_587=l9_584.albedo*(l9_585.directDiffuse+(l9_585.indirectDiffuse*l9_584.ao));
float3 l9_588=l9_585.directSpecular+(l9_585.indirectSpecular*l9_584.specularAo);
float3 l9_589=l9_584.emissive;
float3 l9_590=l9_585.transmitted;
if (l9_586)
{
float l9_591=l9_584.opacity;
l9_587*=srgbToLinear(l9_591);
}
float3 l9_592=((l9_587+l9_588)+l9_589)+l9_590;
float3 l9_593=l9_592;
float4 l9_594=float4(l9_593,l9_91.opacity);
if (sc_BlendMode_tmp!=1)
{
float3 l9_595=l9_594.xyz;
float l9_596=1.8;
float l9_597=1.4;
float l9_598=0.5;
float l9_599=1.5;
float3 l9_600=(l9_595*((l9_595*l9_596)+float3(l9_597)))/((l9_595*((l9_595*l9_596)+float3(l9_598)))+float3(l9_599));
l9_594=float4(l9_600.x,l9_600.y,l9_600.z,l9_594.w);
}
float3 l9_601=l9_594.xyz;
float l9_602=l9_601.x;
float l9_603=l9_601.y;
float l9_604=l9_601.z;
float3 l9_605=float3(linearToSrgb(l9_602),linearToSrgb(l9_603),linearToSrgb(l9_604));
l9_594=float4(l9_605.x,l9_605.y,l9_605.z,l9_594.w);
float4 l9_606=l9_594;
param_21=l9_606;
}
param_21=fast::max(param_21,float4(0.0));
Output_N6=param_21;
FinalColor=Output_N6;
float4 param_23=FinalColor;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
float4 l9_607=param_23;
float4 l9_608=l9_607;
float l9_609=1.0;
if ((((sc_BlendMode_tmp==0)||(sc_BlendMode_tmp==5))||(sc_BlendMode_tmp==14))||(sc_BlendMode_tmp==16))
{
l9_609=l9_608.w;
}
else
{
if (sc_BlendMode_tmp==4)
{
l9_609=fast::clamp(l9_608.w*2.0,0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==8)
{
l9_609=1.0;
}
else
{
if (sc_BlendMode_tmp==1)
{
l9_609=(1.0-dot(l9_608.xyz,float3(0.33333001)))*l9_608.w;
}
else
{
if (sc_BlendMode_tmp==10)
{
l9_609=(1.0-fast::clamp(dot(l9_608.xyz,float3(1.0)),0.0,1.0))*l9_608.w;
}
else
{
if (sc_BlendMode_tmp==9)
{
l9_609=fast::clamp(dot(l9_608.xyz,float3(1.0)),0.0,1.0)*l9_608.w;
}
else
{
if (sc_BlendMode_tmp==2)
{
l9_609=fast::clamp(dot(l9_608.xyz,float3(1.0)),0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==7)
{
l9_609=fast::clamp(dot(l9_608.xyz,float3(1.0)),0.0,1.0)*l9_608.w;
}
else
{
if (sc_BlendMode_tmp==3)
{
l9_609=dot(l9_608.xyz,float3(0.33333001))*l9_608.w;
}
else
{
if (sc_BlendMode_tmp==11)
{
l9_609=1.0-fast::clamp(dot(l9_608.xyz,float3(1.0)),0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==12)
{
l9_609=fast::clamp(dot(l9_608.xyz,float3(1.0)),0.0,1.0);
}
}
}
}
}
}
}
}
}
}
}
float l9_610=l9_609;
float l9_611=l9_610;
float l9_612=(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity*l9_611;
float3 l9_613=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_607.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float4 l9_614=float4(l9_613.x,l9_613.y,l9_613.z,l9_612);
param_23=l9_614;
}
else
{
if ((int(sc_RenderAlphaToColor_tmp)!=0))
{
param_23=float4(param_23.w);
}
else
{
if ((int(sc_BlendMode_Custom_tmp)!=0))
{
float4 l9_615=param_23;
float4 l9_616=float4(0.0);
float4 l9_617=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_618=out.sc_FragData0;
l9_617=l9_618;
}
else
{
float4 l9_619=gl_FragCoord;
float2 l9_620=l9_619.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_621=l9_620;
float2 l9_622=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_623=1;
int l9_624=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_624=0;
}
else
{
l9_624=in.varStereoViewID;
}
int l9_625=l9_624;
int l9_626=l9_625;
float3 l9_627=float3(l9_621,0.0);
int l9_628=l9_623;
int l9_629=l9_626;
if (l9_628==1)
{
l9_627.y=((2.0*l9_627.y)+float(l9_629))-1.0;
}
float2 l9_630=l9_627.xy;
l9_622=l9_630;
}
else
{
l9_622=l9_621;
}
float2 l9_631=l9_622;
float2 l9_632=l9_631;
float2 l9_633=l9_632;
float2 l9_634=l9_633;
float l9_635=0.0;
int l9_636;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_637=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_637=0;
}
else
{
l9_637=in.varStereoViewID;
}
int l9_638=l9_637;
l9_636=1-l9_638;
}
else
{
int l9_639=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_639=0;
}
else
{
l9_639=in.varStereoViewID;
}
int l9_640=l9_639;
l9_636=l9_640;
}
int l9_641=l9_636;
float2 l9_642=l9_634;
int l9_643=sc_ScreenTextureLayout_tmp;
int l9_644=l9_641;
float l9_645=l9_635;
float2 l9_646=l9_642;
int l9_647=l9_643;
int l9_648=l9_644;
float3 l9_649=float3(0.0);
if (l9_647==0)
{
l9_649=float3(l9_646,0.0);
}
else
{
if (l9_647==1)
{
l9_649=float3(l9_646.x,(l9_646.y*0.5)+(0.5-(float(l9_648)*0.5)),0.0);
}
else
{
l9_649=float3(l9_646,float(l9_648));
}
}
float3 l9_650=l9_649;
float3 l9_651=l9_650;
float4 l9_652=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_651.xy,bias(l9_645));
float4 l9_653=l9_652;
float4 l9_654=l9_653;
l9_617=l9_654;
}
float4 l9_655=l9_617;
float3 l9_656=l9_655.xyz;
float3 l9_657=l9_656;
float3 l9_658=l9_615.xyz;
float3 l9_659=definedBlend(l9_657,l9_658,in.varStereoViewID,(*sc_set0.UserUniforms),sc_set0.intensityTexture,sc_set0.intensityTextureSmpSC);
l9_616=float4(l9_659.x,l9_659.y,l9_659.z,l9_616.w);
float3 l9_660=mix(l9_656,l9_616.xyz,float3(l9_615.w));
l9_616=float4(l9_660.x,l9_660.y,l9_660.z,l9_616.w);
l9_616.w=1.0;
float4 l9_661=l9_616;
param_23=l9_661;
}
else
{
if ((int(sc_Voxelization_tmp)!=0))
{
float4 l9_662=float4(in.varScreenPos.xyz,1.0);
param_23=l9_662;
}
else
{
if ((int(sc_OutputBounds_tmp)!=0))
{
float4 l9_663=gl_FragCoord;
float l9_664=fast::clamp(abs(l9_663.z),0.0,1.0);
float4 l9_665=float4(l9_664,1.0-l9_664,1.0,1.0);
param_23=l9_665;
}
else
{
float4 l9_666=param_23;
float4 l9_667=float4(0.0);
if (sc_BlendMode_tmp==10)
{
l9_667=float4(mix(float3(1.0),l9_666.xyz,float3(l9_666.w)),l9_666.w);
}
else
{
if ((sc_BlendMode_tmp==3)||(sc_BlendMode_tmp==16))
{
float l9_668=l9_666.w;
if (sc_BlendMode_tmp==16)
{
l9_668=fast::clamp(l9_668,0.0,1.0);
}
l9_667=float4(l9_666.xyz*l9_668,l9_668);
}
else
{
l9_667=l9_666;
}
}
float4 l9_669=l9_667;
param_23=l9_669;
}
}
}
}
}
float4 l9_670=param_23;
FinalColor=l9_670;
if ((*sc_set0.UserUniforms).PreviewEnabled==1)
{
if (PreviewInfo.Saved)
{
FinalColor=float4(PreviewInfo.Color);
}
else
{
FinalColor=float4(0.0);
}
}
float4 l9_671=float4(0.0);
float4 Cost=l9_671;
if (Cost.w>0.0)
{
FinalColor=Cost;
}
FinalColor=fast::max(FinalColor,float4(0.0));
float4 param_24=FinalColor;
FinalColor=sc_OutputMotionVectorIfNeeded(param_24,in.varPosAndMotion,in.varNormalAndMotion);
float4 param_25=FinalColor;
float4 l9_672=param_25;
if (sc_ShaderCacheConstant_tmp!=0)
{
l9_672.x+=((*sc_set1.sc_CameraUBO).sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
out.sc_FragData0=l9_672;
return out;
}
} // FRAGMENT SHADER
