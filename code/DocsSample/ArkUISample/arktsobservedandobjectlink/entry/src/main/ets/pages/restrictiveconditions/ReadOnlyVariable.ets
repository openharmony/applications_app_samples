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
import { common } from '@kit.AbilityKit';

// [Start variables_decorated_ObjectLink_read_only]
@Observed
class Info {
  public count: number;

  constructor(count: number) {
    this.count = count;
  }
}

@Component
struct Child {
  @ObjectLink num: Info;
  // [StartExclude variables_decorated_ObjectLink_read_only]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  // [EndExclude variables_decorated_ObjectLink_read_only]
  build() {
    Column() {
      // $r('app.string.value_num')需要替换为开发者所需的资源文件
      Text(`${this.context.resourceManager.getStringSync($r('app.string.value_num').id)}: ${this.num.count}`)
        .onClick(() => {
          // 正确写法，可以更改@ObjectLink装饰变量的成员属性
          this.num.count = 20;
        })
    }
  }
}

@Entry
@Component
struct Parent {
  @State num: Info = new Info(10);
  // [StartExclude variables_decorated_ObjectLink_read_only]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;

  // [EndExclude variables_decorated_ObjectLink_read_only]
  build() {
    Column() {
      // $r('app.string.value_count')需要替换为开发者所需的资源文件
      Text(`${this.context.resourceManager.getStringSync($r('app.string.value_count').id)}: ${this.num.count}`)
      Button('click')
        .onClick(() => {
          // 可以在父组件做整体替换
          this.num = new Info(30);
        })
      Child({ num: this.num })
    }
  }
}

// [End variables_decorated_ObjectLink_read_only]
const readOnlyVariableParent = Parent;
export default readOnlyVariableParent;
