/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

@Component
struct Page01 {

  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Button($r('app.string.Page01_label'))
        .width('80%')
        .onClick(() => {
          this.pageInfos.pushPathByName('Page01', '');
        })
        .margin({top: 10, bottom: 10})
      Button($r('app.string.Dialog01_label'))
        .width('80%')
        .onClick(() => {
          this.pageInfos.pushPathByName('Dialog01', '');
        })
        .margin({top: 10, bottom: 10})
    }
    .title($r('app.string.Page01'))
  }
}

@Component
struct Dialog01 {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Gray)
          .opacity(0.1)
          .onClick(() => {
            this.pageInfos.pop();
          })
        Column() {
          Text($r('app.string.Dialog01'))
            .fontSize(30)
            .fontWeight(2)
          Button($r('app.string.Page01_label'))
            .width('80%')
            .onClick(() => {
              this.pageInfos.pushPathByName('Page01', '');
            })
            .margin({top: 10, bottom: 10})
          Button($r('app.string.Dialog01_label'))
            .width('80%')
            .onClick(() => {
              this.pageInfos.pushPathByName('Dialog01', '');
            })
            .margin({top: 10, bottom: 10})
          Button($r('app.string.pop'))
            .width('80%')
            .onClick(() => {
              this.pageInfos.pop();
            })
            .margin({top: 10, bottom: 10})
        }
        .padding(10)
        .width(250)
        .backgroundColor(Color.White)
        .borderRadius(10)
      }
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}

@Entry
@Component
struct Index {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack()

  @Builder
  PagesMap(name: string) {
    if (name == 'Page01') {
      Page01()
    } else if (name == 'Dialog01') {
      Dialog01()
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Button($r('app.string.Page01_label'))
        .width('80%')
        .onClick(() => {
          this.pageInfos.pushPathByName('Page01', '');
        })
    }
    .mode(NavigationMode.Stack)
    .titleMode(NavigationTitleMode.Mini)
    .title($r('app.string.title'))
    .navDestination(this.PagesMap)
  }
}
