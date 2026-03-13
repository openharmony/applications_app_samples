/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { Router } from '@ohos.arkui.UIContext';
const router = new Router();

@Entry
@Component
struct Index {
  build() {
    Column() {
      Scroll() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
          this.buttonComponent($r('app.string.create_avSession'), 'pages/CreateAVSession');
          this.buttonComponent($r('app.string.setting_metadata'), 'pages/SetAVMetadata');
          this.buttonComponent($r('app.string.adapting_bluetooth_method_one'), 'pages/AdaptingToBluetoothMethodOne');
          this.buttonComponent($r('app.string.adapting_bluetooth_method_two'), 'pages/AdaptingToBluetoothMethodTwo');
          this.buttonComponent($r('app.string.display_tags_media_assets'), 'pages/DisplayTagsOfMediaAssets');
          this.buttonComponent($r('app.string.favoriting_media_assets'), 'pages/FavoritingMediaAssets');
          this.buttonComponent($r('app.string.handling_unsupported_commands'), 'pages/HandlingUnsupportedCommands');
          this.buttonComponent($r('app.string.performing_progress_control'), 'pages/PerformingProgressControl');
          this.buttonComponent($r('app.string.setting_fast_forward'), 'pages/SettingFastForward');
          this.buttonComponent($r('app.string.setting_general_state_information'), 'pages/SettingGeneralStateInformation');
          this.buttonComponent($r('app.string.setting_lyrics'), 'pages/SettingLyrics');
          this.buttonComponent($r('app.string.setting_playlist_information'), 'pages/SettingPlaylistInformation');
          this.buttonComponent($r('app.string.setting_loop_mode'), 'pages/SettingTheLoopMode');
          this.buttonComponent($r('app.string.setting_progress_bar'), 'pages/SettingTheProgressBar');
        }
        .width('100%')
        .padding(20)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buttonComponent(name: string | ResourceStr, dstUri: string) {
    Button(name)
      .width('80%')
      .height('auto')
      .padding({ top: 8, bottom: 8, left: 12, right: 12 })
      .margin({ bottom: 8 })
      .fontSize(13)
      .onClick((e: ClickEvent) => {
        router.pushUrl({ url: dstUri });
      })
  }
}