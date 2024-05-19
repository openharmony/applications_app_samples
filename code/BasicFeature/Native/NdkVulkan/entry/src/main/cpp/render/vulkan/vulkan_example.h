/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

#ifndef VULKAN_EXAMPLE_H
#define VULKAN_EXAMPLE_H
#include "vulkan/vulkan.h"
#include "logger_common.h"
#include "vulkan_utils.h"
#include <native_window/external_window.h>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <algorithm>
#include <vector>
#include <cstring>
#include <cstdlib>
#include <cstdint>
#include <limits>
#include <optional>
#include <set>
namespace vkExample {
struct QueueFamilyIndices {
    int graphicsFamily = -1;
    int presentFamily = -1;

    bool IsComplete()
    {
        return graphicsFamily >= 0 && presentFamily >= 0;
    }
};

struct SwapChainSupportDetails {
    VkSurfaceCapabilitiesKHR capabilities;
    std::vector<VkSurfaceFormatKHR> formats;
    std::vector<VkPresentModeKHR> presentModes;
};

class VulkanExample {
public:
    VulkanExample();
    ~VulkanExample();
    bool InitVulkan();
    void SetupWindow(NativeWindow* nativeWindow);
    void SetUp();
    void RenderLoop();
    bool IsInited() const;
    void SetRecreateSwapChain();
private:
    bool CreateInstance();
    bool CreateSurface();
    bool CreateLogicalDevice();
    void CreateSwapChain();
    void CreateImageViews();
    void CreateRenderPass();
    void CreateDescriptorSetLayout();
    void CreateGraphicsPipeline();
    void CreateFramebuffers();
    void CreateCommandPool();
    uint32_t GetMemoryTypeIndex(uint32_t typeFilter, VkMemoryPropertyFlags properties);
    void CreateBuffer(VkDeviceSize size, VkBufferUsageFlags usage, VkMemoryPropertyFlags properties,
        VkBuffer &buffer, VkDeviceMemory &bufferMemory);
    void CreateVertices();
    void UpdateVertices();
    void CreateUniformBuffers();
    void CreateDescriptorPool();
    void CreateDescriptorSets();
    void CreateCommandBuffer();
    void RecordCommandBuffer(VkCommandBuffer commandBuffer, uint32_t imageIndex);
    void CreateSyncObjects();
    void UpdateUniformBuffers();
    void CleanupSwapChain();
    void RecreateSwapChain();
    void DrawFrame();
    bool PickPhysicalDevice();
    VkShaderModule CreateShaderModule(const std::vector<char> &code);
    VkSurfaceFormatKHR ChooseSwapSurfaceFormat(const std::vector<VkSurfaceFormatKHR> &availableFormats);
    VkPresentModeKHR ChooseSwapPresentMode(const std::vector<VkPresentModeKHR> &availablePresentModes);
    VkExtent2D ChooseSwapExtent(const VkSurfaceCapabilitiesKHR &capabilities);
    SwapChainSupportDetails QuerySwapChainSupport(VkPhysicalDevice device);
    bool IsDeviceSuitable(VkPhysicalDevice device);
    bool CheckDeviceExtensionSupport(VkPhysicalDevice device);
    QueueFamilyIndices FindQueueFamilies(VkPhysicalDevice device);
    std::vector<const char *> GetRequiredExtensions();
    VkShaderModule LoadSPIRVShader(std::string filename);
    VkCommandBuffer GetCommandBuffer();
    void FlushCommandBuffer(VkCommandBuffer commandBuffer);
    VkPipelineVertexInputStateCreateInfo PrepareVertexInputState(
        VkVertexInputBindingDescription& vertexInputBinding,
        // 2 attributes for position(location = 0) and color (location = 1)
        std::array<VkVertexInputAttributeDescription, 2>& vertexInputAttributes);
    VkPipelineColorBlendStateCreateInfo PrepareColorBlendState(
        VkPipelineColorBlendAttachmentState& blendAttachmentState);
    VkPipelineInputAssemblyStateCreateInfo PrepareInputAssemblyState();
    VkPipelineRasterizationStateCreateInfo PrepareRasterizationState();
    VkPipelineMultisampleStateCreateInfo PrepareMultisampleState();
    VkPipelineViewportStateCreateInfo PrepareViewportState();
    void PreparePipelineLayout();
    VkPipelineDynamicStateCreateInfo PrepareDynamicState(std::vector<VkDynamicState>& dynamicStates);

    struct Vertex {
        float position[3];
        float color[3];
    };

    struct VulkanBuffer {
        VkDeviceMemory memory;
        VkBuffer buffer;
    };

    // mvp matrix
    struct {
        float mat[4][4] = {{0.974279, 0.000000, 0.000000, 0.000000},
                           {0.000000, 1.732051, 0.000000, 0.000000},
                           {0.000000, 0.000000, -1.003922, -1.000000},
                           {0.000000, 0.000000, 1.505882, 2.500000}};
    } uboVS;
    float alpha = 0.0f;
    std::vector<Vertex> vertices = {{{std::sin(alpha), 1.0f, -std::cos(alpha)}, {1.0f, 0.0f, 0.0f}},
                                    {{-std::sin(alpha), 1.0f, std::cos(alpha)}, {0.0f, 1.0f, 0.0f}},
                                    {{0.0f, -1.0f, 0.0f}, {0.0f, 0.0f, 1.0f}}};
    std::vector<uint32_t> indices = {0, 1, 2};
    VkDeviceSize vertexBufferSize = vertices.size() * sizeof(Vertex);
    VkDeviceSize indexBufferSize = indices.size() * sizeof(uint32_t);
    uint32_t width = 1280;
    uint32_t height = 720;
    bool inited = false;
    bool shouldRecreate = false;
    const std::vector<const char *> deviceExtensions = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};
    std::vector<std::string> supportedInstanceExtensions;
    std::vector<const char *> enabledInstanceExtensions;

    NativeWindow *window = nullptr;

    VkInstance instance;
    VkDebugUtilsMessengerEXT debugMessenger;
    VkSurfaceKHR surface;

    VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
    VkDevice device;

    VkQueue graphicsQueue;
    VkQueue presentQueue;

    VkSwapchainKHR swapChain;
    std::vector<VkImage> swapChainImages;
    VkFormat swapChainImageFormat;
    VkExtent2D swapChainExtent;
    std::vector<VkImageView> swapChainImageViews;
    std::vector<VkFramebuffer> swapChainFramebuffers;

    VkRenderPass renderPass;
    VkPipelineLayout pipelineLayout;
    VkPipeline graphicsPipeline;

    VkCommandPool commandPool;
    VkCommandBuffer commandBuffer;

    VkSemaphore imageAvailableSemaphore;
    VkSemaphore renderFinishedSemaphore;
    VkFence inFlightFence;

    VulkanBuffer vertexBuffer;
    VulkanBuffer indexBuffer;
    VulkanBuffer uniformBuffer;
    VulkanBuffer vertexStagingBuffer;
    VulkanBuffer indexStagingBuffer;

    VkDescriptorSetLayout descriptorSetLayout;
    VkDescriptorPool descriptorPool;
    VkDescriptorSet descriptorSet;
    };
} // namespace vkExample
#endif //VULKAN_EXAMPLE_H