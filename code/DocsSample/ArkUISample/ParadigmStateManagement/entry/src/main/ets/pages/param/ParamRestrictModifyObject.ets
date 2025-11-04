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
@Component
export struct ParamRestrictModifyObject {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_restrict_modify_object'))
  }
}

// [Start Param_Restrict_Modify_Object]
@ObservedV2
class Info {
  @Trace public name: string;

  constructor(name: string) {
    this.name = name;
  }
}

@Entry
@ComponentV2
struct Index {
  @Local info: Info = new Info('Tom');

  build() {
    Column() {
      Text(`Parent info.name ${this.info.name}`)
      Button('Parent change info')
        .onClick(() => {
          // 父组件更改@Local变量，会同步子组件对应@Param变量
          this.info = new Info('Lucy');
        })
      Child({ info: this.info })
    }
  }
}

@ComponentV2
struct Child {
  @Require @Param info: Info;

  build() {
    Column() {
      Text(`info.name: ${this.info.name}`)
      Button('change info')
        .onClick(() => {
          // 错误用法，不允许在子组件中更改@Param变量，编译时会报错
          // 错误用法：this.info = new Info('Jack');
        })
      Button('Child change info.name')
        .onClick(() => {
          // 允许在子组件中更改对象中属性，该修改会同步到父组件数据源上，当属性被@Trace装饰时，可观测到对应UI刷新
          this.info.name = 'Jack';
        })
    }
  }
}
// [End Param_Restrict_Modify_Object]