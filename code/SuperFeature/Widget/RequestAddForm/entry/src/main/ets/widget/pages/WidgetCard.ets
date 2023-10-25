/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Entry
@Component
struct WidgetCard {
  /*
   * The title.
   */
  readonly TITLE: string = 'App Store';
  readonly TITLE_CARD: string = 'ArkTs Widget Card';

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'EntryAbility';

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

  build() {
    Row() {
      Column() {
        Text(this.TITLE)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontWeight('medium')
        Text(this.TITLE_CARD)
          .fontSize($r('sys.float.ohos_id_text_size_body3'))
          .fontWeight('regular')
          .margin({
            top: 10
          })
      }
      .width(this.FULL_WIDTH_PERCENT)
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .width((this.FULL_WIDTH_PERCENT))
    .borderStyle(12)
    .onClick(() => {
      class ParamsData {
        message: string = '';
      };

      class ActionType {
        action: string = '';
        abilityName: string = '';
        params: ParamsData = { message : '' };
      };
      let action: ActionType = {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      };
      postCardAction(this, action);
    })
    .borderRadius(0)
  }
}