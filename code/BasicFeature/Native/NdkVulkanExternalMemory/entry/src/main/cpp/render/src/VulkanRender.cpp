/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "VulkanRender.h"
#include "utils/include/VulkanUtils.h"
#include <algorithm>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <hilog/log.h>
#include <iosfwd>
#include <iostream>
#include <native_buffer/native_buffer.h>
#include <optional>
#include <set>
#include <vector>

namespace NativeXComponentSample {
static bool inline CheckResult(VkResult result)
{
    if (result != VK_SUCCESS) {
        OH_LOG_INFO(LOG_APP, "Fatal : VkResult is %{public}d", static_cast<int>(result));
        return false;
    }
    return true;
}

VulkanRender::VulkanRender() { vkExample::utils::LoadVulkanLibrary(); }

VulkanRender::~VulkanRender() {}

// [Start setup_native_window]
void VulkanRender::SetupWindow(NativeWindow *nativeWindow)
{
    nativeWindow_ = nativeWindow;
    CreateInstance();
    vkExample::utils::LoadVulkanFunctions(instance_);
    CreateSurface();
    PickPhysicalDevice();
    CreateLogicalDevice();
    vkExample::utils::LoadVulkanFunctions(device_);

    createSwapChain();
    createRenderPass();
    createFrameBuffersAndImages();
    createVertexBuffer();
    createUniformBuffer();
    deviceInfoInitialized_ = true;
}
// [End setup_native_window]

bool VulkanRender::CreateInstance()
{
    VkApplicationInfo appInfo{};
    appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    appInfo.pApplicationName = "VideoRender";
    appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.pEngineName = "VideoRender";
    appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.apiVersion = VK_API_VERSION_1_0;

    VkInstanceCreateInfo createInfo{};
    createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    createInfo.pApplicationInfo = &appInfo;

    auto extensions = GetRequiredExtensions();
    if (extensions.size() > 0) {
        createInfo.enabledExtensionCount = static_cast<uint32_t>(extensions.size());
        createInfo.ppEnabledExtensionNames = extensions.data();
    }

    createInfo.enabledLayerCount = 0;
    createInfo.pNext = nullptr;
    if (vkCreateInstance == nullptr) {
        OH_LOG_INFO(LOG_APP, "vkCreateInstance is null! Failed to create instance!");
        return false;
    }

    bool res = CheckResult(vkCreateInstance(&createInfo, nullptr, &instance_));
    return res;
}

// Check whether all required extensions is supported when creating vkInstance
std::vector<const char *> VulkanRender::GetRequiredExtensions()
{
    std::vector<const char *> extensions = {VK_KHR_SURFACE_EXTENSION_NAME, VK_OHOS_SURFACE_EXTENSION_NAME};
    uint32_t extCount = 0;
    vkEnumerateInstanceExtensionProperties(nullptr, &extCount, nullptr);
    std::vector<VkExtensionProperties> availableExts(extCount);

    if (vkEnumerateInstanceExtensionProperties(nullptr, &extCount, availableExts.data()) == VK_SUCCESS) {
        for (const auto &availableExt : availableExts) {
            supportedInstanceExtensions_.push_back(availableExt.extensionName);
        }
    }

    if (enabledInstanceExtensions_.size() > 0) {
        for (const char *enabledExt : enabledInstanceExtensions_) {
            if (std::find(supportedInstanceExtensions_.begin(), supportedInstanceExtensions_.end(), enabledExt) ==
                supportedInstanceExtensions_.end()) {
                OH_LOG_INFO(LOG_APP, "Failed to enable instance extension %s", enabledExt);
            }
            extensions.push_back(enabledExt);
        }
    }
    return extensions;
}

// [Start create_surface]
bool VulkanRender::CreateSurface()
{
    VkSurfaceCreateInfoOHOS surfaceCreateInfo{};
    surfaceCreateInfo.sType = VK_STRUCTURE_TYPE_SURFACE_CREATE_INFO_OHOS;
    if (nativeWindow_ == nullptr) {
        OH_LOG_INFO(LOG_APP, "nativeWindow_ is nulptr.Failed to create surface !");
        return false;
    }
    surfaceCreateInfo.window = nativeWindow_;
    surfaceCreateInfo.flags = 0;
    surfaceCreateInfo.pNext = nullptr;
    bool res = CheckResult(vkCreateSurfaceOHOS(instance_, &surfaceCreateInfo, nullptr, &surface_));
    return res;
}
// [End create_surface]

bool VulkanRender::PickPhysicalDevice()
{
    uint32_t deviceCount = 0;
    vkEnumeratePhysicalDevices(instance_, &deviceCount, nullptr);

    if (deviceCount == 0) {
        OH_LOG_INFO(LOG_APP, "Failed to find GPUs with Vulkan support!");
        return false;
    }

    std::vector<VkPhysicalDevice> devices(deviceCount);
    vkEnumeratePhysicalDevices(instance_, &deviceCount, devices.data());
    for (const auto &device : devices) {
        if (IsDeviceSuitable(device)) {
            gpuDevice_ = device;
            break;
        }
    }
    return true;
}

// This suitable GPU should support graphics & present queue family and
// extension 'VK_KHR_SWAPCHAIN_EXTENSION_NAME'.
bool VulkanRender::IsDeviceSuitable(VkPhysicalDevice device)
{
    QueueFamilyIndices indices = FindQueueFamilies(device);

    bool extensionsSupported = CheckDeviceExtensionSupport(device);

    bool swapChainAdequate = true;
    if (extensionsSupported) {
        SwapChainSupportDetails swapchainSupport = QuerySwapChainSupport(device);
        swapChainAdequate = !swapchainSupport.formats.empty() && !swapchainSupport.presentModes.empty();
    }

    return indices.IsComplete() && extensionsSupported && swapChainAdequate;
}

// Check whether the physical device supports all required extensions.
bool VulkanRender::CheckDeviceExtensionSupport(VkPhysicalDevice device)
{
    uint32_t extensionCount;
    vkEnumerateDeviceExtensionProperties(device, nullptr, &extensionCount, nullptr);

    std::vector<VkExtensionProperties> availableExtensions(extensionCount);
    vkEnumerateDeviceExtensionProperties(device, nullptr, &extensionCount, availableExtensions.data());

    std::set<std::string> requiredExtensions(deviceExtensions_.begin(), deviceExtensions_.end());

    for (const auto &extension : availableExtensions) {
        requiredExtensions.erase(extension.extensionName);
    }

    return requiredExtensions.empty();
}

SwapChainSupportDetails VulkanRender::QuerySwapChainSupport(VkPhysicalDevice device)
{
    SwapChainSupportDetails details;
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface_, &details.capabilities);
    uint32_t formatCount;
    vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface_, &formatCount, nullptr);

    if (formatCount != 0) {
        details.formats.resize(formatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface_, &formatCount, details.formats.data());
    }

    uint32_t presentModeCount;
    vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface_, &presentModeCount, nullptr);

    if (presentModeCount != 0) {
        details.presentModes.resize(presentModeCount);
        vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface_, &presentModeCount, details.presentModes.data());
    }

    return details;
}

