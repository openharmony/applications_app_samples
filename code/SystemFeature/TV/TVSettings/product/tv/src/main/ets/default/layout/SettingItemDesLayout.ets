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

import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';

const TAG = 'SettingItemDesLayout';

@Component
export struct SettingItemDesLayout {
  @Prop imageUrl: string
  @Prop des: string | Resource;

  aboutToAppear() {
    LogUtil.info(TAG + ' aboutToAppear')
  }

  build() {
    Column() {
      Image($r(this.imageUrl))
        .width(ConfigData.WH_40_100)// .height(ConfigData.WH_50_100)
        .objectFit(ImageFit.Contain)
        .aspectRatio(1)

      Text(this.des)
        .fontColor('rgba(255, 255, 255, 0.2)')
        .fontSize(lpx(36))
        .margin({
          top: lpx(24)
        })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
