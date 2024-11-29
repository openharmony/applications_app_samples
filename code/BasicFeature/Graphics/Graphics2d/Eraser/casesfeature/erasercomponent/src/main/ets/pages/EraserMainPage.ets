/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

/**
 * 实现步骤：
 * 1.创建MyRenderNode类来负责绘制路径，并定义其属性如路径对象、颜色混合模式和线宽以便动态修改。
 * 2.创建MyImageRenderNode类用于管理和记录画布上的图案变化，节点渲染时将属性pixelMapHistory栈顶的pixelMap绘制到画布上。
 * 3.定义MyNodeController类管理NodeContainer上节点的创建和删除。
 * 4.创建自定义节点容器组件NodeContainer，接收MyNodeController的实例，并通过设置blendMode属性创建离屏画布。
 * 5.设置NodeContainer组件的宽高为图片加载完成后实际内容区域的宽高，并通过相对容器布局的alignRules使NodeContainer与图片内容区域重叠，控制
 *   绘制区域。
 * 6.在NodeContainer组件的onAppear()生命周期中初始化创建和挂载一个MyImageRenderNode节点currentImageNode，作为绘图的基础层。
 * 7.创建状态变量isClear用于区分当前处于涂鸦还是橡皮擦模式，创建状态变量currentLineStrokeWidth用于设置当前绘制节点中画笔的线宽。
 * 8.在NodeContainer组件的onTouch回调函数中，处理手指按下、移动和抬起事件，以便在屏幕上绘制或擦除路径。
 * 9.手指按下时，如果是初次绘制，创建一个新的MyRenderNode节点存储到变量currentNodeDraw中，并将其挂载到根节点上，否则在currentNodeDraw中重
 *   新添加路径，最后根据isClear的值修改节点中的blendMode，控制画笔涂鸦和擦除。
 * 10.手指移动时，更新currentNodeDraw中的路径对象，并触发节点的重新渲染，绘制或擦除对应的移动轨迹。
 * 11.手指抬起时，通过组件截图功能获取当前NodeContainer上绘制结果的pixelMap，将其存入currentImageNode节点的历史记录栈pixelMapHistory中，
 *    并重新渲染currentImageNode节点。然后重置currentNodeDraw节点中的路径对象，并刷新currentNodeDraw。
 * 12.从历史记录栈pixelMapHistory中移除最近一次绘制的pixelMap，刷新currentImageNode节点实现撤销功能，移除的pixelMap放入缓存栈cacheStack
 *    中以备恢复时使用。
 * 13.从缓存栈cacheStack中取出栈顶的pixelMap，重新放入历史记录栈pixelMapHistory中，刷新currentImageNode节点恢复上次撤销之前的状态。
 */

import { componentSnapshot } from '@kit.ArkUI';
import { Constants } from '../constants/Contants';
import { drawing } from '@kit.ArkGraphics2D';
import { image } from '@kit.ImageKit';
import { MyImageRenderNode, MyNodeController, MyRenderNode } from '../model/RenderNodeModel';

@Component
export struct EraserMainPage {
  @State isClear: boolean = false; // 标记是否选中橡皮擦
  @State undoEnabled: boolean = false; // 标记是否可以撤销
  @State redoEnabled: boolean = false; // 标记是否可以恢复上次撤销
  @State currentLineStrokeWidth: number = Constants.INIT_LINE_STROKE_WIDTH; // 当前画笔线宽，初始值为40
  @State nodeContainerWidth: number = 0; // 绘制区域 NodeContainer 宽度
  @State nodeContainerHeight: number = 0; // 绘制区域 NodeContainer 高度
  private currentNodeDraw: MyRenderNode | null = null; // 当前正在绘制的节点，涂鸦和擦除都使用该节点进行绘制
  private currentImageNode: MyImageRenderNode | null = null; // 用于管理和绘制之前所有绘制结果的节点
  private myNodeController: MyNodeController = new MyNodeController(); // 初始化节点控制器
  private lineStrokeWidths: number[] = [20, 30, 40, 50, 60]; // 画笔可选择的线宽列表

