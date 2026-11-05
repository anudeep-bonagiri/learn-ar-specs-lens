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
constant bool ENABLE_BASE_TEXTURE_TRANSFORM [[function_constant(0)]];
constant bool ENABLE_BASE_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_BASE_TEXTURE_TRANSFORM) ? ENABLE_BASE_TEXTURE_TRANSFORM : false;
constant bool ENABLE_BASE_TEX [[function_constant(1)]];
constant bool ENABLE_BASE_TEX_tmp = is_function_constant_defined(ENABLE_BASE_TEX) ? ENABLE_BASE_TEX : false;
constant bool ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM [[function_constant(2)]];
constant bool ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM) ? ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM : false;
constant bool ENABLE_CLEARCOAT_NORMAL_TEX [[function_constant(3)]];
constant bool ENABLE_CLEARCOAT_NORMAL_TEX_tmp = is_function_constant_defined(ENABLE_CLEARCOAT_NORMAL_TEX) ? ENABLE_CLEARCOAT_NORMAL_TEX : false;
constant bool ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM [[function_constant(4)]];
constant bool ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM) ? ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM : false;
constant bool ENABLE_CLEARCOAT_ROUGHNESS_TEX [[function_constant(5)]];
constant bool ENABLE_CLEARCOAT_ROUGHNESS_TEX_tmp = is_function_constant_defined(ENABLE_CLEARCOAT_ROUGHNESS_TEX) ? ENABLE_CLEARCOAT_ROUGHNESS_TEX : false;
constant bool ENABLE_CLEARCOAT_TEXTURE_TRANSFORM [[function_constant(6)]];
constant bool ENABLE_CLEARCOAT_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_CLEARCOAT_TEXTURE_TRANSFORM) ? ENABLE_CLEARCOAT_TEXTURE_TRANSFORM : false;
constant bool ENABLE_CLEARCOAT_TEX [[function_constant(7)]];
constant bool ENABLE_CLEARCOAT_TEX_tmp = is_function_constant_defined(ENABLE_CLEARCOAT_TEX) ? ENABLE_CLEARCOAT_TEX : false;
constant bool ENABLE_CLEARCOAT [[function_constant(8)]];
constant bool ENABLE_CLEARCOAT_tmp = is_function_constant_defined(ENABLE_CLEARCOAT) ? ENABLE_CLEARCOAT : false;
constant bool ENABLE_EMISSIVE_TEXTURE_TRANSFORM [[function_constant(9)]];
constant bool ENABLE_EMISSIVE_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_EMISSIVE_TEXTURE_TRANSFORM) ? ENABLE_EMISSIVE_TEXTURE_TRANSFORM : false;
constant bool ENABLE_EMISSIVE [[function_constant(10)]];
constant bool ENABLE_EMISSIVE_tmp = is_function_constant_defined(ENABLE_EMISSIVE) ? ENABLE_EMISSIVE : false;
constant bool ENABLE_GLTF_LIGHTING [[function_constant(11)]];
constant bool ENABLE_GLTF_LIGHTING_tmp = is_function_constant_defined(ENABLE_GLTF_LIGHTING) ? ENABLE_GLTF_LIGHTING : false;
constant bool ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM [[function_constant(12)]];
constant bool ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM) ? ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM : false;
constant bool ENABLE_METALLIC_ROUGHNESS_TEX [[function_constant(13)]];
constant bool ENABLE_METALLIC_ROUGHNESS_TEX_tmp = is_function_constant_defined(ENABLE_METALLIC_ROUGHNESS_TEX) ? ENABLE_METALLIC_ROUGHNESS_TEX : false;
constant bool ENABLE_NORMALMAP [[function_constant(14)]];
constant bool ENABLE_NORMALMAP_tmp = is_function_constant_defined(ENABLE_NORMALMAP) ? ENABLE_NORMALMAP : false;
constant bool ENABLE_NORMAL_TEXTURE_TRANSFORM [[function_constant(15)]];
constant bool ENABLE_NORMAL_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_NORMAL_TEXTURE_TRANSFORM) ? ENABLE_NORMAL_TEXTURE_TRANSFORM : false;
constant bool ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM [[function_constant(16)]];
constant bool ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM) ? ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM : false;
constant bool ENABLE_SHEEN_COLOR_TEX [[function_constant(17)]];
constant bool ENABLE_SHEEN_COLOR_TEX_tmp = is_function_constant_defined(ENABLE_SHEEN_COLOR_TEX) ? ENABLE_SHEEN_COLOR_TEX : false;
constant bool ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM [[function_constant(18)]];
constant bool ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM) ? ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM : false;
constant bool ENABLE_SHEEN_ROUGHNESS_TEX [[function_constant(19)]];
constant bool ENABLE_SHEEN_ROUGHNESS_TEX_tmp = is_function_constant_defined(ENABLE_SHEEN_ROUGHNESS_TEX) ? ENABLE_SHEEN_ROUGHNESS_TEX : false;
constant bool ENABLE_SHEEN [[function_constant(20)]];
constant bool ENABLE_SHEEN_tmp = is_function_constant_defined(ENABLE_SHEEN) ? ENABLE_SHEEN : false;
constant bool ENABLE_STIPPLE_PATTERN_TEST [[function_constant(21)]];
constant bool ENABLE_STIPPLE_PATTERN_TEST_tmp = is_function_constant_defined(ENABLE_STIPPLE_PATTERN_TEST) ? ENABLE_STIPPLE_PATTERN_TEST : false;
constant bool ENABLE_TEXTURE_TRANSFORM [[function_constant(22)]];
constant bool ENABLE_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_TEXTURE_TRANSFORM) ? ENABLE_TEXTURE_TRANSFORM : false;
constant bool ENABLE_TRANSMISSION_TEXTURE_TRANSFORM [[function_constant(23)]];
constant bool ENABLE_TRANSMISSION_TEXTURE_TRANSFORM_tmp = is_function_constant_defined(ENABLE_TRANSMISSION_TEXTURE_TRANSFORM) ? ENABLE_TRANSMISSION_TEXTURE_TRANSFORM : false;
constant bool ENABLE_TRANSMISSION_TEX [[function_constant(24)]];
constant bool ENABLE_TRANSMISSION_TEX_tmp = is_function_constant_defined(ENABLE_TRANSMISSION_TEX) ? ENABLE_TRANSMISSION_TEX : false;
constant bool ENABLE_TRANSMISSION [[function_constant(25)]];
constant bool ENABLE_TRANSMISSION_tmp = is_function_constant_defined(ENABLE_TRANSMISSION) ? ENABLE_TRANSMISSION : false;
constant bool ENABLE_VERTEX_COLOR_BASE [[function_constant(26)]];
constant bool ENABLE_VERTEX_COLOR_BASE_tmp = is_function_constant_defined(ENABLE_VERTEX_COLOR_BASE) ? ENABLE_VERTEX_COLOR_BASE : false;
constant bool METALLIC_ROUGHNESS_TEX_SWIZZLE_RB [[function_constant(27)]];
constant bool METALLIC_ROUGHNESS_TEX_SWIZZLE_RB_tmp = is_function_constant_defined(METALLIC_ROUGHNESS_TEX_SWIZZLE_RB) ? METALLIC_ROUGHNESS_TEX_SWIZZLE_RB : false;
constant bool SC_USE_CLAMP_TO_BORDER_baseColorTexture [[function_constant(28)]];
constant bool SC_USE_CLAMP_TO_BORDER_baseColorTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_baseColorTexture) ? SC_USE_CLAMP_TO_BORDER_baseColorTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture [[function_constant(29)]];
constant bool SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture) ? SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture [[function_constant(30)]];
constant bool SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture) ? SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_clearcoatTexture [[function_constant(31)]];
constant bool SC_USE_CLAMP_TO_BORDER_clearcoatTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_clearcoatTexture) ? SC_USE_CLAMP_TO_BORDER_clearcoatTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_emissiveTexture [[function_constant(32)]];
constant bool SC_USE_CLAMP_TO_BORDER_emissiveTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_emissiveTexture) ? SC_USE_CLAMP_TO_BORDER_emissiveTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_intensityTexture [[function_constant(33)]];
constant bool SC_USE_CLAMP_TO_BORDER_intensityTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_intensityTexture) ? SC_USE_CLAMP_TO_BORDER_intensityTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture [[function_constant(34)]];
constant bool SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture) ? SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_normalTexture [[function_constant(35)]];
constant bool SC_USE_CLAMP_TO_BORDER_normalTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_normalTexture) ? SC_USE_CLAMP_TO_BORDER_normalTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_screenTexture [[function_constant(36)]];
constant bool SC_USE_CLAMP_TO_BORDER_screenTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_screenTexture) ? SC_USE_CLAMP_TO_BORDER_screenTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_sheenColorTexture [[function_constant(37)]];
constant bool SC_USE_CLAMP_TO_BORDER_sheenColorTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_sheenColorTexture) ? SC_USE_CLAMP_TO_BORDER_sheenColorTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture [[function_constant(38)]];
constant bool SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture) ? SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture : false;
constant bool SC_USE_CLAMP_TO_BORDER_transmissionTexture [[function_constant(39)]];
constant bool SC_USE_CLAMP_TO_BORDER_transmissionTexture_tmp = is_function_constant_defined(SC_USE_CLAMP_TO_BORDER_transmissionTexture) ? SC_USE_CLAMP_TO_BORDER_transmissionTexture : false;
constant bool SC_USE_UV_MIN_MAX_baseColorTexture [[function_constant(40)]];
constant bool SC_USE_UV_MIN_MAX_baseColorTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_baseColorTexture) ? SC_USE_UV_MIN_MAX_baseColorTexture : false;
constant bool SC_USE_UV_MIN_MAX_clearcoatNormalTexture [[function_constant(41)]];
constant bool SC_USE_UV_MIN_MAX_clearcoatNormalTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_clearcoatNormalTexture) ? SC_USE_UV_MIN_MAX_clearcoatNormalTexture : false;
constant bool SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture [[function_constant(42)]];
constant bool SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture) ? SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture : false;
constant bool SC_USE_UV_MIN_MAX_clearcoatTexture [[function_constant(43)]];
constant bool SC_USE_UV_MIN_MAX_clearcoatTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_clearcoatTexture) ? SC_USE_UV_MIN_MAX_clearcoatTexture : false;
constant bool SC_USE_UV_MIN_MAX_emissiveTexture [[function_constant(44)]];
constant bool SC_USE_UV_MIN_MAX_emissiveTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_emissiveTexture) ? SC_USE_UV_MIN_MAX_emissiveTexture : false;
constant bool SC_USE_UV_MIN_MAX_intensityTexture [[function_constant(45)]];
constant bool SC_USE_UV_MIN_MAX_intensityTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_intensityTexture) ? SC_USE_UV_MIN_MAX_intensityTexture : false;
constant bool SC_USE_UV_MIN_MAX_metallicRoughnessTexture [[function_constant(46)]];
constant bool SC_USE_UV_MIN_MAX_metallicRoughnessTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_metallicRoughnessTexture) ? SC_USE_UV_MIN_MAX_metallicRoughnessTexture : false;
constant bool SC_USE_UV_MIN_MAX_normalTexture [[function_constant(47)]];
constant bool SC_USE_UV_MIN_MAX_normalTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_normalTexture) ? SC_USE_UV_MIN_MAX_normalTexture : false;
constant bool SC_USE_UV_MIN_MAX_screenTexture [[function_constant(48)]];
constant bool SC_USE_UV_MIN_MAX_screenTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_screenTexture) ? SC_USE_UV_MIN_MAX_screenTexture : false;
constant bool SC_USE_UV_MIN_MAX_sheenColorTexture [[function_constant(49)]];
constant bool SC_USE_UV_MIN_MAX_sheenColorTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_sheenColorTexture) ? SC_USE_UV_MIN_MAX_sheenColorTexture : false;
constant bool SC_USE_UV_MIN_MAX_sheenRoughnessTexture [[function_constant(50)]];
constant bool SC_USE_UV_MIN_MAX_sheenRoughnessTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_sheenRoughnessTexture) ? SC_USE_UV_MIN_MAX_sheenRoughnessTexture : false;
constant bool SC_USE_UV_MIN_MAX_transmissionTexture [[function_constant(51)]];
constant bool SC_USE_UV_MIN_MAX_transmissionTexture_tmp = is_function_constant_defined(SC_USE_UV_MIN_MAX_transmissionTexture) ? SC_USE_UV_MIN_MAX_transmissionTexture : false;
constant bool SC_USE_UV_TRANSFORM_baseColorTexture [[function_constant(52)]];
constant bool SC_USE_UV_TRANSFORM_baseColorTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_baseColorTexture) ? SC_USE_UV_TRANSFORM_baseColorTexture : false;
constant bool SC_USE_UV_TRANSFORM_clearcoatNormalTexture [[function_constant(53)]];
constant bool SC_USE_UV_TRANSFORM_clearcoatNormalTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_clearcoatNormalTexture) ? SC_USE_UV_TRANSFORM_clearcoatNormalTexture : false;
constant bool SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture [[function_constant(54)]];
constant bool SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture) ? SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture : false;
constant bool SC_USE_UV_TRANSFORM_clearcoatTexture [[function_constant(55)]];
constant bool SC_USE_UV_TRANSFORM_clearcoatTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_clearcoatTexture) ? SC_USE_UV_TRANSFORM_clearcoatTexture : false;
constant bool SC_USE_UV_TRANSFORM_emissiveTexture [[function_constant(56)]];
constant bool SC_USE_UV_TRANSFORM_emissiveTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_emissiveTexture) ? SC_USE_UV_TRANSFORM_emissiveTexture : false;
constant bool SC_USE_UV_TRANSFORM_intensityTexture [[function_constant(57)]];
constant bool SC_USE_UV_TRANSFORM_intensityTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_intensityTexture) ? SC_USE_UV_TRANSFORM_intensityTexture : false;
constant bool SC_USE_UV_TRANSFORM_metallicRoughnessTexture [[function_constant(58)]];
constant bool SC_USE_UV_TRANSFORM_metallicRoughnessTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_metallicRoughnessTexture) ? SC_USE_UV_TRANSFORM_metallicRoughnessTexture : false;
constant bool SC_USE_UV_TRANSFORM_normalTexture [[function_constant(59)]];
constant bool SC_USE_UV_TRANSFORM_normalTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_normalTexture) ? SC_USE_UV_TRANSFORM_normalTexture : false;
constant bool SC_USE_UV_TRANSFORM_screenTexture [[function_constant(60)]];
constant bool SC_USE_UV_TRANSFORM_screenTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_screenTexture) ? SC_USE_UV_TRANSFORM_screenTexture : false;
constant bool SC_USE_UV_TRANSFORM_sheenColorTexture [[function_constant(61)]];
constant bool SC_USE_UV_TRANSFORM_sheenColorTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_sheenColorTexture) ? SC_USE_UV_TRANSFORM_sheenColorTexture : false;
constant bool SC_USE_UV_TRANSFORM_sheenRoughnessTexture [[function_constant(62)]];
constant bool SC_USE_UV_TRANSFORM_sheenRoughnessTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_sheenRoughnessTexture) ? SC_USE_UV_TRANSFORM_sheenRoughnessTexture : false;
constant bool SC_USE_UV_TRANSFORM_transmissionTexture [[function_constant(63)]];
constant bool SC_USE_UV_TRANSFORM_transmissionTexture_tmp = is_function_constant_defined(SC_USE_UV_TRANSFORM_transmissionTexture) ? SC_USE_UV_TRANSFORM_transmissionTexture : false;
constant bool UseViewSpaceDepthVariant [[function_constant(64)]];
constant bool UseViewSpaceDepthVariant_tmp = is_function_constant_defined(UseViewSpaceDepthVariant) ? UseViewSpaceDepthVariant : true;
constant bool baseColorTextureHasSwappedViews [[function_constant(65)]];
constant bool baseColorTextureHasSwappedViews_tmp = is_function_constant_defined(baseColorTextureHasSwappedViews) ? baseColorTextureHasSwappedViews : false;
constant bool clearcoatNormalTextureHasSwappedViews [[function_constant(66)]];
constant bool clearcoatNormalTextureHasSwappedViews_tmp = is_function_constant_defined(clearcoatNormalTextureHasSwappedViews) ? clearcoatNormalTextureHasSwappedViews : false;
constant bool clearcoatRoughnessTextureHasSwappedViews [[function_constant(67)]];
constant bool clearcoatRoughnessTextureHasSwappedViews_tmp = is_function_constant_defined(clearcoatRoughnessTextureHasSwappedViews) ? clearcoatRoughnessTextureHasSwappedViews : false;
constant bool clearcoatTextureHasSwappedViews [[function_constant(68)]];
constant bool clearcoatTextureHasSwappedViews_tmp = is_function_constant_defined(clearcoatTextureHasSwappedViews) ? clearcoatTextureHasSwappedViews : false;
constant bool emissiveTextureHasSwappedViews [[function_constant(69)]];
constant bool emissiveTextureHasSwappedViews_tmp = is_function_constant_defined(emissiveTextureHasSwappedViews) ? emissiveTextureHasSwappedViews : false;
constant bool intensityTextureHasSwappedViews [[function_constant(70)]];
constant bool intensityTextureHasSwappedViews_tmp = is_function_constant_defined(intensityTextureHasSwappedViews) ? intensityTextureHasSwappedViews : false;
constant bool metallicRoughnessTextureHasSwappedViews [[function_constant(71)]];
constant bool metallicRoughnessTextureHasSwappedViews_tmp = is_function_constant_defined(metallicRoughnessTextureHasSwappedViews) ? metallicRoughnessTextureHasSwappedViews : false;
constant bool normalTextureHasSwappedViews [[function_constant(72)]];
constant bool normalTextureHasSwappedViews_tmp = is_function_constant_defined(normalTextureHasSwappedViews) ? normalTextureHasSwappedViews : false;
constant bool sc_BlendMode_Custom [[function_constant(73)]];
constant bool sc_BlendMode_Custom_tmp = is_function_constant_defined(sc_BlendMode_Custom) ? sc_BlendMode_Custom : false;
constant bool sc_DepthOnly [[function_constant(74)]];
constant bool sc_DepthOnly_tmp = is_function_constant_defined(sc_DepthOnly) ? sc_DepthOnly : false;
constant bool sc_EnvmapDiffuseHasSwappedViews [[function_constant(75)]];
constant bool sc_EnvmapDiffuseHasSwappedViews_tmp = is_function_constant_defined(sc_EnvmapDiffuseHasSwappedViews) ? sc_EnvmapDiffuseHasSwappedViews : false;
constant bool sc_EnvmapSpecularHasSwappedViews [[function_constant(76)]];
constant bool sc_EnvmapSpecularHasSwappedViews_tmp = is_function_constant_defined(sc_EnvmapSpecularHasSwappedViews) ? sc_EnvmapSpecularHasSwappedViews : false;
constant bool sc_FramebufferFetch [[function_constant(77)]];
constant bool sc_FramebufferFetch_tmp = is_function_constant_defined(sc_FramebufferFetch) ? sc_FramebufferFetch : false;
constant bool sc_HasDiffuseEnvmap [[function_constant(78)]];
constant bool sc_HasDiffuseEnvmap_tmp = is_function_constant_defined(sc_HasDiffuseEnvmap) ? sc_HasDiffuseEnvmap : false;
constant bool sc_HasSpecularCubemap [[function_constant(79)]];
constant bool sc_HasSpecularCubemap_tmp = is_function_constant_defined(sc_HasSpecularCubemap) ? sc_HasSpecularCubemap : false;
constant bool sc_LightEstimation [[function_constant(80)]];
constant bool sc_LightEstimation_tmp = is_function_constant_defined(sc_LightEstimation) ? sc_LightEstimation : false;
constant bool sc_MotionVectorsPass [[function_constant(81)]];
constant bool sc_MotionVectorsPass_tmp = is_function_constant_defined(sc_MotionVectorsPass) ? sc_MotionVectorsPass : false;
constant bool sc_OITCompositingPass [[function_constant(82)]];
constant bool sc_OITCompositingPass_tmp = is_function_constant_defined(sc_OITCompositingPass) ? sc_OITCompositingPass : false;
constant bool sc_OITDepthBoundsPass [[function_constant(83)]];
constant bool sc_OITDepthBoundsPass_tmp = is_function_constant_defined(sc_OITDepthBoundsPass) ? sc_OITDepthBoundsPass : false;
constant bool sc_OITDepthGatherPass [[function_constant(84)]];
constant bool sc_OITDepthGatherPass_tmp = is_function_constant_defined(sc_OITDepthGatherPass) ? sc_OITDepthGatherPass : false;
constant bool sc_OutputBounds [[function_constant(85)]];
constant bool sc_OutputBounds_tmp = is_function_constant_defined(sc_OutputBounds) ? sc_OutputBounds : false;
constant bool sc_ProjectiveShadowsCaster [[function_constant(86)]];
constant bool sc_ProjectiveShadowsCaster_tmp = is_function_constant_defined(sc_ProjectiveShadowsCaster) ? sc_ProjectiveShadowsCaster : false;
constant bool sc_ProjectiveShadowsReceiver [[function_constant(87)]];
constant bool sc_ProjectiveShadowsReceiver_tmp = is_function_constant_defined(sc_ProjectiveShadowsReceiver) ? sc_ProjectiveShadowsReceiver : false;
constant bool sc_RenderAlphaToColor [[function_constant(88)]];
constant bool sc_RenderAlphaToColor_tmp = is_function_constant_defined(sc_RenderAlphaToColor) ? sc_RenderAlphaToColor : false;
constant bool sc_SSAOEnabled [[function_constant(89)]];
constant bool sc_SSAOEnabled_tmp = is_function_constant_defined(sc_SSAOEnabled) ? sc_SSAOEnabled : false;
constant bool sc_ScreenTextureHasSwappedViews [[function_constant(90)]];
constant bool sc_ScreenTextureHasSwappedViews_tmp = is_function_constant_defined(sc_ScreenTextureHasSwappedViews) ? sc_ScreenTextureHasSwappedViews : false;
constant bool sc_ShadowMapHardwarePCF [[function_constant(91)]];
constant bool sc_ShadowMapHardwarePCF_tmp = is_function_constant_defined(sc_ShadowMapHardwarePCF) ? sc_ShadowMapHardwarePCF : false;
constant bool sc_ShadowMapIsRandomSampling [[function_constant(92)]];
constant bool sc_ShadowMapIsRandomSampling_tmp = is_function_constant_defined(sc_ShadowMapIsRandomSampling) ? sc_ShadowMapIsRandomSampling : false;
constant bool sc_ShadowMapIsSoftShadow [[function_constant(93)]];
constant bool sc_ShadowMapIsSoftShadow_tmp = is_function_constant_defined(sc_ShadowMapIsSoftShadow) ? sc_ShadowMapIsSoftShadow : false;
constant bool sc_ShadowMapReceiver [[function_constant(94)]];
constant bool sc_ShadowMapReceiver_tmp = is_function_constant_defined(sc_ShadowMapReceiver) ? sc_ShadowMapReceiver : false;
constant bool sc_TAAEnabled [[function_constant(95)]];
constant bool sc_TAAEnabled_tmp = is_function_constant_defined(sc_TAAEnabled) ? sc_TAAEnabled : false;
constant bool sc_VertexBlendingUseNormals [[function_constant(96)]];
constant bool sc_VertexBlendingUseNormals_tmp = is_function_constant_defined(sc_VertexBlendingUseNormals) ? sc_VertexBlendingUseNormals : false;
constant bool sc_VertexBlending [[function_constant(97)]];
constant bool sc_VertexBlending_tmp = is_function_constant_defined(sc_VertexBlending) ? sc_VertexBlending : false;
constant bool sc_Voxelization [[function_constant(98)]];
constant bool sc_Voxelization_tmp = is_function_constant_defined(sc_Voxelization) ? sc_Voxelization : false;
constant bool screenTextureHasSwappedViews [[function_constant(99)]];
constant bool screenTextureHasSwappedViews_tmp = is_function_constant_defined(screenTextureHasSwappedViews) ? screenTextureHasSwappedViews : false;
constant bool sheenColorTextureHasSwappedViews [[function_constant(100)]];
constant bool sheenColorTextureHasSwappedViews_tmp = is_function_constant_defined(sheenColorTextureHasSwappedViews) ? sheenColorTextureHasSwappedViews : false;
constant bool sheenRoughnessTextureHasSwappedViews [[function_constant(101)]];
constant bool sheenRoughnessTextureHasSwappedViews_tmp = is_function_constant_defined(sheenRoughnessTextureHasSwappedViews) ? sheenRoughnessTextureHasSwappedViews : false;
constant bool transmissionTextureHasSwappedViews [[function_constant(102)]];
constant bool transmissionTextureHasSwappedViews_tmp = is_function_constant_defined(transmissionTextureHasSwappedViews) ? transmissionTextureHasSwappedViews : false;
constant int NODE_10_DROPLIST_ITEM [[function_constant(103)]];
constant int NODE_10_DROPLIST_ITEM_tmp = is_function_constant_defined(NODE_10_DROPLIST_ITEM) ? NODE_10_DROPLIST_ITEM : 0;
constant int NODE_11_DROPLIST_ITEM [[function_constant(104)]];
constant int NODE_11_DROPLIST_ITEM_tmp = is_function_constant_defined(NODE_11_DROPLIST_ITEM) ? NODE_11_DROPLIST_ITEM : 0;
constant int NODE_7_DROPLIST_ITEM [[function_constant(105)]];
constant int NODE_7_DROPLIST_ITEM_tmp = is_function_constant_defined(NODE_7_DROPLIST_ITEM) ? NODE_7_DROPLIST_ITEM : 0;
constant int NODE_8_DROPLIST_ITEM [[function_constant(106)]];
constant int NODE_8_DROPLIST_ITEM_tmp = is_function_constant_defined(NODE_8_DROPLIST_ITEM) ? NODE_8_DROPLIST_ITEM : 0;
constant int SC_DEVICE_CLASS [[function_constant(107)]];
constant int SC_DEVICE_CLASS_tmp = is_function_constant_defined(SC_DEVICE_CLASS) ? SC_DEVICE_CLASS : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_baseColorTexture [[function_constant(108)]];
constant int SC_SOFTWARE_WRAP_MODE_U_baseColorTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture) ? SC_SOFTWARE_WRAP_MODE_U_baseColorTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture [[function_constant(109)]];
constant int SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture) ? SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture [[function_constant(110)]];
constant int SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture) ? SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture [[function_constant(111)]];
constant int SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture) ? SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_emissiveTexture [[function_constant(112)]];
constant int SC_SOFTWARE_WRAP_MODE_U_emissiveTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture) ? SC_SOFTWARE_WRAP_MODE_U_emissiveTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_intensityTexture [[function_constant(113)]];
constant int SC_SOFTWARE_WRAP_MODE_U_intensityTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_intensityTexture) ? SC_SOFTWARE_WRAP_MODE_U_intensityTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture [[function_constant(114)]];
constant int SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture) ? SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_normalTexture [[function_constant(115)]];
constant int SC_SOFTWARE_WRAP_MODE_U_normalTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_normalTexture) ? SC_SOFTWARE_WRAP_MODE_U_normalTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_screenTexture [[function_constant(116)]];
constant int SC_SOFTWARE_WRAP_MODE_U_screenTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_screenTexture) ? SC_SOFTWARE_WRAP_MODE_U_screenTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture [[function_constant(117)]];
constant int SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture) ? SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture [[function_constant(118)]];
constant int SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture) ? SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_U_transmissionTexture [[function_constant(119)]];
constant int SC_SOFTWARE_WRAP_MODE_U_transmissionTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture) ? SC_SOFTWARE_WRAP_MODE_U_transmissionTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_baseColorTexture [[function_constant(120)]];
constant int SC_SOFTWARE_WRAP_MODE_V_baseColorTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_baseColorTexture) ? SC_SOFTWARE_WRAP_MODE_V_baseColorTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture [[function_constant(121)]];
constant int SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture) ? SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture [[function_constant(122)]];
constant int SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture) ? SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture [[function_constant(123)]];
constant int SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture) ? SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_emissiveTexture [[function_constant(124)]];
constant int SC_SOFTWARE_WRAP_MODE_V_emissiveTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_emissiveTexture) ? SC_SOFTWARE_WRAP_MODE_V_emissiveTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_intensityTexture [[function_constant(125)]];
constant int SC_SOFTWARE_WRAP_MODE_V_intensityTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_intensityTexture) ? SC_SOFTWARE_WRAP_MODE_V_intensityTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture [[function_constant(126)]];
constant int SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture) ? SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_normalTexture [[function_constant(127)]];
constant int SC_SOFTWARE_WRAP_MODE_V_normalTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_normalTexture) ? SC_SOFTWARE_WRAP_MODE_V_normalTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_screenTexture [[function_constant(128)]];
constant int SC_SOFTWARE_WRAP_MODE_V_screenTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_screenTexture) ? SC_SOFTWARE_WRAP_MODE_V_screenTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture [[function_constant(129)]];
constant int SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture) ? SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture [[function_constant(130)]];
constant int SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture) ? SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture : -1;
constant int SC_SOFTWARE_WRAP_MODE_V_transmissionTexture [[function_constant(131)]];
constant int SC_SOFTWARE_WRAP_MODE_V_transmissionTexture_tmp = is_function_constant_defined(SC_SOFTWARE_WRAP_MODE_V_transmissionTexture) ? SC_SOFTWARE_WRAP_MODE_V_transmissionTexture : -1;
constant int Tweak_N30 [[function_constant(132)]];
constant int Tweak_N30_tmp = is_function_constant_defined(Tweak_N30) ? Tweak_N30 : 0;
constant int Tweak_N32 [[function_constant(133)]];
constant int Tweak_N32_tmp = is_function_constant_defined(Tweak_N32) ? Tweak_N32 : 0;
constant int Tweak_N37 [[function_constant(134)]];
constant int Tweak_N37_tmp = is_function_constant_defined(Tweak_N37) ? Tweak_N37 : 0;
constant int Tweak_N44 [[function_constant(135)]];
constant int Tweak_N44_tmp = is_function_constant_defined(Tweak_N44) ? Tweak_N44 : 0;
constant int Tweak_N47 [[function_constant(136)]];
constant int Tweak_N47_tmp = is_function_constant_defined(Tweak_N47) ? Tweak_N47 : 0;
constant int Tweak_N60 [[function_constant(137)]];
constant int Tweak_N60_tmp = is_function_constant_defined(Tweak_N60) ? Tweak_N60 : 0;
constant int baseColorTextureLayout [[function_constant(138)]];
constant int baseColorTextureLayout_tmp = is_function_constant_defined(baseColorTextureLayout) ? baseColorTextureLayout : 0;
constant int clearcoatNormalTextureLayout [[function_constant(139)]];
constant int clearcoatNormalTextureLayout_tmp = is_function_constant_defined(clearcoatNormalTextureLayout) ? clearcoatNormalTextureLayout : 0;
constant int clearcoatRoughnessTextureLayout [[function_constant(140)]];
constant int clearcoatRoughnessTextureLayout_tmp = is_function_constant_defined(clearcoatRoughnessTextureLayout) ? clearcoatRoughnessTextureLayout : 0;
constant int clearcoatTextureLayout [[function_constant(141)]];
constant int clearcoatTextureLayout_tmp = is_function_constant_defined(clearcoatTextureLayout) ? clearcoatTextureLayout : 0;
constant int emissiveTextureLayout [[function_constant(142)]];
constant int emissiveTextureLayout_tmp = is_function_constant_defined(emissiveTextureLayout) ? emissiveTextureLayout : 0;
constant int intensityTextureLayout [[function_constant(143)]];
constant int intensityTextureLayout_tmp = is_function_constant_defined(intensityTextureLayout) ? intensityTextureLayout : 0;
constant int metallicRoughnessTextureLayout [[function_constant(144)]];
constant int metallicRoughnessTextureLayout_tmp = is_function_constant_defined(metallicRoughnessTextureLayout) ? metallicRoughnessTextureLayout : 0;
constant int normalTextureLayout [[function_constant(145)]];
constant int normalTextureLayout_tmp = is_function_constant_defined(normalTextureLayout) ? normalTextureLayout : 0;
constant int sc_AmbientLightMode0 [[function_constant(146)]];
constant int sc_AmbientLightMode0_tmp = is_function_constant_defined(sc_AmbientLightMode0) ? sc_AmbientLightMode0 : 0;
constant int sc_AmbientLightMode1 [[function_constant(147)]];
constant int sc_AmbientLightMode1_tmp = is_function_constant_defined(sc_AmbientLightMode1) ? sc_AmbientLightMode1 : 0;
constant int sc_AmbientLightMode2 [[function_constant(148)]];
constant int sc_AmbientLightMode2_tmp = is_function_constant_defined(sc_AmbientLightMode2) ? sc_AmbientLightMode2 : 0;
constant int sc_AmbientLightMode_Constant [[function_constant(149)]];
constant int sc_AmbientLightMode_Constant_tmp = is_function_constant_defined(sc_AmbientLightMode_Constant) ? sc_AmbientLightMode_Constant : 0;
constant int sc_AmbientLightMode_EnvironmentMap [[function_constant(150)]];
constant int sc_AmbientLightMode_EnvironmentMap_tmp = is_function_constant_defined(sc_AmbientLightMode_EnvironmentMap) ? sc_AmbientLightMode_EnvironmentMap : 0;
constant int sc_AmbientLightMode_FromCamera [[function_constant(151)]];
constant int sc_AmbientLightMode_FromCamera_tmp = is_function_constant_defined(sc_AmbientLightMode_FromCamera) ? sc_AmbientLightMode_FromCamera : 0;
constant int sc_AmbientLightMode_SphericalHarmonics [[function_constant(152)]];
constant int sc_AmbientLightMode_SphericalHarmonics_tmp = is_function_constant_defined(sc_AmbientLightMode_SphericalHarmonics) ? sc_AmbientLightMode_SphericalHarmonics : 0;
constant int sc_AmbientLightsCount [[function_constant(153)]];
constant int sc_AmbientLightsCount_tmp = is_function_constant_defined(sc_AmbientLightsCount) ? sc_AmbientLightsCount : 0;
constant int sc_BlendMode [[function_constant(154)]];
constant int sc_BlendMode_tmp = is_function_constant_defined(sc_BlendMode) ? sc_BlendMode : 0;
constant int sc_DepthBufferMode [[function_constant(155)]];
constant int sc_DepthBufferMode_tmp = is_function_constant_defined(sc_DepthBufferMode) ? sc_DepthBufferMode : 0;
constant int sc_DirectionalLightsCount [[function_constant(156)]];
constant int sc_DirectionalLightsCount_tmp = is_function_constant_defined(sc_DirectionalLightsCount) ? sc_DirectionalLightsCount : 0;
constant int sc_EnvLightMode [[function_constant(157)]];
constant int sc_EnvLightMode_tmp = is_function_constant_defined(sc_EnvLightMode) ? sc_EnvLightMode : 0;
constant int sc_EnvmapDiffuseLayout [[function_constant(158)]];
constant int sc_EnvmapDiffuseLayout_tmp = is_function_constant_defined(sc_EnvmapDiffuseLayout) ? sc_EnvmapDiffuseLayout : 0;
constant int sc_EnvmapSpecularLayout [[function_constant(159)]];
constant int sc_EnvmapSpecularLayout_tmp = is_function_constant_defined(sc_EnvmapSpecularLayout) ? sc_EnvmapSpecularLayout : 0;
constant int sc_LightEstimationSGCount [[function_constant(160)]];
constant int sc_LightEstimationSGCount_tmp = is_function_constant_defined(sc_LightEstimationSGCount) ? sc_LightEstimationSGCount : 0;
constant int sc_PointLightsCount [[function_constant(161)]];
constant int sc_PointLightsCount_tmp = is_function_constant_defined(sc_PointLightsCount) ? sc_PointLightsCount : 0;
constant int sc_RenderingSpace [[function_constant(162)]];
constant int sc_RenderingSpace_tmp = is_function_constant_defined(sc_RenderingSpace) ? sc_RenderingSpace : -1;
constant int sc_ScreenTextureLayout [[function_constant(163)]];
constant int sc_ScreenTextureLayout_tmp = is_function_constant_defined(sc_ScreenTextureLayout) ? sc_ScreenTextureLayout : 0;
constant int sc_ShaderCacheConstant [[function_constant(164)]];
constant int sc_ShaderCacheConstant_tmp = is_function_constant_defined(sc_ShaderCacheConstant) ? sc_ShaderCacheConstant : 0;
constant int sc_ShadowMapSampleCount [[function_constant(165)]];
constant int sc_ShadowMapSampleCount_tmp = is_function_constant_defined(sc_ShadowMapSampleCount) ? sc_ShadowMapSampleCount : 16;
constant int sc_SkinBonesCount [[function_constant(166)]];
constant int sc_SkinBonesCount_tmp = is_function_constant_defined(sc_SkinBonesCount) ? sc_SkinBonesCount : 0;
constant int sc_SoftwareBlendMode [[function_constant(167)]];
constant int sc_SoftwareBlendMode_tmp = is_function_constant_defined(sc_SoftwareBlendMode) ? sc_SoftwareBlendMode : 0;
constant int sc_StereoRenderingMode [[function_constant(168)]];
constant int sc_StereoRenderingMode_tmp = is_function_constant_defined(sc_StereoRenderingMode) ? sc_StereoRenderingMode : 0;
constant int sc_StereoRendering_IsClipDistanceEnabled [[function_constant(169)]];
constant int sc_StereoRendering_IsClipDistanceEnabled_tmp = is_function_constant_defined(sc_StereoRendering_IsClipDistanceEnabled) ? sc_StereoRendering_IsClipDistanceEnabled : 0;
constant int screenTextureLayout [[function_constant(170)]];
constant int screenTextureLayout_tmp = is_function_constant_defined(screenTextureLayout) ? screenTextureLayout : 0;
constant int sheenColorTextureLayout [[function_constant(171)]];
constant int sheenColorTextureLayout_tmp = is_function_constant_defined(sheenColorTextureLayout) ? sheenColorTextureLayout : 0;
constant int sheenRoughnessTextureLayout [[function_constant(172)]];
constant int sheenRoughnessTextureLayout_tmp = is_function_constant_defined(sheenRoughnessTextureLayout) ? sheenRoughnessTextureLayout : 0;
constant int transmissionTextureLayout [[function_constant(173)]];
constant int transmissionTextureLayout_tmp = is_function_constant_defined(transmissionTextureLayout) ? transmissionTextureLayout : 0;

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
float3 emissiveFactor;
float3x3 emissiveTextureTransform;
float4 emissiveTextureUvMinMax;
float4 emissiveTextureBorderColor;
float normalTextureScale;
float3x3 normalTextureTransform;
float4 normalTextureUvMinMax;
float4 normalTextureBorderColor;
float metallicFactor;
float roughnessFactor;
float occlusionTextureStrength;
float3x3 metallicRoughnessTextureTransform;
float4 metallicRoughnessTextureUvMinMax;
float4 metallicRoughnessTextureBorderColor;
float transmissionFactor;
float3x3 transmissionTextureTransform;
float4 transmissionTextureUvMinMax;
float4 transmissionTextureBorderColor;
float3x3 screenTextureTransform;
float4 screenTextureUvMinMax;
float4 screenTextureBorderColor;
float3 sheenColorFactor;
float3x3 sheenColorTextureTransform;
float4 sheenColorTextureUvMinMax;
float4 sheenColorTextureBorderColor;
float sheenRoughnessFactor;
float3x3 sheenRoughnessTextureTransform;
float4 sheenRoughnessTextureUvMinMax;
float4 sheenRoughnessTextureBorderColor;
float clearcoatFactor;
float3x3 clearcoatTextureTransform;
float4 clearcoatTextureUvMinMax;
float4 clearcoatTextureBorderColor;
float clearcoatRoughnessFactor;
float3x3 clearcoatRoughnessTextureTransform;
float4 clearcoatRoughnessTextureUvMinMax;
float4 clearcoatRoughnessTextureBorderColor;
float3x3 clearcoatNormalTextureTransform;
float4 clearcoatNormalTextureUvMinMax;
float4 clearcoatNormalTextureBorderColor;
float3x3 baseColorTextureTransform;
float4 baseColorTextureUvMinMax;
float4 baseColorTextureBorderColor;
float4 baseColorFactor;
float2 baseColorTexture_offset;
float2 baseColorTexture_scale;
float baseColorTexture_rotation;
float2 emissiveTexture_offset;
float2 emissiveTexture_scale;
float emissiveTexture_rotation;
float2 normalTexture_offset;
float2 normalTexture_scale;
float normalTexture_rotation;
float2 metallicRoughnessTexture_offset;
float2 metallicRoughnessTexture_scale;
float metallicRoughnessTexture_rotation;
float2 transmissionTexture_offset;
float2 transmissionTexture_scale;
float transmissionTexture_rotation;
float2 sheenColorTexture_offset;
float2 sheenColorTexture_scale;
float sheenColorTexture_rotation;
float2 sheenRoughnessTexture_offset;
float2 sheenRoughnessTexture_scale;
float sheenRoughnessTexture_rotation;
float2 clearcoatTexture_offset;
float2 clearcoatTexture_scale;
float clearcoatTexture_rotation;
float2 clearcoatNormalTexture_offset;
float2 clearcoatNormalTexture_scale;
float clearcoatNormalTexture_rotation;
float2 clearcoatRoughnessTexture_offset;
float2 clearcoatRoughnessTexture_scale;
float clearcoatRoughnessTexture_rotation;
float Port_DebugSheenEnvLightMult_N003;
float Port_DebugSheenPunctualLightMult_N003;
float Port_Input2_N043;
float Port_Input2_N062;
float3 Port_SpecularAO_N036;
float3 Port_Albedo_N405;
float Port_Opacity_N405;
float3 Port_Emissive_N405;
float Port_Metallic_N405;
float3 Port_SpecularAO_N405;
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
texture2d<float> baseColorTexture [[id(1)]];
texture2d<float> clearcoatNormalTexture [[id(2)]];
texture2d<float> clearcoatRoughnessTexture [[id(3)]];
texture2d<float> clearcoatTexture [[id(4)]];
texture2d<float> emissiveTexture [[id(5)]];
texture2d<float> intensityTexture [[id(6)]];
texture2d<float> metallicRoughnessTexture [[id(7)]];
texture2d<float> normalTexture [[id(8)]];
texture2d<float> sc_EnvmapDiffuse [[id(9)]];
texture2d<float> sc_EnvmapSpecular [[id(10)]];
texture2d<float> sc_SSAOTexture [[id(19)]];
texture2d<float> sc_ScreenTexture [[id(20)]];
depth2d<float> sc_ShadowMapTexture [[id(22)]];
texture2d<float> sc_ShadowTexture [[id(23)]];
texturecube<float> sc_SpecularCubemap [[id(24)]];
texture2d<float> screenTexture [[id(26)]];
texture2d<float> sheenColorTexture [[id(27)]];
texture2d<float> sheenRoughnessTexture [[id(28)]];
texture2d<float> transmissionTexture [[id(29)]];
sampler baseColorTextureSmpSC [[id(30)]];
sampler clearcoatNormalTextureSmpSC [[id(31)]];
sampler clearcoatRoughnessTextureSmpSC [[id(32)]];
sampler clearcoatTextureSmpSC [[id(33)]];
sampler emissiveTextureSmpSC [[id(34)]];
sampler intensityTextureSmpSC [[id(35)]];
sampler metallicRoughnessTextureSmpSC [[id(36)]];
sampler normalTextureSmpSC [[id(37)]];
sampler sc_EnvmapDiffuseSmpSC [[id(38)]];
sampler sc_EnvmapSpecularSmpSC [[id(39)]];
sampler sc_SSAOTextureSmpSC [[id(41)]];
sampler sc_ScreenTextureSmpSC [[id(42)]];
sampler sc_ShadowMapTextureSmpSC [[id(44)]];
sampler sc_ShadowTextureSmpSC [[id(45)]];
sampler sc_SpecularCubemapSmpSC [[id(46)]];
sampler screenTextureSmpSC [[id(48)]];
sampler sheenColorTextureSmpSC [[id(49)]];
sampler sheenRoughnessTextureSmpSC [[id(50)]];
sampler transmissionTextureSmpSC [[id(51)]];
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
float3 SurfacePosition_WorldSpace;
float3 VertexNormal_WorldSpace;
float3 VertexTangent_WorldSpace;
float3 VertexBinormal_WorldSpace;
float2 Surface_UVCoord0;
float2 Surface_UVCoord1;
float2 gScreenCoord;
float4 VertexColor;
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
float3 emissiveFactor;
float3x3 emissiveTextureTransform;
float4 emissiveTextureUvMinMax;
float4 emissiveTextureBorderColor;
float normalTextureScale;
float3x3 normalTextureTransform;
float4 normalTextureUvMinMax;
float4 normalTextureBorderColor;
float metallicFactor;
float roughnessFactor;
float occlusionTextureStrength;
float3x3 metallicRoughnessTextureTransform;
float4 metallicRoughnessTextureUvMinMax;
float4 metallicRoughnessTextureBorderColor;
float transmissionFactor;
float3x3 transmissionTextureTransform;
float4 transmissionTextureUvMinMax;
float4 transmissionTextureBorderColor;
float3x3 screenTextureTransform;
float4 screenTextureUvMinMax;
float4 screenTextureBorderColor;
float3 sheenColorFactor;
float3x3 sheenColorTextureTransform;
float4 sheenColorTextureUvMinMax;
float4 sheenColorTextureBorderColor;
float sheenRoughnessFactor;
float3x3 sheenRoughnessTextureTransform;
float4 sheenRoughnessTextureUvMinMax;
float4 sheenRoughnessTextureBorderColor;
float clearcoatFactor;
float3x3 clearcoatTextureTransform;
float4 clearcoatTextureUvMinMax;
float4 clearcoatTextureBorderColor;
float clearcoatRoughnessFactor;
float3x3 clearcoatRoughnessTextureTransform;
float4 clearcoatRoughnessTextureUvMinMax;
float4 clearcoatRoughnessTextureBorderColor;
float3x3 clearcoatNormalTextureTransform;
float4 clearcoatNormalTextureUvMinMax;
float4 clearcoatNormalTextureBorderColor;
float3x3 baseColorTextureTransform;
float4 baseColorTextureUvMinMax;
float4 baseColorTextureBorderColor;
float4 baseColorFactor;
float2 baseColorTexture_offset;
float2 baseColorTexture_scale;
float baseColorTexture_rotation;
float2 emissiveTexture_offset;
float2 emissiveTexture_scale;
float emissiveTexture_rotation;
float2 normalTexture_offset;
float2 normalTexture_scale;
float normalTexture_rotation;
float2 metallicRoughnessTexture_offset;
float2 metallicRoughnessTexture_scale;
float metallicRoughnessTexture_rotation;
float2 transmissionTexture_offset;
float2 transmissionTexture_scale;
float transmissionTexture_rotation;
float2 sheenColorTexture_offset;
float2 sheenColorTexture_scale;
float sheenColorTexture_rotation;
float2 sheenRoughnessTexture_offset;
float2 sheenRoughnessTexture_scale;
float sheenRoughnessTexture_rotation;
float2 clearcoatTexture_offset;
float2 clearcoatTexture_scale;
float clearcoatTexture_rotation;
float2 clearcoatNormalTexture_offset;
float2 clearcoatNormalTexture_scale;
float clearcoatNormalTexture_rotation;
float2 clearcoatRoughnessTexture_offset;
float2 clearcoatRoughnessTexture_scale;
float clearcoatRoughnessTexture_rotation;
float Port_DebugSheenEnvLightMult_N003;
float Port_DebugSheenPunctualLightMult_N003;
float Port_Input2_N043;
float Port_Input2_N062;
float3 Port_SpecularAO_N036;
float3 Port_Albedo_N405;
float Port_Opacity_N405;
float3 Port_Emissive_N405;
float Port_Metallic_N405;
float3 Port_SpecularAO_N405;
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
texture2d<float> baseColorTexture [[id(1)]];
texture2d<float> clearcoatNormalTexture [[id(2)]];
texture2d<float> clearcoatRoughnessTexture [[id(3)]];
texture2d<float> clearcoatTexture [[id(4)]];
texture2d<float> emissiveTexture [[id(5)]];
texture2d<float> intensityTexture [[id(6)]];
texture2d<float> metallicRoughnessTexture [[id(7)]];
texture2d<float> normalTexture [[id(8)]];
texture2d<float> sc_EnvmapDiffuse [[id(9)]];
texture2d<float> sc_EnvmapSpecular [[id(10)]];
texture2d<float> sc_SSAOTexture [[id(19)]];
texture2d<float> sc_ScreenTexture [[id(20)]];
depth2d<float> sc_ShadowMapTexture [[id(22)]];
texture2d<float> sc_ShadowTexture [[id(23)]];
texturecube<float> sc_SpecularCubemap [[id(24)]];
texture2d<float> screenTexture [[id(26)]];
texture2d<float> sheenColorTexture [[id(27)]];
texture2d<float> sheenRoughnessTexture [[id(28)]];
texture2d<float> transmissionTexture [[id(29)]];
sampler baseColorTextureSmpSC [[id(30)]];
sampler clearcoatNormalTextureSmpSC [[id(31)]];
sampler clearcoatRoughnessTextureSmpSC [[id(32)]];
sampler clearcoatTextureSmpSC [[id(33)]];
sampler emissiveTextureSmpSC [[id(34)]];
sampler intensityTextureSmpSC [[id(35)]];
sampler metallicRoughnessTextureSmpSC [[id(36)]];
sampler normalTextureSmpSC [[id(37)]];
sampler sc_EnvmapDiffuseSmpSC [[id(38)]];
sampler sc_EnvmapSpecularSmpSC [[id(39)]];
sampler sc_SSAOTextureSmpSC [[id(41)]];
sampler sc_ScreenTextureSmpSC [[id(42)]];
sampler sc_ShadowMapTextureSmpSC [[id(44)]];
sampler sc_ShadowTextureSmpSC [[id(45)]];
sampler sc_SpecularCubemapSmpSC [[id(46)]];
sampler screenTextureSmpSC [[id(48)]];
sampler sheenColorTextureSmpSC [[id(49)]];
sampler sheenRoughnessTextureSmpSC [[id(50)]];
sampler transmissionTextureSmpSC [[id(51)]];
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
// Implementation of the GLSL radians() function
template<typename T>
T radians(T d)
{
return d*T(0.01745329251);
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
float4 N31_PbrIn=float4(0.0);
bool N31_EnableTransmission=false;
float N31_Opacity=0.0;
float3 N31_Background=float3(0.0);
bool N31_EnableSheen=false;
float4 N31_SheenColor=float4(0.0);
bool N31_EnableClearcoat=false;
float N31_ClearcoatBase=0.0;
float4 N31_ClearcoatColor=float4(0.0);
float4 N31_Result=float4(0.0);
float3 N3_EmissiveColor=float3(0.0);
bool N3_EnableEmissiveTexture=false;
int N3_EmissiveTextureCoord=0;
bool N3_EnableNormalTexture=false;
float N3_NormalScale=0.0;
int N3_NormalTextureCoord=0;
float N3_MetallicValue=0.0;
float N3_RoughnessValue=0.0;
bool N3_MetallicRoughnessTexSwizzleRB=false;
bool N3_EnableMetallicRoughnessTexture=false;
float N3_OcclusionStrength=0.0;
int N3_MaterialParamsTextureCoord=0;
bool N3_TransmissionEnable=false;
float N3_TransmissionFactor=0.0;
bool N3_EnableTransmissionTexture=false;
int N3_TransmissionTextureCoord=0;
bool N3_SheenEnable=false;
float3 N3_SheenColorFactor=float3(0.0);
bool N3_EnableSheenTexture=false;
int N3_SheenColorTextureCoord=0;
float N3_SheenRoughnessFactor=0.0;
bool N3_EnableSheenRoughnessTexture=false;
int N3_SheenRoughnessTextureCoord=0;
bool N3_ClearcoatEnable=false;
float N3_ClearcoatFactor=0.0;
bool N3_EnableClearcoatTexture=false;
int N3_ClearcoatTextureCoord=0;
float N3_ClearcoatRoughnessFactor=0.0;
bool N3_EnableClearCoatRoughnessTexture=false;
int N3_ClearcoatRoughnessTextureCoord=0;
bool N3_EnableClearCoatNormalTexture=false;
int N3_ClearcoatNormalMapCoord=0;
float3 N3_BaseColorIn=float3(0.0);
float N3_OpacityIn=0.0;
bool N3_EnableTextureTransform=false;
bool N3_EmissiveTextureTransform=false;
float2 N3_EmissiveTextureOffset=float2(0.0);
float2 N3_EmissiveTextureScale=float2(0.0);
float N3_EmissiveTextureRotation=0.0;
bool N3_NormalTextureTransform=false;
float2 N3_NormalTextureOffset=float2(0.0);
float2 N3_NormalTextureScale=float2(0.0);
float N3_NormalTextureRotation=0.0;
bool N3_MaterialParamsTextureTransform=false;
float2 N3_MaterialParamsTextureOffset=float2(0.0);
float2 N3_MaterialParamsTextureScale=float2(0.0);
float N3_MaterialParamsTextureRotation=0.0;
bool N3_TransmissionTextureTransform=false;
float2 N3_TransmissionTextureOffset=float2(0.0);
float2 N3_TransmissionTextureScale=float2(0.0);
float N3_TransmissionTextureRotation=0.0;
bool N3_SheenColorTextureTransform=false;
float2 N3_SheenColorTextureOffset=float2(0.0);
float2 N3_SheenColorTextureScale=float2(0.0);
float N3_SheenColorTextureRotation=0.0;
bool N3_SheenRoughnessTextureTransform=false;
float2 N3_SheenRoughnessTextureOffset=float2(0.0);
float2 N3_SheenRoughnessTextureScale=float2(0.0);
float N3_SheenRoughnessTextureRotation=0.0;
bool N3_ClearcoatTextureTransform=false;
float2 N3_ClearcoatTextureOffset=float2(0.0);
float2 N3_ClearcoatTextureScale=float2(0.0);
float N3_ClearcoatTextureRotation=0.0;
bool N3_ClearcoatNormalTextureTransform=false;
float2 N3_ClearcoatNormalTextureOffset=float2(0.0);
float2 N3_ClearcoatNormalTextureScale=float2(0.0);
float N3_ClearcoatNormalTextureRotation=0.0;
bool N3_ClearcoatRoughnessTextureTransform=false;
float2 N3_ClearcoatRoughnessTextureOffset=float2(0.0);
float2 N3_ClearcoatRoughnessTextureScale=float2(0.0);
float N3_ClearcoatRoughnessTextureRotation=0.0;
float3 N3_BaseColor=float3(0.0);
float N3_Opacity=0.0;
float3 N3_Normal=float3(0.0);
float3 N3_Emissive=float3(0.0);
float N3_Metallic=0.0;
float N3_Roughness=0.0;
float4 N3_Occlusion=float4(0.0);
float3 N3_Background=float3(0.0);
float4 N3_SheenOut=float4(0.0);
float N3_ClearcoatBase=0.0;
float3 N3_ClearcoatNormal=float3(0.0);
float N3_ClearcoatRoughness=0.0;
bool N35_EnableVertexColor=false;
bool N35_EnableBaseTexture=false;
int N35_BaseColorTextureCoord=0;
float4 N35_BaseColorFactor=float4(0.0);
bool N35_EnableTextureTransform=false;
bool N35_BaseTextureTransform=false;
float2 N35_BaseTextureOffset=float2(0.0);
float2 N35_BaseTextureScale=float2(0.0);
float N35_BaseTextureRotation=0.0;
float3 N35_BaseColor=float3(0.0);
float N35_Opacity=0.0;
float4 N35_UnlitColor=float4(0.0);
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
Globals.SurfacePosition_WorldSpace=in.varPosAndMotion.xyz;
Globals.VertexNormal_WorldSpace=normalize(in.varNormalAndMotion.xyz);
Globals.VertexTangent_WorldSpace=normalize(in.varTangent.xyz);
Globals.VertexBinormal_WorldSpace=cross(Globals.VertexNormal_WorldSpace,Globals.VertexTangent_WorldSpace)*in.varTangent.w;
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
Globals.VertexColor=in.varColor;
float4 Output_N17=float4(0.0);
float4 param=float4(1.0);
float4 param_1=float4(0.0);
ssGlobals param_3=Globals;
ssGlobals tempGlobals;
float4 param_2;
if ((int(ENABLE_GLTF_LIGHTING_tmp)!=0))
{
float3 l9_14=float3(0.0);
float3 l9_15=(*sc_set0.UserUniforms).emissiveFactor;
l9_14=l9_15;
float l9_16=0.0;
float l9_17=1.0;
float l9_18=(*sc_set0.UserUniforms).Port_Input2_N043;
float l9_19;
if ((int(ENABLE_NORMALMAP_tmp)!=0))
{
float l9_20=0.0;
float l9_21=(*sc_set0.UserUniforms).normalTextureScale;
l9_20=l9_21;
l9_17=l9_20;
l9_19=l9_17;
}
else
{
l9_19=l9_18;
}
l9_16=l9_19;
float l9_22=0.0;
float l9_23=(*sc_set0.UserUniforms).metallicFactor;
l9_22=l9_23;
float l9_24=0.0;
float l9_25=(*sc_set0.UserUniforms).roughnessFactor;
l9_24=l9_25;
float l9_26=0.0;
float l9_27=1.0;
float l9_28=(*sc_set0.UserUniforms).Port_Input2_N062;
float l9_29;
if ((int(ENABLE_METALLIC_ROUGHNESS_TEX_tmp)!=0))
{
float l9_30=0.0;
float l9_31=(*sc_set0.UserUniforms).occlusionTextureStrength;
l9_30=l9_31;
l9_27=l9_30;
l9_29=l9_27;
}
else
{
l9_29=l9_28;
}
l9_26=l9_29;
float l9_32=0.0;
float l9_33=(*sc_set0.UserUniforms).transmissionFactor;
l9_32=l9_33;
float3 l9_34=float3(0.0);
float3 l9_35=(*sc_set0.UserUniforms).sheenColorFactor;
l9_34=l9_35;
float l9_36=0.0;
float l9_37=(*sc_set0.UserUniforms).sheenRoughnessFactor;
l9_36=l9_37;
float l9_38=0.0;
float l9_39=(*sc_set0.UserUniforms).clearcoatFactor;
l9_38=l9_39;
float l9_40=0.0;
float l9_41=(*sc_set0.UserUniforms).clearcoatRoughnessFactor;
l9_40=l9_41;
float4 l9_42=float4(0.0);
float4 l9_43=(*sc_set0.UserUniforms).baseColorFactor;
l9_42=l9_43;
float2 l9_44=float2(0.0);
float2 l9_45=(*sc_set0.UserUniforms).baseColorTexture_offset;
l9_44=l9_45;
float2 l9_46=float2(0.0);
float2 l9_47=(*sc_set0.UserUniforms).baseColorTexture_scale;
l9_46=l9_47;
float l9_48=0.0;
float l9_49=(*sc_set0.UserUniforms).baseColorTexture_rotation;
l9_48=l9_49;
float3 l9_50=float3(0.0);
float l9_51=0.0;
float4 l9_52=l9_42;
float2 l9_53=l9_44;
float2 l9_54=l9_46;
float l9_55=l9_48;
ssGlobals l9_56=param_3;
tempGlobals=l9_56;
float3 l9_57=float3(0.0);
float l9_58=0.0;
N35_EnableVertexColor=(int(ENABLE_VERTEX_COLOR_BASE_tmp)!=0);
N35_EnableBaseTexture=(int(ENABLE_BASE_TEX_tmp)!=0);
N35_BaseColorTextureCoord=NODE_7_DROPLIST_ITEM_tmp;
N35_BaseColorFactor=l9_52;
N35_EnableTextureTransform=(int(ENABLE_TEXTURE_TRANSFORM_tmp)!=0);
N35_BaseTextureTransform=(int(ENABLE_BASE_TEXTURE_TRANSFORM_tmp)!=0);
N35_BaseTextureOffset=l9_53;
N35_BaseTextureScale=l9_54;
N35_BaseTextureRotation=l9_55;
float4 l9_59=N35_BaseColorFactor;
if (N35_EnableBaseTexture)
{
int l9_60=N35_BaseColorTextureCoord;
float2 l9_61=tempGlobals.Surface_UVCoord0;
float2 l9_62=l9_61;
if (l9_60==0)
{
float2 l9_63=tempGlobals.Surface_UVCoord0;
l9_62=l9_63;
}
if (l9_60==1)
{
float2 l9_64=tempGlobals.Surface_UVCoord1;
l9_62=l9_64;
}
float2 l9_65=l9_62;
float2 l9_66=l9_65;
if (N35_EnableTextureTransform&&N35_BaseTextureTransform)
{
float2 l9_67=l9_66;
float2 l9_68=N35_BaseTextureOffset;
float2 l9_69=N35_BaseTextureScale;
float l9_70=N35_BaseTextureRotation;
float3x3 l9_71=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_68.x,l9_68.y,1.0));
float3x3 l9_72=float3x3(float3(cos(l9_70),sin(l9_70),0.0),float3(-sin(l9_70),cos(l9_70),0.0),float3(0.0,0.0,1.0));
float3x3 l9_73=float3x3(float3(l9_69.x,0.0,0.0),float3(0.0,l9_69.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_74=(l9_71*l9_72)*l9_73;
float2 l9_75=(l9_74*float3(l9_67,1.0)).xy;
l9_66=l9_75;
}
float2 l9_76=l9_66;
float4 l9_77=float4(0.0);
int l9_78;
if ((int(baseColorTextureHasSwappedViews_tmp)!=0))
{
int l9_79=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_79=0;
}
else
{
l9_79=in.varStereoViewID;
}
int l9_80=l9_79;
l9_78=1-l9_80;
}
else
{
int l9_81=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_81=0;
}
else
{
l9_81=in.varStereoViewID;
}
int l9_82=l9_81;
l9_78=l9_82;
}
int l9_83=l9_78;
int l9_84=baseColorTextureLayout_tmp;
int l9_85=l9_83;
float2 l9_86=l9_76;
bool l9_87=(int(SC_USE_UV_TRANSFORM_baseColorTexture_tmp)!=0);
float3x3 l9_88=(*sc_set0.UserUniforms).baseColorTextureTransform;
int2 l9_89=int2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture_tmp);
bool l9_90=(int(SC_USE_UV_MIN_MAX_baseColorTexture_tmp)!=0);
float4 l9_91=(*sc_set0.UserUniforms).baseColorTextureUvMinMax;
bool l9_92=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture_tmp)!=0);
float4 l9_93=(*sc_set0.UserUniforms).baseColorTextureBorderColor;
float l9_94=0.0;
bool l9_95=l9_92&&(!l9_90);
float l9_96=1.0;
float l9_97=l9_86.x;
int l9_98=l9_89.x;
if (l9_98==1)
{
l9_97=fract(l9_97);
}
else
{
if (l9_98==2)
{
float l9_99=fract(l9_97);
float l9_100=l9_97-l9_99;
float l9_101=step(0.25,fract(l9_100*0.5));
l9_97=mix(l9_99,1.0-l9_99,fast::clamp(l9_101,0.0,1.0));
}
}
l9_86.x=l9_97;
float l9_102=l9_86.y;
int l9_103=l9_89.y;
if (l9_103==1)
{
l9_102=fract(l9_102);
}
else
{
if (l9_103==2)
{
float l9_104=fract(l9_102);
float l9_105=l9_102-l9_104;
float l9_106=step(0.25,fract(l9_105*0.5));
l9_102=mix(l9_104,1.0-l9_104,fast::clamp(l9_106,0.0,1.0));
}
}
l9_86.y=l9_102;
if (l9_90)
{
bool l9_107=l9_92;
bool l9_108;
if (l9_107)
{
l9_108=l9_89.x==3;
}
else
{
l9_108=l9_107;
}
float l9_109=l9_86.x;
float l9_110=l9_91.x;
float l9_111=l9_91.z;
bool l9_112=l9_108;
float l9_113=l9_96;
float l9_114=fast::clamp(l9_109,l9_110,l9_111);
float l9_115=step(abs(l9_109-l9_114),9.9999997e-06);
l9_113*=(l9_115+((1.0-float(l9_112))*(1.0-l9_115)));
l9_109=l9_114;
l9_86.x=l9_109;
l9_96=l9_113;
bool l9_116=l9_92;
bool l9_117;
if (l9_116)
{
l9_117=l9_89.y==3;
}
else
{
l9_117=l9_116;
}
float l9_118=l9_86.y;
float l9_119=l9_91.y;
float l9_120=l9_91.w;
bool l9_121=l9_117;
float l9_122=l9_96;
float l9_123=fast::clamp(l9_118,l9_119,l9_120);
float l9_124=step(abs(l9_118-l9_123),9.9999997e-06);
l9_122*=(l9_124+((1.0-float(l9_121))*(1.0-l9_124)));
l9_118=l9_123;
l9_86.y=l9_118;
l9_96=l9_122;
}
float2 l9_125=l9_86;
bool l9_126=l9_87;
float3x3 l9_127=l9_88;
if (l9_126)
{
l9_125=float2((l9_127*float3(l9_125,1.0)).xy);
}
float2 l9_128=l9_125;
l9_86=l9_128;
float l9_129=l9_86.x;
int l9_130=l9_89.x;
bool l9_131=l9_95;
float l9_132=l9_96;
if ((l9_130==0)||(l9_130==3))
{
float l9_133=l9_129;
float l9_134=0.0;
float l9_135=1.0;
bool l9_136=l9_131;
float l9_137=l9_132;
float l9_138=fast::clamp(l9_133,l9_134,l9_135);
float l9_139=step(abs(l9_133-l9_138),9.9999997e-06);
l9_137*=(l9_139+((1.0-float(l9_136))*(1.0-l9_139)));
l9_133=l9_138;
l9_129=l9_133;
l9_132=l9_137;
}
l9_86.x=l9_129;
l9_96=l9_132;
float l9_140=l9_86.y;
int l9_141=l9_89.y;
bool l9_142=l9_95;
float l9_143=l9_96;
if ((l9_141==0)||(l9_141==3))
{
float l9_144=l9_140;
float l9_145=0.0;
float l9_146=1.0;
bool l9_147=l9_142;
float l9_148=l9_143;
float l9_149=fast::clamp(l9_144,l9_145,l9_146);
float l9_150=step(abs(l9_144-l9_149),9.9999997e-06);
l9_148*=(l9_150+((1.0-float(l9_147))*(1.0-l9_150)));
l9_144=l9_149;
l9_140=l9_144;
l9_143=l9_148;
}
l9_86.y=l9_140;
l9_96=l9_143;
float2 l9_151=l9_86;
int l9_152=l9_84;
int l9_153=l9_85;
float l9_154=l9_94;
float2 l9_155=l9_151;
int l9_156=l9_152;
int l9_157=l9_153;
float3 l9_158=float3(0.0);
if (l9_156==0)
{
l9_158=float3(l9_155,0.0);
}
else
{
if (l9_156==1)
{
l9_158=float3(l9_155.x,(l9_155.y*0.5)+(0.5-(float(l9_157)*0.5)),0.0);
}
else
{
l9_158=float3(l9_155,float(l9_157));
}
}
float3 l9_159=l9_158;
float3 l9_160=l9_159;
float4 l9_161=sc_set0.baseColorTexture.sample(sc_set0.baseColorTextureSmpSC,l9_160.xy,bias(l9_154));
float4 l9_162=l9_161;
if (l9_92)
{
l9_162=mix(l9_93,l9_162,float4(l9_96));
}
float4 l9_163=l9_162;
l9_77=l9_163;
float4 l9_164=l9_77;
float4 l9_165=l9_164;
float4 l9_166;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_166=float4(pow(l9_165.x,2.2),pow(l9_165.y,2.2),pow(l9_165.z,2.2),pow(l9_165.w,2.2));
}
else
{
l9_166=l9_165*l9_165;
}
float4 l9_167=l9_166;
l9_59*=l9_167;
}
if (N35_EnableVertexColor)
{
float4 l9_168=tempGlobals.VertexColor;
l9_59*=l9_168;
}
N35_BaseColor=l9_59.xyz;
N35_Opacity=l9_59.w;
float4 l9_169=l9_59;
float4 l9_170;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_170=float4(pow(l9_169.x,0.45454544),pow(l9_169.y,0.45454544),pow(l9_169.z,0.45454544),pow(l9_169.w,0.45454544));
}
else
{
l9_170=sqrt(l9_169);
}
float4 l9_171=l9_170;
N35_UnlitColor=l9_171;
l9_57=N35_BaseColor;
l9_58=N35_Opacity;
l9_50=l9_57;
l9_51=l9_58;
float2 l9_172=float2(0.0);
float2 l9_173=(*sc_set0.UserUniforms).emissiveTexture_offset;
l9_172=l9_173;
float2 l9_174=float2(0.0);
float2 l9_175=(*sc_set0.UserUniforms).emissiveTexture_scale;
l9_174=l9_175;
float l9_176=0.0;
float l9_177=(*sc_set0.UserUniforms).emissiveTexture_rotation;
l9_176=l9_177;
float2 l9_178=float2(0.0);
float2 l9_179=(*sc_set0.UserUniforms).normalTexture_offset;
l9_178=l9_179;
float2 l9_180=float2(0.0);
float2 l9_181=(*sc_set0.UserUniforms).normalTexture_scale;
l9_180=l9_181;
float l9_182=0.0;
float l9_183=(*sc_set0.UserUniforms).normalTexture_rotation;
l9_182=l9_183;
float2 l9_184=float2(0.0);
float2 l9_185=(*sc_set0.UserUniforms).metallicRoughnessTexture_offset;
l9_184=l9_185;
float2 l9_186=float2(0.0);
float2 l9_187=(*sc_set0.UserUniforms).metallicRoughnessTexture_scale;
l9_186=l9_187;
float l9_188=0.0;
float l9_189=(*sc_set0.UserUniforms).metallicRoughnessTexture_rotation;
l9_188=l9_189;
float2 l9_190=float2(0.0);
float2 l9_191=(*sc_set0.UserUniforms).transmissionTexture_offset;
l9_190=l9_191;
float2 l9_192=float2(0.0);
float2 l9_193=(*sc_set0.UserUniforms).transmissionTexture_scale;
l9_192=l9_193;
float l9_194=0.0;
float l9_195=(*sc_set0.UserUniforms).transmissionTexture_rotation;
l9_194=l9_195;
float2 l9_196=float2(0.0);
float2 l9_197=(*sc_set0.UserUniforms).sheenColorTexture_offset;
l9_196=l9_197;
float2 l9_198=float2(0.0);
float2 l9_199=(*sc_set0.UserUniforms).sheenColorTexture_scale;
l9_198=l9_199;
float l9_200=0.0;
float l9_201=(*sc_set0.UserUniforms).sheenColorTexture_rotation;
l9_200=l9_201;
float2 l9_202=float2(0.0);
float2 l9_203=(*sc_set0.UserUniforms).sheenRoughnessTexture_offset;
l9_202=l9_203;
float2 l9_204=float2(0.0);
float2 l9_205=(*sc_set0.UserUniforms).sheenRoughnessTexture_scale;
l9_204=l9_205;
float l9_206=0.0;
float l9_207=(*sc_set0.UserUniforms).sheenRoughnessTexture_rotation;
l9_206=l9_207;
float2 l9_208=float2(0.0);
float2 l9_209=(*sc_set0.UserUniforms).clearcoatTexture_offset;
l9_208=l9_209;
float2 l9_210=float2(0.0);
float2 l9_211=(*sc_set0.UserUniforms).clearcoatTexture_scale;
l9_210=l9_211;
float l9_212=0.0;
float l9_213=(*sc_set0.UserUniforms).clearcoatTexture_rotation;
l9_212=l9_213;
float2 l9_214=float2(0.0);
float2 l9_215=(*sc_set0.UserUniforms).clearcoatNormalTexture_offset;
l9_214=l9_215;
float2 l9_216=float2(0.0);
float2 l9_217=(*sc_set0.UserUniforms).clearcoatNormalTexture_scale;
l9_216=l9_217;
float l9_218=0.0;
float l9_219=(*sc_set0.UserUniforms).clearcoatNormalTexture_rotation;
l9_218=l9_219;
float2 l9_220=float2(0.0);
float2 l9_221=(*sc_set0.UserUniforms).clearcoatRoughnessTexture_offset;
l9_220=l9_221;
float2 l9_222=float2(0.0);
float2 l9_223=(*sc_set0.UserUniforms).clearcoatRoughnessTexture_scale;
l9_222=l9_223;
float l9_224=0.0;
float l9_225=(*sc_set0.UserUniforms).clearcoatRoughnessTexture_rotation;
l9_224=l9_225;
float3 l9_226=float3(0.0);
float l9_227=0.0;
float3 l9_228=float3(0.0);
float3 l9_229=float3(0.0);
float l9_230=0.0;
float l9_231=0.0;
float4 l9_232=float4(0.0);
float3 l9_233=float3(0.0);
float4 l9_234=float4(0.0);
float l9_235=0.0;
float3 l9_236=float3(0.0);
float l9_237=0.0;
float3 l9_238=l9_14;
float l9_239=l9_16;
float l9_240=l9_22;
float l9_241=l9_24;
float l9_242=l9_26;
float l9_243=l9_32;
float3 l9_244=l9_34;
float l9_245=l9_36;
float l9_246=l9_38;
float l9_247=l9_40;
float3 l9_248=l9_50;
float l9_249=l9_51;
float2 l9_250=l9_172;
float2 l9_251=l9_174;
float l9_252=l9_176;
float2 l9_253=l9_178;
float2 l9_254=l9_180;
float l9_255=l9_182;
float2 l9_256=l9_184;
float2 l9_257=l9_186;
float l9_258=l9_188;
float2 l9_259=l9_190;
float2 l9_260=l9_192;
float l9_261=l9_194;
float2 l9_262=l9_196;
float2 l9_263=l9_198;
float l9_264=l9_200;
float2 l9_265=l9_202;
float2 l9_266=l9_204;
float l9_267=l9_206;
float2 l9_268=l9_208;
float2 l9_269=l9_210;
float l9_270=l9_212;
float2 l9_271=l9_214;
float2 l9_272=l9_216;
float l9_273=l9_218;
float2 l9_274=l9_220;
float2 l9_275=l9_222;
float l9_276=l9_224;
ssGlobals l9_277=param_3;
tempGlobals=l9_277;
float3 l9_278=float3(0.0);
float l9_279=0.0;
float3 l9_280=float3(0.0);
float3 l9_281=float3(0.0);
float l9_282=0.0;
float l9_283=0.0;
float4 l9_284=float4(0.0);
float3 l9_285=float3(0.0);
float4 l9_286=float4(0.0);
float l9_287=0.0;
float3 l9_288=float3(0.0);
float l9_289=0.0;
N3_EmissiveColor=l9_238;
N3_EnableEmissiveTexture=(int(ENABLE_EMISSIVE_tmp)!=0);
N3_EmissiveTextureCoord=NODE_10_DROPLIST_ITEM_tmp;
N3_EnableNormalTexture=(int(ENABLE_NORMALMAP_tmp)!=0);
N3_NormalScale=l9_239;
N3_NormalTextureCoord=NODE_8_DROPLIST_ITEM_tmp;
N3_MetallicValue=l9_240;
N3_RoughnessValue=l9_241;
N3_MetallicRoughnessTexSwizzleRB=(int(METALLIC_ROUGHNESS_TEX_SWIZZLE_RB_tmp)!=0);
N3_EnableMetallicRoughnessTexture=(int(ENABLE_METALLIC_ROUGHNESS_TEX_tmp)!=0);
N3_OcclusionStrength=l9_242;
N3_MaterialParamsTextureCoord=NODE_11_DROPLIST_ITEM_tmp;
N3_TransmissionEnable=(int(ENABLE_TRANSMISSION_tmp)!=0);
N3_TransmissionFactor=l9_243;
N3_EnableTransmissionTexture=(int(ENABLE_TRANSMISSION_TEX_tmp)!=0);
N3_TransmissionTextureCoord=Tweak_N30_tmp;
N3_SheenEnable=(int(ENABLE_SHEEN_tmp)!=0);
N3_SheenColorFactor=l9_244;
N3_EnableSheenTexture=(int(ENABLE_SHEEN_COLOR_TEX_tmp)!=0);
N3_SheenColorTextureCoord=Tweak_N32_tmp;
N3_SheenRoughnessFactor=l9_245;
N3_EnableSheenRoughnessTexture=(int(ENABLE_SHEEN_ROUGHNESS_TEX_tmp)!=0);
N3_SheenRoughnessTextureCoord=Tweak_N37_tmp;
N3_ClearcoatEnable=(int(ENABLE_CLEARCOAT_tmp)!=0);
N3_ClearcoatFactor=l9_246;
N3_EnableClearcoatTexture=(int(ENABLE_CLEARCOAT_TEX_tmp)!=0);
N3_ClearcoatTextureCoord=Tweak_N44_tmp;
N3_ClearcoatRoughnessFactor=l9_247;
N3_EnableClearCoatRoughnessTexture=(int(ENABLE_CLEARCOAT_ROUGHNESS_TEX_tmp)!=0);
N3_ClearcoatRoughnessTextureCoord=Tweak_N60_tmp;
N3_EnableClearCoatNormalTexture=(int(ENABLE_CLEARCOAT_NORMAL_TEX_tmp)!=0);
N3_ClearcoatNormalMapCoord=Tweak_N47_tmp;
N3_BaseColorIn=l9_248;
N3_OpacityIn=l9_249;
N3_EnableTextureTransform=(int(ENABLE_TEXTURE_TRANSFORM_tmp)!=0);
N3_EmissiveTextureTransform=(int(ENABLE_EMISSIVE_TEXTURE_TRANSFORM_tmp)!=0);
N3_EmissiveTextureOffset=l9_250;
N3_EmissiveTextureScale=l9_251;
N3_EmissiveTextureRotation=l9_252;
N3_NormalTextureTransform=(int(ENABLE_NORMAL_TEXTURE_TRANSFORM_tmp)!=0);
N3_NormalTextureOffset=l9_253;
N3_NormalTextureScale=l9_254;
N3_NormalTextureRotation=l9_255;
N3_MaterialParamsTextureTransform=(int(ENABLE_METALLIC_ROUGHNESS_TEXTURE_TRANSFORM_tmp)!=0);
N3_MaterialParamsTextureOffset=l9_256;
N3_MaterialParamsTextureScale=l9_257;
N3_MaterialParamsTextureRotation=l9_258;
N3_TransmissionTextureTransform=(int(ENABLE_TRANSMISSION_TEXTURE_TRANSFORM_tmp)!=0);
N3_TransmissionTextureOffset=l9_259;
N3_TransmissionTextureScale=l9_260;
N3_TransmissionTextureRotation=l9_261;
N3_SheenColorTextureTransform=(int(ENABLE_SHEEN_COLOR_TEXTURE_TRANSFORM_tmp)!=0);
N3_SheenColorTextureOffset=l9_262;
N3_SheenColorTextureScale=l9_263;
N3_SheenColorTextureRotation=l9_264;
N3_SheenRoughnessTextureTransform=(int(ENABLE_SHEEN_ROUGHNESS_TEXTURE_TRANSFORM_tmp)!=0);
N3_SheenRoughnessTextureOffset=l9_265;
N3_SheenRoughnessTextureScale=l9_266;
N3_SheenRoughnessTextureRotation=l9_267;
N3_ClearcoatTextureTransform=(int(ENABLE_CLEARCOAT_TEXTURE_TRANSFORM_tmp)!=0);
N3_ClearcoatTextureOffset=l9_268;
N3_ClearcoatTextureScale=l9_269;
N3_ClearcoatTextureRotation=l9_270;
N3_ClearcoatNormalTextureTransform=(int(ENABLE_CLEARCOAT_NORMAL_TEXTURE_TRANSFORM_tmp)!=0);
N3_ClearcoatNormalTextureOffset=l9_271;
N3_ClearcoatNormalTextureScale=l9_272;
N3_ClearcoatNormalTextureRotation=l9_273;
N3_ClearcoatRoughnessTextureTransform=(int(ENABLE_CLEARCOAT_ROUGHNESS_TEXTURE_TRANSFORM_tmp)!=0);
N3_ClearcoatRoughnessTextureOffset=l9_274;
N3_ClearcoatRoughnessTextureScale=l9_275;
N3_ClearcoatRoughnessTextureRotation=l9_276;
N3_BaseColor=N3_BaseColorIn;
N3_Opacity=N3_OpacityIn;
N3_Emissive=N3_EmissiveColor;
if (N3_EnableEmissiveTexture)
{
float3 l9_290=N3_Emissive;
int l9_291=N3_EmissiveTextureCoord;
float2 l9_292=tempGlobals.Surface_UVCoord0;
float2 l9_293=l9_292;
if (l9_291==0)
{
float2 l9_294=tempGlobals.Surface_UVCoord0;
l9_293=l9_294;
}
if (l9_291==1)
{
float2 l9_295=tempGlobals.Surface_UVCoord1;
l9_293=l9_295;
}
float2 l9_296=l9_293;
float2 l9_297=l9_296;
if (N3_EnableTextureTransform&&N3_EmissiveTextureTransform)
{
float2 l9_298=l9_297;
float2 l9_299=N3_EmissiveTextureOffset;
float2 l9_300=N3_EmissiveTextureScale;
float l9_301=N3_EmissiveTextureRotation;
float l9_302=radians(l9_301);
float3x3 l9_303=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_299.x,l9_299.y,1.0));
float3x3 l9_304=float3x3(float3(cos(l9_302),sin(l9_302),0.0),float3(-sin(l9_302),cos(l9_302),0.0),float3(0.0,0.0,1.0));
float3x3 l9_305=float3x3(float3(l9_300.x,0.0,0.0),float3(0.0,l9_300.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_306=(l9_303*l9_304)*l9_305;
float2 l9_307=(l9_306*float3(l9_298,1.0)).xy;
l9_297=l9_307;
}
float2 l9_308=l9_297;
float4 l9_309=float4(0.0);
int l9_310;
if ((int(emissiveTextureHasSwappedViews_tmp)!=0))
{
int l9_311=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_311=0;
}
else
{
l9_311=in.varStereoViewID;
}
int l9_312=l9_311;
l9_310=1-l9_312;
}
else
{
int l9_313=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_313=0;
}
else
{
l9_313=in.varStereoViewID;
}
int l9_314=l9_313;
l9_310=l9_314;
}
int l9_315=l9_310;
int l9_316=emissiveTextureLayout_tmp;
int l9_317=l9_315;
float2 l9_318=l9_308;
bool l9_319=(int(SC_USE_UV_TRANSFORM_emissiveTexture_tmp)!=0);
float3x3 l9_320=(*sc_set0.UserUniforms).emissiveTextureTransform;
int2 l9_321=int2(SC_SOFTWARE_WRAP_MODE_U_emissiveTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_emissiveTexture_tmp);
bool l9_322=(int(SC_USE_UV_MIN_MAX_emissiveTexture_tmp)!=0);
float4 l9_323=(*sc_set0.UserUniforms).emissiveTextureUvMinMax;
bool l9_324=(int(SC_USE_CLAMP_TO_BORDER_emissiveTexture_tmp)!=0);
float4 l9_325=(*sc_set0.UserUniforms).emissiveTextureBorderColor;
float l9_326=0.0;
bool l9_327=l9_324&&(!l9_322);
float l9_328=1.0;
float l9_329=l9_318.x;
int l9_330=l9_321.x;
if (l9_330==1)
{
l9_329=fract(l9_329);
}
else
{
if (l9_330==2)
{
float l9_331=fract(l9_329);
float l9_332=l9_329-l9_331;
float l9_333=step(0.25,fract(l9_332*0.5));
l9_329=mix(l9_331,1.0-l9_331,fast::clamp(l9_333,0.0,1.0));
}
}
l9_318.x=l9_329;
float l9_334=l9_318.y;
int l9_335=l9_321.y;
if (l9_335==1)
{
l9_334=fract(l9_334);
}
else
{
if (l9_335==2)
{
float l9_336=fract(l9_334);
float l9_337=l9_334-l9_336;
float l9_338=step(0.25,fract(l9_337*0.5));
l9_334=mix(l9_336,1.0-l9_336,fast::clamp(l9_338,0.0,1.0));
}
}
l9_318.y=l9_334;
if (l9_322)
{
bool l9_339=l9_324;
bool l9_340;
if (l9_339)
{
l9_340=l9_321.x==3;
}
else
{
l9_340=l9_339;
}
float l9_341=l9_318.x;
float l9_342=l9_323.x;
float l9_343=l9_323.z;
bool l9_344=l9_340;
float l9_345=l9_328;
float l9_346=fast::clamp(l9_341,l9_342,l9_343);
float l9_347=step(abs(l9_341-l9_346),9.9999997e-06);
l9_345*=(l9_347+((1.0-float(l9_344))*(1.0-l9_347)));
l9_341=l9_346;
l9_318.x=l9_341;
l9_328=l9_345;
bool l9_348=l9_324;
bool l9_349;
if (l9_348)
{
l9_349=l9_321.y==3;
}
else
{
l9_349=l9_348;
}
float l9_350=l9_318.y;
float l9_351=l9_323.y;
float l9_352=l9_323.w;
bool l9_353=l9_349;
float l9_354=l9_328;
float l9_355=fast::clamp(l9_350,l9_351,l9_352);
float l9_356=step(abs(l9_350-l9_355),9.9999997e-06);
l9_354*=(l9_356+((1.0-float(l9_353))*(1.0-l9_356)));
l9_350=l9_355;
l9_318.y=l9_350;
l9_328=l9_354;
}
float2 l9_357=l9_318;
bool l9_358=l9_319;
float3x3 l9_359=l9_320;
if (l9_358)
{
l9_357=float2((l9_359*float3(l9_357,1.0)).xy);
}
float2 l9_360=l9_357;
l9_318=l9_360;
float l9_361=l9_318.x;
int l9_362=l9_321.x;
bool l9_363=l9_327;
float l9_364=l9_328;
if ((l9_362==0)||(l9_362==3))
{
float l9_365=l9_361;
float l9_366=0.0;
float l9_367=1.0;
bool l9_368=l9_363;
float l9_369=l9_364;
float l9_370=fast::clamp(l9_365,l9_366,l9_367);
float l9_371=step(abs(l9_365-l9_370),9.9999997e-06);
l9_369*=(l9_371+((1.0-float(l9_368))*(1.0-l9_371)));
l9_365=l9_370;
l9_361=l9_365;
l9_364=l9_369;
}
l9_318.x=l9_361;
l9_328=l9_364;
float l9_372=l9_318.y;
int l9_373=l9_321.y;
bool l9_374=l9_327;
float l9_375=l9_328;
if ((l9_373==0)||(l9_373==3))
{
float l9_376=l9_372;
float l9_377=0.0;
float l9_378=1.0;
bool l9_379=l9_374;
float l9_380=l9_375;
float l9_381=fast::clamp(l9_376,l9_377,l9_378);
float l9_382=step(abs(l9_376-l9_381),9.9999997e-06);
l9_380*=(l9_382+((1.0-float(l9_379))*(1.0-l9_382)));
l9_376=l9_381;
l9_372=l9_376;
l9_375=l9_380;
}
l9_318.y=l9_372;
l9_328=l9_375;
float2 l9_383=l9_318;
int l9_384=l9_316;
int l9_385=l9_317;
float l9_386=l9_326;
float2 l9_387=l9_383;
int l9_388=l9_384;
int l9_389=l9_385;
float3 l9_390=float3(0.0);
if (l9_388==0)
{
l9_390=float3(l9_387,0.0);
}
else
{
if (l9_388==1)
{
l9_390=float3(l9_387.x,(l9_387.y*0.5)+(0.5-(float(l9_389)*0.5)),0.0);
}
else
{
l9_390=float3(l9_387,float(l9_389));
}
}
float3 l9_391=l9_390;
float3 l9_392=l9_391;
float4 l9_393=sc_set0.emissiveTexture.sample(sc_set0.emissiveTextureSmpSC,l9_392.xy,bias(l9_386));
float4 l9_394=l9_393;
if (l9_324)
{
l9_394=mix(l9_325,l9_394,float4(l9_328));
}
float4 l9_395=l9_394;
l9_309=l9_395;
float4 l9_396=l9_309;
float3 l9_397=l9_396.xyz;
float3 l9_398;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_398=float3(pow(l9_397.x,2.2),pow(l9_397.y,2.2),pow(l9_397.z,2.2));
}
else
{
l9_398=l9_397*l9_397;
}
float3 l9_399=l9_398;
float3 l9_400=l9_399;
float3 l9_401=l9_290;
float3 l9_402;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_402=float3(pow(l9_401.x,2.2),pow(l9_401.y,2.2),pow(l9_401.z,2.2));
}
else
{
l9_402=l9_401*l9_401;
}
float3 l9_403=l9_402;
l9_290=l9_400*l9_403;
N3_Emissive=l9_290;
}
float3 l9_404=tempGlobals.VertexNormal_WorldSpace;
N3_Normal=normalize(l9_404);
if (N3_EnableNormalTexture)
{
float3 l9_405=N3_Normal;
int l9_406=N3_NormalTextureCoord;
float2 l9_407=tempGlobals.Surface_UVCoord0;
float2 l9_408=l9_407;
if (l9_406==0)
{
float2 l9_409=tempGlobals.Surface_UVCoord0;
l9_408=l9_409;
}
if (l9_406==1)
{
float2 l9_410=tempGlobals.Surface_UVCoord1;
l9_408=l9_410;
}
float2 l9_411=l9_408;
float2 l9_412=l9_411;
if (N3_EnableTextureTransform&&N3_NormalTextureTransform)
{
float2 l9_413=l9_412;
float2 l9_414=N3_NormalTextureOffset;
float2 l9_415=N3_NormalTextureScale;
float l9_416=N3_NormalTextureRotation;
float l9_417=radians(l9_416);
float3x3 l9_418=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_414.x,l9_414.y,1.0));
float3x3 l9_419=float3x3(float3(cos(l9_417),sin(l9_417),0.0),float3(-sin(l9_417),cos(l9_417),0.0),float3(0.0,0.0,1.0));
float3x3 l9_420=float3x3(float3(l9_415.x,0.0,0.0),float3(0.0,l9_415.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_421=(l9_418*l9_419)*l9_420;
float2 l9_422=(l9_421*float3(l9_413,1.0)).xy;
l9_412=l9_422;
}
float2 l9_423=l9_412;
float4 l9_424=float4(0.0);
int l9_425;
if ((int(normalTextureHasSwappedViews_tmp)!=0))
{
int l9_426=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_426=0;
}
else
{
l9_426=in.varStereoViewID;
}
int l9_427=l9_426;
l9_425=1-l9_427;
}
else
{
int l9_428=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_428=0;
}
else
{
l9_428=in.varStereoViewID;
}
int l9_429=l9_428;
l9_425=l9_429;
}
int l9_430=l9_425;
int l9_431=normalTextureLayout_tmp;
int l9_432=l9_430;
float2 l9_433=l9_423;
bool l9_434=(int(SC_USE_UV_TRANSFORM_normalTexture_tmp)!=0);
float3x3 l9_435=(*sc_set0.UserUniforms).normalTextureTransform;
int2 l9_436=int2(SC_SOFTWARE_WRAP_MODE_U_normalTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_normalTexture_tmp);
bool l9_437=(int(SC_USE_UV_MIN_MAX_normalTexture_tmp)!=0);
float4 l9_438=(*sc_set0.UserUniforms).normalTextureUvMinMax;
bool l9_439=(int(SC_USE_CLAMP_TO_BORDER_normalTexture_tmp)!=0);
float4 l9_440=(*sc_set0.UserUniforms).normalTextureBorderColor;
float l9_441=0.0;
bool l9_442=l9_439&&(!l9_437);
float l9_443=1.0;
float l9_444=l9_433.x;
int l9_445=l9_436.x;
if (l9_445==1)
{
l9_444=fract(l9_444);
}
else
{
if (l9_445==2)
{
float l9_446=fract(l9_444);
float l9_447=l9_444-l9_446;
float l9_448=step(0.25,fract(l9_447*0.5));
l9_444=mix(l9_446,1.0-l9_446,fast::clamp(l9_448,0.0,1.0));
}
}
l9_433.x=l9_444;
float l9_449=l9_433.y;
int l9_450=l9_436.y;
if (l9_450==1)
{
l9_449=fract(l9_449);
}
else
{
if (l9_450==2)
{
float l9_451=fract(l9_449);
float l9_452=l9_449-l9_451;
float l9_453=step(0.25,fract(l9_452*0.5));
l9_449=mix(l9_451,1.0-l9_451,fast::clamp(l9_453,0.0,1.0));
}
}
l9_433.y=l9_449;
if (l9_437)
{
bool l9_454=l9_439;
bool l9_455;
if (l9_454)
{
l9_455=l9_436.x==3;
}
else
{
l9_455=l9_454;
}
float l9_456=l9_433.x;
float l9_457=l9_438.x;
float l9_458=l9_438.z;
bool l9_459=l9_455;
float l9_460=l9_443;
float l9_461=fast::clamp(l9_456,l9_457,l9_458);
float l9_462=step(abs(l9_456-l9_461),9.9999997e-06);
l9_460*=(l9_462+((1.0-float(l9_459))*(1.0-l9_462)));
l9_456=l9_461;
l9_433.x=l9_456;
l9_443=l9_460;
bool l9_463=l9_439;
bool l9_464;
if (l9_463)
{
l9_464=l9_436.y==3;
}
else
{
l9_464=l9_463;
}
float l9_465=l9_433.y;
float l9_466=l9_438.y;
float l9_467=l9_438.w;
bool l9_468=l9_464;
float l9_469=l9_443;
float l9_470=fast::clamp(l9_465,l9_466,l9_467);
float l9_471=step(abs(l9_465-l9_470),9.9999997e-06);
l9_469*=(l9_471+((1.0-float(l9_468))*(1.0-l9_471)));
l9_465=l9_470;
l9_433.y=l9_465;
l9_443=l9_469;
}
float2 l9_472=l9_433;
bool l9_473=l9_434;
float3x3 l9_474=l9_435;
if (l9_473)
{
l9_472=float2((l9_474*float3(l9_472,1.0)).xy);
}
float2 l9_475=l9_472;
l9_433=l9_475;
float l9_476=l9_433.x;
int l9_477=l9_436.x;
bool l9_478=l9_442;
float l9_479=l9_443;
if ((l9_477==0)||(l9_477==3))
{
float l9_480=l9_476;
float l9_481=0.0;
float l9_482=1.0;
bool l9_483=l9_478;
float l9_484=l9_479;
float l9_485=fast::clamp(l9_480,l9_481,l9_482);
float l9_486=step(abs(l9_480-l9_485),9.9999997e-06);
l9_484*=(l9_486+((1.0-float(l9_483))*(1.0-l9_486)));
l9_480=l9_485;
l9_476=l9_480;
l9_479=l9_484;
}
l9_433.x=l9_476;
l9_443=l9_479;
float l9_487=l9_433.y;
int l9_488=l9_436.y;
bool l9_489=l9_442;
float l9_490=l9_443;
if ((l9_488==0)||(l9_488==3))
{
float l9_491=l9_487;
float l9_492=0.0;
float l9_493=1.0;
bool l9_494=l9_489;
float l9_495=l9_490;
float l9_496=fast::clamp(l9_491,l9_492,l9_493);
float l9_497=step(abs(l9_491-l9_496),9.9999997e-06);
l9_495*=(l9_497+((1.0-float(l9_494))*(1.0-l9_497)));
l9_491=l9_496;
l9_487=l9_491;
l9_490=l9_495;
}
l9_433.y=l9_487;
l9_443=l9_490;
float2 l9_498=l9_433;
int l9_499=l9_431;
int l9_500=l9_432;
float l9_501=l9_441;
float2 l9_502=l9_498;
int l9_503=l9_499;
int l9_504=l9_500;
float3 l9_505=float3(0.0);
if (l9_503==0)
{
l9_505=float3(l9_502,0.0);
}
else
{
if (l9_503==1)
{
l9_505=float3(l9_502.x,(l9_502.y*0.5)+(0.5-(float(l9_504)*0.5)),0.0);
}
else
{
l9_505=float3(l9_502,float(l9_504));
}
}
float3 l9_506=l9_505;
float3 l9_507=l9_506;
float4 l9_508=sc_set0.normalTexture.sample(sc_set0.normalTextureSmpSC,l9_507.xy,bias(l9_501));
float4 l9_509=l9_508;
if (l9_439)
{
l9_509=mix(l9_440,l9_509,float4(l9_443));
}
float4 l9_510=l9_509;
l9_424=l9_510;
float4 l9_511=l9_424;
float3 l9_512=(l9_511.xyz*1.9921875)-float3(1.0);
l9_512=mix(float3(0.0,0.0,1.0),l9_512,float3(N3_NormalScale));
float3 l9_513=tempGlobals.VertexTangent_WorldSpace;
float3 l9_514=l9_513;
float3 l9_515=tempGlobals.VertexBinormal_WorldSpace;
float3 l9_516=l9_515;
float3x3 l9_517=float3x3(float3(l9_514),float3(l9_516),float3(l9_405));
l9_405=normalize(l9_517*l9_512);
N3_Normal=l9_405;
}
N3_Metallic=N3_MetallicValue;
N3_Roughness=N3_RoughnessValue;
N3_Occlusion=float4(1.0,1.0,1.0,0.0);
if (N3_EnableMetallicRoughnessTexture)
{
float l9_518=N3_Metallic;
float l9_519=N3_Roughness;
float4 l9_520=N3_Occlusion;
int l9_521=N3_MaterialParamsTextureCoord;
float2 l9_522=tempGlobals.Surface_UVCoord0;
float2 l9_523=l9_522;
if (l9_521==0)
{
float2 l9_524=tempGlobals.Surface_UVCoord0;
l9_523=l9_524;
}
if (l9_521==1)
{
float2 l9_525=tempGlobals.Surface_UVCoord1;
l9_523=l9_525;
}
float2 l9_526=l9_523;
float2 l9_527=l9_526;
if (N3_EnableTextureTransform&&N3_MaterialParamsTextureTransform)
{
float2 l9_528=l9_527;
float2 l9_529=N3_MaterialParamsTextureOffset;
float2 l9_530=N3_MaterialParamsTextureScale;
float l9_531=N3_MaterialParamsTextureRotation;
float l9_532=radians(l9_531);
float3x3 l9_533=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_529.x,l9_529.y,1.0));
float3x3 l9_534=float3x3(float3(cos(l9_532),sin(l9_532),0.0),float3(-sin(l9_532),cos(l9_532),0.0),float3(0.0,0.0,1.0));
float3x3 l9_535=float3x3(float3(l9_530.x,0.0,0.0),float3(0.0,l9_530.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_536=(l9_533*l9_534)*l9_535;
float2 l9_537=(l9_536*float3(l9_528,1.0)).xy;
l9_527=l9_537;
}
float2 l9_538=l9_527;
float4 l9_539=float4(0.0);
int l9_540;
if ((int(metallicRoughnessTextureHasSwappedViews_tmp)!=0))
{
int l9_541=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_541=0;
}
else
{
l9_541=in.varStereoViewID;
}
int l9_542=l9_541;
l9_540=1-l9_542;
}
else
{
int l9_543=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_543=0;
}
else
{
l9_543=in.varStereoViewID;
}
int l9_544=l9_543;
l9_540=l9_544;
}
int l9_545=l9_540;
int l9_546=metallicRoughnessTextureLayout_tmp;
int l9_547=l9_545;
float2 l9_548=l9_538;
bool l9_549=(int(SC_USE_UV_TRANSFORM_metallicRoughnessTexture_tmp)!=0);
float3x3 l9_550=(*sc_set0.UserUniforms).metallicRoughnessTextureTransform;
int2 l9_551=int2(SC_SOFTWARE_WRAP_MODE_U_metallicRoughnessTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_metallicRoughnessTexture_tmp);
bool l9_552=(int(SC_USE_UV_MIN_MAX_metallicRoughnessTexture_tmp)!=0);
float4 l9_553=(*sc_set0.UserUniforms).metallicRoughnessTextureUvMinMax;
bool l9_554=(int(SC_USE_CLAMP_TO_BORDER_metallicRoughnessTexture_tmp)!=0);
float4 l9_555=(*sc_set0.UserUniforms).metallicRoughnessTextureBorderColor;
float l9_556=0.0;
bool l9_557=l9_554&&(!l9_552);
float l9_558=1.0;
float l9_559=l9_548.x;
int l9_560=l9_551.x;
if (l9_560==1)
{
l9_559=fract(l9_559);
}
else
{
if (l9_560==2)
{
float l9_561=fract(l9_559);
float l9_562=l9_559-l9_561;
float l9_563=step(0.25,fract(l9_562*0.5));
l9_559=mix(l9_561,1.0-l9_561,fast::clamp(l9_563,0.0,1.0));
}
}
l9_548.x=l9_559;
float l9_564=l9_548.y;
int l9_565=l9_551.y;
if (l9_565==1)
{
l9_564=fract(l9_564);
}
else
{
if (l9_565==2)
{
float l9_566=fract(l9_564);
float l9_567=l9_564-l9_566;
float l9_568=step(0.25,fract(l9_567*0.5));
l9_564=mix(l9_566,1.0-l9_566,fast::clamp(l9_568,0.0,1.0));
}
}
l9_548.y=l9_564;
if (l9_552)
{
bool l9_569=l9_554;
bool l9_570;
if (l9_569)
{
l9_570=l9_551.x==3;
}
else
{
l9_570=l9_569;
}
float l9_571=l9_548.x;
float l9_572=l9_553.x;
float l9_573=l9_553.z;
bool l9_574=l9_570;
float l9_575=l9_558;
float l9_576=fast::clamp(l9_571,l9_572,l9_573);
float l9_577=step(abs(l9_571-l9_576),9.9999997e-06);
l9_575*=(l9_577+((1.0-float(l9_574))*(1.0-l9_577)));
l9_571=l9_576;
l9_548.x=l9_571;
l9_558=l9_575;
bool l9_578=l9_554;
bool l9_579;
if (l9_578)
{
l9_579=l9_551.y==3;
}
else
{
l9_579=l9_578;
}
float l9_580=l9_548.y;
float l9_581=l9_553.y;
float l9_582=l9_553.w;
bool l9_583=l9_579;
float l9_584=l9_558;
float l9_585=fast::clamp(l9_580,l9_581,l9_582);
float l9_586=step(abs(l9_580-l9_585),9.9999997e-06);
l9_584*=(l9_586+((1.0-float(l9_583))*(1.0-l9_586)));
l9_580=l9_585;
l9_548.y=l9_580;
l9_558=l9_584;
}
float2 l9_587=l9_548;
bool l9_588=l9_549;
float3x3 l9_589=l9_550;
if (l9_588)
{
l9_587=float2((l9_589*float3(l9_587,1.0)).xy);
}
float2 l9_590=l9_587;
l9_548=l9_590;
float l9_591=l9_548.x;
int l9_592=l9_551.x;
bool l9_593=l9_557;
float l9_594=l9_558;
if ((l9_592==0)||(l9_592==3))
{
float l9_595=l9_591;
float l9_596=0.0;
float l9_597=1.0;
bool l9_598=l9_593;
float l9_599=l9_594;
float l9_600=fast::clamp(l9_595,l9_596,l9_597);
float l9_601=step(abs(l9_595-l9_600),9.9999997e-06);
l9_599*=(l9_601+((1.0-float(l9_598))*(1.0-l9_601)));
l9_595=l9_600;
l9_591=l9_595;
l9_594=l9_599;
}
l9_548.x=l9_591;
l9_558=l9_594;
float l9_602=l9_548.y;
int l9_603=l9_551.y;
bool l9_604=l9_557;
float l9_605=l9_558;
if ((l9_603==0)||(l9_603==3))
{
float l9_606=l9_602;
float l9_607=0.0;
float l9_608=1.0;
bool l9_609=l9_604;
float l9_610=l9_605;
float l9_611=fast::clamp(l9_606,l9_607,l9_608);
float l9_612=step(abs(l9_606-l9_611),9.9999997e-06);
l9_610*=(l9_612+((1.0-float(l9_609))*(1.0-l9_612)));
l9_606=l9_611;
l9_602=l9_606;
l9_605=l9_610;
}
l9_548.y=l9_602;
l9_558=l9_605;
float2 l9_613=l9_548;
int l9_614=l9_546;
int l9_615=l9_547;
float l9_616=l9_556;
float2 l9_617=l9_613;
int l9_618=l9_614;
int l9_619=l9_615;
float3 l9_620=float3(0.0);
if (l9_618==0)
{
l9_620=float3(l9_617,0.0);
}
else
{
if (l9_618==1)
{
l9_620=float3(l9_617.x,(l9_617.y*0.5)+(0.5-(float(l9_619)*0.5)),0.0);
}
else
{
l9_620=float3(l9_617,float(l9_619));
}
}
float3 l9_621=l9_620;
float3 l9_622=l9_621;
float4 l9_623=sc_set0.metallicRoughnessTexture.sample(sc_set0.metallicRoughnessTextureSmpSC,l9_622.xy,bias(l9_616));
float4 l9_624=l9_623;
if (l9_554)
{
l9_624=mix(l9_555,l9_624,float4(l9_558));
}
float4 l9_625=l9_624;
l9_539=l9_625;
float4 l9_626=l9_539;
float3 l9_627=l9_626.xyz;
if (N3_MetallicRoughnessTexSwizzleRB)
{
l9_627=l9_627.zyx;
}
l9_518*=l9_627.x;
l9_519*=l9_627.y;
l9_520.w=N3_OcclusionStrength;
float3 l9_628=float3(1.0+(l9_520.w*(l9_627.z-1.0)));
l9_520=float4(l9_628.x,l9_628.y,l9_628.z,l9_520.w);
N3_Metallic=l9_518;
N3_Roughness=l9_519;
N3_Occlusion=l9_520;
}
if (N3_TransmissionEnable)
{
float3 l9_629=N3_BaseColor;
float3 l9_630=N3_Emissive;
float l9_631=N3_Metallic;
float2 l9_632=tempGlobals.gScreenCoord;
float2 l9_633=l9_632;
float4 l9_634=float4(0.0);
int l9_635;
if ((int(screenTextureHasSwappedViews_tmp)!=0))
{
int l9_636=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_636=0;
}
else
{
l9_636=in.varStereoViewID;
}
int l9_637=l9_636;
l9_635=1-l9_637;
}
else
{
int l9_638=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_638=0;
}
else
{
l9_638=in.varStereoViewID;
}
int l9_639=l9_638;
l9_635=l9_639;
}
int l9_640=l9_635;
int l9_641=screenTextureLayout_tmp;
int l9_642=l9_640;
float2 l9_643=l9_633;
bool l9_644=(int(SC_USE_UV_TRANSFORM_screenTexture_tmp)!=0);
float3x3 l9_645=(*sc_set0.UserUniforms).screenTextureTransform;
int2 l9_646=int2(SC_SOFTWARE_WRAP_MODE_U_screenTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_screenTexture_tmp);
bool l9_647=(int(SC_USE_UV_MIN_MAX_screenTexture_tmp)!=0);
float4 l9_648=(*sc_set0.UserUniforms).screenTextureUvMinMax;
bool l9_649=(int(SC_USE_CLAMP_TO_BORDER_screenTexture_tmp)!=0);
float4 l9_650=(*sc_set0.UserUniforms).screenTextureBorderColor;
float l9_651=0.0;
bool l9_652=l9_649&&(!l9_647);
float l9_653=1.0;
float l9_654=l9_643.x;
int l9_655=l9_646.x;
if (l9_655==1)
{
l9_654=fract(l9_654);
}
else
{
if (l9_655==2)
{
float l9_656=fract(l9_654);
float l9_657=l9_654-l9_656;
float l9_658=step(0.25,fract(l9_657*0.5));
l9_654=mix(l9_656,1.0-l9_656,fast::clamp(l9_658,0.0,1.0));
}
}
l9_643.x=l9_654;
float l9_659=l9_643.y;
int l9_660=l9_646.y;
if (l9_660==1)
{
l9_659=fract(l9_659);
}
else
{
if (l9_660==2)
{
float l9_661=fract(l9_659);
float l9_662=l9_659-l9_661;
float l9_663=step(0.25,fract(l9_662*0.5));
l9_659=mix(l9_661,1.0-l9_661,fast::clamp(l9_663,0.0,1.0));
}
}
l9_643.y=l9_659;
if (l9_647)
{
bool l9_664=l9_649;
bool l9_665;
if (l9_664)
{
l9_665=l9_646.x==3;
}
else
{
l9_665=l9_664;
}
float l9_666=l9_643.x;
float l9_667=l9_648.x;
float l9_668=l9_648.z;
bool l9_669=l9_665;
float l9_670=l9_653;
float l9_671=fast::clamp(l9_666,l9_667,l9_668);
float l9_672=step(abs(l9_666-l9_671),9.9999997e-06);
l9_670*=(l9_672+((1.0-float(l9_669))*(1.0-l9_672)));
l9_666=l9_671;
l9_643.x=l9_666;
l9_653=l9_670;
bool l9_673=l9_649;
bool l9_674;
if (l9_673)
{
l9_674=l9_646.y==3;
}
else
{
l9_674=l9_673;
}
float l9_675=l9_643.y;
float l9_676=l9_648.y;
float l9_677=l9_648.w;
bool l9_678=l9_674;
float l9_679=l9_653;
float l9_680=fast::clamp(l9_675,l9_676,l9_677);
float l9_681=step(abs(l9_675-l9_680),9.9999997e-06);
l9_679*=(l9_681+((1.0-float(l9_678))*(1.0-l9_681)));
l9_675=l9_680;
l9_643.y=l9_675;
l9_653=l9_679;
}
float2 l9_682=l9_643;
bool l9_683=l9_644;
float3x3 l9_684=l9_645;
if (l9_683)
{
l9_682=float2((l9_684*float3(l9_682,1.0)).xy);
}
float2 l9_685=l9_682;
l9_643=l9_685;
float l9_686=l9_643.x;
int l9_687=l9_646.x;
bool l9_688=l9_652;
float l9_689=l9_653;
if ((l9_687==0)||(l9_687==3))
{
float l9_690=l9_686;
float l9_691=0.0;
float l9_692=1.0;
bool l9_693=l9_688;
float l9_694=l9_689;
float l9_695=fast::clamp(l9_690,l9_691,l9_692);
float l9_696=step(abs(l9_690-l9_695),9.9999997e-06);
l9_694*=(l9_696+((1.0-float(l9_693))*(1.0-l9_696)));
l9_690=l9_695;
l9_686=l9_690;
l9_689=l9_694;
}
l9_643.x=l9_686;
l9_653=l9_689;
float l9_697=l9_643.y;
int l9_698=l9_646.y;
bool l9_699=l9_652;
float l9_700=l9_653;
if ((l9_698==0)||(l9_698==3))
{
float l9_701=l9_697;
float l9_702=0.0;
float l9_703=1.0;
bool l9_704=l9_699;
float l9_705=l9_700;
float l9_706=fast::clamp(l9_701,l9_702,l9_703);
float l9_707=step(abs(l9_701-l9_706),9.9999997e-06);
l9_705*=(l9_707+((1.0-float(l9_704))*(1.0-l9_707)));
l9_701=l9_706;
l9_697=l9_701;
l9_700=l9_705;
}
l9_643.y=l9_697;
l9_653=l9_700;
float2 l9_708=l9_643;
int l9_709=l9_641;
int l9_710=l9_642;
float l9_711=l9_651;
float2 l9_712=l9_708;
int l9_713=l9_709;
int l9_714=l9_710;
float3 l9_715=float3(0.0);
if (l9_713==0)
{
l9_715=float3(l9_712,0.0);
}
else
{
if (l9_713==1)
{
l9_715=float3(l9_712.x,(l9_712.y*0.5)+(0.5-(float(l9_714)*0.5)),0.0);
}
else
{
l9_715=float3(l9_712,float(l9_714));
}
}
float3 l9_716=l9_715;
float3 l9_717=l9_716;
float4 l9_718=sc_set0.screenTexture.sample(sc_set0.screenTextureSmpSC,l9_717.xy,bias(l9_711));
float4 l9_719=l9_718;
if (l9_649)
{
l9_719=mix(l9_650,l9_719,float4(l9_653));
}
float4 l9_720=l9_719;
l9_634=l9_720;
float4 l9_721=l9_634;
float3 l9_722=l9_721.xyz;
float3 l9_723;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_723=float3(pow(l9_722.x,2.2),pow(l9_722.y,2.2),pow(l9_722.z,2.2));
}
else
{
l9_723=l9_722*l9_722;
}
float3 l9_724=l9_723;
N3_Background=l9_724;
float l9_725=1.0;
if (N3_EnableTransmissionTexture)
{
int l9_726=N3_TransmissionTextureCoord;
float2 l9_727=tempGlobals.Surface_UVCoord0;
float2 l9_728=l9_727;
if (l9_726==0)
{
float2 l9_729=tempGlobals.Surface_UVCoord0;
l9_728=l9_729;
}
if (l9_726==1)
{
float2 l9_730=tempGlobals.Surface_UVCoord1;
l9_728=l9_730;
}
float2 l9_731=l9_728;
float2 l9_732=l9_731;
if (N3_EnableTextureTransform&&N3_TransmissionTextureTransform)
{
float2 l9_733=l9_732;
float2 l9_734=N3_TransmissionTextureOffset;
float2 l9_735=N3_TransmissionTextureScale;
float l9_736=N3_TransmissionTextureRotation;
float l9_737=radians(l9_736);
float3x3 l9_738=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_734.x,l9_734.y,1.0));
float3x3 l9_739=float3x3(float3(cos(l9_737),sin(l9_737),0.0),float3(-sin(l9_737),cos(l9_737),0.0),float3(0.0,0.0,1.0));
float3x3 l9_740=float3x3(float3(l9_735.x,0.0,0.0),float3(0.0,l9_735.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_741=(l9_738*l9_739)*l9_740;
float2 l9_742=(l9_741*float3(l9_733,1.0)).xy;
l9_732=l9_742;
}
float2 l9_743=l9_732;
float4 l9_744=float4(0.0);
int l9_745;
if ((int(transmissionTextureHasSwappedViews_tmp)!=0))
{
int l9_746=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_746=0;
}
else
{
l9_746=in.varStereoViewID;
}
int l9_747=l9_746;
l9_745=1-l9_747;
}
else
{
int l9_748=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_748=0;
}
else
{
l9_748=in.varStereoViewID;
}
int l9_749=l9_748;
l9_745=l9_749;
}
int l9_750=l9_745;
int l9_751=transmissionTextureLayout_tmp;
int l9_752=l9_750;
float2 l9_753=l9_743;
bool l9_754=(int(SC_USE_UV_TRANSFORM_transmissionTexture_tmp)!=0);
float3x3 l9_755=(*sc_set0.UserUniforms).transmissionTextureTransform;
int2 l9_756=int2(SC_SOFTWARE_WRAP_MODE_U_transmissionTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_transmissionTexture_tmp);
bool l9_757=(int(SC_USE_UV_MIN_MAX_transmissionTexture_tmp)!=0);
float4 l9_758=(*sc_set0.UserUniforms).transmissionTextureUvMinMax;
bool l9_759=(int(SC_USE_CLAMP_TO_BORDER_transmissionTexture_tmp)!=0);
float4 l9_760=(*sc_set0.UserUniforms).transmissionTextureBorderColor;
float l9_761=0.0;
bool l9_762=l9_759&&(!l9_757);
float l9_763=1.0;
float l9_764=l9_753.x;
int l9_765=l9_756.x;
if (l9_765==1)
{
l9_764=fract(l9_764);
}
else
{
if (l9_765==2)
{
float l9_766=fract(l9_764);
float l9_767=l9_764-l9_766;
float l9_768=step(0.25,fract(l9_767*0.5));
l9_764=mix(l9_766,1.0-l9_766,fast::clamp(l9_768,0.0,1.0));
}
}
l9_753.x=l9_764;
float l9_769=l9_753.y;
int l9_770=l9_756.y;
if (l9_770==1)
{
l9_769=fract(l9_769);
}
else
{
if (l9_770==2)
{
float l9_771=fract(l9_769);
float l9_772=l9_769-l9_771;
float l9_773=step(0.25,fract(l9_772*0.5));
l9_769=mix(l9_771,1.0-l9_771,fast::clamp(l9_773,0.0,1.0));
}
}
l9_753.y=l9_769;
if (l9_757)
{
bool l9_774=l9_759;
bool l9_775;
if (l9_774)
{
l9_775=l9_756.x==3;
}
else
{
l9_775=l9_774;
}
float l9_776=l9_753.x;
float l9_777=l9_758.x;
float l9_778=l9_758.z;
bool l9_779=l9_775;
float l9_780=l9_763;
float l9_781=fast::clamp(l9_776,l9_777,l9_778);
float l9_782=step(abs(l9_776-l9_781),9.9999997e-06);
l9_780*=(l9_782+((1.0-float(l9_779))*(1.0-l9_782)));
l9_776=l9_781;
l9_753.x=l9_776;
l9_763=l9_780;
bool l9_783=l9_759;
bool l9_784;
if (l9_783)
{
l9_784=l9_756.y==3;
}
else
{
l9_784=l9_783;
}
float l9_785=l9_753.y;
float l9_786=l9_758.y;
float l9_787=l9_758.w;
bool l9_788=l9_784;
float l9_789=l9_763;
float l9_790=fast::clamp(l9_785,l9_786,l9_787);
float l9_791=step(abs(l9_785-l9_790),9.9999997e-06);
l9_789*=(l9_791+((1.0-float(l9_788))*(1.0-l9_791)));
l9_785=l9_790;
l9_753.y=l9_785;
l9_763=l9_789;
}
float2 l9_792=l9_753;
bool l9_793=l9_754;
float3x3 l9_794=l9_755;
if (l9_793)
{
l9_792=float2((l9_794*float3(l9_792,1.0)).xy);
}
float2 l9_795=l9_792;
l9_753=l9_795;
float l9_796=l9_753.x;
int l9_797=l9_756.x;
bool l9_798=l9_762;
float l9_799=l9_763;
if ((l9_797==0)||(l9_797==3))
{
float l9_800=l9_796;
float l9_801=0.0;
float l9_802=1.0;
bool l9_803=l9_798;
float l9_804=l9_799;
float l9_805=fast::clamp(l9_800,l9_801,l9_802);
float l9_806=step(abs(l9_800-l9_805),9.9999997e-06);
l9_804*=(l9_806+((1.0-float(l9_803))*(1.0-l9_806)));
l9_800=l9_805;
l9_796=l9_800;
l9_799=l9_804;
}
l9_753.x=l9_796;
l9_763=l9_799;
float l9_807=l9_753.y;
int l9_808=l9_756.y;
bool l9_809=l9_762;
float l9_810=l9_763;
if ((l9_808==0)||(l9_808==3))
{
float l9_811=l9_807;
float l9_812=0.0;
float l9_813=1.0;
bool l9_814=l9_809;
float l9_815=l9_810;
float l9_816=fast::clamp(l9_811,l9_812,l9_813);
float l9_817=step(abs(l9_811-l9_816),9.9999997e-06);
l9_815*=(l9_817+((1.0-float(l9_814))*(1.0-l9_817)));
l9_811=l9_816;
l9_807=l9_811;
l9_810=l9_815;
}
l9_753.y=l9_807;
l9_763=l9_810;
float2 l9_818=l9_753;
int l9_819=l9_751;
int l9_820=l9_752;
float l9_821=l9_761;
float2 l9_822=l9_818;
int l9_823=l9_819;
int l9_824=l9_820;
float3 l9_825=float3(0.0);
if (l9_823==0)
{
l9_825=float3(l9_822,0.0);
}
else
{
if (l9_823==1)
{
l9_825=float3(l9_822.x,(l9_822.y*0.5)+(0.5-(float(l9_824)*0.5)),0.0);
}
else
{
l9_825=float3(l9_822,float(l9_824));
}
}
float3 l9_826=l9_825;
float3 l9_827=l9_826;
float4 l9_828=sc_set0.transmissionTexture.sample(sc_set0.transmissionTextureSmpSC,l9_827.xy,bias(l9_821));
float4 l9_829=l9_828;
if (l9_759)
{
l9_829=mix(l9_760,l9_829,float4(l9_763));
}
float4 l9_830=l9_829;
l9_744=l9_830;
float4 l9_831=l9_744;
l9_725=l9_831.x;
}
l9_725*=N3_TransmissionFactor;
float3 l9_832=l9_629;
l9_629=mix(l9_832,float3(0.0),float3(l9_725));
l9_629=mix(l9_629,l9_832,float3(l9_631));
float3 l9_833=l9_630;
l9_630=mix(float3(0.0),l9_832,float3(l9_725))*N3_Background;
l9_630=mix(l9_630,float3(0.0),float3(l9_631))+l9_833;
N3_BaseColor=l9_629;
N3_Emissive=l9_630;
}
float3 l9_834=N3_BaseColor;
float3 l9_835;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_835=float3(pow(l9_834.x,0.45454544),pow(l9_834.y,0.45454544),pow(l9_834.z,0.45454544));
}
else
{
l9_835=sqrt(l9_834);
}
float3 l9_836=l9_835;
N3_BaseColor=l9_836;
float l9_837=N3_Opacity;
float l9_838;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_838=pow(l9_837,0.45454544);
}
else
{
l9_838=sqrt(l9_837);
}
float l9_839=l9_838;
N3_Opacity=l9_839;
float3 l9_840=N3_Emissive;
float3 l9_841;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_841=float3(pow(l9_840.x,0.45454544),pow(l9_840.y,0.45454544),pow(l9_840.z,0.45454544));
}
else
{
l9_841=sqrt(l9_840);
}
float3 l9_842=l9_841;
N3_Emissive=l9_842;
if (N3_SheenEnable)
{
float3 l9_843=N3_Normal;
float4 l9_844=N3_Occlusion;
float3 l9_845=N3_SheenColorFactor;
float l9_846=N3_SheenRoughnessFactor;
if (N3_EnableSheenTexture)
{
int l9_847=N3_SheenColorTextureCoord;
float2 l9_848=tempGlobals.Surface_UVCoord0;
float2 l9_849=l9_848;
if (l9_847==0)
{
float2 l9_850=tempGlobals.Surface_UVCoord0;
l9_849=l9_850;
}
if (l9_847==1)
{
float2 l9_851=tempGlobals.Surface_UVCoord1;
l9_849=l9_851;
}
float2 l9_852=l9_849;
float2 l9_853=l9_852;
if (N3_EnableTextureTransform&&N3_SheenColorTextureTransform)
{
float2 l9_854=l9_853;
float2 l9_855=N3_SheenColorTextureOffset;
float2 l9_856=N3_SheenColorTextureScale;
float l9_857=N3_SheenColorTextureRotation;
float l9_858=radians(l9_857);
float3x3 l9_859=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_855.x,l9_855.y,1.0));
float3x3 l9_860=float3x3(float3(cos(l9_858),sin(l9_858),0.0),float3(-sin(l9_858),cos(l9_858),0.0),float3(0.0,0.0,1.0));
float3x3 l9_861=float3x3(float3(l9_856.x,0.0,0.0),float3(0.0,l9_856.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_862=(l9_859*l9_860)*l9_861;
float2 l9_863=(l9_862*float3(l9_854,1.0)).xy;
l9_853=l9_863;
}
float2 l9_864=l9_853;
float4 l9_865=float4(0.0);
int l9_866;
if ((int(sheenColorTextureHasSwappedViews_tmp)!=0))
{
int l9_867=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_867=0;
}
else
{
l9_867=in.varStereoViewID;
}
int l9_868=l9_867;
l9_866=1-l9_868;
}
else
{
int l9_869=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_869=0;
}
else
{
l9_869=in.varStereoViewID;
}
int l9_870=l9_869;
l9_866=l9_870;
}
int l9_871=l9_866;
int l9_872=sheenColorTextureLayout_tmp;
int l9_873=l9_871;
float2 l9_874=l9_864;
bool l9_875=(int(SC_USE_UV_TRANSFORM_sheenColorTexture_tmp)!=0);
float3x3 l9_876=(*sc_set0.UserUniforms).sheenColorTextureTransform;
int2 l9_877=int2(SC_SOFTWARE_WRAP_MODE_U_sheenColorTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_sheenColorTexture_tmp);
bool l9_878=(int(SC_USE_UV_MIN_MAX_sheenColorTexture_tmp)!=0);
float4 l9_879=(*sc_set0.UserUniforms).sheenColorTextureUvMinMax;
bool l9_880=(int(SC_USE_CLAMP_TO_BORDER_sheenColorTexture_tmp)!=0);
float4 l9_881=(*sc_set0.UserUniforms).sheenColorTextureBorderColor;
float l9_882=0.0;
bool l9_883=l9_880&&(!l9_878);
float l9_884=1.0;
float l9_885=l9_874.x;
int l9_886=l9_877.x;
if (l9_886==1)
{
l9_885=fract(l9_885);
}
else
{
if (l9_886==2)
{
float l9_887=fract(l9_885);
float l9_888=l9_885-l9_887;
float l9_889=step(0.25,fract(l9_888*0.5));
l9_885=mix(l9_887,1.0-l9_887,fast::clamp(l9_889,0.0,1.0));
}
}
l9_874.x=l9_885;
float l9_890=l9_874.y;
int l9_891=l9_877.y;
if (l9_891==1)
{
l9_890=fract(l9_890);
}
else
{
if (l9_891==2)
{
float l9_892=fract(l9_890);
float l9_893=l9_890-l9_892;
float l9_894=step(0.25,fract(l9_893*0.5));
l9_890=mix(l9_892,1.0-l9_892,fast::clamp(l9_894,0.0,1.0));
}
}
l9_874.y=l9_890;
if (l9_878)
{
bool l9_895=l9_880;
bool l9_896;
if (l9_895)
{
l9_896=l9_877.x==3;
}
else
{
l9_896=l9_895;
}
float l9_897=l9_874.x;
float l9_898=l9_879.x;
float l9_899=l9_879.z;
bool l9_900=l9_896;
float l9_901=l9_884;
float l9_902=fast::clamp(l9_897,l9_898,l9_899);
float l9_903=step(abs(l9_897-l9_902),9.9999997e-06);
l9_901*=(l9_903+((1.0-float(l9_900))*(1.0-l9_903)));
l9_897=l9_902;
l9_874.x=l9_897;
l9_884=l9_901;
bool l9_904=l9_880;
bool l9_905;
if (l9_904)
{
l9_905=l9_877.y==3;
}
else
{
l9_905=l9_904;
}
float l9_906=l9_874.y;
float l9_907=l9_879.y;
float l9_908=l9_879.w;
bool l9_909=l9_905;
float l9_910=l9_884;
float l9_911=fast::clamp(l9_906,l9_907,l9_908);
float l9_912=step(abs(l9_906-l9_911),9.9999997e-06);
l9_910*=(l9_912+((1.0-float(l9_909))*(1.0-l9_912)));
l9_906=l9_911;
l9_874.y=l9_906;
l9_884=l9_910;
}
float2 l9_913=l9_874;
bool l9_914=l9_875;
float3x3 l9_915=l9_876;
if (l9_914)
{
l9_913=float2((l9_915*float3(l9_913,1.0)).xy);
}
float2 l9_916=l9_913;
l9_874=l9_916;
float l9_917=l9_874.x;
int l9_918=l9_877.x;
bool l9_919=l9_883;
float l9_920=l9_884;
if ((l9_918==0)||(l9_918==3))
{
float l9_921=l9_917;
float l9_922=0.0;
float l9_923=1.0;
bool l9_924=l9_919;
float l9_925=l9_920;
float l9_926=fast::clamp(l9_921,l9_922,l9_923);
float l9_927=step(abs(l9_921-l9_926),9.9999997e-06);
l9_925*=(l9_927+((1.0-float(l9_924))*(1.0-l9_927)));
l9_921=l9_926;
l9_917=l9_921;
l9_920=l9_925;
}
l9_874.x=l9_917;
l9_884=l9_920;
float l9_928=l9_874.y;
int l9_929=l9_877.y;
bool l9_930=l9_883;
float l9_931=l9_884;
if ((l9_929==0)||(l9_929==3))
{
float l9_932=l9_928;
float l9_933=0.0;
float l9_934=1.0;
bool l9_935=l9_930;
float l9_936=l9_931;
float l9_937=fast::clamp(l9_932,l9_933,l9_934);
float l9_938=step(abs(l9_932-l9_937),9.9999997e-06);
l9_936*=(l9_938+((1.0-float(l9_935))*(1.0-l9_938)));
l9_932=l9_937;
l9_928=l9_932;
l9_931=l9_936;
}
l9_874.y=l9_928;
l9_884=l9_931;
float2 l9_939=l9_874;
int l9_940=l9_872;
int l9_941=l9_873;
float l9_942=l9_882;
float2 l9_943=l9_939;
int l9_944=l9_940;
int l9_945=l9_941;
float3 l9_946=float3(0.0);
if (l9_944==0)
{
l9_946=float3(l9_943,0.0);
}
else
{
if (l9_944==1)
{
l9_946=float3(l9_943.x,(l9_943.y*0.5)+(0.5-(float(l9_945)*0.5)),0.0);
}
else
{
l9_946=float3(l9_943,float(l9_945));
}
}
float3 l9_947=l9_946;
float3 l9_948=l9_947;
float4 l9_949=sc_set0.sheenColorTexture.sample(sc_set0.sheenColorTextureSmpSC,l9_948.xy,bias(l9_942));
float4 l9_950=l9_949;
if (l9_880)
{
l9_950=mix(l9_881,l9_950,float4(l9_884));
}
float4 l9_951=l9_950;
l9_865=l9_951;
float4 l9_952=l9_865;
float3 l9_953=l9_952.xyz;
float3 l9_954;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_954=float3(pow(l9_953.x,2.2),pow(l9_953.y,2.2),pow(l9_953.z,2.2));
}
else
{
l9_954=l9_953*l9_953;
}
float3 l9_955=l9_954;
l9_845*=l9_955;
}
if (N3_EnableSheenRoughnessTexture)
{
int l9_956=N3_SheenRoughnessTextureCoord;
float2 l9_957=tempGlobals.Surface_UVCoord0;
float2 l9_958=l9_957;
if (l9_956==0)
{
float2 l9_959=tempGlobals.Surface_UVCoord0;
l9_958=l9_959;
}
if (l9_956==1)
{
float2 l9_960=tempGlobals.Surface_UVCoord1;
l9_958=l9_960;
}
float2 l9_961=l9_958;
float2 l9_962=l9_961;
if (N3_EnableTextureTransform&&N3_SheenRoughnessTextureTransform)
{
float2 l9_963=l9_962;
float2 l9_964=N3_SheenRoughnessTextureOffset;
float2 l9_965=N3_SheenRoughnessTextureScale;
float l9_966=N3_SheenRoughnessTextureRotation;
float l9_967=radians(l9_966);
float3x3 l9_968=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_964.x,l9_964.y,1.0));
float3x3 l9_969=float3x3(float3(cos(l9_967),sin(l9_967),0.0),float3(-sin(l9_967),cos(l9_967),0.0),float3(0.0,0.0,1.0));
float3x3 l9_970=float3x3(float3(l9_965.x,0.0,0.0),float3(0.0,l9_965.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_971=(l9_968*l9_969)*l9_970;
float2 l9_972=(l9_971*float3(l9_963,1.0)).xy;
l9_962=l9_972;
}
float2 l9_973=l9_962;
float4 l9_974=float4(0.0);
int l9_975;
if ((int(sheenRoughnessTextureHasSwappedViews_tmp)!=0))
{
int l9_976=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_976=0;
}
else
{
l9_976=in.varStereoViewID;
}
int l9_977=l9_976;
l9_975=1-l9_977;
}
else
{
int l9_978=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_978=0;
}
else
{
l9_978=in.varStereoViewID;
}
int l9_979=l9_978;
l9_975=l9_979;
}
int l9_980=l9_975;
int l9_981=sheenRoughnessTextureLayout_tmp;
int l9_982=l9_980;
float2 l9_983=l9_973;
bool l9_984=(int(SC_USE_UV_TRANSFORM_sheenRoughnessTexture_tmp)!=0);
float3x3 l9_985=(*sc_set0.UserUniforms).sheenRoughnessTextureTransform;
int2 l9_986=int2(SC_SOFTWARE_WRAP_MODE_U_sheenRoughnessTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_sheenRoughnessTexture_tmp);
bool l9_987=(int(SC_USE_UV_MIN_MAX_sheenRoughnessTexture_tmp)!=0);
float4 l9_988=(*sc_set0.UserUniforms).sheenRoughnessTextureUvMinMax;
bool l9_989=(int(SC_USE_CLAMP_TO_BORDER_sheenRoughnessTexture_tmp)!=0);
float4 l9_990=(*sc_set0.UserUniforms).sheenRoughnessTextureBorderColor;
float l9_991=0.0;
bool l9_992=l9_989&&(!l9_987);
float l9_993=1.0;
float l9_994=l9_983.x;
int l9_995=l9_986.x;
if (l9_995==1)
{
l9_994=fract(l9_994);
}
else
{
if (l9_995==2)
{
float l9_996=fract(l9_994);
float l9_997=l9_994-l9_996;
float l9_998=step(0.25,fract(l9_997*0.5));
l9_994=mix(l9_996,1.0-l9_996,fast::clamp(l9_998,0.0,1.0));
}
}
l9_983.x=l9_994;
float l9_999=l9_983.y;
int l9_1000=l9_986.y;
if (l9_1000==1)
{
l9_999=fract(l9_999);
}
else
{
if (l9_1000==2)
{
float l9_1001=fract(l9_999);
float l9_1002=l9_999-l9_1001;
float l9_1003=step(0.25,fract(l9_1002*0.5));
l9_999=mix(l9_1001,1.0-l9_1001,fast::clamp(l9_1003,0.0,1.0));
}
}
l9_983.y=l9_999;
if (l9_987)
{
bool l9_1004=l9_989;
bool l9_1005;
if (l9_1004)
{
l9_1005=l9_986.x==3;
}
else
{
l9_1005=l9_1004;
}
float l9_1006=l9_983.x;
float l9_1007=l9_988.x;
float l9_1008=l9_988.z;
bool l9_1009=l9_1005;
float l9_1010=l9_993;
float l9_1011=fast::clamp(l9_1006,l9_1007,l9_1008);
float l9_1012=step(abs(l9_1006-l9_1011),9.9999997e-06);
l9_1010*=(l9_1012+((1.0-float(l9_1009))*(1.0-l9_1012)));
l9_1006=l9_1011;
l9_983.x=l9_1006;
l9_993=l9_1010;
bool l9_1013=l9_989;
bool l9_1014;
if (l9_1013)
{
l9_1014=l9_986.y==3;
}
else
{
l9_1014=l9_1013;
}
float l9_1015=l9_983.y;
float l9_1016=l9_988.y;
float l9_1017=l9_988.w;
bool l9_1018=l9_1014;
float l9_1019=l9_993;
float l9_1020=fast::clamp(l9_1015,l9_1016,l9_1017);
float l9_1021=step(abs(l9_1015-l9_1020),9.9999997e-06);
l9_1019*=(l9_1021+((1.0-float(l9_1018))*(1.0-l9_1021)));
l9_1015=l9_1020;
l9_983.y=l9_1015;
l9_993=l9_1019;
}
float2 l9_1022=l9_983;
bool l9_1023=l9_984;
float3x3 l9_1024=l9_985;
if (l9_1023)
{
l9_1022=float2((l9_1024*float3(l9_1022,1.0)).xy);
}
float2 l9_1025=l9_1022;
l9_983=l9_1025;
float l9_1026=l9_983.x;
int l9_1027=l9_986.x;
bool l9_1028=l9_992;
float l9_1029=l9_993;
if ((l9_1027==0)||(l9_1027==3))
{
float l9_1030=l9_1026;
float l9_1031=0.0;
float l9_1032=1.0;
bool l9_1033=l9_1028;
float l9_1034=l9_1029;
float l9_1035=fast::clamp(l9_1030,l9_1031,l9_1032);
float l9_1036=step(abs(l9_1030-l9_1035),9.9999997e-06);
l9_1034*=(l9_1036+((1.0-float(l9_1033))*(1.0-l9_1036)));
l9_1030=l9_1035;
l9_1026=l9_1030;
l9_1029=l9_1034;
}
l9_983.x=l9_1026;
l9_993=l9_1029;
float l9_1037=l9_983.y;
int l9_1038=l9_986.y;
bool l9_1039=l9_992;
float l9_1040=l9_993;
if ((l9_1038==0)||(l9_1038==3))
{
float l9_1041=l9_1037;
float l9_1042=0.0;
float l9_1043=1.0;
bool l9_1044=l9_1039;
float l9_1045=l9_1040;
float l9_1046=fast::clamp(l9_1041,l9_1042,l9_1043);
float l9_1047=step(abs(l9_1041-l9_1046),9.9999997e-06);
l9_1045*=(l9_1047+((1.0-float(l9_1044))*(1.0-l9_1047)));
l9_1041=l9_1046;
l9_1037=l9_1041;
l9_1040=l9_1045;
}
l9_983.y=l9_1037;
l9_993=l9_1040;
float2 l9_1048=l9_983;
int l9_1049=l9_981;
int l9_1050=l9_982;
float l9_1051=l9_991;
float2 l9_1052=l9_1048;
int l9_1053=l9_1049;
int l9_1054=l9_1050;
float3 l9_1055=float3(0.0);
if (l9_1053==0)
{
l9_1055=float3(l9_1052,0.0);
}
else
{
if (l9_1053==1)
{
l9_1055=float3(l9_1052.x,(l9_1052.y*0.5)+(0.5-(float(l9_1054)*0.5)),0.0);
}
else
{
l9_1055=float3(l9_1052,float(l9_1054));
}
}
float3 l9_1056=l9_1055;
float3 l9_1057=l9_1056;
float4 l9_1058=sc_set0.sheenRoughnessTexture.sample(sc_set0.sheenRoughnessTextureSmpSC,l9_1057.xy,bias(l9_1051));
float4 l9_1059=l9_1058;
if (l9_989)
{
l9_1059=mix(l9_990,l9_1059,float4(l9_993));
}
float4 l9_1060=l9_1059;
l9_974=l9_1060;
float4 l9_1061=l9_974;
float l9_1062=l9_1061.w;
float l9_1063;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_1063=pow(l9_1062,2.2);
}
else
{
l9_1063=l9_1062*l9_1062;
}
float l9_1064=l9_1063;
l9_846*=l9_1064;
}
l9_846=fast::max(l9_846,9.9999997e-05);
N3_SheenOut=float4(0.0);
float3 l9_1065=l9_843;
float3 l9_1066=(*sc_set1.sc_CameraUBO).sc_Camera.position;
float3 l9_1067=tempGlobals.SurfacePosition_WorldSpace;
float3 l9_1068=normalize(l9_1066-l9_1067);
float3 l9_1069=l9_1065;
float3 l9_1070=l9_1068;
float l9_1071=fast::clamp(dot(l9_1069,l9_1070),0.0,1.0);
float l9_1072=fast::max(l9_1071,9.9999997e-05);
float l9_1073=l9_846*l9_846;
float3 l9_1074=normalize(reflect(-l9_1068,l9_1065));
float l9_1075=l9_1072;
float3 l9_1076=l9_1074;
float l9_1077=l9_846;
float3 l9_1078=l9_845;
float l9_1079=l9_1077*4.0;
l9_1079=3.0+(((l9_1079-0.0)*2.0)/5.000001);
float l9_1080=l9_1077*l9_1077;
float l9_1081;
if (l9_1077<0.25)
{
l9_1081=(((-339.20001)*l9_1080)+(161.39999*l9_1077))-25.9;
}
else
{
l9_1081=(((-8.4799995)*l9_1080)+(14.3*l9_1077))-9.9499998;
}
float l9_1082=l9_1081;
float l9_1083;
if (l9_1077<0.25)
{
l9_1083=((44.0*l9_1080)-(23.700001*l9_1077))+3.26;
}
else
{
l9_1083=((1.97*l9_1080)-(3.27*l9_1077))+0.72000003;
}
float l9_1084=l9_1083;
float l9_1085=l9_1082;
float l9_1086=l9_1075;
float l9_1087=l9_1084;
float l9_1088;
if (l9_1077<0.25)
{
l9_1088=0.0;
}
else
{
l9_1088=0.1*(l9_1077-0.25);
}
float l9_1089=exp((l9_1085*l9_1086)+l9_1087)+l9_1088;
float l9_1090=3.1415927;
l9_1089=fast::clamp(l9_1089*l9_1090,0.0,1.0);
float3 l9_1091=l9_1076;
float l9_1092=l9_1079;
float3 l9_1093=float3(0.0);
float3 l9_1094=l9_1091;
float l9_1095=l9_1092;
float3 l9_1096=l9_1094;
float l9_1097=l9_1095;
float4 l9_1098=float4(0.0);
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_1099=l9_1096;
float3 l9_1100=float3(((-l9_1099.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_1099.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_1099.y,(l9_1099.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_1099.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
float3 l9_1101=l9_1100;
bool l9_1102=true;
float l9_1103=l9_1097;
float4 l9_1104;
if (l9_1102)
{
l9_1104=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1101,level(l9_1103));
}
else
{
l9_1104=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1101,bias(l9_1103));
}
float4 l9_1105=l9_1104;
l9_1098=l9_1105;
}
else
{
float3 l9_1106=l9_1096;
float l9_1107=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_1108=float2(0.0);
float l9_1109=l9_1106.x;
float l9_1110=-l9_1106.z;
float l9_1111=(l9_1109<0.0) ? (-1.0) : 1.0;
float l9_1112=l9_1111*acos(fast::clamp(l9_1110/length(float2(l9_1109,l9_1110)),-1.0,1.0));
l9_1108.x=l9_1112-1.5707964;
l9_1108.y=acos(l9_1106.y);
l9_1108/=float2(6.2831855,3.1415927);
l9_1108.y=1.0-l9_1108.y;
l9_1108.x+=(l9_1107/360.0);
l9_1108.x=fract((l9_1108.x+floor(l9_1108.x))+1.0);
float2 l9_1113=l9_1108;
float2 l9_1114=l9_1113;
if (SC_DEVICE_CLASS_tmp>=2)
{
float l9_1115=floor(l9_1097);
float l9_1116=ceil(l9_1097);
float l9_1117=l9_1097-l9_1115;
float2 l9_1118=l9_1114;
float2 l9_1119=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_1120=l9_1115;
float2 l9_1121=calcSeamlessPanoramicUvsForSampling(l9_1118,l9_1119,l9_1120);
float2 l9_1122=l9_1121;
float l9_1123=l9_1115;
float2 l9_1124=l9_1122;
float l9_1125=l9_1123;
int l9_1126;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_1127=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1127=0;
}
else
{
l9_1127=in.varStereoViewID;
}
int l9_1128=l9_1127;
l9_1126=1-l9_1128;
}
else
{
int l9_1129=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1129=0;
}
else
{
l9_1129=in.varStereoViewID;
}
int l9_1130=l9_1129;
l9_1126=l9_1130;
}
int l9_1131=l9_1126;
float2 l9_1132=l9_1124;
int l9_1133=sc_EnvmapSpecularLayout_tmp;
int l9_1134=l9_1131;
float l9_1135=l9_1125;
float2 l9_1136=l9_1132;
int l9_1137=l9_1133;
int l9_1138=l9_1134;
float3 l9_1139=float3(0.0);
if (l9_1137==0)
{
l9_1139=float3(l9_1136,0.0);
}
else
{
if (l9_1137==1)
{
l9_1139=float3(l9_1136.x,(l9_1136.y*0.5)+(0.5-(float(l9_1138)*0.5)),0.0);
}
else
{
l9_1139=float3(l9_1136,float(l9_1138));
}
}
float3 l9_1140=l9_1139;
float3 l9_1141=l9_1140;
float4 l9_1142=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_1141.xy,level(l9_1135));
float4 l9_1143=l9_1142;
float4 l9_1144=l9_1143;
float4 l9_1145=l9_1144;
float2 l9_1146=l9_1114;
float2 l9_1147=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_1148=l9_1116;
float2 l9_1149=calcSeamlessPanoramicUvsForSampling(l9_1146,l9_1147,l9_1148);
float2 l9_1150=l9_1149;
float l9_1151=l9_1116;
float2 l9_1152=l9_1150;
float l9_1153=l9_1151;
int l9_1154;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_1155=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1155=0;
}
else
{
l9_1155=in.varStereoViewID;
}
int l9_1156=l9_1155;
l9_1154=1-l9_1156;
}
else
{
int l9_1157=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1157=0;
}
else
{
l9_1157=in.varStereoViewID;
}
int l9_1158=l9_1157;
l9_1154=l9_1158;
}
int l9_1159=l9_1154;
float2 l9_1160=l9_1152;
int l9_1161=sc_EnvmapSpecularLayout_tmp;
int l9_1162=l9_1159;
float l9_1163=l9_1153;
float2 l9_1164=l9_1160;
int l9_1165=l9_1161;
int l9_1166=l9_1162;
float3 l9_1167=float3(0.0);
if (l9_1165==0)
{
l9_1167=float3(l9_1164,0.0);
}
else
{
if (l9_1165==1)
{
l9_1167=float3(l9_1164.x,(l9_1164.y*0.5)+(0.5-(float(l9_1166)*0.5)),0.0);
}
else
{
l9_1167=float3(l9_1164,float(l9_1166));
}
}
float3 l9_1168=l9_1167;
float3 l9_1169=l9_1168;
float4 l9_1170=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_1169.xy,level(l9_1163));
float4 l9_1171=l9_1170;
float4 l9_1172=l9_1171;
float4 l9_1173=l9_1172;
l9_1098=mix(l9_1145,l9_1173,float4(l9_1117));
}
else
{
float2 l9_1174=l9_1114;
float l9_1175=l9_1097;
float2 l9_1176=l9_1174;
float l9_1177=l9_1175;
int l9_1178;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_1179=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1179=0;
}
else
{
l9_1179=in.varStereoViewID;
}
int l9_1180=l9_1179;
l9_1178=1-l9_1180;
}
else
{
int l9_1181=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1181=0;
}
else
{
l9_1181=in.varStereoViewID;
}
int l9_1182=l9_1181;
l9_1178=l9_1182;
}
int l9_1183=l9_1178;
float2 l9_1184=l9_1176;
int l9_1185=sc_EnvmapSpecularLayout_tmp;
int l9_1186=l9_1183;
float l9_1187=l9_1177;
float2 l9_1188=l9_1184;
int l9_1189=l9_1185;
int l9_1190=l9_1186;
float3 l9_1191=float3(0.0);
if (l9_1189==0)
{
l9_1191=float3(l9_1188,0.0);
}
else
{
if (l9_1189==1)
{
l9_1191=float3(l9_1188.x,(l9_1188.y*0.5)+(0.5-(float(l9_1190)*0.5)),0.0);
}
else
{
l9_1191=float3(l9_1188,float(l9_1190));
}
}
float3 l9_1192=l9_1191;
float3 l9_1193=l9_1192;
float4 l9_1194=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_1193.xy,level(l9_1187));
float4 l9_1195=l9_1194;
float4 l9_1196=l9_1195;
l9_1098=l9_1196;
}
}
float4 l9_1197=l9_1098;
float3 l9_1198=l9_1197.xyz*(1.0/fast::max(l9_1197.w,0.0039215689));
float3 l9_1199=l9_1198;
float3 l9_1200=l9_1199*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_1200.x+=(*sc_set1.sc_CameraUBO).sc_UniformConstants.x;
float3 l9_1201=l9_1200;
l9_1093=l9_1201;
float3 l9_1202=l9_1093;
float3 l9_1203=l9_1202;
float3 l9_1204=(l9_1203*l9_1078)*l9_1089;
float3 l9_1205=N3_SheenOut.xyz+l9_1204;
N3_SheenOut=float4(l9_1205.x,l9_1205.y,l9_1205.z,N3_SheenOut.w);
float3 l9_1206=mix(N3_SheenOut.xyz,N3_SheenOut.xyz*l9_844.xyz,float3(l9_844.w));
N3_SheenOut=float4(l9_1206.x,l9_1206.y,l9_1206.z,N3_SheenOut.w);
float3 l9_1207=l9_845;
float3 l9_1208=l9_1065;
float3 l9_1209=l9_1068;
float l9_1210=l9_1072;
float l9_1211=l9_1073;
float3 l9_1212=float3(0.0);
int l9_1213=0;
l9_1213=sc_DirectionalLightsCount_tmp;
int l9_1214=l9_1213;
if (l9_1214>0)
{
float l9_1215;
int l9_1216=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_1217=0;
l9_1217=sc_DirectionalLightsCount_tmp;
int l9_1218=l9_1217;
if (l9_1216<l9_1218)
{
int l9_1219=l9_1216;
float3 l9_1220=float3(0.0);
if (l9_1219<sc_DirectionalLightsCount_tmp)
{
l9_1220=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_1219].color.xyz;
}
float3 l9_1221=l9_1220;
float3 l9_1222=l9_1221;
int l9_1223=l9_1216;
float l9_1224=0.0;
if (l9_1223<sc_DirectionalLightsCount_tmp)
{
l9_1224=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_1223].color.w;
}
float l9_1225=l9_1224;
float l9_1226=l9_1225;
l9_1222*=l9_1226;
l9_1222*=3.1415901;
int l9_1227=l9_1216;
float3 l9_1228=float3(0.0);
if (l9_1227<sc_DirectionalLightsCount_tmp)
{
l9_1228=-(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_1227].direction;
}
float3 l9_1229=l9_1228;
float3 l9_1230=normalize(-l9_1229);
float3 l9_1231=normalize(l9_1230+l9_1209);
float3 l9_1232=l9_1208;
float3 l9_1233=l9_1231;
float l9_1234=fast::clamp(dot(l9_1232,l9_1233),0.0,1.0);
float l9_1235=l9_1234;
float3 l9_1236=l9_1208;
float3 l9_1237=l9_1230;
float l9_1238=fast::clamp(dot(l9_1236,l9_1237),0.0,1.0);
float l9_1239=l9_1238;
float l9_1240=l9_1211;
float l9_1241=l9_1235;
float l9_1242=1.0/l9_1240;
float l9_1243=l9_1241*l9_1241;
float l9_1244=1.0-l9_1243;
float l9_1245=l9_1242;
float l9_1246=l9_1244;
float l9_1247=l9_1242*0.5;
if (l9_1246<=0.0)
{
l9_1215=0.0;
}
else
{
l9_1215=pow(l9_1246,l9_1247);
}
float l9_1248=l9_1215;
float l9_1249=3.1415927;
float l9_1250=((2.0+l9_1245)*l9_1248)/(2.0*l9_1249);
float l9_1251=l9_1250;
float l9_1252=l9_1210;
float l9_1253=l9_1239;
float l9_1254=1.0/(4.0*((l9_1253+l9_1252)-(l9_1253*l9_1252)));
float l9_1255=l9_1254;
l9_1212+=((((l9_1222*l9_1207)*l9_1251)*l9_1255)*l9_1239);
l9_1216++;
continue;
}
else
{
break;
}
}
}
int l9_1256=0;
l9_1256=sc_PointLightsCount_tmp;
int l9_1257=l9_1256;
if (l9_1257>0)
{
float l9_1258;
int l9_1259=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_1260=0;
l9_1260=sc_PointLightsCount_tmp;
int l9_1261=l9_1260;
if (l9_1259<l9_1261)
{
int l9_1262=l9_1259;
float3 l9_1263=float3(0.0);
if (l9_1262<sc_PointLightsCount_tmp)
{
l9_1263=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1262].color.xyz;
}
float3 l9_1264=l9_1263;
float3 l9_1265=l9_1264;
int l9_1266=l9_1259;
float l9_1267=0.0;
if (l9_1266<sc_PointLightsCount_tmp)
{
l9_1267=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1266].color.w;
}
float l9_1268=l9_1267;
float l9_1269=l9_1268;
l9_1265*=l9_1269;
l9_1265*=3.1415901;
int l9_1270=l9_1259;
float3 l9_1271=float3(0.0);
if (l9_1270<sc_PointLightsCount_tmp)
{
l9_1271=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1270].position;
}
float3 l9_1272=l9_1271;
float3 l9_1273=l9_1272;
float3 l9_1274=tempGlobals.SurfacePosition_WorldSpace;
float3 l9_1275=normalize(l9_1273-l9_1274);
float3 l9_1276=normalize(l9_1275+l9_1209);
float3 l9_1277=l9_1208;
float3 l9_1278=l9_1276;
float l9_1279=fast::clamp(dot(l9_1277,l9_1278),0.0,1.0);
float l9_1280=l9_1279;
float3 l9_1281=l9_1208;
float3 l9_1282=l9_1275;
float l9_1283=fast::clamp(dot(l9_1281,l9_1282),0.0,1.0);
float l9_1284=l9_1283;
float l9_1285=l9_1211;
float l9_1286=l9_1280;
float l9_1287=1.0/l9_1285;
float l9_1288=l9_1286*l9_1286;
float l9_1289=1.0-l9_1288;
float l9_1290=l9_1287;
float l9_1291=l9_1289;
float l9_1292=l9_1287*0.5;
if (l9_1291<=0.0)
{
l9_1258=0.0;
}
else
{
l9_1258=pow(l9_1291,l9_1292);
}
float l9_1293=l9_1258;
float l9_1294=3.1415927;
float l9_1295=((2.0+l9_1290)*l9_1293)/(2.0*l9_1294);
float l9_1296=l9_1295;
float l9_1297=l9_1210;
float l9_1298=l9_1284;
float l9_1299=1.0/(4.0*((l9_1298+l9_1297)-(l9_1298*l9_1297)));
float l9_1300=l9_1299;
l9_1212+=((((l9_1265*l9_1207)*l9_1296)*l9_1300)*l9_1284);
l9_1259++;
continue;
}
else
{
break;
}
}
}
int l9_1301=0;
l9_1301=sc_AmbientLightsCount_tmp;
int l9_1302=l9_1301;
if (l9_1302>0)
{
int l9_1303=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
int l9_1304=0;
l9_1304=sc_AmbientLightsCount_tmp;
int l9_1305=l9_1304;
if (l9_1303<l9_1305)
{
int l9_1306=l9_1303;
float3 l9_1307=float3(0.0);
if (l9_1306<sc_AmbientLightsCount_tmp)
{
l9_1307=(*sc_set1.sc_LightingUBO).sc_AmbientLights[l9_1306].color;
}
float3 l9_1308=l9_1307;
float3 l9_1309=l9_1308;
int l9_1310=l9_1303;
float l9_1311=0.0;
if (l9_1310<sc_AmbientLightsCount_tmp)
{
l9_1311=(*sc_set1.sc_LightingUBO).sc_AmbientLights[l9_1310].intensity;
}
float l9_1312=l9_1311;
float l9_1313=l9_1312;
l9_1309*=l9_1313;
l9_1309/=float3(3.1415901);
l9_1212+=(l9_1309*l9_1207);
l9_1303++;
continue;
}
else
{
break;
}
}
}
float3 l9_1314=l9_1212;
float3 l9_1315=N3_SheenOut.xyz+l9_1314;
N3_SheenOut=float4(l9_1315.x,l9_1315.y,l9_1315.z,N3_SheenOut.w);
float3 l9_1316=l9_845;
float3 l9_1317=l9_1316;
float l9_1318=fast::max(fast::max(l9_1317.x,l9_1317.y),l9_1317.z);
float l9_1319=1.0-(l9_1318*0.15700001);
N3_SheenOut.w=l9_1319;
}
if (N3_ClearcoatEnable)
{
N3_ClearcoatBase=1.0;
N3_ClearcoatRoughness=1.0;
N3_ClearcoatNormal=float3(0.0,0.0,1.0);
if (N3_EnableClearcoatTexture)
{
int l9_1320=N3_ClearcoatTextureCoord;
float2 l9_1321=tempGlobals.Surface_UVCoord0;
float2 l9_1322=l9_1321;
if (l9_1320==0)
{
float2 l9_1323=tempGlobals.Surface_UVCoord0;
l9_1322=l9_1323;
}
if (l9_1320==1)
{
float2 l9_1324=tempGlobals.Surface_UVCoord1;
l9_1322=l9_1324;
}
float2 l9_1325=l9_1322;
float2 l9_1326=l9_1325;
if (N3_EnableTextureTransform&&N3_ClearcoatTextureTransform)
{
float2 l9_1327=l9_1326;
float2 l9_1328=N3_ClearcoatTextureOffset;
float2 l9_1329=N3_ClearcoatTextureScale;
float l9_1330=N3_ClearcoatTextureRotation;
float l9_1331=radians(l9_1330);
float3x3 l9_1332=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_1328.x,l9_1328.y,1.0));
float3x3 l9_1333=float3x3(float3(cos(l9_1331),sin(l9_1331),0.0),float3(-sin(l9_1331),cos(l9_1331),0.0),float3(0.0,0.0,1.0));
float3x3 l9_1334=float3x3(float3(l9_1329.x,0.0,0.0),float3(0.0,l9_1329.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_1335=(l9_1332*l9_1333)*l9_1334;
float2 l9_1336=(l9_1335*float3(l9_1327,1.0)).xy;
l9_1326=l9_1336;
}
float2 l9_1337=l9_1326;
float4 l9_1338=float4(0.0);
int l9_1339;
if ((int(clearcoatTextureHasSwappedViews_tmp)!=0))
{
int l9_1340=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1340=0;
}
else
{
l9_1340=in.varStereoViewID;
}
int l9_1341=l9_1340;
l9_1339=1-l9_1341;
}
else
{
int l9_1342=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1342=0;
}
else
{
l9_1342=in.varStereoViewID;
}
int l9_1343=l9_1342;
l9_1339=l9_1343;
}
int l9_1344=l9_1339;
int l9_1345=clearcoatTextureLayout_tmp;
int l9_1346=l9_1344;
float2 l9_1347=l9_1337;
bool l9_1348=(int(SC_USE_UV_TRANSFORM_clearcoatTexture_tmp)!=0);
float3x3 l9_1349=(*sc_set0.UserUniforms).clearcoatTextureTransform;
int2 l9_1350=int2(SC_SOFTWARE_WRAP_MODE_U_clearcoatTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_clearcoatTexture_tmp);
bool l9_1351=(int(SC_USE_UV_MIN_MAX_clearcoatTexture_tmp)!=0);
float4 l9_1352=(*sc_set0.UserUniforms).clearcoatTextureUvMinMax;
bool l9_1353=(int(SC_USE_CLAMP_TO_BORDER_clearcoatTexture_tmp)!=0);
float4 l9_1354=(*sc_set0.UserUniforms).clearcoatTextureBorderColor;
float l9_1355=0.0;
bool l9_1356=l9_1353&&(!l9_1351);
float l9_1357=1.0;
float l9_1358=l9_1347.x;
int l9_1359=l9_1350.x;
if (l9_1359==1)
{
l9_1358=fract(l9_1358);
}
else
{
if (l9_1359==2)
{
float l9_1360=fract(l9_1358);
float l9_1361=l9_1358-l9_1360;
float l9_1362=step(0.25,fract(l9_1361*0.5));
l9_1358=mix(l9_1360,1.0-l9_1360,fast::clamp(l9_1362,0.0,1.0));
}
}
l9_1347.x=l9_1358;
float l9_1363=l9_1347.y;
int l9_1364=l9_1350.y;
if (l9_1364==1)
{
l9_1363=fract(l9_1363);
}
else
{
if (l9_1364==2)
{
float l9_1365=fract(l9_1363);
float l9_1366=l9_1363-l9_1365;
float l9_1367=step(0.25,fract(l9_1366*0.5));
l9_1363=mix(l9_1365,1.0-l9_1365,fast::clamp(l9_1367,0.0,1.0));
}
}
l9_1347.y=l9_1363;
if (l9_1351)
{
bool l9_1368=l9_1353;
bool l9_1369;
if (l9_1368)
{
l9_1369=l9_1350.x==3;
}
else
{
l9_1369=l9_1368;
}
float l9_1370=l9_1347.x;
float l9_1371=l9_1352.x;
float l9_1372=l9_1352.z;
bool l9_1373=l9_1369;
float l9_1374=l9_1357;
float l9_1375=fast::clamp(l9_1370,l9_1371,l9_1372);
float l9_1376=step(abs(l9_1370-l9_1375),9.9999997e-06);
l9_1374*=(l9_1376+((1.0-float(l9_1373))*(1.0-l9_1376)));
l9_1370=l9_1375;
l9_1347.x=l9_1370;
l9_1357=l9_1374;
bool l9_1377=l9_1353;
bool l9_1378;
if (l9_1377)
{
l9_1378=l9_1350.y==3;
}
else
{
l9_1378=l9_1377;
}
float l9_1379=l9_1347.y;
float l9_1380=l9_1352.y;
float l9_1381=l9_1352.w;
bool l9_1382=l9_1378;
float l9_1383=l9_1357;
float l9_1384=fast::clamp(l9_1379,l9_1380,l9_1381);
float l9_1385=step(abs(l9_1379-l9_1384),9.9999997e-06);
l9_1383*=(l9_1385+((1.0-float(l9_1382))*(1.0-l9_1385)));
l9_1379=l9_1384;
l9_1347.y=l9_1379;
l9_1357=l9_1383;
}
float2 l9_1386=l9_1347;
bool l9_1387=l9_1348;
float3x3 l9_1388=l9_1349;
if (l9_1387)
{
l9_1386=float2((l9_1388*float3(l9_1386,1.0)).xy);
}
float2 l9_1389=l9_1386;
l9_1347=l9_1389;
float l9_1390=l9_1347.x;
int l9_1391=l9_1350.x;
bool l9_1392=l9_1356;
float l9_1393=l9_1357;
if ((l9_1391==0)||(l9_1391==3))
{
float l9_1394=l9_1390;
float l9_1395=0.0;
float l9_1396=1.0;
bool l9_1397=l9_1392;
float l9_1398=l9_1393;
float l9_1399=fast::clamp(l9_1394,l9_1395,l9_1396);
float l9_1400=step(abs(l9_1394-l9_1399),9.9999997e-06);
l9_1398*=(l9_1400+((1.0-float(l9_1397))*(1.0-l9_1400)));
l9_1394=l9_1399;
l9_1390=l9_1394;
l9_1393=l9_1398;
}
l9_1347.x=l9_1390;
l9_1357=l9_1393;
float l9_1401=l9_1347.y;
int l9_1402=l9_1350.y;
bool l9_1403=l9_1356;
float l9_1404=l9_1357;
if ((l9_1402==0)||(l9_1402==3))
{
float l9_1405=l9_1401;
float l9_1406=0.0;
float l9_1407=1.0;
bool l9_1408=l9_1403;
float l9_1409=l9_1404;
float l9_1410=fast::clamp(l9_1405,l9_1406,l9_1407);
float l9_1411=step(abs(l9_1405-l9_1410),9.9999997e-06);
l9_1409*=(l9_1411+((1.0-float(l9_1408))*(1.0-l9_1411)));
l9_1405=l9_1410;
l9_1401=l9_1405;
l9_1404=l9_1409;
}
l9_1347.y=l9_1401;
l9_1357=l9_1404;
float2 l9_1412=l9_1347;
int l9_1413=l9_1345;
int l9_1414=l9_1346;
float l9_1415=l9_1355;
float2 l9_1416=l9_1412;
int l9_1417=l9_1413;
int l9_1418=l9_1414;
float3 l9_1419=float3(0.0);
if (l9_1417==0)
{
l9_1419=float3(l9_1416,0.0);
}
else
{
if (l9_1417==1)
{
l9_1419=float3(l9_1416.x,(l9_1416.y*0.5)+(0.5-(float(l9_1418)*0.5)),0.0);
}
else
{
l9_1419=float3(l9_1416,float(l9_1418));
}
}
float3 l9_1420=l9_1419;
float3 l9_1421=l9_1420;
float4 l9_1422=sc_set0.clearcoatTexture.sample(sc_set0.clearcoatTextureSmpSC,l9_1421.xy,bias(l9_1415));
float4 l9_1423=l9_1422;
if (l9_1353)
{
l9_1423=mix(l9_1354,l9_1423,float4(l9_1357));
}
float4 l9_1424=l9_1423;
l9_1338=l9_1424;
float4 l9_1425=l9_1338;
float l9_1426=l9_1425.x;
float l9_1427;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_1427=pow(l9_1426,2.2);
}
else
{
l9_1427=l9_1426*l9_1426;
}
float l9_1428=l9_1427;
N3_ClearcoatBase=l9_1428;
}
N3_ClearcoatBase*=N3_ClearcoatFactor;
if (N3_EnableClearCoatRoughnessTexture)
{
int l9_1429=N3_ClearcoatRoughnessTextureCoord;
float2 l9_1430=tempGlobals.Surface_UVCoord0;
float2 l9_1431=l9_1430;
if (l9_1429==0)
{
float2 l9_1432=tempGlobals.Surface_UVCoord0;
l9_1431=l9_1432;
}
if (l9_1429==1)
{
float2 l9_1433=tempGlobals.Surface_UVCoord1;
l9_1431=l9_1433;
}
float2 l9_1434=l9_1431;
float2 l9_1435=l9_1434;
if (N3_EnableTextureTransform&&N3_ClearcoatRoughnessTextureTransform)
{
float2 l9_1436=l9_1435;
float2 l9_1437=N3_ClearcoatRoughnessTextureOffset;
float2 l9_1438=N3_ClearcoatRoughnessTextureScale;
float l9_1439=N3_ClearcoatRoughnessTextureRotation;
float l9_1440=radians(l9_1439);
float3x3 l9_1441=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_1437.x,l9_1437.y,1.0));
float3x3 l9_1442=float3x3(float3(cos(l9_1440),sin(l9_1440),0.0),float3(-sin(l9_1440),cos(l9_1440),0.0),float3(0.0,0.0,1.0));
float3x3 l9_1443=float3x3(float3(l9_1438.x,0.0,0.0),float3(0.0,l9_1438.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_1444=(l9_1441*l9_1442)*l9_1443;
float2 l9_1445=(l9_1444*float3(l9_1436,1.0)).xy;
l9_1435=l9_1445;
}
float2 l9_1446=l9_1435;
float4 l9_1447=float4(0.0);
int l9_1448;
if ((int(clearcoatRoughnessTextureHasSwappedViews_tmp)!=0))
{
int l9_1449=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1449=0;
}
else
{
l9_1449=in.varStereoViewID;
}
int l9_1450=l9_1449;
l9_1448=1-l9_1450;
}
else
{
int l9_1451=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1451=0;
}
else
{
l9_1451=in.varStereoViewID;
}
int l9_1452=l9_1451;
l9_1448=l9_1452;
}
int l9_1453=l9_1448;
int l9_1454=clearcoatRoughnessTextureLayout_tmp;
int l9_1455=l9_1453;
float2 l9_1456=l9_1446;
bool l9_1457=(int(SC_USE_UV_TRANSFORM_clearcoatRoughnessTexture_tmp)!=0);
float3x3 l9_1458=(*sc_set0.UserUniforms).clearcoatRoughnessTextureTransform;
int2 l9_1459=int2(SC_SOFTWARE_WRAP_MODE_U_clearcoatRoughnessTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_clearcoatRoughnessTexture_tmp);
bool l9_1460=(int(SC_USE_UV_MIN_MAX_clearcoatRoughnessTexture_tmp)!=0);
float4 l9_1461=(*sc_set0.UserUniforms).clearcoatRoughnessTextureUvMinMax;
bool l9_1462=(int(SC_USE_CLAMP_TO_BORDER_clearcoatRoughnessTexture_tmp)!=0);
float4 l9_1463=(*sc_set0.UserUniforms).clearcoatRoughnessTextureBorderColor;
float l9_1464=0.0;
bool l9_1465=l9_1462&&(!l9_1460);
float l9_1466=1.0;
float l9_1467=l9_1456.x;
int l9_1468=l9_1459.x;
if (l9_1468==1)
{
l9_1467=fract(l9_1467);
}
else
{
if (l9_1468==2)
{
float l9_1469=fract(l9_1467);
float l9_1470=l9_1467-l9_1469;
float l9_1471=step(0.25,fract(l9_1470*0.5));
l9_1467=mix(l9_1469,1.0-l9_1469,fast::clamp(l9_1471,0.0,1.0));
}
}
l9_1456.x=l9_1467;
float l9_1472=l9_1456.y;
int l9_1473=l9_1459.y;
if (l9_1473==1)
{
l9_1472=fract(l9_1472);
}
else
{
if (l9_1473==2)
{
float l9_1474=fract(l9_1472);
float l9_1475=l9_1472-l9_1474;
float l9_1476=step(0.25,fract(l9_1475*0.5));
l9_1472=mix(l9_1474,1.0-l9_1474,fast::clamp(l9_1476,0.0,1.0));
}
}
l9_1456.y=l9_1472;
if (l9_1460)
{
bool l9_1477=l9_1462;
bool l9_1478;
if (l9_1477)
{
l9_1478=l9_1459.x==3;
}
else
{
l9_1478=l9_1477;
}
float l9_1479=l9_1456.x;
float l9_1480=l9_1461.x;
float l9_1481=l9_1461.z;
bool l9_1482=l9_1478;
float l9_1483=l9_1466;
float l9_1484=fast::clamp(l9_1479,l9_1480,l9_1481);
float l9_1485=step(abs(l9_1479-l9_1484),9.9999997e-06);
l9_1483*=(l9_1485+((1.0-float(l9_1482))*(1.0-l9_1485)));
l9_1479=l9_1484;
l9_1456.x=l9_1479;
l9_1466=l9_1483;
bool l9_1486=l9_1462;
bool l9_1487;
if (l9_1486)
{
l9_1487=l9_1459.y==3;
}
else
{
l9_1487=l9_1486;
}
float l9_1488=l9_1456.y;
float l9_1489=l9_1461.y;
float l9_1490=l9_1461.w;
bool l9_1491=l9_1487;
float l9_1492=l9_1466;
float l9_1493=fast::clamp(l9_1488,l9_1489,l9_1490);
float l9_1494=step(abs(l9_1488-l9_1493),9.9999997e-06);
l9_1492*=(l9_1494+((1.0-float(l9_1491))*(1.0-l9_1494)));
l9_1488=l9_1493;
l9_1456.y=l9_1488;
l9_1466=l9_1492;
}
float2 l9_1495=l9_1456;
bool l9_1496=l9_1457;
float3x3 l9_1497=l9_1458;
if (l9_1496)
{
l9_1495=float2((l9_1497*float3(l9_1495,1.0)).xy);
}
float2 l9_1498=l9_1495;
l9_1456=l9_1498;
float l9_1499=l9_1456.x;
int l9_1500=l9_1459.x;
bool l9_1501=l9_1465;
float l9_1502=l9_1466;
if ((l9_1500==0)||(l9_1500==3))
{
float l9_1503=l9_1499;
float l9_1504=0.0;
float l9_1505=1.0;
bool l9_1506=l9_1501;
float l9_1507=l9_1502;
float l9_1508=fast::clamp(l9_1503,l9_1504,l9_1505);
float l9_1509=step(abs(l9_1503-l9_1508),9.9999997e-06);
l9_1507*=(l9_1509+((1.0-float(l9_1506))*(1.0-l9_1509)));
l9_1503=l9_1508;
l9_1499=l9_1503;
l9_1502=l9_1507;
}
l9_1456.x=l9_1499;
l9_1466=l9_1502;
float l9_1510=l9_1456.y;
int l9_1511=l9_1459.y;
bool l9_1512=l9_1465;
float l9_1513=l9_1466;
if ((l9_1511==0)||(l9_1511==3))
{
float l9_1514=l9_1510;
float l9_1515=0.0;
float l9_1516=1.0;
bool l9_1517=l9_1512;
float l9_1518=l9_1513;
float l9_1519=fast::clamp(l9_1514,l9_1515,l9_1516);
float l9_1520=step(abs(l9_1514-l9_1519),9.9999997e-06);
l9_1518*=(l9_1520+((1.0-float(l9_1517))*(1.0-l9_1520)));
l9_1514=l9_1519;
l9_1510=l9_1514;
l9_1513=l9_1518;
}
l9_1456.y=l9_1510;
l9_1466=l9_1513;
float2 l9_1521=l9_1456;
int l9_1522=l9_1454;
int l9_1523=l9_1455;
float l9_1524=l9_1464;
float2 l9_1525=l9_1521;
int l9_1526=l9_1522;
int l9_1527=l9_1523;
float3 l9_1528=float3(0.0);
if (l9_1526==0)
{
l9_1528=float3(l9_1525,0.0);
}
else
{
if (l9_1526==1)
{
l9_1528=float3(l9_1525.x,(l9_1525.y*0.5)+(0.5-(float(l9_1527)*0.5)),0.0);
}
else
{
l9_1528=float3(l9_1525,float(l9_1527));
}
}
float3 l9_1529=l9_1528;
float3 l9_1530=l9_1529;
float4 l9_1531=sc_set0.clearcoatRoughnessTexture.sample(sc_set0.clearcoatRoughnessTextureSmpSC,l9_1530.xy,bias(l9_1524));
float4 l9_1532=l9_1531;
if (l9_1462)
{
l9_1532=mix(l9_1463,l9_1532,float4(l9_1466));
}
float4 l9_1533=l9_1532;
l9_1447=l9_1533;
float4 l9_1534=l9_1447;
float l9_1535=l9_1534.y;
float l9_1536;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_1536=pow(l9_1535,2.2);
}
else
{
l9_1536=l9_1535*l9_1535;
}
float l9_1537=l9_1536;
N3_ClearcoatRoughness=l9_1537;
}
N3_ClearcoatRoughness*=N3_ClearcoatRoughnessFactor;
if (N3_EnableClearCoatNormalTexture)
{
int l9_1538=N3_ClearcoatNormalMapCoord;
float2 l9_1539=tempGlobals.Surface_UVCoord0;
float2 l9_1540=l9_1539;
if (l9_1538==0)
{
float2 l9_1541=tempGlobals.Surface_UVCoord0;
l9_1540=l9_1541;
}
if (l9_1538==1)
{
float2 l9_1542=tempGlobals.Surface_UVCoord1;
l9_1540=l9_1542;
}
float2 l9_1543=l9_1540;
float2 l9_1544=l9_1543;
if (N3_EnableTextureTransform&&N3_ClearcoatNormalTextureTransform)
{
float2 l9_1545=l9_1544;
float2 l9_1546=N3_ClearcoatNormalTextureOffset;
float2 l9_1547=N3_ClearcoatNormalTextureScale;
float l9_1548=N3_ClearcoatNormalTextureRotation;
float l9_1549=radians(l9_1548);
float3x3 l9_1550=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_1546.x,l9_1546.y,1.0));
float3x3 l9_1551=float3x3(float3(cos(l9_1549),sin(l9_1549),0.0),float3(-sin(l9_1549),cos(l9_1549),0.0),float3(0.0,0.0,1.0));
float3x3 l9_1552=float3x3(float3(l9_1547.x,0.0,0.0),float3(0.0,l9_1547.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_1553=(l9_1550*l9_1551)*l9_1552;
float2 l9_1554=(l9_1553*float3(l9_1545,1.0)).xy;
l9_1544=l9_1554;
}
float2 l9_1555=l9_1544;
float4 l9_1556=float4(0.0);
int l9_1557;
if ((int(clearcoatNormalTextureHasSwappedViews_tmp)!=0))
{
int l9_1558=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1558=0;
}
else
{
l9_1558=in.varStereoViewID;
}
int l9_1559=l9_1558;
l9_1557=1-l9_1559;
}
else
{
int l9_1560=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1560=0;
}
else
{
l9_1560=in.varStereoViewID;
}
int l9_1561=l9_1560;
l9_1557=l9_1561;
}
int l9_1562=l9_1557;
int l9_1563=clearcoatNormalTextureLayout_tmp;
int l9_1564=l9_1562;
float2 l9_1565=l9_1555;
bool l9_1566=(int(SC_USE_UV_TRANSFORM_clearcoatNormalTexture_tmp)!=0);
float3x3 l9_1567=(*sc_set0.UserUniforms).clearcoatNormalTextureTransform;
int2 l9_1568=int2(SC_SOFTWARE_WRAP_MODE_U_clearcoatNormalTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_clearcoatNormalTexture_tmp);
bool l9_1569=(int(SC_USE_UV_MIN_MAX_clearcoatNormalTexture_tmp)!=0);
float4 l9_1570=(*sc_set0.UserUniforms).clearcoatNormalTextureUvMinMax;
bool l9_1571=(int(SC_USE_CLAMP_TO_BORDER_clearcoatNormalTexture_tmp)!=0);
float4 l9_1572=(*sc_set0.UserUniforms).clearcoatNormalTextureBorderColor;
float l9_1573=0.0;
bool l9_1574=l9_1571&&(!l9_1569);
float l9_1575=1.0;
float l9_1576=l9_1565.x;
int l9_1577=l9_1568.x;
if (l9_1577==1)
{
l9_1576=fract(l9_1576);
}
else
{
if (l9_1577==2)
{
float l9_1578=fract(l9_1576);
float l9_1579=l9_1576-l9_1578;
float l9_1580=step(0.25,fract(l9_1579*0.5));
l9_1576=mix(l9_1578,1.0-l9_1578,fast::clamp(l9_1580,0.0,1.0));
}
}
l9_1565.x=l9_1576;
float l9_1581=l9_1565.y;
int l9_1582=l9_1568.y;
if (l9_1582==1)
{
l9_1581=fract(l9_1581);
}
else
{
if (l9_1582==2)
{
float l9_1583=fract(l9_1581);
float l9_1584=l9_1581-l9_1583;
float l9_1585=step(0.25,fract(l9_1584*0.5));
l9_1581=mix(l9_1583,1.0-l9_1583,fast::clamp(l9_1585,0.0,1.0));
}
}
l9_1565.y=l9_1581;
if (l9_1569)
{
bool l9_1586=l9_1571;
bool l9_1587;
if (l9_1586)
{
l9_1587=l9_1568.x==3;
}
else
{
l9_1587=l9_1586;
}
float l9_1588=l9_1565.x;
float l9_1589=l9_1570.x;
float l9_1590=l9_1570.z;
bool l9_1591=l9_1587;
float l9_1592=l9_1575;
float l9_1593=fast::clamp(l9_1588,l9_1589,l9_1590);
float l9_1594=step(abs(l9_1588-l9_1593),9.9999997e-06);
l9_1592*=(l9_1594+((1.0-float(l9_1591))*(1.0-l9_1594)));
l9_1588=l9_1593;
l9_1565.x=l9_1588;
l9_1575=l9_1592;
bool l9_1595=l9_1571;
bool l9_1596;
if (l9_1595)
{
l9_1596=l9_1568.y==3;
}
else
{
l9_1596=l9_1595;
}
float l9_1597=l9_1565.y;
float l9_1598=l9_1570.y;
float l9_1599=l9_1570.w;
bool l9_1600=l9_1596;
float l9_1601=l9_1575;
float l9_1602=fast::clamp(l9_1597,l9_1598,l9_1599);
float l9_1603=step(abs(l9_1597-l9_1602),9.9999997e-06);
l9_1601*=(l9_1603+((1.0-float(l9_1600))*(1.0-l9_1603)));
l9_1597=l9_1602;
l9_1565.y=l9_1597;
l9_1575=l9_1601;
}
float2 l9_1604=l9_1565;
bool l9_1605=l9_1566;
float3x3 l9_1606=l9_1567;
if (l9_1605)
{
l9_1604=float2((l9_1606*float3(l9_1604,1.0)).xy);
}
float2 l9_1607=l9_1604;
l9_1565=l9_1607;
float l9_1608=l9_1565.x;
int l9_1609=l9_1568.x;
bool l9_1610=l9_1574;
float l9_1611=l9_1575;
if ((l9_1609==0)||(l9_1609==3))
{
float l9_1612=l9_1608;
float l9_1613=0.0;
float l9_1614=1.0;
bool l9_1615=l9_1610;
float l9_1616=l9_1611;
float l9_1617=fast::clamp(l9_1612,l9_1613,l9_1614);
float l9_1618=step(abs(l9_1612-l9_1617),9.9999997e-06);
l9_1616*=(l9_1618+((1.0-float(l9_1615))*(1.0-l9_1618)));
l9_1612=l9_1617;
l9_1608=l9_1612;
l9_1611=l9_1616;
}
l9_1565.x=l9_1608;
l9_1575=l9_1611;
float l9_1619=l9_1565.y;
int l9_1620=l9_1568.y;
bool l9_1621=l9_1574;
float l9_1622=l9_1575;
if ((l9_1620==0)||(l9_1620==3))
{
float l9_1623=l9_1619;
float l9_1624=0.0;
float l9_1625=1.0;
bool l9_1626=l9_1621;
float l9_1627=l9_1622;
float l9_1628=fast::clamp(l9_1623,l9_1624,l9_1625);
float l9_1629=step(abs(l9_1623-l9_1628),9.9999997e-06);
l9_1627*=(l9_1629+((1.0-float(l9_1626))*(1.0-l9_1629)));
l9_1623=l9_1628;
l9_1619=l9_1623;
l9_1622=l9_1627;
}
l9_1565.y=l9_1619;
l9_1575=l9_1622;
float2 l9_1630=l9_1565;
int l9_1631=l9_1563;
int l9_1632=l9_1564;
float l9_1633=l9_1573;
float2 l9_1634=l9_1630;
int l9_1635=l9_1631;
int l9_1636=l9_1632;
float3 l9_1637=float3(0.0);
if (l9_1635==0)
{
l9_1637=float3(l9_1634,0.0);
}
else
{
if (l9_1635==1)
{
l9_1637=float3(l9_1634.x,(l9_1634.y*0.5)+(0.5-(float(l9_1636)*0.5)),0.0);
}
else
{
l9_1637=float3(l9_1634,float(l9_1636));
}
}
float3 l9_1638=l9_1637;
float3 l9_1639=l9_1638;
float4 l9_1640=sc_set0.clearcoatNormalTexture.sample(sc_set0.clearcoatNormalTextureSmpSC,l9_1639.xy,bias(l9_1633));
float4 l9_1641=l9_1640;
if (l9_1571)
{
l9_1641=mix(l9_1572,l9_1641,float4(l9_1575));
}
float4 l9_1642=l9_1641;
l9_1556=l9_1642;
float4 l9_1643=l9_1556;
N3_ClearcoatNormal=l9_1643.xyz;
N3_ClearcoatNormal*=0.9921875;
}
}
l9_278=N3_BaseColor;
l9_279=N3_Opacity;
l9_280=N3_Normal;
l9_281=N3_Emissive;
l9_282=N3_Metallic;
l9_283=N3_Roughness;
l9_284=N3_Occlusion;
l9_285=N3_Background;
l9_286=N3_SheenOut;
l9_287=N3_ClearcoatBase;
l9_288=N3_ClearcoatNormal;
l9_289=N3_ClearcoatRoughness;
l9_226=l9_278;
l9_227=l9_279;
l9_228=l9_280;
l9_229=l9_281;
l9_230=l9_282;
l9_231=l9_283;
l9_232=l9_284;
l9_233=l9_285;
l9_234=l9_286;
l9_235=l9_287;
l9_236=l9_288;
l9_237=l9_289;
float4 l9_1644=float4(0.0);
float3 l9_1645=l9_226;
float l9_1646=l9_227;
float3 l9_1647=l9_228;
float3 l9_1648=l9_229;
float l9_1649=l9_230;
float l9_1650=l9_231;
float3 l9_1651=l9_232.xyz;
float3 l9_1652=(*sc_set0.UserUniforms).Port_SpecularAO_N036;
ssGlobals l9_1653=param_3;
if (!(int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
l9_1653.BumpedNormal=l9_1647;
}
l9_1646=fast::clamp(l9_1646,0.0,1.0);
float l9_1654=l9_1646;
if (sc_BlendMode_tmp==8)
{
if (l9_1654<(*sc_set0.UserUniforms).alphaTestThreshold)
{
discard_fragment();
}
}
if ((int(ENABLE_STIPPLE_PATTERN_TEST_tmp)!=0))
{
float4 l9_1655=gl_FragCoord;
float2 l9_1656=floor(mod(l9_1655.xy,float2(4.0)));
float l9_1657=(mod(dot(l9_1656,float2(4.0,1.0))*9.0,16.0)+1.0)/17.0;
if (l9_1654<l9_1657)
{
discard_fragment();
}
}
l9_1645=fast::max(l9_1645,float3(0.0));
float4 l9_1658;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
l9_1658=float4(l9_1645,l9_1646);
}
else
{
l9_1648=fast::max(l9_1648,float3(0.0));
l9_1649=fast::clamp(l9_1649,0.0,1.0);
l9_1650=fast::clamp(l9_1650,0.0,1.0);
l9_1651=fast::clamp(l9_1651,float3(0.0),float3(1.0));
float3 l9_1659=l9_1645;
float l9_1660=l9_1646;
float3 l9_1661=l9_1653.BumpedNormal;
float3 l9_1662=l9_1653.PositionWS;
float3 l9_1663=l9_1653.ViewDirWS;
float3 l9_1664=l9_1648;
float l9_1665=l9_1649;
float l9_1666=l9_1650;
float3 l9_1667=l9_1651;
float3 l9_1668=l9_1652;
SurfaceProperties l9_1669;
l9_1669.albedo=float3(0.0);
l9_1669.opacity=1.0;
l9_1669.normal=float3(0.0);
l9_1669.positionWS=float3(0.0);
l9_1669.viewDirWS=float3(0.0);
l9_1669.metallic=0.0;
l9_1669.roughness=0.0;
l9_1669.emissive=float3(0.0);
l9_1669.ao=float3(1.0);
l9_1669.specularAo=float3(1.0);
l9_1669.bakedShadows=float3(1.0);
SurfaceProperties l9_1670=l9_1669;
SurfaceProperties l9_1671=l9_1670;
l9_1671.opacity=l9_1660;
float3 l9_1672=l9_1659;
float3 l9_1673;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_1673=float3(pow(l9_1672.x,2.2),pow(l9_1672.y,2.2),pow(l9_1672.z,2.2));
}
else
{
l9_1673=l9_1672*l9_1672;
}
float3 l9_1674=l9_1673;
l9_1671.albedo=l9_1674;
l9_1671.normal=normalize(l9_1661);
l9_1671.positionWS=l9_1662;
l9_1671.viewDirWS=l9_1663;
float3 l9_1675=l9_1664;
float3 l9_1676;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_1676=float3(pow(l9_1675.x,2.2),pow(l9_1675.y,2.2),pow(l9_1675.z,2.2));
}
else
{
l9_1676=l9_1675*l9_1675;
}
float3 l9_1677=l9_1676;
l9_1671.emissive=l9_1677;
l9_1671.metallic=l9_1665;
l9_1671.roughness=l9_1666;
l9_1671.ao=l9_1667;
l9_1671.specularAo=l9_1668;
if ((int(sc_SSAOEnabled_tmp)!=0))
{
float3 l9_1678=l9_1671.positionWS;
l9_1671.ao=evaluateSSAO(l9_1678,in.varStereoViewID,(*sc_set1.sc_CameraUBO),sc_set0.sc_SSAOTexture,sc_set0.sc_SSAOTextureSmpSC);
}
SurfaceProperties l9_1679=l9_1671;
SurfaceProperties l9_1680=l9_1679;
float3 l9_1681=mix(float3(0.039999999),l9_1680.albedo*l9_1680.metallic,float3(l9_1680.metallic));
float3 l9_1682=mix(l9_1680.albedo*(1.0-l9_1680.metallic),float3(0.0),float3(l9_1680.metallic));
l9_1679.albedo=l9_1682;
l9_1679.specColor=l9_1681;
SurfaceProperties l9_1683=l9_1679;
l9_1671=l9_1683;
SurfaceProperties l9_1684=l9_1671;
LightingComponents l9_1685;
l9_1685.directDiffuse=float3(0.0);
l9_1685.directSpecular=float3(0.0);
l9_1685.indirectDiffuse=float3(1.0);
l9_1685.indirectSpecular=float3(0.0);
l9_1685.emitted=float3(0.0);
l9_1685.transmitted=float3(0.0);
LightingComponents l9_1686=l9_1685;
LightingComponents l9_1687=l9_1686;
float3 l9_1688=l9_1684.viewDirWS;
int l9_1689=0;
float4 l9_1690=float4(l9_1684.bakedShadows,1.0);
if (sc_DirectionalLightsCount_tmp>0)
{
sc_DirectionalLight_t l9_1691;
LightProperties l9_1692;
int l9_1693=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1693<sc_DirectionalLightsCount_tmp)
{
l9_1691.direction=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_1693].direction;
l9_1691.color=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_1693].color;
l9_1691.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_1693].shadowMapParamsIndex;
l9_1692.direction=l9_1691.direction;
l9_1692.color=l9_1691.color.xyz;
l9_1692.attenuation=l9_1691.color.w;
l9_1692.attenuation*=l9_1690[(l9_1689<3) ? l9_1689 : 3];
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_1691.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_1694=l9_1693;
float l9_1695=evaluateDirectionalShadowMap(l9_1694,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_1696=l9_1691.shadowMapParamsIndex;
float3 l9_1697=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_1696].params[0].xyz;
float3 l9_1698=l9_1697;
l9_1692.color=mix(l9_1698,l9_1692.color,float3(l9_1695));
}
}
l9_1689++;
LightingComponents l9_1699=l9_1687;
LightProperties l9_1700=l9_1692;
SurfaceProperties l9_1701=l9_1684;
float3 l9_1702=l9_1688;
SurfaceProperties l9_1703=l9_1701;
float3 l9_1704=l9_1700.direction;
float l9_1705=dot(l9_1703.normal,l9_1704);
float l9_1706=fast::clamp(l9_1705,0.0,1.0);
float3 l9_1707=float3(l9_1706);
l9_1699.directDiffuse+=((l9_1707*l9_1700.color)*l9_1700.attenuation);
SurfaceProperties l9_1708=l9_1701;
float3 l9_1709=l9_1700.direction;
float3 l9_1710=l9_1702;
l9_1699.directSpecular+=((calculateDirectSpecular(l9_1708,l9_1709,l9_1710)*l9_1700.color)*l9_1700.attenuation);
LightingComponents l9_1711=l9_1699;
l9_1687=l9_1711;
l9_1693++;
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
sc_PointLight_t l9_1712;
LightProperties l9_1713;
int l9_1714=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1714<sc_PointLightsCount_tmp)
{
l9_1712.falloffRangeSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].falloffRangeSqr;
l9_1712.falloffRangeNegInvSqrSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].falloffRangeNegInvSqrSqr;
l9_1712.angleScale=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].angleScale;
l9_1712.angleOffset=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].angleOffset;
l9_1712.direction=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].direction;
l9_1712.position=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].position;
l9_1712.color=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].color;
l9_1712.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_1714].shadowMapParamsIndex;
float3 l9_1715=l9_1712.position-l9_1684.positionWS;
float l9_1716=dot(l9_1715,l9_1715);
float l9_1717=l9_1712.falloffRangeSqr;
float l9_1718=l9_1716;
float l9_1719=l9_1717;
bool l9_1720=l9_1719>0.0;
bool l9_1721=l9_1720&&(l9_1718>l9_1717);
if (!l9_1721)
{
float l9_1722=rsqrt(l9_1716);
l9_1713.direction=l9_1715*l9_1722;
l9_1713.color=l9_1712.color.xyz;
l9_1713.attenuation=l9_1712.color.w;
l9_1713.attenuation*=l9_1690[(l9_1689<3) ? l9_1689 : 3];
float3 l9_1723=l9_1713.direction;
float3 l9_1724=l9_1712.direction;
float l9_1725=l9_1712.angleScale;
float l9_1726=l9_1712.angleOffset;
float l9_1727=dot(l9_1723,l9_1724);
float l9_1728=fast::clamp((l9_1727*l9_1725)+l9_1726,0.0,1.0);
float l9_1729=l9_1728*l9_1728;
l9_1713.attenuation*=l9_1729;
float l9_1730=l9_1712.falloffRangeSqr;
bool l9_1731=l9_1730>0.0;
if (l9_1731)
{
float l9_1732=l9_1722*l9_1722;
float l9_1733=l9_1716;
float l9_1734=l9_1732;
float l9_1735=l9_1712.falloffRangeNegInvSqrSqr;
float l9_1736=10000.0;
float l9_1737=l9_1735;
bool l9_1738=l9_1737!=0.0;
if (l9_1738)
{
float l9_1739=l9_1733*l9_1733;
l9_1736+=(l9_1739*l9_1735);
l9_1736=fast::max(l9_1736,0.0);
}
float l9_1740=l9_1736*l9_1734;
l9_1713.attenuation*=l9_1740;
}
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_1712.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_1741=l9_1714;
float3 l9_1742=-l9_1713.direction;
float l9_1743=evaluatePointShadowMap(l9_1741,l9_1742,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_1744=l9_1712.shadowMapParamsIndex;
float3 l9_1745=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_1744].params[0].xyz;
float3 l9_1746=l9_1745;
l9_1713.color=mix(l9_1746,l9_1713.color,float3(l9_1743));
}
}
LightingComponents l9_1747=l9_1687;
LightProperties l9_1748=l9_1713;
SurfaceProperties l9_1749=l9_1684;
float3 l9_1750=l9_1688;
SurfaceProperties l9_1751=l9_1749;
float3 l9_1752=l9_1748.direction;
float l9_1753=dot(l9_1751.normal,l9_1752);
float l9_1754=fast::clamp(l9_1753,0.0,1.0);
float3 l9_1755=float3(l9_1754);
l9_1747.directDiffuse+=((l9_1755*l9_1748.color)*l9_1748.attenuation);
SurfaceProperties l9_1756=l9_1749;
float3 l9_1757=l9_1748.direction;
float3 l9_1758=l9_1750;
l9_1747.directSpecular+=((calculateDirectSpecular(l9_1756,l9_1757,l9_1758)*l9_1748.color)*l9_1748.attenuation);
LightingComponents l9_1759=l9_1747;
l9_1687=l9_1759;
}
l9_1689++;
l9_1714++;
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
float3 l9_1760=float3(0.0);
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float2 l9_1761=abs(in.varShadowTex-float2(0.5));
float l9_1762=fast::max(l9_1761.x,l9_1761.y);
float l9_1763=step(l9_1762,0.5);
float4 l9_1764=sc_set0.sc_ShadowTexture.sample(sc_set0.sc_ShadowTextureSmpSC,in.varShadowTex)*l9_1763;
float3 l9_1765=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_1764.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float l9_1766=l9_1764.w*(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity;
l9_1760=mix(float3(1.0),l9_1765,float3(l9_1766));
}
else
{
l9_1760=float3(1.0);
}
float3 l9_1767=l9_1760;
float3 l9_1768=l9_1767;
l9_1687.directDiffuse*=l9_1768;
l9_1687.directSpecular*=l9_1768;
}
SurfaceProperties l9_1769=l9_1684;
float3 l9_1770=l9_1769.normal;
float3 l9_1771=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
float3 l9_1772=l9_1770;
float4 l9_1773=float4(0.0);
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp)
{
float3 l9_1774=l9_1772;
float l9_1775=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_1776=float2(0.0);
float l9_1777=l9_1774.x;
float l9_1778=-l9_1774.z;
float l9_1779=(l9_1777<0.0) ? (-1.0) : 1.0;
float l9_1780=l9_1779*acos(fast::clamp(l9_1778/length(float2(l9_1777,l9_1778)),-1.0,1.0));
l9_1776.x=l9_1780-1.5707964;
l9_1776.y=acos(l9_1774.y);
l9_1776/=float2(6.2831855,3.1415927);
l9_1776.y=1.0-l9_1776.y;
l9_1776.x+=(l9_1775/360.0);
l9_1776.x=fract((l9_1776.x+floor(l9_1776.x))+1.0);
float2 l9_1781=l9_1776;
float2 l9_1782=l9_1781;
if (SC_DEVICE_CLASS_tmp>=2)
{
float2 l9_1783=l9_1782;
float2 l9_1784=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_1785=5.0;
l9_1782=calcSeamlessPanoramicUvsForSampling(l9_1783,l9_1784,l9_1785);
}
float2 l9_1786=l9_1782;
float l9_1787=13.0;
int l9_1788;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_1789=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1789=0;
}
else
{
l9_1789=in.varStereoViewID;
}
int l9_1790=l9_1789;
l9_1788=1-l9_1790;
}
else
{
int l9_1791=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1791=0;
}
else
{
l9_1791=in.varStereoViewID;
}
int l9_1792=l9_1791;
l9_1788=l9_1792;
}
int l9_1793=l9_1788;
float2 l9_1794=l9_1786;
int l9_1795=sc_EnvmapSpecularLayout_tmp;
int l9_1796=l9_1793;
float l9_1797=l9_1787;
float2 l9_1798=l9_1794;
int l9_1799=l9_1795;
int l9_1800=l9_1796;
float3 l9_1801=float3(0.0);
if (l9_1799==0)
{
l9_1801=float3(l9_1798,0.0);
}
else
{
if (l9_1799==1)
{
l9_1801=float3(l9_1798.x,(l9_1798.y*0.5)+(0.5-(float(l9_1800)*0.5)),0.0);
}
else
{
l9_1801=float3(l9_1798,float(l9_1800));
}
}
float3 l9_1802=l9_1801;
float3 l9_1803=l9_1802;
float4 l9_1804=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_1803.xy,bias(l9_1797));
float4 l9_1805=l9_1804;
l9_1773=l9_1805;
}
else
{
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_1806=l9_1772;
float l9_1807=0.18000001;
float l9_1808=4.5;
float3 l9_1809=l9_1806;
float3 l9_1810=float3(((-l9_1809.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_1809.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_1809.y,(l9_1809.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_1809.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
l9_1806=l9_1810;
float3 l9_1811;
if (abs(l9_1806.z)<0.99000001)
{
l9_1811=float3(-l9_1806.y,l9_1806.x,0.0);
}
else
{
l9_1811=float3(0.0,-l9_1806.z,l9_1806.y);
}
float3 l9_1812=normalize(l9_1811);
float3 l9_1813=cross(l9_1806,l9_1812);
float3 l9_1814=l9_1806+(((l9_1812*1.0)+(l9_1813*0.0))*l9_1807);
float3 l9_1815=l9_1806+(((l9_1812*(-0.5))+(l9_1813*0.86602539))*l9_1807);
float3 l9_1816=l9_1806+(((l9_1812*(-0.5))-(l9_1813*0.86602539))*l9_1807);
float3 l9_1817=l9_1814;
bool l9_1818=true;
float l9_1819=l9_1808;
float4 l9_1820;
if (l9_1818)
{
l9_1820=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1817,level(l9_1819));
}
else
{
l9_1820=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1817,bias(l9_1819));
}
float4 l9_1821=l9_1820;
float4 l9_1822=l9_1821;
float3 l9_1823=l9_1815;
bool l9_1824=true;
float l9_1825=l9_1808;
float4 l9_1826;
if (l9_1824)
{
l9_1826=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1823,level(l9_1825));
}
else
{
l9_1826=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1823,bias(l9_1825));
}
float4 l9_1827=l9_1826;
float4 l9_1828=l9_1827;
float3 l9_1829=l9_1816;
bool l9_1830=true;
float l9_1831=l9_1808;
float4 l9_1832;
if (l9_1830)
{
l9_1832=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1829,level(l9_1831));
}
else
{
l9_1832=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1829,bias(l9_1831));
}
float4 l9_1833=l9_1832;
float4 l9_1834=l9_1833;
float4 l9_1835=((l9_1822+l9_1828)+l9_1834)*0.33333334;
l9_1773=l9_1835;
}
else
{
float3 l9_1836=l9_1772;
float l9_1837=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_1838=float2(0.0);
float l9_1839=l9_1836.x;
float l9_1840=-l9_1836.z;
float l9_1841=(l9_1839<0.0) ? (-1.0) : 1.0;
float l9_1842=l9_1841*acos(fast::clamp(l9_1840/length(float2(l9_1839,l9_1840)),-1.0,1.0));
l9_1838.x=l9_1842-1.5707964;
l9_1838.y=acos(l9_1836.y);
l9_1838/=float2(6.2831855,3.1415927);
l9_1838.y=1.0-l9_1838.y;
l9_1838.x+=(l9_1837/360.0);
l9_1838.x=fract((l9_1838.x+floor(l9_1838.x))+1.0);
float2 l9_1843=l9_1838;
float2 l9_1844=l9_1843;
if ((int(sc_HasDiffuseEnvmap_tmp)!=0))
{
float2 l9_1845=l9_1844;
float2 l9_1846=(*sc_set1.sc_LightingUBO).sc_EnvmapDiffuseSize.xy;
float l9_1847=0.0;
l9_1844=calcSeamlessPanoramicUvsForSampling(l9_1845,l9_1846,l9_1847);
float2 l9_1848=l9_1844;
float l9_1849=-13.0;
int l9_1850;
if ((int(sc_EnvmapDiffuseHasSwappedViews_tmp)!=0))
{
int l9_1851=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1851=0;
}
else
{
l9_1851=in.varStereoViewID;
}
int l9_1852=l9_1851;
l9_1850=1-l9_1852;
}
else
{
int l9_1853=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1853=0;
}
else
{
l9_1853=in.varStereoViewID;
}
int l9_1854=l9_1853;
l9_1850=l9_1854;
}
int l9_1855=l9_1850;
float2 l9_1856=l9_1848;
int l9_1857=sc_EnvmapDiffuseLayout_tmp;
int l9_1858=l9_1855;
float l9_1859=l9_1849;
float2 l9_1860=l9_1856;
int l9_1861=l9_1857;
int l9_1862=l9_1858;
float3 l9_1863=float3(0.0);
if (l9_1861==0)
{
l9_1863=float3(l9_1860,0.0);
}
else
{
if (l9_1861==1)
{
l9_1863=float3(l9_1860.x,(l9_1860.y*0.5)+(0.5-(float(l9_1862)*0.5)),0.0);
}
else
{
l9_1863=float3(l9_1860,float(l9_1862));
}
}
float3 l9_1864=l9_1863;
float3 l9_1865=l9_1864;
float4 l9_1866=sc_set0.sc_EnvmapDiffuse.sample(sc_set0.sc_EnvmapDiffuseSmpSC,l9_1865.xy,bias(l9_1859));
float4 l9_1867=l9_1866;
l9_1773=l9_1867;
}
else
{
float2 l9_1868=l9_1844;
float l9_1869=13.0;
int l9_1870;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_1871=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1871=0;
}
else
{
l9_1871=in.varStereoViewID;
}
int l9_1872=l9_1871;
l9_1870=1-l9_1872;
}
else
{
int l9_1873=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1873=0;
}
else
{
l9_1873=in.varStereoViewID;
}
int l9_1874=l9_1873;
l9_1870=l9_1874;
}
int l9_1875=l9_1870;
float2 l9_1876=l9_1868;
int l9_1877=sc_EnvmapSpecularLayout_tmp;
int l9_1878=l9_1875;
float l9_1879=l9_1869;
float2 l9_1880=l9_1876;
int l9_1881=l9_1877;
int l9_1882=l9_1878;
float3 l9_1883=float3(0.0);
if (l9_1881==0)
{
l9_1883=float3(l9_1880,0.0);
}
else
{
if (l9_1881==1)
{
l9_1883=float3(l9_1880.x,(l9_1880.y*0.5)+(0.5-(float(l9_1882)*0.5)),0.0);
}
else
{
l9_1883=float3(l9_1880,float(l9_1882));
}
}
float3 l9_1884=l9_1883;
float3 l9_1885=l9_1884;
float4 l9_1886=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_1885.xy,bias(l9_1879));
float4 l9_1887=l9_1886;
l9_1773=l9_1887;
}
}
}
float4 l9_1888=l9_1773;
float3 l9_1889=l9_1888.xyz*(1.0/fast::max(l9_1888.w,0.0039215689));
float3 l9_1890=l9_1889*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_1771=l9_1890;
}
else
{
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_SphericalHarmonics_tmp)
{
float3 l9_1891=(*sc_set1.sc_LightingUBO).sc_Sh[0];
float3 l9_1892=(*sc_set1.sc_LightingUBO).sc_Sh[1];
float3 l9_1893=(*sc_set1.sc_LightingUBO).sc_Sh[2];
float3 l9_1894=(*sc_set1.sc_LightingUBO).sc_Sh[3];
float3 l9_1895=(*sc_set1.sc_LightingUBO).sc_Sh[4];
float3 l9_1896=(*sc_set1.sc_LightingUBO).sc_Sh[5];
float3 l9_1897=(*sc_set1.sc_LightingUBO).sc_Sh[6];
float3 l9_1898=(*sc_set1.sc_LightingUBO).sc_Sh[7];
float3 l9_1899=(*sc_set1.sc_LightingUBO).sc_Sh[8];
float3 l9_1900=-l9_1770;
float l9_1901=0.0;
l9_1901=l9_1900.x;
float l9_1902=l9_1900.y;
float l9_1903=l9_1900.z;
float l9_1904=l9_1901*l9_1901;
float l9_1905=l9_1902*l9_1902;
float l9_1906=l9_1903*l9_1903;
float l9_1907=l9_1901*l9_1902;
float l9_1908=l9_1902*l9_1903;
float l9_1909=l9_1901*l9_1903;
float3 l9_1910=((((((l9_1899*0.42904299)*(l9_1904-l9_1905))+((l9_1897*0.74312502)*l9_1906))+(l9_1891*0.88622701))-(l9_1897*0.24770799))+((((l9_1895*l9_1907)+(l9_1898*l9_1909))+(l9_1896*l9_1908))*0.85808599))+((((l9_1894*l9_1901)+(l9_1892*l9_1902))+(l9_1893*l9_1903))*1.0233279);
l9_1771=l9_1910*(*sc_set1.sc_LightingUBO).sc_ShIntensity;
}
}
if (sc_AmbientLightsCount_tmp>0)
{
if (sc_AmbientLightMode0_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_1771+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].intensity);
}
else
{
l9_1771.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color.x);
}
}
if (sc_AmbientLightsCount_tmp>1)
{
if (sc_AmbientLightMode1_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_1771+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].intensity);
}
else
{
l9_1771.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color.x);
}
}
if (sc_AmbientLightsCount_tmp>2)
{
if (sc_AmbientLightMode2_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_1771+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].intensity);
}
else
{
l9_1771.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color.x);
}
}
if ((int(sc_LightEstimation_tmp)!=0))
{
float3 l9_1911=l9_1770;
float3 l9_1912=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight;
sc_SphericalGaussianLight_t l9_1913;
float l9_1914;
int l9_1915=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1915<sc_LightEstimationSGCount_tmp)
{
l9_1913.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_1915].color;
l9_1913.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_1915].sharpness;
l9_1913.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_1915].axis;
float3 l9_1916=l9_1911;
float l9_1917=dot(l9_1913.axis,l9_1916);
float l9_1918=l9_1913.sharpness;
float l9_1919=0.36000001;
float l9_1920=1.0/(4.0*l9_1919);
float l9_1921=exp(-l9_1918);
float l9_1922=l9_1921*l9_1921;
float l9_1923=1.0/l9_1918;
float l9_1924=(1.0+(2.0*l9_1922))-l9_1923;
float l9_1925=((l9_1921-l9_1922)*l9_1923)-l9_1922;
float l9_1926=sqrt(1.0-l9_1924);
float l9_1927=l9_1919*l9_1917;
float l9_1928=l9_1920*l9_1926;
float l9_1929=l9_1927+l9_1928;
float l9_1930=l9_1917;
float l9_1931=fast::clamp(l9_1930,0.0,1.0);
float l9_1932=l9_1931;
if (step(abs(l9_1927),l9_1928)>0.5)
{
l9_1914=(l9_1929*l9_1929)/l9_1926;
}
else
{
l9_1914=l9_1932;
}
l9_1932=l9_1914;
float l9_1933=(l9_1924*l9_1932)+l9_1925;
sc_SphericalGaussianLight_t l9_1934=l9_1913;
float3 l9_1935=(l9_1934.color/float3(l9_1934.sharpness))*6.2831855;
float3 l9_1936=(l9_1935*l9_1933)/float3(3.1415927);
l9_1912+=l9_1936;
l9_1915++;
continue;
}
else
{
break;
}
}
float3 l9_1937=l9_1912;
l9_1771+=l9_1937;
}
float3 l9_1938=l9_1771;
float3 l9_1939=l9_1938;
l9_1687.indirectDiffuse=l9_1939;
SurfaceProperties l9_1940=l9_1684;
float3 l9_1941=l9_1688;
float3 l9_1942=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
SurfaceProperties l9_1943=l9_1940;
float3 l9_1944=l9_1941;
float3 l9_1945=l9_1943.normal;
float3 l9_1946=reflect(-l9_1944,l9_1945);
float3 l9_1947=l9_1945;
float3 l9_1948=l9_1946;
float l9_1949=l9_1943.roughness;
l9_1946=getSpecularDominantDir(l9_1947,l9_1948,l9_1949);
float l9_1950=l9_1943.roughness;
float l9_1951=pow(l9_1950,0.66666669);
float l9_1952=fast::clamp(l9_1951,0.0,1.0);
float l9_1953=l9_1952*5.0;
float l9_1954=l9_1953;
float l9_1955=l9_1954;
float3 l9_1956=l9_1946;
float l9_1957=l9_1955;
float3 l9_1958=l9_1956;
float l9_1959=l9_1957;
float4 l9_1960=float4(0.0);
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_1961=l9_1958;
float3 l9_1962=float3(((-l9_1961.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_1961.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_1961.y,(l9_1961.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_1961.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
float3 l9_1963=l9_1962;
bool l9_1964=true;
float l9_1965=l9_1959;
float4 l9_1966;
if (l9_1964)
{
l9_1966=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1963,level(l9_1965));
}
else
{
l9_1966=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_1963,bias(l9_1965));
}
float4 l9_1967=l9_1966;
l9_1960=l9_1967;
}
else
{
float3 l9_1968=l9_1958;
float l9_1969=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_1970=float2(0.0);
float l9_1971=l9_1968.x;
float l9_1972=-l9_1968.z;
float l9_1973=(l9_1971<0.0) ? (-1.0) : 1.0;
float l9_1974=l9_1973*acos(fast::clamp(l9_1972/length(float2(l9_1971,l9_1972)),-1.0,1.0));
l9_1970.x=l9_1974-1.5707964;
l9_1970.y=acos(l9_1968.y);
l9_1970/=float2(6.2831855,3.1415927);
l9_1970.y=1.0-l9_1970.y;
l9_1970.x+=(l9_1969/360.0);
l9_1970.x=fract((l9_1970.x+floor(l9_1970.x))+1.0);
float2 l9_1975=l9_1970;
float2 l9_1976=l9_1975;
if (SC_DEVICE_CLASS_tmp>=2)
{
float l9_1977=floor(l9_1959);
float l9_1978=ceil(l9_1959);
float l9_1979=l9_1959-l9_1977;
float2 l9_1980=l9_1976;
float2 l9_1981=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_1982=l9_1977;
float2 l9_1983=calcSeamlessPanoramicUvsForSampling(l9_1980,l9_1981,l9_1982);
float2 l9_1984=l9_1983;
float l9_1985=l9_1977;
float2 l9_1986=l9_1984;
float l9_1987=l9_1985;
int l9_1988;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_1989=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1989=0;
}
else
{
l9_1989=in.varStereoViewID;
}
int l9_1990=l9_1989;
l9_1988=1-l9_1990;
}
else
{
int l9_1991=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_1991=0;
}
else
{
l9_1991=in.varStereoViewID;
}
int l9_1992=l9_1991;
l9_1988=l9_1992;
}
int l9_1993=l9_1988;
float2 l9_1994=l9_1986;
int l9_1995=sc_EnvmapSpecularLayout_tmp;
int l9_1996=l9_1993;
float l9_1997=l9_1987;
float2 l9_1998=l9_1994;
int l9_1999=l9_1995;
int l9_2000=l9_1996;
float3 l9_2001=float3(0.0);
if (l9_1999==0)
{
l9_2001=float3(l9_1998,0.0);
}
else
{
if (l9_1999==1)
{
l9_2001=float3(l9_1998.x,(l9_1998.y*0.5)+(0.5-(float(l9_2000)*0.5)),0.0);
}
else
{
l9_2001=float3(l9_1998,float(l9_2000));
}
}
float3 l9_2002=l9_2001;
float3 l9_2003=l9_2002;
float4 l9_2004=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2003.xy,level(l9_1997));
float4 l9_2005=l9_2004;
float4 l9_2006=l9_2005;
float4 l9_2007=l9_2006;
float2 l9_2008=l9_1976;
float2 l9_2009=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_2010=l9_1978;
float2 l9_2011=calcSeamlessPanoramicUvsForSampling(l9_2008,l9_2009,l9_2010);
float2 l9_2012=l9_2011;
float l9_2013=l9_1978;
float2 l9_2014=l9_2012;
float l9_2015=l9_2013;
int l9_2016;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2017=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2017=0;
}
else
{
l9_2017=in.varStereoViewID;
}
int l9_2018=l9_2017;
l9_2016=1-l9_2018;
}
else
{
int l9_2019=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2019=0;
}
else
{
l9_2019=in.varStereoViewID;
}
int l9_2020=l9_2019;
l9_2016=l9_2020;
}
int l9_2021=l9_2016;
float2 l9_2022=l9_2014;
int l9_2023=sc_EnvmapSpecularLayout_tmp;
int l9_2024=l9_2021;
float l9_2025=l9_2015;
float2 l9_2026=l9_2022;
int l9_2027=l9_2023;
int l9_2028=l9_2024;
float3 l9_2029=float3(0.0);
if (l9_2027==0)
{
l9_2029=float3(l9_2026,0.0);
}
else
{
if (l9_2027==1)
{
l9_2029=float3(l9_2026.x,(l9_2026.y*0.5)+(0.5-(float(l9_2028)*0.5)),0.0);
}
else
{
l9_2029=float3(l9_2026,float(l9_2028));
}
}
float3 l9_2030=l9_2029;
float3 l9_2031=l9_2030;
float4 l9_2032=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2031.xy,level(l9_2025));
float4 l9_2033=l9_2032;
float4 l9_2034=l9_2033;
float4 l9_2035=l9_2034;
l9_1960=mix(l9_2007,l9_2035,float4(l9_1979));
}
else
{
float2 l9_2036=l9_1976;
float l9_2037=l9_1959;
float2 l9_2038=l9_2036;
float l9_2039=l9_2037;
int l9_2040;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2041=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2041=0;
}
else
{
l9_2041=in.varStereoViewID;
}
int l9_2042=l9_2041;
l9_2040=1-l9_2042;
}
else
{
int l9_2043=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2043=0;
}
else
{
l9_2043=in.varStereoViewID;
}
int l9_2044=l9_2043;
l9_2040=l9_2044;
}
int l9_2045=l9_2040;
float2 l9_2046=l9_2038;
int l9_2047=sc_EnvmapSpecularLayout_tmp;
int l9_2048=l9_2045;
float l9_2049=l9_2039;
float2 l9_2050=l9_2046;
int l9_2051=l9_2047;
int l9_2052=l9_2048;
float3 l9_2053=float3(0.0);
if (l9_2051==0)
{
l9_2053=float3(l9_2050,0.0);
}
else
{
if (l9_2051==1)
{
l9_2053=float3(l9_2050.x,(l9_2050.y*0.5)+(0.5-(float(l9_2052)*0.5)),0.0);
}
else
{
l9_2053=float3(l9_2050,float(l9_2052));
}
}
float3 l9_2054=l9_2053;
float3 l9_2055=l9_2054;
float4 l9_2056=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2055.xy,level(l9_2049));
float4 l9_2057=l9_2056;
float4 l9_2058=l9_2057;
l9_1960=l9_2058;
}
}
float4 l9_2059=l9_1960;
float3 l9_2060=l9_2059.xyz*(1.0/fast::max(l9_2059.w,0.0039215689));
float3 l9_2061=l9_2060;
float3 l9_2062=l9_2061*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_2062.x+=(*sc_set1.sc_CameraUBO).sc_UniformConstants.x;
float3 l9_2063=l9_2062;
float3 l9_2064=l9_2063;
float l9_2065=abs(dot(l9_1945,l9_1944));
SurfaceProperties l9_2066=l9_1943;
float l9_2067=l9_2065;
float3 l9_2068=l9_2064*envBRDFApprox(l9_2066,l9_2067);
l9_1942+=l9_2068;
}
if ((int(sc_LightEstimation_tmp)!=0))
{
SurfaceProperties l9_2069=l9_1940;
float3 l9_2070=l9_1941;
float l9_2071=fast::clamp(l9_2069.roughness*l9_2069.roughness,0.0099999998,1.0);
float3 l9_2072=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight*l9_2069.specColor;
sc_SphericalGaussianLight_t l9_2073;
sc_SphericalGaussianLight_t l9_2074;
sc_SphericalGaussianLight_t l9_2075;
int l9_2076=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_2076<sc_LightEstimationSGCount_tmp)
{
l9_2073.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2076].color;
l9_2073.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2076].sharpness;
l9_2073.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2076].axis;
float3 l9_2077=l9_2069.normal;
float l9_2078=l9_2071;
float3 l9_2079=l9_2070;
float3 l9_2080=l9_2069.specColor;
float3 l9_2081=l9_2077;
float l9_2082=l9_2078;
l9_2074.axis=l9_2081;
float l9_2083=l9_2082*l9_2082;
l9_2074.sharpness=2.0/l9_2083;
l9_2074.color=float3(1.0/(3.1415927*l9_2083));
sc_SphericalGaussianLight_t l9_2084=l9_2074;
sc_SphericalGaussianLight_t l9_2085=l9_2084;
sc_SphericalGaussianLight_t l9_2086=l9_2085;
float3 l9_2087=l9_2079;
l9_2075.axis=reflect(-l9_2087,l9_2086.axis);
l9_2075.color=l9_2086.color;
l9_2075.sharpness=l9_2086.sharpness;
l9_2075.sharpness/=(4.0*fast::max(dot(l9_2086.axis,l9_2087),9.9999997e-05));
sc_SphericalGaussianLight_t l9_2088=l9_2075;
sc_SphericalGaussianLight_t l9_2089=l9_2088;
sc_SphericalGaussianLight_t l9_2090=l9_2089;
sc_SphericalGaussianLight_t l9_2091=l9_2073;
float l9_2092=length((l9_2090.axis*l9_2090.sharpness)+(l9_2091.axis*l9_2091.sharpness));
float3 l9_2093=(l9_2090.color*exp((l9_2092-l9_2090.sharpness)-l9_2091.sharpness))*l9_2091.color;
float l9_2094=1.0-exp((-2.0)*l9_2092);
float3 l9_2095=((l9_2093*6.2831855)*l9_2094)/float3(l9_2092);
float3 l9_2096=l9_2095;
float3 l9_2097=l9_2089.axis;
float l9_2098=l9_2078*l9_2078;
float l9_2099=dot(l9_2077,l9_2097);
float l9_2100=fast::clamp(l9_2099,0.0,1.0);
float l9_2101=l9_2100;
float l9_2102=dot(l9_2077,l9_2079);
float l9_2103=fast::clamp(l9_2102,0.0,1.0);
float l9_2104=l9_2103;
float3 l9_2105=normalize(l9_2089.axis+l9_2079);
float l9_2106=l9_2098;
float l9_2107=l9_2101;
float l9_2108=1.0/(l9_2107+sqrt(l9_2106+(((1.0-l9_2106)*l9_2107)*l9_2107)));
float l9_2109=l9_2098;
float l9_2110=l9_2104;
float l9_2111=1.0/(l9_2110+sqrt(l9_2109+(((1.0-l9_2109)*l9_2110)*l9_2110)));
l9_2096*=(l9_2108*l9_2111);
float l9_2112=dot(l9_2097,l9_2105);
float l9_2113=fast::clamp(l9_2112,0.0,1.0);
float l9_2114=pow(1.0-l9_2113,5.0);
l9_2096*=(l9_2080+((float3(1.0)-l9_2080)*l9_2114));
l9_2096*=l9_2101;
float3 l9_2115=l9_2096;
l9_2072+=l9_2115;
l9_2076++;
continue;
}
else
{
break;
}
}
float3 l9_2116=l9_2072;
l9_1942+=l9_2116;
}
float3 l9_2117=l9_1942;
l9_1687.indirectSpecular=l9_2117;
LightingComponents l9_2118=l9_1687;
LightingComponents l9_2119=l9_2118;
if (sc_BlendMode_tmp==9)
{
l9_2119.directDiffuse=float3(0.0);
l9_2119.indirectDiffuse=float3(0.0);
float4 l9_2120=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_2121=out.sc_FragData0;
l9_2120=l9_2121;
}
else
{
float4 l9_2122=gl_FragCoord;
float2 l9_2123=l9_2122.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_2124=l9_2123;
float2 l9_2125=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_2126=1;
int l9_2127=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2127=0;
}
else
{
l9_2127=in.varStereoViewID;
}
int l9_2128=l9_2127;
int l9_2129=l9_2128;
float3 l9_2130=float3(l9_2124,0.0);
int l9_2131=l9_2126;
int l9_2132=l9_2129;
if (l9_2131==1)
{
l9_2130.y=((2.0*l9_2130.y)+float(l9_2132))-1.0;
}
float2 l9_2133=l9_2130.xy;
l9_2125=l9_2133;
}
else
{
l9_2125=l9_2124;
}
float2 l9_2134=l9_2125;
float2 l9_2135=l9_2134;
float2 l9_2136=l9_2135;
float2 l9_2137=l9_2136;
float l9_2138=0.0;
int l9_2139;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_2140=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2140=0;
}
else
{
l9_2140=in.varStereoViewID;
}
int l9_2141=l9_2140;
l9_2139=1-l9_2141;
}
else
{
int l9_2142=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2142=0;
}
else
{
l9_2142=in.varStereoViewID;
}
int l9_2143=l9_2142;
l9_2139=l9_2143;
}
int l9_2144=l9_2139;
float2 l9_2145=l9_2137;
int l9_2146=sc_ScreenTextureLayout_tmp;
int l9_2147=l9_2144;
float l9_2148=l9_2138;
float2 l9_2149=l9_2145;
int l9_2150=l9_2146;
int l9_2151=l9_2147;
float3 l9_2152=float3(0.0);
if (l9_2150==0)
{
l9_2152=float3(l9_2149,0.0);
}
else
{
if (l9_2150==1)
{
l9_2152=float3(l9_2149.x,(l9_2149.y*0.5)+(0.5-(float(l9_2151)*0.5)),0.0);
}
else
{
l9_2152=float3(l9_2149,float(l9_2151));
}
}
float3 l9_2153=l9_2152;
float3 l9_2154=l9_2153;
float4 l9_2155=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_2154.xy,bias(l9_2148));
float4 l9_2156=l9_2155;
float4 l9_2157=l9_2156;
l9_2120=l9_2157;
}
float4 l9_2158=l9_2120;
float3 l9_2159=l9_2158.xyz;
float3 l9_2160;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2160=float3(pow(l9_2159.x,2.2),pow(l9_2159.y,2.2),pow(l9_2159.z,2.2));
}
else
{
l9_2160=l9_2159*l9_2159;
}
float3 l9_2161=l9_2160;
float3 l9_2162=l9_2161;
l9_2119.transmitted=l9_2162*mix(float3(1.0),l9_1671.albedo,float3(l9_1671.opacity));
l9_1671.opacity=1.0;
}
bool l9_2163=false;
if (sc_BlendMode_tmp==4)
{
l9_2163=true;
}
SurfaceProperties l9_2164=l9_1671;
LightingComponents l9_2165=l9_2119;
bool l9_2166=l9_2163;
float3 l9_2167=l9_2164.albedo*(l9_2165.directDiffuse+(l9_2165.indirectDiffuse*l9_2164.ao));
float3 l9_2168=l9_2165.directSpecular+(l9_2165.indirectSpecular*l9_2164.specularAo);
float3 l9_2169=l9_2164.emissive;
float3 l9_2170=l9_2165.transmitted;
if (l9_2166)
{
float l9_2171=l9_2164.opacity;
l9_2167*=srgbToLinear(l9_2171);
}
float3 l9_2172=((l9_2167+l9_2168)+l9_2169)+l9_2170;
float3 l9_2173=l9_2172;
float4 l9_2174=float4(l9_2173,l9_1671.opacity);
if (sc_BlendMode_tmp!=1)
{
float3 l9_2175=l9_2174.xyz;
float l9_2176=1.8;
float l9_2177=1.4;
float l9_2178=0.5;
float l9_2179=1.5;
float3 l9_2180=(l9_2175*((l9_2175*l9_2176)+float3(l9_2177)))/((l9_2175*((l9_2175*l9_2176)+float3(l9_2178)))+float3(l9_2179));
l9_2174=float4(l9_2180.x,l9_2180.y,l9_2180.z,l9_2174.w);
}
float3 l9_2181=l9_2174.xyz;
float l9_2182=l9_2181.x;
float l9_2183=l9_2181.y;
float l9_2184=l9_2181.z;
float3 l9_2185=float3(linearToSrgb(l9_2182),linearToSrgb(l9_2183),linearToSrgb(l9_2184));
l9_2174=float4(l9_2185.x,l9_2185.y,l9_2185.z,l9_2174.w);
float4 l9_2186=l9_2174;
l9_1658=l9_2186;
}
l9_1658=fast::max(l9_1658,float4(0.0));
l9_1644=l9_1658;
float4 l9_2187=float4(0.0);
float3 l9_2188=(*sc_set0.UserUniforms).Port_Albedo_N405;
float l9_2189=(*sc_set0.UserUniforms).Port_Opacity_N405;
float3 l9_2190=l9_236;
float3 l9_2191=(*sc_set0.UserUniforms).Port_Emissive_N405;
float l9_2192=(*sc_set0.UserUniforms).Port_Metallic_N405;
float l9_2193=l9_237;
float3 l9_2194=(*sc_set0.UserUniforms).Port_SpecularAO_N405;
ssGlobals l9_2195=param_3;
if (!(int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
l9_2195.BumpedNormal=float3x3(float3(l9_2195.VertexTangent_WorldSpace),float3(l9_2195.VertexBinormal_WorldSpace),float3(l9_2195.VertexNormal_WorldSpace))*l9_2190;
}
float l9_2196=l9_2189;
if (sc_BlendMode_tmp==8)
{
if (l9_2196<(*sc_set0.UserUniforms).alphaTestThreshold)
{
discard_fragment();
}
}
if ((int(ENABLE_STIPPLE_PATTERN_TEST_tmp)!=0))
{
float4 l9_2197=gl_FragCoord;
float2 l9_2198=floor(mod(l9_2197.xy,float2(4.0)));
float l9_2199=(mod(dot(l9_2198,float2(4.0,1.0))*9.0,16.0)+1.0)/17.0;
if (l9_2196<l9_2199)
{
discard_fragment();
}
}
float4 l9_2200;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
l9_2200=float4(l9_2188,l9_2189);
}
else
{
l9_2193=fast::clamp(l9_2193,0.0,1.0);
float3 l9_2201=float3(1.0);
float3 l9_2202=l9_2188;
float l9_2203=l9_2189;
float3 l9_2204=l9_2195.BumpedNormal;
float3 l9_2205=l9_2195.PositionWS;
float3 l9_2206=l9_2195.ViewDirWS;
float3 l9_2207=l9_2191;
float l9_2208=l9_2192;
float l9_2209=l9_2193;
float3 l9_2210=l9_2201;
float3 l9_2211=l9_2194;
SurfaceProperties l9_2212;
l9_2212.albedo=float3(0.0);
l9_2212.opacity=1.0;
l9_2212.normal=float3(0.0);
l9_2212.positionWS=float3(0.0);
l9_2212.viewDirWS=float3(0.0);
l9_2212.metallic=0.0;
l9_2212.roughness=0.0;
l9_2212.emissive=float3(0.0);
l9_2212.ao=float3(1.0);
l9_2212.specularAo=float3(1.0);
l9_2212.bakedShadows=float3(1.0);
SurfaceProperties l9_2213=l9_2212;
SurfaceProperties l9_2214=l9_2213;
l9_2214.opacity=l9_2203;
float3 l9_2215=l9_2202;
float3 l9_2216;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2216=float3(pow(l9_2215.x,2.2),pow(l9_2215.y,2.2),pow(l9_2215.z,2.2));
}
else
{
l9_2216=l9_2215*l9_2215;
}
float3 l9_2217=l9_2216;
l9_2214.albedo=l9_2217;
l9_2214.normal=normalize(l9_2204);
l9_2214.positionWS=l9_2205;
l9_2214.viewDirWS=l9_2206;
float3 l9_2218=l9_2207;
float3 l9_2219;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2219=float3(pow(l9_2218.x,2.2),pow(l9_2218.y,2.2),pow(l9_2218.z,2.2));
}
else
{
l9_2219=l9_2218*l9_2218;
}
float3 l9_2220=l9_2219;
l9_2214.emissive=l9_2220;
l9_2214.metallic=l9_2208;
l9_2214.roughness=l9_2209;
l9_2214.ao=l9_2210;
l9_2214.specularAo=l9_2211;
if ((int(sc_SSAOEnabled_tmp)!=0))
{
float3 l9_2221=l9_2214.positionWS;
l9_2214.ao=evaluateSSAO(l9_2221,in.varStereoViewID,(*sc_set1.sc_CameraUBO),sc_set0.sc_SSAOTexture,sc_set0.sc_SSAOTextureSmpSC);
}
SurfaceProperties l9_2222=l9_2214;
SurfaceProperties l9_2223=l9_2222;
float3 l9_2224=mix(float3(0.039999999),l9_2223.albedo*l9_2223.metallic,float3(l9_2223.metallic));
float3 l9_2225=mix(l9_2223.albedo*(1.0-l9_2223.metallic),float3(0.0),float3(l9_2223.metallic));
l9_2222.albedo=l9_2225;
l9_2222.specColor=l9_2224;
SurfaceProperties l9_2226=l9_2222;
l9_2214=l9_2226;
SurfaceProperties l9_2227=l9_2214;
LightingComponents l9_2228;
l9_2228.directDiffuse=float3(0.0);
l9_2228.directSpecular=float3(0.0);
l9_2228.indirectDiffuse=float3(1.0);
l9_2228.indirectSpecular=float3(0.0);
l9_2228.emitted=float3(0.0);
l9_2228.transmitted=float3(0.0);
LightingComponents l9_2229=l9_2228;
LightingComponents l9_2230=l9_2229;
float3 l9_2231=l9_2227.viewDirWS;
int l9_2232=0;
float4 l9_2233=float4(l9_2227.bakedShadows,1.0);
if (sc_DirectionalLightsCount_tmp>0)
{
sc_DirectionalLight_t l9_2234;
LightProperties l9_2235;
int l9_2236=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_2236<sc_DirectionalLightsCount_tmp)
{
l9_2234.direction=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_2236].direction;
l9_2234.color=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_2236].color;
l9_2234.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_DirectionalLights[l9_2236].shadowMapParamsIndex;
l9_2235.direction=l9_2234.direction;
l9_2235.color=l9_2234.color.xyz;
l9_2235.attenuation=l9_2234.color.w;
l9_2235.attenuation*=l9_2233[(l9_2232<3) ? l9_2232 : 3];
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_2234.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_2237=l9_2236;
float l9_2238=evaluateDirectionalShadowMap(l9_2237,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_2239=l9_2234.shadowMapParamsIndex;
float3 l9_2240=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_2239].params[0].xyz;
float3 l9_2241=l9_2240;
l9_2235.color=mix(l9_2241,l9_2235.color,float3(l9_2238));
}
}
l9_2232++;
LightingComponents l9_2242=l9_2230;
LightProperties l9_2243=l9_2235;
SurfaceProperties l9_2244=l9_2227;
float3 l9_2245=l9_2231;
SurfaceProperties l9_2246=l9_2244;
float3 l9_2247=l9_2243.direction;
float l9_2248=dot(l9_2246.normal,l9_2247);
float l9_2249=fast::clamp(l9_2248,0.0,1.0);
float3 l9_2250=float3(l9_2249);
l9_2242.directDiffuse+=((l9_2250*l9_2243.color)*l9_2243.attenuation);
SurfaceProperties l9_2251=l9_2244;
float3 l9_2252=l9_2243.direction;
float3 l9_2253=l9_2245;
l9_2242.directSpecular+=((calculateDirectSpecular(l9_2251,l9_2252,l9_2253)*l9_2243.color)*l9_2243.attenuation);
LightingComponents l9_2254=l9_2242;
l9_2230=l9_2254;
l9_2236++;
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
sc_PointLight_t l9_2255;
LightProperties l9_2256;
int l9_2257=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_2257<sc_PointLightsCount_tmp)
{
l9_2255.falloffRangeSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].falloffRangeSqr;
l9_2255.falloffRangeNegInvSqrSqr=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].falloffRangeNegInvSqrSqr;
l9_2255.angleScale=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].angleScale;
l9_2255.angleOffset=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].angleOffset;
l9_2255.direction=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].direction;
l9_2255.position=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].position;
l9_2255.color=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].color;
l9_2255.shadowMapParamsIndex=(*sc_set1.sc_LightingUBO).sc_PointLights[l9_2257].shadowMapParamsIndex;
float3 l9_2258=l9_2255.position-l9_2227.positionWS;
float l9_2259=dot(l9_2258,l9_2258);
float l9_2260=l9_2255.falloffRangeSqr;
float l9_2261=l9_2259;
float l9_2262=l9_2260;
bool l9_2263=l9_2262>0.0;
bool l9_2264=l9_2263&&(l9_2261>l9_2260);
if (!l9_2264)
{
float l9_2265=rsqrt(l9_2259);
l9_2256.direction=l9_2258*l9_2265;
l9_2256.color=l9_2255.color.xyz;
l9_2256.attenuation=l9_2255.color.w;
l9_2256.attenuation*=l9_2233[(l9_2232<3) ? l9_2232 : 3];
float3 l9_2266=l9_2256.direction;
float3 l9_2267=l9_2255.direction;
float l9_2268=l9_2255.angleScale;
float l9_2269=l9_2255.angleOffset;
float l9_2270=dot(l9_2266,l9_2267);
float l9_2271=fast::clamp((l9_2270*l9_2268)+l9_2269,0.0,1.0);
float l9_2272=l9_2271*l9_2271;
l9_2256.attenuation*=l9_2272;
float l9_2273=l9_2255.falloffRangeSqr;
bool l9_2274=l9_2273>0.0;
if (l9_2274)
{
float l9_2275=l9_2265*l9_2265;
float l9_2276=l9_2259;
float l9_2277=l9_2275;
float l9_2278=l9_2255.falloffRangeNegInvSqrSqr;
float l9_2279=10000.0;
float l9_2280=l9_2278;
bool l9_2281=l9_2280!=0.0;
if (l9_2281)
{
float l9_2282=l9_2276*l9_2276;
l9_2279+=(l9_2282*l9_2278);
l9_2279=fast::max(l9_2279,0.0);
}
float l9_2283=l9_2279*l9_2277;
l9_2256.attenuation*=l9_2283;
}
if ((int(sc_ShadowMapReceiver_tmp)!=0))
{
if ((*sc_set0.UserUniforms).sc_ShadowMapParams[l9_2255.shadowMapParamsIndex].params[1].w>0.0)
{
int l9_2284=l9_2257;
float3 l9_2285=-l9_2256.direction;
float l9_2286=evaluatePointShadowMap(l9_2284,l9_2285,gl_FragCoord,(*sc_set1.sc_CameraUBO),sc_set0.sc_ShadowTexture,sc_set0.sc_ShadowTextureSmpSC,(*sc_set0.UserUniforms),sc_set0.sc_ShadowMapTexture,sc_set0.sc_ShadowMapTextureSmpSC,(*sc_set1.sc_LightingUBO),in.varPosAndMotion,in.varNormalAndMotion);
int l9_2287=l9_2255.shadowMapParamsIndex;
float3 l9_2288=(*sc_set0.UserUniforms).sc_ShadowMapParams[l9_2287].params[0].xyz;
float3 l9_2289=l9_2288;
l9_2256.color=mix(l9_2289,l9_2256.color,float3(l9_2286));
}
}
LightingComponents l9_2290=l9_2230;
LightProperties l9_2291=l9_2256;
SurfaceProperties l9_2292=l9_2227;
float3 l9_2293=l9_2231;
SurfaceProperties l9_2294=l9_2292;
float3 l9_2295=l9_2291.direction;
float l9_2296=dot(l9_2294.normal,l9_2295);
float l9_2297=fast::clamp(l9_2296,0.0,1.0);
float3 l9_2298=float3(l9_2297);
l9_2290.directDiffuse+=((l9_2298*l9_2291.color)*l9_2291.attenuation);
SurfaceProperties l9_2299=l9_2292;
float3 l9_2300=l9_2291.direction;
float3 l9_2301=l9_2293;
l9_2290.directSpecular+=((calculateDirectSpecular(l9_2299,l9_2300,l9_2301)*l9_2291.color)*l9_2291.attenuation);
LightingComponents l9_2302=l9_2290;
l9_2230=l9_2302;
}
l9_2232++;
l9_2257++;
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
float3 l9_2303=float3(0.0);
if ((int(sc_ProjectiveShadowsReceiver_tmp)!=0))
{
float2 l9_2304=abs(in.varShadowTex-float2(0.5));
float l9_2305=fast::max(l9_2304.x,l9_2304.y);
float l9_2306=step(l9_2305,0.5);
float4 l9_2307=sc_set0.sc_ShadowTexture.sample(sc_set0.sc_ShadowTextureSmpSC,in.varShadowTex)*l9_2306;
float3 l9_2308=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_2307.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float l9_2309=l9_2307.w*(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity;
l9_2303=mix(float3(1.0),l9_2308,float3(l9_2309));
}
else
{
l9_2303=float3(1.0);
}
float3 l9_2310=l9_2303;
float3 l9_2311=l9_2310;
l9_2230.directDiffuse*=l9_2311;
l9_2230.directSpecular*=l9_2311;
}
SurfaceProperties l9_2312=l9_2227;
float3 l9_2313=l9_2312.normal;
float3 l9_2314=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
float3 l9_2315=l9_2313;
float4 l9_2316=float4(0.0);
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp)
{
float3 l9_2317=l9_2315;
float l9_2318=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_2319=float2(0.0);
float l9_2320=l9_2317.x;
float l9_2321=-l9_2317.z;
float l9_2322=(l9_2320<0.0) ? (-1.0) : 1.0;
float l9_2323=l9_2322*acos(fast::clamp(l9_2321/length(float2(l9_2320,l9_2321)),-1.0,1.0));
l9_2319.x=l9_2323-1.5707964;
l9_2319.y=acos(l9_2317.y);
l9_2319/=float2(6.2831855,3.1415927);
l9_2319.y=1.0-l9_2319.y;
l9_2319.x+=(l9_2318/360.0);
l9_2319.x=fract((l9_2319.x+floor(l9_2319.x))+1.0);
float2 l9_2324=l9_2319;
float2 l9_2325=l9_2324;
if (SC_DEVICE_CLASS_tmp>=2)
{
float2 l9_2326=l9_2325;
float2 l9_2327=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_2328=5.0;
l9_2325=calcSeamlessPanoramicUvsForSampling(l9_2326,l9_2327,l9_2328);
}
float2 l9_2329=l9_2325;
float l9_2330=13.0;
int l9_2331;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2332=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2332=0;
}
else
{
l9_2332=in.varStereoViewID;
}
int l9_2333=l9_2332;
l9_2331=1-l9_2333;
}
else
{
int l9_2334=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2334=0;
}
else
{
l9_2334=in.varStereoViewID;
}
int l9_2335=l9_2334;
l9_2331=l9_2335;
}
int l9_2336=l9_2331;
float2 l9_2337=l9_2329;
int l9_2338=sc_EnvmapSpecularLayout_tmp;
int l9_2339=l9_2336;
float l9_2340=l9_2330;
float2 l9_2341=l9_2337;
int l9_2342=l9_2338;
int l9_2343=l9_2339;
float3 l9_2344=float3(0.0);
if (l9_2342==0)
{
l9_2344=float3(l9_2341,0.0);
}
else
{
if (l9_2342==1)
{
l9_2344=float3(l9_2341.x,(l9_2341.y*0.5)+(0.5-(float(l9_2343)*0.5)),0.0);
}
else
{
l9_2344=float3(l9_2341,float(l9_2343));
}
}
float3 l9_2345=l9_2344;
float3 l9_2346=l9_2345;
float4 l9_2347=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2346.xy,bias(l9_2340));
float4 l9_2348=l9_2347;
l9_2316=l9_2348;
}
else
{
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_2349=l9_2315;
float l9_2350=0.18000001;
float l9_2351=4.5;
float3 l9_2352=l9_2349;
float3 l9_2353=float3(((-l9_2352.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_2352.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_2352.y,(l9_2352.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_2352.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
l9_2349=l9_2353;
float3 l9_2354;
if (abs(l9_2349.z)<0.99000001)
{
l9_2354=float3(-l9_2349.y,l9_2349.x,0.0);
}
else
{
l9_2354=float3(0.0,-l9_2349.z,l9_2349.y);
}
float3 l9_2355=normalize(l9_2354);
float3 l9_2356=cross(l9_2349,l9_2355);
float3 l9_2357=l9_2349+(((l9_2355*1.0)+(l9_2356*0.0))*l9_2350);
float3 l9_2358=l9_2349+(((l9_2355*(-0.5))+(l9_2356*0.86602539))*l9_2350);
float3 l9_2359=l9_2349+(((l9_2355*(-0.5))-(l9_2356*0.86602539))*l9_2350);
float3 l9_2360=l9_2357;
bool l9_2361=true;
float l9_2362=l9_2351;
float4 l9_2363;
if (l9_2361)
{
l9_2363=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2360,level(l9_2362));
}
else
{
l9_2363=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2360,bias(l9_2362));
}
float4 l9_2364=l9_2363;
float4 l9_2365=l9_2364;
float3 l9_2366=l9_2358;
bool l9_2367=true;
float l9_2368=l9_2351;
float4 l9_2369;
if (l9_2367)
{
l9_2369=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2366,level(l9_2368));
}
else
{
l9_2369=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2366,bias(l9_2368));
}
float4 l9_2370=l9_2369;
float4 l9_2371=l9_2370;
float3 l9_2372=l9_2359;
bool l9_2373=true;
float l9_2374=l9_2351;
float4 l9_2375;
if (l9_2373)
{
l9_2375=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2372,level(l9_2374));
}
else
{
l9_2375=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2372,bias(l9_2374));
}
float4 l9_2376=l9_2375;
float4 l9_2377=l9_2376;
float4 l9_2378=((l9_2365+l9_2371)+l9_2377)*0.33333334;
l9_2316=l9_2378;
}
else
{
float3 l9_2379=l9_2315;
float l9_2380=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_2381=float2(0.0);
float l9_2382=l9_2379.x;
float l9_2383=-l9_2379.z;
float l9_2384=(l9_2382<0.0) ? (-1.0) : 1.0;
float l9_2385=l9_2384*acos(fast::clamp(l9_2383/length(float2(l9_2382,l9_2383)),-1.0,1.0));
l9_2381.x=l9_2385-1.5707964;
l9_2381.y=acos(l9_2379.y);
l9_2381/=float2(6.2831855,3.1415927);
l9_2381.y=1.0-l9_2381.y;
l9_2381.x+=(l9_2380/360.0);
l9_2381.x=fract((l9_2381.x+floor(l9_2381.x))+1.0);
float2 l9_2386=l9_2381;
float2 l9_2387=l9_2386;
if ((int(sc_HasDiffuseEnvmap_tmp)!=0))
{
float2 l9_2388=l9_2387;
float2 l9_2389=(*sc_set1.sc_LightingUBO).sc_EnvmapDiffuseSize.xy;
float l9_2390=0.0;
l9_2387=calcSeamlessPanoramicUvsForSampling(l9_2388,l9_2389,l9_2390);
float2 l9_2391=l9_2387;
float l9_2392=-13.0;
int l9_2393;
if ((int(sc_EnvmapDiffuseHasSwappedViews_tmp)!=0))
{
int l9_2394=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2394=0;
}
else
{
l9_2394=in.varStereoViewID;
}
int l9_2395=l9_2394;
l9_2393=1-l9_2395;
}
else
{
int l9_2396=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2396=0;
}
else
{
l9_2396=in.varStereoViewID;
}
int l9_2397=l9_2396;
l9_2393=l9_2397;
}
int l9_2398=l9_2393;
float2 l9_2399=l9_2391;
int l9_2400=sc_EnvmapDiffuseLayout_tmp;
int l9_2401=l9_2398;
float l9_2402=l9_2392;
float2 l9_2403=l9_2399;
int l9_2404=l9_2400;
int l9_2405=l9_2401;
float3 l9_2406=float3(0.0);
if (l9_2404==0)
{
l9_2406=float3(l9_2403,0.0);
}
else
{
if (l9_2404==1)
{
l9_2406=float3(l9_2403.x,(l9_2403.y*0.5)+(0.5-(float(l9_2405)*0.5)),0.0);
}
else
{
l9_2406=float3(l9_2403,float(l9_2405));
}
}
float3 l9_2407=l9_2406;
float3 l9_2408=l9_2407;
float4 l9_2409=sc_set0.sc_EnvmapDiffuse.sample(sc_set0.sc_EnvmapDiffuseSmpSC,l9_2408.xy,bias(l9_2402));
float4 l9_2410=l9_2409;
l9_2316=l9_2410;
}
else
{
float2 l9_2411=l9_2387;
float l9_2412=13.0;
int l9_2413;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2414=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2414=0;
}
else
{
l9_2414=in.varStereoViewID;
}
int l9_2415=l9_2414;
l9_2413=1-l9_2415;
}
else
{
int l9_2416=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2416=0;
}
else
{
l9_2416=in.varStereoViewID;
}
int l9_2417=l9_2416;
l9_2413=l9_2417;
}
int l9_2418=l9_2413;
float2 l9_2419=l9_2411;
int l9_2420=sc_EnvmapSpecularLayout_tmp;
int l9_2421=l9_2418;
float l9_2422=l9_2412;
float2 l9_2423=l9_2419;
int l9_2424=l9_2420;
int l9_2425=l9_2421;
float3 l9_2426=float3(0.0);
if (l9_2424==0)
{
l9_2426=float3(l9_2423,0.0);
}
else
{
if (l9_2424==1)
{
l9_2426=float3(l9_2423.x,(l9_2423.y*0.5)+(0.5-(float(l9_2425)*0.5)),0.0);
}
else
{
l9_2426=float3(l9_2423,float(l9_2425));
}
}
float3 l9_2427=l9_2426;
float3 l9_2428=l9_2427;
float4 l9_2429=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2428.xy,bias(l9_2422));
float4 l9_2430=l9_2429;
l9_2316=l9_2430;
}
}
}
float4 l9_2431=l9_2316;
float3 l9_2432=l9_2431.xyz*(1.0/fast::max(l9_2431.w,0.0039215689));
float3 l9_2433=l9_2432*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_2314=l9_2433;
}
else
{
if (sc_EnvLightMode_tmp==sc_AmbientLightMode_SphericalHarmonics_tmp)
{
float3 l9_2434=(*sc_set1.sc_LightingUBO).sc_Sh[0];
float3 l9_2435=(*sc_set1.sc_LightingUBO).sc_Sh[1];
float3 l9_2436=(*sc_set1.sc_LightingUBO).sc_Sh[2];
float3 l9_2437=(*sc_set1.sc_LightingUBO).sc_Sh[3];
float3 l9_2438=(*sc_set1.sc_LightingUBO).sc_Sh[4];
float3 l9_2439=(*sc_set1.sc_LightingUBO).sc_Sh[5];
float3 l9_2440=(*sc_set1.sc_LightingUBO).sc_Sh[6];
float3 l9_2441=(*sc_set1.sc_LightingUBO).sc_Sh[7];
float3 l9_2442=(*sc_set1.sc_LightingUBO).sc_Sh[8];
float3 l9_2443=-l9_2313;
float l9_2444=0.0;
l9_2444=l9_2443.x;
float l9_2445=l9_2443.y;
float l9_2446=l9_2443.z;
float l9_2447=l9_2444*l9_2444;
float l9_2448=l9_2445*l9_2445;
float l9_2449=l9_2446*l9_2446;
float l9_2450=l9_2444*l9_2445;
float l9_2451=l9_2445*l9_2446;
float l9_2452=l9_2444*l9_2446;
float3 l9_2453=((((((l9_2442*0.42904299)*(l9_2447-l9_2448))+((l9_2440*0.74312502)*l9_2449))+(l9_2434*0.88622701))-(l9_2440*0.24770799))+((((l9_2438*l9_2450)+(l9_2441*l9_2452))+(l9_2439*l9_2451))*0.85808599))+((((l9_2437*l9_2444)+(l9_2435*l9_2445))+(l9_2436*l9_2446))*1.0233279);
l9_2314=l9_2453*(*sc_set1.sc_LightingUBO).sc_ShIntensity;
}
}
if (sc_AmbientLightsCount_tmp>0)
{
if (sc_AmbientLightMode0_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_2314+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].intensity);
}
else
{
l9_2314.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[0].color.x);
}
}
if (sc_AmbientLightsCount_tmp>1)
{
if (sc_AmbientLightMode1_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_2314+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].intensity);
}
else
{
l9_2314.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[1].color.x);
}
}
if (sc_AmbientLightsCount_tmp>2)
{
if (sc_AmbientLightMode2_tmp==sc_AmbientLightMode_Constant_tmp)
{
l9_2314+=((*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].intensity);
}
else
{
l9_2314.x+=(1e-06*(*sc_set1.sc_LightingUBO).sc_AmbientLights[2].color.x);
}
}
if ((int(sc_LightEstimation_tmp)!=0))
{
float3 l9_2454=l9_2313;
float3 l9_2455=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight;
sc_SphericalGaussianLight_t l9_2456;
float l9_2457;
int l9_2458=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_2458<sc_LightEstimationSGCount_tmp)
{
l9_2456.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2458].color;
l9_2456.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2458].sharpness;
l9_2456.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2458].axis;
float3 l9_2459=l9_2454;
float l9_2460=dot(l9_2456.axis,l9_2459);
float l9_2461=l9_2456.sharpness;
float l9_2462=0.36000001;
float l9_2463=1.0/(4.0*l9_2462);
float l9_2464=exp(-l9_2461);
float l9_2465=l9_2464*l9_2464;
float l9_2466=1.0/l9_2461;
float l9_2467=(1.0+(2.0*l9_2465))-l9_2466;
float l9_2468=((l9_2464-l9_2465)*l9_2466)-l9_2465;
float l9_2469=sqrt(1.0-l9_2467);
float l9_2470=l9_2462*l9_2460;
float l9_2471=l9_2463*l9_2469;
float l9_2472=l9_2470+l9_2471;
float l9_2473=l9_2460;
float l9_2474=fast::clamp(l9_2473,0.0,1.0);
float l9_2475=l9_2474;
if (step(abs(l9_2470),l9_2471)>0.5)
{
l9_2457=(l9_2472*l9_2472)/l9_2469;
}
else
{
l9_2457=l9_2475;
}
l9_2475=l9_2457;
float l9_2476=(l9_2467*l9_2475)+l9_2468;
sc_SphericalGaussianLight_t l9_2477=l9_2456;
float3 l9_2478=(l9_2477.color/float3(l9_2477.sharpness))*6.2831855;
float3 l9_2479=(l9_2478*l9_2476)/float3(3.1415927);
l9_2455+=l9_2479;
l9_2458++;
continue;
}
else
{
break;
}
}
float3 l9_2480=l9_2455;
l9_2314+=l9_2480;
}
float3 l9_2481=l9_2314;
float3 l9_2482=l9_2481;
l9_2230.indirectDiffuse=l9_2482;
SurfaceProperties l9_2483=l9_2227;
float3 l9_2484=l9_2231;
float3 l9_2485=float3(0.0);
if ((sc_EnvLightMode_tmp==sc_AmbientLightMode_EnvironmentMap_tmp)||(sc_EnvLightMode_tmp==sc_AmbientLightMode_FromCamera_tmp))
{
SurfaceProperties l9_2486=l9_2483;
float3 l9_2487=l9_2484;
float3 l9_2488=l9_2486.normal;
float3 l9_2489=reflect(-l9_2487,l9_2488);
float3 l9_2490=l9_2488;
float3 l9_2491=l9_2489;
float l9_2492=l9_2486.roughness;
l9_2489=getSpecularDominantDir(l9_2490,l9_2491,l9_2492);
float l9_2493=l9_2486.roughness;
float l9_2494=pow(l9_2493,0.66666669);
float l9_2495=fast::clamp(l9_2494,0.0,1.0);
float l9_2496=l9_2495*5.0;
float l9_2497=l9_2496;
float l9_2498=l9_2497;
float3 l9_2499=l9_2489;
float l9_2500=l9_2498;
float3 l9_2501=l9_2499;
float l9_2502=l9_2500;
float4 l9_2503=float4(0.0);
if ((int(sc_HasSpecularCubemap_tmp)!=0))
{
float3 l9_2504=l9_2501;
float3 l9_2505=float3(((-l9_2504.z)*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y)-(l9_2504.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x),l9_2504.y,(l9_2504.z*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.x)-(l9_2504.x*(*sc_set1.sc_LightingUBO).sc_EnvmapRotationSinCos.y));
float3 l9_2506=l9_2505;
bool l9_2507=true;
float l9_2508=l9_2502;
float4 l9_2509;
if (l9_2507)
{
l9_2509=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2506,level(l9_2508));
}
else
{
l9_2509=sc_set0.sc_SpecularCubemap.sample(sc_set0.sc_SpecularCubemapSmpSC,l9_2506,bias(l9_2508));
}
float4 l9_2510=l9_2509;
l9_2503=l9_2510;
}
else
{
float3 l9_2511=l9_2501;
float l9_2512=(*sc_set1.sc_LightingUBO).sc_EnvmapRotation.y;
float2 l9_2513=float2(0.0);
float l9_2514=l9_2511.x;
float l9_2515=-l9_2511.z;
float l9_2516=(l9_2514<0.0) ? (-1.0) : 1.0;
float l9_2517=l9_2516*acos(fast::clamp(l9_2515/length(float2(l9_2514,l9_2515)),-1.0,1.0));
l9_2513.x=l9_2517-1.5707964;
l9_2513.y=acos(l9_2511.y);
l9_2513/=float2(6.2831855,3.1415927);
l9_2513.y=1.0-l9_2513.y;
l9_2513.x+=(l9_2512/360.0);
l9_2513.x=fract((l9_2513.x+floor(l9_2513.x))+1.0);
float2 l9_2518=l9_2513;
float2 l9_2519=l9_2518;
if (SC_DEVICE_CLASS_tmp>=2)
{
float l9_2520=floor(l9_2502);
float l9_2521=ceil(l9_2502);
float l9_2522=l9_2502-l9_2520;
float2 l9_2523=l9_2519;
float2 l9_2524=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_2525=l9_2520;
float2 l9_2526=calcSeamlessPanoramicUvsForSampling(l9_2523,l9_2524,l9_2525);
float2 l9_2527=l9_2526;
float l9_2528=l9_2520;
float2 l9_2529=l9_2527;
float l9_2530=l9_2528;
int l9_2531;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2532=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2532=0;
}
else
{
l9_2532=in.varStereoViewID;
}
int l9_2533=l9_2532;
l9_2531=1-l9_2533;
}
else
{
int l9_2534=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2534=0;
}
else
{
l9_2534=in.varStereoViewID;
}
int l9_2535=l9_2534;
l9_2531=l9_2535;
}
int l9_2536=l9_2531;
float2 l9_2537=l9_2529;
int l9_2538=sc_EnvmapSpecularLayout_tmp;
int l9_2539=l9_2536;
float l9_2540=l9_2530;
float2 l9_2541=l9_2537;
int l9_2542=l9_2538;
int l9_2543=l9_2539;
float3 l9_2544=float3(0.0);
if (l9_2542==0)
{
l9_2544=float3(l9_2541,0.0);
}
else
{
if (l9_2542==1)
{
l9_2544=float3(l9_2541.x,(l9_2541.y*0.5)+(0.5-(float(l9_2543)*0.5)),0.0);
}
else
{
l9_2544=float3(l9_2541,float(l9_2543));
}
}
float3 l9_2545=l9_2544;
float3 l9_2546=l9_2545;
float4 l9_2547=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2546.xy,level(l9_2540));
float4 l9_2548=l9_2547;
float4 l9_2549=l9_2548;
float4 l9_2550=l9_2549;
float2 l9_2551=l9_2519;
float2 l9_2552=(*sc_set1.sc_LightingUBO).sc_EnvmapSpecularSize.xy;
float l9_2553=l9_2521;
float2 l9_2554=calcSeamlessPanoramicUvsForSampling(l9_2551,l9_2552,l9_2553);
float2 l9_2555=l9_2554;
float l9_2556=l9_2521;
float2 l9_2557=l9_2555;
float l9_2558=l9_2556;
int l9_2559;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2560=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2560=0;
}
else
{
l9_2560=in.varStereoViewID;
}
int l9_2561=l9_2560;
l9_2559=1-l9_2561;
}
else
{
int l9_2562=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2562=0;
}
else
{
l9_2562=in.varStereoViewID;
}
int l9_2563=l9_2562;
l9_2559=l9_2563;
}
int l9_2564=l9_2559;
float2 l9_2565=l9_2557;
int l9_2566=sc_EnvmapSpecularLayout_tmp;
int l9_2567=l9_2564;
float l9_2568=l9_2558;
float2 l9_2569=l9_2565;
int l9_2570=l9_2566;
int l9_2571=l9_2567;
float3 l9_2572=float3(0.0);
if (l9_2570==0)
{
l9_2572=float3(l9_2569,0.0);
}
else
{
if (l9_2570==1)
{
l9_2572=float3(l9_2569.x,(l9_2569.y*0.5)+(0.5-(float(l9_2571)*0.5)),0.0);
}
else
{
l9_2572=float3(l9_2569,float(l9_2571));
}
}
float3 l9_2573=l9_2572;
float3 l9_2574=l9_2573;
float4 l9_2575=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2574.xy,level(l9_2568));
float4 l9_2576=l9_2575;
float4 l9_2577=l9_2576;
float4 l9_2578=l9_2577;
l9_2503=mix(l9_2550,l9_2578,float4(l9_2522));
}
else
{
float2 l9_2579=l9_2519;
float l9_2580=l9_2502;
float2 l9_2581=l9_2579;
float l9_2582=l9_2580;
int l9_2583;
if ((int(sc_EnvmapSpecularHasSwappedViews_tmp)!=0))
{
int l9_2584=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2584=0;
}
else
{
l9_2584=in.varStereoViewID;
}
int l9_2585=l9_2584;
l9_2583=1-l9_2585;
}
else
{
int l9_2586=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2586=0;
}
else
{
l9_2586=in.varStereoViewID;
}
int l9_2587=l9_2586;
l9_2583=l9_2587;
}
int l9_2588=l9_2583;
float2 l9_2589=l9_2581;
int l9_2590=sc_EnvmapSpecularLayout_tmp;
int l9_2591=l9_2588;
float l9_2592=l9_2582;
float2 l9_2593=l9_2589;
int l9_2594=l9_2590;
int l9_2595=l9_2591;
float3 l9_2596=float3(0.0);
if (l9_2594==0)
{
l9_2596=float3(l9_2593,0.0);
}
else
{
if (l9_2594==1)
{
l9_2596=float3(l9_2593.x,(l9_2593.y*0.5)+(0.5-(float(l9_2595)*0.5)),0.0);
}
else
{
l9_2596=float3(l9_2593,float(l9_2595));
}
}
float3 l9_2597=l9_2596;
float3 l9_2598=l9_2597;
float4 l9_2599=sc_set0.sc_EnvmapSpecular.sample(sc_set0.sc_EnvmapSpecularSmpSC,l9_2598.xy,level(l9_2592));
float4 l9_2600=l9_2599;
float4 l9_2601=l9_2600;
l9_2503=l9_2601;
}
}
float4 l9_2602=l9_2503;
float3 l9_2603=l9_2602.xyz*(1.0/fast::max(l9_2602.w,0.0039215689));
float3 l9_2604=l9_2603;
float3 l9_2605=l9_2604*(*sc_set1.sc_LightingUBO).sc_EnvmapExposure;
l9_2605.x+=(*sc_set1.sc_CameraUBO).sc_UniformConstants.x;
float3 l9_2606=l9_2605;
float3 l9_2607=l9_2606;
float l9_2608=abs(dot(l9_2488,l9_2487));
SurfaceProperties l9_2609=l9_2486;
float l9_2610=l9_2608;
float3 l9_2611=l9_2607*envBRDFApprox(l9_2609,l9_2610);
l9_2485+=l9_2611;
}
if ((int(sc_LightEstimation_tmp)!=0))
{
SurfaceProperties l9_2612=l9_2483;
float3 l9_2613=l9_2484;
float l9_2614=fast::clamp(l9_2612.roughness*l9_2612.roughness,0.0099999998,1.0);
float3 l9_2615=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.ambientLight*l9_2612.specColor;
sc_SphericalGaussianLight_t l9_2616;
sc_SphericalGaussianLight_t l9_2617;
sc_SphericalGaussianLight_t l9_2618;
int l9_2619=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_2619<sc_LightEstimationSGCount_tmp)
{
l9_2616.color=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2619].color;
l9_2616.sharpness=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2619].sharpness;
l9_2616.axis=(*sc_set1.sc_LightingUBO).sc_LightEstimationData.sg[l9_2619].axis;
float3 l9_2620=l9_2612.normal;
float l9_2621=l9_2614;
float3 l9_2622=l9_2613;
float3 l9_2623=l9_2612.specColor;
float3 l9_2624=l9_2620;
float l9_2625=l9_2621;
l9_2617.axis=l9_2624;
float l9_2626=l9_2625*l9_2625;
l9_2617.sharpness=2.0/l9_2626;
l9_2617.color=float3(1.0/(3.1415927*l9_2626));
sc_SphericalGaussianLight_t l9_2627=l9_2617;
sc_SphericalGaussianLight_t l9_2628=l9_2627;
sc_SphericalGaussianLight_t l9_2629=l9_2628;
float3 l9_2630=l9_2622;
l9_2618.axis=reflect(-l9_2630,l9_2629.axis);
l9_2618.color=l9_2629.color;
l9_2618.sharpness=l9_2629.sharpness;
l9_2618.sharpness/=(4.0*fast::max(dot(l9_2629.axis,l9_2630),9.9999997e-05));
sc_SphericalGaussianLight_t l9_2631=l9_2618;
sc_SphericalGaussianLight_t l9_2632=l9_2631;
sc_SphericalGaussianLight_t l9_2633=l9_2632;
sc_SphericalGaussianLight_t l9_2634=l9_2616;
float l9_2635=length((l9_2633.axis*l9_2633.sharpness)+(l9_2634.axis*l9_2634.sharpness));
float3 l9_2636=(l9_2633.color*exp((l9_2635-l9_2633.sharpness)-l9_2634.sharpness))*l9_2634.color;
float l9_2637=1.0-exp((-2.0)*l9_2635);
float3 l9_2638=((l9_2636*6.2831855)*l9_2637)/float3(l9_2635);
float3 l9_2639=l9_2638;
float3 l9_2640=l9_2632.axis;
float l9_2641=l9_2621*l9_2621;
float l9_2642=dot(l9_2620,l9_2640);
float l9_2643=fast::clamp(l9_2642,0.0,1.0);
float l9_2644=l9_2643;
float l9_2645=dot(l9_2620,l9_2622);
float l9_2646=fast::clamp(l9_2645,0.0,1.0);
float l9_2647=l9_2646;
float3 l9_2648=normalize(l9_2632.axis+l9_2622);
float l9_2649=l9_2641;
float l9_2650=l9_2644;
float l9_2651=1.0/(l9_2650+sqrt(l9_2649+(((1.0-l9_2649)*l9_2650)*l9_2650)));
float l9_2652=l9_2641;
float l9_2653=l9_2647;
float l9_2654=1.0/(l9_2653+sqrt(l9_2652+(((1.0-l9_2652)*l9_2653)*l9_2653)));
l9_2639*=(l9_2651*l9_2654);
float l9_2655=dot(l9_2640,l9_2648);
float l9_2656=fast::clamp(l9_2655,0.0,1.0);
float l9_2657=pow(1.0-l9_2656,5.0);
l9_2639*=(l9_2623+((float3(1.0)-l9_2623)*l9_2657));
l9_2639*=l9_2644;
float3 l9_2658=l9_2639;
l9_2615+=l9_2658;
l9_2619++;
continue;
}
else
{
break;
}
}
float3 l9_2659=l9_2615;
l9_2485+=l9_2659;
}
float3 l9_2660=l9_2485;
l9_2230.indirectSpecular=l9_2660;
LightingComponents l9_2661=l9_2230;
LightingComponents l9_2662=l9_2661;
if (sc_BlendMode_tmp==9)
{
l9_2662.directDiffuse=float3(0.0);
l9_2662.indirectDiffuse=float3(0.0);
float4 l9_2663=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_2664=out.sc_FragData0;
l9_2663=l9_2664;
}
else
{
float4 l9_2665=gl_FragCoord;
float2 l9_2666=l9_2665.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_2667=l9_2666;
float2 l9_2668=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_2669=1;
int l9_2670=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2670=0;
}
else
{
l9_2670=in.varStereoViewID;
}
int l9_2671=l9_2670;
int l9_2672=l9_2671;
float3 l9_2673=float3(l9_2667,0.0);
int l9_2674=l9_2669;
int l9_2675=l9_2672;
if (l9_2674==1)
{
l9_2673.y=((2.0*l9_2673.y)+float(l9_2675))-1.0;
}
float2 l9_2676=l9_2673.xy;
l9_2668=l9_2676;
}
else
{
l9_2668=l9_2667;
}
float2 l9_2677=l9_2668;
float2 l9_2678=l9_2677;
float2 l9_2679=l9_2678;
float2 l9_2680=l9_2679;
float l9_2681=0.0;
int l9_2682;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_2683=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2683=0;
}
else
{
l9_2683=in.varStereoViewID;
}
int l9_2684=l9_2683;
l9_2682=1-l9_2684;
}
else
{
int l9_2685=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2685=0;
}
else
{
l9_2685=in.varStereoViewID;
}
int l9_2686=l9_2685;
l9_2682=l9_2686;
}
int l9_2687=l9_2682;
float2 l9_2688=l9_2680;
int l9_2689=sc_ScreenTextureLayout_tmp;
int l9_2690=l9_2687;
float l9_2691=l9_2681;
float2 l9_2692=l9_2688;
int l9_2693=l9_2689;
int l9_2694=l9_2690;
float3 l9_2695=float3(0.0);
if (l9_2693==0)
{
l9_2695=float3(l9_2692,0.0);
}
else
{
if (l9_2693==1)
{
l9_2695=float3(l9_2692.x,(l9_2692.y*0.5)+(0.5-(float(l9_2694)*0.5)),0.0);
}
else
{
l9_2695=float3(l9_2692,float(l9_2694));
}
}
float3 l9_2696=l9_2695;
float3 l9_2697=l9_2696;
float4 l9_2698=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_2697.xy,bias(l9_2691));
float4 l9_2699=l9_2698;
float4 l9_2700=l9_2699;
l9_2663=l9_2700;
}
float4 l9_2701=l9_2663;
float3 l9_2702=l9_2701.xyz;
float3 l9_2703;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2703=float3(pow(l9_2702.x,2.2),pow(l9_2702.y,2.2),pow(l9_2702.z,2.2));
}
else
{
l9_2703=l9_2702*l9_2702;
}
float3 l9_2704=l9_2703;
float3 l9_2705=l9_2704;
l9_2662.transmitted=l9_2705*mix(float3(1.0),l9_2214.albedo,float3(l9_2214.opacity));
l9_2214.opacity=1.0;
}
bool l9_2706=false;
if (sc_BlendMode_tmp==4)
{
l9_2706=true;
}
SurfaceProperties l9_2707=l9_2214;
LightingComponents l9_2708=l9_2662;
bool l9_2709=l9_2706;
float3 l9_2710=l9_2707.albedo*(l9_2708.directDiffuse+(l9_2708.indirectDiffuse*l9_2707.ao));
float3 l9_2711=l9_2708.directSpecular+(l9_2708.indirectSpecular*l9_2707.specularAo);
float3 l9_2712=l9_2707.emissive;
float3 l9_2713=l9_2708.transmitted;
if (l9_2709)
{
float l9_2714=l9_2707.opacity;
l9_2710*=srgbToLinear(l9_2714);
}
float3 l9_2715=((l9_2710+l9_2711)+l9_2712)+l9_2713;
float3 l9_2716=l9_2715;
float4 l9_2717=float4(l9_2716,l9_2214.opacity);
if (sc_BlendMode_tmp!=1)
{
float3 l9_2718=l9_2717.xyz;
float l9_2719=1.8;
float l9_2720=1.4;
float l9_2721=0.5;
float l9_2722=1.5;
float3 l9_2723=(l9_2718*((l9_2718*l9_2719)+float3(l9_2720)))/((l9_2718*((l9_2718*l9_2719)+float3(l9_2721)))+float3(l9_2722));
l9_2717=float4(l9_2723.x,l9_2723.y,l9_2723.z,l9_2717.w);
}
float3 l9_2724=l9_2717.xyz;
float l9_2725=l9_2724.x;
float l9_2726=l9_2724.y;
float l9_2727=l9_2724.z;
float3 l9_2728=float3(linearToSrgb(l9_2725),linearToSrgb(l9_2726),linearToSrgb(l9_2727));
l9_2717=float4(l9_2728.x,l9_2728.y,l9_2728.z,l9_2717.w);
float4 l9_2729=l9_2717;
l9_2200=l9_2729;
}
l9_2200=fast::max(l9_2200,float4(0.0));
l9_2187=l9_2200;
float4 l9_2730=float4(0.0);
float4 l9_2731=l9_1644;
float l9_2732=l9_227;
float3 l9_2733=l9_233;
float4 l9_2734=l9_234;
float l9_2735=l9_235;
float4 l9_2736=l9_2187;
ssGlobals l9_2737=param_3;
tempGlobals=l9_2737;
float4 l9_2738=float4(0.0);
N31_PbrIn=l9_2731;
N31_EnableTransmission=(int(ENABLE_TRANSMISSION_tmp)!=0);
N31_Opacity=l9_2732;
N31_Background=l9_2733;
N31_EnableSheen=(int(ENABLE_SHEEN_tmp)!=0);
N31_SheenColor=l9_2734;
N31_EnableClearcoat=(int(ENABLE_CLEARCOAT_tmp)!=0);
N31_ClearcoatBase=l9_2735;
N31_ClearcoatColor=l9_2736;
N31_Result=N31_PbrIn;
if ((N31_EnableSheen||N31_EnableTransmission)||N31_EnableClearcoat)
{
float4 l9_2739=N31_Result;
float4 l9_2740;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2740=float4(pow(l9_2739.x,2.2),pow(l9_2739.y,2.2),pow(l9_2739.z,2.2),pow(l9_2739.w,2.2));
}
else
{
l9_2740=l9_2739*l9_2739;
}
float4 l9_2741=l9_2740;
N31_Result=l9_2741;
if (N31_EnableSheen)
{
float l9_2742=N31_SheenColor.w;
float3 l9_2743=(N31_Result.xyz*l9_2742)+N31_SheenColor.xyz;
N31_Result=float4(l9_2743.x,l9_2743.y,l9_2743.z,N31_Result.w);
}
if (N31_EnableTransmission)
{
float4 l9_2744=N31_Result;
float l9_2745=N31_Opacity;
float l9_2746;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2746=pow(l9_2745,2.2);
}
else
{
l9_2746=l9_2745*l9_2745;
}
float l9_2747=l9_2746;
N31_Result=mix(float4(N31_Background,1.0),l9_2744,float4(l9_2747));
N31_Result.w=1.0;
}
if (N31_EnableClearcoat)
{
float l9_2748=N31_ClearcoatBase;
float4 l9_2749=N31_ClearcoatColor;
float4 l9_2750;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2750=float4(pow(l9_2749.x,2.2),pow(l9_2749.y,2.2),pow(l9_2749.z,2.2),pow(l9_2749.w,2.2));
}
else
{
l9_2750=l9_2749*l9_2749;
}
float4 l9_2751=l9_2750;
float4 l9_2752=l9_2751*l9_2748;
float3 l9_2753=N31_Result.xyz+l9_2752.xyz;
N31_Result=float4(l9_2753.x,l9_2753.y,l9_2753.z,N31_Result.w);
}
float4 l9_2754=N31_Result;
float4 l9_2755;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2755=float4(pow(l9_2754.x,0.45454544),pow(l9_2754.y,0.45454544),pow(l9_2754.z,0.45454544),pow(l9_2754.w,0.45454544));
}
else
{
l9_2755=sqrt(l9_2754);
}
float4 l9_2756=l9_2755;
N31_Result=l9_2756;
}
l9_2738=N31_Result;
l9_2730=l9_2738;
param=l9_2730;
param_2=param;
}
else
{
float4 l9_2757=float4(0.0);
float4 l9_2758=(*sc_set0.UserUniforms).baseColorFactor;
l9_2757=l9_2758;
float2 l9_2759=float2(0.0);
float2 l9_2760=(*sc_set0.UserUniforms).baseColorTexture_offset;
l9_2759=l9_2760;
float2 l9_2761=float2(0.0);
float2 l9_2762=(*sc_set0.UserUniforms).baseColorTexture_scale;
l9_2761=l9_2762;
float l9_2763=0.0;
float l9_2764=(*sc_set0.UserUniforms).baseColorTexture_rotation;
l9_2763=l9_2764;
float4 l9_2765=float4(0.0);
float4 l9_2766=l9_2757;
float2 l9_2767=l9_2759;
float2 l9_2768=l9_2761;
float l9_2769=l9_2763;
ssGlobals l9_2770=param_3;
tempGlobals=l9_2770;
float4 l9_2771=float4(0.0);
N35_EnableVertexColor=(int(ENABLE_VERTEX_COLOR_BASE_tmp)!=0);
N35_EnableBaseTexture=(int(ENABLE_BASE_TEX_tmp)!=0);
N35_BaseColorTextureCoord=NODE_7_DROPLIST_ITEM_tmp;
N35_BaseColorFactor=l9_2766;
N35_EnableTextureTransform=(int(ENABLE_TEXTURE_TRANSFORM_tmp)!=0);
N35_BaseTextureTransform=(int(ENABLE_BASE_TEXTURE_TRANSFORM_tmp)!=0);
N35_BaseTextureOffset=l9_2767;
N35_BaseTextureScale=l9_2768;
N35_BaseTextureRotation=l9_2769;
float4 l9_2772=N35_BaseColorFactor;
if (N35_EnableBaseTexture)
{
int l9_2773=N35_BaseColorTextureCoord;
float2 l9_2774=tempGlobals.Surface_UVCoord0;
float2 l9_2775=l9_2774;
if (l9_2773==0)
{
float2 l9_2776=tempGlobals.Surface_UVCoord0;
l9_2775=l9_2776;
}
if (l9_2773==1)
{
float2 l9_2777=tempGlobals.Surface_UVCoord1;
l9_2775=l9_2777;
}
float2 l9_2778=l9_2775;
float2 l9_2779=l9_2778;
if (N35_EnableTextureTransform&&N35_BaseTextureTransform)
{
float2 l9_2780=l9_2779;
float2 l9_2781=N35_BaseTextureOffset;
float2 l9_2782=N35_BaseTextureScale;
float l9_2783=N35_BaseTextureRotation;
float3x3 l9_2784=float3x3(float3(1.0,0.0,0.0),float3(0.0,1.0,0.0),float3(l9_2781.x,l9_2781.y,1.0));
float3x3 l9_2785=float3x3(float3(cos(l9_2783),sin(l9_2783),0.0),float3(-sin(l9_2783),cos(l9_2783),0.0),float3(0.0,0.0,1.0));
float3x3 l9_2786=float3x3(float3(l9_2782.x,0.0,0.0),float3(0.0,l9_2782.y,0.0),float3(0.0,0.0,1.0));
float3x3 l9_2787=(l9_2784*l9_2785)*l9_2786;
float2 l9_2788=(l9_2787*float3(l9_2780,1.0)).xy;
l9_2779=l9_2788;
}
float2 l9_2789=l9_2779;
float4 l9_2790=float4(0.0);
int l9_2791;
if ((int(baseColorTextureHasSwappedViews_tmp)!=0))
{
int l9_2792=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2792=0;
}
else
{
l9_2792=in.varStereoViewID;
}
int l9_2793=l9_2792;
l9_2791=1-l9_2793;
}
else
{
int l9_2794=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2794=0;
}
else
{
l9_2794=in.varStereoViewID;
}
int l9_2795=l9_2794;
l9_2791=l9_2795;
}
int l9_2796=l9_2791;
int l9_2797=baseColorTextureLayout_tmp;
int l9_2798=l9_2796;
float2 l9_2799=l9_2789;
bool l9_2800=(int(SC_USE_UV_TRANSFORM_baseColorTexture_tmp)!=0);
float3x3 l9_2801=(*sc_set0.UserUniforms).baseColorTextureTransform;
int2 l9_2802=int2(SC_SOFTWARE_WRAP_MODE_U_baseColorTexture_tmp,SC_SOFTWARE_WRAP_MODE_V_baseColorTexture_tmp);
bool l9_2803=(int(SC_USE_UV_MIN_MAX_baseColorTexture_tmp)!=0);
float4 l9_2804=(*sc_set0.UserUniforms).baseColorTextureUvMinMax;
bool l9_2805=(int(SC_USE_CLAMP_TO_BORDER_baseColorTexture_tmp)!=0);
float4 l9_2806=(*sc_set0.UserUniforms).baseColorTextureBorderColor;
float l9_2807=0.0;
bool l9_2808=l9_2805&&(!l9_2803);
float l9_2809=1.0;
float l9_2810=l9_2799.x;
int l9_2811=l9_2802.x;
if (l9_2811==1)
{
l9_2810=fract(l9_2810);
}
else
{
if (l9_2811==2)
{
float l9_2812=fract(l9_2810);
float l9_2813=l9_2810-l9_2812;
float l9_2814=step(0.25,fract(l9_2813*0.5));
l9_2810=mix(l9_2812,1.0-l9_2812,fast::clamp(l9_2814,0.0,1.0));
}
}
l9_2799.x=l9_2810;
float l9_2815=l9_2799.y;
int l9_2816=l9_2802.y;
if (l9_2816==1)
{
l9_2815=fract(l9_2815);
}
else
{
if (l9_2816==2)
{
float l9_2817=fract(l9_2815);
float l9_2818=l9_2815-l9_2817;
float l9_2819=step(0.25,fract(l9_2818*0.5));
l9_2815=mix(l9_2817,1.0-l9_2817,fast::clamp(l9_2819,0.0,1.0));
}
}
l9_2799.y=l9_2815;
if (l9_2803)
{
bool l9_2820=l9_2805;
bool l9_2821;
if (l9_2820)
{
l9_2821=l9_2802.x==3;
}
else
{
l9_2821=l9_2820;
}
float l9_2822=l9_2799.x;
float l9_2823=l9_2804.x;
float l9_2824=l9_2804.z;
bool l9_2825=l9_2821;
float l9_2826=l9_2809;
float l9_2827=fast::clamp(l9_2822,l9_2823,l9_2824);
float l9_2828=step(abs(l9_2822-l9_2827),9.9999997e-06);
l9_2826*=(l9_2828+((1.0-float(l9_2825))*(1.0-l9_2828)));
l9_2822=l9_2827;
l9_2799.x=l9_2822;
l9_2809=l9_2826;
bool l9_2829=l9_2805;
bool l9_2830;
if (l9_2829)
{
l9_2830=l9_2802.y==3;
}
else
{
l9_2830=l9_2829;
}
float l9_2831=l9_2799.y;
float l9_2832=l9_2804.y;
float l9_2833=l9_2804.w;
bool l9_2834=l9_2830;
float l9_2835=l9_2809;
float l9_2836=fast::clamp(l9_2831,l9_2832,l9_2833);
float l9_2837=step(abs(l9_2831-l9_2836),9.9999997e-06);
l9_2835*=(l9_2837+((1.0-float(l9_2834))*(1.0-l9_2837)));
l9_2831=l9_2836;
l9_2799.y=l9_2831;
l9_2809=l9_2835;
}
float2 l9_2838=l9_2799;
bool l9_2839=l9_2800;
float3x3 l9_2840=l9_2801;
if (l9_2839)
{
l9_2838=float2((l9_2840*float3(l9_2838,1.0)).xy);
}
float2 l9_2841=l9_2838;
l9_2799=l9_2841;
float l9_2842=l9_2799.x;
int l9_2843=l9_2802.x;
bool l9_2844=l9_2808;
float l9_2845=l9_2809;
if ((l9_2843==0)||(l9_2843==3))
{
float l9_2846=l9_2842;
float l9_2847=0.0;
float l9_2848=1.0;
bool l9_2849=l9_2844;
float l9_2850=l9_2845;
float l9_2851=fast::clamp(l9_2846,l9_2847,l9_2848);
float l9_2852=step(abs(l9_2846-l9_2851),9.9999997e-06);
l9_2850*=(l9_2852+((1.0-float(l9_2849))*(1.0-l9_2852)));
l9_2846=l9_2851;
l9_2842=l9_2846;
l9_2845=l9_2850;
}
l9_2799.x=l9_2842;
l9_2809=l9_2845;
float l9_2853=l9_2799.y;
int l9_2854=l9_2802.y;
bool l9_2855=l9_2808;
float l9_2856=l9_2809;
if ((l9_2854==0)||(l9_2854==3))
{
float l9_2857=l9_2853;
float l9_2858=0.0;
float l9_2859=1.0;
bool l9_2860=l9_2855;
float l9_2861=l9_2856;
float l9_2862=fast::clamp(l9_2857,l9_2858,l9_2859);
float l9_2863=step(abs(l9_2857-l9_2862),9.9999997e-06);
l9_2861*=(l9_2863+((1.0-float(l9_2860))*(1.0-l9_2863)));
l9_2857=l9_2862;
l9_2853=l9_2857;
l9_2856=l9_2861;
}
l9_2799.y=l9_2853;
l9_2809=l9_2856;
float2 l9_2864=l9_2799;
int l9_2865=l9_2797;
int l9_2866=l9_2798;
float l9_2867=l9_2807;
float2 l9_2868=l9_2864;
int l9_2869=l9_2865;
int l9_2870=l9_2866;
float3 l9_2871=float3(0.0);
if (l9_2869==0)
{
l9_2871=float3(l9_2868,0.0);
}
else
{
if (l9_2869==1)
{
l9_2871=float3(l9_2868.x,(l9_2868.y*0.5)+(0.5-(float(l9_2870)*0.5)),0.0);
}
else
{
l9_2871=float3(l9_2868,float(l9_2870));
}
}
float3 l9_2872=l9_2871;
float3 l9_2873=l9_2872;
float4 l9_2874=sc_set0.baseColorTexture.sample(sc_set0.baseColorTextureSmpSC,l9_2873.xy,bias(l9_2867));
float4 l9_2875=l9_2874;
if (l9_2805)
{
l9_2875=mix(l9_2806,l9_2875,float4(l9_2809));
}
float4 l9_2876=l9_2875;
l9_2790=l9_2876;
float4 l9_2877=l9_2790;
float4 l9_2878=l9_2877;
float4 l9_2879;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2879=float4(pow(l9_2878.x,2.2),pow(l9_2878.y,2.2),pow(l9_2878.z,2.2),pow(l9_2878.w,2.2));
}
else
{
l9_2879=l9_2878*l9_2878;
}
float4 l9_2880=l9_2879;
l9_2772*=l9_2880;
}
if (N35_EnableVertexColor)
{
float4 l9_2881=tempGlobals.VertexColor;
l9_2772*=l9_2881;
}
N35_BaseColor=l9_2772.xyz;
N35_Opacity=l9_2772.w;
float4 l9_2882=l9_2772;
float4 l9_2883;
if (SC_DEVICE_CLASS_tmp>=2)
{
l9_2883=float4(pow(l9_2882.x,0.45454544),pow(l9_2882.y,0.45454544),pow(l9_2882.z,0.45454544),pow(l9_2882.w,0.45454544));
}
else
{
l9_2883=sqrt(l9_2882);
}
float4 l9_2884=l9_2883;
N35_UnlitColor=l9_2884;
l9_2771=N35_UnlitColor;
l9_2765=l9_2771;
param_1=l9_2765;
param_2=param_1;
}
Output_N17=param_2;
FinalColor=Output_N17;
float4 param_4=FinalColor;
if ((int(sc_ProjectiveShadowsCaster_tmp)!=0))
{
float4 l9_2885=param_4;
float4 l9_2886=l9_2885;
float l9_2887=1.0;
if ((((sc_BlendMode_tmp==0)||(sc_BlendMode_tmp==5))||(sc_BlendMode_tmp==14))||(sc_BlendMode_tmp==16))
{
l9_2887=l9_2886.w;
}
else
{
if (sc_BlendMode_tmp==4)
{
l9_2887=fast::clamp(l9_2886.w*2.0,0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==8)
{
l9_2887=1.0;
}
else
{
if (sc_BlendMode_tmp==1)
{
l9_2887=(1.0-dot(l9_2886.xyz,float3(0.33333001)))*l9_2886.w;
}
else
{
if (sc_BlendMode_tmp==10)
{
l9_2887=(1.0-fast::clamp(dot(l9_2886.xyz,float3(1.0)),0.0,1.0))*l9_2886.w;
}
else
{
if (sc_BlendMode_tmp==9)
{
l9_2887=fast::clamp(dot(l9_2886.xyz,float3(1.0)),0.0,1.0)*l9_2886.w;
}
else
{
if (sc_BlendMode_tmp==2)
{
l9_2887=fast::clamp(dot(l9_2886.xyz,float3(1.0)),0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==7)
{
l9_2887=fast::clamp(dot(l9_2886.xyz,float3(1.0)),0.0,1.0)*l9_2886.w;
}
else
{
if (sc_BlendMode_tmp==3)
{
l9_2887=dot(l9_2886.xyz,float3(0.33333001))*l9_2886.w;
}
else
{
if (sc_BlendMode_tmp==11)
{
l9_2887=1.0-fast::clamp(dot(l9_2886.xyz,float3(1.0)),0.0,1.0);
}
else
{
if (sc_BlendMode_tmp==12)
{
l9_2887=fast::clamp(dot(l9_2886.xyz,float3(1.0)),0.0,1.0);
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
float l9_2888=l9_2887;
float l9_2889=l9_2888;
float l9_2890=(*sc_set2.sc_DrawCallUBO).sc_ShadowDensity*l9_2889;
float3 l9_2891=mix((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz,(*sc_set2.sc_DrawCallUBO).sc_ShadowColor.xyz*l9_2885.xyz,float3((*sc_set2.sc_DrawCallUBO).sc_ShadowColor.w));
float4 l9_2892=float4(l9_2891.x,l9_2891.y,l9_2891.z,l9_2890);
param_4=l9_2892;
}
else
{
if ((int(sc_RenderAlphaToColor_tmp)!=0))
{
param_4=float4(param_4.w);
}
else
{
if ((int(sc_BlendMode_Custom_tmp)!=0))
{
float4 l9_2893=param_4;
float4 l9_2894=float4(0.0);
float4 l9_2895=float4(0.0);
if ((int(sc_FramebufferFetch_tmp)!=0))
{
float4 l9_2896=out.sc_FragData0;
l9_2895=l9_2896;
}
else
{
float4 l9_2897=gl_FragCoord;
float2 l9_2898=l9_2897.xy*(*sc_set1.sc_CameraUBO).sc_CurrentRenderTargetDims.zw;
float2 l9_2899=l9_2898;
float2 l9_2900=float2(0.0);
if (sc_StereoRenderingMode_tmp==1)
{
int l9_2901=1;
int l9_2902=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2902=0;
}
else
{
l9_2902=in.varStereoViewID;
}
int l9_2903=l9_2902;
int l9_2904=l9_2903;
float3 l9_2905=float3(l9_2899,0.0);
int l9_2906=l9_2901;
int l9_2907=l9_2904;
if (l9_2906==1)
{
l9_2905.y=((2.0*l9_2905.y)+float(l9_2907))-1.0;
}
float2 l9_2908=l9_2905.xy;
l9_2900=l9_2908;
}
else
{
l9_2900=l9_2899;
}
float2 l9_2909=l9_2900;
float2 l9_2910=l9_2909;
float2 l9_2911=l9_2910;
float2 l9_2912=l9_2911;
float l9_2913=0.0;
int l9_2914;
if ((int(sc_ScreenTextureHasSwappedViews_tmp)!=0))
{
int l9_2915=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2915=0;
}
else
{
l9_2915=in.varStereoViewID;
}
int l9_2916=l9_2915;
l9_2914=1-l9_2916;
}
else
{
int l9_2917=0;
if (sc_StereoRenderingMode_tmp==0)
{
l9_2917=0;
}
else
{
l9_2917=in.varStereoViewID;
}
int l9_2918=l9_2917;
l9_2914=l9_2918;
}
int l9_2919=l9_2914;
float2 l9_2920=l9_2912;
int l9_2921=sc_ScreenTextureLayout_tmp;
int l9_2922=l9_2919;
float l9_2923=l9_2913;
float2 l9_2924=l9_2920;
int l9_2925=l9_2921;
int l9_2926=l9_2922;
float3 l9_2927=float3(0.0);
if (l9_2925==0)
{
l9_2927=float3(l9_2924,0.0);
}
else
{
if (l9_2925==1)
{
l9_2927=float3(l9_2924.x,(l9_2924.y*0.5)+(0.5-(float(l9_2926)*0.5)),0.0);
}
else
{
l9_2927=float3(l9_2924,float(l9_2926));
}
}
float3 l9_2928=l9_2927;
float3 l9_2929=l9_2928;
float4 l9_2930=sc_set0.sc_ScreenTexture.sample(sc_set0.sc_ScreenTextureSmpSC,l9_2929.xy,bias(l9_2923));
float4 l9_2931=l9_2930;
float4 l9_2932=l9_2931;
l9_2895=l9_2932;
}
float4 l9_2933=l9_2895;
float3 l9_2934=l9_2933.xyz;
float3 l9_2935=l9_2934;
float3 l9_2936=l9_2893.xyz;
float3 l9_2937=definedBlend(l9_2935,l9_2936,in.varStereoViewID,(*sc_set0.UserUniforms),sc_set0.intensityTexture,sc_set0.intensityTextureSmpSC);
l9_2894=float4(l9_2937.x,l9_2937.y,l9_2937.z,l9_2894.w);
float3 l9_2938=mix(l9_2934,l9_2894.xyz,float3(l9_2893.w));
l9_2894=float4(l9_2938.x,l9_2938.y,l9_2938.z,l9_2894.w);
l9_2894.w=1.0;
float4 l9_2939=l9_2894;
param_4=l9_2939;
}
else
{
if ((int(sc_Voxelization_tmp)!=0))
{
float4 l9_2940=float4(in.varScreenPos.xyz,1.0);
param_4=l9_2940;
}
else
{
if ((int(sc_OutputBounds_tmp)!=0))
{
float4 l9_2941=gl_FragCoord;
float l9_2942=fast::clamp(abs(l9_2941.z),0.0,1.0);
float4 l9_2943=float4(l9_2942,1.0-l9_2942,1.0,1.0);
param_4=l9_2943;
}
else
{
float4 l9_2944=param_4;
float4 l9_2945=float4(0.0);
if (sc_BlendMode_tmp==10)
{
l9_2945=float4(mix(float3(1.0),l9_2944.xyz,float3(l9_2944.w)),l9_2944.w);
}
else
{
if ((sc_BlendMode_tmp==3)||(sc_BlendMode_tmp==16))
{
float l9_2946=l9_2944.w;
if (sc_BlendMode_tmp==16)
{
l9_2946=fast::clamp(l9_2946,0.0,1.0);
}
l9_2945=float4(l9_2944.xyz*l9_2946,l9_2946);
}
else
{
l9_2945=l9_2944;
}
}
float4 l9_2947=l9_2945;
param_4=l9_2947;
}
}
}
}
}
float4 l9_2948=param_4;
FinalColor=l9_2948;
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
float4 l9_2949=float4(0.0);
float4 Cost=l9_2949;
if (Cost.w>0.0)
{
FinalColor=Cost;
}
FinalColor=fast::max(FinalColor,float4(0.0));
float4 param_5=FinalColor;
FinalColor=sc_OutputMotionVectorIfNeeded(param_5,in.varPosAndMotion,in.varNormalAndMotion);
float4 param_6=FinalColor;
float4 l9_2950=param_6;
if (sc_ShaderCacheConstant_tmp!=0)
{
l9_2950.x+=((*sc_set1.sc_CameraUBO).sc_UniformConstants.x*float(sc_ShaderCacheConstant_tmp));
}
out.sc_FragData0=l9_2950;
return out;
}
} // FRAGMENT SHADER
