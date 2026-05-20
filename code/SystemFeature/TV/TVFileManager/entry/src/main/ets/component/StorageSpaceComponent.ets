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
import { StorageManager } from '../common/manager/StorageManager';
import lpx from '../common/utils/Lpx';
import { MLog } from '../common/utils/MLog';
import { Units } from '../common/utils/PixelUnitConversion';
import { Tools } from '../common/utils/Tools';

const TAG = 'StorageSpaceComponent';
@Component
export default struct StorageSpaceComponent {
  @State showFreeSize: [number, number] = [0, 0];
  @Prop @Watch('refreshPath') storagePath:string

  aboutToAppear(): void {
    MLog.print(TAG, `aboutToAppear storagePath:${this.storagePath}`);
    this.refreshSize(this.storagePath);
  }

  aboutToDisappear(): void {
    MLog.print(TAG, `aboutToDisappear`)
  }

  refreshPath(){
    this.refreshSize(this.storagePath);
  }

  refreshSize(path:string){
    MLog.print(TAG, `refreshSpaceSize path:${path}`);
    let pathSize = StorageManager.getFreeSpaceSize(path);
    MLog.print(TAG, `refreshSpaceSize pathSize:${JSON.stringify(pathSize)}`);
    this.showFreeSize = pathSize;
  }

  build() {
    Column() {
      Text($r('app.string.storage_space_text', `${Tools.byte2Str(this.showFreeSize[1] - this.showFreeSize[0]) + '/' + Tools.byte2Str(this.showFreeSize[1])}`))
        .minFontSize(10)
        .maxFontSize(36)
        .fontColor('#99000000')
        .maxLines(1)
        .width('100%')
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)
      Progress({
        value: (this.showFreeSize[1] - this.showFreeSize[0]) / 1000,
        total: this.showFreeSize[1] / 1000,
        type: ProgressType.Linear
      })
        .width(lpx(Units.px2vp(180)))
        .height(lpx(Units.px2vp(8)))
        .margin({ top: lpx(Units.px2vp(8)) })
        .color($r('app.color.storage_progress_color'))
        .backgroundColor('#A5ABB7')
        .style({ strokeWidth: lpx(Units.px2vp(10)) })

    }
    .alignItems(HorizontalAlign.Center)
    .size({ width:'100%', height:'100%' })
  }
}