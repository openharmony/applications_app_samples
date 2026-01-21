/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start wildcard_monitor_array_first_item_change]
import { hilog } from '@kit.PerformanceAnalysisKit';

@ObservedV2
class Person {
  @Trace firstName: string = 'first';
  @Trace lastName: string = 'last';
  constructor(first: string = 'no first', last: string = 'no last') {
    this.firstName = first;
    this.lastName = last;
  }
}

@ObservedV2
class ArrayOfPerson extends Array<Person> {}

@ObservedV2
class TopArray extends Array<ArrayOfPerson> {}

@Entry
@ComponentV2
struct DocSampleArrayOfArrays {
  @Local topArray: TopArray = this.makeNewTopArray();

  @SyncMonitor('topArray.1.*')
  topArrayMonitor1Star(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `TopArray[1]: ${monitor.dirty.toString()}`);
  }

  @SyncMonitor('topArray.*')
  topArrayMonitorStar(monitor: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `TopArray: ${monitor.dirty.toString()}`);
  }

  makeNewTopArray(): TopArray {
    return new TopArray(
      new ArrayOfPerson(new Person('Adrian'), new Person('Andrew'), new Person('Aaliyah'), new Person('Amir'), new Person('Angel')),
      new ArrayOfPerson(new Person('Carter'), new Person('Charlie'), new Person('Cooper'), new Person('Cole'), new Person('Callie')),
      new ArrayOfPerson(new Person('Danile'), new Person('Dasy'), new Person('Dawson'), new Person('Dana'), new Person('Dalton'))
    );
  }

  build() {
    Column() {
      Text('Array of Arrays')
        .fontSize(30)

      // 因为脏的路径中包含'topArray.1'，会触发路径为'topArray.1.*'的@SyncMonitor的回调
      // 因为脏的路径中包含'topArray'，会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray = new TopArray')
        .onClick(() => {
          this.topArray = this.makeNewTopArray();
        })

      // 因为脏路径被包含在'topArray.1.*'中，会触发路径为'topArray.1.*'的@SyncMonitor的回调
      // 因为脏路径没被包含在'topArray.*'中，不会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray[1][0] = new Person')
        .onClick(() => {
          this.topArray[1][0] = new Person();
        })

      // 不会触发路径为 'topArray.1.*'的@SyncMonitor的回调
      // 不会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray[0][1] = new Person')
        .onClick(() => {
          this.topArray[0][1] = new Person();
        })

      // 因为脏路径被包含在'topArray.1.*'中，会触发路径为'topArray.1.*'的@SyncMonitor的回调
      // 因为脏路径没被包含在'topArray.*'中，不会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray[1].push')
        .onClick(() => {
          this.topArray[1].push(new Person());
        })

      // 因为脏的路径中包含'topArray.1'，会触发路径为'topArray.1.*'的@SyncMonitor的回调
      // 因为脏的路径中包含'topArray.*'，会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray.shift (size>2)')
        .onClick(() => {
          this.topArray.shift();
        })

      // 不会触发路径为'topArray.1.*的@SyncMonitor的回调
      // 因为脏的路径中包含'topArray.*'，会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray[0] = new ArrayOfPerson')
        .onClick(() => {
          this.topArray[0] = new ArrayOfPerson(new Person(), new Person());
        })

      // 不会触发路径为'topArray.1.*的@SyncMonitor的回调
      // 不会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray[1][0].last update')
        .onClick(() => {
          this.topArray[1][0].lastName += '~';
        })

      // 不会触发路径为'topArray.1.*'的@SyncMonitor的回调
      // 因为脏的路径中包含'topArray'，会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray = new TopArray, keep [1]')
        .onClick(() => {
          let newTop = this.makeNewTopArray();
          newTop[1] = this.topArray[1];
          this.topArray = newTop;
        })

      // 不会触发路径为'topArray.1.*'的@SyncMonitor的回调
      // 因为脏的路径中包含'topArray.*'，会触发路径为'topArray.*'的@SyncMonitor的回调
      Button('topArray.push, +0, +1')
        .onClick(() => {
          this.topArray.push(new ArrayOfPerson(new Person(), new Person()));
        })
    }
  }
}
// [End wildcard_monitor_array_first_item_change]