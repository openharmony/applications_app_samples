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
import { common } from '@kit.AbilityKit';

// [Start navigation_page_two]
// PageTwo.ets
import { CustomTransition } from '../../../CustomTransition/CustomNavigationUtils';
import { AnimationProperties } from '../../../CustomTransition/AnimationProperties';
import { RectInfoInPx } from '../../../utils/ComponentAttrUtils';
import { getMyNode, MyNodeController } from '../../../NodeContainer/CustomComponent';

@Builder
export function PageTwoBuilder() {
  PageTwo();
}

@Component
export struct PageTwo {
  @State pageInfos: NavPathStack = new NavPathStack();
  @State animationProperties: AnimationProperties = new AnimationProperties(this.getUIContext());
  @State myNodeController: MyNodeController | undefined = new MyNodeController(false);
  // [StartExclude navigation_page_two]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // [EndExclude navigation_page_two]
  private pageId: number = -1;
  private shouldDoDefaultTransition: boolean = false;
  private prePageDoFinishTransition: () => void = () => {
  };
  private cardItemInfo: RectInfoInPx = new RectInfoInPx();
  @StorageProp('windowSizeChanged') @Watch('unRegisterNavParam') windowSizeChangedTime: number = 0;
  @StorageProp('onConfigurationUpdate') @Watch('unRegisterNavParam') onConfigurationUpdateTime: number = 0;

  aboutToAppear(): void {
    // 迁移自定义节点至当前页面
    this.myNodeController = getMyNode();
  }

  private unRegisterNavParam(): void {
    this.shouldDoDefaultTransition = true;
  }

  private onBackPressed(): boolean {
    if (this.shouldDoDefaultTransition) {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
      this.pageInfos.pop();
      this.prePageDoFinishTransition();
      this.shouldDoDefaultTransition = false;
      return true;
    }
    this.pageInfos.pop();
    return true;
  }

  build() {
    NavDestination() {
      // Stack需要设置alignContent为TopStart，否则在高度变化过程中，截图和内容都会随高度重新布局位置
      Stack({ alignContent: Alignment.TopStart }) {
        Stack({ alignContent: Alignment.TopStart }) {
          Column({ space: 20 }) {
            NodeContainer(this.myNodeController);
            if (this.animationProperties.showDetailContent) {
              Text(this.context.resourceManager.getStringByNameSync('shareTransition_text8'))
                .fontSize(20)
                .transition(TransitionEffect.OPACITY)
                .margin(30)
            }
          }
          .alignItems(HorizontalAlign.Start)
        }
        .position({ y: this.animationProperties.positionValue });
      }
      .scale({ x: this.animationProperties.scaleValue, y: this.animationProperties.scaleValue })
      .translate({ x: this.animationProperties.translateX, y: this.animationProperties.translateY })
      .width(this.animationProperties.clipWidth)
      .height(this.animationProperties.clipHeight)
      .borderRadius(this.animationProperties.radius)
      // expandSafeArea使得Stack做沉浸式效果，向上扩到状态栏，向下扩到导航条
      .expandSafeArea([SafeAreaType.SYSTEM])
      // 对高度进行裁切
      .clip(true)
    }
    .backgroundColor(this.animationProperties.navDestinationBgColor)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
      this.pageId = this.pageInfos.getAllPathName().length - 1;
      let param = context.pathInfo?.param as Record<string, Object>;
      this.prePageDoFinishTransition = param['doDefaultTransition'] as () => void;
      this.cardItemInfo = param['cardItemInfo'] as RectInfoInPx;
      CustomTransition.getInstance().registerNavParam(this.pageId,
        (isPush: boolean, isExit: boolean, transitionProxy: NavigationTransitionProxy) => {
          this.animationProperties.doAnimation(
            this.cardItemInfo, isPush, isExit, transitionProxy, 0,
            this.prePageDoFinishTransition, this.myNodeController);
        }, 500);
    })
    .onBackPressed(() => {
      return this.onBackPressed();
    })
    .onDisAppear(() => {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
    })
  }
}

// [End navigation_page_two]