bool VulkanRender::CreateLogicalDevice()
{
    indices_ = FindQueueFamilies(gpuDevice_);
    std::vector<VkDeviceQueueCreateInfo> queueCreateInfos;
    std::set<uint32_t> uniqueQueueFamilies = {static_cast<uint32_t>(indices_.graphicsFamily),
                                              static_cast<uint32_t>(indices_.presentFamily)};

    float queuePriority = 1.0f;
    for (uint32_t queueFamily : uniqueQueueFamilies) {
        VkDeviceQueueCreateInfo queueCreateInfo{};
        queueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
        queueCreateInfo.queueFamilyIndex = queueFamily;
        queueCreateInfo.queueCount = 1;
        queueCreateInfo.pQueuePriorities = &queuePriority;
        queueCreateInfos.push_back(queueCreateInfo);
    }
    VkPhysicalDeviceFeatures deviceFeatures{};

    VkDeviceCreateInfo createInfo{};
    createInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;

    createInfo.queueCreateInfoCount = static_cast<uint32_t>(queueCreateInfos.size());
    createInfo.pQueueCreateInfos = queueCreateInfos.data();

    createInfo.pEnabledFeatures = &deviceFeatures;

    createInfo.enabledExtensionCount = static_cast<uint32_t>(deviceExtensions_.size());
    createInfo.ppEnabledExtensionNames = deviceExtensions_.data();
    createInfo.enabledLayerCount = 0;

    bool res = CheckResult(vkCreateDevice(gpuDevice_, &createInfo, nullptr, &device_));
    vkGetDeviceQueue(device_, indices_.graphicsFamily, 0, &graphicsQueue_);
    vkGetDeviceQueue(device_, indices_.presentFamily, 0, &presentQueue_);
    return res;
}

// Find graphics family index and present family index of the physical device.
QueueFamilyIndices VulkanRender::FindQueueFamilies(VkPhysicalDevice device)
{
    QueueFamilyIndices indices;

    uint32_t queueFamilyCount = 0;
    vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount, nullptr);

    std::vector<VkQueueFamilyProperties> queueFamilies(queueFamilyCount);
    vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount, queueFamilies.data());

    int i = 0;
    for (const auto &queueFamily : queueFamilies) {
        if (queueFamily.queueFlags & VK_QUEUE_GRAPHICS_BIT) {
            indices.graphicsFamily = i;
            queueFamilyIndex_ = i;
        }

        VkBool32 presentSupport = false;
        vkGetPhysicalDeviceSurfaceSupportKHR(device, i, surface_, &presentSupport);

        if (presentSupport) {
            indices.presentFamily = i;
        }

        if (indices.IsComplete()) {
            break;
        }
        i++;
    }

    return indices;
}

