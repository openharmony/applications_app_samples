
import audioSuiteNapi from 'libentry.so';
import { common } from '@kit.AbilityKit'
import { fileIo as fs } from '@kit.CoreFileKit';


@Entry
@Component
struct Index {
  @State message: string = 'Ready';
  @State napiReturnLog: string = '暂无返回信息'; //
  @State isPlay: boolean = false;

  // 更新NAPI返回信息
  updateNapiLog(msg: string) {
    const timestamp = new Date().toLocaleTimeString();
    this.napiReturnLog = `[${timestamp}]\n${msg}`;
  }

  aboutToAppear() {
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let value = context.resourceManager.getRawFileContentSync("S16LE_2_48000.pcm");
    let myBuffer: ArrayBufferLike = value?.buffer;
    let filePath = context.filesDir + "/" + "S16LE_2_48000.pcm";
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, myBuffer);
    fs.closeSync(file);
  }


  build() {
    NavDestination() {
      Scroll() {
        Column() {
          // 信息显示区域
          Column() {
            Text('实时状态信息')
              .fontSize(18)
              .fontWeight(600)
              .margin({ bottom: 12 })

            // 当前状态
            Column() {
              Text('当前状态')
                .fontSize(14)
                .fontWeight(600)
                .margin({ bottom: 8 })
              Text(this.message)
                .fontSize(14)
                .fontColor('#007DFF')
                .width('100%')
                .padding(10)
                .backgroundColor('#F0F0F0')
                .borderRadius(8)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 12 })

            // NAPI返回信息
            Column() {
              Text('NAPI返回信息')
                .fontSize(14)
                .fontWeight(600)
                .margin({ bottom: 8 })
              Scroll() {
                Text(this.napiReturnLog)
                  .fontSize(12)
                  .fontColor('#52C41A')
                  .width('100%')
                  .padding(10)
                  .backgroundColor('#F0F0F0')
                  .borderRadius(8)
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 创建播放流按钮
          Button('播放音频')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .enabled(!this.isPlay)
            .onClick(async () => {
              try {
                this.isPlay = true;
                let result = await audioSuiteNapi.CreateAudioRender(1);
                this.message = '播放原始音频成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '播放原始音频失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })
          Button('播放加均衡器效果后音频')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .enabled(!this.isPlay)
            .onClick(async () => {
              try {
                this.isPlay = true;
                let result = await audioSuiteNapi.CreateAudioRender(2);
                this.message = '播放加均衡器效果后音频成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '播放加均衡器效果后音频失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })
          // 销毁播放流按钮
          Button('停止播放')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .enabled(this.isPlay)
            .onClick(async () => {
              try {
                this.isPlay = false;
                let result = await audioSuiteNapi.DestroyAudioRender();
                this.message = '停止播放成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '停止播放失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('添加默认均衡器效果')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                let result = await audioSuiteNapi.BaseEditor();
                this.message = '添加默认均衡器效果成功';
                this.updateNapiLog(result);
              } catch (err) {
                this.message = '添加默认均衡器效果失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })

          Button('音源分离')
            .width('90%')
            .height(30)
            .margin({ bottom: 12 })
            .onClick(async () => {
              try {
                // let result = await audioSuiteNapi.registcallback2();
                this.message = '音源分离成功';
                // this.updateNapiLog(result);
              } catch (err) {
                this.message = '音源分离失败';
                this.updateNapiLog('错误: ' + JSON.stringify(err));
              }
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F1F3F5')
      }
      .width('100%')
      .height('100%')
    }
  }
}