/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { SwipeRefresher } from '@ohos.arkui.advanced.SwipeRefresher';

@CustomDialog
export struct DiaLogComponent {
  @Consume dialogText: string | Resource;
  @Consume loadStatus: LoadType;
  controller: CustomDialogController = new CustomDialogController({ builder: DiaLogComponent({}), });

  build() {
    Row() {
      Text(this.dialogText)
        .fontSize($r('app.string.font_20'))
        .fontColor('#333333');
      Blank();
      if (this.loadStatus == LoadType.LOADING) {
        SwipeRefresher({ content: '', isLoading: true }).height(30).width(30);
      }
      if (this.loadStatus == LoadType.SUCC) {
        Image($r('app.media.ic_select')).height(20).width(20).fillColor('#ff209cef');
      }
      if (this.loadStatus == LoadType.FAIL) {
        Image($r('app.media.ic_public_cancel')).height(20).width(20).fillColor('#ffee2929');
      }
    }
    .height(70)
    .width('30%')
    .backgroundColor('#D8D8D8')
    .borderRadius(10)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 20, right: 20 });
  }
}

export enum LoadType {
  SUCC = 0, LOADING, FAIL
}