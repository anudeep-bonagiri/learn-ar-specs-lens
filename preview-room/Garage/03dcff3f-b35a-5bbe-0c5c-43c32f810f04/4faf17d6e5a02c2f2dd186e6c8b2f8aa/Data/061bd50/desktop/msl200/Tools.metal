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
constant bool Tweak_N121 [[function_constant(7)]];
constant bool Tweak_N121_tmp = is_function_constant_defined(Tweak_N121) ? Tweak_N121 : false;
constant bool UseViewSpaceDepthVariant [[function_constant(8)]];
constant bool UseViewSpaceDepthVariant_tmp = is_function_constant_defined(UseViewSpaceDepthVariant) ? UseViewSpaceDepthVariant : true;
constant bool baseTexHasSwappedViews [[function_constant(9)]];
constant bool baseTexHasSwappedViews_tmp = is_function_constant_defined(baseTexHasSwappedViews) ? baseTexHasSwappedViews : false;
constant bool intensityTextureHasSwappedViews [[function_constant(10)]];
constant bool intensityTextureHasSwappedViews_tmp = is_function_constant_defined(intensityTextureHasSwappedViews) ? intensityTextureHasSwappedViews : false;
constant bool sc_BlendMode_Custom [[function_constant(11)]];
constant bool sc_BlendMode_Custom_tmp = is_function_constant_defined(sc_BlendMode_Custom) ? sc_BlendMode_Custom : false;
constant bool sc_DepthOnly [[function_constant(12)]];
constant bool sc_DepthOnly_tmp = is_function_constant_defined(sc_DepthOnly) ? sc_DepthOnly : false;
constant bool sc_EnvmapDiffuseHasSwappedViews [[function_constant(13)]];
constant bool sc_EnvmapDiffuseHasSwappedViews_tmp = is_function_constant_defined(sc_EnvmapDiffuseHasSwappedViews) ? sc_EnvmapDiffuseHasSwappedViews : false;
constant bool sc_EnvmapSpecularHasSwappedViews [[function_constant(14)]];
constant bool sc_EnvmapSpecularHasSwappedViews_tmp = is_function_constant_defined(sc_EnvmapSpecularHasSwappedViews) ? sc_EnvmapSpecularHasSwappedViews : false;
constant bool sc_FramebufferFetch [[function_constant(15)]];
constant bool sc_FramebufferFetch_tmp = is_function_constant_defined(sc_FramebufferFetch) ? sc_FramebufferFetch : false;
constant bool sc_HasDiffuseEnvmap [[function_constant(16)]];
constant bool sc_HasDiffuseEnvmap_tmp = is_function_constant_defined(sc_HasDiffuseEnvmap) ? sc_HasDiffuseEnvmap : false;
constant bool sc_HasSpecularCubemap [[function_constant(17)]];
constant bool sc_HasSpecularCubemap_tmp = is_function_constant_defined(sc_HasSpecularCubemap) ? sc_HasSpecularCubemap : false;
constant bool sc_LightEstimation [[function_constant(18)]];
constant bool sc_LightEstimation_tmp = is_function_constant_defined(sc_LightEstimation) ? sc_LightEstimation : false;
constant bool sc_MotionVectorsPass [[function_constant(19)]];
constant bool sc_MotionVectorsPass_tmp = is_function_constant_defined(sc_MotionVectorsPass) ? sc_MotionVectorsPass : false;
constant bool sc_OITCompositingPass [[function_constant(20)]];
constant bool sc_OITCompositingPass_tmp = is_function_constant_defined(sc_OITCompositingPass) ? sc_OITCompositingPass : false;
constant bool sc_OITDepthBoundsPass [[function_constant(21)]];
constant bool sc_OITDepthBoundsPass_tmp = is_function_constant_defined(sc_OITDepthBoundsPass) ? sc_OITDepthBoundsPass : false;
constant bool sc_OITDepthGatherPass [[function_constant(22)]];
constant bool sc_OITDepthGatherPass_tmp = is_function_constant_defined(sc_OITDepthGatherPass) ? sc_OITDepthGatherPass : false;
constant bool sc_OutputBounds [[function_constant(23)]];
constant bool sc_OutputBounds_tmp = is_function_constant_defined(sc_OutputBounds) ? sc_OutputBounds : false;
constant bool sc_ProjectiveShadowsCaster [[function_constant(24)]];
constant bool sc_ProjectiveShadowsCaster_tmp = is_function_constant_defined(sc_ProjectiveShadowsCaster) ? sc_ProjectiveShadowsCaster : false;
constant bool sc_ProjectiveShadowsReceiver [[function_constant(25)]];
constant bool sc_ProjectiveShadowsReceiver_tmp = is_function_constant_defined(sc_ProjectiveShadowsReceiver) ? sc_ProjectiveShadowsReceiver : false;
constant bool sc_RenderAlphaToColor [[function_constant(26)]];
constant bool sc_RenderAlphaToColor_tmp = is_function_constant_defined(sc_RenderAlphaToColor) ? sc_RenderAlphaToColor : false;
constant bool sc_SSAOEnabled [[function_constant(27)]];
constant bool sc_SSAOEnabled_tmp = is_function_constant_defined(sc_SSAOEnabled) ? sc_SSAOEnabled : false;
constant bool sc_ScreenTextureHasSwappedViews [[function_constant(28)]];
constant bool sc_ScreenTextureHasSwappedViews_tmp = is_function_constant_defined(sc_ScreenTextureHasSwappedViews) ? sc_ScreenTextureHasSwappedViews : false;
constant bool sc_ShadowMapHardwarePCF [[function_constant(29)]];
constant bool sc_ShadowMapHardwarePCF_tmp = is_function_constant_defined(sc_ShadowMapHardwarePCF) ? sc_ShadowMapHardwarePCF : false;
constant bool sc_ShadowMapIsRandomSampling [[function_constant(30)]];
constant bool sc_ShadowMapIsRandomSampling_tmp = is_function_constant_defined(sc_ShadowMapIsRandomSampling) ? sc_ShadowMapIsRandomSampling : false;
constant bool sc_ShadowMapIsSoftShadow [[function_constant(31)]];
constant bool sc_ShadowMapIsSoftShadow_tmp = is_function_constant_defined(sc_ShadowMapIsSoftShadow) ? sc_ShadowMapIsSoftShadow : false;
constant bool sc_ShadowMapReceiver [[function_constant(32)]];
constant bool sc_ShadowMapReceiver_tmp = is_function_constant_defined(sc_ShadowMapReceiver) ? sc_ShadowMapReceiver : false;
constant bool sc_TAAEnabled [[function_constant(33)]];
constant bool sc_TAAEnabled_tmp = is_function_constant_defined(sc_TAAEnabled) ? sc_TAAEnabled : false;
constant bool sc_VertexBlendingUseNormals [[function_constant(34)]];
constant bool sc_VertexBlendingUseNormals_tmp = is_function_constant_defined(sc_VertexBlendingUseNormals) ? sc_VertexBlendingUseNormals : false;
constant bool sc_VertexBlending [[function_constant(35)]];
constant bool sc_VertexBlending_tmp = is_function_constant_defined(sc_VertexBlending) ? sc_VertexBlending : false;
constant bool sc_Voxelization [[function_constant(36)]];
constant bool sc_Voxelization_tmp = is_function_constant_defined(sc_Voxelization) ? sc_Voxelization : false;
constant int SC_DEVICE_CLASS [[function_constant(37)]];
constant int SC_DEVICE_CLASS_tmp = is_function_constant_defined(SC_DEVICE_CLASS) ? SC_DEVICE_CLASS : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_baseTex [[function_constant(38)]];
constant int SC_SOFTWARE_WRAP_MODE_U_baseTex_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_baseTex) ? SC_SOFTWARE_WRAP_MODE_U_baseTex : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_intensityTexture [[function_constant(39)]];
constant int SC_SOFTWARE_WRAP_MODE_U_intensityTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_intensityTexture) ? SC_SOFTWARE_WRAP_MODE_U_intensityTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_baseTex [[function_constant(40)]];
constant int SC_SOFTWARE_WRAP_MODE_V_baseTex_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_baseTex) ? SC_SOFTWARE_WRAP_MODE_V_baseTex : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_intensityTexture [[function_constant(41)]];
constant int SC_SOFTWARE_WRAP_MODE_V_intensityTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_intensityTexture) ? SC_SOFTWARE_WRAP_MODE_V_intensityTexture : -1;
constant int baseTexLayout [[function_constant(42)]];
constant int baseTexLayout_tmp = is_function_constant_defined(baseTexLayout) ? baseTexLayout : 0;
constant int intensityTextureLayout [[function_constant(43)]];
constant int intensityTextureLayout_tmp = is_function_constant_defined(intensityTextureLayout) ? intensityTextureLayout : 0;
constant int sc_AmbientLightMode0 [[function_constant(44)]];
constant int sc_AmbientLightMode0_tmp = is_function_constant_defined(sc_AmbientLightMode0) ? sc_AmbientLightMode0 : 0;
constant int sc_AmbientLightMode1 [[function_constant(45)]];
constant int sc_AmbientLightMode1_tmp = is_function_constant_defined(sc_AmbientLightMode1) ? sc_AmbientLightMode1 : 0;
constant int sc_AmbientLightMode2 [[function_constant(46)]];
constant int sc_AmbientLightMode2_tmp = is_function_constant_defined(sc_AmbientLightMode2) ? sc_AmbientLightMode2 : 0;
constant int sc_AmbientLightMode_Constant [[function_constant(47)]];
constant int sc_AmbientLightMode_Constant_tmp = is_function_constant_defined(sc_AmbientLightMode_Constant) ? sc_AmbientLightMode_Constant : 0;
constant int sc_AmbientLightMode_EnvironmentMap [[function_constant(48)]];
constant int sc_AmbientLightMode_EnvironmentMap_tmp = is_function_constant_defined(sc_AmbientLightMode_EnvironmentMap) ? sc_AmbientLightMode_EnvironmentMap : 0;
constant int sc_AmbientLightMode_FromCamera [[function_constant(49)]];
constant int sc_AmbientLightMode_FromCamera_tmp = is_function_constant_defined(sc_AmbientLightMode_FromCamera) ? sc_AmbientLightMode_FromCamera : 0;
constant int sc_AmbientLightMode_SphericalHarmonics [[function_constant(50)]];
constant int sc_AmbientLightMode_SphericalHarmonics_tmp = is_function_constant_defined(sc_AmbientLightMode_SphericalHarmonics) ? sc_AmbientLightMode_SphericalHarmonics : 0;
constant int sc_AmbientLightsCount [[function_constant(51)]];
constant int sc_AmbientLightsCount_tmp = is_function_constant_defined(sc_AmbientLightsCount) ? sc_AmbientLightsCount : 0;
constant int sc_BlendMode [[function_constant(52)]];
constant int sc_BlendMode_tmp = is_function_constant_defined(sc_BlendMode) ? sc_BlendMode : 0;
constant int sc_DepthBufferMode [[function_constant(53)]];
constant int sc_DepthBufferMode_tmp = is_function_constant_defined(sc_DepthBufferMode) ? sc_DepthBufferMode : 0;
constant int sc_DirectionalLightsCount [[function_constant(54)]];
constant int sc_DirectionalLightsCount_tmp = is_function_constant_defined(sc_DirectionalLightsCount) ? sc_DirectionalLightsCount : 0;
constant int sc_EnvLightMode [[function_constant(55)]];
constant int sc_EnvLightMode_tmp = is_function_constant_defined(sc_EnvLightMode) ? sc_EnvLightMode : 0;
constant int sc_EnvmapDiffuseLayout [[function_constant(56)]];
constant int sc_EnvmapDiffuseLayout_tmp = is_function_constant_defined(sc_EnvmapDiffuseLayout) ? sc_EnvmapDiffuseLayout : 0;
constant int sc_EnvmapSpecularLayout [[function_constant(57)]];
constant int sc_EnvmapSpecularLayout_tmp = is_function_constant_defined(sc_EnvmapSpecularLayout) ? sc_EnvmapSpecularLayout : 0;
constant int sc_LightEstimationSGCount [[function_constant(58)]];
constant int sc_LightEstimationSGCount_tmp = is_function_constant_defined(sc_LightEstimationSGCount) ? sc_LightEstimationSGCount : 0;
constant int sc_PointLightsCount [[function_constant(59)]];
constant int sc_PointLightsCount_tmp = is_function_constant_defined(sc_PointLightsCount) ? sc_PointLightsCount : 0;
constant int sc_RenderingSpace [[function_constant(60)]];
constant int sc_RenderingSpace_tmp = is_function_constant_defined(sc_RenderingSpace) ? sc_RenderingSpace : -1;
constant int sc_ScreenTextureLayout [[function_constant(61)]];
constant int sc_ScreenTextureLayout_tmp = is_function_constant_defined(sc_ScreenTextureLayout) ? sc_ScreenTextureLayout : 0;
constant int sc_ShaderCacheConstant [[function_constant(62)]];
constant int sc_ShaderCacheConstant_tmp = is_function_constant_defined(sc_ShaderCacheConstant) ? sc_ShaderCacheConstant : 0;
constant int sc_ShadowMapSampleCount [[function_constant(63)]];
constant int sc_ShadowMapSampleCount_tmp = is_function_constant_defined(sc_ShadowMapSampleCount) ? sc_ShadowMapSampleCount : 16;
constant int sc_SkinBonesCount [[function_constant(64)]];
constant int sc_SkinBonesCount_tmp = is_function_constant_defined(sc_SkinBonesCount) ? sc_SkinBonesCount : 0;
constant int sc_SoftwareBlendMode [[function_constant(65)]];
constant int sc_SoftwareBlendMode_tmp = is_function_constant_defined(sc_SoftwareBlendMode) ? sc_SoftwareBlendMode : 0;
constant int sc_StereoRenderingMode [[function_constant(66)]];
constant int sc_StereoRenderingMode_tmp = is_function_constant_defined(sc_StereoRenderingMode) ? sc_StereoRenderingMode : 0;
constant int sc_StereoRendering_IsClipDistanceEnabled [[function_constant(67)]];
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
float4 Port_Default_N369;
float Port_Value2_N073;
float Port_Default_N204;
float Port_Input2_N072;
float3 Port_Emissive_N036;
float3 Port_AO_N036;
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
texture2d<float> intensityTexture [[id(3)]];
texture2d<float> sc_EnvmapDiffuse [[id(6)]];
texture2d<float> sc_EnvmapSpecular [[id(7)]];
texture2d<float> sc_SSAOTexture [[id(16)]];
texture2d<float> sc_ScreenTexture [[id(17)]];
depth2d<float> sc_ShadowMapTexture [[id(19)]];
texture2d<float> sc_ShadowTexture [[id(20)]];
texturecube<float> sc_SpecularCubemap [[id(21)]];
sampler baseTexSmpSC [[id(23)]];
sampler intensityTextureSmpSC [[id(25)]];
sampler sc_EnvmapDiffuseSmpSC [[id(28)]];
sampler sc_EnvmapSpecularSmpSC [[id(29)]];
sampler sc_SSAOTextureSmpSC [[id(31)]];
sampler sc_ScreenTextureSmpSC [[id(32)]];
sampler sc_ShadowMapTextureSmpSC [[id(34)]];
sampler sc_ShadowTextureSmpSC [[id(35)]];
sampler sc_SpecularCubemapSmpSC [[id(36)]];
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
float4 VertexColor;
float2 Surface_UVCoord0;
float2 Surface_UVCoord1;
float2 gScreenCoord;
float3 VertexTangent_WorldSpace;
float3 VertexNormal_WorldSpace;
float3 VertexBinormal_WorldSpace;
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
float4 Port_Default_N369;
float Port_Value2_N073;
float Port_Default_N204;
float Port_Input2_N072;
float3 Port_Emissive_N036;
float3 Port_AO_N036;
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
texture2d<float> intensityTexture [[id(3)]];
texture2d<float> sc_EnvmapDiffuse [[id(6)]];
texture2d<float> sc_EnvmapSpecular [[id(7)]];
texture2d<float> sc_SSAOTexture [[id(16)]];
texture2d<float> sc_ScreenTexture [[id(17)]];
depth2d<float> sc_ShadowMapTexture [[id(19)]];
texture2d<float> sc_ShadowTexture [[id(20)]];
texturecube<float> sc_SpecularCubemap [[id(21)]];
sampler baseTexSmpSC [[id(23)]];
sampler intensityTextureSmpSC [[id(25)]];
sampler sc_EnvmapDiffuseSmpSC [[id(28)]];
sampler sc_EnvmapSpecularSmpSC [[id(29)]];
sampler sc_SSAOTextureSmpSC [[id(31)]];
sampler sc_ScreenTextureSmpSC [[id(32)]];
sampler sc_ShadowMapTextureSmpSC [[id(34)]];
sampler sc_ShadowTextureSmpSC [[id(35)]];
sampler sc_SpecularCubemapSmpSC [[id(36)]];
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
Globals.VertexColor=in.varColor;
Globals.Surface_UVCoord0=in.varTex01.xy;
Globals.Surface_UVCoord1=in.varTex01.zw;
float4 l9_0=gl_FragCoord;
float2 l9_1=l9_0.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_2=l9_1;
float2 l9_3=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_4=1;
int l9_5=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_5=0;
}
else
{
l9_5=in.varStereoViewID;
}
int l9_6=l9_5;
int l9_7=l9_6;
float3 l9_8=float3(l9_2,0.0);
int l9_9=l9_4;
int l9_10=l9_7;
if (l9_9==1)
{
l9_8.y=((2.0*l9_8.y)+float(l9_10))-1.0;
}
float2 l9_11=l9_8.xy;
l9_3=l9_11;
}
else
{
l9_3=l9_2;
}
float2 l9_12=l9_3;
float2 l9_13=l9_12;
Globals.gScreenCoord=l9_13;
Globals.VertexTangent_WorldSpace=normalize(in.varTangent.xyz);
Globals.VertexNormal_WorldSpace=normalize(in.varNormalAndMotion.xyz);
Globals.VertexBinormal_WorldSpace=cross(Globals.VertexNormal_WorldSpace,Globals.VertexTangent_WorldSpace)*in.varTangent.w;
float4 Result_N363=float4(0.0);
float4 param=float4(0.0);
ssGlobals param_2=Globals;
float3 l9_14=float3(0.0);
float3 l9_15=float3(0.0);
ssGlobals l9_16=param_2;
float4 l9_17=float4(0.0);
float4 l9_18=(*sc_set0.UserUniforms).baseColor;
l9_17=l9_18;
float4 l9_19=float4(0.0);
l9_19=l9_17;
float4 l9_20=float4(0.0);
float4 l9_21=float4(0.0);
float4 l9_22=(*sc_set0.UserUniforms).Port_Default_N369;
ssGlobals l9_23=l9_16;
float4 l9_24;
if ((int(Tweak_N121_tmp)!=0))
{
float2 l9_25=float2(0.0);
float2 l9_26=float2(0.0);
ssGlobals l9_27=l9_23;
float2 l9_28=float2(0.0);
l9_28=l9_27.Surface_UVCoord0;
l9_26=l9_28;
float2 l9_29=l9_26;
l9_25=l9_29;
float4 l9_30=float4(0.0);
int l9_31;
if ((int(baseTexHasSwappedViews_tmp)!=0))
{
int l9_32=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_32=0;
}
else
{
l9_32=in.varStereoViewID;
}
int l9_33=l9_32;
l9_31=1-l9_33;
}
else
{
int l9_34=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_34=0;
}
else
{
l9_34=in.varStereoViewID;
}
int l9_35=l9_34;
l9_31=l9_35;
}
int l9_36=l9_31;
int l9_37=baseTexLayout_tmp;
int l9_38=l9_36;
float2 l9_39=l9_25;
bool l9_40=(int(SC_USE_UV_TRANSFORM_baseTex_tmp)!=0);
float3x3 l9_41=(*sc_set0.UserUniforms).baseTexTransform;
int2 l9_42=int2(SC_SOFTWARE_WRAP_MODE_U_baseTex_tmp,SC_SOFTWARE_WRAP_MODE_V_baseTex_tmp);
bool l9_43=(int(SC_USE_UV_MIN_MAX_baseTex_tmp)!=0);
float4 l9_44=(*sc_set0.UserUniforms).baseTexUvMinMax;
bool l9_45=(int(SC_USE_CLAMP_TO_BORDER_baseTex_tmp)!=0);
float4 l9_46=(*sc_set0.UserUniforms).baseTexBorderColor;
float l9_47=0.0;
bool l9_48=l9_45&&(!l9_43);
float l9_49=1.0;
float l9_50=l9_39.x;
int l9_51=l9_42.x;
if (l9_51==1)
{
l9_50=fract(l9_50);
}
else
{
if (l9_51==2)
{
float l9_52=fract(l9_50);
float l9_53=l9_50-l9_52;
float l9_54=step(0.25,fract(l9_53*0.5));
l9_50=mix(l9_52,1.0-l9_52,fast::clamp(l9_54,0.0,1.0));
}
}
l9_39.x=l9_50;
float l9_55=l9_39.y;
int l9_56=l9_42.y;
if (l9_56==1)
{
l9_55=fract(l9_55);
}
else
{
if (l9_56==2)
{
float l9_57=fract(l9_55);
float l9_58=l9_55-l9_57;
float l9_59=step(0.25,fract(l9_58*0.5));
l9_55=mix(l9_57,1.0-l9_57,fast::clamp(l9_59,0.0,1.0));
}
}
l9_39.y=l9_55;
if (l9_43)
{
bool l9_60=l9_45;
bool l9_61;
if (l9_60)
{
l9_61=l9_42.x==3;
}
else
{
l9_61=l9_60;
}
float l9_62=l9_39.x;
float l9_63=l9_44.x;
float l9_64=l9_44.z;
bool l9_65=l9_61;
float l9_66=l9_49;
float l9_67=fast::clamp(l9_62,l9_63,l9_64);
float l9_68=step(abs(l9_62-l9_67),9.9999997e-06);
l9_66*=(l9_68+((1.0-float(l9_65))*(1.0-l9_68)));
l9_62=l9_67;
l9_39.x=l9_62;
l9_49=l9_66;
bool l9_69=l9_45;
bool l9_70;
if (l9_69)
{
l9_70=l9_42.y==3;
}
else
{
l9_70=l9_69;
}
float l9_71=l9_39.y;
float l9_72=l9_44.y;
float l9_73=l9_44.w;
bool l9_74=l9_70;
float l9_75=l9_49;
float l9_76=fast::clamp(l9_71,l9_72,l9_73);
float l9_77=step(abs(l9_71-l9_76),9.9999997e-06);
l9_75*=(l9_77+((1.0-float(l9_74))*(1.0-l9_77)));
l9_71=l9_76;
l9_39.y=l9_71;
l9_49=l9_75;
}
float2 l9_78=l9_39;
bool l9_79=l9_40;
float3x3 l9_80=l9_41;
if (l9_79)
{
l9_78=float2((l9_80*float3(l9_78,1.0)).xy);
}
float2 l9_81=l9_78;
l9_39=l9_81;
float l9_82=l9_39.x;
int l9_83=l9_42.x;
bool l9_84=l9_48;
float l9_85=l9_49;
if ((l9_83==0)||(l9_83==3))
{
float l9_86=l9_82;
float l9_87=0.0;
float l9_88=1.0;
bool l9_89=l9_84;
float l9_90=l9_85;
float l9_91=fast::clamp(l9_86,l9_87,l9_88);
float l9_92=step(abs(l9_86-l9_91),9.9999997e-06);
l9_90*=(l9_92+((1.0-float(l9_89))*(1.0-l9_92)));
l9_86=l9_91;
l9_82=l9_86;
l9_85=l9_90;
}
l9_39.x=l9_82;
l9_49=l9_85;
float l9_93=l9_39.y;
int l9_94=l9_42.y;
bool l9_95=l9_48;
float l9_96=l9_49;
if ((l9_94==0)||(l9_94==3))
{
float l9_97=l9_93;
float l9_98=0.0;
float l9_99=1.0;
bool l9_100=l9_95;
float l9_101=l9_96;
float l9_102=fast::clamp(l9_97,l9_98,l9_99);
float l9_103=step(abs(l9_97-l9_102),9.9999997e-06);
l9_101*=(l9_103+((1.0-float(l9_100))*(1.0-l9_103)));
l9_97=l9_102;
l9_93=l9_97;
l9_96=l9_101;
}
l9_39.y=l9_93;
l9_49=l9_96;
float2 l9_104=l9_39;
int l9_105=l9_37;
int l9_106=l9_38;
float l9_107=l9_47;
float2 l9_108=l9_104;
int l9_109=l9_105;
int l9_110=l9_106;
float3 l9_111=float3(0.0);
if (l9_109==0)
{
l9_111=float3(l9_108,0.0);
}
else
{
if (l9_109==1)
{
l9_111=float3(l9_108.x,(l9_108.y*0.5)+(0.5-(float(l9_110)*0.5)),0.0);
}
else
{
l9_111=float3(l9_108,float(l9_110));
}
}
float3 l9_112=l9_111;
float3 l9_113=l9_112;
float4 l9_114=sc_set0.baseTex.sample(sc_set0.baseTexSmpSC,l9_113.xy,bias(l9_107));
float4 l9_115=l9_114;
if (l9_45)
{
l9_115=mix(l9_46,l9_115,float4(l9_49));
}
float4 l9_116=l9_115;
l9_30=l9_116;
l9_21=l9_30;
l9_24=l9_21;
}
else
{
l9_24=l9_22;
}
l9_20=l9_24;
float4 l9_117=float4(0.0);
l9_117=l9_19*l9_20;
float4 l9_118=float4(0.0);
l9_118=l9_117;
float4 l9_119=float4(0.0);
l9_119=l9_118;
l9_15=l9_119.xyz;
float3 l9_120=l9_15;
l9_14=l9_120;
float3 l9_121=float3(0.0);
l9_121=l9_14;
float3 l9_122=float3(0.0);
l9_122=l9_121;
float4 l9_123=float4(0.0);
l9_123=float4(l9_122.x,l9_122.y,l9_122.z,l9_123.w);
l9_123.w=(*sc_set0.UserUniforms).Port_Value2_N073;
param=l9_123;
float4 param_1=param;
Result_N363=param_1;
float4 Export_N364=float4(0.0);
Export_N364=Result_N363;
float4 Output_N5=float4(0.0);
float4 param_3=(*sc_set0.UserUniforms).baseColor;
Output_N5=param_3;
float4 Value_N384=float4(0.0);
Value_N384=Output_N5;
float4 Result_N369=float4(0.0);
float4 param_4=float4(0.0);
float4 param_5=(*sc_set0.UserUniforms).Port_Default_N369;
ssGlobals param_7=Globals;
float4 param_6;
if ((int(Tweak_N121_tmp)!=0))
{
float2 l9_124=float2(0.0);
float2 l9_125=float2(0.0);
ssGlobals l9_126=param_7;
float2 l9_127=float2(0.0);
l9_127=l9_126.Surface_UVCoord0;
l9_125=l9_127;
float2 l9_128=l9_125;
l9_124=l9_128;
float4 l9_129=float4(0.0);
int l9_130;
if ((int(baseTexHasSwappedViews_tmp)!=0))
{
int l9_131=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_131=0;
}
else
{
l9_131=in.varStereoViewID;
}
int l9_132=l9_131;
l9_130=1-l9_132;
}
else
{
int l9_133=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_133=0;
}
else
{
l9_133=in.varStereoViewID;
}
int l9_134=l9_133;
l9_130=l9_134;
}
int l9_135=l9_130;
int l9_136=baseTexLayout_tmp;
int l9_137=l9_135;
float2 l9_138=l9_124;
bool l9_139=(int(SC_USE_UV_TRANSFORM_baseTex_tmp)!=0);
float3x3 l9_140=(*sc_set0.UserUniforms).baseTexTransform;
int2 l9_141=int2(SC_SOFTWARE_WRAP_MODE_U_baseTex_tmp,SC_SOFTWARE_WRAP_MODE_V_baseTex_tmp);
bool l9_142=(int(SC_USE_UV_MIN_MAX_baseTex_tmp)!=0);
float4 l9_143=(*sc_set0.UserUniforms).baseTexUvMinMax;
bool l9_144=(int(SC_USE_CLAMP_TO_BORDER_baseTex_tmp)!=0);
float4 l9_145=(*sc_set0.UserUniforms).baseTexBorderColor;
float l9_146=0.0;
bool l9_147=l9_144&&(!l9_142);
float l9_148=1.0;
float l9_149=l9_138.x;
int l9_150=l9_141.x;
if (l9_150==1)
{
l9_149=fract(l9_149);
}
else
{
if (l9_150==2)
{
float l9_151=fract(l9_149);
float l9_152=l9_149-l9_151;
float l9_153=step(0.25,fract(l9_152*0.5));
l9_149=mix(l9_151,1.0-l9_151,fast::clamp(l9_153,0.0,1.0));
}
}
l9_138.x=l9_149;
float l9_154=l9_138.y;
int l9_155=l9_141.y;
if (l9_155==1)
{
l9_154=fract(l9_154);
}
else
{
if (l9_155==2)
{
float l9_156=fract(l9_154);
float l9_157=l9_154-l9_156;
float l9_158=step(0.25,fract(l9_157*0.5));
l9_154=mix(l9_156,1.0-l9_156,fast::clamp(l9_158,0.0,1.0));
}
}
l9_138.y=l9_154;
if (l9_142)
{
bool l9_159=l9_144;
bool l9_160;
if (l9_159)
{
l9_160=l9_141.x==3;
}
else
{
l9_160=l9_159;
}
float l9_161=l9_138.x;
float l9_162=l9_143.x;
float l9_163=l9_143.z;
bool l9_164=l9_160;
float l9_165=l9_148;
float l9_166=fast::clamp(l9_161,l9_162,l9_163);
float l9_167=step(abs(l9_161-l9_166),9.9999997e-06);
l9_165*=(l9_167+((1.0-float(l9_164))*(1.0-l9_167)));
l9_161=l9_166;
l9_138.x=l9_161;
l9_148=l9_165;
bool l9_168=l9_144;
bool l9_169;
if (l9_168)
{
l9_169=l9_141.y==3;
}
else
{
l9_169=l9_168;
}
float l9_170=l9_138.y;
float l9_171=l9_143.y;
float l9_172=l9_143.w;
bool l9_173=l9_169;
float l9_174=l9_148;
float l9_175=fast::clamp(l9_170,l9_171,l9_172);
float l9_176=step(abs(l9_170-l9_175),9.9999997e-06);
l9_174*=(l9_176+((1.0-float(l9_173))*(1.0-l9_176)));
l9_170=l9_175;
l9_138.y=l9_170;
l9_148=l9_174;
}
float2 l9_177=l9_138;
bool l9_178=l9_139;
float3x3 l9_179=l9_140;
if (l9_178)
{
l9_177=float2((l9_179*float3(l9_177,1.0)).xy);
}
float2 l9_180=l9_177;
l9_138=l9_180;
float l9_181=l9_138.x;
int l9_182=l9_141.x;
bool l9_183=l9_147;
float l9_184=l9_148;
if ((l9_182==0)||(l9_182==3))
{
float l9_185=l9_181;
float l9_186=0.0;
float l9_187=1.0;
bool l9_188=l9_183;
float l9_189=l9_184;
float l9_190=fast::clamp(l9_185,l9_186,l9_187);
float l9_191=step(abs(l9_185-l9_190),9.9999997e-06);
l9_189*=(l9_191+((1.0-float(l9_188))*(1.0-l9_191)));
l9_185=l9_190;
l9_181=l9_185;
l9_184=l9_189;
}
l9_138.x=l9_181;
l9_148=l9_184;
float l9_192=l9_138.y;
int l9_193=l9_141.y;
bool l9_194=l9_147;
float l9_195=l9_148;
if ((l9_193==0)||(l9_193==3))
{
float l9_196=l9_192;
float l9_197=0.0;
float l9_198=1.0;
bool l9_199=l9_194;
float l9_200=l9_195;
float l9_201=fast::clamp(l9_196,l9_197,l9_198);
float l9_202=step(abs(l9_196-l9_201),9.9999997e-06);
l9_200*=(l9_202+((1.0-float(l9_199))*(1.0-l9_202)));
l9_196=l9_201;
l9_192=l9_196;
l9_195=l9_200;
}
l9_138.y=l9_192;
l9_148=l9_195;
float2 l9_203=l9_138;
int l9_204=l9_136;
int l9_205=l9_137;
float l9_206=l9_146;
float2 l9_207=l9_203;
int l9_208=l9_204;
int l9_209=l9_205;
float3 l9_210=float3(0.0);
if (l9_208==0)
{
l9_210=float3(l9_207,0.0);
}
else
{
if (l9_208==1)
{
l9_210=float3(l9_207.x,(l9_207.y*0.5)+(0.5-(float(l9_209)*0.5)),0.0);
}
else
{
l9_210=float3(l9_207,float(l9_209));
}
}
float3 l9_211=l9_210;
float3 l9_212=l9_211;
float4 l9_213=sc_set0.baseTex.sample(sc_set0.baseTexSmpSC,l9_212.xy,bias(l9_206));
float4 l9_214=l9_213;
if (l9_144)
{
l9_214=mix(l9_145,l9_214,float4(l9_148));
}
float4 l9_215=l9_214;
l9_129=l9_215;
param_4=l9_129;
param_6=param_4;
}
else
{
param_6=param_5;
}
Result_N369=param_6;
float4 Output_N148=float4(0.0);
Output_N148=Value_N384*Result_N369;
float4 Export_N385=float4(0.0);
Export_N385=Output_N148;
float4 Value_N166=float4(0.0);
Value_N166=Export_N385;
float Output_N168=0.0;
Output_N168=Value_N166.w;
float Result_N204=0.0;
float param_8=(*sc_set0.UserUniforms).Port_Default_N204;
float param_9=param_8;
Result_N204=param_9;
float Output_N72=0.0;
float param_10=(*sc_set0.UserUniforms).Port_Input2_N072;
float param_11=param_10;
Output_N72=param_11;
float Output_N205=0.0;
Output_N205=(Output_N168*Result_N204)*Output_N72;
float Export_N158=0.0;
Export_N158=Output_N205;
float3 Result_N337=float3(0.0);
float3 param_12=float3(0.0);
ssGlobals param_14=Globals;
float3 l9_216=float3(0.0);
l9_216=param_14.VertexNormal_WorldSpace;
float3 l9_217=float3(0.0);
float3 l9_218=l9_216;
float l9_219=dot(l9_218,l9_218);
float l9_220;
if (l9_219>0.0)
{
l9_220=1.0/sqrt(l9_219);
}
else
{
l9_220=0.0;
}
float l9_221=l9_220;
float3 l9_222=l9_218*l9_221;
l9_217=l9_222;
param_12=l9_217;
float3 param_13=param_12;
Result_N337=param_13;
float3 Export_N334=float3(0.0);
Export_N334=Result_N337;
float4 Output_N36=float4(0.0);
float3 param_15=Export_N364.xyz;
float param_16=Export_N158;
float3 param_17=Export_N334;
float3 param_18=(*sc_set0.UserUniforms).Port_Emissive_N036;
float3 param_19=(*sc_set0.UserUniforms).Port_AO_N036;
ssGlobals param_21=Globals;
if (!(int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
param_21.BumpedNormal=param_17;
}
param_16=fast::clamp(param_16,0.0,1.0);
float l9_223=param_16;
if (sc_BlendMode_tmp==8)
{
if (l9_223<(*sc_set0.UserUniforms).alphaTestThreshold)
{
discard_fragment();
}
}
if ((int(ENABLE_STIPPLE_PATTERN_TEST_tmp)!=0))
{
float4 l9_224=gl_FragCoord;
float2 l9_225=floor(mod(l9_224.xy,float2(4.0)));
float l9_226=(mod(dot(l9_225,float2(4.0,1.0))*9.0,16.0)+1.0)/17.0;
if (l9_223<l9_226)
{
discard_fragment();
}
}
param_15=fast::max(param_15,float3(0.0));
float4 param_20;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
param_20=float4(param_15,param_16);
}
else
{
float l9_227=0.0;
float l9_228=1.0;
float3 l9_229=float3(1.0);
float3 l9_230=param_15;
float l9_231=param_16;
float3 l9_232=param_21.BumpedNormal;
float3 l9_233=param_21.PositionWS;
float3 l9_234=param_21.ViewDirWS;
float3 l9_235=param_18;
float l9_236=l9_227;
float l9_237=l9_228;
float3 l9_238=param_19;
float3 l9_239=l9_229;
SurfaceProperties l9_240;
l9_240.albedo=float3(0.0);
l9_240.opacity=1.0;
l9_240.normal=float3(0.0);
l9_240.positionWS=float3(0.0);
l9_240.viewDirWS=float3(0.0);
l9_240.metallic=0.0;
l9_240.roughness=0.0;
l9_240.emissive=float3(0.0);
l9_240.ao=float3(1.0);
l9_240.specularAo=float3(1.0);
l9_240.bakedShadows=float3(1.0);
SurfaceProperties l9_241=l9_240;
SurfaceProperties l9_242=l9_241;
l9_242.opacity=l9_231;
float3 l9_243=l9_230;
float3 l9_244;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_244=float3(pow(l9_243.x,2.2),pow(l9_243.y,2.2),pow(l9_243.z,2.2));
}
else
{
l9_244=l9_243*l9_243;
}
float3 l9_245=l9_244;
l9_242.albedo=l9_245;
l9_242.normal=normalize(l9_232);
l9_242.positionWS=l9_233;
l9_242.viewDirWS=l9_234;
float3 l9_246=l9_235;
float3 l9_247;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_247=float3(pow(l9_246.x,2.2),pow(l9_246.y,2.2),pow(l9_246.z,2.2));
}
else
{
l9_247=l9_246*l9_246;
}
float3 l9_248=l9_247;
l9_242.emissive=l9_248;
l9_242.metallic=l9_236;
l9_242.roughness=l9_237;
l9_242.ao=l9_238;
l9_242.specularAo=l9_239;
if ((int(sc_SSAOEnabled_tmp)!=0))
{
float3 l9_249=l9_242.positionWS;
l9_242.ao=evaluateSSAO(l9_249,in.varStereoViewID,(*sc_set1.sc_CameraUBO),sc_set0.sc_SSAOTexture,sc_set0.sc_SSAOTextureSmpSC);
}
SurfaceProperties l9_250=l9_242;
SurfaceProperties l9_251=l9_250;
float3 l9_252=mix(float3(0.039999999),l9_251.albedo*l9_251.metallic,float3(l9_251.metallic));
float3 l9_253=mix(l9_251.albedo*(1.0-l9_251.metallic),float3(0.0),float3(l9_251.metallic));
l9_250.albedo=l9_253;
l9_250.specColor=l9_252;
SurfaceProperties l9_254=l9_250;
l9_242=l9_254;
SurfaceProperties l9_255=l9_242;
LightingComponents l9_256;
l9_256.directDiffuse=float3(0.0);
l9_256.directSpecular=float3(0.0);
l9_256.indirectDiffuse=float3(1.0);
l9_256.indirectSpecular=float3(0.0);
l9_256.emitted=float3(0.0);
l9_256.transmitted=float3(0.0);
LightingComponents l9_257=l9_256;
LightingComponents l9_258=l9_257;
float3 l9_259=l9_255.viewDirWS;
int l9_260=0;
float4 l9_261=float4(l9_255.bakedShadows,1.0);
if (sc_DirectionalLightsCount_tmp>0)
{
sc_DirectionalLight_t l9_262;
LightProperties l9_263;
int l9_264=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_264<sc_DirectionalLightsCount_tmp)
{
l9_262.direction=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_264].direction;
l9_262.color=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_264].color;
l9_262.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_264].shadowMapParamsIndex;
l9_263.direction=l9_262.direction;
l9_263.color=l9_262.color.xyz;
l9_263.attenuation=l9_262.color.w;
l9_263.attenuation*=l9_261[(l9_260<3) ? l9_260 : 3];
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_262.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_265=l9_264;
float l9_266=evaluateDirectionalShadowMap(l9_265,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_267=l9_262.shadowMapParamsIndex;
float3 l9_268=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_267].params[0].xyz;
float3 l9_269=l9_268;
l9_263.color=mix(l9_269,l9_263.color,float3(l9_266));
}
}
l9_260++;
LightingComponents l9_270=l9_258;
LightProperties l9_271=l9_263;
SurfaceProperties l9_272=l9_255;
float3 l9_273=l9_259;
SurfaceProperties l9_274=l9_272;
float3 l9_275=l9_271.direction;
float l9_276=dot(l9_274.normal,l9_275);
float l9_277=fast::clamp(l9_276,0.0,1.0);
float3 l9_278=float3(l9_277);
l9_270.directDiffuse+=((l9_278*l9_271.color)*l9_271.attenuation);
SurfaceProperties l9_279=l9_272;
float3 l9_280=l9_271.direction;
float3 l9_281=l9_273;
l9_270.directSpecular+=((calculateDirectSpecular(l9_279,l9_280,l9_281)*l9_271.color)*l9_271.attenuation);
LightingComponents l9_282=l9_270;
l9_258=l9_282;
l9_264++;
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
sc_PointLight_t l9_283;
LightProperties l9_284;
int l9_285=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_285<sc_PointLightsCount_tmp)
{
l9_283.falloffRangeSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].falloffRangeSqr;
l9_283.falloffRangeNegInvSqrSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].falloffRangeNegInvSqrSqr;
l9_283.angleScale=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].angleScale;
l9_283.angleOffset=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].angleOffset;
l9_283.direction=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].direction;
l9_283.position=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].position;
l9_283.color=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].color;
l9_283.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_285].shadowMapParamsIndex;
float3 l9_286=l9_283.position-l9_255.positionWS;
float l9_287=dot(l9_286,l9_286);
float l9_288=l9_283.falloffRangeSqr;
float l9_289=l9_287;
float l9_290=l9_288;
bool l9_291=l9_290>0.0;
bool l9_292=l9_291&&(l9_289>l9_288);
if (!l9_292)
{
float l9_293=rsqrt(l9_287);
l9_284.direction=l9_286*l9_293;
l9_284.color=l9_283.color.xyz;
l9_284.attenuation=l9_283.color.w;
l9_284.attenuation*=l9_261[(l9_260<3) ? l9_260 : 3];
float3 l9_294=l9_284.direction;
float3 l9_295=l9_283.direction;
float l9_296=l9_283.angleScale;
float l9_297=l9_283.angleOffset;
float l9_298=dot(l9_294,l9_295);
float l9_299=fast::clamp((l9_298*l9_296)+l9_297,0.0,1.0);
float l9_300=l9_299*l9_299;
l9_284.attenuation*=l9_300;
float l9_301=l9_283.falloffRangeSqr;
bool l9_302=l9_301>0.0;
if (l9_302)
{
float l9_303=l9_293*l9_293;
float l9_304=l9_287;
float l9_305=l9_303;
float l9_306=l9_283.falloffRangeNegInvSqrSqr;
float l9_307=10000.0;
float l9_308=l9_306;
bool l9_309=l9_308!=0.0;
if (l9_309)
{
float l9_310=l9_304*l9_304;
l9_307+=(l9_310*l9_306);
l9_307=fast::max(l9_307,0.0);
}
float l9_311=l9_307*l9_305;
l9_284.attenuation*=l9_311;
}
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_283.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_312=l9_285;
float3 l9_313=-l9_284.direction;
float l9_314=evaluatePointShadowMap(l9_312,l9_313,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_315=l9_283.shadowMapParamsIndex;
float3 l9_316=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_315].params[0].xyz;
float3 l9_317=l9_316;
l9_284.color=mix(l9_317,l9_284.color,float3(l9_314));
}
}
LightingComponents l9_318=l9_258;
LightProperties l9_319=l9_284;
SurfaceProperties l9_320=l9_255;
float3 l9_321=l9_259;
SurfaceProperties l9_322=l9_320;
float3 l9_323=l9_319.direction;
float l9_324=dot(l9_322.normal,l9_323);
float l9_325=fast::clamp(l9_324,0.0,1.0);
float3 l9_326=float3(l9_325);
l9_318.directDiffuse+=((l9_326*l9_319.color)*l9_319.attenuation);
SurfaceProperties l9_327=l9_320;
float3 l9_328=l9_319.direction;
float3 l9_329=l9_321;
l9_318.directSpecular+=((calculateDirectSpecular(l9_327,l9_328,l9_329)*l9_319.color)*l9_319.attenuation);
LightingComponents l9_330=l9_318;
l9_258=l9_330;
}
l9_260++;
l9_285++;
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
float3 l9_331=float3(0.0);
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float2 l9_332=abs(in.varShadowTex-float2(0.5));
float l9_333=fast::max(l9_332.x,l9_332.y);
float l9_334=step(l9_333,0.5);
float4 l9_335=sc_set0.sc_ShadowTexture.sample(sc_set0.sc_ShadowTextureSmpSC,in.varShadowTex)*l9_334;
float3 l9_336=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_335.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float l9_337=l9_335.w*(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity;
l9_331=mix(float3(1.0),l9_336,float3(l9_337));
}
else
{
l9_331=float3(1.0);
}
float3 l9_338=l9_331;
float3 l9_339=l9_338;
l9_258.directDiffuse*=l9_339;
l9_258.directSpecular*=l9_339;
}
l9_258.directSpecular=float3(0.0);
SurfaceProperties l9_340=l9_255;
float3 l9_341=l9_340.normal;
float3 l9_342=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
float3 l9_343=l9_341;
float4 l9_344=float4(0.0);
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp)
{
float3 l9_345=l9_343;
float l9_346=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_347=float2(0.0);
float l9_348=l9_345.x;
float l9_349=-l9_345.z;
float l9_350=(l9_348<0.0) ? (-1.0) : 1.0;
float l9_351=l9_350*acos(fast::clamp(l9_349/length(float2(l9_348,l9_349)),-1.0,1.0));
l9_347.x=l9_351-1.5707964;
l9_347.y=acos(l9_345.y);
l9_347/=float2(6.2831855,3.1415927);
l9_347.y=1.0-l9_347.y;
l9_347.x+=(l9_346/360.0);
l9_347.x=fract((l9_347.x+floor(l9_347.x))+1.0);
float2 l9_352=l9_347;
float2 l9_353=l9_352;
if (SC_DEVICE_CLASS_tmp>=2)
{
float2 l9_354=l9_353;
float2 l9_355=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_356=5.0;
l9_353=calcSeamlessPanoramicUvsForSampling(l9_354,l9_355,l9_356);
}
float2 l9_357=l9_353;
float l9_358=13.0;
int l9_359;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_360=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_360=0;
}
else
{
l9_360=in.varStereoViewID;
}
int l9_361=l9_360;
l9_359=1-l9_361;
}
else
{
int l9_362=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_362=0;
}
else
{
l9_362=in.varStereoViewID;
}
int l9_363=l9_362;
l9_359=l9_363;
}
int l9_364=l9_359;
float2 l9_365=l9_357;
int l9_366=sc_EnvmapSpecularLayout_tmp;
int l9_367=l9_364;
float l9_368=l9_358;
float2 l9_369=l9_365;
int l9_370=l9_366;
int l9_371=l9_367;
float3 l9_372=float3(0.0);
if (l9_370==0)
{
l9_372=float3(l9_369,0.0);
}
else
{
if (l9_370==1)
{
l9_372=float3(l9_369.x,(l9_369.y*0.5)+(0.5-(float(l9_371)*0.5)),0.0);
}
else
{
l9_372=float3(l9_369,float(l9_371));
}
}
float3 l9_373=l9_372;
float3 l9_374=l9_373;
float4 l9_375=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_374.xy,bias(l9_368));
float4 l9_376=l9_375;
l9_344=l9_376;
}
else
{
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_377=l9_343;
float l9_378=0.18000001;
float l9_379=4.5;
float3 l9_380=l9_377;
float3 l9_381=float3(((-l9_380.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_380.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_380.y,(l9_380.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_380.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
l9_377=l9_381;
float3 l9_382;
if (abs(l9_377.z)<0.99000001)
{
l9_382=float3(-l9_377.y,l9_377.x,0.0);
}
else
{
l9_382=float3(0.0,-l9_377.z,l9_377.y);
}
float3 l9_383=normalize(l9_382);
float3 l9_384=cross(l9_377,l9_383);
float3 l9_385=l9_377+(((l9_383*1.0)+(l9_384*0.0))*l9_378);
float3 l9_386=l9_377+(((l9_383*(-0.5))+(l9_384*0.86602539))*l9_378);
float3 l9_387=l9_377+(((l9_383*(-0.5))-(l9_384*0.86602539))*l9_378);
float3 l9_388=l9_385;
bool l9_389=true;
float l9_390=l9_379;
float4 l9_391;
if (l9_389)
{
l9_391=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_388,level(l9_390));
}
else
{
l9_391=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_388,bias(l9_390));
}
float4 l9_392=l9_391;
float4 l9_393=l9_392;
float3 l9_394=l9_386;
bool l9_395=true;
float l9_396=l9_379;
float4 l9_397;
if (l9_395)
{
l9_397=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_394,level(l9_396));
}
else
{
l9_397=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_394,bias(l9_396));
}
float4 l9_398=l9_397;
float4 l9_399=l9_398;
float3 l9_400=l9_387;
bool l9_401=true;
float l9_402=l9_379;
float4 l9_403;
if (l9_401)
{
l9_403=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_400,level(l9_402));
}
else
{
l9_403=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_400,bias(l9_402));
}
float4 l9_404=l9_403;
float4 l9_405=l9_404;
float4 l9_406=((l9_393+l9_399)+l9_405)*0.33333334;
l9_344=l9_406;
}
else
{
float3 l9_407=l9_343;
float l9_408=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_409=float2(0.0);
float l9_410=l9_407.x;
float l9_411=-l9_407.z;
float l9_412=(l9_410<0.0) ? (-1.0) : 1.0;
float l9_413=l9_412*acos(fast::clamp(l9_411/length(float2(l9_410,l9_411)),-1.0,1.0));
l9_409.x=l9_413-1.5707964;
l9_409.y=acos(l9_407.y);
l9_409/=float2(6.2831855,3.1415927);
l9_409.y=1.0-l9_409.y;
l9_409.x+=(l9_408/360.0);
l9_409.x=fract((l9_409.x+floor(l9_409.x))+1.0);
float2 l9_414=l9_409;
float2 l9_415=l9_414;
if ((int(sc_HasDiffuseEnvmap_tmp)!=0))
{
float2 l9_416=l9_415;
float2 l9_417=(*sc_set1.sc_LightingUBO).sc_EnvmapDiffuseSize.xy;
float l9_418=0.0;
l9_415=calcSeamlessPanoramicUvsForSampling(l9_416,l9_417,l9_418);
float2 l9_419=l9_415;
float l9_420=-13.0;
int l9_421;
if ((int(sc_EnvmapDiffuseHasSwappedViews_tmp)!=0))
{
int l9_422=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_422=0;
}
else
{
l9_422=in.varStereoViewID;
}
int l9_423=l9_422;
l9_421=1-l9_423;
}
else
{
int l9_424=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_424=0;
}
else
{
l9_424=in.varStereoViewID;
}
int l9_425=l9_424;
l9_421=l9_425;
}
int l9_426=l9_421;
float2 l9_427=l9_419;
int l9_428=sc_EnvmapDiffuseLayout_tmp;
int l9_429=l9_426;
float l9_430=l9_420;
float2 l9_431=l9_427;
int l9_432=l9_428;
int l9_433=l9_429;
float3 l9_434=float3(0.0);
if (l9_432==0)
{
l9_434=float3(l9_431,0.0);
}
else
{
if (l9_432==1)
{
l9_434=float3(l9_431.x,(l9_431.y*0.5)+(0.5-(float(l9_433)*0.5)),0.0);
}
else
{
l9_434=float3(l9_431,float(l9_433));
}
}
float3 l9_435=l9_434;
float3 l9_436=l9_435;
float4 l9_437=sc_set0.sc_EnvmapDiffuse.sample(sc_set0.sc_EnvmapDiffuseSmpSC,l9_436.xy,bias(l9_430));
float4 l9_438=l9_437;
l9_344=l9_438;
}
else
{
float2 l9_439=l9_415;
float l9_440=13.0;
int l9_441;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_442=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_442=0;
}
else
{
l9_442=in.varStereoViewID;
}
int l9_443=l9_442;
l9_441=1-l9_443;
}
else
{
int l9_444=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_444=0;
}
else
{
l9_444=in.varStereoViewID;
}
int l9_445=l9_444;
l9_441=l9_445;
}
int l9_446=l9_441;
float2 l9_447=l9_439;
int l9_448=sc_EnvmapSpecularLayout_tmp;
int l9_449=l9_446;
float l9_450=l9_440;
float2 l9_451=l9_447;
int l9_452=l9_448;
int l9_453=l9_449;
float3 l9_454=float3(0.0);
if (l9_452==0)
{
l9_454=float3(l9_451,0.0);
}
else
{
if (l9_452==1)
{
l9_454=float3(l9_451.x,(l9_451.y*0.5)+(0.5-(float(l9_453)*0.5)),0.0);
}
else
{
l9_454=float3(l9_451,float(l9_453));
}
}
float3 l9_455=l9_454;
float3 l9_456=l9_455;
float4 l9_457=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_456.xy,bias(l9_450));
float4 l9_458=l9_457;
l9_344=l9_458;
}
}
}
float4 l9_459=l9_344;
float3 l9_460=l9_459.xyz*(1.0/fast::max(l9_459.w,0.0039215689));
float3 l9_461=l9_460*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_342=l9_461;
}
else
{
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_SphericalHarmonics_tmp)
{
float3 l9_462=(*sc_set1.sc_LightingUBO).sc_Sh[0];
float3 l9_463=(*sc_set1.sc_LightingUBO).sc_Sh[1];
float3 l9_464=(*sc_set1.sc_LightingUBO).sc_Sh[2];
float3 l9_465=(*sc_set1.sc_LightingUBO).sc_Sh[3];
float3 l9_466=(*sc_set1.sc_LightingUBO).sc_Sh[4];
float3 l9_467=(*sc_set1.sc_LightingUBO).sc_Sh[5];
float3 l9_468=(*sc_set1.sc_LightingUBO).sc_Sh[6];
float3 l9_469=(*sc_set1.sc_LightingUBO).sc_Sh[7];
float3 l9_470=(*sc_set1.sc_LightingUBO).sc_Sh[8];
float3 l9_471=-l9_341;
float l9_472=0.0;
l9_472=l9_471.x;
float l9_473=l9_471.y;
float l9_474=l9_471.z;
float l9_475=l9_472*l9_472;
float l9_476=l9_473*l9_473;
float l9_477=l9_474*l9_474;
float l9_478=l9_472*l9_473;
float l9_479=l9_473*l9_474;
float l9_480=l9_472*l9_474;
float3 l9_481=((((((l9_470*0.42904299)*(l9_475-l9_476))+((l9_468*0.74312502)*l9_477))+(l9_462*0.88622701))-(l9_468*0.24770799))+((((l9_466*l9_478)+(l9_469*l9_480))+(l9_467*l9_479))*0.85808599))+((((l9_465*l9_472)+(l9_463*l9_473))+(l9_464*l9_474))*1.0233279);
l9_342=l9_481*(*sc_set1.sc_LightingUBO).sc_ShIntensity;
}
}
if (sc_AmbientLightsCount_tmp>0)
{
if (sc_AmbientLightMode0_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_342+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].intensity);
}
else
{
l9_342.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color.x);
}
}
if (sc_AmbientLightsCount_tmp>1)
{
if (sc_AmbientLightMode1_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_342+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].intensity);
}
else
{
l9_342.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color.x);
}
}
if (sc_AmbientLightsCount_tmp>2)
{
if (sc_AmbientLightMode2_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_342+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].intensity);
}
else
{
l9_342.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color.x);
}
}
if ((int(sc_LightEstimation_tmp)!=0))
{
float3 l9_482=l9_341;
float3 l9_483=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight;
sc_SphericalGaussianLight_t l9_484;
float l9_485;
int l9_486=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_486<sc_LightEstimationSGCount_tmp)
{
l9_484.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_486].color;
l9_484.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_486].sharpness;
l9_484.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_486].axis;
float3 l9_487=l9_482;
float l9_488=dot(l9_484.axis,l9_487);
float l9_489=l9_484.sharpness;
float l9_490=0.36000001;
float l9_491=1.0/(4.0*l9_490);
float l9_492=exp(-l9_489);
float l9_493=l9_492*l9_492;
float l9_494=1.0/l9_489;
float l9_495=(1.0+(2.0*l9_493))-l9_494;
float l9_496=((l9_492-l9_493)*l9_494)-l9_493;
float l9_497=sqrt(1.0-l9_495);
float l9_498=l9_490*l9_488;
float l9_499=l9_491*l9_497;
float l9_500=l9_498+l9_499;
float l9_501=l9_488;
float l9_502=fast::clamp(l9_501,0.0,1.0);
float l9_503=l9_502;
if (step(abs(l9_498),l9_499)>0.5)
{
l9_485=(l9_500*l9_500)/l9_497;
}
else
{
l9_485=l9_503;
}
l9_503=l9_485;
float l9_504=(l9_495*l9_503)+l9_496;
sc_SphericalGaussianLight_t l9_505=l9_484;
float3 l9_506=(l9_505.color/float3(l9_505.sharpness))*6.2831855;
float3 l9_507=(l9_506*l9_504)/float3(3.1415927);
l9_483+=l9_507;
l9_486++;
continue;
}
else
{
break;
}
}
float3 l9_508=l9_483;
l9_342+=l9_508;
}
float3 l9_509=l9_342;
float3 l9_510=l9_509;
l9_258.indirectDiffuse=l9_510;
LightingComponents l9_511=l9_258;
LightingComponents l9_512=l9_511;
if (sc_BlendMode_tmp==9)
{
l9_512.directDiffuse=float3(0.0);
l9_512.indirectDiffuse=float3(0.0);
float4 l9_513=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_514=out.sc_FragData0;
l9_513=l9_514;
}
else
{
float4 l9_515=gl_FragCoord;
float2 l9_516=l9_515.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_517=l9_516;
float2 l9_518=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_519=1;
int l9_520=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_520=0;
}
else
{
l9_520=in.varStereoViewID;
}
int l9_521=l9_520;
int l9_522=l9_521;
float3 l9_523=float3(l9_517,0.0);
int l9_524=l9_519;
int l9_525=l9_522;
if (l9_524==1)
{
l9_523.y=((2.0*l9_523.y)+float(l9_525))-1.0;
}
float2 l9_526=l9_523.xy;
l9_518=l9_526;
}
else
{
l9_518=l9_517;
}
float2 l9_527=l9_518;
float2 l9_528=l9_527;
float2 l9_529=l9_528;
float2 l9_530=l9_529;
float l9_531=0.0;
int l9_532;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_533=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_533=0;
}
else
{
l9_533=in.varStereoViewID;
}
int l9_534=l9_533;
l9_532=1-l9_534;
}
else
{
int l9_535=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_535=0;
}
else
{
l9_535=in.varStereoViewID;
}
int l9_536=l9_535;
l9_532=l9_536;
}
int l9_537=l9_532;
float2 l9_538=l9_530;
int l9_539=sc_ScreenTextureLayout_tmp;
int l9_540=l9_537;
float l9_541=l9_531;
float2 l9_542=l9_538;
int l9_543=l9_539;
int l9_544=l9_540;
float3 l9_545=float3(0.0);
if (l9_543==0)
{
l9_545=float3(l9_542,0.0);
}
else
{
if (l9_543==1)
{
l9_545=float3(l9_542.x,(l9_542.y*0.5)+(0.5-(float(l9_544)*0.5)),0.0);
}
else
{
l9_545=float3(l9_542,float(l9_544));
}
}
float3 l9_546=l9_545;
float3 l9_547=l9_546;
float4 l9_548=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_547.xy,bias(l9_541));
float4 l9_549=l9_548;
float4 l9_550=l9_549;
l9_513=l9_550;
}
float4 l9_551=l9_513;
float3 l9_552=l9_551.xyz;
float3 l9_553;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_553=float3(pow(l9_552.x,2.2),pow(l9_552.y,2.2),pow(l9_552.z,2.2));
}
else
{
l9_553=l9_552*l9_552;
}
float3 l9_554=l9_553;
float3 l9_555=l9_554;
l9_512.transmitted=l9_555*mix(float3(1.0),l9_242.albedo,float3(l9_242.opacity));
l9_242.opacity=1.0;
}
bool l9_556=false;
if (sc_BlendMode_tmp==4)
{
l9_556=true;
}
SurfaceProperties l9_557=l9_242;
LightingComponents l9_558=l9_512;
bool l9_559=l9_556;
float3 l9_560=l9_557.albedo*(l9_558.directDiffuse+(l9_558.indirectDiffuse*l9_557.ao));
float3 l9_561=l9_558.directSpecular+(l9_558.indirectSpecular*l9_557.specularAo);
float3 l9_562=l9_557.emissive;
float3 l9_563=l9_558.transmitted;
if (l9_559)
{
float l9_564=l9_557.opacity;
l9_560*=srgbToLinear(l9_564);
}
float3 l9_565=((l9_560+l9_561)+l9_562)+l9_563;
float3 l9_566=l9_565;
float4 l9_567=float4(l9_566,l9_242.opacity);
if (sc_BlendMode_tmp!=1)
{
float3 l9_568=l9_567.xyz;
float l9_569=1.8;
float l9_570=1.4;
float l9_571=0.5;
float l9_572=1.5;
float3 l9_573=(l9_568*((l9_568*l9_569)+float3(l9_570)))/((l9_568*((l9_568*l9_569)+float3(l9_571)))+float3(l9_572));
l9_567=float4(l9_573.x,l9_573.y,l9_573.z,l9_567.w);
}
float3 l9_574=l9_567.xyz;
float l9_575=l9_574.x;
float l9_576=l9_574.y;
float l9_577=l9_574.z;
float3 l9_578=float3(linearToSrgb(l9_575),linearToSrgb(l9_576),linearToSrgb(l9_577));
l9_567=float4(l9_578.x,l9_578.y,l9_578.z,l9_567.w);
float4 l9_579=l9_567;
param_20=l9_579;
}
param_20=fast::max(param_20,float4(0.0));
Output_N36=param_20;
FinalColor=Output_N36;
float4 param_22=FinalColor;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
float4 l9_580=param_22;
float4 l9_581=l9_580;
float l9_582=1.0;
if ((((sc_BlendMode_tmp==0)||(sc_BlendMode_tmp==5))||(sc_BlendMode_tmp==14))||(sc_BlendMode_tmp==16))
{
l9_582=l9_581.w;
}
else
{
if (sc_BlendMode_tmp==4)
{
l9_582=fast::clamp(l9_581.w*2.0,0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==8)
{
l9_582=1.0;
}
else
{
if (sc_BlendMode_tmp==1)
{
l9_582=(1.0-dot(l9_581.xyz,float3(0.33333001)))*l9_581.w;
}
else
{
if (sc_BlendMode_tmp==10)
{
l9_582=(1.0-fast::clamp(dot(l9_581.xyz,float3(1.0)),0.0,1.0))*l9_581.w;
}
else
{
if (sc_BlendMode_tmp==9)
{
l9_582=fast::clamp(dot(l9_581.xyz,float3(1.0)),0.0,1.0)*l9_581.w;
}
else
{
if (sc_BlendMode_tmp==2)
{
l9_582=fast::clamp(dot(l9_581.xyz,float3(1.0)),0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==7)
{
l9_582=fast::clamp(dot(l9_581.xyz,float3(1.0)),0.0,1.0)*l9_581.w;
}
else
{
if (sc_BlendMode_tmp==3)
{
l9_582=dot(l9_581.xyz,float3(0.33333001))*l9_581.w;
}
else
{
if (sc_BlendMode_tmp==11)
{
l9_582=1.0-fast::clamp(dot(l9_581.xyz,float3(1.0)),0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==12)
{
l9_582=fast::clamp(dot(l9_581.xyz,float3(1.0)),0.0,1.0);
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
float l9_583=l9_582;
float l9_584=l9_583;
float l9_585=(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity*l9_584;
float3 l9_586=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_580.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float4 l9_587=float4(l9_586.x,l9_586.y,l9_586.z,l9_585);
param_22=l9_587;
}
else
{
if ((int(sc_RenderAlphaToColor_tmp)!=0))
{
param_22=float4(param_22.w);
}
else
{
if ((int(sc_BlendMode_Custom_tmp)!=0))
{
float4 l9_588=param_22;
float4 l9_589=float4(0.0);
float4 l9_590=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_591=out.sc_FragData0;
l9_590=l9_591;
}
else
{
float4 l9_592=gl_FragCoord;
float2 l9_593=l9_592.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_594=l9_593;
float2 l9_595=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_596=1;
int l9_597=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_597=0;
}
else
{
l9_597=in.varStereoViewID;
}
int l9_598=l9_597;
int l9_599=l9_598;
float3 l9_600=float3(l9_594,0.0);
int l9_601=l9_596;
int l9_602=l9_599;
if (l9_601==1)
{
l9_600.y=((2.0*l9_600.y)+float(l9_602))-1.0;
}
float2 l9_603=l9_600.xy;
l9_595=l9_603;
}
else
{
l9_595=l9_594;
}
float2 l9_604=l9_595;
float2 l9_605=l9_604;
float2 l9_606=l9_605;
float2 l9_607=l9_606;
float l9_608=0.0;
int l9_609;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_610=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_610=0;
}
else
{
l9_610=in.varStereoViewID;
}
int l9_611=l9_610;
l9_609=1-l9_611;
}
else
{
int l9_612=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_612=0;
}
else
{
l9_612=in.varStereoViewID;
}
int l9_613=l9_612;
l9_609=l9_613;
}
int l9_614=l9_609;
float2 l9_615=l9_607;
int l9_616=sc_ScreenTextureLayout_tmp;
int l9_617=l9_614;
float l9_618=l9_608;
float2 l9_619=l9_615;
int l9_620=l9_616;
int l9_621=l9_617;
float3 l9_622=float3(0.0);
if (l9_620==0)
{
l9_622=float3(l9_619,0.0);
}
else
{
if (l9_620==1)
{
l9_622=float3(l9_619.x,(l9_619.y*0.5)+(0.5-(float(l9_621)*0.5)),0.0);
}
else
{
l9_622=float3(l9_619,float(l9_621));
}
}
float3 l9_623=l9_622;
float3 l9_624=l9_623;
float4 l9_625=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_624.xy,bias(l9_618));
float4 l9_626=l9_625;
float4 l9_627=l9_626;
l9_590=l9_627;
}
float4 l9_628=l9_590;
float3 l9_629=l9_628.xyz;
float3 l9_630=l9_629;
float3 l9_631=l9_588.xyz;
float3 l9_632=definedBlend(l9_630,l9_631,in.varStereoViewID,(*sc_set0.UserUniforms),sc_set0.intensityTexture,sc_set0.intensityTextureSmpSC);
l9_589=float4(l9_632.x,l9_632.y,l9_632.z,l9_589.w);
float3 l9_633=mix(l9_629,l9_589.xyz,float3(l9_588.w));
l9_589=float4(l9_633.x,l9_633.y,l9_633.z,l9_589.w);
l9_589.w=1.0;
float4 l9_634=l9_589;
param_22=l9_634;
}
else
{
if ((int(sc_Voxelization_tmp)!=0))
{
float4 l9_635=float4(in.varScreenPos.xyz,1.0);
param_22=l9_635;
}
else
{
if ((int(sc_OutputBounds_tmp)!=0))
{
float4 l9_636=gl_FragCoord;
float l9_637=fast::clamp(abs(l9_636.z),0.0,1.0);
float4 l9_638=float4(l9_637,1.0-l9_637,1.0,1.0);
param_22=l9_638;
}
else
{
float4 l9_639=param_22;
float4 l9_640=float4(0.0);
if (sc_BlendMode_tmp==10)
{
l9_640=float4(mix(float3(1.0),l9_639.xyz,float3(l9_639.w)),l9_639.w);
}
else
{
if ((sc_BlendMode_tmp==3)||(sc_BlendMode_tmp==16))
{
float l9_641=l9_639.w;
if (sc_BlendMode_tmp==16)
{
l9_641=fast::clamp(l9_641,0.0,1.0);
}
l9_640=float4(l9_639.xyz*l9_641,l9_641);
}
else
{
l9_640=l9_639;
}
}
float4 l9_642=l9_640;
param_22=l9_642;
}
}
}
}
}
float4 l9_643=param_22;
FinalColor=l9_643;
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
float4 l9_644=float4(0.0);
float4 Cost=l9_644;
if (Cost.w>0.0)
{
FinalColor=Cost;
}
FinalColor=fast::max(FinalColor,float4(0.0));
float4 param_23=FinalColor;
FinalColor=sc_OutputMotionVectorIfNeeded(param_23,in.varPosAndMotion,in.varNormalAndMotion);
float4 param_24=FinalColor;
float4 l9_645=param_24;
if (sc_ShaderCacheConstant_tmp!=0)
{
l9_645.x+=((*sc_set1.sc_CameraUBO).sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
out.sc_FragData0=l9_645;
return out;
}
} // FRAGMENT SHADER
