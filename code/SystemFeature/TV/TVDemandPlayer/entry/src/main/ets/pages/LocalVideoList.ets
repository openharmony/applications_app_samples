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
/* eslint-disable */
import { router, promptAction as prompt } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { initInfo, ComEvent } from '@ohos/utilslibrary';
import { UrlType, UrlList } from '../const/Type';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { EventUtil } from '../utils/EventUtil';
import { Constants } from '../const/Constants';
let log = initInfo('LocalVideoList.ets');

let events = [
  'usual.event.data.VOLUME_BAD_REMOVAL',
]

interface CommonEventErr {
  code: number;
  message: string;
  name: string;
}

@Entry
@Component
struct LocalVideoList {
  subscriber: ComEvent | null = null;
  private scroller: Scroller = new Scroller();
  @State focusId: number = 0;
  @StorageLink('screen_lpx_w') screenW: number = AppStorage.get<number>('screen_lpx_w') || 1280;
  @StorageLink('screen_lpx_h') screenH: number = AppStorage.get<number>('screen_lpx_h') || 720;
  @StorageLink('screen_dpi') dpi: number = AppStorage.get<number>('screen_dpi') || 2;
  @StorageLink('screen_lpi') lpi: number = AppStorage.get<number>('screen_lpi') || 1.5;
  @StorageLink('screen_px_w') pageW: number = AppStorage.get<number>('screen_px_w') || 1920;
  @StorageLink('screen_px_h') pageH: number = AppStorage.get<number>('screen_px_h') || 1080;
  @StorageLink('local_video_list') videoList: Array<UrlType> = AppStorage.get<Array<UrlType>>('local_video_list') || [];
  @State videoName: string = ''
  private clickNow:number = 0;
  private isNavigating: boolean = false;
  aboutToAppear() {
    this.setVideoList();
  }

  aboutToDisappear() {
    if (this.subscriber) {
      this.subscriber.unsubscribe(() => {
        this.subscriber = null;
      })
    }
  }

  onPageShow() {
    this.isNavigating = false;
    this.setVideoList();
    this.initFocus()
    this.subscriber = new ComEvent(events, (err: CommonEventErr, data: Record<string, string>) => {
      log(`usb event`);
      if (err.code) {
        log(`subscribe failed err: ${JSON.stringify(err)}`);
      } else {
        log(`subscribe data: ${JSON.stringify(data.event)}`);
        router.back({
          url: 'pages/LocalFolderList'
        })
        prompt.showToast({
          message: 'U盘被移除',
          duration: 2000,
          bottom: `${px2vp(this.pageH - 300) / 2}`
        })
      }
    })
  }

  onPageHide() {
    if (this.subscriber) {
      this.subscriber.unsubscribe(() => {
        this.subscriber = null;
      })
    }
  }

  initFocus() {
    let len = this.videoList.length;
    if (len > 0) {
      if (this.focusId < -1 || this.focusId > (len - 1)) {
        this.focusId = 0;
      }
      focusControl.requestFocus(`${this.focusId}`)
      this.videoName = this.videoList[this.focusId].displayName as string
    }
  }

  setVideoList() {
    let urlList: UrlList[] = [];
    this.videoList.forEach((t: UrlType) => {
      try {
        let fileUrl = (t.uri?.startsWith('rawfile')) ? t.uri
          : 'fd://' + fs.openSync(t.uri, fs.OpenMode.READ_ONLY).fd
        urlList.push({
          uri: t.uri || '',
          url: fileUrl as string,
          type: 'local',
          displayName: t.displayName as string,
          defResolution: '720P',
          deviceType: t.deviceType as number,
          resolutions: []
        })
      } catch (e) {
        console.error('setVideoList',JSON.stringify(e))
      }
    })
    AppStorage.setOrCreate<Array<UrlList>>('video_list', urlList)
  }

  videoOnFocus(data: UrlType, ind: number) {
    this.videoName = data.displayName as string
  }

  // 播放视频
  playVideo(data: UrlType, ind: number) {
    if (this.isNavigating) {
      return;
    }
    this.isNavigating = true;
    globalThis.videoIndex = ind;
    try {
      router.push({
        url: 'pages/VideoPlayer'
      })
    } catch (e) {
      this.isNavigating = false;
      log(`playVideo router.push error: ${JSON.stringify(e)}`);
    }
  }

