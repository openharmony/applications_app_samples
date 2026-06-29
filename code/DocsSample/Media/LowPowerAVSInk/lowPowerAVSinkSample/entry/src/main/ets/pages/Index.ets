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

import { fileIo } from '@kit.CoreFileKit';
import { display, promptAction, router, window } from '@kit.ArkUI';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import player from 'libplayer.so';
import Logger from '../common/utils/Logger';
import { CommonConstants as Const } from '../common/CommonConstants';
import picker from '@ohos.file.picker'
import { common } from '@kit.AbilityKit';

const TAG: string = 'Sample_Player'
const PLAY_STATUS = ['initial', 'selected', 'prepared', 'ready', 'playing', 'pausing']


@Entry
@Component
struct Player {
  private surfaceId1: string = '';
  private surfaceId2: string = '';
  @StorageProp('topRectHeight')
  topRectHeight: number = 0;
  @State duration:string = '--:--:--'
  @State progress:string = '--:--:--'
  @State progressBarNumber:number = 0;
  @State surfaceWidth:string = '100%'
  @State surfaceHeight:string = '400'
  @State speedMode:number = 1.0;
  @State playStatus:string = 'initial';
  @State isPausing:boolean = false;
  @State xComponentStatus:Visibility = Visibility.Visible;
  @State controlStatus:Visibility = Visibility.Hidden;
  @State surfaceId:string = '1';
  private intervalId:number = -1;
  private showIntervalId:number = -1;
  private selectFilePath: string | null = null;
  private sourcePath: string[] = ['从文件管理选取', '从图库选取']
  private durationTime:number = 0;
  private progressTime:number = 0;
  private volume:number = 100;
  private touchX:number = -1;
  private seekMode:number = 0;
  private xComponentController: XComponentController = new XComponentController();
  private xComponentController2: XComponentController = new XComponentController();
  private scroller = new Scroller()
  private operationRet:number = 0;
  private seekFlag:number = 0;
  private context = this.getUIContext().getHostContext() as common.AbilityStageContext;

  selectFile() {
    this.getUIContext().showTextPickerDialog({
      range: this.sourcePath,
      canLoop: false,
      selected: 0,
      onAccept: (value: TextPickerResult) => {
        clearInterval(this.intervalId);
        switch (value.value) {
          case '从文件管理选取':
            this.selectDocFile()
            break
          case '从图库选取':
            this.selectAlbumFile()
            break
          default:
            this.selectAlbumFile()
            break
        }
      }
    })
  }

  selectDocFile() {
    let documentSelectOptions = new picker.DocumentSelectOptions
    let documentViewPicker = new picker.DocumentViewPicker
    documentViewPicker.select(documentSelectOptions)
      .then((documentSelectResult) => {
        this.selectFilePath = documentSelectResult[0]
        if (this.selectFilePath == null) {
          this.getUIContext().getPromptAction().showToast({
            message: $r('app.string.alert'),
            duration: Const.DURATION,
            bottom: Const.BOTTOM
          });
        } else {
          this.play();
          Logger.info(TAG, 'documentViewPicker.select to file succeed and URI is:' + this.selectFilePath);
        }
      })
  }

  selectAlbumFile() {
    try {
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select({
        
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE,
        maxSelectNumber: 1
      })
        .then((photoSelectResult) => {
          this.selectFilePath = photoSelectResult.photoUris[0];
          if (this.selectFilePath == null) {
            this.getUIContext().getPromptAction().showToast({
              message: $r('app.string.alert'),
              duration: Const.DURATION,
              bottom: Const.BOTTOM
            });
          } else {
            this.play();
            Logger.info(TAG, 'documentViewPicker.select to file succeed and URI is:' + this.selectFilePath);
          }
        })
    } catch (err) {
      Logger.error(TAG, 'Failed to select photo. Error: ' + JSON.stringify(err));
    }
  }

  formatDuration(durationInMicroseconds: number): string {
    const totalSeconds = Math.floor(durationInMicroseconds / 1000000);
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const seconds = totalSeconds % 60;
    return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
  }


  play() {
    try {
      let inputFile = fileIo.openSync(this.selectFilePath, fileIo.OpenMode.READ_ONLY);
      if (!inputFile) {
        Logger.error(TAG, 'player inputFile is null');
      }
      let inputFileState = fileIo.statSync(inputFile.fd);
      if (inputFileState.size <= 0) {
        Logger.error(TAG, 'player inputFile size is 0');
      }
      player.playNative(inputFile.fd, Const.DEFAULT_VALUE, inputFileState.size,
        () => {
          Logger.info(TAG, 'player JSCallback');
          fileIo.close(inputFile);
        },
        () => {
          Logger.info(TAG, 'audio JSCallback');
          player.pauseNative();
          this.playStatus = 'pausing';
        })
    } catch (err) {
      Logger.error(TAG, 'Failed to play file. Error: ' + JSON.stringify(err));
      return;
    }
    this.playStatus = 'selected';
  }

