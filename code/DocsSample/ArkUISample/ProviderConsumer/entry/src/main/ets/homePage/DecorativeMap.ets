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

// [Start Decorative_Map]
@Entry
@ComponentV2
struct Parent {
  @Provider() message: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);

  build() {
    Column() {
      Text('Parent')
        .fontSize(20)
        .margin(5)
      ForEach(Array.from(this.message.entries()), (item: [number, string]) => {
        Text(`${item[0]}`)
          .fontSize(20)
        Text(`${item[1]}`)
          .fontSize(20)
        Divider()
      })
      // message被@Provider装饰，可以被观察到Map整体的赋值以及调用Map接口带来的变化
      Button('init map')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message = new Map([[0, 'aa'], [1, 'bb'], [3, 'cc']]);
        })
      Button('set new one')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.set(4, 'd');
        })
      Button('clear')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.clear();
        })
      Button('replace the first one')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.set(0, 'a~');
        })
      Button('delete the first one')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.delete(0);
        })
      Child()
    }
    .width('100%')
  }
}

@ComponentV2
struct Child {
  @Consumer() message: Map<number, string> = new Map([[0, 'd'], [1, 'e'], [3, 'f']]);

  build() {
    Column() {
      Text('Child')
        .fontSize(20)
        .margin(5)
      ForEach(Array.from(this.message.entries()), (item: [number, string]) => {
        Text(`${item[0]}`)
          .fontSize(20)
        Text(`${item[1]}`)
          .fontSize(20)
        Divider()
      })
      // message被@Consumer装饰，可以被观察到Map整体的赋值以及调用Map接口带来的变化
      Button('init map')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message = new Map([[0, 'dd'], [1, 'ee'], [3, 'ff']]);
        })
      Button('set new one')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.set(4, 'g');
        })
      Button('clear')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.clear();
        })
      Button('replace the first one')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.set(0, 'a*');
        })
      Button('delete the first one')
        .width(300)
        .margin(5)
        .onClick(() => {
          this.message.delete(0);
        })
    }
    .width('100%')
  }
}
// [End Decorative_Map]

@Component
export struct DecorativeMap {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Parent()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Decorative_Map'))
  }
}