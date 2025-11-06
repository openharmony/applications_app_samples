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
// [Start component_builder_modify]
@Component
struct Child {
  label: string = 'Child';
  @BuilderParam customBuilderParam: () => void;

  build() {
    Column() {
      this.customBuilderParam()
    }
  }
}

@Entry
@Component
struct Parent {
  label: string = 'Parent';

  @Builder componentBuilder() {
    Text(`${this.label}`) // @Builder内的this指向实际调用点的组件，在这个用例中因为调用点在Child组件内，所以this实际指向Child组件
  }

  @LocalBuilder componentLocalBuilder() {
    Text(`${this.label}`) // @LocalBuilder内的this指向声明@LocalBuilder函数Parent组件
  }

  build() {
    Column() {
      Child({ customBuilderParam: this.componentBuilder }) // Child组件内调用customBuilderParam显示字符串Child
      Child({ customBuilderParam: this.componentLocalBuilder }) // Child组件内调用customBuilderParam显示字符串Parent
    }
  }
}
// [End component_builder_modify]
@Component
export struct ComponentBuilderModify {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.component_builder_modify'))
  }
}