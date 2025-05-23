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
#include "vulkan_utils.h"
#include "logger_common.h"
#include <iostream>
#include <dlfcn.h>

PFN_vkCreateInstance vkCreateInstance;
PFN_vkGetDeviceProcAddr vkGetDeviceProcAddr;
PFN_vkGetInstanceProcAddr vkGetInstanceProcAddr;
PFN_vkCreateDevice vkCreateDevice;
PFN_vkEnumeratePhysicalDevices vkEnumeratePhysicalDevices;
PFN_vkGetPhysicalDeviceProperties vkGetPhysicalDeviceProperties;
PFN_vkGetPhysicalDeviceProperties2 vkGetPhysicalDeviceProperties2;
PFN_vkEnumerateDeviceExtensionProperties vkEnumerateDeviceExtensionProperties;
PFN_vkEnumerateDeviceLayerProperties vkEnumerateDeviceLayerProperties;
PFN_vkGetPhysicalDeviceFormatProperties vkGetPhysicalDeviceFormatProperties;
PFN_vkGetPhysicalDeviceFeatures vkGetPhysicalDeviceFeatures;
PFN_vkGetPhysicalDeviceFeatures2 vkGetPhysicalDeviceFeatures2;
PFN_vkGetPhysicalDeviceQueueFamilyProperties vkGetPhysicalDeviceQueueFamilyProperties;
PFN_vkGetPhysicalDeviceMemoryProperties vkGetPhysicalDeviceMemoryProperties;
PFN_vkEnumerateInstanceExtensionProperties vkEnumerateInstanceExtensionProperties;
PFN_vkEnumerateInstanceLayerProperties vkEnumerateInstanceLayerProperties;
PFN_vkCmdPipelineBarrier vkCmdPipelineBarrier;
PFN_vkCreateShaderModule vkCreateShaderModule;
PFN_vkCreateBuffer vkCreateBuffer;
PFN_vkGetBufferMemoryRequirements vkGetBufferMemoryRequirements;
PFN_vkMapMemory vkMapMemory;
PFN_vkUnmapMemory vkUnmapMemory;
PFN_vkFlushMappedMemoryRanges vkFlushMappedMemoryRanges;
PFN_vkInvalidateMappedMemoryRanges vkInvalidateMappedMemoryRanges;
PFN_vkBindBufferMemory vkBindBufferMemory;
PFN_vkDestroyBuffer vkDestroyBuffer;
PFN_vkAllocateMemory vkAllocateMemory;
PFN_vkBindImageMemory vkBindImageMemory;
PFN_vkGetImageSubresourceLayout vkGetImageSubresourceLayout;
PFN_vkCmdCopyBuffer vkCmdCopyBuffer;
PFN_vkCmdCopyBufferToImage vkCmdCopyBufferToImage;
PFN_vkCmdCopyImage vkCmdCopyImage;
PFN_vkCmdBlitImage vkCmdBlitImage;
PFN_vkCmdClearAttachments vkCmdClearAttachments;
PFN_vkCreateSampler vkCreateSampler;
PFN_vkDestroySampler vkDestroySampler;
PFN_vkDestroyImage vkDestroyImage;
PFN_vkFreeMemory vkFreeMemory;
PFN_vkCreateRenderPass vkCreateRenderPass;
PFN_vkCmdBeginRenderPass vkCmdBeginRenderPass;
PFN_vkCmdEndRenderPass vkCmdEndRenderPass;
PFN_vkCmdNextSubpass vkCmdNextSubpass;
PFN_vkCmdExecuteCommands vkCmdExecuteCommands;
PFN_vkCmdClearColorImage vkCmdClearColorImage;
PFN_vkCreateImage vkCreateImage;
PFN_vkGetImageMemoryRequirements vkGetImageMemoryRequirements;
PFN_vkCreateImageView vkCreateImageView;
PFN_vkDestroyImageView vkDestroyImageView;
PFN_vkCreateSemaphore vkCreateSemaphore;
PFN_vkDestroySemaphore vkDestroySemaphore;
PFN_vkCreateFence vkCreateFence;
PFN_vkDestroyFence vkDestroyFence;
PFN_vkWaitForFences vkWaitForFences;
PFN_vkResetFences vkResetFences;
PFN_vkResetDescriptorPool vkResetDescriptorPool;
PFN_vkCreateCommandPool vkCreateCommandPool;
PFN_vkDestroyCommandPool vkDestroyCommandPool;
PFN_vkAllocateCommandBuffers vkAllocateCommandBuffers;
PFN_vkBeginCommandBuffer vkBeginCommandBuffer;
PFN_vkResetCommandBuffer vkResetCommandBuffer;
PFN_vkEndCommandBuffer vkEndCommandBuffer;
PFN_vkGetDeviceQueue vkGetDeviceQueue;
PFN_vkQueueSubmit vkQueueSubmit;
PFN_vkQueueWaitIdle vkQueueWaitIdle;
PFN_vkDeviceWaitIdle vkDeviceWaitIdle;
PFN_vkCreateFramebuffer vkCreateFramebuffer;
PFN_vkCreatePipelineCache vkCreatePipelineCache;
PFN_vkCreatePipelineLayout vkCreatePipelineLayout;
PFN_vkCreateGraphicsPipelines vkCreateGraphicsPipelines;
PFN_vkCreateComputePipelines vkCreateComputePipelines;
PFN_vkCreateDescriptorPool vkCreateDescriptorPool;
PFN_vkCreateDescriptorSetLayout vkCreateDescriptorSetLayout;
PFN_vkAllocateDescriptorSets vkAllocateDescriptorSets;
PFN_vkUpdateDescriptorSets vkUpdateDescriptorSets;
PFN_vkCmdBindDescriptorSets vkCmdBindDescriptorSets;
PFN_vkCmdBindPipeline vkCmdBindPipeline;
PFN_vkCmdBindVertexBuffers vkCmdBindVertexBuffers;
PFN_vkCmdBindIndexBuffer vkCmdBindIndexBuffer;
PFN_vkCmdSetViewport vkCmdSetViewport;
PFN_vkCmdSetScissor vkCmdSetScissor;
PFN_vkCmdSetLineWidth vkCmdSetLineWidth;
PFN_vkCmdSetDepthBias vkCmdSetDepthBias;
PFN_vkCmdPushConstants vkCmdPushConstants;
PFN_vkCmdDrawIndexed vkCmdDrawIndexed;
PFN_vkCmdDraw vkCmdDraw;
PFN_vkCmdDrawIndexedIndirect vkCmdDrawIndexedIndirect;
PFN_vkCmdDrawIndirect vkCmdDrawIndirect;
PFN_vkCmdDispatch vkCmdDispatch;
PFN_vkDestroyPipeline vkDestroyPipeline;
PFN_vkDestroyPipelineLayout vkDestroyPipelineLayout;
PFN_vkDestroyDescriptorSetLayout vkDestroyDescriptorSetLayout;
PFN_vkDestroyDevice vkDestroyDevice;
PFN_vkDestroyInstance vkDestroyInstance;
PFN_vkDestroyDescriptorPool vkDestroyDescriptorPool;
PFN_vkFreeCommandBuffers vkFreeCommandBuffers;
PFN_vkDestroyRenderPass vkDestroyRenderPass;
PFN_vkDestroyFramebuffer vkDestroyFramebuffer;
PFN_vkDestroyShaderModule vkDestroyShaderModule;
PFN_vkDestroyPipelineCache vkDestroyPipelineCache;
PFN_vkCreateQueryPool vkCreateQueryPool;
PFN_vkDestroyQueryPool vkDestroyQueryPool;
PFN_vkGetQueryPoolResults vkGetQueryPoolResults;
PFN_vkCmdBeginQuery vkCmdBeginQuery;
PFN_vkCmdEndQuery vkCmdEndQuery;
PFN_vkCmdResetQueryPool vkCmdResetQueryPool;
PFN_vkCmdCopyQueryPoolResults vkCmdCopyQueryPoolResults;

