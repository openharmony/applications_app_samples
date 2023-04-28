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
import Resource2String from '../../utils/StringUtil';

@Component
export struct SearchBar {
  private stringUtil: Resource2String = new Resource2String(getContext(this));

  build() {
    Column() {
      Row() {
        Image($r('app.media.search'))
          .size({ width: 20, height: 20 })
          .margin({ left: 12, right: 12 })
        Text($r('app.string.mobile_phone'))
          .fontSize(16)
          .fontColor(Color.Gray)
      }
      .borderRadius(30)
      .alignItems(VerticalAlign.Center)
      .size({ width: '100%', height: 35 })
      .backgroundColor($r('app.color.white'))
      .margin({ top: 6, bottom: 6 })
      .onClick(async () => {
        let option: router.RouterOptions = {
          url: '@bundle:com.samples.asorangeshopping/search/ets/pages/SearchPage',
          params: {
            // TODO 资源文件转换有问题，暂时用字符串替代  await this.stringUtil.getString($r('app.string.mobile_phone'))
            placeHolder: '5G',
          }
        };
        router.pushUrl(option);
      })
    }
  }
}