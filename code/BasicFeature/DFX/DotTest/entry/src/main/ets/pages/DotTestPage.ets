/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import hiAppEvent from '@ohos.hiAppEvent'
import prompt from '@ohos.prompt'
import Logger from '../model/Logger'

const TAG = 'DotTestPage'

@Entry
@Component
struct DotTestPage {
  @State contentText: Resource = $r('app.string.initContentText')
  @State isOn: boolean = false

  private writeEvent() {
    hiAppEvent.write('test_event', hiAppEvent.EventType.STATISTIC, {
      'int_data': 100, 'str_data': 'strValue'
    }, (err, value) => {
      if (err) {
        Logger.error(TAG, `failed to write event because ${err.code}`)
        this.contentText = $r('app.string.writeFailed')
        return
      }
      prompt.showToast({
        message: 'success to write event'
      })
      this.contentText = $r('app.string.writeSuccess')
      Logger.info(TAG, `success to write event: ${value}`)
    })
  }

  private changeEvent(isOn: boolean) {
    this.isOn = isOn
    if (isOn) {
      hiAppEvent.configure({
        disable: isOn
      })
      this.contentText = $r('app.string.appDisabled')
    } else {
      hiAppEvent.configure({
        disable: isOn
      })
      this.contentText = $r('app.string.appAble')
    }
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.appName'))
          .fontSize('20vp')
          .fontColor(Color.White)
      }
      .width('100%')
      .height('10%')
      .backgroundColor($r('app.color.title_bgColor'))
      .padding({ left: '10vp' })
      .alignItems(VerticalAlign.Center)

      Column() {
        Row() {
          Text(this.contentText)
            .fontSize('15vp')
            .margin({ left: '4vp' })
        }.width('400vp').height('200vp')
        .border({
          width: '2vp',
        })
        .margin({ bottom: '10vp' })

        Button($r('app.string.event')).width('150vp').height('50vp')
          .fontSize('16vp')
          .onClick(() => {
            this.writeEvent()
          })
      }.width('100%').height('40%')
      .justifyContent(FlexAlign.Center)

      Row() {
        Text($r('app.string.disable')).fontSize('16vp')
        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .selectedColor($r('app.color.toggle_selectedColor'))
          .switchPointColor($r('app.color.toggle_switchPointColor'))
          .onChange((isOn: boolean) => {
            this.changeEvent(isOn)
          })
      }.width('100%').height('10%')
      .backgroundColor($r('app.color.operation_bgColor')).justifyContent(FlexAlign.SpaceAround)
    }.width('100%').height('100%')
  }
}
