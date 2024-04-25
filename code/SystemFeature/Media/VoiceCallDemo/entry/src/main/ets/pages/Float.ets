/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Constants from '../Constants';
import ComponentSingletonTimer from '../components/ComponentSingletonTimer';
import common from '@ohos.app.ability.common';

/**
 * 悬浮窗UI
 */
@Entry
@Component
struct Float {
  @StorageLink('UI_EVENT') mUIEvent: number = -1;

  build() {
    Column() {
      if (this.mUIEvent === Constants.EVENT_UI_CALL) { //请求通话页面
        FloatComponent({ res: $r('app.media.icon_openvalley_call_green'), tips: $r('app.string.tips_call') })
      } else if (this.mUIEvent === Constants.EVENT_UI_ANSWER) { // 来电页面
        FloatComponent({ res: $r('app.media.icon_openvalley_call_green'), tips: $r('app.string.tips_answer') })
      } else if (this.mUIEvent === Constants.EVENT_UI_VOICE) { //通话页面
        FloatComponent({ res: $r('app.media.icon_openvalley_call_green') })
      }
    }
    .id('switch_window_to_index')
    .backgroundColor($r('app.color.color_transparent'))
    .width('100%')
    .height('100%')
    .onClick(() => {
      let context = getContext(this) as common.UIAbilityContext; // UIAbilityContext
      context.startAbility({
        bundleName: context.abilityInfo.bundleName,
        abilityName: context.abilityInfo.name
      })
    })
  }
}

@Component
struct FloatComponent {
  private res?: Resource;
  private tips?: Resource;

  build() {

    Column() {
      if (this.res) {
        Image(this.res)
          .objectFit(ImageFit.Contain)
          .width('40%')
          .height('40%')
      }

      if (this.tips) {
        Text(this.tips)
          .fontSize(14)
          .fontColor($r('app.color.color_green'))
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyOS Sans SC')
      } else {
        ComponentSingletonTimer({ mTextColor: $r('app.color.color_green'), mTextSize: 14 })
      }
    }
    .backgroundColor($r('app.color.color_fff'))
    .borderRadius(16)
    .justifyContent(FlexAlign.SpaceAround)
    .width('100%')
    .height('100%')
  }
}