PFN_vkCreateSurfaceOHOS vkCreateSurfaceOHOS;
PFN_vkDestroySurfaceKHR vkDestroySurfaceKHR;
PFN_vkCmdFillBuffer vkCmdFillBuffer;
PFN_vkGetPhysicalDeviceSurfaceSupportKHR vkGetPhysicalDeviceSurfaceSupportKHR;
PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR vkGetPhysicalDeviceSurfaceCapabilitiesKHR;
PFN_vkGetPhysicalDeviceSurfaceFormatsKHR vkGetPhysicalDeviceSurfaceFormatsKHR;
PFN_vkGetPhysicalDeviceSurfacePresentModesKHR vkGetPhysicalDeviceSurfacePresentModesKHR;

PFN_vkCreateSwapchainKHR vkCreateSwapchainKHR;
PFN_vkDestroySwapchainKHR vkDestroySwapchainKHR;
PFN_vkGetSwapchainImagesKHR vkGetSwapchainImagesKHR;
PFN_vkAcquireNextImageKHR vkAcquireNextImageKHR;
PFN_vkQueuePresentKHR vkQueuePresentKHR;
PFN_vkGetMemoryNativeBufferOHOS vkGetMemoryNativeBufferOHOS;
PFN_vkGetNativeBufferPropertiesOHOS vkGetNativeBufferPropertiesOHOS;

