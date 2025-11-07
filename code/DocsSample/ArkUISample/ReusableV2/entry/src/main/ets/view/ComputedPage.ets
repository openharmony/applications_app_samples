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
//[Start Reset_the_internal_state_variables_of_the_component_before_reuse1]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[Sample_Reusablev2]';
const DOMAIN = 0xF811;
const BUNDLE = 'Reusablev2_';

@ObservedV2
export class Info1 {
  @Trace public  age: number;
  constructor(age: number) {
    this.age = age;
  }
}

@Entry
@ComponentV2
struct ComputedPage {
  @Local local: number = 0;
  @Provider('inherit') inheritProvider: number = 100;
  @Local condition: boolean = true;
  build() {
    Column() {
      // $r('app.string.EntryAbility_RecycleOrReuse')需要替换为开发者所需的字符串（图像、数字等）资源文件
      Button($r('app.string.EntryAbility_RecycleOrReuse')).onClick(()=>{this.condition=!this.condition;})
      Column() {
        Text($r('app.string.EntryAbility_ParentVariable'))
        Text(`local: ${this.local}`).onClick(()=>{this.local++;})
        Text(`inheritProvider: ${this.inheritProvider}`).onClick(()=>{this.inheritProvider++;})
      }.borderWidth(2)
      if (this.condition) {
        ReusableV2ComponentComputed({
          paramOut: this.local,
          paramOnce: this.local,
          changeParam: () => {
            this.local++;
          }
        })
      }
    }
  }
}
@ReusableV2
@ComponentV2
struct ReusableV2ComponentComputed {
  @Local val: number = 0;
  @Local info: Info1 = new Info1(25);
  @Param paramLocal: number = 1;
  @Require @Param paramOut: number;
  @Require @Param @Once paramOnce: number;
  @Event changeParam: () => void;
  @Provider('selfProvider') selfProvider: number = 0;
  @Consumer('inherit') inheritConsumer: number = 0;
  @Consumer('selfConsumer') selfConsumer: number = 0;
  noDecoVariable: number = 0; // 未加装饰器，被视作常量
  noDecoInfo: Info1 = new Info1(30); // 未加装饰器，被视作常量
  readonly readOnlyVariable: number = 0; // readonly常量
  @Computed
  get plusParam() {
    return this.paramLocal + this.paramOut + this.paramOnce;
  }
  @Monitor('val')
  onValChange(monitor: IMonitor) {
    hilog.info(DOMAIN, TAG, BUNDLE + `val change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }
  @Monitor('plusParam')
  onPlusParamChange(monitor: IMonitor) {
    hilog.info(DOMAIN, TAG, BUNDLE + `plusParam change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
  }
  build() {
    Column() {
      Column() {
        // $r('app.string.EntryAbility_ResetToLocal')需要替换为开发者所需的字符串（图像、数字等）资源文件
        Text($r('app.string.EntryAbility_ResetToLocal'))
        Text(`val: ${this.val}`).onClick(()=>{this.val++;})
        Text(`info.age: ${this.info.age}`).onClick(()=>{this.info.age++;})
        Text(`paramLocal: ${this.paramLocal}`).onClick(()=>{/* 无外部传入的Local无法本地修改 */})
        Text(`selfProvider: ${this.selfProvider}`).onClick(()=>{this.selfProvider++;})
        Text(`selfConsumer: ${this.selfConsumer}`).onClick(()=>{this.selfConsumer++;})
      }.borderWidth(2)
      Column() {
        // $r('app.string.EntryAbility_ResetToExternal')需要替换为开发者所需的字符串（图像、数字等）资源文件
        Text($r('app.string.EntryAbility_ResetToExternal'))
        Text(`paramOut: ${this.paramOut}`).onClick(()=>{this.changeParam();})
        Text(`paramOnce: ${this.paramOnce}`).onClick(()=>{this.paramOnce++;})
      }.borderWidth(2)
      Column() {
        // $r('app.string.EntryAbility_Decision')需要替换为开发者所需的字符串（图像、数字等）资源文件
        Text($r('app.string.EntryAbility_Decision'))
        Text(`inheritConsumer: ${this.inheritConsumer}`).onClick(()=>{this.inheritConsumer++;})
        Text(`plusParam: ${this.plusParam}`)
      }.borderWidth(2)
      Column() {
        // $r('app.string.EntryAbility_NotReset')需要替换为开发者所需的字符串（图像、数字等）资源文件
        Text($r('app.string.EntryAbility_NotReset'))
        Text(`noDecoVariable: ${this.noDecoVariable}`)
        Text(`noDecoInfo.age: ${this.noDecoInfo.age}`).onClick(()=>{this.noDecoInfo.age++;}) // 能够触发刷新但是复用时不会被重置
        Text(`readOnlyVariable: ${this.readOnlyVariable}`)
      }.borderWidth(2)
    }
  }
}
//[End Reset_the_internal_state_variables_of_the_component_before_reuse1]