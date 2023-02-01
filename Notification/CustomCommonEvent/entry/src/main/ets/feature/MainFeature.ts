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

import commonEvent from '@ohos.commonEvent'
import consts from '../module/Consts'
import surveillanceEventsManager from '../module/SurveillanceEventsManager'

export default class MainFeature {
  private onceEvents: Array<string> = []
  private currentValidEvents: Array<string> = surveillanceEventsManager.surveillanceEvents
  private settingSubscriber = null // this subscriber subscribe self defined sticky events
  private eventsState: Map<string, number> = new Map()

  constructor() {
  }

  async init() {
    if (this.settingSubscriber == null) {
      let settingSubscriberInfo = {
        events: [
          consts.COMMON_EVENT_SETTING_UPDATE
        ]
      }
      commonEvent.createSubscriber(settingSubscriberInfo).then((subscriber) => {
        this.settingSubscriber = subscriber
        commonEvent.subscribe(subscriber, (error, event) => {
          this.eventsState.clear()
          this.currentValidEvents = []
          this.onceEvents = []
          surveillanceEventsManager.surveillanceEvents.forEach((element: string) => {
            this.eventsState.set(element, event.parameters[element])
          })
          this.eventsState.forEach((value, key) => {
            switch (value) {
              case consts.ENABLE_STATE_ALWAYS:
                this.currentValidEvents.push(key)
                break
              case consts.ENABLE_STATE_ONCE:
                this.currentValidEvents.push(key)
                this.onceEvents.push(key)
                break
            }
          })
        })
      })
    }
  }

  async reset() {
    await commonEvent.unsubscribe(this.settingSubscriber, () => {
      this.settingSubscriber = null
    })
  }

  getOnceEvents(): Array<string> {
    return this.onceEvents
  }

  getCurrentValidEvents():Array<string> {
    return this.currentValidEvents
  }
}