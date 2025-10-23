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
import { curves, AnimatorResult } from '@kit.ArkUI';

// 该接口控制列表项视觉属性
class ListItemModify implements AttributeModifier<ListItemAttribute> {
  public offsetY: number = 0;

  applyNormalAttribute(instance: ListItemAttribute): void {
    instance.translate({ y: this.offsetY }) // Y轴位移
  }
}

@Observed
class DragSortCtrl<T> {
  private arr: Array<T>
  private modify: Array<ListItemModify>
  private uiContext: UIContext; // 新增UIContext成员
  private dragRefOffset: number = 0
  offsetY: number = 0
  private ITEM_INTV: number = 0

  constructor(arr: Array<T>, intv: number, uiContext: UIContext) {
    this.arr = arr;
    this.uiContext = uiContext;
    this.modify = []
    this.ITEM_INTV = intv
    arr.forEach(() => {
      this.modify.push(new ListItemModify())
    })
  }

  itemMove(index: number, newIndex: number): void {
    let tmp = this.arr.splice(index, 1) // 移除当前传入的index
    this.arr.splice(newIndex, 0, tmp[0]) // 将当前移除的index插入到数组前一个位置
    let tmp2 = this.modify.splice(index, 1)
    this.modify.splice(newIndex, 0, tmp2[0])
  }

  setDragRef(item: T): void {
    this.dragRefOffset = 0
  }

  onMove(item: T, offset: number) {
    this.offsetY = offset - this.dragRefOffset // 逐帧计算传入的offect，每满足一个item高度时，进入下方if逻辑，更新dragRefOffset的值
    let index = this.arr.indexOf(item) // 在数组中查找传入的item
    this.modify[index].offsetY = this.offsetY
    if (this.offsetY < -this.ITEM_INTV / 2) { // 通过判断使指定的item逐一移动到首位
      // 使用interpolatingSpring曲线生成弹簧动画
      this.uiContext.animateTo({ curve: curves.interpolatingSpring(0, 1, 400, 38) }, () => {
        this.offsetY += this.ITEM_INTV // 调整偏移量实现平滑移动
        this.dragRefOffset -= this.ITEM_INTV // 移动的总偏移量
        console.info(`item offsetY ${this.offsetY} dragRefOffset ${this.dragRefOffset}`);
        this.itemMove(index, index - 1) // 执行列表项位置交换
      })
    }
  }

  getModify(item: T): ListItemModify {
    let index = this.arr.indexOf(item)
    return this.modify[index]
  }
}

@Entry
@Component
struct ListAutoSortExample {
  @State private arr: Array<number> = [0, 1, 2, 3, 4, 5]
  @State dragSortCtrl: DragSortCtrl<number> = new DragSortCtrl<number>(this.arr, 120, this.getUIContext())
  @State firstListItemGroupCount: number = 3
  private listScroll: ListScroller = new ListScroller()
  private backAnimator: AnimatorResult | null = null

  @Builder
  itemEnd(item: number, index: number) {
    Row() {
      Button('To TOP').margin('4vp').onClick(() => {
        console.info(`item number item ${item} index ${index}`);
        this.listScroll.closeAllSwipeActions({
          onFinish: () => {
            this.dragSortCtrl.setDragRef(item)
            let length = 120 * (this.arr.indexOf(item))
            this.backAnimator = this.getUIContext()?.createAnimator({ // 创建弹簧动画
              duration: 1000,
              easing: 'interpolating-spring(0, 1, 150, 24)',
              delay: 0,
              fill: 'none',
              direction: 'normal',
              iterations: 1,
              begin: 0,
              end: -length
            })
            this.backAnimator.onFrame = (value) => { // 逐帧回调更新位置
              this.dragSortCtrl.onMove(item, value) // 处理list的移动替换动效
            }
            this.backAnimator.onFinish = () => {}
            this.backAnimator.play() // 启动动画
          }
        })
      })
    }.padding('4vp').justifyContent(FlexAlign.SpaceEvenly)
  }

  @Builder
  header(title: string) {
    Row() {
      Text(title)
    }
  }

  build() {
    Row() {
      Column() {
        List({ space: 20, scroller: this.listScroll }) {
          ListItemGroup({ header: this.header('first ListItemGroup'), space: 20 }) {
            ForEach(this.arr, (item: number, index) => {
              if (index < this.firstListItemGroupCount) {
                ListItem() {
                  Text('' + item)
                    .width('100%')
                    .height(100)
                    .fontSize(16)
                    .borderRadius(10)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(0xFFFFFF)
                }
                .swipeAction({
                  end: this.itemEnd(item, index)
                })
                .clip(true)
                .attributeModifier(this.dragSortCtrl.getModify(item)) // 动态设置属性修改
                .borderRadius(10)
                .margin({ left: 20, right: 20 })
              }
            })
          }
          ListItemGroup({ header: this.header('second ListItemGroup'), space: 20 }) {
            ForEach(this.arr, (item: number, index) => {
              if (index > this.firstListItemGroupCount - 1) {
                ListItem() {
                  Text('' + item)
                    .width('100%')
                    .height(100)
                    .fontSize(16)
                    .borderRadius(10)
                    .textAlign(TextAlign.Center)
                    .backgroundColor(0xFFFFFF)
                }
                .swipeAction({
                  end: this.itemEnd(item, index)
                })
                .clip(true)
                .attributeModifier(this.dragSortCtrl.getModify(item))
                .borderRadius(10)
                .margin({ left: 20, right: 20 })
              }
            })
          }
        }
        .padding({ top: 20 })
        .height('100%')
      }
    }.backgroundColor(0xDCDCDC)
  }
}