void *g_libVulkan;

namespace vkExample {
namespace utils {
    // Dynamically load Vulkan library and base function pointers
    bool LoadVulkanLibrary()
    {
        // Load vulkan library
        constexpr char* path = "libvulkan.so";
        dlerror();
        g_libVulkan = dlopen(path, RTLD_NOW | RTLD_LOCAL);
        if (!g_libVulkan) {
            LOGI("Failed to load vulkan library, %{public}s", dlerror());
            return false;
        }

        // // Load base function pointers
        vkEnumerateInstanceExtensionProperties = reinterpret_cast<PFN_vkEnumerateInstanceExtensionProperties>(
            dlsym(g_libVulkan, "vkEnumerateInstanceExtensionProperties"));
        vkEnumerateInstanceLayerProperties = reinterpret_cast<PFN_vkEnumerateInstanceLayerProperties>(
            dlsym(g_libVulkan, "vkEnumerateInstanceLayerProperties"));
        vkCreateInstance = reinterpret_cast<PFN_vkCreateInstance>(dlsym(g_libVulkan, "vkCreateInstance"));
        vkGetInstanceProcAddr =
            reinterpret_cast<PFN_vkGetInstanceProcAddr>(dlsym(g_libVulkan, "vkGetInstanceProcAddr"));
        vkGetDeviceProcAddr = reinterpret_cast<PFN_vkGetDeviceProcAddr>(dlsym(g_libVulkan, "vkGetDeviceProcAddr"));

        return true;
    }

