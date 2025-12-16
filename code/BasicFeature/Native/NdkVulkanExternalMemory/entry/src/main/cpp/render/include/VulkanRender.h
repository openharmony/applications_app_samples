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

#ifndef VIDEO_RENDER_VULKANRENDERER_H
#define VIDEO_RENDER_VULKANRENDERER_H

#include <vector>
#include <string>
#include <vulkan/vulkan_core.h>
#include <native_window/external_window.h>

namespace NativeXComponentSample {
struct QueueFamilyIndices {
    int graphicsFamily = -1;
    int presentFamily = -1;
    bool IsComplete() { return graphicsFamily >= 0 && presentFamily >= 0; }
};

struct SwapChainSupportDetails {
    VkSurfaceCapabilitiesKHR capabilities;
    std::vector<VkSurfaceFormatKHR> formats;
    std::vector<VkPresentModeKHR> presentModes;
};

class VulkanRender {
public:
    VulkanRender();
    ~VulkanRender();
    void SetupWindow(NativeWindow *nativeWindow);
    void NativeBufferToTexture(OH_NativeBuffer *buffer, float transformMatrix[16]);
    void render();

private:
    NativeWindow *nativeWindow_ = nullptr;
    struct UniformBufferObject {
        float mvp[16];
    };

    VkInstance instance_;
    VkSurfaceKHR surface_;
    VkDevice device_;
    VkPhysicalDevice gpuDevice_;
    VkQueue graphicsQueue_;
    VkQueue presentQueue_;
    VkPhysicalDeviceMemoryProperties gpuMemoryProperties_;
    uint32_t queueFamilyIndex_;
    bool deviceInfoInitialized_;
    QueueFamilyIndices indices_;

    struct VulkanSwapChainInfo {
        VkSwapchainKHR swapchain;
        uint32_t swapchainLength;

        VkExtent2D displaySize;
        VkFormat displayFormat;

        // array of frane buffers and views
        VkFramebuffer *framebuffers;
        VkImage *displayImages;
        VkImageView *displayViews;
    };
    VulkanSwapChainInfo swapchainInfo_;

    struct VulkanExternalTextureInfo {
        VkSamplerYcbcrConversion ycbcrConversion;
        VkSampler sampler;
        VkImageView view;
        VkSamplerYcbcrConversionInfo convInfoWrap;
    };
    VulkanExternalTextureInfo externalTextureInfo_;
    VkImage externalTextureImage_;
    VkDeviceMemory externalTextureMemory_;
    bool initialized_ = false;

    struct VulkanBuffersInfo {
        VkBuffer vertexBuf;
        VkBuffer uniformBuf;
        VkDeviceMemory uniformBufferMemory;
        VkDeviceMemory vertexBufferMemory;
        void *uniformBufferMapped;
    };
    VulkanBuffersInfo buffersInfo_;

    struct VulkanGfxPipelineInfo {
        VkDescriptorSetLayout dscLayout;
        VkDescriptorPool descPool;
        VkDescriptorSet descSet;
        VkPipelineLayout layout;
        VkPipelineCache cache;
        VkPipeline pipeline;
        VkWriteDescriptorSet *descWrites;
    };
    VulkanGfxPipelineInfo gfxPipelineInfo_;

    struct VulkanRenderInfo {
        VkRenderPass renderPass;
        VkCommandPool cmdPool;
        VkCommandBuffer *cmdBuffer;
        uint32_t cmdBufferLen;
        VkSemaphore semaphore;
        VkFence fence;
    };
    VulkanRenderInfo renderInfo_;

    std::vector<std::string> supportedInstanceExtensions_;
    std::vector<const char *> enabledInstanceExtensions_;
    const std::vector<const char *> deviceExtensions_ = {VK_KHR_SWAPCHAIN_EXTENSION_NAME};

    bool CreateInstance();
    std::vector<const char *> GetRequiredExtensions();
    bool CreateSurface();
    bool PickPhysicalDevice();
    bool CreateLogicalDevice();
    void createSwapChain(uint32_t width = 0, uint32_t height = 0);
    void createRenderPass();
    void createFrameBuffersAndImages();
    void createVertexBuffer();
    void createDescriptorSetLayout();
    void createGraphicsPipeline();
    void createDescriptorSet();
    void createUniformBuffer();
    void createOtherStaff();
    void recordCommandBuffer();

    void cleanupSwapChain() const;

    void mapMemoryTypeToIndex(uint32_t typeBits, VkFlags requirements_mask, uint32_t *typeIndex) const;
    void createBuffer(VkDeviceSize size, VkBufferUsageFlags usage, VkMemoryPropertyFlags properties, VkBuffer &buffer,
                      VkDeviceMemory &bufferMemory);
    static void setImageLayout(VkCommandBuffer cndBuffer, VkImage image, VkImageLayout oldImageLayout,
                               VkImageLayout newImageLayout, VkPipelineStageFlags srcStages,
                               VkPipelineStageFlags destStages);
    VkShaderModule LoadSPIRVShader(std::string filename);

    QueueFamilyIndices FindQueueFamilies(VkPhysicalDevice device);
    bool IsDeviceSuitable(VkPhysicalDevice device);
    bool CheckDeviceExtensionSupport(VkPhysicalDevice device);
    SwapChainSupportDetails QuerySwapChainSupport(VkPhysicalDevice device);
};
} // namespace NativeXComponentSample
#endif //VIDEO_RENDER_VULKANRENDERER_H
