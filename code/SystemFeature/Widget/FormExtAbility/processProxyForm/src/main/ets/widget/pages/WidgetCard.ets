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

const ACTION_TYPE: string = 'router';
const ABILITY_NAME: string = 'EntryAbility';
const MESSAGE: string = 'add detail';
const FULL_WIDTH_PERCENT: string = '100%';
const FULL_HEIGHT_PERCENT: string = '100%';

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('cityName') cityName: string = '';
  @LocalStorageProp('cityTemperature') cityTemperature: string = '';

  build() {
    Row() {
      Column() {
        Row() {
          Text($r('app.string.city'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight('medium')
          Text(this.cityName)
            .fontSize($r('sys.float.ohos_id_text_size_body3'))
            .fontWeight('regular')
        }
        Row() {
          Text($r('app.string.temperature'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontWeight('medium')
          Text(this.cityTemperature + ' ℃')
            .fontSize($r('sys.float.ohos_id_text_size_body3'))
            .fontWeight('regular')
        }
      }
      .width(FULL_WIDTH_PERCENT)
    }
    .backgroundColor(0xAFEEEE)
    .width((FULL_WIDTH_PERCENT))
    .borderStyle(12)
    .borderRadius(16)
    .opacity(0.5)
    .height(FULL_HEIGHT_PERCENT)
    .onClick(() => {
      class ParamsType {
        message: string = '';
      };

      class ActionType {
        action: string = '';
        abilityName: string = '';
        params: ParamsType = { message: '' };
      };
      let action: ActionType = {
        action: ACTION_TYPE,
        abilityName: ABILITY_NAME,
        params: {
          message: MESSAGE
        }
      };
      postCardAction(this, action);
    })
  }
}