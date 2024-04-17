/*
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

let Update_4_4 = new LocalStorage();

@Entry(Update_4_4)
@Component
struct Widget_4_4Card {
  @LocalStorageProp('hour') hour: ResourceStr = '';
  @LocalStorageProp('minute') minute: ResourceStr = '';
  @LocalStorageProp('second') second: ResourceStr = '';
  /*
   * The title.
   */
  readonly TITLE: string = 'Hello World';
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
   * The width percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  build() {
    Row() {
      Column() {
        Text($r('app.string.widget_4_4_desc'))
          .fontSize(30)
          .fontColor(Color.White)
        Text(`${this.hour.toString().padStart(2, '0')}:${this.minute.toString()
          .padStart(2, '0')}:${this.second.toString().padStart(2, '0')}`)
          .fontSize(30)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
      }
      .width(this.FULL_WIDTH_PERCENT)
    }
    .backgroundImage($r('app.media.test'))
    .backgroundImageSize(ImageSize.Cover)
    .height(this.FULL_HEIGHT_PERCENT)
    .onClick(() => {
      postCardAction(this, {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      });
    })
  }
}