  playTest() {
    try {
      let filesDir = this.context.resourceDir;
      Logger.info(TAG, 'documentViewPicker.select to file succeed and URI is2:' + filesDir);
      let inputFile = fileIo.openSync(filesDir + '/fuzztest.mp4', fileIo.OpenMode.READ_ONLY);
      Logger.info(TAG, 'documentViewPicker.select to file succeed and URI is2:' + inputFile);
      if (!inputFile) {
        return;
      }
      let inputFileState = fileIo.statSync(inputFile.fd);
      if (inputFileState.size <= 0) {
        return;
      }
      player.playNative(inputFile.fd, Const.DEFAULT_VALUE, inputFileState.size,
        () => {
          Logger.info(TAG, 'player JSCallback');
          fileIo.close(inputFile);
        },
        () => {
          Logger.info(TAG, 'audio JSCallback');
          player.pauseNative();
          this.playStatus = 'pausing';
        })
      player.prepareNative();
      player.startDecoderNative();
      setTimeout(() => {
        player.renderFirstFrameNative();
        player.startRenderNative();
        player.startAudioNative();
        this.playStatus = 'playing'
      }, 300);
    } catch (err) {
      Logger.error(TAG, 'Failed to playTest file. Error: ' + JSON.stringify(err));
      return;
    }
  }


  updateProgress(progressTime:number){
    this.progressTime = progressTime;
    this.progress = this.formatDuration(this.progressTime);
    this.progressBarNumber = 260*(this.progressTime/this.durationTime);
  }

  onPageShow() {
    player.resumeNative();
  }

