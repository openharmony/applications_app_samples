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
// [Start state_mixed_scene_nested_type_v1_v2]
import { UIUtils } from '@kit.ArkUI';

class ArrayItem {
  public value: number = 0;

  constructor(value: number) {
    this.value = value;
  }
}

class Inner {
  public innerValue: string = 'inner';
  public arr: Array<ArrayItem>;

  constructor(arr: Array<ArrayItem>) {
    this.arr = arr;
  }
}

class Outer {
  @Track public outerValue: string = 'outer';
  @Track public inner: Inner;

  constructor(inner: Inner) {
    this.inner = inner;
  }
}

@Entry
@Component
struct NestedClassV1 {
  // 需保证每一层都是V1的状态变量
  @State outer: Outer =
    UIUtils.makeV1Observed(new Outer(
      UIUtils.makeV1Observed(new Inner(UIUtils.makeV1Observed([
        UIUtils.makeV1Observed(new ArrayItem(1)),
        UIUtils.makeV1Observed(new ArrayItem(2))
      ])))
    ));

  build() {
    Column() {
      Text(`@State outer.outerValue can update ${this.outer.outerValue}`)
        .fontSize(20)
        .onClick(() => {
          // @State可以观察第一层的变化
          // 变化会通知@ObjectLink和@Param刷新
          this.outer.outerValue += '!';
        })

      Text(`@State outer.inner.innerValue cannot update ${this.outer.inner.innerValue}`)
        .fontSize(20)
        .onClick(() => {
          // @State无法观察第二层的变化
          // 但该变化会被@ObjectLink和@Param观察
          this.outer.inner.innerValue += '!';
        })
      // 将inner传递给@ObjectLink可观察inner属性的变化
      NestedClassV1ObjectLink({ inner: this.outer.inner })
      // 将开启enableV2Compatibility的数据传给V2
      NestedClassV2({ outer: UIUtils.enableV2Compatibility(this.outer) })
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct NestedClassV1ObjectLink {
  @ObjectLink inner: Inner;

  build() {
    Text(`@ObjectLink inner.innerValue can update ${this.inner.innerValue}`)
      .fontSize(20)
      .onClick(() => {
        // 可以触发刷新，和@Param是同一个对象的引用，@Param也会进行刷新
        this.inner.innerValue += '!';
      })
  }
}

@ComponentV2
struct NestedClassV2 {
  @Require @Param outer: Outer;

  build() {
    Column() {
      Text(`@Param outer.outerValue can update ${this.outer.outerValue}`)
        .fontSize(20)
        .onClick(() => {
          // 可以观察第一层的变化
          this.outer.outerValue += '!';
        })
      Text(`@Param outer.inner.innerValue can update ${this.outer.inner.innerValue}`)
        .fontSize(20)
        .onClick(() => {
          // 可以观察第二层的变化，和@ObjectLink是同一个对象的引用，也会触发刷新
          this.outer.inner.innerValue += '!';
        })

      Repeat(this.outer.inner.arr)
        .each((item: RepeatItem<ArrayItem>) => {
          Text(`@Param outer.inner.arr index: ${item.index} item: ${item.item.value}`)
        })

      Button('@Param push').onClick(() => {
        // outer已经使能了V2观察能力，对于新增加的数据，则默认开启V2观察能力
        this.outer.inner.arr.push(UIUtils.makeV1Observed(new ArrayItem(20)));
      })

      Button('@Param change the last Item').onClick(() => {
        // 可以观察最后一个数组项的属性变化
        this.outer.inner.arr[this.outer.inner.arr.length - 1].value++;
      })
    }
  }
}
// [End state_mixed_scene_nested_type_v1_v2]
@Component
export struct StateMixedSceneNestedTypeV1V2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      NestedClassV1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.state_mixed_scene_nested_type_v1_v2'))
  }
}