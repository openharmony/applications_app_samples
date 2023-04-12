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

import prompt from '@ohos.prompt'
import CommonEvent from '@ohos.commonEvent'
import MissionItem from '../components/MissionItem'
import MissionInfo from '../bean/MisssionInfo'
import MissionModel from '../model/MissionModel'
import { EventConstants, Logger, MyDataSource } from '@ohos/base'


const TAG: string = 'RecentsLayout'
const SUBSCRIBER_INFO = {
  events: [
    EventConstants.EVENT_ENTER_RECENTS
  ]
}
const MISSION_OPERATE = {
  CHANGE_LOCK: 0,
  CLEAR: 1
}

@Component
export struct RecentsLayout {
  @State missionInfos: Array<MissionInfo> = new Array<MissionInfo>()
  @State showEmptyMessage: boolean = false
  private subscriber = undefined
  private missionsData: MyDataSource = new MyDataSource([])

  async aboutToAppear() {
    await this.refreshMissionInfos()
    this.subscriber = await CommonEvent.createSubscriber(SUBSCRIBER_INFO)
    CommonEvent.subscribe(this.subscriber, this.refreshMissionInfos.bind(this))
  }

  async refreshMissionInfos() {
    let context = getContext(this)
    this.missionInfos = await MissionModel.getMissionInfos(context)
    Logger.info(TAG, `refreshRecentsData end,result = ${this.missionInfos.length}`)
    this.missionsData['dataArray'] = this.missionInfos
    this.missionsData.notifyDataReload()
    if (this.missionInfos.length > 0) {
      this.showEmptyMessage = false
    } else {
      this.showEmptyMessage = true
    }
  }

  handleOperateMission = async (index: number, operate: number) => {
    Logger.info(TAG, `handleOperateMission, index=${index}, operate=${operate}`);
    this.missionInfos = this.missionsData['dataArray'];
    this.missionsData['dataArray'] = [];
    this.missionsData.notifyDataReload();
    if (this.missionInfos[index]) {
      if (operate === MISSION_OPERATE.CHANGE_LOCK) {
        if (this.missionInfos[index].lockedState) {
          await  MissionModel.unLockMission(this.missionInfos[index].missionId);
        } else {
          await MissionModel.lockMission(this.missionInfos[index].missionId);
        }
      } else {
        await  MissionModel.clearMission(this.missionInfos[index].missionId);
      }
    }
    setTimeout(() => {
      CommonEvent.publish(EventConstants.EVENT_ENTER_RECENTS, () => {
        Logger.info(TAG, `enter recents`);
      })
    }, 20)
  }

  async clearAllMissions() {
    await MissionModel.clearAllMission()
    CommonEvent.publish(EventConstants.EVENT_CLEAR_RECENTS, () => {
      Logger.info(TAG, `clearAllMission,then exit recents`)
    })
  }

  build() {
    Column() {
      if (this.showEmptyMessage) {
        Text($r('app.string.message_no_mission'))
          .fontSize(20)
          .fontColor(Color.White)
          .alignSelf(ItemAlign.Center)
      } else {
        List({ space: 16 }) {
          LazyForEach(this.missionsData, (item, index) => {
            ListItem() {
              MissionItem({ missionInfo: item, index: index, operateMission: this.handleOperateMission })
            }
          }, item => item.appName)
        }
        .listDirection(Axis.Horizontal)
        .height('60%')
        .width('100%')

        Image($r("app.media.ic_delete"))
          .width(45)
          .height(45)
          .objectFit(ImageFit.Contain)
          .margin({ top: 20 })
          .padding(5)
          .borderRadius(25)
          .backgroundColor('#77F5F5F5')
          .onClick(this.clearAllMissions)
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      CommonEvent.publish(EventConstants.EVENT_ENTER_HOME, () => {
        Logger.info(TAG, `exit recents`)
      })
    })
  }
}