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

import Logger from '../model/Logger'
import call from '@ohos.telephony.call'

const TAG: string = `[CallView]`

@Component
export struct CallView {
  private on: Resource = $r('app.media.call_on')
  private off: Resource = $r('app.media.call_off')
  @State src: Resource = this.off
  @Link input: string
  @Link output: string

  build() {
    Column() {
      Image(this.src)
        .id('callImg')
        .width(70)
        .height(70)
        .onClick(() => {
          if (this.src == this.on) {
            this.src = this.off
          } else {
            this.output = ''
            this.src = this.on
            call.dialCall(this.input, (err, data) => {
              this.output = this.output + `dial: ${JSON.stringify(data)}` + '\n'
              Logger.info(`${TAG}, callback: dial err->${JSON.stringify(err)} data->${JSON.stringify(data)}`)
            })

            call.hasCall((err, data) => {
              this.output = this.output + `hasCall: ${JSON.stringify(data)}` + '\n'
              Logger.info(`${TAG}, callback: hasCall err->${JSON.stringify(err)} data->${JSON.stringify(data)}`)
            })

            call.getCallState((err, data) => {
              this.output = this.output + `getCallState: ${JSON.stringify(data)}` + '\n'
              Logger.info(`${TAG}, callback: getCallState err->${JSON.stringify(err)} data->${JSON.stringify(data)}`)
            })

            call.isEmergencyPhoneNumber(this.input, (err, data) => {
              this.output = this.output + `isEmergencyPhoneNumber: ${JSON.stringify(data)}` + '\n'
              Logger.info(`${TAG}, callback: isEmergencyPhoneNumber err->${JSON.stringify(err)} data->${JSON.stringify(data)}`)
            })

            call.formatPhoneNumber(this.input, (err, data) => {
              this.output = this.output + `formatPhoneNumber: ${JSON.stringify(data)}` + '\n'
              Logger.info(`${TAG}, callback: formatPhoneNumber err->${JSON.stringify(err)} data->${JSON.stringify(data)}`)
            })

            call.formatPhoneNumberToE164(this.input, "CN", (err, data) => {
              this.output = this.output + `formatPhoneNumberToE164: ${JSON.stringify(data)}` + '\n'
              Logger.info(`${TAG}, callback: formatPhoneNumberToE164 err->${JSON.stringify(err)} data->${JSON.stringify(data)}`)
            })
          }
        })
        .onFinish(() => {
          this.src = this.off
        })
    }
  }
}