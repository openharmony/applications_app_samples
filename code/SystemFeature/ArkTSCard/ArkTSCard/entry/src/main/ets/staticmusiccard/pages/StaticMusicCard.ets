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

@Entry
@Component
struct StaticMusicCard {
  /*
   * The title.
   */
  readonly TITLE: Resource = $r('app.string.music');

  /*
   * The CARD_TYPE.
   */
  readonly CARD_TYPE: Resource = $r('app.string.static');

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'SecondAbility';

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';


  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  build() {
    FormLink({
      action: this.ACTION_TYPE,
      abilityName: this.ABILITY_NAME,
      params: {
        data: 'static'
      }
    }) {
      Row() {
        Column() {
          Image($r('app.media.18'))
            .width('96px')
            .height('96px')
            .borderRadius('24px')
            .margin({
              left: 12
            })
        }

        Column() {
          Text(this.TITLE)
            .textAlign(TextAlign.Start)
            .fontSize(18)
            .fontColor('#182431')
            .fontWeight(500)
          Text(this.CARD_TYPE)
            .textAlign(TextAlign.Start)
            .fontSize(14)
            .fontColor('#182431')
            .fontWeight(400)
            .opacity(0.6)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({
          left: '12px'
        })
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(this.FULL_HEIGHT_PERCENT)
    }
  }
}