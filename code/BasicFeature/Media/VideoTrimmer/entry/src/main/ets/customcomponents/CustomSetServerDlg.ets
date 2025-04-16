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

/**
 * 配置上传下载地址。
 */

import { common } from '@kit.AbilityKit';
import { urlUtils } from '../utils/UrlUtils';

@CustomDialog
export struct CustomSetServerDlg {
  serverUrl: string = '';
  controller: CustomDialogController; // 通过CustomDialogController类显示自定义弹窗
  cancel: () => void = () => {
  };

  build() {
    Column() {
      Row() {
        Text($r('app.string.video_trimmer_serverName'))
          .fontColor($r('app.color.video_trimmer_text_normal'))
          .fontFamily('HarmonyHeiTi')
          .fontSize($r('app.integer.video_trimmer_component_video_loading_text_font_size'))
          .width($r('app.integer.video_trimmer_update_server_width'))
          .textAlign(TextAlign.Start)
        TextInput({ text: this.serverUrl.toString() })
          .id('input_serverUrl')
          .height($r('app.integer.video_trimmer_server_input_height'))
          .width($r('app.string.video_trimmer_server_input_width'))
          .padding({ right: $r('app.integer.video_trimmer_server_5') })
          .onChange((val) => urlUtils.saveUrl(getContext(this) as common.UIAbilityContext, val))
      }
      .padding({ bottom: $r('app.integer.video_trimmer_component_video_playing_image_margin_left') })

      Row() {
        Button($r('app.string.video_trimmer_save'))
          .id('btn_save_serverUrl')
          .onClick(() => {
            urlUtils.saveUrl(getContext(this) as common.UIAbilityContext, this.serverUrl);
            this.controller.close();
          })
      }
    }
    .width($r('app.string.video_trimmer_lazy_foreach_list_page_list_width'))
    .height($r('app.integer.video_trimmer_server_dlg_height'))
    .padding({
      top: $r('app.integer.video_trimmer_server_margin_top'),
      bottom: $r('app.integer.video_trimmer_server_5'),
      left: $r('app.integer.video_trimmer_server_12'),
      right: $r('app.integer.video_trimmer_server_12')
    })
    .backgroundColor(Color.White)
    .borderRadius($r('app.integer.video_trimmer_server_borderRadius'))
  }
}