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

// [Start create_navigation]
import nativeComponent from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

class PageParam {
  name: string = "";
}

@Entry
@Component
struct NavigationAnimationDemo {
  private pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Column() {
        Text('Navigation信息查询')
          .fontSize(24)
          .margin({ bottom: 20 })

        Button('进入QueryNavigation')
          .onClick(() => {
            let param = new PageParam();
            param.name = "QueryNavigation";
            this.pageStack.pushPath({ name: 'pageOne', param: param});
          })
          .margin({ bottom: 10 })

        Button('进入QueryRouter').onClick(() => {
          let param = new PageParam();
          param.name = "QueryRouter";
          this.pageStack.pushPath({name: 'pageOne', param: param});
        }).id('QueryRouter')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title('NDK Navigation Sample')
    .navDestination(this.pageMap)
  }

  @Builder
  pageMap(name: string) {
    if (name === 'pageOne') {
      Page({name: 'pageOne'})
    } else if (name == 'pageTwo') {
      Page({mode: NavDestinationMode.DIALOG, name: 'pageTwo'})
    }
  }
}
// [End create_navigation]

// [Start create_navdestination]
@Component
struct Page {
  private nativeRoot: NodeContent = new NodeContent()
  name: string = ""

  mode: NavDestinationMode = NavDestinationMode.STANDARD

  build() {
    NavDestination() {
      Column() {
        Text(this.name)
          .fontSize(20)
          .margin({ bottom: 20 })
        Button('push page two').margin(20).onClick(() => {
          this.queryNavigationInfo()?.pathStack.pushPath({name: 'pageTwo'})
        })
        if (this.name == "pageOne") {
          ContentSlot(this.nativeRoot)
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }.onShown(() => {
      nativeComponent.createContentNode(this.nativeRoot);
    })
    .title('Page One')
    .hideBackButton(false)
    .mode(this.mode)
    .hitTestBehavior(this.mode == NavDestinationMode.STANDARD ? HitTestMode.Default : HitTestMode.Transparent)
  }
}
// [End create_navdestination]