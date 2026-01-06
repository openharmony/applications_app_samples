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

// [Start wildcard_monitor_object_property_change]
import { hilog } from '@kit.PerformanceAnalysisKit';
@ObservedV2
class ClassA {
  @Trace public propA : number = 8;
  @Trace public propB : number = 99;

  constructor(a : number, b: number) {
    this.propA = a;
    this.propB = b;
  }
}

@Entry
@ComponentV2 struct DocSampleClass {
  @Local cls : ClassA = new ClassA(100, 100);

  @SyncMonitor('cls.*')
  onClsChanged(m :IMonitor) {
    hilog.info(0xFF00, 'testTag', '%{public}s', `### onClsChanged, dirty: ${m.dirty.toString()}`);
  }

  build() {
    Column() {
      Divider()
      Button(`#1 Change propA ${this.cls.propA}: +=1;`)
        .onClick(() => {
          this.cls.propA += 1;
        })
      Button(`#2 Change propB ${this.cls.propB}: +=1`)
        .onClick(() => {
          this.cls.propB += 1;
        })
      Button(`#3 Assign class object`)
        .onClick(() => {
          this.cls = new ClassA(-200, -200);
        })
    }
    .border({ style: BorderStyle.Solid, width: 2, color: Color.Green })
  }
}
// [End wildcard_monitor_object_property_change]