void VulkanRender::createSwapChain(uint32_t width, uint32_t height)
{
    // *******************************************************
    // Get the surface capabilities because:
    // - It contains the minimal and max length of the chain, we will need it
    // - It's necessary to query the supported surface format (R8G8B8A8 for instance ...)
    VkSurfaceCapabilitiesKHR surfaceCapabilities;
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(gpuDevice_, surface_, &surfaceCapabilities);
    // Query the list of supported surface format and choose one we Like
    uint32_t formatCount = 0;
    vkGetPhysicalDeviceSurfaceFormatsKHR(gpuDevice_, surface_, &formatCount, nullptr);
    std::vector<VkSurfaceFormatKHR> formats;
    if (formatCount != 0) {
        formats.resize(formatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(gpuDevice_, surface_, &formatCount, formats.data());
    }
    uint32_t chosenFormat;
    for (chosenFormat = 0; chosenFormat < formatCount; chosenFormat++) {
        if (formats[chosenFormat].format == VK_FORMAT_R8G8B8A8_UNORM)
            break;
    }

    if (width == 0 && height == 0) {
        swapchainInfo_.displaySize = surfaceCapabilities.currentExtent;
    } else {
        swapchainInfo_.displaySize = VkExtent2D{.width = width, .height = height};
    }
    swapchainInfo_.displayFormat = formats[chosenFormat].format;
    // **********************************************************
    // Create a swap chain (here we choose the minimum available number of surface
    // in the chain)

    VkSwapchainCreateInfoKHR swapchainCreateInfo{
        .sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .pNext = nullptr,
        .surface = surface_,
        .minImageCount = surfaceCapabilities.minImageCount,
        .imageFormat = formats[chosenFormat].format,
        .imageColorSpace = formats[chosenFormat].colorSpace,
        .imageExtent = swapchainInfo_.displaySize,
        .imageArrayLayers = 1,
        .imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
        .imageSharingMode = VK_SHARING_MODE_EXCLUSIVE,
        .queueFamilyIndexCount = 1,
        .pQueueFamilyIndices = &queueFamilyIndex_,
        .preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR,
        .compositeAlpha = VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR,
        .presentMode = VK_PRESENT_MODE_FIFO_KHR,
        .clipped = VK_TRUE,
        .oldSwapchain = VK_NULL_HANDLE
    };
    CheckResult(vkCreateSwapchainKHR(device_, &swapchainCreateInfo, nullptr, &swapchainInfo_.swapchain));
}

void VulkanRender::createRenderPass()
{
    VkAttachmentDescription attachmentDescriptions{
        .format = swapchainInfo_.displayFormat,
        .samples = VK_SAMPLE_COUNT_1_BIT,
        .loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR,
        .storeOp = VK_ATTACHMENT_STORE_OP_STORE,
        .stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE,
        .stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE,
        .initialLayout = VK_IMAGE_LAYOUT_UNDEFINED,
        .finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
    };

    VkAttachmentReference colorReference = {.attachment = 0, .layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL};

    VkSubpassDescription subpassDescription{
        .flags = 0,
        .pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS,
        .inputAttachmentCount = 0,
        .pInputAttachments = nullptr,
        .colorAttachmentCount = 1,
        .pColorAttachments = &colorReference,
        .pResolveAttachments = nullptr,
        .pDepthStencilAttachment = nullptr,
        .preserveAttachmentCount = 0,
        .pPreserveAttachments = nullptr
    };

    VkRenderPassCreateInfo renderPassCreateInfo{
        .sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO,
        .pNext = nullptr,
        .attachmentCount = 1,
        .pAttachments = &attachmentDescriptions,
        .subpassCount = 1,
        .pSubpasses = &subpassDescription,
        .dependencyCount = 0,
        .pDependencies = nullptr
    };
    CheckResult(vkCreateRenderPass(device_, &renderPassCreateInfo, nullptr, &renderInfo_.renderPass));
}

void VulkanRender::createFrameBuffersAndImages()
{
    // Get the Length of the created swap chain
    CheckResult(vkGetSwapchainImagesKHR(device_, swapchainInfo_.swapchain, &swapchainInfo_.swapchainLength, nullptr));

    swapchainInfo_.displayImages = new VkImage[swapchainInfo_.swapchainLength];
    CheckResult(vkGetSwapchainImagesKHR(device_, swapchainInfo_.swapchain, &swapchainInfo_.swapchainLength,
                                        swapchainInfo_.displayImages));
    // create image view for each swapchain image
    swapchainInfo_.displayViews = new VkImageView[swapchainInfo_.swapchainLength];
    for (uint32_t i = 0; i < swapchainInfo_.swapchainLength; i++) {
        VkImageViewCreateInfo viewCreateInfo = {
            .sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
            .pNext = nullptr,
            .flags = 0,
            .image = swapchainInfo_.displayImages[i],
            .viewType = VK_IMAGE_VIEW_TYPE_2D,
            .format = swapchainInfo_.displayFormat,
            .components = {.r = VK_COMPONENT_SWIZZLE_IDENTITY,
                           .g = VK_COMPONENT_SWIZZLE_IDENTITY,
                           .b = VK_COMPONENT_SWIZZLE_IDENTITY,
                           .a = VK_COMPONENT_SWIZZLE_IDENTITY},
            .subresourceRange =
                {
                    .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
                    .baseMipLevel = 0,
                    .levelCount = 1,
                    .baseArrayLayer = 0,
                    .layerCount = 1,
                }
        };
        CheckResult(vkCreateImageView(device_, &viewCreateInfo, nullptr, &swapchainInfo_.displayViews[i]));
    }

    // create a framebuffer fron each swapchain image
    swapchainInfo_.framebuffers = new VkFramebuffer[swapchainInfo_.swapchainLength];
    for (uint32_t i = 0; i < swapchainInfo_.swapchainLength; i++) {
        VkImageView attachments[] = {
            swapchainInfo_.displayViews[i],
        };
        VkFramebufferCreateInfo fbCreateInfo{
            .sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO,
            .pNext = nullptr,
            .renderPass = renderInfo_.renderPass,
            .attachmentCount = 1, // 2 if using depth
            .pAttachments = attachments,
            .width = static_cast<uint32_t>(swapchainInfo_.displaySize.width),
            .height = static_cast<uint32_t>(swapchainInfo_.displaySize.height),
            .layers = 1
        };

        CheckResult(vkCreateFramebuffer(device_, &fbCreateInfo, nullptr, &swapchainInfo_.framebuffers[i]));
    }
}

void VulkanRender::createBuffer(VkDeviceSize size, VkBufferUsageFlags usage, VkMemoryPropertyFlags properties,
                                VkBuffer &buffer, VkDeviceMemory &bufferMemory)
{
    VkBufferCreateInfo createBufferInfo{
        .sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0,
        .size = size,
        .usage = usage,
        .sharingMode = VK_SHARING_MODE_EXCLUSIVE,
        .queueFamilyIndexCount = 1,
        .pQueueFamilyIndices = &queueFamilyIndex_
    };
    CheckResult(vkCreateBuffer(device_, &createBufferInfo, nullptr, &buffer));
    VkMemoryRequirements memReq;
    vkGetBufferMemoryRequirements(device_, buffer, &memReq);
    VkMemoryAllocateInfo allocInfo{
        .sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .pNext = nullptr,
        .allocationSize = memReq.size,
        .memoryTypeIndex = 0, // Memory type assigned in the next step
    };
    // Assign the proper memory type for that buffer
    mapMemoryTypeToIndex(memReq.memoryTypeBits, properties, &allocInfo.memoryTypeIndex);
    CheckResult(vkAllocateMemory(device_, &allocInfo, nullptr, &bufferMemory));
    CheckResult(vkBindBufferMemory(device_, buffer, bufferMemory, 0));
}

// -1.0f, 1.θf, 0.0f, 1.0f, 1.0f,  // top left
// -1.0f, -1.θf, 0.0f, 1.0f, 0.0f, // top left
// 1.0f, -1.θf, 0.0f, 0.0f, 0.0f,  // top left
// 1.0f, 1.θf, 0.0f, 0.0f, 1.0f,  // top left
void VulkanRender::createVertexBuffer()
{
    const float vertexData[] = {-1.0f, -1.0f, 0.0f, 0.0f, 1.0f, -1.0f, 1.0f, 0.0f,
                                -1.0f, 1.0f,  0.0f, 1.0f, 1.0f, 1.0f,  1.0f, 1.0f};
    createBuffer(sizeof(vertexData), VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
                 VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, buffersInfo_.vertexBuf,
                 buffersInfo_.vertexBufferMemory);

    void *data;
    CheckResult(vkMapMemory(device_, buffersInfo_.vertexBufferMemory, 0, sizeof(vertexData), 0, &data));
    memcpy(data, vertexData, sizeof(vertexData));
    vkUnmapMemory(device_, buffersInfo_.vertexBufferMemory);
}

void VulkanRender::createUniformBuffer()
{
    createBuffer(sizeof(UniformBufferObject), VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT,
                 VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, buffersInfo_.uniformBuf,
                 buffersInfo_.uniformBufferMemory);
    CheckResult(vkMapMemory(device_, buffersInfo_.uniformBufferMemory, 0, sizeof(UniformBufferObject), 0,
                            &buffersInfo_.uniformBufferMapped));
}

// load spirv shaders in phone.
VkShaderModule VulkanRender::LoadSPIRVShader(std::string filename)
{
    // Read shader from sandbox. The path can be found in function aboutToAppear() in /ets/pages/Index.ets.
    std::string spvPath = "/data/storage/el2/base/haps/entry/files/rawfile/" + filename + ".spv";
    constexpr size_t maxShaderSize = 1000000;
    size_t shaderSize;
    char *shaderCode = nullptr;
    std::ifstream is(spvPath, std::ios::binary | std::ios::in | std::ios::ate);

    if (is.is_open()) {
        shaderSize = is.tellg();
        is.seekg(0, std::ios::beg);
        // Copy file contents into a buffer
        if (shaderSize == 0 || shaderSize > maxShaderSize) {
            OH_LOG_ERROR(LOG_APP, "Failed to load spriv shader. The shader size is invalid!");
        }
        shaderCode = new char[shaderSize];
        is.read(shaderCode, shaderSize);
        is.close();
    }

    if (shaderCode) {
        // Create a new shader module that will be used for pipeline creation
        VkShaderModuleCreateInfo moduleCreateInfo{};
        moduleCreateInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
        moduleCreateInfo.codeSize = shaderSize;
        moduleCreateInfo.pCode = (uint32_t *)shaderCode;

        VkShaderModule shaderModule;
        CheckResult(vkCreateShaderModule(device_, &moduleCreateInfo, NULL, &shaderModule));

        delete[] shaderCode;
        return shaderModule;
    } else {
        OH_LOG_ERROR(LOG_APP, "Failed to open shader file %{public}s", filename.c_str());
        return VK_NULL_HANDLE;
    }
}

void VulkanRender::createDescriptorSetLayout()
{
    const VkDescriptorSetLayoutBinding uboLayoutBinding = {
        .binding = 0,
        .descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptorCount = 1,
        .stageFlags = VK_SHADER_STAGE_VERTEX_BIT,
        .pImmutableSamplers = nullptr
    };
    const VkDescriptorSetLayoutBinding imageLayoutBinding{
        .binding = 1,
        .descriptorType = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptorCount = 1,
        .stageFlags = VK_SHADER_STAGE_FRAGMENT_BIT,
        .pImmutableSamplers = &externalTextureInfo_.sampler
    };
    const auto bindings = new VkDescriptorSetLayoutBinding[2];
    bindings[0] = uboLayoutBinding;
    bindings[1] = imageLayoutBinding;
    const VkDescriptorSetLayoutCreateInfo descriptorSetLayoutCreateInfo = {
        .sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
        .bindingCount = 2,
        .pBindings = bindings
    };
    CheckResult(
        vkCreateDescriptorSetLayout(device_, &descriptorSetLayoutCreateInfo, nullptr, &gfxPipelineInfo_.dscLayout));
    delete[] bindings;
}


void VulkanRender::createGraphicsPipeline()
{
    VkPipelineLayoutCreateInfo pipelineLayoutCreateInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
        .pNext = nullptr,
        .setLayoutCount = 1,
        .pSetLayouts = &gfxPipelineInfo_.dscLayout,
        .pushConstantRangeCount = 0,
        .pPushConstantRanges = nullptr
    };
    CheckResult(vkCreatePipelineLayout(device_, &pipelineLayoutCreateInfo, nullptr, &gfxPipelineInfo_.layout));
    auto dynamicStates = new VkDynamicState[2]{VK_DYNAMIC_STATE_VIEWPORT, VK_DYNAMIC_STATE_SCISSOR};
    VkPipelineDynamicStateCreateInfo dynamicStateInfo{.sType = VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO,
                                                      .pNext = nullptr,
                                                      .dynamicStateCount = 2,
                                                      .pDynamicStates = dynamicStates};

    VkShaderModule vertexShader = LoadSPIRVShader("vert");
    VkShaderModule fragmentShader = LoadSPIRVShader("frag");
    // Specify vertex and fragment shader stages
    VkPipelineShaderStageCreateInfo shaderStages[2]{{
                                                        .sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
                                                        .pNext = nullptr,
                                                        .flags = 0,
                                                        .stage = VK_SHADER_STAGE_VERTEX_BIT,
                                                        .module = vertexShader,
                                                        .pName = "main",
                                                        .pSpecializationInfo = nullptr
                                                    },
                                                    {
                                                        .sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,
                                                        .pNext = nullptr,
                                                        .flags = 0,
                                                        .stage = VK_SHADER_STAGE_FRAGMENT_BIT,
                                                        .module = fragmentShader,
                                                        .pName = "main",
                                                        .pSpecializationInfo = nullptr
                                                    }};
    VkViewport viewports{
        .x = 0,
        .y = 0,
        .width = (float)swapchainInfo_.displaySize.width,
        .height = (float)swapchainInfo_.displaySize.height,
        .minDepth = 0.0f,
        .maxDepth = 1.0f
    };

    VkRect2D scissor = {
        .offset =
            {
                .x = 0,
                .y = 0,
            },
        .extent = swapchainInfo_.displaySize
    };

    // Specify viewport info
    VkPipelineViewportStateCreateInfo viewportInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,
        .pNext = nullptr,
        .viewportCount = 1,
        .pViewports = &viewports,
        .pScissors = &scissor
    };

    // Specify multisample info
    VkSampleMask sampleMask = ~0u;
    VkPipelineMultisampleStateCreateInfo multisampleInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        .pNext = nullptr,
        .rasterizationSamples = VK_SAMPLE_COUNT_1_BIT,
        .sampleShadingEnable = VK_FALSE,
        .minSampleShading = 0,
        .pSampleMask = &sampleMask,
        .alphaToCoverageEnable = VK_FALSE,
        .alphaToOneEnable = VK_FALSE
    };

    // specify color blend state
    VkPipelineColorBlendAttachmentState attachmentStates{
        .blendEnable = VK_FALSE,
        .colorWriteMask =
            VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT | VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT
    };
    VkPipelineColorBlendStateCreateInfo colorBlendInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0,
        .logicOpEnable = VK_FALSE,
        .logicOp = VK_LOGIC_OP_COPY,
        .attachmentCount = 1,
        .pAttachments = &attachmentStates
    };

    // Specify rasterizer info
    VkPipelineRasterizationStateCreateInfo rasterInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
        .pNext = nullptr,
        .depthClampEnable = VK_FALSE,
        .rasterizerDiscardEnable = VK_FALSE,
        .polygonMode = VK_POLYGON_MODE_FILL,
        .cullMode = VK_CULL_MODE_NONE,
        .frontFace = VK_FRONT_FACE_CLOCKWISE,
        .depthBiasEnable = VK_FALSE,
        .lineWidth = 1
    };

    // Specify input assembler state
    VkPipelineInputAssemblyStateCreateInfo inputAssemblyInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
        .pNext = nullptr,
        .topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP,
        .primitiveRestartEnable = VK_FALSE
    };

    // Specify vertex input state
    VkVertexInputBindingDescription vertex_input_bindings{
        .binding = 0,
        .stride = 4 * sizeof(float),
        .inputRate = VK_VERTEX_INPUT_RATE_VERTEX
    };
    VkVertexInputAttributeDescription vertex_input_attributes[2]{{
                                                                     .location = 0,
                                                                     .binding = 0,
                                                                     .format = VK_FORMAT_R32G32B32_SFLOAT,
                                                                     .offset = 0
                                                                 },
                                                                 {
                                                                     .location = 1,
                                                                     .binding = 0,
                                                                     .format = VK_FORMAT_R32G32_SFLOAT,
                                                                     .offset = sizeof(float) * 2
                                                                 }};

    VkPipelineVertexInputStateCreateInfo vertexInputInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
        .pNext = nullptr,
        .vertexBindingDescriptionCount = 1,
        .pVertexBindingDescriptions = &vertex_input_bindings,
        .vertexAttributeDescriptionCount = 2,
        .pVertexAttributeDescriptions = vertex_input_attributes
    };

    // Create the pipeline cache
    VkPipelineCacheCreateInfo pipelineCacheInfo{
        .sType = VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0, // reserved, must be 0
        .initialDataSize = 0,
        .pInitialData = nullptr
    };

    CheckResult(vkCreatePipelineCache(device_, &pipelineCacheInfo, nullptr, &gfxPipelineInfo_.cache));

    // Create the pipeline
    VkGraphicsPipelineCreateInfo pipelineCreateInfo{
        .sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0,
        .stageCount = 2,
        .pStages = shaderStages,
        .pVertexInputState = &vertexInputInfo,
        .pInputAssemblyState = &inputAssemblyInfo,
        .pTessellationState = nullptr,
        .pViewportState = &viewportInfo,
        .pRasterizationState = &rasterInfo,
        .pMultisampleState = &multisampleInfo,
        .pDepthStencilState = nullptr,
        .pColorBlendState = &colorBlendInfo,
        .pDynamicState = &dynamicStateInfo,
        .layout = gfxPipelineInfo_.layout,
        .renderPass = renderInfo_.renderPass,
        .subpass = 0,
        .basePipelineHandle = VK_NULL_HANDLE,
        .basePipelineIndex = 0
    };

    CheckResult(vkCreateGraphicsPipelines(device_, gfxPipelineInfo_.cache, 1, &pipelineCreateInfo, nullptr,
                                          &gfxPipelineInfo_.pipeline));
    // We don't need the shaders anymore, we can release their memory
    vkDestroyShaderModule(device_, vertexShader, nullptr);
    vkDestroyShaderModule(device_, fragmentShader, nullptr);
}

