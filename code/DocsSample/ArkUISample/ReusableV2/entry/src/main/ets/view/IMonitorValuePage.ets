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
//[Start Use_in_if_component]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@ObservedV2
export class Info2 {
  @Trace public age: number;
  constructor(age: number) {
    this.age = age;
  }
}

@Entry
@ComponentV2
struct IMonitorValuePage {
  @Local condition: boolean = true;

  build() {
    Column() {
      // $r('app.string.EntryAbility_RecycleOrReuse')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($r('app.string.EntryAbility_RecycleOrReuse')).onClick(()=>{this.condition=!this.condition;})
      if (this.condition) {
        ReusableV2ComponentIMonitorValue()
      }
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2ComponentIMonitorValue {
  noDecoInfo: Info2 = new Info2(30); // 未加装饰器，被视作常量
  @Monitor('noDecoInfo.age')
  onAgeChange(monitor: IMonitor) {
    hilog.info(DOMAIN, TAG, BUNDLE + `age change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }
  aboutToRecycle() {
    this.noDecoInfo.age = 25;
  }
  aboutToReuse() {
    this.noDecoInfo.age = 35;
  }
  build() {
    Column() {
      Column() {
        Text(`noDecoInfo.age: ${this.noDecoInfo.age}`)
          .onClick(()=>{this.noDecoInfo.age++;}) // 能够触发刷新但是不会被重置
      }
    }
  }
}
//[End Use_in_if_component]