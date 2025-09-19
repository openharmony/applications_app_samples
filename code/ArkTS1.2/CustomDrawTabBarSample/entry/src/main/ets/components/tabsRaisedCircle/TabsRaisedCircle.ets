'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import {
  Builder,
  Text,
  Column,
  Component,
  FlexAlign,
  ImageInterpolation,
  ForEach,
  Image,
  Resource,
  Position,
  HorizontalAlign,
  RelativeContainer,
  Color
} from '@ohos.arkui.component';
import { State, Link, Watch, PropRef } from '@ohos.arkui.stateManagement';
import componentUtils from '@ohos.arkui.componentUtils';
import inspector from '@ohos.arkui.inspector';
import hilog from '@ohos.hilog';
import { ChamferInfo } from '../../utils/CircleClass';
import { TabMenusInterfaceIRequired } from '../../types/TabMenusInterface';
import { TabsRaisedCircleSelect } from './TabsRaisedCircleSelect';
import { tabsDimensions } from '../../mock/TabsDimensions';
import { getImageUrl } from '../../utils/Functions';

@Component
export struct TabsRaisedCircle {
  // 当前选中项
  @Link @Watch('getAnimateSelectIndex') selectIndex: number;
  // 用于指定动画的当前选中项
  @State animateSelectIndex: number = 0;
  // 选项数据集合
  @Link tabsMenu: TabMenusInterfaceIRequired[];
  // Tabs 高度
  @PropRef tabHeight: number = 60;
  // 图片宽高
  @State imageWH: number = 33;
  // 动画执行时长
  @State animateTime: number = 1000;
  // 图片选中偏移量
  @State imageOffsetY: number = 20;
  // tabs id
  @State tabsId: string = 'bugle_tabBar';
  // 选中中间球 -- id
  @State selectBodyId: string = `ball`;
  // 选中球填充色
  @PropRef tabsSelectBgColor: string = 'rgba(92, 187, 183,1)';
  // 背景色
  @PropRef tabsBgColor: Color = Color.White;
  // 凸圆信息
  @State chamfer: ChamferInfo | undefined = undefined;
  // 每个选项 id 的前缀
  @State tabItemId: string = `nu_tabItem_${new Date().getTime()}_`;
  // 每个选项中 image 的前缀
  @State selectImageId: string = `nu_tabItemSelectImage_${new Date().getTime()}_`;

  /**
   * 获取动画控制的下标
   * 用于切换选项时，先让标签回到底部，然后让当前选项在上移
   */
  getAnimateSelectIndex(p: string) {
    // 动画等待时间 - 用于等待上一个选项动画结束
    let animateDelay = 500;
    this.getUIContext()?.animateTo({
      duration: this.animateTime,
      delay: animateDelay
    }, () => {
      this.animateSelectIndex = this.selectIndex;
    })
  }
  /**
   * 获取 tabs 尺寸信息
   */
  getChamfer() {
    let modePosition: componentUtils.ComponentInfo = tabsDimensions;
    if (modePosition.size) {
      this.chamfer = new ChamferInfo(modePosition, this.tabsMenu.length);
    }
  }

  aboutToAppear(): void{
    this.getChamfer();
    this.animateSelectIndex = this.selectIndex;
  }

  build() {
    RelativeContainer() {
      // 每个选项
      ForEach(this.tabsMenu, (item: TabMenusInterfaceIRequired, index: number) => {
        this.TabItem(item, index)
      })
      // 选中时候的 球
      if (this.chamfer) {
        TabsRaisedCircleSelect({
          tabHeight: this.tabHeight,
          selectIndex: this.selectIndex,
          chamfer: this.chamfer!,
          selectBodyId: this.selectBodyId,
          tabItemId: this.tabItemId,
          tabsBgColor: this.tabsBgColor,
          tabsSelectBgColor: this.tabsSelectBgColor,
        })
      }
    }
    .width('100%')
    .height(this.tabHeight)
    .backgroundColor(this.tabsBgColor)
    .id(this.tabsId)
  }

  /**
   * 每个选项的样式
   * @param { TabMenusInterfaceIRequired } item - 选项的数据
   * @param { number } index - 下标
   */
  @Builder
  TabItem(item: TabMenusInterfaceIRequired, index: number) {
    Column() {
      if (item.image && this.chamfer) {
        Image((getImageUrl(item as TabMenusInterfaceIRequired, index, this.selectIndex)) as Resource)
          .size({
            width: this.chamfer!.circleDiameter / 2,
            height: this.chamfer!.circleDiameter / 2
          })
          .interpolation(ImageInterpolation.High)
          .offset({
            y: this.selectIndex === index && this.animateSelectIndex === index ? -10 : 0,
          } as Position)
          .id(`${this.selectImageId}${index}`)
      }
      Text(item.text)
    }
    .onClick(() => {
      this.getUIContext()?.animateTo({
        duration: this.animateTime,
      }, () => {
        this.selectIndex = index
      })
    })
    .width(100 / this.tabsMenu.length + '%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .id(`${this.tabItemId}${index}`)
    .alignRules({
      'left': {
        'anchor': index === 0 ? '__container__': `${this.tabItemId}${index - 1}`,
        'align': index === 0 ? HorizontalAlign.Start : HorizontalAlign.End
      }
    })
  }
}