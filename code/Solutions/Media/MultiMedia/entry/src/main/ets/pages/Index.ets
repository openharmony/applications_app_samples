/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import router from '@ohos.router';
import TitleBar from '../view/TitleBar';
import MediaUtils from '../model/MediaUtils';
import { MediaView } from '../view/MediaView';
import Logger from '../model/Logger';

@Observed
export default class Album {
  constructor(public albumName: string, public count: number, public mediaType?: mediaLibrary.MediaType) {
    this.albumName = albumName;
    this.count = count;
    this.mediaType = mediaType;
  }
}

@Entry
@Component
struct Index {
  private mediaUtils: MediaUtils = MediaUtils.getInstance(getContext(this))
  @State albums: Array<Album> = []
  @State selectIndex: number = 0
  @State operateVisible: boolean = false

  async onPageShow() {
    this.albums = [];
    this.albums = await this.mediaUtils.getAlbums();
  }

  @Builder OperateBtn(src, zIndex, translate, handleClick) {
    Button() {
      Image(src)
        .width('70%')
        .height('70%')
    }
    .type(ButtonType.Circle)
    .width('40%')
    .height('40%')
    .backgroundColor('#0D9FFB')
    .zIndex(zIndex)
    .translate({ x: translate.x, y: translate.y })
    .transition({ type: TransitionType.Insert, translate: { x: 0, y: 0 } })
    .transition({ type: TransitionType.Delete, opacity: 0 })
    .onClick(handleClick)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        TitleBar()
        List() {
          ForEach(this.albums, (item: Album, index) => {
            ListItem() {
              MediaView({ album: item })
                .id(`mediaType${index}`)
            }
          }, item => item.albumName)
        }
        .divider({ strokeWidth: 1, color: Color.Gray, startMargin: 16, endMargin: 16 })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')

      Stack({ alignContent: Alignment.Center }) {
        Button() {
          Image($r('app.media.add'))
            .width('100%')
            .height('100%')
        }
        .width(60)
        .height(60)
        .padding(10)
        .id('addBtn')
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .onClick(() => {
          animateTo({ duration: 500, curve: Curve.Ease }, () => {
            this.operateVisible = !this.operateVisible
          })
        })

        Button() {
          Image($r('app.media.icon_camera'))
            .id('camera')
            .width('100%')
            .height('100%')
        }
        .width(60)
        .height(60)
        .padding(10)
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .translate({ x: 0, y: -80 })
        .visibility(this.operateVisible ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.operateVisible = !this.operateVisible;
          let context: common.UIAbilityContext | undefined = AppStorage.Get('context');
          let want: Want = {
            bundleName: "com.samples.camera_page",
            abilityName: "EntryAbility",
          };
          context && context.startAbility(want,  (err) => {
            if (err.code) {
              Logger.error('StartAbility', `Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
            }
          });
        })

        Button() {
          Image($r('app.media.icon_record'))
            .id('record')
            .width('100%')
            .height('100%')
        }
        .width(60)
        .height(60)
        .padding(10)
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .translate({ x: -80, y: 0 })
        .visibility(this.operateVisible ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.operateVisible = !this.operateVisible
          router.push({ url: 'pages/RecordPage' })
        })

        Button() {
          Image($r('app.media.icon_document'))
            .width('100%')
            .height('100%')
        }
        .width(60)
        .height(60)
        .padding(10)
        .id('document')
        .type(ButtonType.Circle)
        .backgroundColor('#0D9FFB')
        .translate({ x: 0, y: 80 })
        .visibility(this.operateVisible ? Visibility.Visible : Visibility.None)
        .onClick(() => {
          this.operateVisible = !this.operateVisible
          router.pushUrl({ url: 'pages/DocumentPage' })
        })
      }
      .width(180)
      .height(220)
      .margin({ right: 40, bottom: 120 })
    }
    .width('100%')
    .height('100%')
  }

  aboutToDisappear() {
    this.mediaUtils.offDateChange()
  }
}