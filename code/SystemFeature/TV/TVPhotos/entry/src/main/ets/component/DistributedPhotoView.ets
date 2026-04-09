/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { distributedDeviceManager } from "@kit.DistributedServiceKit";
import Logger from "../common/Logger";
import { dfsManager } from "../manager/DfsManager";
import { PhotoModel } from "../models/PhotoModel";
import { rdbManager } from "../manager/RdbManager";
import { router } from "@kit.ArkUI";
import { KeyCode } from "@kit.InputKit";
import { VideoImage } from "../pages/components/VideoImage";
import { Constants } from "../common/Constants";
import { Util } from "../common/Util";
import { EventUtil } from "../common/EventUtil";
import { getToVideoApp, isAppInstalled } from "../pages/Index";

const TAG = 'DistributedPhotoView';
const GRID_ROW_COUNT: number = 6;
const FOCUS_DEFAULT = -1

@Component
export struct DistributedPhotoView {
  @Link focusStr: string;
  @State photoList: PhotoModel[] = [];
  @State availableDeviceList: distributedDeviceManager.DeviceBasicInfo[] = [];
  @State onLineDeviceList: distributedDeviceManager.DeviceBasicInfo[] = [];
  @State isConnected: boolean = true;
  private gridScroller: Scroller = new Scroller();
  @State isFocus: number = FOCUS_DEFAULT

  changeFocusToId(str: string) {
    this.focusStr = str;
    AppStorage.setOrCreate<string>('focusStr', str);
    focusControl.requestFocus(str);
  }

  async aboutToAppear(): Promise<void> {
    dfsManager.init();
    rdbManager.registerRemoteDataChange((storeObserver: Array<string>) => {
      Logger.error(TAG, `remote data change`);
      this.loadPhotoList(this.availableDeviceList[0]);
    });
    let isLogin = await dfsManager.checkAccountLogin();
    if (!isLogin) {
      // 未登录，重新登录
      isLogin = await dfsManager.accountLogin();
    }
    if (isLogin) {
      this.availableDeviceList = dfsManager.getAvailableDevices();
      if (this.availableDeviceList.length > 0) {
        let ret = await dfsManager.connectDfs(this.availableDeviceList[0]);
        if (ret === true) {
          this.loadPhotoList(this.availableDeviceList[0]);
        }
      } else {
        this.isConnected = false;
      }
    } else {
      this.isConnected = false;
    }
  }

  aboutToDisappear(): void {
    rdbManager.unregisterRemoteDataChange();
  }

  onPageShow(): void {
    if (!this.isConnected && dfsManager.isConnected()) {
      this.isConnected = true;
      if (dfsManager.connectedDevice) {
        this.loadPhotoList(dfsManager.connectedDevice);
      }
    }
  }

  toPhotoWatch(index: number) {
    let item = this.photoList[index];
    if (item && item.photoType === Constants.PHOTO_TYPE_VIDEO) {
      if (isAppInstalled()) {
        getToVideoApp(item.uri, item.displayName, item.thumbnail);
      }
    } else {
      router.pushUrl({
        url: 'pages/PhotoWatch',
        params: {
          photoIndex: index,
          photoList: this.photoList,
          isFromRemote: true
        }
      })
    }
  }

  toDfsDevicePage() {
    router.pushUrl({
      url: 'pages/DistributedDevicePage'
    })
  }

  async loadPhotoList(device: distributedDeviceManager.DeviceBasicInfo) {
    let list = await rdbManager.queryDfsPhotoData(device.networkId ?? '');
    if (list) {
      this.photoList = list;
    }
    Logger.info(TAG, `loadPhotoList success , data = ${JSON.stringify(list)}`);
  }

