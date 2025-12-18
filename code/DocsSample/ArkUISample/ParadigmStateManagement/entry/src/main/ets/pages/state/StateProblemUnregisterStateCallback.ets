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

// [Start state_problem_unregister_state_callback]
import { common } from '@kit.AbilityKit';

class Model {
  private callback: (() => void) | undefined = () => {
  };

  add(callback: () => void): void {
    this.callback = callback;
  }

  delete(): void {
    this.callback = undefined;
  }

  call(): void {
    if (this.callback) {
      this.callback();
    }
  }
}

let model: Model = new Model();

@Entry
@Component
struct Test {
  @State count: number = 10;
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  aboutToAppear(): void {
    model.add(() => {
      this.count++;
    })
  }

  build() {
    Column() {
      // 请在resources\base\element\string.json文件中配置name为'state_countvalue_text1' ，value为非空字符串的资源
      Text(this.context.resourceManager.getStringByNameSync('state_countvalue_text1') + `${this.count}`)
      Button('change')
        .onClick(() => {
          model.call();
        })
    }
  }

  aboutToDisappear(): void {
    model.delete();
  }
}
// [End state_problem_unregister_state_callback]

@Component
export struct StateProblemUnregisterStateCallback {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Test()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_problem_unregister_state_callback'))
  }
}