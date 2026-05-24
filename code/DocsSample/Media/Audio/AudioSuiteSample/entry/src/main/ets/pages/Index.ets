/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 */
import audioSuiteNapi from 'libentry.so';
import { common } from '@kit.AbilityKit'
import { fileIo as fs } from '@kit.CoreFileKit';


@Entry
@Component
struct Index {
  @State message: string = 'Ready';
  @State napiReturnLog: string = '暂无返回信息'; //
  @State isPlay: boolean = false;
  @State isReal: boolean = false;
  // Loading 状态
  @State isLoadingBaseEditor: boolean = false;
  @State isLoadingAudioSourceSeparation: boolean = false;
  @State isLoadingMixingAndCascading: boolean = false;
  // 效果完成状态
  @State isBaseEditorCompleted: boolean = false;
  @State isAudioSourceSeparationCompleted: boolean = false;
  @State isMixingAndCascadingCompleted: boolean = false;

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
    Stack() {
      Column() {
        NavDestination() {
          Column() {
            // 信息显示区域 - 固定在顶部
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

            // 按钮区域 - 可滚动
            Scroll() {
              Column() {
                // 创建播放流按钮
                Button('播放音频')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(!this.isPlay)
                  .onClick(async () => {
                    try {
                      this.isPlay = true;
                      let result: string = await audioSuiteNapi.CreateAudioRender(1);
                      this.message = '播放原始音频成功';
                      this.updateNapiLog(result);
                    } catch (err) {
                      this.message = '播放原始音频失败';
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
                      let type: number = 1;
                      if (this.isReal) {
                        type = 2;
                        this.isReal = false;
                      }
                      let result: string = await audioSuiteNapi.DestroyAudioRender(type);
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
                  .onClick(() => {
                    try {
                      this.message = '正在添加均衡器效果...';
                      this.isLoadingBaseEditor = true;
                      audioSuiteNapi.BaseEditor((result: string) => {
                        this.isLoadingBaseEditor = false;
                        this.isBaseEditorCompleted = true;
                        this.message = '添加默认均衡器效果成功';
                        this.updateNapiLog(result);
                      });
                    } catch (err) {
                      this.isLoadingBaseEditor = false;
                      this.message = '添加默认均衡器效果失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('播放加均衡器效果后音频')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(!this.isPlay && this.isBaseEditorCompleted)
                  .onClick(async () => {
                    try {
                      this.isPlay = true;
                      let result: string = await audioSuiteNapi.CreateAudioRender(2);
                      this.message = '播放加均衡器效果后音频成功';
                      this.updateNapiLog(result);
                    } catch (err) {
                      this.message = '播放加均衡器效果后音频失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('音源分离')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .onClick(() => {
                    try {
                      this.message = '正在进行音源分离...';
                      this.isLoadingAudioSourceSeparation = true;
                      audioSuiteNapi.AudioSourceSeparationNapi((result: string) => {
                        this.isLoadingAudioSourceSeparation = false;
                        this.isAudioSourceSeparationCompleted = true;
                        this.message = '音源分离成功';
                        this.updateNapiLog(result);
                      });
                    } catch (err) {
                      this.isLoadingAudioSourceSeparation = false;
                      this.message = '音源分离失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('播放伴奏')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(!this.isPlay && this.isAudioSourceSeparationCompleted)
                  .onClick(async () => {
                    try {
                      this.isPlay = true;
                      let result: string = await audioSuiteNapi.CreateAudioRender(3);
                      this.message = '播放伴奏成功';
                      this.updateNapiLog(result);
                    } catch (err) {
                      this.message = '播放伴奏失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('播放人声')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(!this.isPlay && this.isAudioSourceSeparationCompleted)
                  .onClick(async () => {
                    try {
                      this.isPlay = true;
                      let result: string = await audioSuiteNapi.CreateAudioRender(4);
                      this.message = '播放人声成功';
                      this.updateNapiLog(result);
                    } catch (err) {
                      this.message = '播放人声失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('混音与级联')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(this.isAudioSourceSeparationCompleted)
                  .onClick(() => {
                    try {
                      this.message = '正在进行混音与级联...';
                      this.isLoadingMixingAndCascading = true;
                      audioSuiteNapi.MixingAndCascadingNapi((result: string) => {
                        this.isLoadingMixingAndCascading = false;
                        this.isMixingAndCascadingCompleted = true;
                        this.message = '混音与级联成功';
                        this.updateNapiLog(result);
                      });
                    } catch (err) {
                      this.isLoadingMixingAndCascading = false;
                      this.message = '混音与级联失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('播放混音')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(!this.isPlay && this.isMixingAndCascadingCompleted)
                  .onClick(async () => {
                    try {
                      this.isPlay = true;
                      let result: string = await audioSuiteNapi.CreateAudioRender(5);
                      this.message = '播放混音成功';
                      this.updateNapiLog(result);
                    } catch (err) {
                      this.message = '播放混音失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })

                Button('播放实时渲染')
                  .width('90%')
                  .height(30)
                  .margin({ bottom: 12 })
                  .enabled(!this.isPlay)
                  .onClick(async () => {
                    try {
                      this.isPlay = true;
                      this.isReal = true;
                      let result: string = await audioSuiteNapi.EqualizerEffectNapi();
                      this.message = '播放实时渲染成功';
                      this.updateNapiLog(result);
                    } catch (err) {
                      this.message = '播放实时渲染失败';
                      this.updateNapiLog('错误: ' + JSON.stringify(err));
                    }
                  })
              }
              .width('100%')
              .padding({ left: 16, right: 16 })
              .alignItems(HorizontalAlign.Center)
            }
            .width('100%')
            .layoutWeight(1)
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Auto)
            .edgeEffect(EdgeEffect.Spring)
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('100%')

        // Loading 遮罩层
        if (this.isLoadingBaseEditor || this.isLoadingAudioSourceSeparation || this.isLoadingMixingAndCascading) {
          Column() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#007DFF')
              .margin({ bottom: 12 })

            Text(this.isLoadingBaseEditor ? '正在添加均衡器效果...' :
              this.isLoadingAudioSourceSeparation ? '正在进行音源分离...' :
                this.isLoadingMixingAndCascading ? '正在进行混音与级联...' : '处理中...')
              .fontSize(16)
              .fontColor('#FFFFFF')
          }
          .width('100%')
          .height('100%')
          .position({ x: 0, y: 0 })
          .justifyContent(FlexAlign.Center)
          .backgroundColor('rgba(0, 0, 0, 0.6)')
          .zIndex(999)
        }

        // Loading 遮罩层
        if (this.isLoadingBaseEditor || this.isLoadingAudioSourceSeparation || this.isLoadingMixingAndCascading) {
          Column() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#007DFF')
              .margin({ bottom: 12 })

            Text(this.isLoadingBaseEditor ? '正在添加均衡器效果...' :
              this.isLoadingAudioSourceSeparation ? '正在进行音源分离...' :
                this.isLoadingMixingAndCascading ? '正在进行混音与级联...' : '处理中...')
              .fontSize(16)
              .fontColor('#FFFFFF')
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .backgroundColor('rgba(0, 0, 0, 0.6)')
        }
      }
      .width('100%')
      .height('100%')
    }
  }
}