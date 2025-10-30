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
const TAG: string = '[EvtryAblity]';

@Observed
class StateArrayInitChild {
  public count: number;

  constructor(count: number) {
    this.count = count
  }
}

@Observed
class StateArrayInitChildList extends Array<StateArrayInitChild> {
  constructor(children?: StateArrayInitChild[]) {
    super();
    if (children) {
      this.push(...children);
    }
  }
}

@Observed
class StateArrayInitAncestor {
  public childList: StateArrayInitChildList;

  constructor(childList: StateArrayInitChildList) {
    this.childList = childList;
  }

  public loadData() {
    let tempList =
      new StateArrayInitChildList([new StateArrayInitChild(1), new StateArrayInitChild(2), new StateArrayInitChild(3),
        new StateArrayInitChild(4), new StateArrayInitChild(5)]);
    this.childList = tempList;
  }

  public clearData() {
    this.childList = new StateArrayInitChildList();
  }
}

@Component
struct StateArrayInit {
  @Link childList: StateArrayInitChildList;
  @ObjectLink stateArrayInitchild: StateArrayInitChild;

  build() {
    Row() {
      Text(this.stateArrayInitchild.count + '')
        .height(70)
        .fontSize(20)
        .borderRadius({ topLeft: 6, topRight: 6 })
        .margin({ left: 50 })
      Button('X')
        .id('X')
        .backgroundColor(Color.Red)
        .onClick(() => {
          let index = this.childList.findIndex((item) => {
            return item.count === this.stateArrayInitchild.count
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
  @ObjectLink @Watch('changeChildList') stateArrayInitchildList: StateArrayInitChildList;

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
        ForEach(this.stateArrayInitchildList, (item: StateArrayInitChild, index) => {
          ListItem() {
            StateArrayInit({
              childList: this.stateArrayInitchildList,
              stateArrayInitchild: item
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
  @ObjectLink stateArrayInitancestor: StateArrayInitAncestor;

  build() {
    Column() {
      StateArrayInitCompList({ stateArrayInitchildList: this.stateArrayInitancestor.childList })
      Row() {
        Button('Clear')
          .onClick(() => {
            this.stateArrayInitancestor.clearData()
          })
          .width(100)
          .margin({ right: 50 })
        Button('Recover')
          .onClick(() => {
            this.stateArrayInitancestor.loadData()
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
  @State childList: StateArrayInitChildList =
    new StateArrayInitChildList([new StateArrayInitChild(1), new StateArrayInitChild(2), new StateArrayInitChild(3),
      new StateArrayInitChild(4), new StateArrayInitChild(5)]);
  @State ancestor: StateArrayInitAncestor = new StateArrayInitAncestor(this.childList)
  // [End StateArrayInit_end]
  build() {
    Column() {
      StateArrayInitCompAncestor({ stateArrayInitancestor: this.ancestor })
    }
  }
}