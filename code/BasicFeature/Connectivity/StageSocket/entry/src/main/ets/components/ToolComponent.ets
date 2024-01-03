/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import startAbility from '../utils/AbilityUtil';
import ToolData from '../data/ToolData';
import Constants from '../Constants';
import Want from '@ohos.app.ability.Want';

@Component
export default struct ToolComponent {
  private toolArray: Array<ToolData>; // 功能数组 暂只有语音通话

  build() {
    Row() {
      ForEach(this.toolArray, (item: ToolData, index) => {
        Button() {
          Image(item.getImgResource())
            .width(40)
            .height(40)
            .objectFit(ImageFit.Contain)
        }
        .width(100)
        .height(100)
        .borderRadius(10)
        .type(ButtonType.Normal)
        .backgroundColor(Color.White)
        .margin({ left: 10 })
        .onClick(() => {
          let want: Want = {
            bundleName: item.getBundleName(),
            abilityName: item.getAbilityName(),
            parameters: item.getParameters()
          };
          AppStorage.setOrCreate('indexMsg', Constants.START_ABILITY_EVENT_ANSWER);
          AppStorage.setOrCreate('indexMsg', 'clear');
          startAbility(want);
        })
      }, (item: ToolData) => JSON.stringify(item))
    }
    .width('100%')
    .height('99%')
    .margin(10)
    .alignItems(VerticalAlign.Top)
  }
}
