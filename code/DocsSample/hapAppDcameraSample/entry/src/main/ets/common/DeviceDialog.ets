/*
 * Copyright (c) 2022-2025 Huawei Co., Ltd.
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
import deviceManager from '@ohos.distributedDeviceManager';
import Logger from '../utils/Logger';

const TAG: string = 'Sample_DeviceDialog';

@CustomDialog
export struct DeviceDialog {
  controller?: CustomDialogController;
  // Kept your original AppStorage and selectedIndex logic to ensure compatibility
  @StorageLink('deviceList') deviceList: Array<deviceManager.DeviceBasicInfo> = AppStorage.get('deviceList')!;
  private selectedIndex: number | undefined = 0;
  private onSelectedIndexChange: (selectedIndex: number | undefined) => void = () => {
  };

  // --- UI Optimization ---
  // @Builder for list item UI
  @Builder
  buildDeviceItem(item: deviceManager.DeviceBasicInfo, index: number | undefined) {
    // *** FIX: The 'let isSelected' variable declaration was removed from here ***
    // The logic is now placed directly inside the component attributes below.
    Row() {
      // 1. Selection indicator
      Circle({ width: 20, height: 20 })
        .fill(this.selectedIndex === index ? '#007DFF' : '#F1F3F5') // Logic is here
        .margin({ right: 15 })

      // 2. Device name
      Text(item.deviceName)
        .fontSize(16)
        .layoutWeight(1)
        .fontColor(this.selectedIndex === index ? '#007DFF' : Color.Black) // Logic is here
    }
    .width('100%')
    .padding({ top: 12, bottom: 12, left: 15, right: 15 })
    .backgroundColor(this.selectedIndex === index ? '#E8F1FF' : Color.Transparent) // Logic is here
    .borderRadius(10)
    .clip(true)
    // 3. Press effect for better interaction
    .stateStyles({
      pressed: {
        .backgroundColor('#F1F3F5')
      }
    })
    .onClick(() => {
      // 4. Smooth selection animation
      animateTo({ duration: 200 }, () => {
        Logger.info(TAG, `select device: ${item.deviceId}`);
        if (index !== undefined) {
          Logger.info(TAG, `onSelectedIndexChange: ${index}`);
          this.selectedIndex = index;
          this.onSelectedIndexChange(this.selectedIndex);
        }
      });
    });
  }

  build() {
    Column() {
      // Title
      Text($r('app.string.choiceDevice'))
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 15 })

      // List
      List({ space: 10 }) {
        ForEach(this.deviceList, (item: deviceManager.DeviceBasicInfo, index: number | undefined) => {
          ListItem() {
            // Call the @Builder function to construct the item
            this.buildDeviceItem(item, index);
          }
        }, (item: deviceManager.DeviceBasicInfo) => item.deviceName);
      }
      .width('100%')
      .layoutWeight(1)

      // Button
      Button() {
        Text($r('app.string.cancel'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(44)
      .type(ButtonType.Capsule)
      .backgroundColor('#F1F3F5')
      .fontColor(Color.Black)
      .margin({ top: 20 })
      .onClick(() => {
        if (this.controller !== undefined) {
          this.controller.close();
        }
      });
    }
    // Overall dialog styling
    .width('85%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .shadow({ radius: 10, color: '#1F000000', offsetX: 0, offsetY: 5 });
  }
}