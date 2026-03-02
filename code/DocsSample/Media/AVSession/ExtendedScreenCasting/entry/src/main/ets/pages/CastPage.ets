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

// [Start show_castPage]
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct CastPage {
  // 监测到CastDisplayState变化后，当设备断开时，销毁本页内容。
  @StorageLink('CastDisplayState') @Watch('onDestroyExtend') private displayState: number = 1;
  public context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  private onDestroyExtend() {
    if (this.displayState === 1) { return };
    this.context.terminateSelf().then(() => {
      console.info('CastPage finished');
    }).catch((err: BusinessError) => {
      console.error(`Failed to destroying CastPage. Code: ${err.code}, message: ${err.message}`);
    });
  }

  build() {
    RelativeContainer() {
      Row() {
        Image($r('app.media.video_cover_0'))
          .height('100%')
          .width('100%')
          .borderRadius(10)
      }
    }
  }
}
// [End show_castPage]