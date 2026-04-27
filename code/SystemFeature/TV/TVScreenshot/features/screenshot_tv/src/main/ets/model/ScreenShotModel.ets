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

import { screenshot } from '@kit.ArkUI';
import { window } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { Constants } from '../common/Constants';
import Log from '../common/Log';
import { Want, common } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'ScreenShot-ScreenShotModel';

const SCREENSHOT_PREFIX = 'Screenshot';
const PICTURE_TYPE = '.jpg';
const OPTIONS_QUALITY = 100;

/**
 * ScreenShotModel 类是整个截屏特性的核心逻辑封装。
 * 它负责调用系统底层截屏 API、处理位图数据、以及与文件系统交互。
 * 这种封装方式将底层的复杂异步操作与 UI 层解耦，确保了业务逻辑的可测试性和稳定性。
 */
class ScreenShotModel {
  private captureImage: image.PixelMap | undefined = undefined;
  private imageFileName: string = '';

  /**
   * 触发系统截屏功能。
   * 业务背景：当用户通过快捷键或 UI 按钮发起截屏请求时调用。
   * 原理：调用 @ohos.screenshot 提供的 save() 方法获取当前屏幕的 PixelMap。
   * 成功后通过 AppStorage 实时通知 UI 层进行预览更新，实现所见即所得。
   */
  async shotScreen(): Promise<void> {
    Log.showInfo(TAG, 'shotScreen');
    try {
      // 在 API 12+ 中，全屏截图建议使用 capture 方法，替代旧版的 save 方法。
      const data: image.PixelMap = await screenshot.capture();
      Log.showInfo(TAG, `screenshot.capture data success`);
      if (data) {
        this.captureImage = data;
        AppStorage.setOrCreate<image.PixelMap>('captureImage', data);
        this.showWindow();
        // 设置初始提示信息，告知用户截屏已启动并正在处理，缓解用户的等待焦虑。
        AppStorage.setOrCreate<string>('saveTipStr', '正在保存截屏图片到"照片"');
      }
    } catch (err) {
      const error = err as BusinessError;
      // 异常流处理：截屏失败时及时反馈，避免 UI 卡死在等待状态。
      AppStorage.setOrCreate<string>('saveTipStr', '截屏失败,请尝试重新截屏');
      Log.showError(TAG, `screenshot.capture err:${JSON.stringify(error)}`);
    }
  }

  /**
   * 将截屏图片异步保存到系统媒体库。
   * 业务背景：在用户预览截图后，需要持久化存储到设备中。
   * 原理：利用 ImagePacker 将 PixelMap 编码为 JPEG 格式，并通过 photoAccessHelper 接入系统媒体库。
   * 使用媒体库而非直接操作文件路径，是为了确保图片能被系统“图库”应用自动索引和展示。
   */
  async saveImage(): Promise<void> {
    let imageUri: string = '';
    let fd: number | undefined = undefined;
    let pixelMap = this.captureImage;
    if (!pixelMap) {
      Log.showError(TAG, 'saveImage failed, pixelMap is undefined');
      return;
    }
    const context = AppStorage.get('context') as common.UIAbilityContext;
    try {
      const helper = photoAccessHelper.getPhotoAccessHelper(context);
      // 生成唯一的文件名，防止多次截屏时发生文件覆盖。
      this.imageFileName = SCREENSHOT_PREFIX + '_' + (new Date()).getTime() + PICTURE_TYPE;
      Log.showInfo(TAG, `imageName: ${this.imageFileName}`);

      const packer = image.createImagePacker();
      // 在部分 API 12 环境下，packToBuffer 尚未可用，继续使用 packing。
      const packedImg: ArrayBuffer = await packer.packing(pixelMap, {
        format: 'image/jpeg', 
        quality: OPTIONS_QUALITY,
      });

      // 在公共目录创建占位符，这是鸿蒙系统推荐的安全访问媒体文件的方式。
      // API 12+ createAsset 返回的是 URI 字符串
      imageUri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');

      if (imageUri) {
        AppStorage.setOrCreate<string>('imageUri', imageUri);
        Log.showInfo(TAG, `imageUri: ${imageUri}`);

        // 通过文件描述符 (fd) 进行流式写入，相比全量写入更节省内存。
        const file = await fs.open(imageUri, fs.OpenMode.READ_WRITE);
        fd = file.fd;
        await fs.write(fd, packedImg);
        await fs.fsync(fd);
        AppStorage.setOrCreate<string>('imageFilename', this.imageFileName);
        AppStorage.setOrCreate<string>('saveTipStr', '截屏图片已存储到"照片"');
        Log.showInfo(TAG, `SaveImage success`);
      }
    } catch (error) {
      const err = error as BusinessError;
      // 捕获保存过程中的任何 I/O 或权限异常，并更新提示信息，确保用户知晓结果。
      AppStorage.setOrCreate<string>('saveTipStr', '截屏图片保存失败!');
      Log.showError(TAG, `SaveImage failed, cause: ${JSON.stringify(err)}`);
    } finally {
      // 严格遵循资源释放原则，无论成功或失败都必须关闭文件描述符，防止内存泄漏。
      if (fd !== undefined) {
        try {
          await fs.close(fd);
          Log.showInfo(TAG, `FileIo close, successful`);
        } catch (closeErr) {
          Log.showError(TAG, `FileIo close failed: ${JSON.stringify(closeErr)}`);
        }
      }
    }
  }

  /**
   * 显示截屏预览窗口。
   * 业务背景：截屏完成后，需要立即向用户展示预览效果。
   * 原理：通过窗口名称查找到已创建的悬浮窗，并调用其显示动画，增强交互动效。
   */
  showWindow(): void {
    Log.showInfo(TAG, 'showWindow');
    try {
      let win = window.findWindow(Constants.WIN_NAME);
      if (win) {
        win.showWindow().catch((err: BusinessError) => {
          Log.showError(TAG, 'showWindow failed: ' + JSON.stringify(err));
        });
      }
    } catch (err) {
      Log.showError(TAG, 'showWindow failed: ' + JSON.stringify(err));
    }
  }

  /**
   * 隐藏截屏预览窗口。
   * 业务背景：用户点击取消或预览时间结束后调用。
   * 原理：执行隐藏动画，并在动画结束后由业务逻辑决定是否销毁窗口或终止 Ability。
   */
  dismiss(): void {
    Log.showInfo(TAG, 'dismiss');
    try {
      let win = window.findWindow(Constants.WIN_NAME);
      if (win) {
        win.destroyWindow().catch((err: BusinessError) => {
          Log.showError(TAG, 'destroyWindow failed: ' + JSON.stringify(err));
        });
      }
    } catch (err) {
      Log.showError(TAG, 'dismiss failed: ' + JSON.stringify(err));
    }
  }

  /**
   * 启动指定的 Ability。
   * 业务背景：用于跨模块的功能调用，如跳转到设置或编辑页面。
   * 原理：封装了对 UIAbilityContext 的 startAbility 调用，提供统一的路由入口。
   */
  openAbility(wantData: Want): void {
    Log.showInfo(TAG, `openAbility want:${JSON.stringify(wantData)}`);
    const context = AppStorage.get('context') as common.UIAbilityContext;
    if (context) {
      context.startAbility(wantData).catch((err: BusinessError) => {
        Log.showError(TAG, 'startAbility failed: ' + JSON.stringify(err));
      });
    }
  }
}

export let screenShotModel = new ScreenShotModel();
