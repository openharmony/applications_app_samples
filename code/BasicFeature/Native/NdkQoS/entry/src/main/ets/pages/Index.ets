import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';

@Entry
@Component
struct Index {
  @State message: string = 'QoS Sample';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        Button('High level QoS test', {type: ButtonType.Normal})
          .margin({top: 50})
          .height('6%')
          .width('50%')
          .borderRadius(8)
          .fontWeight(FontWeight.Bold)
          .backgroundColor('#aabbcc')
          .onClick(() => {
            let ret: string = testNapi.useHighQos().toString();
            AlertDialog.show({
              title: this.message,
              message: "High-level QoS calculation time: " + ret + " ms",
              alignment: DialogAlignment.Center,
              confirm: {
                value: "OK",
                action: () => {
                  console.log("High-QoS done")
                }
              }
            })
          })

        Button('Low level QoS test', {type: ButtonType.Normal})
          .margin({top: 50})
          .height('6%')
          .borderRadius(8)
          .width('50%')
          .backgroundColor('#aabbcc')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let ret: string = testNapi.useLowQos().toString();
            AlertDialog.show({
              title: this.message,
              message: "Low-level QoS calculation time: " + ret + " ms",
              alignment: DialogAlignment.Center,
              confirm: {
                value: "OK",
                action: () => {
                  console.log("Low-QoS done")
                }
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