  build() {
    Row() {
      Column() {
        Text('视频列表')
          .fontSize('40lpx')
          .width('100%')
          .height('90lpx')
          .fontColor('#ffd6d6d6')
          .padding({ left: '30lpx', bottom: '48lpx' })
          .margin({ top: '25lpx' })
        Row() {
          List({ space: '24lpx' }) {
            ForEach(this.videoList, (item: UrlType, ind) => {
              ListItem() {
                Stack({ alignContent: Alignment.Center }) {
                  Row() {
                    Text(`${ind + 1}`)
                      .fontSize(ind == this.focusId ? '24lpx' : '22lpx')
                      .textAlign(TextAlign.Center)
                      .fontColor(ind == this.focusId ? '#1e1e1f' : '#e5e5e5')
                      .width('60lpx')
                      .height('40lpx')
                    Text(String(item.displayName).length > 15 ? String(item.displayName).slice(0, 15) + '...' :
                    item.displayName)
                      .fontSize(ind == this.focusId ? '26lpx' : '24lpx')
                      .textAlign(TextAlign.Start)
                      .width('410lpx')
                      .height('40lpx')
                      .maxLines(1)
                      .fontColor(ind == this.focusId ? '#1e1e1f' : '#e5e5e5')
                  }
                  .width(ind == this.focusId ? '490lpx' : '480lpx')
                  .height(ind == this.focusId ? '60lpx' : '50lpx')
                  .borderWidth('1lpx')
                  .borderRadius(globalThis.lpiPx(12))
                  .borderStyle(BorderStyle.Solid)
                  .borderColor('#464648')
                  .backgroundColor(ind == this.focusId ? '#dededf' : '#464648')
                  .alignItems(VerticalAlign.Center)
                  .justifyContent(FlexAlign.Center)
                  .zIndex(1)

                  Text('')
                    .zIndex(2)
                    .textAlign(TextAlign.Center)
                    .width(`500lpx`)
                    .height('70lpx')
                    .focusable(true)
                    .focusOnTouch(true)
                    .defaultFocus(ind == this.focusId)
                    .key(`${ind}`)
                    .id(`${ind}`)
                    .onFocus(() => {
                      this.focusId = ind;
                      log(`onFocus focusId:${ind}`);
                      this.videoOnFocus(item, ind);
                    })
                    .onKeyEvent((e) => {
                      let len = this.videoList.length;
                      if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
                        if (this.focusId > 0) {
                          this.focusId--;
                        }
                      }

                      if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                        if (this.focusId < len - 1) {
                          this.focusId++;
                        }
                      }
                    })
                    .onHover(() => {
                      this.focusId = ind;
                      this.videoOnFocus(item, ind);
                    })
                    .onClick(()=>{
                      //节流处理
                      if ((Date.now()-this.clickNow)<800){
                        return
                      }
                      this.clickNow = Date.now();
                      console.log('===start',this.clickNow)
                      this.playVideo(item, ind);
                    })
                }
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.Transparent
                    })
                  }
                })
                .width(ind == this.focusId ? '500lpx' : '490lpx')
                .height(ind == this.focusId ? '70lpx' : '60lpx')
                .borderWidth('2lpx')
                .borderRadius(globalThis.lpiPx(16))
                .backgroundColor(ind == this.focusId ? '#18181A' : '#464648')
                .borderColor(ind == this.focusId ? '#dededf' : '#464648')
              }.width('100%')
            })
          }
          .scrollBar(BarState.Off)
          .height(`${this.screenH - 140}lpx`)
          .width('510lpx')
          .align(Alignment.Top)
        }
        .height(`${this.screenH - 140}lpx`)
        .width('100%')
        .padding({ left: '20lpx', right: '20lpx', bottom: '20lpx' })
      }
      .padding('10lpx')
      .width('600lpx')
      .height('100%')
      .focusable(true)
      .onFocus(() => {
        log(`page onFocus`);
      })
      .onAppear(() => {
        log(`page onAppear`);
      })
      .onKeyEvent(e => {
        if (e.keyCode == KeyCode.KEYCODE_F24) {
          return;
        }

        if (e.keyCode == KeyCode.KEYCODE_B && e.type == KeyType.Up) {
          router.back();
        }
        log(`keyCode:${e.keyCode}, keyType:${e.type}`);
      })

      Column() {
        Image($rawfile('ic_video_back.svg'))
          .width('200lpx')
          .objectFit(ImageFit.Contain)
          .aspectRatio(1)
        Text(this.videoName)
          .fontColor('rgba(255, 255, 255, 0.2)')
          .fontSize('36lpx')
          .margin({
            top: '24lpx'
          })
      }
      .width('50%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }.backgroundColor('#18181A')
    .width('100%')
  }
}