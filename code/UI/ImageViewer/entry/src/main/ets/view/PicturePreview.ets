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

import { CommonLazyDataSourceModel } from '../model/CommonLazyDataSourceModel';
import { windowSizeManager } from '../utils/Managers';
import { PicturePreviewImage } from './PicturePreviewImage';
import { window } from '@kit.ArkUI';


/**
 * 使用图片预览组件样例
 *
 * 核心组件:
 * 一. PicturePreview
 * 二. PicturePreviewImage
 *
 * 实现步骤:
 * 一、PicturePreview
 * - 1. 使用 List 来使用多图片的移动和展示
 * - 2. 当图片处于边缘位置可以通过 ListScroller 来进行图片预览的位移
 *
 * 二、PicturePreviewImage
 * - 1. 使用matrix实现图片的缩放
 * - 2. 使用offset实现组件的偏移
 * - 3. 提前计算图片属性以便对组件属性进行设置
 * - 4. Image.objectFile使用Cover以便图片能够超出其父组件显示（而不撑大父组件）
 *
 * @param { Axis } [listDirection] - 图片预览的主轴方向， 默认水平滑动
 * @param { string[] } imageList - 图片数据列表
 */
@Component
export struct PicturePreview {
  // 滑动方向
  @Prop listDirection: Axis = Axis.Vertical;
  // 外部传入的图片数据
  @Link @Watch('getListMaxLength') imageList: string[];
  // 背景颜色
  @State listBGColor: Color = Color.White;
  // 图片懒加载数据源
  @State lazyImageList: CommonLazyDataSourceModel<string> = new CommonLazyDataSourceModel();
  // 当前视图下标
  private listIndex: number = 0;
  // 图片数量
  private listMaxLength: number = 0;
  // list 滑动控制器
  private listScroll: ListScroller = new ListScroller();
  // list间距
  private listSpace: number = 10;
  // list滑动动画时长
  private listAnimationDuration: number = 500;

  // 获取图片数量和设置懒加载图片数据
  getListMaxLength() {
    this.listMaxLength = this.imageList.length;
    this.lazyImageList.clearAndPushAll(this.imageList);
  }

  // 改变偏移量
  setListOffset = (offset: number, animationDuration: number = 0) => {
    const WIN_SIZE :window.Size= windowSizeManager.get();
    let principalAxisSize:number = this.listDirection === Axis.Horizontal ? WIN_SIZE.width : WIN_SIZE.height;
    let principalAxisOffset :number= principalAxisSize * this.listIndex;
    let space :number= this.listSpace * this.listIndex;
    principalAxisOffset = principalAxisOffset + space;
    let calculatedOffset :number= offset + principalAxisOffset;
    this.listScroll.scrollTo({
      yOffset: this.listDirection === Axis.Horizontal ? 0 : calculatedOffset,
      xOffset: this.listDirection === Axis.Horizontal ? calculatedOffset : 0,
      animation: {
        duration: animationDuration
      }
    })
  }
  // 改变到具体页面
  setListToIndex = (index: number) => {
    const WIN_SIZE :window.Size= windowSizeManager.get();
    let nIndex :number= index;
    if (nIndex < 0) {
      nIndex = 0;
    } else if (nIndex >= this.listMaxLength) {
      nIndex = this.listMaxLength - 1;
    }
    this.listIndex = nIndex;
    let principalAxisSize :number= this.listDirection === Axis.Horizontal ? WIN_SIZE.width : WIN_SIZE.height;
    let calculatedOffset :number= Math.abs(nIndex * principalAxisSize) + this.listSpace * nIndex;
    this.listScroll.scrollTo({
      yOffset: this.listDirection === Axis.Horizontal ? 0 : calculatedOffset,
      xOffset: this.listDirection === Axis.Horizontal ? calculatedOffset : 0,
      animation: {
        duration: this.listAnimationDuration
      }
    })
  }

  /**
   * 初始化数据源
   */
  aboutToAppear(): void {
    this.getListMaxLength();
  }

  build() {
    NavDestination() {
      List({ scroller: this.listScroll, space: this.listSpace }) {
        LazyForEach(this.lazyImageList, (imageUrl: string, index: number) => {
          ListItem() {
            PicturePreviewImage({
              imageUrl: imageUrl,
              listDirection: this.listDirection,
              setListOffset: this.setListOffset,
              setListToIndex: this.setListToIndex,
              imageIndex: index,
              imageMaxLength: this.listMaxLength,
              listBGColor: this.listBGColor
            })
          }
          .width($r('app.string.imageviewer_full_size'))
        })
      }
      .enableScrollInteraction(false) // PicturePreviewImage中根据自定义手势控制滑动，需要禁止List本身的滑动，否则会出现滑动冲突
      .scrollSnapAlign(ScrollSnapAlign.START)
      .width($r('app.string.imageviewer_full_size'))
      .height($r('app.string.imageviewer_full_size'))
      .cachedCount(1)
      .listDirection(this.listDirection)
      .scrollBar(BarState.Off)
      .backgroundColor(this.listBGColor)
      .onClick(() => {
        this.listBGColor = this.listBGColor === Color.White ? Color.Black : Color.White;
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      // 注意：边框不可去除,这一步是为了防止鸿蒙定位Y轴上移,等待华为修复
      .borderWidth(1)
      .borderColor(Color.Transparent)
    }
    .hideTitleBar(true)
  }
}

