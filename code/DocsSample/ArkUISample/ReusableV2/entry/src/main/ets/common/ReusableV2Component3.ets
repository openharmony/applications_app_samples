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
//[Start ReusableV2Component3]
import { Info1 } from '../view/Page6';
@ReusableV2
@ComponentV2
export struct ReusableV2Component3 {
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
  }
  @Monitor('plusParam')
  onPlusParamChange(monitor: IMonitor) {
  }
  build() {
    Column() {
      Column() {
        Text($('app.string.EntryAbility_title8'))
        Text(`val: ${this.val}`).onClick(()=>{this.val++;})
        Text(`info.age: ${this.info.age}`).onClick(()=>{this.info.age++;})
        Text(`paramLocal: ${this.paramLocal}`).onClick(()=>{/* 无外部传入的Local无法本地修改 */})
        Text(`selfProvider: ${this.selfProvider}`).onClick(()=>{this.selfProvider++;})
        Text(`selfConsumer: ${this.selfConsumer}`).onClick(()=>{this.selfConsumer++;})
      }.borderWidth(2)
      Column() {
        Text($('app.string.EntryAbility_title9'))
        Text(`paramOut: ${this.paramOut}`).onClick(()=>{this.changeParam();})
        Text(`paramOnce: ${this.paramOnce}`).onClick(()=>{this.paramOnce++;})
      }.borderWidth(2)
      Column() {
        Text($('app.string.EntryAbility_title10'))
        Text(`inheritConsumer: ${this.inheritConsumer}`).onClick(()=>{this.inheritConsumer++;})
        Text(`plusParam: ${this.plusParam}`)
      }.borderWidth(2)
      Column() {
        Text($('app.string.EntryAbility_title11'))
        Text(`noDecoVariable: ${this.noDecoVariable}`)
        Text(`noDecoInfo.age: ${this.noDecoInfo.age}`).onClick(()=>{this.noDecoInfo.age++;}) // 能够触发刷新但是复用时不会被重置
        Text(`readOnlyVariable: ${this.readOnlyVariable}`)
      }.borderWidth(2)
    }
  }
}
//[End ReusableV2Component3]