  // 顶部撤销、恢复按钮模块
  @Builder
  topButtonLine() {
    Row() {
      Image($r('app.media.eraser_undo'))
        .fillColor(this.undoEnabled ? $r('app.color.eraser_top_button_enabled_color') :
        $r('app.color.eraser_top_button_disabled_color'))
        .width($r('app.integer.eraser_top_button_size'))
        .height($r('app.integer.eraser_top_button_size'))
        .enabled(this.undoEnabled)
        .onClick(() => {
          this.undo();
        })
      Image($r('app.media.eraser_redo'))
        .fillColor(this.redoEnabled ? $r('app.color.eraser_top_button_enabled_color') :
        $r('app.color.eraser_top_button_disabled_color'))
        .width($r('app.integer.eraser_top_button_size'))
        .height($r('app.integer.eraser_top_button_size'))
        .enabled(this.redoEnabled)
        .onClick(() => {
          this.redo();
        })
    }
    .width($r('app.string.eraser_full_size'))
    .height($r('app.integer.eraser_top_button_line_height'))
    .padding($r('app.integer.eraser_padding'))
    .backgroundColor($r('app.color.eraser_top_and_bottom_line_background_color'))
    .alignRules({
      top: { anchor: Constants.CONTAINER_ID, align: VerticalAlign.Top },
      left: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Start }
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .id(Constants.TOP_BUTTON_LINE_ID)
  }

  // 底部画笔编辑模块，用于切换涂鸦和橡皮擦选中状态，设置线宽
  @Builder
  bottomPenShape() {
    Row() {
      // 涂鸦按钮
      Column() {
        Image($r('app.media.eraser_screenshot_penshape'))
          .fillColor(this.isClear ? $r('app.color.eraser_unselected_color') : $r('app.color.eraser_selected_color'))
          .width($r('app.integer.eraser_pen_shape_icon_size'))
          .height($r('app.integer.eraser_pen_shape_icon_size'))
        Text($r('app.string.eraser_pen_shape_text'))
          .fontSize($r('app.integer.eraser_font_size'))
          .fontColor($r('app.color.eraser_selected_color'))
          .margin({ top: $r('app.integer.eraser_pen_shape_text_margin_top') })
          .fontColor(this.isClear ? $r('app.color.eraser_unselected_color') : $r('app.color.eraser_selected_color'))
      }
      .margin({ right: $r('app.integer.eraser_bottom_pen_shape_margin_right') })
      .onClick(() => {
        this.isClear = false;
      })

      // 橡皮擦按钮
      Column() {
        Image($r('app.media.eraser_screenshot_eraser'))
          .fillColor(this.isClear ? $r('app.color.eraser_selected_color') : $r('app.color.eraser_unselected_color'))
          .width($r('app.integer.eraser_pen_shape_icon_size'))
          .height($r('app.integer.eraser_pen_shape_icon_size'))
        Text($r('app.string.eraser_eraser_text'))
          .fontSize($r('app.integer.eraser_font_size'))
          .fontColor($r('app.color.eraser_selected_color'))
          .margin({ top: $r('app.integer.eraser_pen_shape_text_margin_top') })
          .fontColor(this.isClear ? $r('app.color.eraser_selected_color') : $r('app.color.eraser_unselected_color'))
      }
      .onClick(() => {
        this.isClear = true;
      })

      Divider()
        .vertical(true)
        .strokeWidth(Constants.DIVIDER_STROKE_WIDTH)
        .color($r('app.color.eraser_divider_color'))
        .margin({ left: $r('app.integer.eraser_divider_margin'), right: $r('app.integer.eraser_divider_margin') })
      // 可选的线宽列表
      Row() {
        // TODO：性能知识点：此处列表项确定且数量较少，使用了ForEach，在列表项多的情况下，推荐使用LazyForeEach
        ForEach(this.lineStrokeWidths, (strokeWidth: number) => {
          Circle({ width: px2vp(strokeWidth), height: px2vp(strokeWidth) })
            .fill(strokeWidth === this.currentLineStrokeWidth ? $r('app.color.eraser_selected_color') :
            $r('app.color.eraser_unselected_color'))// 为了避免线宽较小时无法点击，扩大触摸热区
            .responseRegion(this.getResponRegion(px2vp(strokeWidth), Constants.THRESHOLD))
            .onClick(() => {
              // 点击切换选中的线宽
              this.currentLineStrokeWidth = strokeWidth;
            })
        })
      }
      .layoutWeight(Constants.LAYOUT_WEIGHT)
      .justifyContent(FlexAlign.SpaceAround)
    }
    .width($r('app.string.eraser_full_size'))
    .height($r('app.integer.eraser_bottom_line_height'))
    .padding($r('app.integer.eraser_padding'))
    .backgroundColor($r('app.color.eraser_top_and_bottom_line_background_color'))
    .alignRules({
      bottom: { anchor: Constants.CONTAINER_ID, align: VerticalAlign.Bottom },
      left: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Start }
    })
    .alignItems(VerticalAlign.Center)
    .id(Constants.BOTTOM_PEN_SHAPE_ID)
  }

