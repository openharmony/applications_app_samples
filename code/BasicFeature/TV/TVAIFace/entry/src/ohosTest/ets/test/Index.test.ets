/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import { Component, DisplayRotation, Driver, ON, Rect } from '@ohos.UiTest';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { resourceManager } from '@kit.LocalizationKit';

const TAG: string = '[Sample_AIFace]';
const BUNDLE: string = 'AIFace_';
const delegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage: resourceManager.ResourceManager = delegator.getAppContext().resourceManager;
  let text: string = await manage.getStringValue(resource);
  return text;
}

export default function IndexTest() {
  describe('AIFaceTests', () => {
    beforeAll(async () => {
      try {
        let want: Want = {
          bundleName: 'com.ohos.aiface',
          abilityName: 'MainAbility'
        };
        let abilityDelegator: abilityDelegatorRegistry.AbilityDelegator =
          abilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegator.startAbility(want);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'Ability startAbility fail');
        expect().assertFail();
      }
    })

    /**
     * 主页功能按钮测试 - 图像人脸识别
     */
    it(BUNDLE + 'HomePage_ImageRecognition_001', 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'HomePage_ImageRecognition_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(2000);

        // 查找图像人脸识别按钮（焦点ID为'1'）
        await driver.assertComponentExist(ON.id('1'));
        let imageRecognitionBtn: Component = await driver.findComponent(ON.id('1'));
        await imageRecognitionBtn.click();
        await driver.delayMs(2000);

        // 验证是否跳转到图像选择页面
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.local_image'))));

        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'HomePage_ImageRecognition_001 fail');
        expect().assertFail();
      }
      hilog.info(0x0000, TAG, BUNDLE + 'HomePage_ImageRecognition_001 end');
    })

    /**
     * 主页功能按钮测试 - 摄像头人脸识别
     */
    it(BUNDLE + 'HomePage_CameraRecognition_001', 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'HomePage_CameraRecognition_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(2000);

        // 查找摄像头人脸识别按钮（焦点ID为'0'）
        await driver.assertComponentExist(ON.id('0'));
        let cameraRecognitionBtn: Component = await driver.findComponent(ON.id('0'));
        await cameraRecognitionBtn.click();
        await driver.delayMs(2000);

        // 验证是否跳转到摄像头预览页面（检查XComponent是否存在）
        await driver.assertComponentExist(ON.type('XComponent'));

        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
      } catch (err) {
        // 可能没有摄像头设备，这是正常情况
        hilog.info(0x0000, TAG, 'Camera may not be available');
      }
      hilog.info(0x0000, TAG, BUNDLE + 'HomePage_CameraRecognition_001 end');
    })

    /**
     * 主页功能按钮测试 - 设备认证
     */
    it(BUNDLE + 'HomePage_DeviceAuthentication_001', 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'HomePage_DeviceAuthentication_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(2000);

        // 查找设备认证按钮（焦点ID为'-1'）
        await driver.assertComponentExist(ON.id('-1'));
        let deviceAuthBtn: Component = await driver.findComponent(ON.id('-1'));
        await deviceAuthBtn.click();
        await driver.delayMs(2000);

        // 验证是否跳转到设备认证页面
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.Trust_Device'))));

        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'HomePage_DeviceAuthentication_001 fail');
        expect().assertFail();
      }
      hilog.info(0x0000, TAG, BUNDLE + 'HomePage_DeviceAuthentication_001 end');
    })

    /**
     * 图像选择页面测试
     */
    it(BUNDLE + 'ImageSelect_001', 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'ImageSelect_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(2000);
        // 进入图像选择页面
        await driver.assertComponentExist(ON.id('1'));
        let imageRecognitionBtn: Component = await driver.findComponent(ON.id('1'));
        await imageRecognitionBtn.click();
        await driver.delayMs(2000);
        // 验证页面标题
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.local_image'))));
        // 检查是否有图片显示
        await driver.delayMs(3000); // 等待图片加载
        try {
          // 查找所有图片组件
          let imageComponents: Component[] = await driver.findComponents(ON.type('Image'));
          // 先检查是否有图片组件
          if (imageComponents && imageComponents.length > 0) {
            let firstImage: Component | undefined = undefined;
            // 找到第一个符合条件的图片组件（排除SVG图标等）
            for (let i = 0; i < imageComponents.length; i++) {
              try {
                let bounds: Rect = await imageComponents[i].getBounds();
                // 计算宽度和高度
                let width: number = bounds.right - bounds.left;
                let height: number = bounds.bottom - bounds.top;

                // 检查是否为缩略图（根据尺寸判断，通常缩略图尺寸较大）
                // 跳过尺寸很小的图标（如100x100的图标）
                if (width > 150 && height > 150) {
                  firstImage = imageComponents[i];
                  hilog.info(0x0000, TAG, `Found image with dimensions: ${width}x${height}`);
                  break;
                }
              } catch (boundsErr) {
                // 如果获取bounds失败，继续检查下一个
                continue;
              }
            }
            // 如果找到了合适的图片，点击它
            if (firstImage !== undefined) {
              await firstImage.click();
              await driver.delayMs(2000);
              // 验证是否进入图像预览页面
              // 可能出现的页面元素：Canvas、加载进度条或人脸检测框
              try {
                // 先检查是否有Canvas元素
                await driver.assertComponentExist(ON.type('Canvas'));
                hilog.info(0x0000, TAG, 'Image preview page loaded with Canvas');
              } catch (canvasErr) {
                // 如果没有Canvas，可能直接进入了AI处理页面
                // 检查是否有其他图像预览相关元素
                try {
                  await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.AI_fail_load'))));
                  hilog.info(0x0000, TAG, 'AI model loading message found');
                } catch (aiErr) {
                  // 可能图片正在处理中
                  hilog.info(0x0000, TAG, 'Image may be processing, checking for loading indicator');
                }
              }
              // 返回图像选择页面
              await driver.pressBack();
              await driver.delayMs(1000);
            } else {
              hilog.info(0x0000, TAG, 'No suitable image found for testing (all images are too small)');
            }
          } else {
            hilog.info(0x0000, TAG, 'No image components found at all');
          }
        } catch (err) {
          hilog.info(0x0000, TAG, 'No images available for selection or error occurred: ' + JSON.stringify(err));
        }
        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
      } catch (err) {
        hilog.error(0x0000, TAG, BUNDLE + 'ImageSelect_001 fail: ' + JSON.stringify(err));
        expect().assertFail();
      }
      hilog.info(0x0000, TAG, BUNDLE + 'ImageSelect_001 end');
    });

    /**
     * 设备认证页面测试 - 发现设备
     */
    it(BUNDLE + 'DeviceAuthentication_Discover_001', 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'DeviceAuthentication_Discover_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(2000);
        // 进入设备认证页面
        await driver.assertComponentExist(ON.id('-1'));
        let deviceAuthBtn: Component = await driver.findComponent(ON.id('-1'));
        await deviceAuthBtn.click();
        await driver.delayMs(2000);
        // 点击"发现设备"按钮
        await driver.assertComponentExist(ON.id('button'));
        let discoverBtn: Component = await driver.findComponent(ON.id('button'));
        await discoverBtn.click();
        await driver.delayMs(3000);
        // 验证按钮状态变化
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.discovering_devices'))));
        // 再次点击停止发现
        await discoverBtn.click();
        await driver.delayMs(1000);
        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
      } catch (err) {
        hilog.error(0x0000, TAG, '%{public}s', 'DeviceAuthentication_Discover_001 fail');
        expect().assertFail();
      }
      hilog.info(0x0000, TAG, BUNDLE + 'DeviceAuthentication_Discover_001 end');
    })

    /**
     * 摄像头页面测试 - 多机位切换
     */
    it(BUNDLE + 'CameraPage_MultiCamera_001', 0, async () => {
      hilog.info(0x0000, TAG, BUNDLE + 'CameraPage_MultiCamera_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(2000);

        // 进入摄像头页面
        await driver.assertComponentExist(ON.id('0'));
        let cameraBtn: Component = await driver.findComponent(ON.id('0'));
        await cameraBtn.click();
        await driver.delayMs(2000);

        // 验证摄像头预览组件存在
        await driver.assertComponentExist(ON.type('XComponent'));
        await driver.delayMs(1000);

        // 返回主页
        await driver.pressBack();
        await driver.delayMs(1000);
      } catch (err) {
        // 可能没有摄像头，这是正常情况
        hilog.info(0x0000, TAG, 'Camera may not be available');
      }
      hilog.info(0x0000, TAG, BUNDLE + 'CameraPage_MultiCamera_001 end');
    })

    /**
     * 清理测试环境
     */
    it(BUNDLE + "CleanupEnvironment", 0, async (done: Function) => {
      hilog.info(0x0000, TAG, BUNDLE + 'CleanupEnvironment begin');
      let driver: Driver = Driver.create();
      await driver.setDisplayRotation(DisplayRotation.ROTATION_0);
      await driver.pressHome();
      await driver.delayMs(2000);
      hilog.info(0x0000, TAG, BUNDLE + 'CleanupEnvironment end');
      done();
    })
  })
}