// xxx.ets
import { curves } from '@kit.ArkUI';

@Entry
@Component
struct motionBlurTest {
  @State widthSize: number = 400;
  @State heightSize: number = 320;
  @State flag: boolean = true;
  @State radius: number = 0;
  @State x: number = 0;
  @State y: number = 0;

  build() {
    Column() {
      Column() {
        Image($r('app.media.testImg'))
          .width(this.widthSize)
          .height(this.heightSize)
          .onClick(() => {
            this.radius = 5;
            this.x = 0.5;
            this.y = 0.5;
            if (this.flag) {
              this.widthSize = 100;
              this.heightSize = 80;
            } else {
              this.widthSize = 400;
              this.heightSize = 320;
            }
            this.flag = !this.flag;
          })
          .animation({
            duration: 2000,
            curve: curves.springCurve(10, 1, 228, 30),
            onFinish: () => {
              this.radius = 0;
            }
          })
          .motionBlur({ radius: this.radius, anchor: { x: this.x, y: this.y } })
      }
    }.width('100%').margin({ top: 5 })
  }
}