import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State brightnessValue: number = 0.5;
  @State keepScreenOn: boolean = false;
  @State statusText: string = 'Tap a control to adjust window brightness or keep-screen-on.';
  @State logText: string = 'ready\n';

  private currentWindow?: window.Window = undefined;

  aboutToAppear(): void {
    void this.initWindow();
  }

  // 在页面内保留一份简单日志，方便观察亮度和常亮接口的调用结果。
  private appendLog(message: string): void {
    const line = `${Date.now()}: ${message}`;
    this.logText += `${line}\n`;
    hilog.info(DOMAIN, 'windowBrightness', line);
  }

  // 初始化当前宿主窗口，后续亮度和常亮设置都作用在这个窗口上。
  private async initWindow(): Promise<void> {
    try {
      const hostContext = this.getUIContext().getHostContext();
      if (!hostContext) {
        throw new Error('Host context is unavailable.');
      }
      const context = hostContext as common.UIAbilityContext;
      this.currentWindow = await window.getLastWindow(context);
      const windowId = this.currentWindow.getWindowProperties().id;
      this.statusText = `window ready, id=${windowId}`;
      this.appendLog(this.statusText);
    } catch (err) {
      this.statusText = `initWindow failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // setWindowBrightness 和 setWindowKeepScreenOn 都依赖当前窗口对象，这里统一兜底初始化。
  private async ensureWindow(): Promise<boolean> {
    if (!this.currentWindow) {
      await this.initWindow();
    }
    if (!this.currentWindow) {
      this.statusText = 'current window is unavailable.';
      this.appendLog(this.statusText);
      return false;
    }
    return true;
  }

  // 设置当前窗口亮度，取值范围为 0 ~ 1。
  private async applyBrightness(value: number): Promise<void> {
    if (!await this.ensureWindow()) {
      return;
    }

    try {
      this.brightnessValue = value;
      await this.currentWindow!.setWindowBrightness(value);
      this.statusText = `setWindowBrightness(${value.toFixed(2)}) success`;
      this.appendLog(this.statusText);
    } catch (err) {
      this.statusText = `setWindowBrightness failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  // 设置当前窗口是否保持常亮。
  private async applyKeepScreenOn(value: boolean): Promise<void> {
    if (!await this.ensureWindow()) {
      return;
    }

    try {
      this.keepScreenOn = value;
      await this.currentWindow!.setWindowKeepScreenOn(value);
      this.statusText = `setWindowKeepScreenOn(${value}) success`;
      this.appendLog(this.statusText);
    } catch (err) {
      this.statusText = `setWindowKeepScreenOn failed: ${JSON.stringify(err)}`;
      this.appendLog(this.statusText);
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Column({ space: 8 }) {
          Text('Window Brightness Sample')
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text('Use setWindowBrightness to control brightness and setWindowKeepScreenOn to control screen-on behavior.')
            .fontSize(14)
            .fontColor('#666666')
            .width('100%')
            .textAlign(TextAlign.Start)
        }
        .width('100%')

        Column({ space: 12 }) {
          Text('Brightness')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text(`Current value: ${this.brightnessValue.toFixed(2)}`)
            .fontSize(16)
            .width('100%')
            .textAlign(TextAlign.Start)

          Slider({ value: this.brightnessValue, min: 0, max: 1, step: 0.01 })
            .width('100%')
            .showTips(true)
            .onChange((value: number) => {
              this.brightnessValue = value;
            })

          Button('Apply Brightness')
            .width('100%')
            .onClick(() => {
              void this.applyBrightness(this.brightnessValue);
            })

          Row({ space: 8 }) {
            Button('0.2')
              .layoutWeight(1)
              .onClick(() => {
                void this.applyBrightness(0.2);
              })

            Button('0.5')
              .layoutWeight(1)
              .backgroundColor('#0A7A5A')
              .onClick(() => {
                void this.applyBrightness(0.5);
              })

            Button('1.0')
              .layoutWeight(1)
              .backgroundColor('#AD5C00')
              .onClick(() => {
                void this.applyBrightness(1.0);
              })
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F8F4ED')
        .borderRadius(20)

        Column({ space: 12 }) {
          Text('Keep Screen On')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)

          Row() {
            Text(`Enabled: ${this.keepScreenOn}`)
              .layoutWeight(1)
              .fontSize(16)

            Toggle({ type: ToggleType.Switch, isOn: this.keepScreenOn })
              .onChange((value: boolean) => {
                void this.applyKeepScreenOn(value);
              })
          }
          .width('100%')

          Row({ space: 8 }) {
            Button('Keep On')
              .layoutWeight(1)
              .onClick(() => {
                void this.applyKeepScreenOn(true);
              })

            Button('Allow Sleep')
              .layoutWeight(1)
              .backgroundColor('#6D4CC2')
              .onClick(() => {
                void this.applyKeepScreenOn(false);
              })
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#EDF3FB')
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
