import { ColorMetrics, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @StorageLink('mainWindow') mainWindow: window.Window | undefined = undefined;

  @State alpha: number = 0;
  @State red: number = 0;
  @State green: number = 0;
  @State blue: number = 0;
  @State statusText: string = 'Move the sliders to change the current window background color.';
  @State applyModeText: string = 'Current mode: string (#AARRGGBB)';

  aboutToAppear(): void {
    this.applyWindowBackgroundColor();
  }

  // 将 0~255 的通道值转换成两位十六进制字符串，用于拼接 #AARRGGBB。
  private toHex(value: number): string {
    return Math.round(value).toString(16).padStart(2, '0').toUpperCase();
  }

  // 按 ARGB 顺序生成当前窗口背景色的十六进制字符串。
  private getColorValue(): string {
    return `#${this.toHex(this.alpha)}${this.toHex(this.red)}${this.toHex(this.green)}${this.toHex(this.blue)}`;
  }

  // 滑块变化时默认使用 string 形式更新窗口背景色。
  private applyWindowBackgroundColor(): void {
    if (!this.mainWindow) {
      this.statusText = 'Current window is unavailable.';
      return;
    }

    try {
      const color = this.getColorValue();
      this.mainWindow.setWindowBackgroundColor(color);
      this.statusText = `setWindowBackgroundColor(${color}) success`;
      hilog.info(DOMAIN, 'backgroundColor', this.statusText);
    } catch (err) {
      this.statusText = `setWindowBackgroundColor failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'backgroundColor', this.statusText);
    }
  }

  // 显式演示用 string（#AARRGGBB）设置窗口背景色。
  private applyByString(): void {
    if (!this.mainWindow) {
      this.statusText = 'Current window is unavailable.';
      return;
    }

    try {
      const color = this.getColorValue();
      this.mainWindow.setWindowBackgroundColor(color);
      this.applyModeText = 'Current mode: string (#AARRGGBB)';
      this.statusText = `setWindowBackgroundColor(${color}) success`;
      hilog.info(DOMAIN, 'backgroundColor', this.statusText);
    } catch (err) {
      this.statusText = `setWindowBackgroundColor by string failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'backgroundColor', this.statusText);
    }
  }

  // Color 枚举本身不能直接传给接口，这里先转成 ColorMetrics 再设置。
  private applyByColorEnum(color: ResourceColor, label: string): void {
    if (!this.mainWindow) {
      this.statusText = 'Current window is unavailable.';
      return;
    }

    try {
      const colorMetrics = ColorMetrics.resourceColor(color);
      this.mainWindow.setWindowBackgroundColor(colorMetrics);
      this.applyModeText = `Current mode: Color enum -> ColorMetrics (${label})`;
      this.statusText = `setWindowBackgroundColor(ColorMetrics.resourceColor(${label})) success`;
      hilog.info(DOMAIN, 'backgroundColor', this.statusText);
    } catch (err) {
      this.statusText = `setWindowBackgroundColor by Color enum failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'backgroundColor', this.statusText);
    }
  }

  // 直接演示用 ColorMetrics.rgba(...) 设置窗口背景色。
  private applyByColorMetrics(): void {
    if (!this.mainWindow) {
      this.statusText = 'Current window is unavailable.';
      return;
    }

    try {
      const alpha = Math.round(this.alpha) / 255;
      const colorMetrics = ColorMetrics.rgba(Math.round(this.red), Math.round(this.green), Math.round(this.blue), alpha);
      this.mainWindow.setWindowBackgroundColor(colorMetrics);
      this.applyModeText = 'Current mode: ColorMetrics.rgba(...)';
      this.statusText = `setWindowBackgroundColor(ColorMetrics.rgba(${Math.round(this.red)}, ${Math.round(this.green)}, ${Math.round(this.blue)}, ${alpha.toFixed(2)})) success`;
      hilog.info(DOMAIN, 'backgroundColor', this.statusText);
    } catch (err) {
      this.statusText = `setWindowBackgroundColor by ColorMetrics failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'backgroundColor', this.statusText);
    }
  }

  // 复用一套 ARGB 滑块 UI，滑动后立即刷新窗口背景色。
  @Builder
  @Builder
  private buildColorSlider(title: string, value: number, onChange: (value: number) => void) {
    Column({ space: 4 }) {
      Row() {
        Text(title)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width(28)

        Text(`${Math.round(value)}`)
          .fontSize(14)
          .fontColor('#666666')
          .layoutWeight(1)
          .textAlign(TextAlign.End)
      }
      .width('100%')

      Slider({ value: value, min: 0, max: 255, step: 1 })
        .width('100%')
        .showTips(true)
        .blockColor('#111111')
        .trackColor('#D8D8D8')
        .selectedColor('#111111')
        .onChange((sliderValue: number) => {
          onChange(sliderValue);
          this.applyWindowBackgroundColor();
        })
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }

  build() {
    Column({ space: 8 }) {
      Column({ space: 4 }) {
        Text('Current Window Background')
          .fontSize(16)
          .fontColor('#666666')
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.getColorValue())
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.statusText)
          .fontSize(11)
          .fontColor('#666666')
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)

        Text(this.applyModeText)
          .fontSize(11)
          .fontColor('#666666')
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 10, bottom: 10 })
      .borderRadius(12)

      this.buildColorSlider('A', this.alpha, (value: number) => {
        this.alpha = value;
      })

      this.buildColorSlider('R', this.red, (value: number) => {
        this.red = value;
      })

      this.buildColorSlider('G', this.green, (value: number) => {
        this.green = value;
      })

      this.buildColorSlider('B', this.blue, (value: number) => {
        this.blue = value;
      })

      Column({ space: 6 }) {
        Text('Set By')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .textAlign(TextAlign.Start)

        Row({ space: 8 }) {
          Button('String')
            .layoutWeight(1)
            .height(34)
            .fontSize(12)
            .onClick(() => {
              this.applyByString();
            })

          Button('Transparent')
            .layoutWeight(1)
            .height(34)
            .fontSize(12)
            .onClick(() => {
              this.applyByColorEnum(Color.Transparent, 'Color.Transparent');
            })
        }
        .width('100%')

        Row({ space: 8 }) {
          Button('Black')
            .layoutWeight(1)
            .height(34)
            .fontSize(12)
            .onClick(() => {
              this.applyByColorEnum(Color.Black, 'Color.Black');
            })

          Button('White')
            .layoutWeight(1)
            .height(34)
            .fontSize(12)
            .onClick(() => {
              this.applyByColorEnum(Color.White, 'Color.White');
            })
        }
        .width('100%')

        Button('ColorMetrics')
          .width('100%')
          .height(34)
          .fontSize(12)
          .onClick(() => {
            this.applyByColorMetrics();
          })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      .borderRadius(12)
    }
    .width('100%')
    .height('100%')
    .padding(12)
  }

}
