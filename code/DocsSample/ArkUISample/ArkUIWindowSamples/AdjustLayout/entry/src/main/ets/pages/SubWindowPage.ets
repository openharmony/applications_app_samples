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

// [Start startMoving]
// SubWindowPage.ets
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const DOMAIN = 0x0000;
const TAG = 'Sample_AdjustLayout';

@Entry
@Component
struct SubWindowPage {
  @StorageProp('WINDOW_SIZE') windowSize: window.Size = {
    width: 600,
    height: 300
  };

  @StorageLink('SUB_WINDOW_VISIBILITY_ENABLED') showSubWindowEnabled: boolean = false;
  @StorageProp('SUB_WINDOW_RESIZE_ENABLED') resizeEnabled: boolean = true;
  @StorageProp('SUB_WINDOW_MOVE_ENABLED') moveEnabled: boolean = true;

  private isCompact(): boolean {
    return this.windowSize.width < 500 || this.windowSize.height < 240;
  }

  /**
   通过startMoving为子窗口接入系统拖拽移动
   */
  private startMoveSubWindow(): void {
    const subWindow = AppStorage.get<window.Window>('SUB_WINDOW');
    if (!subWindow) {
      return;
    }
    subWindow.startMoving().then(() => {
      hilog.info(DOMAIN, TAG, 'startMoving success');
    }).catch((err: Error) => {
      const businessError = err as BusinessError;
      hilog.error(DOMAIN, TAG, `startMoving failed: ${JSON.stringify(businessError)}`);
    });
  }

  build() {
    Column() {
      Row() {
        Text(this.moveEnabled ? 'Sub Window - Move Enabled' : 'Sub Window - Move Disabled')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
        Blank()
        Text(`${this.windowSize.width} × ${this.windowSize.height}`)
          .fontSize(12)
          .fontColor('#DDE7FF')
      }
      .height(44)
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor(this.moveEnabled ? '#2F5BEA' : '#666666')
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down && this.moveEnabled) {
          this.startMoveSubWindow();
        }
      })

      Column() {
        Text('当前子窗口大小')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)

        Text(`width = ${this.windowSize.width}px`)
          .fontSize(14)
          .margin({ top: 8 })

        Text(`height = ${this.windowSize.height}px`)
          .fontSize(14)
          .margin({ top: 4 })

        Text(this.resizeEnabled ? '大小拖拽：开启' : '大小拖拽：关闭')
          .fontSize(13)
          .fontColor('#666666')
          .margin({ top: 12 })

        Text(this.moveEnabled ? '位置拖拽：开启' : '位置拖拽：关闭')
          .fontSize(13)
          .fontColor('#666666')
          .margin({ top: 4 })

        if (this.isCompact()) {
          Text('Compact Layout')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 16 })
        } else {
          Row() {
            Column() {
              Text('Left Panel')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .width('45%')
            .height(80)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#EEF3FF')

            Column() {
              Text('Right Panel')
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .width('55%')
            .height(80)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#FFFFFF')
          }
          .width('100%')
          .margin({ top: 16 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .border({
      width: 4,
      color: '#FF4D4F',
      radius: 0
    })
  }
}
// [End startMoving]