void VulkanRender::createDescriptorSet()
{
    const VkDescriptorPoolSize pooLSizeUbo = {.type = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER, .descriptorCount = 1};
    const VkDescriptorPoolSize poolsizeSampler = {
        .type = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptorCount = 1,
    };
    const auto poolSizes = new VkDescriptorPoolSize[2];
    poolSizes[0] = pooLSizeUbo;
    poolSizes[1] = poolsizeSampler;
    const VkDescriptorPoolCreateInfo poolCreateInfo = {
        .sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        .pNext = nullptr,
        .maxSets = 1,
        .poolSizeCount = 2,
        .pPoolSizes = poolSizes
    };
    CheckResult(vkCreateDescriptorPool(device_, &poolCreateInfo, nullptr, &gfxPipelineInfo_.descPool));
    delete[] poolSizes;

    VkDescriptorSetAllocateInfo alloc_info{.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
                                           .pNext = nullptr,
                                           .descriptorPool = gfxPipelineInfo_.descPool,
                                           .descriptorSetCount = 1,
                                           .pSetLayouts = &gfxPipelineInfo_.dscLayout};
    CheckResult(vkAllocateDescriptorSets(device_, &alloc_info, &gfxPipelineInfo_.descSet));
    gfxPipelineInfo_.descWrites = new VkWriteDescriptorSet[2];
}

