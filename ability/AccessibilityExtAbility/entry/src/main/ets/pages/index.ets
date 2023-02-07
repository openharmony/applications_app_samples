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

import accessibility from '@ohos.accessibility'
import ResourceUtils from '../utils/ResourceUtils'
import Logger from '../utils/Logger'

@Entry
@Component
struct Index {
  private context: Context = getContext(this)
  @State connectState: Resource = $r("app.string.state_unconnected")
  @State accessibilityTest: Resource = $r("app.string.accessibility_test")
  @State currentState: Resource = $r("app.string.current_state")
  @State buttonClickState: Resource = $r("app.string.accessibility_not_clicked")

  aboutToAppear(): void {
    Logger.info("Index aboutToAppear()")
    try {
      accessibility.isOpenAccessibility().then((data) => {
        console.info("Index success in isOpenAccessibility. data: " + JSON.stringify(data))
        this.connectState = data ? $r("app.string.state_connected") : $r("app.string.state_unconnected")
      }).catch((err) => {
        console.error("Index Failed to isOpenAccessibility. Cause: " + JSON.stringify(err))
      })
    } catch (error) {
      Logger.error("Index Failed to isOpenAccessibility. Cause: " + JSON.stringify(error))
    }
    try {
      accessibility.on("accessibilityStateChange", (data) => {
        this.connectState = data ? $r("app.string.state_connected") : $r("app.string.state_unconnected")
        Logger.info("Index Subscribe accessibility state change. Result: " + JSON.stringify(data))
      })
    } catch (error) {
      Logger.error("Index Failed to subscribe accessibility state change. Cause: " + JSON.stringify(error))
    }
  }

  aboutToDisappear(): void {
    Logger.info("Index aboutToDisappear()")
    try {
      accessibility.off("accessibilityStateChange", (data) => {
        Logger.info("Index Unsubscribe accessibility state change. Result: " + JSON.stringify(data))
      })
    } catch (error) {
      Logger.error("Index Failed to unsubscribe accessibility state change. Cause: " + JSON.stringify(error))
    }
  }

  build() {
    Row() {
      Column() {
        Row() {
          Text(this.accessibilityTest)
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin(20)
        }

        Row() {
          Text(this.currentState)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text(": ")
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text(this.connectState)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
        }
        .margin(20)

        Row() {
          Button($r("app.string.accessibility_focus"))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .type(ButtonType.Capsule)
            .margin({
              top: 5,
              bottom: 5
            })
            .backgroundColor("#0D9FFB")
            .width("60%")
            .height("5%")
        }
        .margin(10)

        Row() {
          Button(this.buttonClickState)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .type(ButtonType.Capsule)
            .margin({
              top: 5,
              bottom: 5
            })
            .backgroundColor("#0D9FFB")
            .width("60%")
            .height("5%")
            .onClick(() => {
              let currentClickState = ResourceUtils.getStringByResource(this.context, this.buttonClickState)
              Logger.info("currentClickState: " + currentClickState)
              if (currentClickState == ResourceUtils.getStringByName(this.context, "accessibility_not_clicked")) {
                this.buttonClickState = $r("app.string.accessibility_clicked")
              } else {
                this.buttonClickState = $r("app.string.accessibility_not_clicked")
              }
            })
        }
        .margin(10)
      }
      .width('100%')
    }
    .height('100%')
  }
}