  onPhotoKeyEvent(event: KeyEvent, index: number) {
    if (event.type == KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_UP && this.isFocus<6) {
      this.isFocus = FOCUS_DEFAULT
      this.changeFocusToId('menu2');
      return;
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_DOWN && event.type === KeyType.Down) {
      let nextIndex = index + GRID_ROW_COUNT;
      this.gridScroller.scrollToIndex(nextIndex, true, ScrollAlign.AUTO);
      this.changeFocusToId('dfs_photo_' + nextIndex);
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
      if (index / GRID_ROW_COUNT === 0) {
        this.changeFocusToId('menu2');
        return;
      }
      let nextIndex = index - GRID_ROW_COUNT;
      this.gridScroller.scrollToIndex(nextIndex, true, ScrollAlign.AUTO);
      this.changeFocusToId('dfs_photo_' + nextIndex);
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_LEFT && event.type === KeyType.Down) {
      if (index === 0) {
        return;
      }
      let nextIndex = index - 1;
      this.gridScroller.scrollToIndex(nextIndex, true, ScrollAlign.AUTO);
      this.changeFocusToId('dfs_photo_' + nextIndex);
    }
    if (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT && event.type === KeyType.Down) {
      if (index === this.photoList.length - 1) {
        return;
      }
      let nextIndex = index + 1;
      this.gridScroller.scrollToIndex(nextIndex, true, ScrollAlign.AUTO);
      this.changeFocusToId('dfs_photo_' + nextIndex);
    }
    if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER || event.keyCode === KeyCode.KEYCODE_ENTER) &&
      event.type === KeyType.Down) {
      this.toPhotoWatch(index);
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.isConnected) {
        Grid(this.gridScroller) {
          ForEach(this.photoList, (item: PhotoModel, index: number) => {
            GridItem() {
              Stack() {
                VideoImage({
                  isDistributed: true,
                  photoModel: item,
                  focusId: 'dfs_photo_' + index,
                  eventCallback: (event) => {
                    this.onPhotoKeyEvent(event, index);
                  }
                })
                  .width('100%')
                Row() {
                  // 缩略图左下角视频时长
                  Text(item != null && item.photoType == Constants.PHOTO_TYPE_VIDEO ?
                  Util.getFormattedDuration(Number(item.duration)) : '')
                    .fontSize('24lpx')
                    .fontFamily('HarmonyOS Sans')
                    .fontColor('#DBFFFFFF')
                    .lineHeight('28lpx')
                    .margin({ left: '8%', bottom: '4%' })
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .align(Alignment.BottomStart)
              }
              .align(Alignment.BottomEnd)
              .borderRadius("22lpx")
              .margin("24lpx")
              .padding("6lpx")
              .border({
                width: '2lpx',
                color: this.isFocus == index ? '#fff' : Color.Transparent, // 边框颜色
                style: BorderStyle.Solid
              })
            }
            .onFocus(() => {
              this.isFocus = index
            })
          }, (item: PhotoModel) => JSON.stringify(item))
        }
        .columnsTemplate('1fr '.repeat(GRID_ROW_COUNT))
        .padding({ left: "4lpx", right: "4lpx" })
        .width('100%')
      } else {
        Column() {
          Text($r('app.string.distributed_device_empty_tip'))
            .fontSize('36lpx')
            .fontColor('#ffffffff')

          Column() {
            Text($r('app.string.distributed_device_go_to'))
              .id('to_dfs_manage')
              .fontFamily("HarmonyOS Sans")
              .fontSize("36lpx")
              .fontWeight(500)
              .textAlign(TextAlign.Center)
              .fontColor('#FF000000')
              .borderRadius("78lpx")
              .backgroundColor('#FFD8D8D8')
              .focusable(true)
              .width('246lpx')
              .height('74lpx')
              .onKeyEvent(event => {
                if ((event.keyCode === KeyCode.KEYCODE_DPAD_CENTER || event.keyCode === KeyCode.KEYCODE_ENTER) &&
                  event.type === KeyType.Down) {
                  // this.toDfsDevicePage();
                }
                if (event.keyCode === KeyCode.KEYCODE_DPAD_UP && event.type === KeyType.Down) {
                  this.changeFocusToId('menu2');
                }
              })
              .onClick(()=>{
                this.toDfsDevicePage();
              })
              .onTouch((event) => {
                if (!EventUtil.isTouchEvent(event)) {
                  return;
                }
                this.toDfsDevicePage();
              })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .borderRadius("78lpx")
          .padding("8lpx")
          .margin({
            top: '92lpx'
          })
          .border({
            width: '2lpx',
            color: this.focusStr == 'to_dfs_manage' ? '#fff' : Color.Transparent,
            style: BorderStyle.Solid
          })
        }.margin({
          top: '220lpx'
        })
      }
    }.width('100%').height('100%')
  }
}