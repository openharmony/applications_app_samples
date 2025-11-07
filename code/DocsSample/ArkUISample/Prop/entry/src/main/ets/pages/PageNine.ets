/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
class Son {
  public title: string;
  constructor(title: string) {
    this.title = title;
  }
}

@Observed
class Father {
  public name: string;
  public son: Son;
  constructor(name: string, son: Son) {
    this.name = name;
    this.son = son;
  }
}
// [Start prop_nine_start]
@Entry
@Component
struct Person {
  @State person: Father = new Father('Hello', new Son('world'));

  build() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Button('change Father name')
          .width(312)
          .height(40)
          .margin(12)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.person.name = 'Hi';
          })
        Button('change Son title')
          .width(312)
          .height(40)
          .margin(12)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.person.son.title = 'ArkUI';
          })
        Text(this.person.name)
          .fontSize(16)
          .margin(12)
          .width(312)
          .height(40)
          .backgroundColor('#ededed')
          .borderRadius(20)
          .textAlign(TextAlign.Center)
          .fontColor('#e6000000')
          .onClick(() => {
            this.person.name = 'Bye';
          })
        Text(this.person.son.title)
          .fontSize(16)
          .margin(12)
          .width(312)
          .height(40)
          .backgroundColor('#ededed')
          .borderRadius(20)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.person.son.title = 'openHarmony';
          })
        Child({ child: this.person.son })
      }
    }
  }
}


@Component
struct Child {
  @Prop child: Son = new Son('');

  build() {
    Column() {
      Text(this.child.title)
        .fontSize(16)
        .margin(12)
        .width(312)
        .height(40)
        .backgroundColor('#ededed')
        .borderRadius(20)
        .textAlign(TextAlign.Center)
        .onClick(() => {
          this.child.title = 'Bye Bye';
        })
    }
  }
}
// [End prop_nine_start]

@Builder
export function MyPersonBuilder(){
  Person()
}