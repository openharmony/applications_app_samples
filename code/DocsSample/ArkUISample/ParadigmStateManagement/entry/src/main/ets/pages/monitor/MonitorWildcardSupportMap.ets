/*
* Copyright (c) 2026 Huawei Device Co., Ltd.
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
// [Start monitor_wildcard_support_map]
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@ComponentV2
struct MonitorWildcardMap {
  @Local map: Map<string, string> = new Map<string, string>();
  cnt: number = 0;

  @Monitor({ enableWildcard: false }, 'map.size')
  onMapSizeChanged(m: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `onMapSizeChanged, size dirty: ${m.dirty.toString()}`);
  }

  // 使能通配符
  @Monitor({}, 'map.*')
  onMapChanged(m: IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `onMapChanged, dirty: ${m.dirty.toString()}`);
  }

  build() {
    Column({ space: 5 }) {
      Text(`map.size: ${this.map.size}`)
      Text(`map.get('one'): ${this.map.get('one')}`)
      // 在首次点击时，onMapSizeChanged、onMapChanged回调都触发
      Button(`Init, map.set('one', 'A'), map.set('two', 'B')`)
        .onClick(() => {
          this.map.set('one', 'A');
          this.map.set('two', 'B');
        })
      // onMapSizeChanged、onMapChanged回调都触发
      Button(`Add new, map.set('three' + this.cnt, 'C')`)
        .onClick(() => {
          this.cnt++;
          this.map.set('three' + this.cnt, 'C')
        })
      // 当'one'不存在时，onMapSizeChanged、onMapChanged回调都不触发
      // 当'one'存在时，onMapSizeChanged、onMapChanged回调都触发
      Button(`Delete from map: map.delete('one')`)
        .onClick(() => {
          this.map.delete('one')
        })
      // 当map不为空时，onMapSizeChanged、onMapChanged回调都触发
      // 当map为空时，onMapSizeChanged、onMapChanged回调都不触发
      Button(`Clear map`)
        .onClick(() => {
          this.map.clear();
        })
      // 在首次点击且假设存在（'one' -> 'A'）时，仅onMapChanged回调触发
      // 若已经设置过（'one' -> 'TWO'），则onMapSizeChanged、onMapChanged回调都不触发
      Button(`Update one to 'TWO' - map.set('one', 'TWO')`)
        .onClick(() => {
          this.map.set('one', 'TWO');
        })
      // 当Map不存在'one'时，onMapSizeChanged、onMapChanged回调都触发
      // 当Map存在'one'时，onMapSizeChanged、onMapChanged回调都不会触发
      Button(`Update one to the same - map.set('one', sameval)`)
        .onClick(() => {
          const sameval = this.map.get('one') ?? 'one';
          this.map.set('one', sameval);
        })
      // 当Map不存在'one'时，onMapSizeChanged、onMapChanged回调都触发
      // 当Map存在'one'时，仅onMapChanged回调触发
      Button(`Update one to new value - map.set('one', newval)`)
        .onClick(() => {
          let newval = 'x' + (++this.cnt);
          this.map.set('one', newval);
        })
      // 当map为空时，仅onMapChanged回调触发
      // 当map不为空时，onMapChanged、onMapSizeChanged回调都触发
      Button(`new map`)
        .onClick(() => {
          this.map = new Map();
        })
    }
    .border({ style: BorderStyle.Solid, width: 2, color: Color.Green })
  }
}
// [End monitor_wildcard_support_map]
@Component
export struct MonitorWildcardSupportMap {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      MonitorWildcardMap()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.monitor_wildcard_support_map'))
  }
}