    void FreeVulkanLibrary()
    {
        dlclose(g_libVulkan);
    }
    // Load instance based Vulkan function pointers
    void LoadVulkanFunctions(VkInstance instance)
    {
        vkEnumeratePhysicalDevices = reinterpret_cast<PFN_vkEnumeratePhysicalDevices>(
            vkGetInstanceProcAddr(instance, "vkEnumeratePhysicalDevices"));
        vkGetPhysicalDeviceProperties = reinterpret_cast<PFN_vkGetPhysicalDeviceProperties>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties"));
        vkGetPhysicalDeviceProperties2 = reinterpret_cast<PFN_vkGetPhysicalDeviceProperties2>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceProperties2"));
        vkEnumerateDeviceLayerProperties = reinterpret_cast<PFN_vkEnumerateDeviceLayerProperties>(
            vkGetInstanceProcAddr(instance, "vkEnumerateDeviceLayerProperties"));
        vkEnumerateDeviceExtensionProperties = reinterpret_cast<PFN_vkEnumerateDeviceExtensionProperties>(
            vkGetInstanceProcAddr(instance, "vkEnumerateDeviceExtensionProperties"));
        vkGetPhysicalDeviceQueueFamilyProperties = reinterpret_cast<PFN_vkGetPhysicalDeviceQueueFamilyProperties>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceQueueFamilyProperties"));
        vkGetPhysicalDeviceFeatures = reinterpret_cast<PFN_vkGetPhysicalDeviceFeatures>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFeatures"));
        vkGetPhysicalDeviceFeatures2 = reinterpret_cast<PFN_vkGetPhysicalDeviceFeatures2>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFeatures2"));
        vkCreateDevice = reinterpret_cast<PFN_vkCreateDevice>(vkGetInstanceProcAddr(instance, "vkCreateDevice"));
        vkGetPhysicalDeviceFormatProperties = reinterpret_cast<PFN_vkGetPhysicalDeviceFormatProperties>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceFormatProperties"));
        vkGetPhysicalDeviceMemoryProperties = reinterpret_cast<PFN_vkGetPhysicalDeviceMemoryProperties>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceMemoryProperties"));

        vkCmdPipelineBarrier =
            reinterpret_cast<PFN_vkCmdPipelineBarrier>(vkGetInstanceProcAddr(instance, "vkCmdPipelineBarrier"));
        vkCreateShaderModule =
            reinterpret_cast<PFN_vkCreateShaderModule>(vkGetInstanceProcAddr(instance, "vkCreateShaderModule"));

        vkCreateBuffer = reinterpret_cast<PFN_vkCreateBuffer>(vkGetInstanceProcAddr(instance, "vkCreateBuffer"));
        vkGetBufferMemoryRequirements = reinterpret_cast<PFN_vkGetBufferMemoryRequirements>(
            vkGetInstanceProcAddr(instance, "vkGetBufferMemoryRequirements"));
        vkMapMemory = reinterpret_cast<PFN_vkMapMemory>(vkGetInstanceProcAddr(instance, "vkMapMemory"));
        vkUnmapMemory = reinterpret_cast<PFN_vkUnmapMemory>(vkGetInstanceProcAddr(instance, "vkUnmapMemory"));
        vkFlushMappedMemoryRanges = reinterpret_cast<PFN_vkFlushMappedMemoryRanges>(
            vkGetInstanceProcAddr(instance, "vkFlushMappedMemoryRanges"));
        vkInvalidateMappedMemoryRanges = reinterpret_cast<PFN_vkInvalidateMappedMemoryRanges>(
            vkGetInstanceProcAddr(instance, "vkInvalidateMappedMemoryRanges"));
        vkBindBufferMemory =
            reinterpret_cast<PFN_vkBindBufferMemory>(vkGetInstanceProcAddr(instance, "vkBindBufferMemory"));
        vkDestroyBuffer = reinterpret_cast<PFN_vkDestroyBuffer>(vkGetInstanceProcAddr(instance, "vkDestroyBuffer"));

        vkAllocateMemory =
            reinterpret_cast<PFN_vkAllocateMemory>(vkGetInstanceProcAddr(instance, "vkAllocateMemory"));
        vkFreeMemory = reinterpret_cast<PFN_vkFreeMemory>(vkGetInstanceProcAddr(instance, "vkFreeMemory"));
        vkCreateRenderPass =
            reinterpret_cast<PFN_vkCreateRenderPass>(vkGetInstanceProcAddr(instance, "vkCreateRenderPass"));
        vkCmdBeginRenderPass =
            reinterpret_cast<PFN_vkCmdBeginRenderPass>(vkGetInstanceProcAddr(instance, "vkCmdBeginRenderPass"));
        vkCmdEndRenderPass =
            reinterpret_cast<PFN_vkCmdEndRenderPass>(vkGetInstanceProcAddr(instance, "vkCmdEndRenderPass"));
        vkCmdNextSubpass =
            reinterpret_cast<PFN_vkCmdNextSubpass>(vkGetInstanceProcAddr(instance, "vkCmdNextSubpass"));
        vkCmdExecuteCommands =
            reinterpret_cast<PFN_vkCmdExecuteCommands>(vkGetInstanceProcAddr(instance, "vkCmdExecuteCommands"));
        vkCmdClearColorImage =
            reinterpret_cast<PFN_vkCmdClearColorImage>(vkGetInstanceProcAddr(instance, "vkCmdClearColorImage"));

        vkCreateImage = reinterpret_cast<PFN_vkCreateImage>(vkGetInstanceProcAddr(instance, "vkCreateImage"));
        vkGetImageMemoryRequirements = reinterpret_cast<PFN_vkGetImageMemoryRequirements>(
            vkGetInstanceProcAddr(instance, "vkGetImageMemoryRequirements"));
        vkCreateImageView =
            reinterpret_cast<PFN_vkCreateImageView>(vkGetInstanceProcAddr(instance, "vkCreateImageView"));
        vkDestroyImageView =
            reinterpret_cast<PFN_vkDestroyImageView>(vkGetInstanceProcAddr(instance, "vkDestroyImageView"));
        vkBindImageMemory =
            reinterpret_cast<PFN_vkBindImageMemory>(vkGetInstanceProcAddr(instance, "vkBindImageMemory"));
        vkGetImageSubresourceLayout = reinterpret_cast<PFN_vkGetImageSubresourceLayout>(
            vkGetInstanceProcAddr(instance, "vkGetImageSubresourceLayout"));
        vkCmdCopyImage = reinterpret_cast<PFN_vkCmdCopyImage>(vkGetInstanceProcAddr(instance, "vkCmdCopyImage"));
        vkCmdBlitImage = reinterpret_cast<PFN_vkCmdBlitImage>(vkGetInstanceProcAddr(instance, "vkCmdBlitImage"));
        vkDestroyImage = reinterpret_cast<PFN_vkDestroyImage>(vkGetInstanceProcAddr(instance, "vkDestroyImage"));

        vkCmdClearAttachments =
            reinterpret_cast<PFN_vkCmdClearAttachments>(vkGetInstanceProcAddr(instance, "vkCmdClearAttachments"));

        vkCmdCopyBuffer = reinterpret_cast<PFN_vkCmdCopyBuffer>(vkGetInstanceProcAddr(instance, "vkCmdCopyBuffer"));
        vkCmdCopyBufferToImage =
            reinterpret_cast<PFN_vkCmdCopyBufferToImage>(vkGetInstanceProcAddr(instance, "vkCmdCopyBufferToImage"));

        vkCreateSampler = reinterpret_cast<PFN_vkCreateSampler>(vkGetInstanceProcAddr(instance, "vkCreateSampler"));
        vkDestroySampler =
            reinterpret_cast<PFN_vkDestroySampler>(vkGetInstanceProcAddr(instance, "vkDestroySampler"));
        ;

        vkCreateSemaphore =
            reinterpret_cast<PFN_vkCreateSemaphore>(vkGetInstanceProcAddr(instance, "vkCreateSemaphore"));
        vkDestroySemaphore =
            reinterpret_cast<PFN_vkDestroySemaphore>(vkGetInstanceProcAddr(instance, "vkDestroySemaphore"));

        vkCreateFence = reinterpret_cast<PFN_vkCreateFence>(vkGetInstanceProcAddr(instance, "vkCreateFence"));
        vkDestroyFence = reinterpret_cast<PFN_vkDestroyFence>(vkGetInstanceProcAddr(instance, "vkDestroyFence"));
        vkWaitForFences = reinterpret_cast<PFN_vkWaitForFences>(vkGetInstanceProcAddr(instance, "vkWaitForFences"));
        vkResetFences = reinterpret_cast<PFN_vkResetFences>(vkGetInstanceProcAddr(instance, "vkResetFences"));
        ;
        vkResetDescriptorPool =
            reinterpret_cast<PFN_vkResetDescriptorPool>(vkGetInstanceProcAddr(instance, "vkResetDescriptorPool"));

        vkCreateCommandPool =
            reinterpret_cast<PFN_vkCreateCommandPool>(vkGetInstanceProcAddr(instance, "vkCreateCommandPool"));
        vkDestroyCommandPool =
            reinterpret_cast<PFN_vkDestroyCommandPool>(vkGetInstanceProcAddr(instance, "vkDestroyCommandPool"));
        ;

        vkAllocateCommandBuffers = reinterpret_cast<PFN_vkAllocateCommandBuffers>(
            vkGetInstanceProcAddr(instance, "vkAllocateCommandBuffers"));
        vkBeginCommandBuffer =
            reinterpret_cast<PFN_vkBeginCommandBuffer>(vkGetInstanceProcAddr(instance, "vkBeginCommandBuffer"));
        vkResetCommandBuffer =
            reinterpret_cast<PFN_vkResetCommandBuffer>(vkGetInstanceProcAddr(instance, "vkResetCommandBuffer"));
        vkEndCommandBuffer =
            reinterpret_cast<PFN_vkEndCommandBuffer>(vkGetInstanceProcAddr(instance, "vkEndCommandBuffer"));

        vkGetDeviceQueue =
            reinterpret_cast<PFN_vkGetDeviceQueue>(vkGetInstanceProcAddr(instance, "vkGetDeviceQueue"));
        vkQueueSubmit = reinterpret_cast<PFN_vkQueueSubmit>(vkGetInstanceProcAddr(instance, "vkQueueSubmit"));
        vkQueueWaitIdle = reinterpret_cast<PFN_vkQueueWaitIdle>(vkGetInstanceProcAddr(instance, "vkQueueWaitIdle"));

        vkDeviceWaitIdle =
            reinterpret_cast<PFN_vkDeviceWaitIdle>(vkGetInstanceProcAddr(instance, "vkDeviceWaitIdle"));

        vkCreateFramebuffer =
            reinterpret_cast<PFN_vkCreateFramebuffer>(vkGetInstanceProcAddr(instance, "vkCreateFramebuffer"));

        vkCreatePipelineCache =
            reinterpret_cast<PFN_vkCreatePipelineCache>(vkGetInstanceProcAddr(instance, "vkCreatePipelineCache"));
        vkCreatePipelineLayout =
            reinterpret_cast<PFN_vkCreatePipelineLayout>(vkGetInstanceProcAddr(instance, "vkCreatePipelineLayout"));
        vkCreateGraphicsPipelines = reinterpret_cast<PFN_vkCreateGraphicsPipelines>(
            vkGetInstanceProcAddr(instance, "vkCreateGraphicsPipelines"));
        vkCreateComputePipelines = reinterpret_cast<PFN_vkCreateComputePipelines>(
            vkGetInstanceProcAddr(instance, "vkCreateComputePipelines"));

        vkCreateDescriptorPool =
            reinterpret_cast<PFN_vkCreateDescriptorPool>(vkGetInstanceProcAddr(instance, "vkCreateDescriptorPool"));
        vkCreateDescriptorSetLayout = reinterpret_cast<PFN_vkCreateDescriptorSetLayout>(
            vkGetInstanceProcAddr(instance, "vkCreateDescriptorSetLayout"));

        vkAllocateDescriptorSets = reinterpret_cast<PFN_vkAllocateDescriptorSets>(
            vkGetInstanceProcAddr(instance, "vkAllocateDescriptorSets"));
        vkUpdateDescriptorSets =
            reinterpret_cast<PFN_vkUpdateDescriptorSets>(vkGetInstanceProcAddr(instance, "vkUpdateDescriptorSets"));

        vkCmdBindDescriptorSets = reinterpret_cast<PFN_vkCmdBindDescriptorSets>(
            vkGetInstanceProcAddr(instance, "vkCmdBindDescriptorSets"));
        vkCmdBindPipeline =
            reinterpret_cast<PFN_vkCmdBindPipeline>(vkGetInstanceProcAddr(instance, "vkCmdBindPipeline"));
        vkCmdBindVertexBuffers =
            reinterpret_cast<PFN_vkCmdBindVertexBuffers>(vkGetInstanceProcAddr(instance, "vkCmdBindVertexBuffers"));
        vkCmdBindIndexBuffer =
            reinterpret_cast<PFN_vkCmdBindIndexBuffer>(vkGetInstanceProcAddr(instance, "vkCmdBindIndexBuffer"));

        vkCmdSetViewport =
            reinterpret_cast<PFN_vkCmdSetViewport>(vkGetInstanceProcAddr(instance, "vkCmdSetViewport"));
        vkCmdSetScissor = reinterpret_cast<PFN_vkCmdSetScissor>(vkGetInstanceProcAddr(instance, "vkCmdSetScissor"));
        vkCmdSetLineWidth =
            reinterpret_cast<PFN_vkCmdSetLineWidth>(vkGetInstanceProcAddr(instance, "vkCmdSetLineWidth"));
        vkCmdSetDepthBias =
            reinterpret_cast<PFN_vkCmdSetDepthBias>(vkGetInstanceProcAddr(instance, "vkCmdSetDepthBias"));
        vkCmdPushConstants =
            reinterpret_cast<PFN_vkCmdPushConstants>(vkGetInstanceProcAddr(instance, "vkCmdPushConstants"));
        ;

        vkCmdDrawIndexed =
            reinterpret_cast<PFN_vkCmdDrawIndexed>(vkGetInstanceProcAddr(instance, "vkCmdDrawIndexed"));
        vkCmdDraw = reinterpret_cast<PFN_vkCmdDraw>(vkGetInstanceProcAddr(instance, "vkCmdDraw"));
        vkCmdDrawIndexedIndirect = reinterpret_cast<PFN_vkCmdDrawIndexedIndirect>(
            vkGetInstanceProcAddr(instance, "vkCmdDrawIndexedIndirect"));
        vkCmdDrawIndirect =
            reinterpret_cast<PFN_vkCmdDrawIndirect>(vkGetInstanceProcAddr(instance, "vkCmdDrawIndirect"));
        vkCmdDispatch = reinterpret_cast<PFN_vkCmdDispatch>(vkGetInstanceProcAddr(instance, "vkCmdDispatch"));

        vkDestroyPipeline =
            reinterpret_cast<PFN_vkDestroyPipeline>(vkGetInstanceProcAddr(instance, "vkDestroyPipeline"));
        vkDestroyPipelineLayout = reinterpret_cast<PFN_vkDestroyPipelineLayout>(
            vkGetInstanceProcAddr(instance, "vkDestroyPipelineLayout"));
        ;
        vkDestroyDescriptorSetLayout = reinterpret_cast<PFN_vkDestroyDescriptorSetLayout>(
            vkGetInstanceProcAddr(instance, "vkDestroyDescriptorSetLayout"));
        vkDestroyDevice = reinterpret_cast<PFN_vkDestroyDevice>(vkGetInstanceProcAddr(instance, "vkDestroyDevice"));
        vkDestroyInstance =
            reinterpret_cast<PFN_vkDestroyInstance>(vkGetInstanceProcAddr(instance, "vkDestroyInstance"));
        vkDestroyDescriptorPool = reinterpret_cast<PFN_vkDestroyDescriptorPool>(
            vkGetInstanceProcAddr(instance, "vkDestroyDescriptorPool"));
        vkFreeCommandBuffers =
            reinterpret_cast<PFN_vkFreeCommandBuffers>(vkGetInstanceProcAddr(instance, "vkFreeCommandBuffers"));
        vkDestroyRenderPass =
            reinterpret_cast<PFN_vkDestroyRenderPass>(vkGetInstanceProcAddr(instance, "vkDestroyRenderPass"));
        vkDestroyFramebuffer =
            reinterpret_cast<PFN_vkDestroyFramebuffer>(vkGetInstanceProcAddr(instance, "vkDestroyFramebuffer"));
        vkDestroyShaderModule =
            reinterpret_cast<PFN_vkDestroyShaderModule>(vkGetInstanceProcAddr(instance, "vkDestroyShaderModule"));
        vkDestroyPipelineCache =
            reinterpret_cast<PFN_vkDestroyPipelineCache>(vkGetInstanceProcAddr(instance, "vkDestroyPipelineCache"));

        vkCreateQueryPool =
            reinterpret_cast<PFN_vkCreateQueryPool>(vkGetInstanceProcAddr(instance, "vkCreateQueryPool"));
        vkDestroyQueryPool =
            reinterpret_cast<PFN_vkDestroyQueryPool>(vkGetInstanceProcAddr(instance, "vkDestroyQueryPool"));
        vkGetQueryPoolResults =
            reinterpret_cast<PFN_vkGetQueryPoolResults>(vkGetInstanceProcAddr(instance, "vkGetQueryPoolResults"));

        vkCmdBeginQuery = reinterpret_cast<PFN_vkCmdBeginQuery>(vkGetInstanceProcAddr(instance, "vkCmdBeginQuery"));
        vkCmdEndQuery = reinterpret_cast<PFN_vkCmdEndQuery>(vkGetInstanceProcAddr(instance, "vkCmdEndQuery"));
        vkCmdResetQueryPool =
            reinterpret_cast<PFN_vkCmdResetQueryPool>(vkGetInstanceProcAddr(instance, "vkCmdResetQueryPool"));
        vkCmdCopyQueryPoolResults = reinterpret_cast<PFN_vkCmdCopyQueryPoolResults>(
            vkGetInstanceProcAddr(instance, "vkCmdCopyQueryPoolResults"));

        vkCreateSurfaceOHOS =
            reinterpret_cast<PFN_vkCreateSurfaceOHOS>(vkGetInstanceProcAddr(instance, "vkCreateSurfaceOHOS"));
        vkDestroySurfaceKHR =
            reinterpret_cast<PFN_vkDestroySurfaceKHR>(vkGetInstanceProcAddr(instance, "vkDestroySurfaceKHR"));

        vkCmdFillBuffer = reinterpret_cast<PFN_vkCmdFillBuffer>(vkGetInstanceProcAddr(instance, "vkCmdFillBuffer"));
        vkGetPhysicalDeviceSurfaceSupportKHR = reinterpret_cast<PFN_vkGetPhysicalDeviceSurfaceSupportKHR>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceSupportKHR"));
        vkGetPhysicalDeviceSurfaceCapabilitiesKHR = reinterpret_cast<PFN_vkGetPhysicalDeviceSurfaceCapabilitiesKHR>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceCapabilitiesKHR"));
        vkGetPhysicalDeviceSurfaceFormatsKHR = reinterpret_cast<PFN_vkGetPhysicalDeviceSurfaceFormatsKHR>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfaceFormatsKHR"));
        vkGetPhysicalDeviceSurfacePresentModesKHR = reinterpret_cast<PFN_vkGetPhysicalDeviceSurfacePresentModesKHR>(
            vkGetInstanceProcAddr(instance, "vkGetPhysicalDeviceSurfacePresentModesKHR"));
    }

