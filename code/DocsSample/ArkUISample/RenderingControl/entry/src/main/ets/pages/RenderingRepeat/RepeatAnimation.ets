/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start repeat_animation]

@Entry
@ComponentV2
struct RepeatAnimationDemo {
  @Local dataArray: ItemInfo[] = [];
  private count: number = 0;

  aboutToAppear(): void {
    for (let i = 0; i < 5; i++) {
      this.dataArray.push(new ItemInfo(`Item ${i}`, `#FFFFFF`));
    }
  }

  build() {
    Column({ space: 5 }) {
      Row({ space: 5 }) {
        Button('Add')
          .onClick(() => {
            // 为插入子组件设置动画
            this.getUIContext()?.animateTo({ duration: 1000 }, () => {
              this.dataArray.splice(0, 0, new ItemInfo(`New item ${this.count++}`, `#FFFFFF`))
            })
          })
        Button('Delete')
          .onClick(() => {
            // 为删除子组件设置动画
            this.getUIContext()?.animateTo({ duration: 1000 }, () => {
              this.dataArray.splice(0, 1)
            })
          })
        Button('Exchange')
          .onClick(() => {
            // 为交换子组件设置动画
            this.getUIContext()?.animateTo({ duration: 1000 }, () => {
              let temp = this.dataArray[1];
              this.dataArray[1] = this.dataArray[0]
              this.dataArray[0] = temp;
            })
          })
        Button('Update')
          .onClick(() => {
            // 为更新子组件设置动画
            this.getUIContext()?.animateTo({ duration: 1000 }, () => {
              this.dataArray[0].info = 'Item updated';
              this.dataArray[0].color = '#86C5E3';
            })
          })
      }
      List({ space: 5 }) {
        Repeat(this.dataArray)
          .each((repeatItem) => {
            ListItem() {
              Text(repeatItem.item.info)
            }
            .backgroundColor(repeatItem.item.color)
            .width(150)
            .height(50)
            .border({ width: 1 })
            // 设置子组件插入和删除时的过渡效果
            .transition(TransitionEffect.translate({ x: 300 }))
          })
          .key((item: ItemInfo, index: number) => item.key)
          .virtualScroll()
      }
      .alignListItem(ListItemAlign.Center)
    }
    .width('100%')
  }
}

@ObservedV2
class ItemInfo {
  @Trace public info: string;
  @Trace public color: string;
  public key: string;
  constructor(info: string, color: string) {
    this.info = info;
    this.color = color;
    this.key = info;
  }
}

// [End repeat_animation]