/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start access_global_config]
import { config } from './Config';
import { taskpool } from '@kit.ArkTS';

@Concurrent
async function download() {
  if (!await config.isWifiOn()) {
    console.info('wifi is off');
    return false;
  }
  if (!await config.getIsLogin()) {
    console.info('not login');
    return false;
  }
  console.info(`User[${await config.getUser()}] start download ...`);
  return true;
}

@Entry
@Component
struct Index {
  @State message: string = 'not login';
  @State wifiState: string = 'wifi off';
  @State downloadResult: string = '';
  input: string = '';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
        TextInput({ placeholder: '请输入用户名' })
          .id('textInput')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onChange((value) => {
            this.input = value;
          })
        Text('login')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            if (!await config.getIsLogin() && this.input) {
              this.message = 'login: ' + this.input;
              config.login(this.input);
            }
          })
          .backgroundColor(0xcccccc)
        Text('logout')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            if (await config.getIsLogin()) {
              this.message = 'not login';
              config.logout();
            }
          })
          .backgroundColor(0xcccccc)
        Text(this.wifiState)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
        Toggle({ type: ToggleType.Switch })
          .onChange(async (isOn: boolean) => {
            await config.setWifiState(isOn)
            this.wifiState = isOn ? 'wifi on' : 'wifi off';
          })
        Text('download')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(async () => {
            let ret = await taskpool.execute(download);
            this.downloadResult = ret ? 'download success' : 'download fail';
          })
        Text(this.downloadResult)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End access_global_config]