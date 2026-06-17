import { AVScreenCaptureDemo } from './AVScreenCaptureDemo';

@Entry({ routeName: 'Scene6' })
@Component
export struct Scene6 {
  @State isCapturing: boolean = false;
  @Consume('pageInfos') pageInfos: NavPathStack;
  private avScreenCaptureDemo: AVScreenCaptureDemo = new AVScreenCaptureDemo();

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Column() {
          Text('ArkTS录屏存文件')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('20%')

        Column() {
          List({ space: 40 }) {
            ListItem() {
              Button($r('app.string.start_desc'), { type: ButtonType.Circle, stateEffect: true })
                .backgroundColor(0xF55A42)
                .width(90)
                .height(90)
                .onClick(() => {
                  this.avScreenCaptureDemo.startRecording(this.getUIContext().getHostContext()!);
                  this.isCapturing = true;
                })
            }
            ListItem() {
              Button($r('app.string.stop_desc'), { type: ButtonType.Normal, stateEffect: true })
                .backgroundColor(0x000000)
                .width(85)
                .height(85)
                .shadow({ radius: 10 })
                .onClick(() => {
                  if (this.isCapturing) {
                    this.avScreenCaptureDemo.stopRecording();
                    this.isCapturing = false;
                  }
                })
            }
          }.listDirection(Axis.Horizontal).lanes({ minLength: 200, maxLength: 300 })
        }
        .width('100%')
        .height('20%')

        Column() {
        }
        .width('100%')
        .height('20%')
      }
      .width('100%')
    }
    .title('ArkTS录屏存文件')
  }
}
