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

// [Start PhotoPickerComponent_drawer]
import { display } from '@kit.ArkUI';
import { PhotoPickerComponent, PickerController, PickerOptions } from '@kit.MediaLibraryKit';
const enum DrawerState {
  Expanding,
  Collapsing,
  Sliding
}

@Entry
@Component
struct Drawer {
  @State pickerController: PickerController = new PickerController();
  private pickerOptions: PickerOptions = new PickerOptions();
  // 屏幕高度。
  @State screenHeight: number = 0;
  // 抽屉高度。
  @State drawerHeight: number = 0;
  // 抽屉的偏移量。
  @State offsetY: number = 0;
  // 抽屉状态。
  @State isExpanded: boolean = false;
  // 拖拽起始位置。
  private startY: number = 0;
  // 当前拖拽的偏移量。
  private currentOffset: number = 0;
  // 自定义抽屉高度在整个屏幕的占比。
  private drawerRation: number = 0.8;
  // 初始化为收缩态。
  private drawerState: DrawerState = DrawerState.Collapsing;
  // 手势响应阈值，判断手势是否是向下。
  private pulligDownThreshold: number = -5;

  aboutToAppear(): void {
    // 获取屏幕高度。
    this.screenHeight = px2vp(display.getDefaultDisplaySync().height);
    // 获取抽屉高度。
    this.drawerHeight = this.screenHeight * this.drawerRation;
    // 初始时抽屉在底部（隐藏高度）。
    this.offsetY = this.drawerHeight * 0.8;
    // 初始化时picker不支持滚动。
    this.pickerOptions.isSlidingSupported = false;
    // 无边缘回弹。
    this.pickerOptions.edgeEffect = EdgeEffect.None;
    // 不展示搜索框。
    this.pickerOptions.isSearchSupported = false;
  }

  private scrollStopAtStart() {
    // 状态变更为展开态，同时设置宫格不能滚动。
    this.drawerState = DrawerState.Expanding;
    this.pickerController.updatePickerOptions({
    isSlidingSupported: false
  })
  }

  private toggleDrawer() {
    if (this.isExpanded) {
      this.hideDrawer();
    } else {
      this.showDrawer();
    }
  }

  private hideDrawer() {
    animateTo({
      duration: 300,
      curve: Curve.EaseOut,
      onFinish: () => {
        this.isExpanded = false;
      }
    }, () => {
      this.drawerState = DrawerState.Collapsing;
      this.offsetY = this.drawerHeight * 0.8;
    })
  }

  private showDrawer() {
    animateTo({
      duration: 300,
      curve: Curve.EaseOut,
      onFinish: () => {
        this.isExpanded = true;
      }
    }, () => {
      this.drawerState = DrawerState.Expanding;
      this.offsetY = 0;
    })
  }

  build() {
    RelativeContainer() {
      // 主内容区域。
      Column() {
        Text('主页面内容')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 20 })

        Text('这是一个使用RelativeContainer实现的底部抽屉效果')
          .fontSize(16)
          .fontColor('#666')
          .margin({ bottom: 30 })
          .textAlign(TextAlign.Center)
          .width('80%')

        Button(this.isExpanded ? '收起抽屉' : '展开抽屉')
          .onClick(() => {
            this.toggleDrawer();
          })
      }
      .width('100%')
      .padding(20)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor('#f5f5f5')
      .borderRadius(10)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
      })
      .height('100%')

      if (this.isExpanded) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#80000000')
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
            right: { anchor: '__container__', align: HorizontalAlign.End },
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          })
          .onClick(() => {
            this.hideDrawer();
          })
      }

      Column() {
        Row()
          .width(50)
          .height(5)
          .backgroundColor('#CCC')
          .borderRadius(3)
          .margin({ top: 12, bottom: 8 })

        Text('抽屉菜单')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 10 })

        Divider()
          .width('90%')
          .margin({ bottom: 10 })

        PhotoPickerComponent({
          pickerOptions: this.pickerOptions,
          pickerController: this.pickerController,
          onScrollStopAtStart: this.scrollStopAtStart
        })
          .layoutWeight(1)
          .width('100%')
      }
      .width('100%')
      .height(this.drawerHeight)
      .backgroundColor(Color.White)
      .borderRadius({ topLeft: 20, topRight: 20 })
      .shadow({ radius: 10, color: '#33000000' })
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      })
      .translate({ y: this.offsetY })
      .gesture(
        PanGesture({ direction: PanDirection.Vertical })
          // 记录开始拖拽的位置。
          .onActionStart((event: GestureEvent) => {
            this.startY = event.fingerList[0].globalY || 0;
            this.currentOffset = this.offsetY;
          })
          .onActionUpdate((event: GestureEvent) => {
            // 如果是picker滑动状态，不改变抽屉的高度，直接返回。
            if (this.drawerState === DrawerState.Sliding) {
              return;
            }
            // 如果是展开态或者收缩态则需要通过手势来改变状态。
            // 计算移动距离。
            const deltaY = event.fingerList[0].globalY - this.startY || 0;
            // 展开态且向下滑动，那么屏蔽宫格的滑动且状态置为滚动态。
            if (this.drawerState === DrawerState.Expanding && deltaY < this.pulligDownThreshold) {
              this.pickerController.updatePickerOptions({
                isSlidingSupported: true
              })
              this.drawerState = DrawerState.Sliding
            }
            let newOffset = this.currentOffset + deltaY;
            if (newOffset < 0) {
              newOffset = 0;
            }
            this.offsetY = newOffset;
          })
          .onActionEnd(()=>{
            // 手势结束，根据位置自动展开或收起。
            if (this.offsetY > this.drawerHeight / 2) {
              // 滑动超过抽屉一半，收缩态。
              this.hideDrawer();
            } else {
              // 滑动不到抽屉一半，展开态。
              this.showDrawer();
            }
          })
      )
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#E0E0E0')
  }
}
// [ENd PhotoPickerComponent_drawer]