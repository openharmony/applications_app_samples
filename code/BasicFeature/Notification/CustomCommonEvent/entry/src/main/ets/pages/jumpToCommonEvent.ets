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

import prompt from '@ohos.promptAction';
import commonEvent from '@ohos.commonEventManager';
import Base from '@ohos.base';
import Logger from '../module/Logger'

interface Form {
  id: number
}

interface Error {
  errcode: number,
  msg: string
}

@Entry
@Component
struct CardExample {
  @State buttonText: Resource = $r('app.string.SubscribeEventOn');
  @State buttonFountSize: Resource = $r('app.float.button_fount_size');
  @State buttonBackgroundColor: Resource = $r('app.color.subscribe_events_background');
  @State buttonFountColor: Resource = $r('app.color.subscribe_events_fount');
  @State isSubscribeEvents: boolean = false;
  @State isInAppCardEventsCallback: boolean = false;
  @State isOutAppCardEventsCallback: boolean = false;
  @State customCommonEventFormId: number = 0;
  @State customCommonEventRelyFormId: number = 0;
  private eventData: string = '';
  private eventDataBundleName: string = '';
  private validEventsSubscriber: commonEvent.CommonEventSubscriber | null = null;
  private validEventsSubscriberBundleName: commonEvent.CommonEventSubscriber | null = null;
  private systemEventCallback = (error: Base.BusinessError, event: commonEvent.CommonEventData) => {
    Logger.info(`systemEventCallback, error: ${JSON.stringify(error)}, data: ${JSON.stringify(event.data)}`);
    if (event.data != undefined) {
      this.eventData = event.data;
      this.eventCallBackPrompt();
    }
  }
  private systemEventCallbackBundleName = (error: Base.BusinessError, event: commonEvent.CommonEventData) => {
    Logger.info(`systemEventCallbackBundleName, error: ${JSON.stringify(error)}, data: ${JSON.stringify(event.data)}`);
    if (event.data != undefined) {
      this.eventDataBundleName = event.data;
      this.eventCallBackPrompt();
    }
  }
  private eventCallBackPrompt = () => {
    if (!this.isSubscribeEvents) {
      return;
    }
    if (this.eventData == 'InApp') {
      if (this.eventDataBundleName == this.eventData) {
        prompt.showToast({ message: $r('app.string.BundleNameEventReceive'), duration: 3000 });
      } else {
        return;
      }
    }
    if (this.eventData == 'OutApp') {
      if (this.eventDataBundleName == this.eventData) {
        return;
      }
      prompt.showToast({ message: $r('app.string.EventReceive'), duration: 3000 });
    }
  }
  private declareEvent = () => {
    let commonEventSubscribeInfo: commonEvent.CommonEventSubscribeInfo = {
      events: ['Acts_CommonEvent_Test']
    };
    Logger.info(`====> declareEvent`);
    commonEvent.createSubscriber(
      commonEventSubscribeInfo,
      (error: Base.BusinessError, subscriber: commonEvent.CommonEventSubscriber) => {
        this.validEventsSubscriber = subscriber;
        commonEvent.subscribe(this.validEventsSubscriber, this.systemEventCallback);
        Logger.info(`declareEvent createSubscriber, error: ${JSON.stringify(error)}`);
      }
    );
  }
  private declareEventBundleName = () => {
    let commonEventSubscribeInfo: commonEvent.CommonEventSubscribeInfo = {
      events: ['Acts_CommonEvent_Test'],
      publisherBundleName: 'com.samples.customcommonevent'
    }
    Logger.info(`====> declareEventBundleName`);
    commonEvent.createSubscriber(
      commonEventSubscribeInfo,
      (error: Base.BusinessError, subscriber: commonEvent.CommonEventSubscriber) => {
        this.validEventsSubscriberBundleName = subscriber;
        commonEvent.subscribe(this.validEventsSubscriberBundleName, this.systemEventCallbackBundleName);
        Logger.info(`declareEventBundleName createSubscriber, error: ${JSON.stringify(error)}`);
      }
    );
  }
  private unsubscribeCommonEvent = () => {
    commonEvent.unsubscribe(this.validEventsSubscriber, () => {
      Logger.info('unsubscribe validEventsSubscriber successfully');
    });
    commonEvent.unsubscribe(this.validEventsSubscriberBundleName, () => {
      Logger.info('unsubscribe validEventsSubscriberBundleName successfully');
    });
    this.eventData = '';
    this.eventDataBundleName = '';
    prompt.showToast({ message: $r('app.string.UnSubscribeEventText'), duration: 3000 });
  }
  private executeCallBack = () => {
    this.declareEventBundleName();
    this.declareEvent();
    prompt.showToast({ message: $r('app.string.SubscribeEventText'), duration: 3000 });
  }

