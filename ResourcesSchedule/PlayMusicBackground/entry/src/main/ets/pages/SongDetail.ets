/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

let localTag: string = 'SongDetail'
let playStatus = AppStorage.Link('playStatus')

@Entry
@Component
struct SongDetail {
  private context: any = getContext(this)
  private playerModel = PlayerModel.getPlayerModelInstance()
  private name: string = router.getParams()['name'].toString()
  @AppStorage.Link('playStatus') playStatus: boolean = false
  @State private playing: boolean = playStatus

  build() {
    Column() {
      Image($r('app.media.ic_back'))
        .width(20)
        .height(20)
        .margin({ left: 16 })
        .position({ x: 10, y: 10 })
        .onClick(() => {
          router.back()
        })
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center }) {
        Text(this.name.toString())
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.pic_album'))
          .width('50%')
          .height('50%')
        if (!this.playing || this.playerModel.playingSong != this.name) {
          Image($r('app.media.ic_play'))
            .width(50)
            .height(50)
            .onClick(() => {
              this.playing = !this.playing
              this.playerModel.play(0, true, this.context)
              Logger.debug(localTag + ' click play butter')
            })
        } else {
          Image($r('app.media.ic_pause'))
            .width(50)
            .height(50)
            .onClick(() => {
              this.playing = !this.playing
              this.playerModel.pause(this.context)
              Logger.debug(localTag + ' click pause butter')
            })
        }
      }
      .width('100%')
      .height('90%')
    }
  }
}