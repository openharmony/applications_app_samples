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

// [Start use_offline_web_component_home_page]
// Home.ets
import { createNWeb, getNWeb } from './Common'

@Component
export struct Home {
  private navPath?: NavPathStack;

  aboutToAppear(): void {
    // 创建3个离线Web组件（需传入UIContext），loadContent之后的任意时机均可创建
    // 1个离线组件直接加载测试Url1，并执行预加载。另外2个为空白离线组件。
    let testUrl1 = this.getUIContext().getHostContext()?.resourceManager.getStringSync($r('app.string.test_url1'))
    createNWeb(testUrl1 ? testUrl1 : "about:blank", this.getUIContext());
    createNWeb('about:blank?tab=1', this.getUIContext())
    createNWeb('about:blank?tab=2', this.getUIContext())
    setTimeout(() => {
      getNWeb(testUrl1)?.startPreLoad()
    }, 100)
  }

  build() {
    NavDestination() {
      Column() {
        Button($r('app.string.back')).onClick(() => {
          this.navPath?.pop();
        })
          .width('80%')
          .margin('5')
          .id('back_index')
        // page1显示两个离线Web组件，同时打开测试Url1，其中一个已执行预加载，另外一个复用空闲的离线组件。
        Button($r('app.string.Jump_to_Page1')).onClick(() => {
          this.navPath?.pushPathByName('Page1', null);
        })
          .width('80%')
          .margin('5')
          .id('go_page1')
        // page2动态复用空闲的离线组件显示网页，这里打开一个空页面。
        Button($r('app.string.Jump_to_Page2_load_blank')).onClick(() => {
          let params: Record<string, ResourceStr> = { 'targetUrl': 'about:blank' };
          this.navPath?.pushPathByName('Page2', params);
        })
          .width('80%')
          .margin('5')
          .id('go_page2:1')

        // page2动态复用空闲的离线组件显示网页，这里默认打开测试Url1
        Button($r('app.string.Jump_to_Page2_load_url1')).onClick(() => {
          let params: Record<string, ResourceStr> = { 'targetUrl': $r('app.string.test_url1') };
          this.navPath?.pushPathByName('Page2', params);
        })
          .width('80%')
          .margin('5')
          .id('go_page2:2')

        // page2动态复用空闲的离线组件显示网页，这里默认打开测试Url2
        Button($r('app.string.Jump_to_Page2_load_url2')).onClick(() => {
          let params: Record<string, ResourceStr> = { 'targetUrl': $r('app.string.test_url2') };
          this.navPath?.pushPathByName('Page2', params);
        })
          .width('80%')
          .margin('5')
          .id('go_page2:3')
      }
    }
    .hideTitleBar(true)
    .onReady((ctx: NavDestinationContext) => {
      this.navPath = ctx.pathStack;
    })
  }
}

// [End use_offline_web_component_home_page]
