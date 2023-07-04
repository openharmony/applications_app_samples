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

let storage = new LocalStorage();

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('list') list: Array<object> = [{'cityTemperature':'', 'cityName': ''}];

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
        Row() {
          Text($r('app.string.city'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight('medium')
          Text(this.list[0]['cityName'])
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight('medium')
        }
        .height(40)
        Row() {
          Text($r('app.string.temperature'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight('medium')
          Text(this.list[0]['cityTemperature'])
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight('medium')
        }
        .height(40)
      }
      .width(this.FULL_WIDTH_PERCENT)
    }
    .backgroundColor(0xAFEEEE)
    .borderStyle(12)
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        'action': this.ACTION_TYPE,
        'abilityName': this.ABILITY_NAME,
        'params': {
          'message': this.MESSAGE
        }
      });
    })
  }
}