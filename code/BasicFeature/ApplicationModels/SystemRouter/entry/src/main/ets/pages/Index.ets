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

@Entry
@Component
struct NavigationExample {
  pageInfos: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageInfos) {
      Column({ space: 12 }) {
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
        Button($r('app.string.hspA_pageOne'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('HspAPageOne', null);
          })
        Button($r('app.string.hspA_pageTwo'), { stateEffect: true, type: ButtonType.Capsule })
          .width($r('app.string.button_width'))
          .height($r('app.string.button_height'))
          .onClick(() => {
            //Push the NavDestination page information specified by name onto the stack, and pass the data as param.
            this.pageInfos.pushPathByName('HspAPageTwo', null);
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
    .title($r('app.string.entry_index_title'))
  }
}