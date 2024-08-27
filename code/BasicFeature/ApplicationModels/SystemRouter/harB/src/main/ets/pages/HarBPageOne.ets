/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Logger from '../common/utils/Logger';

@Builder
export function HarBPageOneBuilder(name: string, param: Object) {
  HarBPageOne()
}

const COLUMN_SPACE: number = 12;

@Component
export struct HarBPageOne {
  pageInfos: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column({ space: COLUMN_SPACE }) {
        Button($r('app.string.entry_index'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Clear all pages in the stack.
            this.pageInfos.clear();
          })
        Button($r('app.string.entry_pageOne'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('pageOne', null);
          })
        Button($r('app.string.entry_pageTwo'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('pageTwo', null);
          })
        Button($r('app.string.harA_pageOne'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('HarAPageOne', null);
          })
        Button($r('app.string.harA_pageTwo'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('HarAPageTwo', null);
          })
        Button($r('app.string.harB_pageTwo'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('HarBPageTwo', null);
          })
      }
      .width($r('app.string.navDestination_width'))
      .height($r('app.string.navDestination_height'))
      .justifyContent(FlexAlign.End)
      .padding({
        bottom: $r('app.string.column_padding'),
        left: $r('app.string.column_padding'),
        right: $r('app.string.column_padding')
      })
    }
    .title('harB-pageOne')
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack
      Logger.info('current page config info is ' + JSON.stringify(context.getConfigInRouteMap()));
    })
  }
}