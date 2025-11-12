/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
// [Start emitter_imp]
import { emitter, Callback } from '@kit.BasicServicesKit';
// [End emitter_imp]
@Entry
@Component
struct Index {
  @State messageOn: string = 'Emit On';

  emitterOn(): void {
    // [Start emitter_on]
    // 定义一个eventId为1的事件。
    let event: emitter.InnerEvent = {
      eventId: 1
    };
    // 定义一个事件的回调处理函数，当收到对应的事件后执行回调函数
    let callback: Callback<emitter.EventData> = (eventData: emitter.EventData) => {
      this.messageOn = eventData.data!.content
      console.info(`eventData: ${JSON.stringify(eventData)}`);
    }
    // [StartExclude emitter_on]
    // [Start emitter_once]
    // 收到eventId为1的事件后执行回调函数。
    // 注意：once订阅只接收一次事件，on订阅则一直接收直到取消订阅为止。
    emitter.once(event, callback);
    // [End emitter_once]
    // [EndExclude emitter_on]
    // 收到eventId为1的事件后执行回调函数
    emitter.on(event, callback);
    // [End emitter_on]
  }

  onPageShow(): void {
    this.emitterOn();
  }

  emitEvent(): void {
    // [Start emitter_emit]
    // 定义一个eventId为1的事件，事件优先级为Low。
    let event: emitter.InnerEvent = {
      eventId: 1,
      priority: emitter.EventPriority.LOW
    };

    let eventData: emitter.EventData = {
      data: {
        content: 'emitter',
        id: 1,
        isEmpty: false
      }
    };

    // 发送eventId为1的事件，事件内容为eventData。
    emitter.emit(event, eventData);
    // [End emitter_emit]
  }

  build() {
    Column() {
      Button(this.messageOn)
        .id('emitterOn')
        .margin(20)
        .onClick(() => {
          this.emitEvent();
        })
      Button('emitterOff')
        .id('2025')
        .margin(20)
        .onClick(() => {
          // [Start emitter_off]
          // 取消eventId为1的事件。
          emitter.off(1);
          // [End emitter_off]
        })
    }
    .height('100%')
    .width('100%')
  }
}