/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

@Entry
@Component
struct DynamicMusicLockUltraLongCard {
  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'SecondAbility';

  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  @Builder
  build() {
    Column() {
      Row() {
        Column() {
          Text('Happier')
            .textAlign(TextAlign.Start)
            .fontSize('40px')
            .fontWeight(700)
            .fontColor('#b3ffffff')
          Text('Billie Eilish')
            .textAlign(TextAlign.Start)
            .fontSize('20px')
            .fontWeight(500)
            .fontColor('#b3ffffff')
        }
        .alignItems(HorizontalAlign.Start)
        .height('70px')
        .margin({
          top: '16px',
          left: '10px'
        })

        Column() {
          Row() {
            Image($r('app.media.ic_public_music'))
              .objectFit(ImageFit.Auto)
              .width('72px')
              .height('72px')
          }
          .height('100%')
          .alignItems(VerticalAlign.Center)
        }
      }
      .alignItems(VerticalAlign.Top)
      .height(this.FULL_HEIGHT_PERCENT)
    }
    .backgroundColor('#339a89')
    .width(this.FULL_WIDTH_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        'action': this.ACTION_TYPE,
        'abilityName': this.ABILITY_NAME,
        'params': {
          data: 'dynamic'
        },
      });
    })
  }
}