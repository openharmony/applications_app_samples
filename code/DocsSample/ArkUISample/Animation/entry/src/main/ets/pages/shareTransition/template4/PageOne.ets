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

// [Start navigation_page_one]
// PageOne.ets
import { CustomTransition } from '../../../CustomTransition/CustomNavigationUtils';
import { MyNodeController, createMyNode, getMyNode } from '../../../NodeContainer/CustomComponent';
import { ComponentAttrUtils, RectInfoInPx } from '../../../utils/ComponentAttrUtils';
import { WindowUtils } from '../../../utils/WindowUtils';

@Builder
export function PageOneBuilder() {
  PageOne();
}

@Component
export struct PageOne {
  // [StartExclude navigation_page_one]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  // [EndExclude navigation_page_one]
  private pageInfos: NavPathStack = new NavPathStack();
  private pageId: number = -1;
  @State myNodeController: MyNodeController | undefined = new MyNodeController(false);

  aboutToAppear(): void {
    let node = getMyNode();
    if (node === undefined) {
      // 新建自定义节点
      createMyNode(this.getUIContext());
    }
    this.myNodeController = getMyNode();
  }

  private doFinishTransition(): void {
    // PageTwo结束转场时将节点从PageTwo迁移回PageOne
    this.myNodeController = getMyNode();
  }

  private registerCustomTransition(): void {
    // 注册自定义动画协议
    CustomTransition.getInstance().registerNavParam(this.pageId,
      (isPush: boolean, isExit: boolean, transitionProxy: NavigationTransitionProxy) => {
      }, 500);
  }

  private onCardClicked(): void {
    let cardItemInfo: RectInfoInPx =
      ComponentAttrUtils.getRectInfoById(WindowUtils.window.getUIContext(), 'card');
    let param: Record<string, Object> = {};
    param['cardItemInfo'] = cardItemInfo;
    param['doDefaultTransition'] = (myController: MyNodeController) => {
      this.doFinishTransition();
    };
    this.pageInfos.pushPath({ name: 'PageTwo', param: param });
    // 自定义节点从PageOne下树
    if (this.myNodeController != undefined) {
      (this.myNodeController as MyNodeController).onRemove();
    }
  }

  build() {
    NavDestination() {
      Stack() {
        Column({ space: 20 }) {
          Row({ space: 10 }) {
            // 图片使用Resource资源，需用户自定义
            Image($r('app.media.avatar'))
              .size({ width: 50, height: 50 })
              .borderRadius(25)
              .clip(true)

            Text('Alice');
          }
          .justifyContent(FlexAlign.Start)

          Text(this.context.resourceManager.getStringByNameSync('shareTransition_text2'));

          NodeContainer(this.myNodeController)
            .size({ width: 320, height: 250 })
            .onClick(() => {
              this.onCardClicked();
            })
        }
        .alignItems(HorizontalAlign.Start)
        .margin(30)
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
      this.pageId = this.pageInfos.getAllPathName().length - 1;
      this.registerCustomTransition();
    })
    .onDisAppear(() => {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
      // 自定义节点从PageOne下树
      if (this.myNodeController != undefined) {
        (this.myNodeController as MyNodeController).onRemove();
      }
    })
  }
}

// [End navigation_page_one]