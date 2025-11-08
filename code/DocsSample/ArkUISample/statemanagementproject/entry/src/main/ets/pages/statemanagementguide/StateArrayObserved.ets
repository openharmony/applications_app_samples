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
// [Start StateArrayObserve_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN_NUMBER: number = 0XFF00;
const TAG: string = '[Sample_StateManagement]';

@Observed
class Child {
  public count: number;
  constructor(count: number) {
    this.count = count;
  }
}

@Observed
class ChildList extends Array<Child> {
}

@Observed
class Ancestor {
  public childList: ChildList;

  constructor(childList: ChildList) {
    this.childList = childList;
  }

  public loadData() {
    let tempList = [new Child(1), new Child(2), new Child(3), new Child(4), new Child(5)];
    this.childList = tempList;
  }

  public clearData() {
    this.childList = [];
  }
}

@Component
struct CompChild {
  @Link childList: ChildList;
  @ObjectLink child: Child;

  build() {
    Row() {
      Text(this.child.count + '')
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
            return item.count === this.child.count;
          });
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
struct CompList {
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
        ForEach(this.childList, (item: Child, index) => {
          ListItem() {
            CompChild({
              childList: this.childList,
              child: item
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
struct CompAncestor {
  @ObjectLink ancestor: Ancestor;

  build() {
    Column() {
      CompList({ childList: this.ancestor.childList })
      Row() {
        Button('Clear')
          .onClick(() => {
            this.ancestor.clearData();
          })
          .width(100)
          .margin({ right: 50 })
        Button('Recover')
          .onClick(() => {
            this.ancestor.loadData();
          })
          .width(100)
      }
    }
  }
}

@Entry
@Component
struct Page {
  @State childList: ChildList = [new Child(1), new Child(2), new Child(3), new Child(4), new Child(5)];
  @State ancestor: Ancestor = new Ancestor(this.childList);

  build() {
    Column() {
      CompAncestor({ ancestor: this.ancestor })
    }
  }
}
// [End StateArrayObserve_start]
const stateArrayObservedPage = Page;
export default stateArrayObservedPage;