  onPageHide() {
    player.pauseNative();
  }
  setOrientation(flag: boolean) {
    try {
      if (this.surfaceHeight == '400') {
        window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
          win.setPreferredOrientation(window.Orientation.LANDSCAPE);
          this.surfaceHeight = '100%';
        })
      } else {
        window.getLastWindow(this.getUIContext().getHostContext()).then((win) => {
          win.setPreferredOrientation(window.Orientation.PORTRAIT);
          this.surfaceHeight = '400';
        })
      }
    } catch (err) {
      Logger.error(TAG, 'Failed to setOrientation. Error: ' + JSON.stringify(err));
      return;
    }
  }


  build() {
    Scroll(this.scroller) {
      Column() {
        Row() {
          XComponent({
            id: 'player',
            type: XComponentType.SURFACE,
            libraryname: 'player',
            controller: this.xComponentController
          })
            .height(Const.FULL_SIZE)
            .width(Const.FULL_SIZE)
            .visibility(this.surfaceId == "1" ? this.xComponentStatus : Visibility.None)
            .onLoad(() => {
              this.surfaceId1 = this.xComponentController.getXComponentSurfaceId();
            })
          XComponent({
            id: 'player2',
            type: XComponentType.SURFACE,
            libraryname: 'player',
            controller: this.xComponentController2
          })
            .height(Const.FULL_SIZE)
            .width(Const.FULL_SIZE)
            .visibility(this.surfaceId == "2" ? this.xComponentStatus : Visibility.None)
            .onLoad(() => {
              this.surfaceId2 = this.xComponentController2.getXComponentSurfaceId();
            })
          Text(this.surfaceId)
            .height(18)
            .fontSize(25)
            .fontColor("white")
            .position({ "left": 20, "bottom": 20 })
            .onClick(() => {
              if (this.surfaceId == "1") {
                player.setSurfaceNative(this.surfaceId2);
                this.surfaceId = "2";
              } else {
                player.setSurfaceNative(this.surfaceId1);
                this.surfaceId = "1";
              }
            })
          Image($r("app.media.full"))
            .height(18)
            .position({ "right": 10, "bottom": 10 })
            .visibility(this.controlStatus)
            .onClick(() => {
              this.setOrientation(true);
            })
        }
        .id("screen")
        .width(this.surfaceWidth)
        .height(this.surfaceHeight)
        
        .onTouch((event: TouchEvent) => {
          const type: TouchType = event.type;
          if (type == TouchType.Down) {
            const x: number = event.touches[0].x;
            this.touchX = x;
          }
          if (type == TouchType.Up) {
            const x: number = event.touches[0].x;
            if (x > this.touchX) {
              let seekTime = this.progressTime / 1000 + 10000
              if (seekTime > this.durationTime / 1000) {
                seekTime = this.durationTime / 1000;
              }
              player.seekNative(seekTime, this.seekMode, false);
            } else if (x < this.touchX) {
              let seekTime = this.progressTime / 1000 - 10000
              if (seekTime < 0) {
                seekTime = 0;
              }
              player.seekNative(seekTime, this.seekMode, false);
            }
          }
        })
        .onClick(() => {
          clearInterval(this.showIntervalId);
          this.showIntervalId = -1;
          if (this.playStatus == "playing" || this.playStatus == 'pausing') {
            this.controlStatus = Visibility.Visible;
            this.showIntervalId = setTimeout(() => {
              this.controlStatus = Visibility.Hidden;
            }, 3000)
          }
        })

        Row() {
          Row() {
          }
          .width(260)
          .height(8)
          .backgroundColor('white')
          .position({ left: 6, top: 12 })
          .onTouch((event: TouchEvent) => {
            const type: TouchType = event.type;
            if (type == TouchType.Move) {
              const x: number = event.touches[0].x;
              clearInterval(this.intervalId);
              this.intervalId = -1;
              this.progressTime = Math.floor(this.durationTime * (x / 260))
              this.progress = this.formatDuration(this.progressTime);
              this.progressBarNumber = Math.floor(260 * (this.progressTime / this.durationTime));
            }
            if (type == TouchType.Up) {
              const x: number = event.touches[0].x;
              const seekTime = Math.floor(this.durationTime * (x / 260) / 1000)
              player.seekNative(seekTime, this.seekMode, false);
              if (this.intervalId == -1) {
                this.intervalId = setInterval(() => {
                  this.progressTime = player.getProgressTime();
                  this.progress = this.formatDuration(this.progressTime);
                  this.progressBarNumber = Math.floor(260 * (this.progressTime / this.durationTime));
                }, 500);
              }
            }
          })

          Row() {
          }
          .id('Slider')
          .width(this.progressBarNumber)
          .height(8)
          .backgroundColor('red')
          .position({ left: 4, top: 12 })
          .onTouch((event: TouchEvent) => {
            const type: TouchType = event.type;
            if (type == TouchType.Move) {
              const x: number = event.touches[0].x;
              clearInterval(this.intervalId);
              this.intervalId = -1;
              this.progressTime = Math.floor(this.durationTime * (x / 260))
              this.progress = this.formatDuration(this.progressTime);
              this.progressBarNumber = Math.floor(260 * (this.progressTime / this.durationTime));
            }
            if (type == TouchType.Up) {
              const x: number = event.touches[0].x;
              const seekTime = Math.floor(this.durationTime * (x / 260) / 1000)
              player.seekNative(seekTime, this.seekMode, false);
              if (this.intervalId == -1) {
                this.intervalId = setInterval(() => {
                  this.progressTime = player.getProgressTime();
                  this.progress = this.formatDuration(this.progressTime);
                  this.progressBarNumber = Math.floor(260 * (this.progressTime / this.durationTime));
                }, 500);
              }
            }
          })

          Text(this.progress + "/" + this.duration) {
          }
          .align(Alignment.End)
          .fontSize(12)
          .fontColor("white")
          .position({ right: 4, top: 8 })
        }
        .width("100%")
        .height("30")
        .backgroundColor('black')
        .margin({ top: 20 })

        Row() {
          Row() {
            Text("0.5x") {
            }
            .fontColor(this.speedMode == 0.5 ? 'red' : 'white')
            .margin({ left: 20 })
            .fontSize(18)
            .onClick(() => {
              if (!(this.playStatus == 'playing')) {
                return;
              }
              player.speedNative(0.5);
              this.speedMode = 0.5;
            })

            Text("1x") {
            }
            .fontColor(this.speedMode == 1.0 ? 'red' : 'white')
            .margin({ left: 20 })
            .fontSize(18)
            .onClick(() => {
              if (!(this.playStatus == 'playing')) {
                return;
              }
              player.speedNative(1.0);
              this.speedMode = 1.0;
            })

            Text("2x") {
            }
            .fontColor(this.speedMode == 2.0 ? 'red' : 'white')
            .margin({ left: 20 })
            .fontSize(18)
            .onClick(() => {
              if (!(this.playStatus == 'playing')) {
                return;
              }
              player.speedNative(2.0);
              this.speedMode = 2.0;
            })

            Text("4x") {
            }
            .fontColor(this.speedMode == 4.0 ? 'red' : 'white')
            .margin({ left: 20 })
            .fontSize(18)
            .onClick(() => {
              if (!(this.playStatus == 'playing')) {
                return;
              }
              player.speedNative(4.0);
              this.speedMode = 4.0;
            })
          }
          .width("70%")
          .height("100%")

          Row() {
            Button('选择视频')
              .onClick(() => {
                this.selectFile();
              })
              .width('90%')
              .height("80%")
              .backgroundColor('#FF4500')
          }
          .width("30%")
          .height("100%")
        }
        .width("100%")
        .height("30")
        .backgroundColor('black')
        .margin({ top: 20 })

        Row() {
          Column() {
            Button('准备')
              .enabled(this.playStatus == 'selected')
              .onClick(() => {
                player.prepareNative();
                this.playStatus = 'prepared'
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Button('解码')
              .enabled(this.playStatus == 'prepared')
              .onClick(() => {
                player.startDecoderNative();
                this.durationTime = player.getDurationTime();
                this.duration = this.formatDuration(this.durationTime);
                this.playStatus = 'ready'
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Button('首帧')
              .enabled(this.playStatus == 'prepared' || this.playStatus == 'ready')
              .onClick(() => {
                player.renderFirstFrameNative();
                this.durationTime = player.getDurationTime();
                this.duration = this.formatDuration(this.durationTime);
                
                this.playStatus = 'ready'
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Select([
              { value: '视频' },
              { value: '音频' },
              { value: '音视频' },
            ])
              .value('播放')
              .controlSize(ControlSize.SMALL)
              .enabled(this.playStatus == 'ready')
              .backgroundColor('#FF4500')
              .onSelect((index: number, text?: string | undefined) => {
                console.info('Select:' + index)
                
                if (index === 0) {
                  player.startRenderNative()
                } else if (index === 1) {
                  player.startAudioNative()
                } else if (index === 2) {
                  player.startRenderNative()
                  player.startAudioNative()
                }
                this.intervalId = setInterval(() => {
                  this.progressTime = player.getProgressTime();
                  this.progress = this.formatDuration(this.progressTime);
                  this.progressBarNumber = Math.floor(260 * (this.progressTime / this.durationTime));
                }, 300);
                this.playStatus = 'playing'
              })
          }
          .width('25%')
          .height('100%')
        }
        .width("100%")
        .height("30")
        .margin({ top: 20 })

        Row() {
          Column() {
            Button(this.playStatus == 'pausing' ? '继续' : '暂停')
              .enabled(this.playStatus == 'playing' || this.playStatus == 'pausing')
              .id('Pause')
              .onClick(() => {
                if (this.playStatus == 'pausing') {
                  setTimeout(() => {
                    player.resumeNative();
                    this.playStatus = 'playing';
                  }, 0)
                } else if (this.playStatus == 'playing') {
                  setTimeout(() => {
                    player.pauseNative();
                    this.playStatus = 'pausing'
                  }, 0)
                }
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Button('重置')
              .enabled(this.playStatus == 'playing' || this.playStatus == 'pausing')
              .id('Reset')
              .onClick(() => {
                
                player.resetNative();
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Button('释放')
              .enabled(this.playStatus == 'playing' || this.playStatus == 'pausing')
              .id('Release')
              .onClick(() => {
                
                player.releaseNative();
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Button('停止')
              .enabled(this.playStatus == 'playing' || this.playStatus == 'pausing')
              .onClick(() => {
                player.stopNative();
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')
        }
        .width("100%")
        .height("30")
        .margin({ top: 20 })

        Row() {
          Column() {
            Button('音量-')
              .enabled(this.playStatus == 'playing' || this.playStatus == 'pausing')
              .onClick(() => {
                this.volume = this.volume - 10;
                if (this.volume <= 0) {
                  this.volume = 0;
                }
                player.setVolumeNative(this.volume / 100);
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Button('音量+')
              .enabled(this.playStatus == 'playing' || this.playStatus == 'pausing')
              .onClick(() => {
                this.volume = this.volume + 10;
                if (this.volume >= 100) {
                  this.volume = 100;
                }
                player.setVolumeNative(this.volume / 100);
              })
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')

          Column() {
            Select([
              { value: '前向关键帧' },
              { value: '后向关键帧' },
              { value: '最近关键帧' },
            ])
              .value('前向关键帧')
              .controlSize(ControlSize.SMALL)
              .backgroundColor('#FF4500')
              .onSelect((index: number, text?: string | undefined) => {
                console.info('Select:' + index)
                if (index === 0) {
                  this.seekMode = 1; //前向
                } else if (index === 1) {
                  this.seekMode = 0; //后向
                } else if (index === 2) {
                  this.seekMode = 2; //最近
                }
              })
          }
          .width('25%')
          .height('100%')
          Column() {
            Button('启动播放')
              .onClick(() => {
                this.playTest();
              })
              .id('Start')
              .width('80%')
              .height("80%")
              .backgroundColor('#FF4500')
              .margin({ top: 3 })
          }
          .width('25%')
          .height('100%')
        }
        .width("100%")
        .height("30")
        .margin({ top: 20 })
      }
    }
    
    .width('100%')
    .height('100%')
    .padding({top: this.getUIContext().px2vp(this.topRectHeight)})
  }
}