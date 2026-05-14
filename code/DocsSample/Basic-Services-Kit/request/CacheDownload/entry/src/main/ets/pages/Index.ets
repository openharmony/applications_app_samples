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

import { logger } from '../utils/Logger';

const TAG: string = 'Index';

@Styles
function itemStyle() {
  .width('100%')
  .height(56)
  .padding({
    top: 17,
    bottom: 17,
    left: 12,
    right: 12
  })
  .backgroundColor(Color.White)
  .borderRadius(24)
  .margin({ top: 20 })
}

@Extend(Text)
function textStyle() {
  .fontColor($r('app.color.text_normal'))
  .fontWeight(400)
  .fontFamily('HarmonyHeiTi')
  .fontSize(16)
}

@Entry
@Component
struct Index {
  build() {
    Navigation() {
      Scroll() {
        Column() {
          this.CapabilityView(
            $r('app.media.ic_download'),
            $r('app.string.cache_download_retry'),
            'btn_retry_options',
            () => {
              this.navigateTo('pages/CacheDownloadRetry');
            }
          )

          this.CapabilityView(
            $r('app.media.ic_download'),
            $r('app.string.cache_download_timeout'),
            'btn_timeout_options',
            () => {
              this.navigateTo('pages/CacheDownloadTimeout');
            }
          )

          this.CapabilityView(
            $r('app.media.ic_download'),
            $r('app.string.global_retry_options_title'),
            'btn_global_retry',
            () => {
              this.navigateTo('pages/GlobalRetryOptions');
            }
          )

          this.CapabilityView(
            $r('app.media.ic_download'),
            $r('app.string.global_timeout_options_title'),
            'btn_global_timeout',
            () => {
              this.navigateTo('pages/GlobalTimeoutOptions');
            }
          )
        }
        .width('100%')
        .margin({ left: -12 })
      }
      .padding({ left: 12, right: 6 })
      .height('100%')
      .align(Alignment.Top)
    }
    .width('100%')
    .height('100%')
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .backgroundColor($r('app.color.page_background'))
    .title({
      main: $r('app.string.EntryAbility_label'),
      sub: $r('app.string.home_subtitle')
    })
    .padding({ top: 5 })
  }

  @Builder
  CapabilityView(image: Resource, text: Resource, id: string, onClick: () => void) {
    Row() {
      Image(image)
        .size({ width: 24, height: 24 })
        .objectFit(ImageFit.Cover)
      Text(text)
        .textStyle()
        .margin({ left: 12 })
    }
    .itemStyle()
    .id(id)
    .onClick(onClick)
  }

  navigateTo(url: string): void {
    try {
      this.getUIContext().getRouter().pushUrl({ url: url });
      logger.info(TAG, `Navigating to ${url}`);
    } catch (error) {
      logger.error(TAG, `Failed to navigate: ${JSON.stringify(error)}`);
    }
  }
}