    void LoadVulkanFunctions(VkDevice device)
    {
        vkCreateSwapchainKHR =
            reinterpret_cast<PFN_vkCreateSwapchainKHR>(vkGetDeviceProcAddr(device, "vkCreateSwapchainKHR"));
        vkDestroySwapchainKHR =
            reinterpret_cast<PFN_vkDestroySwapchainKHR>(vkGetDeviceProcAddr(device, "vkDestroySwapchainKHR"));
        vkGetSwapchainImagesKHR =
            reinterpret_cast<PFN_vkGetSwapchainImagesKHR>(vkGetDeviceProcAddr(device, "vkGetSwapchainImagesKHR"));
        vkAcquireNextImageKHR =
            reinterpret_cast<PFN_vkAcquireNextImageKHR>(vkGetDeviceProcAddr(device, "vkAcquireNextImageKHR"));
        vkQueuePresentKHR =
            reinterpret_cast<PFN_vkQueuePresentKHR>(vkGetDeviceProcAddr(device, "vkQueuePresentKHR"));
        vkGetMemoryNativeBufferOHOS = reinterpret_cast<PFN_vkGetMemoryNativeBufferOHOS>(
            vkGetDeviceProcAddr(device, "vkGetMemoryNativeBufferOHOS"));
        vkGetNativeBufferPropertiesOHOS = reinterpret_cast<PFN_vkGetNativeBufferPropertiesOHOS>(
            vkGetDeviceProcAddr(device, "vkGetNativeBufferPropertiesOHOS"));
    }
} // namespace utils
} // namespace vkExample
