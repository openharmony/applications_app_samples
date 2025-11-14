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
@Observed
class ObjLink {
  public a: string;

  constructor(a: string) {
    this.a = a;
  }
}

// [Start Observe_the_changes]
class Child {
  public num: number;

  constructor(num: number) {
    this.num = num;
  }
}

@Observed
class Parent {
  public child: Child;
  public count: number;

  constructor(child: Child, count: number) {
    this.child = child;
    this.count = count;
  }
}

// [End Observe_the_changes]

@Entry
@Component
struct DecoratorDescription {
  build() {
    Column() {
      Text('Hello World')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
    .height('100%')
    .width('100%')
  }
}

@Component
struct DecoratorDescriptionHelloWorld {
  @ObjectLink objLink: ObjLink;
  // [Start Modify_and_change]
  @ObjectLink parent: Parent;

  // [StartExclude Modify_and_change]
  build() {
    RelativeContainer() {
      Button('')
        .onClick(() => {
          // [EndExclude Modify_and_change]
          // 赋值变化可以被观察到
          this.parent.child = new Child(5);
          this.parent.count = 5;
          // Child没有被@Observed装饰，其属性的变化观察不到
          this.parent.child.num = 5;
          // [End Modify_and_change]

          // [Start Attribute_assignment]
          // 允许@ObjectLink装饰的数据属性赋值
          this.objLink.a = '...'
          // [End Attribute_assignment]
        })
    }
    .height('100%')
    .width('100%')
  }
}
export default DecoratorDescription;
