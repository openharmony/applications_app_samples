import { window } from '@kit.ArkUI';
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

  aboutToAppear(): void {
    this.applyWindowBackgroundColor();
  }

  private toHex(value: number): string {
    return Math.round(value).toString(16).padStart(2, '0').toUpperCase();
  }

  private getColorValue(): string {
    return `#${this.toHex(this.alpha)}${this.toHex(this.red)}${this.toHex(this.green)}${this.toHex(this.blue)}`;
  }

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

  @Builder
  private buildColorSlider(title: string, value: number, onChange: (value: number) => void) {
    Column({ space: 8 }) {
      Row() {
        Text(title)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .width(36)

        Text(`${Math.round(value)}`)
          .fontSize(16)
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
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(18)
  }

  build() {
    Column({ space: 16 }) {
      Column({ space: 10 }) {
        Text('当前窗口背景色：')
          .fontSize(18)
          .fontColor('#666666')
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.getColorValue())
          .fontSize(34)
          .fontWeight(FontWeight.Bold)
          .width('100%')
          .textAlign(TextAlign.Start)

        Text(this.statusText)
          .fontSize(13)
          .fontColor('#666666')
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding(20)
      .backgroundColor('#F3F3F3')
      .borderRadius(24)

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

    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F7F1E8')
  }
}
