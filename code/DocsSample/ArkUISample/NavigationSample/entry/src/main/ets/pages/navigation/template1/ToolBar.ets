import { hilog } from '@kit.PerformanceAnalysisKit';

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
const DOMAIN = 0x0000;
// [Start ToolBar]
// [StartExclude ToolBar]
let toolTmp: ToolbarItem = {
  'value': 'func',
  'icon': 'ets/pages/navigation/template1/image/ic_public_highlights.svg',  // 当前目录image文件夹下的图标资源
  'action': () => {}
};
let tooBar: ToolbarItem[] = [toolTmp,toolTmp,toolTmp];
@Entry
@Component
struct ToolBar {
  @State toolTmp: ToolbarItem = {
    'value': 'func',
    'icon': 'ets/pages/navigation/template1/image/ic_public_highlights.svg',  // 当前目录image文件夹下的图标资源
    'action': () => {}
  };
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();
  private arr: number[] = [1, 2, 3];

  @Builder
  pageMap(name: string) {
    if (name === 'NavDestinationTitle1') {
      pageOneTmp();
    } else if (name === 'NavDestinationTitle2') {
      pageTwoTmp();
    } else if (name === 'NavDestinationTitle3') {
      pageThreeTmp();
    }
  };

  build() {
    Column() {
      // [EndExclude ToolBar]
      Navigation(this.pageInfos) {
        // [StartExclude ToolBar]
        TextInput({ placeholder: 'search...' })
          .width('90%')
          .height(40)
          .backgroundColor('#FFFFFF')

        List({ space: 12 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              Text('Page' + item)
                .width('100%')
                .height(72)
                .backgroundColor('#FFFFFF')
                .borderRadius(24)
                .fontSize(16)
                .fontWeight(500)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.pageInfos.pushPath({ name: 'NavDestinationTitle' + item });
                })
            }
          }, (item: number) => item.toString())
        }
        .width('90%')
        .margin({ top: 12 })
        // [EndExclude ToolBar]
      }
      .toolbarConfiguration(tooBar)
      // [End ToolBar]
      .title('主标题')
      .mode(NavigationMode.Split)
      .navDestination(this.pageMap)
      .menus([
      {
          value: '', icon: 'resources/base/media/ic_public_search.svg', action: () => {
        }
        },
      {
          value: '', icon: 'resources/base/media/ic_public_add.svg', action: () => {
        }
        },
      {
          value: '', icon: 'resources/base/media/ic_public_search.svg', action: () => {
        }
        },
      {
          value: '', icon: 'resources/base/media/ic_public_search.svg', action: () => {
        }
        },
      {
          value: '', icon: 'resources/base/media/ic_public_search.svg', action: () => {
        }
        }
      ])
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }
}

@Component
export struct pageOneTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text('NavDestinationContent1')
      }.width('100%').height('100%')
    }.title('NavDestinationTitle1')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop(); // 弹出路由栈栈顶元素
      hilog.info(DOMAIN, 'testTag', 'pop', '返回值', JSON.stringify(popDestinationInfo));
      return true;
    })
  }
}

@Component
export struct pageTwoTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text('NavDestinationContent2')
      }.width('100%').height('100%')
    }.title('NavDestinationTitle2')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop(); // 弹出路由栈栈顶元素
      hilog.info(DOMAIN, 'testTag', 'pop', '返回值', JSON.stringify(popDestinationInfo));
      return true;
    })
  }
}

@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        Text('NavDestinationContent3')
      }.width('100%').height('100%')
    }.title('NavDestinationTitle3')
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop(); // 弹出路由栈栈顶元素
      hilog.info(DOMAIN, 'testTag', 'pop', '返回值', JSON.stringify(popDestinationInfo));
      return true;
    })
  }
}