#version 460 core
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

// From Core:
#include "render/shaders/common/render_color_conversion_common.h"
// From 3D:
#include "3d/shaders/common/3d_dm_indirect_lighting_common.h"

layout(push_constant, std430) uniform uPushConstant
{
	float unused;
};

layout(set = 0, binding = 1, std140) uniform uDeltaTime
{
	vec2 time; 
};

layout(set = 0, binding = 2, std140) uniform uInputResolution
{
	vec2 inputResolution;
};

layout(set = 1, binding = 0) uniform sampler uSampler;
layout(set = 1, binding = 1) uniform texture2D uLondon

layout (location = 0) in vec2 inUv;
layout (location = 0) out vec4 outColor;


void main(void)
{
	outColor = vec4(sin(time.x), 0.0f, 0.0f, 1.0f);
}