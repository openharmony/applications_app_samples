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

import { sensor } from '@kit.SensorServiceKit';
import { taskpool } from '@kit.ArkTS';
import { BusinessError, emitter } from '@kit.BasicServicesKit';

@Concurrent
async function sensorListener(): Promise<void> {
  sensor.on(sensor.SensorId.ACCELEROMETER, (data) => {
    emitter.emit({ eventId: 0 }, { data: data });
  }, { interval: 1000000000 });

  emitter.on({ eventId: 1 }, () => {
    sensor.off(sensor.SensorId.ACCELEROMETER)
    emitter.off(1)
  })
}

@Entry
@Component
struct Index {
  sensorTask?: taskpool.LongTask
  @State addListener: string = 'Add listener';
  @State deleteListener: string = 'Delete listener';

  build() {
    Column() {
      Text(this.addListener)
        .id('Add listener')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          this.sensorTask = new taskpool.LongTask(sensorListener);
          emitter.on({ eventId: 0 }, (data) => {
            // Do something here
            console.info(`Receive ACCELEROMETER data: {${data.data?.x}, ${data.data?.y}, ${data.data?.z}`);
          });
          taskpool.execute(this.sensorTask).then(() => {
            console.info('Add listener of ACCELEROMETER success');
          }).catch((e: BusinessError) => {
            // Process error
          })
          this.addListener = 'success';
        })
      Text(this.deleteListener)
        .id('Delete listener')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(() => {
          emitter.emit({ eventId: 1 });
          emitter.off(0);
          if (this.sensorTask != undefined) {
            taskpool.terminateTask(this.sensorTask);
          } else {
            console.error('sensorTask is undefined.');
          }
          this.deleteListener = 'success';
        })
    }
    .height('100%')
    .width('100%')
  }
}