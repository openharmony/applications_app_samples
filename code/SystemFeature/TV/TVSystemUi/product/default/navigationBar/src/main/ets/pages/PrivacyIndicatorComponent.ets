/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { ViewModel } from '../viewmodel/ViewModel';
import IndicatorStyle, { IndicatorType } from '../common/IndicatorConfig';

@Entry
@Component
export default struct PrivacyIndicatorComponent {
  private mViewModel: ViewModel = new ViewModel();
  @State mBackgroundColor: Resource = $r('app.color.transparent');

  aboutToAppear(): void {
    this.mViewModel = new ViewModel();
    this.mViewModel.setCallback((type: number) => {
      if (type == IndicatorType.TYPE_ORANGE) {
        this.mBackgroundColor = $r('sys.color.ohos_id_color_alert');
      } else if (type == IndicatorType.TYPE_GREEN) {
        this.mBackgroundColor = $r('sys.color.ohos_id_color_connected');
      } else if (type == IndicatorType.TYPE_BLUE) {
        this.mBackgroundColor = $r('sys.color.ohos_id_color_activated');
      } else {
        // 不显示
        this.mBackgroundColor = $r('app.color.transparent');
      }
    });
    this.mViewModel.registerPrivacyStateListener();
  }

  aboutToDisappear(): void {
    if (this.mViewModel != null) {
      this.mViewModel.unregisterPrivacyStateListener();
    }
  }

  build() {
    Row() {
      Text()
        .width(IndicatorStyle.indicatorSize)
        .height(IndicatorStyle.indicatorSize)
        .borderRadius(IndicatorStyle.indicatorBorderRadius)
        .backgroundColor(this.mBackgroundColor)
        .margin({ top: IndicatorStyle.indicatorTopMargin, right: IndicatorStyle.indicatorRightMargin });
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(VerticalAlign.Top)
  }
}