  // 绘制区域
  @Builder
  drawingArea() {
    Image($r('app.media.eraser_picture'))
      .width($r('app.string.eraser_full_size'))
      .objectFit(ImageFit.Contain)
      .alignRules({
        top: { anchor: Constants.TOP_BUTTON_LINE_ID, align: VerticalAlign.Bottom },
        middle: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Center },
        bottom: { anchor: Constants.BOTTOM_PEN_SHAPE_ID, align: VerticalAlign.Top }
      })
      .onComplete((event) => {
        if (event !== undefined) {
          // NodeContainer的宽高设置为图片成功加载后实际绘制的尺寸
          this.nodeContainerWidth = px2vp(event.contentWidth);
          this.nodeContainerHeight = px2vp(event.contentHeight);
        }
      })
    if (this.nodeContainerWidth && this.nodeContainerHeight) {
      NodeContainer(this.myNodeController)
        .width(this.nodeContainerWidth)
        .height(this.nodeContainerHeight)
        .alignRules({
          top: { anchor: Constants.TOP_BUTTON_LINE_ID, align: VerticalAlign.Bottom },
          middle: { anchor: Constants.CONTAINER_ID, align: HorizontalAlign.Center },
          bottom: { anchor: Constants.BOTTOM_PEN_SHAPE_ID, align: VerticalAlign.Top }
        })
        /**
         * TODO: 知识点：NodeContainer设置属性blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)创建一个离屏画布，
         * NodeContainer的子节点进行颜色混合时将基于该画布进行混合
         */
        .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
        .id(Constants.NODE_CONTAINER_ID)
        // TODO: 性能知识点: onTouch是系统高频回调函数，避免在函数中进行冗余或耗时操作，例如应该减少或避免在函数打印日志，会有较大的性能损耗。
        .onTouch((event: TouchEvent) => {
          this.onTouchEvent(event);
        })
        .onAppear(() => {
          // NodeContainer组件挂载完成后初始化一个MyImageRenderNode节点添加到根节点上
          if (this.currentImageNode === null) {
            // 创建一个MyImageRenderNode对象
            const newNode = new MyImageRenderNode();
            // 定义newNode的大小和位置，位置从组件NodeContainer的左上角(0,0)坐标开始，大小为NodeContainer的宽高
            newNode.frame = {
              x: 0,
              y: 0,
              width: this.nodeContainerWidth,
              height: this.nodeContainerHeight
            };
            this.currentImageNode = newNode;
            this.myNodeController.addNode(this.currentImageNode);
          }
        })
    }
  }

  build() {
    RelativeContainer() {
      // 顶部撤销、恢复按钮模块
      this.topButtonLine()

      // 绘制区域
      this.drawingArea()

      // 底部画笔编辑模块，用于切换涂鸦和橡皮擦选中状态，设置线宽
      this.bottomPenShape()
    }
    .height($r('app.string.eraser_full_size'))
    .width($r('app.string.eraser_full_size'))
    .backgroundColor($r('app.color.eraser_background_color'))
  }

  /**
   * 更新绘制结果
   */
  updateDrawResult() {
    // TODO：知识点：通过组件截图componentSnapshot获取NodeContainer上当前绘制结果的pixelMap，需要设置waitUntilRenderFinished为true尽可能获取最新的渲染结果
    componentSnapshot.get(Constants.NODE_CONTAINER_ID, { waitUntilRenderFinished: true })
      .then(async (pixelMap: image.PixelMap) => {
        if (this.currentImageNode !== null) {
          // 获取到的pixelMap推入pixelMapHistory栈中，并且调用invalidate重新渲染currentImageNode
          this.currentImageNode.pixelMapHistory.push(pixelMap);
          this.currentImageNode.invalidate();
          // 更新绘制结果后将用于恢复的栈清空
          this.currentImageNode.cacheStack = [];
          // 更新撤销和恢复按钮状态
          this.redoEnabled = false;
          this.undoEnabled = true;
          if (this.currentNodeDraw !== null) {
            // 重置绘制节点的路径，
            this.currentNodeDraw.path.reset();
            this.currentNodeDraw.invalidate();
          }
        }
      })
  }

  /**
   * touch事件触发后绘制手指移动轨迹
   */
  onTouchEvent(event: TouchEvent): void {
    // 获取手指触摸位置的坐标点
    const positionX: number = vp2px(event.touches[0].x);
    const positionY: number = vp2px(event.touches[0].y);
    switch (event.type) {
      case TouchType.Down: {
        // 初次绘制时创建一个新的MyRenderNode对象，用于记录和绘制手指移动的路径，后续绘制时在已创建的currentNodeDraw中重新添加路径
        let newNode: MyRenderNode;
        if (this.currentNodeDraw !== null) {
          this.currentNodeDraw.path.moveTo(positionX, positionY);
        } else {
          const newNode = new MyRenderNode();
          newNode.frame = {
            x: 0,
            y: 0,
            width: this.nodeContainerWidth,
            height: this.nodeContainerHeight
          };
          this.currentNodeDraw = newNode;
          this.currentNodeDraw.path.moveTo(positionX, positionY);
          this.myNodeController.addNode(this.currentNodeDraw);
        }
        // TODO：知识点：给画笔设置不同的颜色混合模式，实现涂鸦和擦除效果
        if (!this.isClear) {
          // SRC_OVER类型，将源像素（新绘制内容）按照透明度与目标像素（下层图像）进行混合，覆盖在目标像素（下层图像）上
          this.currentNodeDraw.blendMode = drawing.BlendMode.SRC_OVER;
        } else {
          // CLEAR类型，将源像素（新绘制内容）覆盖的目标像素（下层图像）清除为完全透明
          this.currentNodeDraw.blendMode = drawing.BlendMode.CLEAR;
        }
        // 修改画笔线宽
        this.currentNodeDraw.lineStrokeWidth = this.currentLineStrokeWidth;
        break;
      }
      case TouchType.Move: {
        if (this.currentNodeDraw !== null) {
          // 手指移动，绘制移动轨迹
          this.currentNodeDraw.path.lineTo(positionX, positionY);
          // 节点的path更新后需要调用invalidate()方法触发重新渲染
          this.currentNodeDraw.invalidate();
        }
        break;
      }
      case TouchType.Up: {
        // 没有绘制过，即pixelMapHistory长度为0时，擦除操作不会更新绘制结果
        if (this.isClear && this.currentImageNode?.pixelMapHistory.length === 0 && this.currentNodeDraw !== null) {
          // 重置绘制节点的路径，
          this.currentNodeDraw.path.reset();
          this.currentNodeDraw.invalidate();
          return;
        }
        // 手指离开时更新绘制结果
        this.updateDrawResult();
      }
      default: {
        break;
      }
    }
  }

  /**
   * 撤销上一笔绘制
   */
  undo() {
    if (this.currentImageNode !== null) {
      // 绘制历史记录pixelMapHistory顶部的pixelMap出栈，推入cacheStack栈中
      const pixelMap = this.currentImageNode.pixelMapHistory.pop();
      if (pixelMap) {
        this.currentImageNode.cacheStack.push(pixelMap);
      }
      // 节点重新渲染，将此时pixelMapHistory栈顶的pixelMap绘制到画布上
      this.currentImageNode.invalidate();
      // 更新撤销和恢复按钮状态
      this.redoEnabled = this.currentImageNode.cacheStack.length !== 0 ? true : false;
      this.undoEnabled = this.currentImageNode.pixelMapHistory.length !== 0 ? true : false;
    }
  }

  /**
   * 恢复上一次撤销
   */
  redo() {
    if (this.currentImageNode !== null) {
      // cacheStack顶部的pixelMap出栈，推入绘制历史记录pixelMapHistory栈中
      const pixelMap = this.currentImageNode.cacheStack.pop();
      if (pixelMap) {
        this.currentImageNode.pixelMapHistory.push(pixelMap);
      }
      // 节点重新渲染，将此时pixelMapHistory栈顶的pixelMap绘制到画布上
      this.currentImageNode.invalidate();
      // 更新撤销和恢复按钮状态
      this.redoEnabled = this.currentImageNode.cacheStack.length !== 0 ? true : false;
      this.undoEnabled = this.currentImageNode.pixelMapHistory.length !== 0 ? true : false;
    }
  }

  /**
   * 获取线宽列表项的触摸热区，尺寸小于阈值时扩大触摸热区
   */
  getResponRegion(size: number, threshold: number) {
    const rectangle: Rectangle = {
      x: size < threshold ? (size - threshold) / 2 : 0,
      y: size < threshold ? (size - threshold) / 2 : 0,
      width: size < threshold ? threshold : size,
      height: size < threshold ? threshold : size
    }
    return rectangle;
  }
}
