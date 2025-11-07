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
class Child6 {
  public count: number;
  constructor(count: number) {
    this.count = count
  }
}

@Observed
class ChildList6 extends Array<Child6> {
}

@Observed
class Ancestor6 {
  public childList: ChildList6;

  constructor(childList: ChildList6) {
    this.childList = childList;
  }

  public loadData() {
    let tempList = [new Child6(1), new Child6(2), new Child6(3), new Child6(4), new Child6(5)];
    this.childList = tempList;
  }

  public clearData() {
    this.childList = []
  }
}

@Component
struct CompChild6 {
  @Link childList: ChildList6;
  @ObjectLink child: Child6;

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
            return item.count === this.child.count
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
struct CompList6 {
  @ObjectLink @Watch('changeChildList') ChildList6: ChildList6;

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
        ForEach(this.ChildList6, (item: Child6, index) => {
          ListItem() {
            CompChild6({
              childList: this.ChildList6,
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
struct CompAncestor6 {
  @ObjectLink Ancestor6: Ancestor6;

  build() {
    Column() {
      CompList6({ ChildList6: this.Ancestor6.childList })
      Row() {
        Button('Clear')
          .onClick(() => {
            this.Ancestor6.clearData()
          })
          .width(100)
          .margin({ right: 50 })
        Button('Recover')
          .onClick(() => {
            this.Ancestor6.loadData()
          })
          .width(100)
      }
    }
  }
}

@Entry
@Component
struct Page6 {
  @State childList: ChildList6 = [new Child6(1), new Child6(2), new Child6(3), new Child6(4), new Child6(5)];
  @State ancestor: Ancestor6 = new Ancestor6(this.childList)

  build() {
    Column() {
      CompAncestor6({ Ancestor6: this.ancestor })
    }
  }
}
// [End StateArrayObserve_start]