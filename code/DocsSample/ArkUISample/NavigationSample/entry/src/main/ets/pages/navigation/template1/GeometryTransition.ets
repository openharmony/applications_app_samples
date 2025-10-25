/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { uiObserver } from '@kit.ArkUI';
@Component
struct FromPage {
  navDesInfo: uiObserver.NavDestinationInfo | undefined;
  @Consume('navPS') navPathStack: NavPathStack;
  build() {
    // [Start GeometryTransitionFromPage]
    // [Start GeometryTransitionFromPage1]
    // 起始页配置共享元素id
    NavDestination() {
      Column() {
        // [StartExclude GeometryTransitionFromPage]
        Button('跳转目的页')
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.getUIContext()?.animateTo({ duration: 1000 }, () => {
              this.navPathStack.pushPath({ name: 'ToPage' }, false)
            });
          })
        // [EndExclude GeometryTransitionFromPage]
        // [StartExclude GeometryTransitionFromPage1]
        // $r('app.media.startIcon')需要替换为开发者所需的资源文件
        Image($r('app.media.startIcon'))
          .geometryTransition('sharedId')
          .width(100)
          .height(100)
        // [EndExclude GeometryTransitionFromPage1]
      }
    }.title('FromPage')
    // [End GeometryTransitionFromPage]
    // [End GeometryTransitionFromPage1]
  }
}

@Component
struct ToPage {
  navDesInfo: uiObserver.NavDestinationInfo | undefined;
  @Consume('navPS') navPathStack: NavPathStack;
  build() {
    // [Start GeometryTransitionToPage]
    // 目的页配置共享元素id
    NavDestination() {
      Column() {
        // $r('app.media.startIcon')需要替换为开发者所需的资源文件
        Image($r('app.media.startIcon'))
          .geometryTransition('sharedId')
          .width(200)
          .height(200)
      }
      .onClick(() => {
          this.navPathStack.pop(false)
      })
    }
    .title('ToPage')
    // [End GeometryTransitionToPage]
  }
}

@Entry
@Component
struct GeometryTransition {
  @Provide('navPS') navPathStack: NavPathStack = new NavPathStack();
  @Builder
  PageBuilder(name: string) {
    if (name === 'FromPage'){
      FromPage()
    } else if (name === 'ToPage'){
      ToPage()
    }
  };
  aboutToAppear(): void {
    this.navPathStack.pushPath({name: 'FromPage'});
  }

  build() {
    Column() {
      Navigation(this.navPathStack)
      .title('Navigation')
      .navDestination(this.PageBuilder)
    }
    .width('100%')
    .height('100%')
  }
}