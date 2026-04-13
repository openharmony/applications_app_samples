import { display, window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import image from '@ohos.multimedia.image';
import screenshot from '@ohos.screenshot';

const DOMAIN = 0x0000;
const COMPONENT_ID = 'snapshotTarget';

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
    void this.initContextInfo();
  }

  // 在页面内保留一份简单日志，方便直接观察每个截图接口的调用结果。
  private appendLog(message: string): void {
    const line = `${Date.now()}: ${message}`;
    this.logText += `${line}\n`;
    hilog.info(DOMAIN, 'snapshotSample', line);
  }

  // 初始化宿主窗口，并收集可用于 screenshot.capture 的 displayId。
  private async initContextInfo(): Promise<void> {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        throw new Error('Host context is unavailable.');
      }
      const context = hostContext as common.UIAbilityContext;
      this.currentWindow = await window.getLastWindow(context);

      const defaultDisplay = display.getDefaultDisplaySync();
      this.displayIdText = `${defaultDisplay.id}`;

      const displays = await display.getAllDisplays();
      this.displayInfoText = displays.map((item) => `${item.id}`).join(', ');

      const windowId = this.currentWindow.getWindowProperties().id;
      this.statusText = `windowId=${windowId}, displays=${this.displayInfoText}`;
      this.appendLog(`window initialized, windowId=${windowId}, displayIds=${this.displayInfoText}`);
    } catch (err) {
      this.statusText = `Initialization failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // 解析页面输入的 displayId，传给 screenshot.capture 前先做一次基本校验。
  private parseDisplayId(): number {
    const displayId = Number.parseInt(this.displayIdText, 10);
    if (Number.isNaN(displayId) || displayId < 0) {
      throw new Error(`Invalid displayId: ${this.displayIdText}`);
    }
    return displayId;
  }

  // 所有截图结果都复用同一个预览区域，便于对比不同接口的输出。
  private async updatePreview(pixelMap: image.PixelMap, source: string): Promise<void> {
    this.previewPixelMap = pixelMap;
    try {
      const imageInfo = pixelMap.getImageInfoSync();
      this.imageWidth = imageInfo.size.width;
      this.imageHeight = imageInfo.size.height;
      this.statusText = `${source} success, size=${this.imageWidth}x${this.imageHeight}`;
    } catch (err) {
      this.imageWidth = 0;
      this.imageHeight = 0;
      this.statusText = `${source} success, but getImageInfoSync failed: ${JSON.stringify(err)}`;
    }
    this.appendLog(this.statusText);
  }

  // window.snapshot 系列接口都依赖当前窗口对象，这里统一兜底初始化。
  private async ensureWindow(): Promise<boolean> {
    if (!this.currentWindow) {
      await this.initContextInfo();
    }
    if (!this.currentWindow) {
      this.statusText = 'Current window is unavailable.';
      this.appendLog(this.statusText);
      return false;
    }
    return true;
  }

  // 异步截取当前应用窗口。
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

  // 同步版本的窗口截图接口。
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

  // 在设备支持的前提下，忽略隐私模式截取当前窗口。
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

  // 让用户手动框选屏幕区域，并返回选区信息和对应截图。
  private async pickScreenArea(): Promise<void> {
    try {
      const result = await screenshot.pick();
      this.pickRectText = `left=${result.pickRect.left}, top=${result.pickRect.top}, width=${result.pickRect.width}, height=${result.pickRect.height}`;
      this.appendLog(`screenshot.pick rect=${this.pickRectText}`);
      await this.updatePreview(result.pixelMap, 'screenshot.pick');
    } catch (err) {
      this.statusText = `screenshot.pick failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // screenshot.capture 需要在运行时申请 CUSTOM_SCREEN_CAPTURE 权限。
  private async requestCapturePermission(): Promise<boolean> {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        this.appendLog('permission request failed: hostContext is unavailable');
        return false;
      }

      const context = hostContext as common.UIAbilityContext;
      const atManager = abilityAccessCtrl.createAtManager();
      const result = await atManager.requestPermissionsFromUser(context, [
        'ohos.permission.CUSTOM_SCREEN_CAPTURE' as Permissions
      ]);

      this.appendLog(`permission request result=${JSON.stringify(result.authResults)}`);
      return result.authResults.length > 0 && result.authResults[0] === 0;
    } catch (err) {
      this.appendLog(`permission request failed: ${JSON.stringify(err)}`);
      return false;
    }
  }

  // 权限申请成功后，按指定 displayId 截取对应屏幕。
  private async captureByDisplayId(): Promise<void> {
    try {
      const granted = await this.requestCapturePermission();
      if (!granted) {
        this.statusText = 'CUSTOM_SCREEN_CAPTURE permission denied or unavailable.';
        this.appendLog(this.statusText);
        return;
      }

      const displayId = this.parseDisplayId();
      const pixelMap = await screenshot.capture({ displayId });
      await this.updatePreview(pixelMap, `screenshot.capture(displayId=${displayId})`);
    } catch (err) {
      this.statusText = `screenshot.capture failed: ${JSON.stringify(err)}`;
      this.appendLog(`${this.statusText}. Hint: declare/grant ohos.permission.CUSTOM_SCREEN_CAPTURE first.`);
    }
  }

  // 只截取指定 id 的组件，而不是整页或整窗口。
  private async takeComponentSnapshot(): Promise<void> {
    try {
      const pixelMap = await this.getUIContext().getComponentSnapshot().get(COMPONENT_ID, {
        scale: 1,
        waitUntilRenderFinished: true
      });
      await this.updatePreview(pixelMap, 'componentSnapshot.get');
    } catch (err) {
      this.statusText = `componentSnapshot.get failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Column({ space: 8 }) {
          Text('Snapshot Sample Center')
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text('Includes window.snapshot, screenshot.pick, screenshot.capture(displayId), and componentSnapshot.')
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(TextAlign.Start)
        }
        .width('100%')

        Column({ space: 10 }) {
          Text('Window Snapshot')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)

          Button('window.snapshot')
            .width('100%')
            .onClick(() => {
              void this.takeWindowSnapshot();
            })

          Button('window.snapshotSync')
            .width('100%')
            .backgroundColor('#0A7A5A')
            .onClick(() => {
              this.takeWindowSnapshotSync();
            })

          Button('window.snapshotIgnorePrivacy')
            .width('100%')
            .backgroundColor('#AD5C00')
            .onClick(() => {
              void this.takeWindowSnapshotIgnorePrivacy();
            })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F8F4ED')
        .borderRadius(20)

        Column({ space: 10 }) {
          Text('Screen Screenshot')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
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

          Button('screenshot.pick()')
            .width('100%')
            .backgroundColor('#3F6FB6')
            .onClick(() => {
              void this.pickScreenArea();
            })

          Button('screenshot.capture({ displayId })')
            .width('100%')
            .backgroundColor('#6D4CC2')
            .onClick(() => {
              void this.captureByDisplayId();
            })

          Text(`Last pickRect: ${this.pickRectText}`)
            .width('100%')
            .fontSize(12)
            .fontColor('#666666')
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#EDF3FB')
        .borderRadius(20)

        Column({ space: 10 }) {
          Text('Component Snapshot')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)

          Button('componentSnapshot.get()')
            .width('100%')
            .backgroundColor('#B55D33')
            .onClick(() => {
              void this.takeComponentSnapshot();
            })

          Column({ space: 6 }) {
            Text('This card is the component snapshot target.')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#1E3A2F')

            Text('ID: snapshotTarget')
              .fontSize(12)
              .fontColor('#4C6A5A')

            Text('Use componentSnapshot to capture only this component.')
              .fontSize(13)
              .fontColor('#2E5143')
          }
          .id(COMPONENT_ID)
          .width('100%')
          .padding(16)
          .backgroundColor('#DFF3E7')
          .borderRadius(16)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFF2E8')
        .borderRadius(20)

        Column({ space: 8 }) {
          Text('Status')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text(this.statusText)
            .width('100%')
            .fontSize(14)
            .textAlign(TextAlign.Start)

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
              .borderRadius(12)
              .backgroundColor('#F3F3F3')
          }
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F6F4EE')
        .borderRadius(20)

        Column({ space: 8 }) {
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
        .padding(16)
        .backgroundColor('#EEF3F8')
        .borderRadius(20)
      }
      .width('100%')
      .padding(20)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}
