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

// [Start call_modify_array_prototype_include]
import { hilog } from '@kit.PerformanceAnalysisKit';

function resourceToString(resource: Resource) {
  return getContext().resourceManager.getStringSync(resource);
}

@Entry
@Component
struct main {
  @State message1: ResourceStr = $r('app.string.circular_dependency');
  @State message2: ResourceStr = 'modifyPrototype';

  build() {
    Column() {
      Button($r('app.string.circular_dependency'))
        .onClick(() => {
          import('./a').then((ns: ESObject) => {
            hilog.info(0, '[Sample_ModifyingGlobalVariables]', '%{public}s', ns.b);
          }).catch((e: Error) => {
            hilog.error(0x0000, 'testTag', 'Test Assert error: %{public}s', e.toString());
            this.message1 = resourceToString($r('app.string.circular_dependency')) + 'error: ' + e.toString();
          })
        })
      Row() {
        Button('Not Call modifyPrototype')
          .width('40%')
          .margin({ bottom: 3 })
          .onClick(() => {
            let arr = [1, 2, 3, 4];
            console.log(arr.includes(1).toString());
            this.message2 = 'SideEffect: ' + arr.includes(1).toString();
          })
        Divider()
          .vertical(true)
          .height(30)
          .margin({ left: 8, right: 8 })
          .strokeWidth(2)
        Button('Call modifyPrototype')
          .width('40%')
          .margin({ bottom: 3 })
          .onClick(() => {
            import('./modifyPrototype').then((es: ESObject) => {
              let arr = [1, 2, 3, 4];
              console.log(arr.includes(1).toString()); // 此时调用的是modifyPrototype.ts中的Array.prototype.includes方法
              this.message2 = 'Optimize: ' + arr.includes(1).toString();
            }) // 此时修改了Array的原型链
          })
      }

      Text(this.message1)
        .fontSize(20)
      Text(this.message2)
        .fontSize(20)
    }
    .height('100%')
    .width('100%')
  }
}
// [End call_modify_array_prototype_include]