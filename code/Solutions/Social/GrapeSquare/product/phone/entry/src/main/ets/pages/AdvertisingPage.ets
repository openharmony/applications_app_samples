/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { getResourceString } from '../utils/ResourceUtils';
import Constants from '../utils/Constants';

let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

@Entry
@Component
struct AdvertisingPage {
  // 初始化广告时间
  @State advertisingTime: number = 3;
  // 定时器timer
  @State timer: number = -1;

  aboutToAppear() {
    this.timer = setInterval(() => {
      this.advertisingTime--;
      // 广告时间为0s时跳转到首页
      if (this.advertisingTime === 0) {
        router.replaceUrl({ url: 'pages/HomePage' });
        clearInterval(this.timer);
      }
    }, Constants.SETINTERVAL_TIME)
  }

  build() {
    Stack() {
      Image($r('app.media.advertisment'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
      Row() {
        Text(`${getResourceString(context, $r('app.string.skip'))} ${this.advertisingTime}s`)
          .id('skip')
          .padding({
            left: $r('app.integer.layout_size_30'),
            right: $r('app.integer.layout_size_30'),
            top: $r('app.integer.layout_size_6'),
            bottom: $r('app.integer.layout_size_6')
          })
          .backgroundColor('rgba(0,0,0,0.20)')
          .fontColor(Color.White)
          .borderRadius($r('app.integer.layout_size_15'))
          .onClick(() => {
            clearInterval(this.timer);
            router.replaceUrl({ url: 'pages/HomePage' });
          })
      }.width($r('app.string.layout_100'))
      .justifyContent(FlexAlign.End)
      .padding($r('app.integer.layout_size_10'))
    }
    .alignContent(Alignment.TopEnd)
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
  }
}