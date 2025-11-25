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
// [Start stack_index]
// Index.ets
import { createPostNode, getPostNode, PostNode } from './PostNode';
import { componentUtils, curves, UIContext } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  // 新建一镜到底动画类
  private uiContext: UIContext = this.getUIContext();
  @State animationProperties: AnimationProperties = new AnimationProperties(this.uiContext);
  private listArray: Array<number> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  build() {
    // 卡片折叠态，展开态的共同父组件
    Stack() {
      List({ space: 20 }) {
        ForEach(this.listArray, (item: number) => {
          ListItem() {
            // 卡片折叠态
            PostItem({ index: item, animationProperties: this.animationProperties })
          }
        })
      }
      .clip(false)
      .alignListItem(ListItemAlign.Center)

      if (this.animationProperties.isExpandPageShow) {
        // 卡片展开态
        ExpandPage({ animationProperties: this.animationProperties })
      }
    }
    .key('rootStack')
    .enabled(this.animationProperties.isEnabled)
  }
}

@Component
struct PostItem {
  @Prop index: number
  @Link animationProperties: AnimationProperties;
  @State nodeController: PostNode | undefined = undefined;
  // 折叠时详细内容隐藏
  private showDetailContent: boolean = false;

  aboutToAppear(): void {
    this.nodeController = createPostNode(this.getUIContext(), this.index.toString(), this.showDetailContent);
    if (this.nodeController != undefined) {
      // 设置回调，当卡片从展开态回到折叠态时触发
      this.nodeController.setCallback(this.resetNode.bind(this));
    }
  }

  resetNode() {
    this.nodeController = getPostNode(this.index.toString());
  }

  build() {
    Stack() {
      NodeContainer(this.nodeController)
    }
    .width('100%')
    .height(100)
    .key(this.index.toString())
    .onClick(() => {
      if (this.nodeController != undefined) {
        // 卡片从折叠态节点下树
        this.nodeController.onRemove();
      }
      // 触发卡片从折叠到展开态的动画
      this.animationProperties.expandAnimation(this.index);
    })
  }
}

@Component
struct ExpandPage {
  @Link animationProperties: AnimationProperties;
  @State nodeController: PostNode | undefined = undefined;
  // 展开时详细内容出现
  private showDetailContent: boolean = true;

  aboutToAppear(): void {
    // 获取对应序号的卡片组件
    this.nodeController = getPostNode(this.animationProperties.curIndex.toString());
    // 更新为详细内容出现
    this.nodeController?.update(this.animationProperties.curIndex.toString(), this.showDetailContent);
  }

  build() {
    Stack() {
      NodeContainer(this.nodeController)
    }
    .width('100%')
    .height(this.animationProperties.changedHeight ? '100%' : 100)
    .translate({ x: this.animationProperties.translateX, y: this.animationProperties.translateY })
    .position({ x: this.animationProperties.positionX, y: this.animationProperties.positionY })
    .onClick(() => {
      this.getUIContext()?.animateTo({
        curve: curves.springMotion(0.6, 0.9),
        onFinish: () => {
          if (this.nodeController != undefined) {
            // 执行回调，折叠态节点获取卡片组件
            this.nodeController.callCallback();
            // 当前展开态节点的卡片组件下树
            this.nodeController.onRemove();
          }
          // 卡片展开态节点下树
          this.animationProperties.isExpandPageShow = false;
          this.animationProperties.isEnabled = true;
        }
      }, () => {
        // 卡片从展开态回到折叠态
        this.animationProperties.isEnabled = false;
        this.animationProperties.translateX = 0;
        this.animationProperties.translateY = 0;
        this.animationProperties.changedHeight = false;
        // 更新为详细内容消失
        this.nodeController?.update(this.animationProperties.curIndex.toString(), false);
      })
    })
  }
}

class RectInfo {
  left: number = 0;
  top: number = 0;
  right: number = 0;
  bottom: number = 0;
  width: number = 0;
  height: number = 0;
}

// 封装的一镜到底动画类
@Observed
class AnimationProperties {
  public isExpandPageShow: boolean = false;
  // 控制组件是否响应点击事件
  public isEnabled: boolean = true;
  // 展开卡片的序号
  public curIndex: number = -1;
  public translateX: number = 0;
  public translateY: number = 0;
  public positionX: number = 0;
  public positionY: number = 0;
  public changedHeight: boolean = false;
  private calculatedTranslateX: number = 0;
  private calculatedTranslateY: number = 0;
  // 设置卡片展开后相对父组件的位置
  private expandTranslateX: number = 0;
  private expandTranslateY: number = 0;
  private uiContext: UIContext;

  constructor(uiContext: UIContext) {
    this.uiContext = uiContext
  }

  public expandAnimation(index: number): void {
    // 记录展开态卡片的序号
    if (index != undefined) {
      this.curIndex = index;
    }
    // 计算折叠态卡片相对父组件的位置
    this.calculateData(index.toString());
    // 展开态卡片上树
    this.isExpandPageShow = true;
    // 卡片展开的属性动画
    this.uiContext?.animateTo({
      curve: curves.springMotion(0.6, 0.9)
    }, () => {
      this.translateX = this.calculatedTranslateX;
      this.translateY = this.calculatedTranslateY;
      this.changedHeight = true;
    })
  }

  // 获取需要跨节点迁移的组件的位置，及迁移前后节点的公共父节点的位置，用以计算做动画组件的动画参数
  public calculateData(key: string): void {
    let clickedImageInfo = this.getRectInfoById(this.uiContext, key);
    let rootStackInfo = this.getRectInfoById(this.uiContext, 'rootStack');
    this.positionX = this.uiContext.px2vp(clickedImageInfo.left - rootStackInfo.left);
    this.positionY = this.uiContext.px2vp(clickedImageInfo.top - rootStackInfo.top);
    this.calculatedTranslateX = this.uiContext.px2vp(rootStackInfo.left - clickedImageInfo.left) +
      this.expandTranslateX;
    this.calculatedTranslateY = this.uiContext.px2vp(rootStackInfo.top - clickedImageInfo.top) + this.expandTranslateY;
  }

  // 根据组件的id获取组件的位置信息
  private getRectInfoById(context: UIContext, id: string): RectInfo {
    let componentInfo: componentUtils.ComponentInfo = context.getComponentUtils().getRectangleById(id);

    if (!componentInfo) {
      throw Error('object is empty');
    }

    let rstRect: RectInfo = new RectInfo();
    const widthScaleGap = componentInfo.size.width * (1 - componentInfo.scale.x) / 2;
    const heightScaleGap = componentInfo.size.height * (1 - componentInfo.scale.y) / 2;
    rstRect.left = componentInfo.translate.x + componentInfo.windowOffset.x + widthScaleGap;
    rstRect.top = componentInfo.translate.y + componentInfo.windowOffset.y + heightScaleGap;
    rstRect.right =
      componentInfo.translate.x + componentInfo.windowOffset.x + componentInfo.size.width - widthScaleGap;
    rstRect.bottom =
      componentInfo.translate.y + componentInfo.windowOffset.y + componentInfo.size.height - heightScaleGap;
    rstRect.width = rstRect.right - rstRect.left;
    rstRect.height = rstRect.bottom - rstRect.top;

    return {
      left: rstRect.left,
      right: rstRect.right,
      top: rstRect.top,
      bottom: rstRect.bottom,
      width: rstRect.width,
      height: rstRect.height
    }
  }
}

// [End stack_index]