  build() {
    Row() {
      Column() {
        Row() {
          List() {
            ListItem() {
              Column() {
                Text($r('app.string.EventText'))
                  .fontWeight(700)
                  .fontSize($r('app.float.24fp'))
                  .width($r('app.float.312vp'))
                  .height($r('app.float.33vp'))
                  .textAlign(TextAlign.Start)
              }
              .width('336vp')
              .margin({
                top: $r('app.float.12vp')
              })
            }

            ListItem() {
              Row() {
                Column() {
                  Text($r('app.string.Text_First'))
                    .fontWeight(500)
                    .fontColor($r('app.color.fount_color'))
                    .fontSize($r('app.float.16fp'))
                    .width($r('app.float.240vp'))
                    .height($r('app.float.22vp'))
                    .margin({
                      top: $r('app.float.14vp')
                    })
                  Text($r('app.string.Text_Second'))
                    .fontWeight(400)
                    .fontColor($r('app.color.fount_color'))
                    .opacity(0.6)
                    .fontSize($r('app.float.14fp'))
                    .width($r('app.float.240vp'))
                    .height($r('app.float.19vp'))
                    .margin({
                      top: $r('app.float.2vp'),
                      bottom: $r('app.float.15vp')
                    })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({
                  left: $r('app.float.12vp')
                })
                .padding(0)

                Column() {
                  Button(this.buttonText)
                    .backgroundColor(this.buttonBackgroundColor)
                    .fontSize(this.buttonFountSize)
                    .fontColor(this.buttonFountColor)
                    .width($r('app.float.72vp'))
                    .height($r('app.float.28vp'))
                    .margin({
                      right: $r('app.float.12vp')
                    })
                    .onClick(() => {
                      if (!this.isSubscribeEvents) {
                        this.executeCallBack();
                        this.isSubscribeEvents = !this.isSubscribeEvents
                        this.buttonText = $r('app.string.UnSubscribeEvent')
                        this.buttonFountColor = $r('app.color.unsubscribe_events_fount')
                        this.buttonBackgroundColor = $r('app.color.unsubscribe_events_background')
                      } else {
                        this.unsubscribeCommonEvent();
                        this.isSubscribeEvents = !this.isSubscribeEvents
                        this.buttonText = $r('app.string.SubscribeEventOn')
                        this.buttonFountColor = $r('app.color.subscribe_events_fount')
                        this.buttonBackgroundColor = $r('app.color.subscribe_events_background')
                      }
                    })
                }
                .padding(0)
              }
              .padding(0)
              .alignItems(VerticalAlign.Center)
            }
            .padding(0)
            .margin({
              top: $r('app.float.11vp')
            })
            .borderRadius($r('app.float.24vp'))
            .backgroundColor($r('app.color.white'))
            .width($r('app.float.336vp'))
            .height($r('app.float.72vp'))

            ListItem() {
              Column() {
                FormComponent({
                  id: this.customCommonEventFormId,
                  name: 'publishCard',
                  bundle: 'com.samples.customcommonevent',
                  ability: 'EntryFormAbility',
                  module: 'entry'
                })
                  .borderRadius($r('app.float.24vp'))
                  .allowUpdate(true)
                  .size({ width: 448, height: 96 })
                  .onAcquired((form: Form) => {
                    Logger.info(`form info : ${JSON.stringify(form)}`);
                    this.customCommonEventFormId = form.id;
                  })
                  .onError((err: Error) => {
                    Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
                  })
              }
              .margin({
                top: $r('app.float.12vp')
              })
            }

            ListItem() {
              FormComponent({
                id: this.customCommonEventRelyFormId,
                name: 'publishCard',
                bundle: 'com.samples.customcommoneventrely',
                ability: 'EntryFormAbility',
                module: 'entry'
              })
                .borderRadius($r('app.float.24vp'))
                .allowUpdate(true)
                .size({ width: 448, height: 96 })
                .onAcquired((form: Form) => {
                  Logger.info(`form info : ${JSON.stringify(form)}`);
                  this.customCommonEventRelyFormId = form.id;
                })
                .onError((err: Error) => {
                  Logger.info(`fail to add form, err: ${JSON.stringify(err)}`);
                })
            }
            .margin({
              top: $r('app.float.12vp')
            })
          }
          .alignListItem(ListItemAlign.Center)
        }
      }
      .width('100%')
    }
    .alignItems(VerticalAlign.Top)
    .backgroundColor($r('app.color.page_background'))
    .height('100%')
  }
}