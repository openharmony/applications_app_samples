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

import { Logger } from '../controller/Logger'

import router from '@ohos.router'
import PlayerModel from '../controller/PlayerModel'
import { PlayList } from '../controller/PlayerModel'

let localTag: string = 'Main'

@Component
struct AllSongList {
  private playList: PlayList
  private playerModel: PlayerModel

  pushSongDetailPage(name, path) {
    router.push({
      url: 'pages/SongDetail',
      params: {
        name: name,
        path: path
      }
    })
  }

  build() {
    List({ space: 10, initialIndex: 0 }) {
      ListItem() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
          Text('Songs')
            .width('33%')
            .fontSize(16)
            .backgroundColor('#AFEEEE')
            .textAlign(TextAlign.Center)
          Text('Local')
            .width('33%')
            .fontSize(16)
            .backgroundColor('#AFEEEE')
            .textAlign(TextAlign.Center)
          Text('duration')
            .width('33%')
            .fontSize(16)
            .backgroundColor('#AFEEEE')
            .textAlign(TextAlign.Center)
        }
      }

      ForEach(this.playList.audioFiles, (item) => {
        ListItem() {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
            Text(item.name)
              .width('30%')
              .fontSize(16)
              .backgroundColor('#F5DEB3')
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.playerModel.preloadSong(item.name, getContext(this))
                this.pushSongDetailPage(item.name, item.fileUri)
                Logger.debug(localTag + ' click from Main jump to SongDetail')
              })
            Text(item.fileUri)
              .width('40%')
              .fontSize(16)
              .backgroundColor('#F5DEB3')
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.playerModel.preloadSong(item.name, getContext(this))
                this.pushSongDetailPage(item.name, item.fileUri)
                Logger.debug(localTag + ' click from Main jump to SongDetail')
              })
            Text('' + item.duration)
              .width('30%')
              .fontSize(16)
              .backgroundColor('#F5DEB3')
              .textAlign(TextAlign.Center)
              .onClick(() => {
                this.playerModel.preloadSong(item.name, getContext(this))
                this.pushSongDetailPage(item.name, item.fileUri)
                Logger.debug(localTag + ' click from Main jump to SongDetail')
              })
          }
        }
      }, (item) => item.name)
    }
  }
}


@Entry
@Component
struct Main {
  private playerModel = PlayerModel.getPlayerModelInstance()

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        Column() {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start }) {
            Image($r('app.media.Blueberry'))
              .margin({ left: 6, right: 6 })
              .height(200)
              .width(200)
            Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
              Text('name')
                .fontSize(16)
                .flexGrow(1)
                .margin({ left: 50, top: 40 })
              Text('VIP')
                .fontSize(16)
                .flexGrow(2)
                .margin({ left: 50, bottom: 40 })
            }
          }
          .height(200)
          .width('100%')
          .backgroundColor('#AFEEEE')

          Tabs() {
            TabContent() {
              AllSongList({ playList: this.playerModel.playList, playerModel: this.playerModel })
            }
            .tabBar('Local Music').onClick(() => {
            })

            TabContent() {
            }
            .tabBar('Album')

            TabContent() {
            }
            .tabBar('Favourite')
          }
        }
        .width('100%')
      }.tabBar('My')

      TabContent() {
      }.tabBar('Concern')

      TabContent() {
      }.tabBar('Update')
    }
    .scrollable(true)
  }
}