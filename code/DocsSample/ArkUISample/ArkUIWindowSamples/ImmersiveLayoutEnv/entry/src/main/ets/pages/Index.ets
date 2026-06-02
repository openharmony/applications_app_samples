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
// [Start ImmersiveLayoutEnv_srart]
// [Start ImmersiveLayoutEnv3_srart]
 // [StartExclude ImmersiveLayoutEnv3_srart]
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @Env(SystemProperties.WINDOW_AVOID_AREA) avoidAreasVp: window.UIEnvWindowAvoidAreaInfoVP;
  @StorageProp('topAvoidHeight')
  topAvoidHeight: number = 0;
  @StorageProp('bottomAvoidHeight')
  bottomAvoidHeight: number = 0;
  @StorageProp('leftAvoidWidth')
  leftAvoidWidth: number = 0;
  @StorageProp('rightAvoidWidth')
  rightAvoidWidth: number = 0;
  @StorageLink('mainWindow')
  mainWindow: window.Window | undefined = undefined;
  // [StartExclude ImmersiveLayoutEnv_srart]
  @State orientationText: string = 'Unknown';
  @State statusText: string = 'Rotate the device or use the buttons below to test avoid areas and cutout handling.';

  private text: string = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '.repeat(10);

  aboutToAppear(): void {
    this.refreshOrientationText();
  }

  private refreshOrientationText(): void {
    if (!this.mainWindow) {
      this.orientationText = 'Window unavailable';
      return;
    }

    try {
      this.orientationText = `${this.mainWindow.getPreferredOrientation()}`;
    } catch (err) {
      this.orientationText = `Read orientation failed: ${JSON.stringify(err)}`;
    }
  }

  private async setOrientation(orientation: window.Orientation, label: string): Promise<void> {
    if (!this.mainWindow) {
      this.statusText = 'Main window is unavailable.';
      return;
    }

    try {
      await this.mainWindow.setPreferredOrientation(orientation);
      this.statusText = `setPreferredOrientation(${label}) success`;
      hilog.info(DOMAIN, 'ImmersiveLayout', this.statusText);
      this.refreshOrientationText();
    } catch (err) {
      this.statusText = `setPreferredOrientation(${label}) failed: ${JSON.stringify(err)}`;
      hilog.error(DOMAIN, 'ImmersiveLayout', this.statusText);
    }
  }
  // [EndExclude ImmersiveLayoutEnv3_srart]
  build() {
    Column() {
      Row() {
        Text('Top Container')
          .fontSize(40)
          .textAlign(TextAlign.Center)
          .width('100%')
      }
      .backgroundColor('#2786d9')
      .padding({
        top: this.avoidAreasVp.statusBar.topRect.height + 10,
        bottom: 10,
        left: this.avoidAreasVp.cutout.leftRect.width,
        right: this.avoidAreasVp.cutout.rightRect.width
      })

      Scroll() {
        Column({ space: 12 }) {
          Row() {
            Text(this.text)
              .fontSize(20)
          }

          Divider()

          Text(`topAvoidHeight: ${this.topAvoidHeight}`)
          Text(`bottomAvoidHeight: ${this.bottomAvoidHeight}`)
          Text(`leftAvoidWidth: ${this.leftAvoidWidth}`)
          Text(`rightAvoidWidth: ${this.rightAvoidWidth}`)
          Text(`preferredOrientation: ${this.orientationText}`)
          Text(this.statusText)
            .fontColor('#666666')

          Row({ space: 8 }) {
            Button('Auto Rotation')
              .layoutWeight(1)
              .onClick(() => {
                void this.setOrientation(window.Orientation.AUTO_ROTATION, 'AUTO_ROTATION');
              })

            Button('Portrait')
              .layoutWeight(1)
              .backgroundColor('#0A7A5A')
              .onClick(() => {
                void this.setOrientation(window.Orientation.PORTRAIT, 'PORTRAIT');
              })

            Button('Landscape')
              .layoutWeight(1)
              .backgroundColor('#AD5C00')
              .onClick(() => {
                void this.setOrientation(window.Orientation.LANDSCAPE, 'LANDSCAPE');
              })
          }
          .width('100%')

          Text('Cutout test: rotate the app and observe whether leftAvoidWidth / rightAvoidWidth change on a cutout device.')
            .fontColor('#666666')
        }
        .width('100%')
      }
      .backgroundColor(Color.White)
      .padding(20)
      .borderRadius(15)
      .width('80%')
      .margin({
        left: this.avoidAreasVp.cutout.leftRect.width,
        right: this.avoidAreasVp.cutout.rightRect.width
      })
      .layoutWeight(1)

      Row() {
        Text('Bottom Container')
          .fontSize(40)
          .textAlign(TextAlign.Center)
          .width('100%')
      }
      .backgroundColor('#96dffa')
      .padding({
        top: 10,
        bottom: this.avoidAreasVp.navigationIndicator.bottomRect.height + 10,
        left: this.avoidAreasVp.cutout.leftRect.width,
        right: this.avoidAreasVp.cutout.rightRect.width
      })
    }
    .width('100%')
    .height('100%')
    .padding({
      left: this.avoidAreasVp.cutout.leftRect.width,
      right: this.avoidAreasVp.cutout.rightRect.width
    })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#d5d5d5')
    .justifyContent(FlexAlign.SpaceBetween)
  }
  // [EndExclude ImmersiveLayoutEnv_srart]
}
// [End ImmersiveLayoutEnv_srart]
// [End ImmersiveLayoutEnv3_srart]
