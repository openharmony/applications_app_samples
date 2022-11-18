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

import PreferencesStore from '../../utils/Preferences'
import { SYNC_STATE } from '@ohos/common'

@Extend(Column) function columnStyle () {
  .width('100%')
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
  .margin(12)
  .backgroundColor(Color.White)
  .borderRadius(24)
}

@Extend(Text) function introductionStyle () {
  .fontColor(Color.Black)
  .fontSize(18)
  .margin({ top: 4 })
  .width('100%')
  .opacity(0.8)
}

@Preview
@Component
export default struct SettingsContent {
  @State syncState: string = SYNC_STATE.OVERWRITE_CONTACT_ASSISTANT

  build() {
    Scroll() {
      Column() {
        Text($r('app.string.synchronization_policy'))
          .fontSize(18)
          .margin({ top: 24 })
          .width('100%')
        Column() {
          Row() {
            Text($r('app.string.deduplication'))
              .fontSize(18)
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.syncState === SYNC_STATE.DEDUPLICATION })
              .onChange((isOn: boolean) => {
                this.setSyncState(SYNC_STATE.DEDUPLICATION)
                this.syncState = SYNC_STATE.DEDUPLICATION
              })
          }
          .width('100%')

          Text($r('app.string.deduplication_instruction'))
            .introductionStyle()
        }
        .columnStyle()

        Column() {
          Row() {
            Text($r('app.string.overwrite_contact'))
              .fontSize(18)
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.syncState === SYNC_STATE.OVERWRITE_CONTACT })
              .onChange((isOn: boolean) => {
                this.setSyncState(SYNC_STATE.OVERWRITE_CONTACT)
                this.syncState = SYNC_STATE.OVERWRITE_CONTACT
              })
          }
          .width('100%')

          Text($r('app.string.overwrite_contact_instruction'))
            .introductionStyle()
        }
        .columnStyle()

        Column() {
          Row() {
            Text($r('app.string.overwrite_contact_assistant'))
              .fontSize(18)
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.syncState === SYNC_STATE.OVERWRITE_CONTACT_ASSISTANT })
              .onChange((isOn: boolean) => {
                this.setSyncState(SYNC_STATE.OVERWRITE_CONTACT_ASSISTANT)
                this.syncState = SYNC_STATE.OVERWRITE_CONTACT_ASSISTANT
              })
          }
          .width('100%')

          Text($r('app.string.overwrite_contact_assistant_instruction'))
            .introductionStyle()
        }
        .columnStyle()

      }
      .margin({ top: $r('app.float.page_space_12') })
    }
    .width('100%')
    .layoutWeight(1)
    .padding({ left: $r('app.float.page_space_24'), right: $r('app.float.page_space_24') })
    .backgroundColor($r('app.color.page_background'))
  }

  aboutToAppear() {
    this.getSyncState()
  }

  getSyncState = async () => {
    this.syncState = <string> await PreferencesStore.get('syncState', SYNC_STATE.OVERWRITE_CONTACT_ASSISTANT)
  }

  async setSyncState(state: string) {
    await PreferencesStore.put('syncState', state)
  }
}