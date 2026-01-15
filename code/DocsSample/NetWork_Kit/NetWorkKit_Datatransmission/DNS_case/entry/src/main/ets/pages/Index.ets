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

import { Router } from '@kit.ArkUI'
import { ComponentId } from '../common/CommonConstant';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      Column({ space: 30 }) {
        Text($r('app.string.dns_case'))
          .id(ComponentId.HTTP_TITLE)
          .fontSize(30)

        Button($r('app.string.DNS')).id(ComponentId.DNS_BTN).onClick(() => {
          let page = new Router();
          page.pushUrl({ url: 'pages/DNS' });
        })
          .width(200)

        Button($r('app.string.Unicode')).id(ComponentId.ASCII_BTN).onClick(() => {
          let page = new Router();
          page.pushUrl({ url: 'pages/Unicode' });
        })
          .width(200)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .height('100%')
    .width('100%')
  }
}