void VulkanRender::createOtherStaff()
{
    // Create a pool of command buffers to allocate command buffer from
    VkCommandPoolCreateInfo cmdPoolCreateInfo{
        .sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .pNext = nullptr,
        .flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
        .queueFamilyIndex = 0,
    };
    CheckResult(vkCreateCommandPool(device_, &cmdPoolCreateInfo, nullptr, &renderInfo_.cmdPool));

    // Record a command buffer that just clear the screen
    // 1 command buffer draw in 1 framebuffer
    // In our case we need:2 command as we have 2 framebuffer
    renderInfo_.cmdBufferLen = swapchainInfo_.swapchainLength;
    renderInfo_.cmdBuffer = new VkCommandBuffer[swapchainInfo_.swapchainLength];
    VkCommandBufferAllocateInfo cmdBufferCreateInfo{
        .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .pNext = nullptr,
        .commandPool = renderInfo_.cmdPool,
        .level = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
        .commandBufferCount = renderInfo_.cmdBufferLen
    };
    CheckResult(vkAllocateCommandBuffers(device_, &cmdBufferCreateInfo, renderInfo_.cmdBuffer));
    // We need to create a fence to be able,in the main loop,to wait for our
    // draw conmand(s) to finish before swapping the framebuffers
    VkFenceCreateInfo fenceCreateInfo{
        .sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0
    };
    CheckResult(vkCreateFence(device_, &fenceCreateInfo, nullptr, &renderInfo_.fence));

    // We need to create a semaphore to be able to wait,in the main loop,for our
    // framebuffer to be available for us before drawing.
    VkSemaphoreCreateInfo semaphoreCreateInfo{
        .sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
        .pNext = nullptr,
        .flags = 0
    };
    CheckResult(vkCreateSemaphore(device_, &semaphoreCreateInfo, nullptr, &renderInfo_.semaphore));
}

