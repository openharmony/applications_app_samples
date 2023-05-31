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
import { ConfigType, getConfig, saveConfig } from '../util/ConfigUtil'

@CustomDialog
export default struct ServiceConfigDialog {
  controller: CustomDialogController
  @State currentHost: string = "";
  @State currentPath: string = "";

  async aboutToAppear() {
    this.currentHost = await getConfig(getContext(this), ConfigType.host)
    this.currentPath = await getConfig(getContext(this), ConfigType.path)
  }

  async onSave() {
    await saveConfig(getContext(this), ConfigType.host, this.currentHost)
    await saveConfig(getContext(this), ConfigType.path, this.currentPath)
  }

  build() {
    Column() {
      Text($r('app.string.config_dialog_host_tip'))
        .fontSize($r('app.float.config_dialog_font_size'))
      TextInput({ text: this.currentHost })
        .width('100%')
        .margin({ top: $r('app.float.config_dialog_margin_top') })
        .onChange((value: string) => {
          this.currentHost = value;
        })
      Text($r('app.string.config_dialog_path_tip'))
        .fontSize($r('app.float.config_dialog_font_size'))
        .margin({ top: $r('app.float.config_dialog_margin_top') })
      TextInput({ text: this.currentPath })
        .width('100%')
        .margin({ top: $r('app.float.config_dialog_margin_top') })
        .onChange((value: string) => {
          this.currentPath = value;
        })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.config_dialog_button_cancel'))
          .onClick(() => {
            this.controller.close()
          })
          .padding({
            left: $r('app.float.config_dialog_button_left_padding'),
            right: $r('app.float.config_dialog_button_left_padding')
          })
        Button($r('app.string.config_dialog_button_confirm'))
          .onClick(() => {
            this.controller.close()
            this.onSave()
          })
          .padding({
            left: $r('app.float.config_dialog_button_left_padding'),
            right: $r('app.float.config_dialog_button_left_padding')
          })
      }.margin({ top: $r('app.float.config_dialog_margin_top') })
    }.alignItems(HorizontalAlign.Start)
    .padding($r('app.float.config_dialog_top_padding'))
  }
}