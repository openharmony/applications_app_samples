/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { CameraManager } from 'camera';
import { findRangeIndex, toFixed } from '../utils/CommonUtil';

@Component
struct ZoomButtonsView {
  @Prop @Require zooms: number[];
  @Prop @Require zoomRange: number[] = [];
  @Link currentZoom: number;
  @Require cameraManager: CameraManager;

  getZoomButtonText(zoom: number, index: number): string {
    const minZoom = this.zoomRange[0];
    const currentZoomIndex: number = findRangeIndex(this.currentZoom, this.zooms);
    if (index === 0 && (this.currentZoom === minZoom || currentZoomIndex !== index)) {
      return 'w';
    }
    if (this.currentZoom === zoom || currentZoomIndex !== index) {
      return `${zoom}x`;
    }
    return `${toFixed(this.currentZoom, 1)}x`;
  }

  getZoomButtonBorderWidth(index: number): number {
    const currentZoomIndex: number = findRangeIndex(this.currentZoom, this.zooms);
    return currentZoomIndex === index ? 1.5 : 0;
  }

  build() {
    Row({ space: 15 }) {
      ForEach(this.zooms, (zoom: number, index: number) => {
        Text(this.getZoomButtonText(zoom, index))
          .width(36)
          .height(36)
          .fontColor(Color.White)
          .fontSize(10)
          .fontWeight(FontWeight.Bold)
          .borderWidth(this.getZoomButtonBorderWidth(index))
          .borderColor(Color.White)
          .borderRadius('50%')
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.cameraManager.setSmoothZoom(zoom)
            this.currentZoom = zoom
          })
      }, (zoom: number) => zoom.toString())
    }
    .margin({ bottom: 40 })
    .alignRules({
      bottom: { anchor: 'modeButtonsView', align: VerticalAlign.Top },
      middle: { anchor: 'modeButtonsView', align: HorizontalAlign.Center }
    })
  }
}
export default ZoomButtonsView;