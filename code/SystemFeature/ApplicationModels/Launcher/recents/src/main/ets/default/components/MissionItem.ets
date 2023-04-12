/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import image from '@ohos.multimedia.image'
import CommonEvent from '@ohos.commonEvent'
import MissionInfo from '../bean/MisssionInfo'
import MissionModel from '../model/MissionModel'
import { EventConstants, LauncherAbilityManager, Logger, ResourceManager } from '@ohos/base'


const TAG: string = 'MissionItem'
const MISSION_OPERATE = {
  CHANGE_LOCK: 0,
  CLEAR: 1
}

@Component
export default struct MissionItem {
  private index: number = -1
  private operateMission: (index: number, operate: number) => void
  private missionInfo: MissionInfo | undefined = undefined
  private context: any = undefined
  @State snapShot: image.PixelMap | undefined = undefined
  @State icon: string = ''
  @State translateY: number = 0

  aboutToAppear() {
    this.context = getContext(this)
    this.updateData()
  }

  async updateData() {
    this.snapShot = await MissionModel.getSnapShot(this.missionInfo.missionId)
    ResourceManager.getInstance(this.context)
      .getAppIconWithCache(this.missionInfo.appIconId, this.missionInfo.bundleName, this.iconLoadCallback, '')
  }

  iconLoadCallback = (image: string) => {
    this.icon = image
  }

  build() {
    Column() {
      Row() {
        Image(this.icon)
          .size({ width: 35, height: 35 })
          .objectFit(ImageFit.Contain)
        Text(this.missionInfo.appName)
          .fontSize(17)
          .fontColor(Color.White)
          .margin({ left: 10 })
          .constraintSize({ maxWidth: 100 })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Blank()
        if (this.missionInfo.lockedState) {
          Image($r('app.media.ic_public_lock'))
            .size({ width: 25, height: 25 })
            .objectFit(ImageFit.Contain)
        }
      }
      .width(200)
      .padding({ left: 5, right: 5 })

      Image(this.snapShot)
        .width('100%')
        .height('80%')
        .objectFit(ImageFit.Fill)
        .margin({ top: 10 })
        .borderRadius(16)
    }
    .width(200)
    .height('100%')
    .translate({ y: this.translateY })
    .onClick(() => {
      CommonEvent.publish(EventConstants.EVENT_ENTER_HOME, () => {
        Logger.info(TAG, `exit recents`)
      })
      setTimeout(() => {
        LauncherAbilityManager.getInstance(this.context)
          .startLauncherAbility(this.missionInfo.abilityName, this.missionInfo.bundleName)
      }, 100)
    })
    .gesture(
    SwipeGesture({ fingers: 1, direction: SwipeDirection.Vertical })
      .onAction((event: GestureEvent) => {
        Logger.debug(TAG, `SwipeGesture event.angle=${event.angle}`)
        if (event.angle > 5) {
          this.operateMission(this.index, MISSION_OPERATE.CHANGE_LOCK)
        } else if (event.angle < -5) {
          this.operateMission(this.index, MISSION_OPERATE.CLEAR)
        }
      })
    )
  }
}