// [Start buffer_to_texture]
void VulkanRender::NativeBufferToTexture(OH_NativeBuffer *buffer, float transformMatrix[16])
{
    OH_LOG_Print(LOG_APP, LOG_INFO, 0xFF00, "VulkanRenderThread", "NativeBufferToTexture.");
    if (!deviceInfoInitialized_) {
        return;
    }
    UniformBufferObject ubo{};
    const size_t matrixSize = 16; // 16 means 4 x 4
    memcpy(ubo.mvp, transformMatrix, sizeof(float) * matrixSize);
    memcpy(buffersInfo_.uniformBufferMapped, &ubo, sizeof(ubo));
    VkNativeBufferFormatPropertiesOHOS nbFormatProps = {
        .sType = VK_STRUCTURE_TYPE_NATIVE_BUFFER_FORMAT_PROPERTIES_OHOS,
        .pNext = nullptr
    };
    VkNativeBufferPropertiesOHOS nbProps = {.sType = VK_STRUCTURE_TYPE_NATIVE_BUFFER_PROPERTIES_OHOS,
                                            .pNext = &nbFormatProps};
    CheckResult(vkGetNativeBufferPropertiesOHOS(device_, buffer, &nbProps));

    VkImportNativeBufferInfoOHOS importBufferInfo = {
        .sType = VK_STRUCTURE_TYPE_IMPORT_NATIVE_BUFFER_INFO_OHOS,
        .pNext = nullptr,
        .buffer = buffer
    };

    VkMemoryDedicatedAllocateInfo dedicatedAllocateInfo = {
        .sType = VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO,
        .pNext = &importBufferInfo,
        .image = VK_NULL_HANDLE, // wiLl be set later
        .buffer = VK_NULL_HANDLE
    };

    VkPhysicalDeviceMemoryProperties physicalDeviceMemProps;
    uint32_t foundTypeIndex = 0;
    vkGetPhysicalDeviceMemoryProperties(gpuDevice_, &physicalDeviceMemProps);
    uint32_t memTypeCnt = physicalDeviceMemProps.memoryTypeCount;
    for (uint32_t i = 0; i < memTypeCnt; ++i) {
        if (nbProps.memoryTypeBits & (1 << i)) {
            const VkPhysicalDeviceMemoryProperties &pdmp = physicalDeviceMemProps;
            uint32_t supportedFLags = pdmp.memoryTypes[i].propertyFlags & VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT;
            if (supportedFLags == VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT) {
                foundTypeIndex = i;
                break;
            }
        }
    }

    VkMemoryAllocateInfo allocInfo{
        .sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .pNext = &dedicatedAllocateInfo,
        .allocationSize = nbProps.allocationSize,
        .memoryTypeIndex = 0 // Memory type assigned in the next step
    };

    mapMemoryTypeToIndex(nbProps.memoryTypeBits, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, &allocInfo.memoryTypeIndex);
    VkExternalFormatOHOS externalFormat;
    externalFormat.sType = VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_OHOS;
    externalFormat.pNext = nullptr;
    externalFormat.externalFormat = 0;
    if (nbFormatProps.format == VK_FORMAT_UNDEFINED) {
        externalFormat.externalFormat = nbFormatProps.externalFormat;
    }

    VkExternalMemoryImageCreateInfo externalMemoryImageInfo = {
        .sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO,
        .pNext = &externalFormat,
        .handleTypes = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OHOS_NATIVE_BUFFER_BIT_OHOS,
    };

    VkImageUsageFlags usageFlags = VK_IMAGE_USAGE_SAMPLED_BIT;
    if (nbFormatProps.format != VK_FORMAT_UNDEFINED) {
        usageFlags = usageFlags | VK_IMAGE_USAGE_TRANSFER_SRC_BIT | VK_IMAGE_USAGE_TRANSFER_DST_BIT |
                     VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT;
    }
    OH_NativeBuffer_Config config;
    OH_NativeBuffer_GetConfig(buffer, &config);
    VkImageCreateInfo image_create_info = {
        .sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO,
        .pNext = &externalMemoryImageInfo,
        .flags = 0,
        .imageType = VK_IMAGE_TYPE_2D,
        .format = nbFormatProps.format,
        .extent = {static_cast<uint32_t>(config.width), static_cast<uint32_t>(config.height), 1},
        .mipLevels = 1,
        .arrayLayers = 1,
        .samples = VK_SAMPLE_COUNT_1_BIT,
        .tiling = VK_IMAGE_TILING_OPTIMAL,
        .usage = usageFlags,
        .sharingMode = VK_SHARING_MODE_EXCLUSIVE,
        .queueFamilyIndexCount = 1,
        .pQueueFamilyIndices = &queueFamilyIndex_,
        // VK_IMAGE_LAYOUT_UNDEFINED is mandatory when using external memory
        .initialLayout = VK_IMAGE_LAYOUT_UNDEFINED
    };

    if (initialized_) {
        vkDestroyImage(device_, externalTextureImage_, nullptr);
        vkDestroyImageView(device_, externalTextureInfo_.view, nullptr);
        vkFreeMemory(device_, externalTextureMemory_, nullptr);
    }

    CheckResult(vkCreateImage(device_, &image_create_info, nullptr, &externalTextureImage_));
    dedicatedAllocateInfo.image = externalTextureImage_;
    CheckResult(vkAllocateMemory(device_, &allocInfo, nullptr, &externalTextureMemory_));
    CheckResult(vkBindImageMemory(device_, externalTextureImage_, externalTextureMemory_, 0));

    if (!initialized_) {
        VkSamplerYcbcrConversionCreateInfo ycbcrCreateInfo = {
            .sType = VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO,
            .ycbcrRange = nbFormatProps.suggestedYcbcrRange,
            .components = nbFormatProps.samplerYcbcrConversionComponents,
            .xChromaOffset = nbFormatProps.suggestedXChromaOffset,
            .yChromaOffset = nbFormatProps.suggestedYChromaOffset,
            .chromaFilter = VK_FILTER_LINEAR,
            .forceExplicitReconstruction = false
        };

        if (nbFormatProps.format == VK_FORMAT_UNDEFINED) {
            ycbcrCreateInfo.pNext = &externalFormat;
            ycbcrCreateInfo.format = VK_FORMAT_UNDEFINED;
            ycbcrCreateInfo.ycbcrModel = nbFormatProps.suggestedYcbcrModel;
        }

        CheckResult(
            vkCreateSamplerYcbcrConversion(device_, &ycbcrCreateInfo, nullptr, &externalTextureInfo_.ycbcrConversion));

        externalTextureInfo_.convInfoWrap = {
            .sType = VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO,
            .conversion = externalTextureInfo_.ycbcrConversion,
            .pNext = nullptr,
        };

        // Create sampler
        const VkSamplerCreateInfo sampler = {
            .sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO,
            .pNext = &externalTextureInfo_.convInfoWrap,
            .magFilter = VK_FILTER_NEAREST,
            .minFilter = VK_FILTER_NEAREST,
            .mipmapMode = VK_SAMPLER_MIPMAP_MODE_NEAREST,
            .addressModeU = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
            .addressModeV = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
            .addressModeW = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
            .mipLodBias = 0.0f,
            .compareEnable = VK_FALSE,
            .anisotropyEnable = VK_FALSE,
            .maxAnisotropy = 1,
            .compareOp = VK_COMPARE_OP_NEVER,
            .minLod = 0.0f,
            .maxLod = 0.0f,
            .borderColor = VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE,
            .unnormalizedCoordinates = VK_FALSE
        };
        CheckResult(vkCreateSampler(device_, &sampler, nullptr, &externalTextureInfo_.sampler));
    }

    VkImageViewCreateInfo view = {
        .sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
        .pNext = &externalTextureInfo_.convInfoWrap,
        .flags = 0,
        .image = externalTextureImage_,
        .viewType = VK_IMAGE_VIEW_TYPE_2D,
        .format = nbFormatProps.format,
        .components =
            {
                VK_COMPONENT_SWIZZLE_IDENTITY,
                VK_COMPONENT_SWIZZLE_IDENTITY,
                VK_COMPONENT_SWIZZLE_IDENTITY,
                VK_COMPONENT_SWIZZLE_IDENTITY
            },
        .subresourceRange = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1},
    };
    CheckResult(vkCreateImageView(device_, &view, nullptr, &externalTextureInfo_.view));

    createDescriptorSetLayout();
    createDescriptorSet();

    VkDescriptorImageInfo imageInfo = {
        .sampler = externalTextureInfo_.sampler,
        .imageView = externalTextureInfo_.view,
        .imageLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL
    };

    VkDescriptorBufferInfo bufferInfo = {
        .buffer = buffersInfo_.uniformBuf, .offset = 0, .range = sizeof(UniformBufferObject)};
    VkWriteDescriptorSet bufferWrite = {.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
                                        .dstSet = gfxPipelineInfo_.descSet,
                                        .dstBinding = 0,
                                        .dstArrayElement = 0,
                                        .descriptorCount = 1,
                                        .descriptorType = VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                                        .pImageInfo = nullptr,
                                        .pBufferInfo = &bufferInfo,
                                        .pTexelBufferView = nullptr};
    VkWriteDescriptorSet imageWrite = {.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
                                       .dstSet = gfxPipelineInfo_.descSet,
                                       .dstBinding = 1,
                                       .dstArrayElement = 0,
                                       .descriptorCount = 1,
                                       .descriptorType = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
                                       .pImageInfo = &imageInfo,
                                       .pBufferInfo = nullptr,
                                       .pTexelBufferView = nullptr};
    gfxPipelineInfo_.descWrites[0] = bufferWrite;
    gfxPipelineInfo_.descWrites[1] = imageWrite;
    vkUpdateDescriptorSets(device_, 2, gfxPipelineInfo_.descWrites, 0, nullptr); // 2 descWrites
    if (!initialized_) {
        createGraphicsPipeline();
        createOtherStaff();
    }

    recordCommandBuffer();
    initialized_ = true;
    OH_LOG_INFO(LOG_APP, "NativeBufferToTexture end");
}
// [End buffer_to_texture]

