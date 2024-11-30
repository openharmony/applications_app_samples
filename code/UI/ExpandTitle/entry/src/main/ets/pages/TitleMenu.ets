/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { promptAction } from '@kit.ArkUI';

@Builder
export function titleMenu(): void {
  TitleMenu();
}

/**
 * 菜单栏
 *
 */
@Component
struct TitleMenu {
  // toast弹窗时长
  private toastDuration: number = 2000;

  build() {
    Row() {
      Image($r('app.media.expanded_title_is_public_add'))
        .width($r('app.string.expanded_title_menu_pic_layout'))
        .height($r('app.string.expanded_title_menu_pic_layout'))
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.expanded_title_toast_hint_message'),
            duration: this.toastDuration
          });
        })
      Image($r('app.media.expanded_title_ic_public_more'))
        .width($r('app.string.expanded_title_menu_pic_layout'))
        .height($r('app.string.expanded_title_menu_pic_layout'))
        .margin({ left: $r('app.string.expanded_title_layout_8') })
        .onClick(() => {
          promptAction.showToast({
            message: $r('app.string.expanded_title_toast_hint_message'),
            duration: this.toastDuration
          });
        })
    }
    .height($r('app.string.expanded_title_layout_100_percent'))
  }
}