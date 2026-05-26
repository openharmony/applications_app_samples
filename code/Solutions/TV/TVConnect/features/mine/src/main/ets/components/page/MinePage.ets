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
import { CommonGroup, CommonList, NavItem, SimpleItem } from '../ListComponents';
import { DeviceSyncComponent } from '../DeviceSyncComponent';
import { SceneSyncComponent } from '../SceneSyncComponent';
import { MineItem } from '../MineComponent';
import { HMRouter } from '@hadss/hmrouter';
import { PageViewUtils } from '@ohos/common';

/**
 * 我的页面
 */
@Builder
export function MinePage() {
  MineComponent();
}

/**
 * 我的页面UI组件
 */
@HMRouter({ pageUrl: 'MinePage', singleton: true, lifecycle: 'MinePageLifecycle' })
@Component
export struct MineComponent {
  aboutToAppear(): void {
    PageViewUtils.tabClick();
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.page_mine'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_20'))
          .fontWeight(FontWeight.Bold)
          .margin({ left: $r('app.string.12_vp') });
      }
      .width('50%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center);

      Column() {
        CommonList() {
          MineItem();
          CommonGroup() {
            DeviceSyncComponent();
            SceneSyncComponent();
          };

          CommonGroup() {
            NavItem({ pushName: 'AboutPage' }) {
              SimpleItem({ name: $r('app.string.page_settings_about') });
            };
          };
        };
      }
      .width('70%');
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .backgroundColor($r('app.color.page_background'));
  }
}