void VulkanRender::recordCommandBuffer()
{
    for (int bufferIndex = 0; bufferIndex < swapchainInfo_.swapchainLength; bufferIndex++) {
        // We start by creating and declare the “beginning our command buffer
        VkCommandBufferBeginInfo cmdBufferBeginInfo{
            .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
            .pNext = nullptr,
            .flags = 0,
            .pInheritanceInfo = nullptr,
        };
        CheckResult(vkBeginCommandBuffer(renderInfo_.cmdBuffer[bufferIndex], &cmdBufferBeginInfo));
        setImageLayout(renderInfo_.cmdBuffer[bufferIndex], externalTextureImage_, VK_IMAGE_LAYOUT_UNDEFINED,
                       VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL, VK_PIPELINE_STAGE_HOST_BIT,
                       VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT);
        // Now we start a renderpass. Any draw command has to be recorded in a
        // renderpass
        VkClearValue clearColor = {{{0.0f, 0.0f, 0.0f, 1.0f}}};
        VkRenderPassBeginInfo renderPassBeginInfo{.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
                                                  .pNext = nullptr,
                                                  .renderPass = renderInfo_.renderPass,
                                                  .framebuffer = swapchainInfo_.framebuffers[bufferIndex],
                                                  .renderArea = {.offset =
                                                                     {
                                                                         .x = 0,
                                                                         .y = 0,
                                                                     },
                                                                 .extent = swapchainInfo_.displaySize},
                                                  .clearValueCount = 1,
                                                  .pClearValues = &clearColor};

        vkCmdBeginRenderPass(renderInfo_.cmdBuffer[bufferIndex], &renderPassBeginInfo, VK_SUBPASS_CONTENTS_INLINE);
        // Bind what is necessary to the command buffer
        vkCmdBindPipeline(renderInfo_.cmdBuffer[bufferIndex], VK_PIPELINE_BIND_POINT_GRAPHICS, gfxPipelineInfo_.pipeline);
        // As we support dynamic state for viewport and scissor - we must set them here
        auto viewport = VkViewport{
            .x = .0f,
            .y = .1f,
            .width = (float)swapchainInfo_.displaySize.width,
            .height = (float)swapchainInfo_.displaySize.height,
            .minDepth = .0f,
            .maxDepth = .1f
        };
        vkCmdSetViewport(renderInfo_.cmdBuffer[bufferIndex], 0, 1, &viewport);
        auto scissor = VkRect2D{
            .offset = {0, 0},
            .extent = swapchainInfo_.displaySize,
        };
        vkCmdSetScissor(renderInfo_.cmdBuffer[bufferIndex], 0, 1, &scissor);
        vkCmdBindDescriptorSets(renderInfo_.cmdBuffer[bufferIndex], VK_PIPELINE_BIND_POINT_GRAPHICS,
                                gfxPipelineInfo_.layout, 0, 1, &gfxPipelineInfo_.descSet, 0, nullptr);
        VkDeviceSize offset = 0;
        vkCmdBindVertexBuffers(renderInfo_.cmdBuffer[bufferIndex], 0, 1, &buffersInfo_.vertexBuf, &offset);

        vkCmdDraw(renderInfo_.cmdBuffer[bufferIndex], 4, 1, 0, 0); // 4 indexes
        vkCmdEndRenderPass(renderInfo_.cmdBuffer[bufferIndex]);
        CheckResult(vkEndCommandBuffer(renderInfo_.cmdBuffer[bufferIndex]));
    }
}

