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
/*本地存储 和 USB存储目录*/
import { promptAction as prompt } from '@kit.ArkUI';
import mediaLibrary from '@ohos.file.photoAccessHelper';
import { router } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { secToStr, isVideoFile } from '../utils/Utils'
import { ComEvent, initInfo } from '@ohos/utilslibrary';
import { UrlType, DataType, ImgType, FoldListType, ArrayType } from '../const/Type';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { EventUtil } from '../utils/EventUtil';
import { promptAction } from '@kit.ArkUI';
import { Constants } from '../const/Constants';
import { MessageEvents, worker } from '@kit.ArkTS';
import { fileAccess, fileExtensionInfo, userFileManager } from '@kit.CoreFileKit';
import { dataSharePredicates } from '@kit.ArkData';

let log = initInfo('LocalFolderList.ets');

type AllType = UrlType[]

interface folderList {
  id: string,
  name: string,
  num: number,
  videoList: Array<UrlType>
}

let events = [
  'usual.event.data.VOLUME_MOUNTED',
  'usual.event.data.VOLUME_BAD_REMOVAL',
]

interface videoType {
  uri?: string,
  url?: string,
  displayName?: string | Resource,
  createTime?: string,
  type?: string,
  defResolution?: string,
  deviceType?: number
}

interface urlListType {
  uri?: string,
  url?: string,
  type?: string,
  displayName?: string | Resource,
  defResolution?: string,
  deviceType?: number
}

interface CommonEventErr {
  code: number;
  message: string;
  name: string;
}

@Entry
@Component
@Preview
struct LocalFolderList {
  subscriber: ComEvent | null = null;
  private scroller: Scroller = new Scroller();
  private mediaLibrary = mediaLibrary.getPhotoAccessHelper(getContext());
  private workerInstance = new worker.ThreadWorker('../workers/Worker.ets');
  @State isLoading: boolean = false;
  @State folderList: Array<folderList> = [
    {
      id: 'f_1',
      name: '本地视频',
      num: 0,
      videoList: []
    },
    {
      id: 'f_3',
      name: 'USB设备',
      num: 0,
      videoList: []
    }
  ];
  @State focusId: number = 0;
  @StorageLink('screen_lpx_w') screenW: number = AppStorage.Get<number>('screen_lpx_w') || 1280;
  @StorageLink('screen_lpx_h') screenH: number = AppStorage.Get<number>('screen_lpx_h') || 720;
  @StorageLink('screen_px_w') pageW: number = AppStorage.Get<number>('screen_px_w') || 1920;
  @StorageLink('screen_px_h') pageH: number = AppStorage.Get<number>('screen_px_h') || 1080;
  @State videoList: Array<videoType> = [];
  @State hasScan: boolean = false
  @State isUSBEnable: boolean = false;
  aboutToAppear(): void {
    this.workerInstance.postMessage({'key':'context',value: getContext()});
  }
  onPageShow() {
    this.workerInstance.onmessage = (e: MessageEvents) => {
      if (e.data.key == 'folderList'){
        this.folderList = e.data.value;
      }else if(e.data.key == 'initFocus'){
        this.initFocus()
      } else if(e.data.key == 'isLoading'){
        this.isLoading = e.data.value;
      }else if(e.data.key == 'isUSBEnable'){
        this.isUSBEnable = e.data.value;
      }else if(e.data.key == 'folderListSplice'){
        this.folderList.splice(1, 1, e.data.value)
      }
    }
    fileAccess.getFileAccessAbilityInfo((err, wants) => {
      console.log('HmLog-->getFileAccessAbilityInfo', JSON.stringify(wants));
    })
    if (this.hasScan) {
      return
    }
    this.workerInstance.postMessage({'key':'getLocalVideos'});

    this.userFileManagerMedia()
    this.subscriber = new ComEvent(events, (err: CommonEventErr, data: Record<string, string>) => {
      log(`usb event`);
      if (err != null && err.code) {
        log(`subscribe failed err: ${JSON.stringify(err)}`);
      } else {
        log(`subscribe data: ${JSON.stringify(data.event)}`);
        let msg = '';
        if (data.event == 'usual.event.data.VOLUME_MOUNTED') {
          msg = 'U盘已挂载'
          this.isUSBEnable = true;
        } else {
          msg = 'U盘被移除'
          this.isUSBEnable = false;
          this.folderList[1] = {
            id: 'f_3',
            name: 'USB设备',
            num: 0,
            videoList: []
          }
        }
        this.workerInstance.postMessage({'key':'getLocalVideos'});

        if (msg) {
          prompt.showToast({
            message: msg,
            duration: 2000,
            bottom: `${px2vp(this.pageH - 300) / 2}`
          })
        }
      }
    })
    this.hasScan = true
  }

