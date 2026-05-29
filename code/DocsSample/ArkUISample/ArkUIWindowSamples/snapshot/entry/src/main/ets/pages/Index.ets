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

import { display, screenshot, window } from '@kit.ArkUI';
import { common, abilityAccessCtrl, Permissions } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { image } from '@kit.ImageKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State statusText: string = 'Tap a button to run the snapshot sample.';
  @State logText: string = 'ready\n';
  @State imageWidth: number = 0;
  @State imageHeight: number = 0;
  @State previewPixelMap?: image.PixelMap = undefined;
  @State displayIdText: string = '0';
  @State displayInfoText: string = '-';
  @State pickRectText: string = '-';

  private currentWindow?: window.Window = undefined;

  aboutToAppear(): void {
    void this.initWindow();
    this.initDisplayInfo();
  }

  // 在页面中记录接口调用结果，同时输出到 hilog，便于调试。
  private appendLog(message: string): void {
    this.statusText = message;
    hilog.info(DOMAIN, 'snapshotSample', message);

    const line = `${Date.now()}: ${message}`;
    this.logText += `${line}\n`;
    hilog.info(DOMAIN, 'snapshotSample', line);
  }

  // 获取当前应用窗口。window.snapshot 系列接口需要通过 Window 对象调用。
  private async initWindow(): Promise<void> {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        throw new Error('Host context is unavailable.');
      }

      const context = hostContext as common.UIAbilityContext;
      this.currentWindow = await window.getLastWindow(context);

      const windowId = this.currentWindow.getWindowProperties().id;
      this.statusText = `windowId=${windowId}`;
      this.appendLog(`window initialized, windowId=${windowId}`);
    } catch (err) {
      this.statusText = `Initialization failed: ${JSON.stringify(err)}`;
      this.appendLog(`Initialization failed: ${JSON.stringify(err)}`);
      this.appendLog(this.statusText);
    }
  }

  // 获取当前设备可用的 displayId，供 screenshot.capture 使用。
  private async initDisplayInfo(): Promise<void> {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      this.displayIdText = `${defaultDisplay.id}`;

      const displays = await display.getAllDisplays();
      this.displayInfoText = displays.map((item) => `${item.id}`).join(', ');
      this.statusText = `available dsplayIds=${this.displayInfoText}`;
    } catch (err) {
      this.statusText = `init display info failed: $JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'screenshotSample', this.statusText);
    }
  }

  // 截图前确认当前窗口已初始化。
  private async ensureWindow(): Promise<boolean> {
    if (!this.currentWindow) {
      await this.initWindow();
    }

    if (!this.currentWindow) {
      this.statusText = 'Current window is unavailable.';
      this.appendLog(this.statusText);
      return false;
    }

    return true;
  }

  // 将截图结果展示到页面预览区域，并读取 PixelMap 宽高。
  private updatePreview(pixelMap: image.PixelMap, source: string): void {
    this.previewPixelMap = pixelMap;

    try {
      const imageInfo = pixelMap.getImageInfoSync();
      this.imageWidth = imageInfo.size.width;
      this.imageHeight = imageInfo.size.height;
      this.statusText = `${source} success, size=${this.imageWidth}x${this.imageHeight}`;
      this.appendLog(`${source} success, size=${this.imageWidth}x${this.imageHeight}`);
    } catch (err) {
      this.imageWidth = 0;
      this.imageHeight = 0;
      this.statusText = `${source} success, but getImageInfoSync failed: ${JSON.stringify(err)}`;
      this.appendLog(`${source} success, but getImageInfoSync failed: ${JSON.stringify(err)}`);
    }

    hilog.info(DOMAIN, 'screenshotSample', this.statusText);
    this.appendLog(this.statusText);
  }

  // 异步截取当前窗口。隐私窗口场景下，截图结果会受到隐私模式保护。
  private async takeWindowSnapshot(): Promise<void> {
    if (!await this.ensureWindow()) {
      return;
    }

    try {
      const pixelMap = await this.currentWindow!.snapshot();
      await this.updatePreview(pixelMap, 'window.snapshot');
    } catch (err) {
      this.statusText = `window.snapshot failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // 同步截取当前窗口。调用方式更直接，但会同步返回 PixelMap。
  private takeWindowSnapshotSync(): void {
    if (!this.currentWindow) {
      this.statusText = 'window.snapshotSync failed: current window is unavailable.';
      this.appendLog(this.statusText);
      return;
    }

    try {
      const pixelMap = this.currentWindow.snapshotSync();
      void this.updatePreview(pixelMap, 'window.snapshotSync');
    } catch (err) {
      this.statusText = `window.snapshotSync failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // 忽略隐私模式截取当前窗口。仅在业务明确需要且设备支持时使用。
  private async takeWindowSnapshotIgnorePrivacy(): Promise<void> {
    if (!await this.ensureWindow()) {
      return;
    }

    try {
      const pixelMap = await this.currentWindow!.snapshotIgnorePrivacy();
      await this.updatePreview(pixelMap, 'window.snapshotIgnorePrivacy');
    } catch (err) {
      this.statusText = `window.snapshotIgnorePrivacy failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // getMainWindowSnapshot 需要使用 ohos.permission.CUSTOM_SCREEN_CAPTURE 权限。
  private async requestCapturePermission(): Promise<boolean> {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        this.statusText = 'permission request failed: hostContext is unavailable';
        this.appendLog('permission request failed: hostContext is unavailable');
        return false;
      }

      const context = hostContext as common.UIAbilityContext;
      const atManager = abilityAccessCtrl.createAtManager();
      const result = await atManager.requestPermissionsFromUser(context, [
        'ohos.permission.CUSTOM_SCREEN_CAPTURE' as Permissions
      ]);

      const granted = result.authResults.length > 0 && result.authResults[0] === 0;
      this.statusText = `permission granted=${granted}`;
      this.appendLog(`permission granted=${granted}`);
      return granted;
    } catch (err) {
      this.statusText = `permission request failed: ${JSON.stringify(err)}`;
      this.appendLog(`permission request failed: ${JSON.stringify(err)}`);
      return false;
    }
  }

  // 通过当前主窗口 ID 获取主窗口截图。
  private async takeMainWindowSnapshot(): Promise<void> {
    if (!this.currentWindow) {
      await this.initWindow();
    }

    if (!this.currentWindow) {
      this.appendLog('Current window is unavailable.');
      return;
    }

    const granted = await this.requestCapturePermission();
    if (!granted) {
      this.appendLog('CUSTOM_SCREEN_CAPTURE permission denied or unavailable.');
      return;
    }

    try {
      const windowId = this.currentWindow.getWindowProperties().id;
      const pixelMaps = await window.getMainWindowSnapshot([windowId], {
        useCache: false
      });

      const pixelMap = pixelMaps[0];
      if (!pixelMap) {
        this.appendLog(`getMainWindowSnapshot(${windowId}) returned undefined.`);
        return;
      }

      await this.updatePreview(pixelMap, 'window.getMainWindowSnapshot');
    } catch (err) {
      this.appendLog(`getMainWindowSnapshot failed: ${JSON.stringify(err)}`);
    }
  }

  // 通过手势框选屏幕区域，仅支持主屏区域截图。
  private async pickScreenArea(): Promise<void> {
    try {
      const result = await screenshot.pick();
      this.pickRectText = `left=${result.pickRect.left}, top=${result.pickRect.top}, width=${result.pickRect.width}, height=${result.pickRect.height}`;
      await this.updatePreview(result.pixelMap, 'screenshot.pick');
    } catch (err) {
      this.statusText = `screenshot.pick failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'screenshotSample', this.statusText);
    }
  }

  // 根据 displayId 截取对应屏幕的全屏内容。
  private async captureByDisplayId(): Promise<void> {
    const granted = await this.requestCapturePermission();
    if (!granted) {
      this.statusText = 'CUSTOM_SCREEN_CAPTURE permission denied or unavailable.';
      return;
    }

    try {
      const displayId = Number.parseInt(this.displayIdText, 10);
      if (Number.isNaN(displayId) || displayId < 0) {
        throw new Error(`Invalid displayId: ${this.displayIdText}`);
      }

      const pixelMap = await screenshot.capture({ displayId });
      await this.updatePreview(pixelMap, `screenshot.capture(displayId=${displayId})`);
    } catch (err) {
      this.statusText = `screenshot.capture failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'screenshotSample', this.statusText);
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('Window Snapshot Sample')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        // 调用异步窗口截图接口。
        Button('window.snapshot')
          .width('100%')
          .onClick(() => {
            void this.takeWindowSnapshot();
          })

        // 调用同步窗口截图接口。
        Button('window.snapshotSync')
          .width('100%')
          .backgroundColor('#0A7A5A')
          .onClick(() => {
            this.takeWindowSnapshotSync();
          })

        // 调用忽略隐私模式的窗口截图接口。
        Button('window.snapshotIgnorePrivacy')
          .width('100%')
          .backgroundColor('#AD5C00')
          .onClick(() => {
            void this.takeWindowSnapshotIgnorePrivacy();
          })

        Text('Main Window Snapshot Sample')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        Button('window.getMainWindowSnapshot')
          .width('100%')
          .onClick(() => {
            void this.takeMainWindowSnapshot();
          })

        Text('Screen Screenshot Sample')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(`Available displayIds: ${this.displayInfoText}`)
          .width('100%')
          .fontSize(12)
          .fontColor('#666666')
          .textAlign(TextAlign.Start)

        TextInput({ text: this.displayIdText, placeholder: 'Input displayId' })
          .width('100%')
          .onChange((value: string) => {
            this.displayIdText = value;
          })

        Button('screenshot.pick')
          .width('100%')
          .onClick(() => {
            void this.pickScreenArea();
          })

        Button('screenshot.capture')
          .width('100%')
          .onClick(() => {
            void this.captureByDisplayId();
          })

        Text(`Last pickRect: ${this.pickRectText}`)
          .width('100%')
          .fontSize(12)
          .fontColor('#666666')
          .textAlign(TextAlign.Start)

        Text('Status')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.statusText)
          .width('100%')
          .fontSize(14)
          .textAlign(TextAlign.Start)

        // 有截图结果时展示 PixelMap 预览和图片尺寸。
        if (this.previewPixelMap) {
          Text(`Preview size: ${this.imageWidth} x ${this.imageHeight}`)
            .width('100%')
            .fontSize(12)
            .fontColor('#666666')
            .textAlign(TextAlign.Start)

          Image(this.previewPixelMap)
            .width('100%')
            .height(360)
            .objectFit(ImageFit.Contain)
            .backgroundColor('#F3F3F3')
        }

        Text('Log')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.logText)
          .width('100%')
          .fontSize(12)
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(20)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}
