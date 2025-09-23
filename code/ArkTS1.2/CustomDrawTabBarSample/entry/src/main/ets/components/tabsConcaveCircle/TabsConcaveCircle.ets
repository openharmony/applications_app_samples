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
  Text,
  Column,
  Component,
  TextAlign,
  FlexAlign,
  TextOverflow,
  ImageInterpolation,
  Row,
  Image,
  Stack,
  ForEach,
  Resource,
  Position,
  RenderingContextSettings,
  CanvasRenderingContext2D,
  Canvas,
  Color,
  ClickEvent
} from '@ohos.arkui.component';
import { State, Link, Watch, PropRef } from '@ohos.arkui.stateManagement';
import { AnimatorResult, SimpleAnimatorOptions } from '@ohos.animator'
import inspector from '@ohos.arkui.inspector';
import hilog from '@ohos.hilog';
import { CanvasClipGroove, CanvasCreateRectangle, getImageUrl } from '../../utils/Functions';
import { TabMenusInterfaceIRequired } from '../../types/TabMenusInterface';
import { ConcaveCircle } from '../../utils/CircleClass';

@Component
export struct TabsConcaveCircle {
  // 当前选中项
  @Link @Watch('getAnimateSelectIndex') selectIndex: number;
  // 用于指定动画的当前选中项
  @State animateSelectIndex: number = 0;
  // 选项数据集合
  @Link tabsMenu: TabMenusInterfaceIRequired[];
  // Tabs 高度
  @PropRef tabHeight: number = 60;
  // 图片宽高
  @State imageWH: number = 0;
  // 动画执行时长
  @State animateTime: number = 1000;
  // 图片选中偏移量
  @State imageOffsetY: number = 21;
  // 背景色
  @PropRef tabsBgColor: string = 'rgb(255, 255, 255)';
  // 当前凹槽位置
  @State animationPositionX: number = 0;
  // 选中球填充色
  @PropRef tabsSelectBgColor: Color | number | string | Resource = 'rgba(92, 187, 183,1)';
  // 凹陷出凸起的悬浮球信息
  @State circleInfo: ConcaveCircle | undefined = undefined;
  // 获取第一份
  listener: inspector.ComponentObserver | undefined = undefined;
  @State concaveCircleId: string = `nu_concaveCircle_image_${new Date().getTime()}_`;
  // canvas 数据
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  // 动画
  private canvasAnimator: AnimatorResult | undefined = undefined;

  /**
   * 获取动画控制的下标
   * 用于切换选项时，先让标签回到底部，然后让当前选项在上移
   */
  getAnimateSelectIndex(p:string) {
    // 动画等待时间 - 用于等待上一个选项动画结束
    let animateDelay = 500;
    this.getUIContext()?.animateTo({
      duration: this.animateTime,
      delay: animateDelay
    }, () => {
      this.animateSelectIndex = this.selectIndex;
    })
    // 绘制canvas 用于兼容点击 凸起时，canvas 同时移动
    this.createAnimation()
  }

  /**
   * 创建移动动画
   * 用于移动圆球和重绘canvas中凹陷部分
   */
  createAnimation() {
    if (!this.circleInfo) {
      return;
    }
    this.canvasAnimator = this.getUIContext()?.createAnimator(
      new SimpleAnimatorOptions(this.animationPositionX, (this.circleInfo?.getMenuCenterX(this.selectIndex)) as number))
    this.canvasAnimator!.onFrame = (value: number) => {
      this.animationPositionX = value;
      this.circleInfo?.setPositionXY({ x: value - this.circleInfo!.circleRadius })
      this.createCanvas()
    }
    this.canvasAnimator!.play()
  }

  /**
   * 创建canvas 背景和凹槽
   */
  createCanvas() {
    if (this.circleInfo) {
      this.context.reset();
      CanvasCreateRectangle({
        context: this.context,
        tabsBgColor: this.tabsBgColor
      })
      CanvasClipGroove({
        context: this.context,
        menuLength: this.tabsMenu.length,
        center: this.animationPositionX,
      })
    }
  }

  /**
   * 初始化 canvas 数据
   */
  initCanvas() {
    this.circleInfo = new ConcaveCircle(this.context, this.tabsMenu.length);
    // 图片宽度比凹槽小取圆直径的 70%
    let ratio = 0.7;
    this.imageWH = this.circleInfo!.circleDiameter * ratio;
    this.createAnimation();
  }

  aboutToAppear(): void {
    this.animateSelectIndex = this.selectIndex;
  }

  build() {
    Stack() {
      // 背景 - 实现 凹槽 部分
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => this.initCanvas())
      // 凹槽 上方球体部分
      if (this.circleInfo) {
        Column()
          .width(this.circleInfo!.circleDiameter)
          .height(this.circleInfo!.circleDiameter)
          .borderRadius(this.circleInfo!.circleRadius)
          .backgroundColor(this.tabsSelectBgColor)
          .position({
            x: this.circleInfo!.positionX,
            y: this.circleInfo!.positionY
          } as Position)
          .id('ball')
      }
      // 菜单选项
      Row() {
        ForEach(this.tabsMenu, (item: TabMenusInterfaceIRequired, index: number) => {
          Column() {
            // 当具有图片时才显示图片
            if (item.image) {
              Image((getImageUrl(item as TabMenusInterfaceIRequired, index, this.selectIndex)) as Resource)
                .size({
                  width: this.imageWH,
                  height: this.imageWH,
                })
                .interpolation(ImageInterpolation.High)
                .offset({
                  y: this.selectIndex === index && this.animateSelectIndex === index ? -this.imageOffsetY : 0,
                } as Position)
                .id(`${this.concaveCircleId}${index}`)
            }
            // 菜单文字
            Text(item.text)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .textAlign(TextAlign.Center)
              .width('100%')
          }
          .onClick((e: ClickEvent) => {
            this.getUIContext()?.animateTo({
              duration: this.animateTime
            }, () => {
              this.selectIndex = index;
            })
            this.createAnimation();
          })
          .layoutWeight(1)
          .height('100%')
          .justifyContent(FlexAlign.Center)
        })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height(this.tabHeight)
    .id('concavity_tabBar')
  }
}
