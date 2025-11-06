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
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[Sample_StateManagement]';

@Observed
class Child8 {
  public count: number;

  constructor(count: number) {
    this.count = count
  }
}

@Observed
class ChildList8 extends Array<Child8> {
  constructor(children?: Child8[]) {
    super();
    if (children) {
      this.push(...children);
    }
  }
}

@Observed
class Ancestor8 {
  public childList: ChildList8;
  constructor(childList: ChildList8) {
    this.childList = childList;
  }

  public loadData() {
    let tempList =
      new ChildList8([new Child8(1), new Child8(2), new Child8(3),
        new Child8(4), new Child8(5)]);
    this.childList = tempList;
  }

  public clearData() {
    this.childList = new ChildList8();
  }
}

@Component
struct StateArrayInit {
  @Link childList: ChildList8;
  @ObjectLink Child8: Child8;

  build() {
    Row() {
      Text(this.Child8.count + '')
        .height(70)
        .fontSize(20)
        .borderRadius({ topLeft: 6, topRight: 6 })
        .margin({ left: 50 })
      Button('X')
        .id('X')
        .backgroundColor(Color.Red)
        .onClick(() => {
          let index = this.childList.findIndex((item) => {
            return item.count === this.Child8.count
          })
          if (index !== -1) {
            this.childList.splice(index, 1);
          }
        })
        .margin({ left: 200, right: 30 })
    }
    .margin({
      top: 15,
      left: 15,
      right: 10,
      bottom: 15
    })
    .borderRadius(6)
    .backgroundColor(Color.Grey)
  }
}

@Component
struct StateArrayInitCompList {
  @ObjectLink @Watch('changeChildList') Child8List: ChildList8;

  changeChildList() {
    hilog.info(DOMAIN_NUMBER, TAG, 'CompList ChildList change');
  }

  isRenderCompChild(index: number): number {
    hilog.info(DOMAIN_NUMBER, TAG, 'Comp Child is render' + index);
    return 1;
  }

  build() {
    Column() {
      List() {
        ForEach(this.Child8List, (item: Child8, index) => {
          ListItem() {
            StateArrayInit({
              childList: this.Child8List,
              Child8: item
            })
              .opacity(this.isRenderCompChild(index))
          }
        })
      }
      .height('70%')
    }
  }
}

@Component
struct StateArrayInitCompAncestor {
  @ObjectLink Ancestor8: Ancestor8;

  build() {
    Column() {
      StateArrayInitCompList({ Child8List: this.Ancestor8.childList })
      Row() {
        Button('Clear')
          .onClick(() => {
            this.Ancestor8.clearData()
          })
          .width(100)
          .margin({ right: 50 })
        Button('Recover')
          .onClick(() => {
            this.Ancestor8.loadData()
          })
          .width(100)
      }
    }
  }
}

@Entry
@Component
struct StateArrayInitPage {
  // [Start StateArrayInit_start]
  @State childList: ChildList8 =
    new ChildList8([new Child8(1), new Child8(2), new Child8(3),
      new Child8(4), new Child8(5)]);
  @State ancestor: Ancestor8 = new Ancestor8(this.childList)
  // [End StateArrayInit_start]
  build() {
    Column() {
      StateArrayInitCompAncestor({ Ancestor8: this.ancestor })
    }
  }
}