void VulkanRender::setImageLayout(VkCommandBuffer cmdBuffer, VkImage image, VkImageLayout oldImageLayout,
                                  VkImageLayout newImageLayout, VkPipelineStageFlags srcStages,
                                  VkPipelineStageFlags destStages)
{
    VkImageMemoryBarrier imageMemoryBarrier = {
        .sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .pNext = nullptr,
        .srcAccessMask = 0,
        .dstAccessMask = 0,
        .oldLayout = oldImageLayout,
        .newLayout = newImageLayout,
        .srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
        .dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED,
        .image = image,
        .subresourceRange =
            {
                .aspectMask = VK_IMAGE_ASPECT_COLOR_BIT,
                .baseMipLevel = 0,
                .levelCount = 1,
                .baseArrayLayer = 0,
                .layerCount = 1
            }
    };

    switch (oldImageLayout) {
        case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL:
            imageMemoryBarrier.srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
            break;

        case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL:
            imageMemoryBarrier.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
            break;

        case VK_IMAGE_LAYOUT_PREINITIALIZED:
            imageMemoryBarrier.srcAccessMask = VK_ACCESS_HOST_WRITE_BIT;
            break;

        default:
            break;
    }

    switch (newImageLayout) {
        case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL:
            imageMemoryBarrier.dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
            break;

        case VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL:
            imageMemoryBarrier.dstAccessMask = VK_ACCESS_TRANSFER_READ_BIT;
            break;

        case VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL:
            imageMemoryBarrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT;
            break;

        case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL:
            imageMemoryBarrier.dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
            break;

        case VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL:
            imageMemoryBarrier.dstAccessMask = VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
            break;

        default:
            break;
    }
    vkCmdPipelineBarrier(cmdBuffer, srcStages, destStages, 0, 0, nullptr, 0, nullptr, 1, &imageMemoryBarrier);
}

void VulkanRender::render()
{
    OH_LOG_INFO(LOG_APP, "renderImpl begin");
    uint32_t nextIndex;
    // Get the framebuffer index we should draw in
    auto result = vkAcquireNextImageKHR(device_, swapchainInfo_.swapchain, UINT64_MAX, renderInfo_.semaphore,
                                        VK_NULL_HANDLE, &nextIndex);
    if (result == VK_ERROR_OUT_OF_DATE_KHR || result == VK_SUBOPTIMAL_KHR) {
        cleanupSwapChain();
        createSwapChain();
        createFrameBuffersAndImages();
        return;
    }
    CheckResult(vkResetFences(device_, 1, &renderInfo_.fence));
    VkPipelineStageFlags waitStageMask = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
    VkSubmitInfo Submit_info = {.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO,
                                .pNext = nullptr,
                                .waitSemaphoreCount = 1,
                                .pWaitSemaphores = &renderInfo_.semaphore,
                                .pWaitDstStageMask = &waitStageMask,
                                .commandBufferCount = 1,
                                .pCommandBuffers = &renderInfo_.cmdBuffer[nextIndex],
                                .signalSemaphoreCount = 0,
                                .pSignalSemaphores = nullptr};
    CheckResult(vkQueueSubmit(graphicsQueue_, 1, &Submit_info, renderInfo_.fence));
    CheckResult(vkWaitForFences(device_, 1, &renderInfo_.fence, VK_TRUE, 100000000)); // wait 100000000 nanoseconds

    VkPresentInfoKHR presentInfo{
        .sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,
        .pNext = nullptr,
        .waitSemaphoreCount = 0,
        .pWaitSemaphores = nullptr,
        .swapchainCount = 1,
        .pSwapchains = &swapchainInfo_.swapchain,
        .pImageIndices = &nextIndex,
        .pResults = nullptr
    };
    vkQueuePresentKHR(graphicsQueue_, &presentInfo);
    OH_LOG_INFO(LOG_APP, "renderImpl end");
}

void VulkanRender::cleanupSwapChain() const
{
    for (int i = 0; i < swapchainInfo_.swapchainLength; ++i) {
        vkDestroyFramebuffer(device_, swapchainInfo_.framebuffers[i], nullptr);
        vkDestroyImageView(device_, swapchainInfo_.displayViews[i], nullptr);
    }
    vkDestroySwapchainKHR(device_, swapchainInfo_.swapchain, nullptr);
}

void VulkanRender::mapMemoryTypeToIndex(uint32_t typeBits, VkFlags requirements_mask, uint32_t *typeIndex) const
{
    VkPhysicalDeviceMemoryProperties memoryProperties;
    vkGetPhysicalDeviceMemoryProperties(gpuDevice_, &memoryProperties);
    // Search memtypes to find first index with those properties
    // 32 bits
    for (uint32_t i = 0; i < 32; i++) {
        if ((typeBits & 1) == 1) {
            // Type is available, does it match user properties?
            if ((memoryProperties.memoryTypes[i].propertyFlags & requirements_mask) == requirements_mask) {
                *typeIndex = i;
                return;
            }
        }
        typeBits >>= 1;
    }
}
} // namespace NativeXComponentSample
