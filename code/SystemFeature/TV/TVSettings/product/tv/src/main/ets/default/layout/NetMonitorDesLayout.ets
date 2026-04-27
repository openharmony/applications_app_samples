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

import lpx from '../../common/Lpx';

const TAG = 'NetMonitorDesLayout';

@Component
export struct NetMonitorDesLayout {
  @Prop isRouterError: boolean = false;
  @Prop isNetworkError: boolean = false;

  build() {
    Column() {
      Image($r('app.media.net_tv'))
        .width(lpx(202)).height(lpx(191))
        .objectFit(ImageFit.Contain)

      Image($r('app.media.net_points'))
        .width(lpx(13)).height(lpx(70)).margin({ top: lpx(13), bottom: lpx(36) })
        .objectFit(ImageFit.Contain)

      Image(this.isRouterError ? $r('app.media.net_router_error') : $r('app.media.net_router'))
        .width(this.isRouterError ? lpx(202) : lpx(184))
        .height(this.isRouterError ? lpx(171) : lpx(152))
        .objectFit(ImageFit.Contain)

      Image($r('app.media.net_points'))
        .width(lpx(13)).height(lpx(70))
        .objectFit(ImageFit.Contain).margin({ top: lpx(20), bottom: lpx(21) })

      Image(this.isNetworkError ? $r('app.media.net_internet_error') : $r('app.media.net_internet'))
        .width(this.isNetworkError ? lpx(209) : lpx(197))
        .height(this.isNetworkError ? lpx(197) : lpx(197))
        .objectFit(ImageFit.Contain)

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
