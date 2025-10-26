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
export struct ParamObserveChangeClass {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Index()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.param_observe_change_class'))
  }
}

// [Start Param_Observe_Change_Class]
class RawObject {
  public name: string;

  constructor(name: string) {
    this.name = name;
  }
}

@ObservedV2
class ObservedObject {
  @Trace public name: string;

  constructor(name: string) {
    this.name = name;
  }
}

@Entry
@ComponentV2
struct Index {
  @Local rawObject: RawObject = new RawObject('rawObject');
  @Local observedObject: ObservedObject = new ObservedObject('observedObject');

  build() {
    Column() {
      Text(`${this.rawObject.name}`)
      Text(`${this.observedObject.name}`)
      Button('change object')
        .onClick(() => {
          // 对类对象整体的修改均能观察到
          this.rawObject = new RawObject('new rawObject');
          this.observedObject = new ObservedObject('new observedObject');
        })
      Button('change name')
        .onClick(() => {
          // @Local与@Param均不具备观察类对象属性的能力，因此对rawObject.name的修改无法观察到
          this.rawObject.name = 'new rawObject name';
          // 由于ObservedObject的name属性被@Trace装饰，因此对observedObject.name的修改能被观察到
          this.observedObject.name = 'new observedObject name';
        })
      Child({
        rawObject: this.rawObject,
        observedObject: this.observedObject
      })
    }
  }
}

@ComponentV2
struct Child {
  @Require @Param rawObject: RawObject;
  @Require @Param observedObject: ObservedObject;

  build() {
    Column() {
      Text(`${this.rawObject.name}`)
      Text(`${this.observedObject.name}`)
    }
  }
}
// [End Param_Observe_Change_Class]