  initFocus() {
    let len = this.folderList.length;
    if (len > 0) {
      if (this.focusId < 0 || this.focusId > (len - 1) || !this.folderList[this.focusId] ||
        this.folderList[this.focusId].num == 0) {
        this.focusId = 0;
      }
    }
  }

  aboutToDisappear() {
    if (this.subscriber) {
      this.subscriber.unsubscribe(() => {
        this.subscriber = null;
      })
    }
    if (this.workerInstance){
      this.workerInstance.terminate()
    }
  }

  onPageHide() {
    if (this.subscriber) {
      this.subscriber.unsubscribe(() => {
        this.subscriber = null;
      })
    }
  }

  isFile(mode: number) {
    return (mode & fileExtensionInfo.DocumentFlag.REPRESENTS_FILE) == fileExtensionInfo.DocumentFlag.REPRESENTS_FILE;
  }

  // 获取视频文件入口
  async userFileManagerMedia() {
    const context = getContext(this);
    let mgr = userFileManager.getUserFileMgr(context);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: [],
      predicates: predicates
    };
    try {
      let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset> = await mgr.getPhotoAssets(fetchOptions);
      if (fetchResult != undefined) {
        let videos: videoType[] = [];
        let count = await fetchResult.getCount();
        for (let i = 0; i < count; i++) {
          let fileAsset: userFileManager.FileAsset = await fetchResult.getPositionObject(i);
          if (fileAsset != undefined && fileAsset.fileType == 2) {
            videos.push({
              uri: fileAsset.uri,
              url: fileAsset.uri,
              displayName: fileAsset.displayName,
              createTime: '',
              type: 'local',
              defResolution: '720P',
              deviceType: 1
            })
          }
        }
        let obj: folderList = {
          id: this.folderList[0].id,
          name: this.folderList[0].name,
          num: videos.length,
          videoList: videos
        };
        this.folderList.splice(0, 1, obj)
        this.videoList = videos;
        this.setVideoList();

      }
    } catch (err) {
      this.isLoading = false;
      log('getPhotoAssets failed, message = ', err);
    }
  }

  setVideoList() {
    let urlList: urlListType[] = [];
    this.videoList.forEach(t => {
      urlList.push({
        uri: t.uri || '',
        url: t.url,
        type: 'local',
        displayName: t.displayName,
        defResolution: '720P',
        deviceType: t.deviceType
      })
    })
    AppStorage.SetOrCreate<Array<urlListType>>('video_list', urlList)
    console.log('HmLog-->setVideoList', `${urlList}`);
  }

  build() {
    Stack() {
      Column() {
        Text('本地点播')
          .fontSize('40lpx')
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .height('90lpx')
          .fontColor('#ffffffff')
          .margin({ bottom: '20lpx', left: '80lpx', top: '10lpx' })
          .focusable(true)
          .defaultFocus(true)
          .stateStyles({
            focused: {
              .border({
                color: Color.Transparent
              })
            }
          })

        Row({ space: '50lpx' }) {
          ForEach(this.folderList, (item: FoldListType, ind) => {
            Column() {
              Row() {
                Stack({ alignContent: Alignment.Center }) {
                  Image(ind == 0 ? $rawfile('ic_local_dianbo.svg') :
                    item.num == 0 ? $rawfile('ic_no_usb.svg') : $rawfile('ic_usb.svg'))
                    .borderRadius(globalThis.lpiPx(18))
                    .width('286lpx')
                    .height('156lpx')
                    .objectFit(ImageFit.Cover)
                    .clip(true)
                  Column({ space: '10lpx' }) {
                    Text(item.name)
                      .fontSize('24lpx')
                      .textAlign(TextAlign.Start)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#FFFFFF')
                    Text(`共${item.num}条视频`)
                      .fontSize('20lpx')
                      .textAlign(TextAlign.Start)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#FFFFFF')
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width('300lpx')
                  .height('30lpx')
                  .position({
                    x: '24lpx',
                    y: '24lpx'
                  })

                  Text('')
                    .width('100%')
                    .height('100%')
                    .focusable(ind == 0 ? true : item.num > 0 ? true : false)
                    .focusOnTouch(true)
                    .defaultFocus(ind === this.focusId)
                    .key(`${ind}`)
                    .id(`${ind}`)
                    .onFocus(() => {
                      log(`onFocus focusId:${ind}`);
                      this.focusId = ind;
                    })
                    .zIndex(2)
                }
                .width('300lpx')
                .height('170lpx')
                .borderWidth('2lpx')
                .borderRadius(globalThis.lpiPx(22))
                .borderStyle(BorderStyle.Solid)
                .borderColor(ind == this.focusId ? '#ffffffff' : '#004f5a65')
              }
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .height('248lpx')
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
            }
            .onHover(() => {
              setTimeout(() => {
                this.focusId = ind;
              }, 100)
            })
            .onClick(() => {
              this.focusId = ind;
              let num = this.folderList[this.focusId].num;
              let videoList = this.folderList[this.focusId].videoList;
              if (!this.isUSBEnable) {
                if (this.focusId === 1) {
                  promptAction.showToast({
                    message: '无外部存储！',
                    duration: 2000,
                    bottom: `${px2vp(this.pageH - 300) / 2}`
                  })
                }
              }
              if (this.isLoading || num == 0) {
                return;
              }
              globalThis.localVideoList = videoList;
              AppStorage.SetOrCreate<Array<UrlType>>('local_video_list', videoList);
              setTimeout(() => {
                router.push({
                  url: 'pages/LocalVideoList'
                })
              }, 100)
            })
          })
        }
        .width('100%')
        .translate({ y: '-40lpx' })
        .margin({ left: '80lpx' })
      }
      .width('100%')
      .height('100%')
      .zIndex(1)
      .focusable(true)
      .onFocus(() => {
      })
      .onKeyEvent(e => {
        if (e.keyCode == KeyCode.KEYCODE_F24) {
          return;
        }
        let len = this.folderList.length;
        if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
          if (this.focusId > 0) {
            this.focusId--;
          }
        }
        if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
          if (this.focusId < len - 1) {
            this.focusId++;
          }
        }
        if (e.keyCode == KeyCode.KEYCODE_ENTER && e.type == KeyType.Up) {
          let num = this.folderList[this.focusId].num;
          let videoList = this.folderList[this.focusId].videoList;
          if (!this.isUSBEnable) {
            if (this.focusId === 1) {
              promptAction.showToast({
                message: '无外部存储！',
                duration: 2000,
                bottom: `${px2vp(this.pageH - 300) / 2}`
              })
            }
          }
          if (this.isLoading || num == 0) {
            return;
          }
          globalThis.localVideoList = videoList;
          AppStorage.SetOrCreate<Array<UrlType>>('local_video_list', videoList);
          setTimeout(() => {
            router.push({
              url: 'pages/LocalVideoList'
            })
          }, 100)
        }
        if (e.keyCode == KeyCode.KEYCODE_B && e.type == KeyType.Up) {
          router.back();
        }
      })

      Column() {
        LoadingProgress().color('#ffffff').width('120lpx').height('100lpx')
        Text(`本地视频扫描中...`)
          .fontSize('16lpx')
          .fontColor('#ffffff')
      }
      .padding('10lpx')
      .backgroundColor('#4d000000')
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .zIndex(2)
      .visibility(this.isLoading ? Visibility.Visible : Visibility.None)
    }
    .backgroundColor('#18181A')
    .width('100%')
    .height('100%')
  }
}
