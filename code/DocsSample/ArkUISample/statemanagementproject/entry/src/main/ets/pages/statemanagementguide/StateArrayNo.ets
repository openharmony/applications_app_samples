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
// [Start StateArrayNo_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[EvtryAblity]';

@Observed
class Child8 {
  public count: number;

  constructor(count: number) {
    this.count = count
  }
}

@Observed
class ChildList extends Array<Child8> {
};

@Observed
class Ancestor {
  public childList: ChildList;

  constructor(childList: ChildList) {
    this.childList = childList;
  }

  public loadData() {
    let tempList = new ChildList();
    for (let i = 1; i < 6; i++) {
      tempList.push(new Child8(i));
    }
    this.childList = tempList;
  }

  public clearData() {
    this.childList = []
  }
}

@Component
struct CompChild8 {
  @Link childList: ChildList;
  @ObjectLink Child8: Child8;

  build() {
    Row() {
      Text(this.Child8.count + '')
        .height(70)
        .fontSize(20)
        .borderRadius({
          topLeft: 6,
          topRight: 6
        })
        .margin({ left: 50 })
      Button('X')
        .backgroundColor(Color.Red)
        .onClick(() => {
          let index = this.childList.findIndex((item) => {
            return item.count === this.Child8.count
          })
          if (index !== -1) {
            this.childList.splice(index, 1);
          }
        })
        .margin({
          left: 200,
          right: 30
        })
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
struct CompList8 {
  @ObjectLink @Watch('changeChildList') childList: ChildList;

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
        ForEach(this.childList, (item: Child8, index) => {
          ListItem() {
            CompChild8({
              childList: this.childList,
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
struct Ancestor8 {
  @ObjectLink ancestor: Ancestor;

  build() {
    Column() {
      CompList8({ childList: this.ancestor.childList })
      Row() {
        Button('Clear')
          .onClick(() => {
            this.ancestor.clearData()
          })
          .width(100)
          .margin({ right: 50 })
        Button('Recover')
          .onClick(() => {
            this.ancestor.loadData()
          })
          .width(100)
      }
    }
  }
}

@Entry
@Component
struct Page8 {
  @State childList: ChildList = [new Child8(1), new Child8(2), new Child8(3), new Child8(4), new Child8(5)];
  @State ancestor: Ancestor = new Ancestor(this.childList)
  build() {
    Column() {
      Ancestor8({ ancestor: this.ancestor })
    }
  }
}
// [End StateArrayNo_start]