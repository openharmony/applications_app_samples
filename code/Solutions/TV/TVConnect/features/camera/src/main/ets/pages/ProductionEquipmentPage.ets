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
import { CommonConstants, PageViewUtils } from '@ohos/common';
import { HMRouter } from '@hadss/hmrouter';
import { AddEquipments } from '../components/home/addEquipments';
import { ConfigurationWizard } from '../components/home/configurationWizard';
import { ConnectingDevice } from '../components/home/connectingDevice';
import { ProductionDifficulty } from '../components/home/productionDifficulty';
import { SelectionSort } from '../components/home/selectionSort';
import { ProductionEquipmentEnum } from '../model/utils/ConfigEnum';

@HMRouter({ pageUrl: 'ProductionEquipmentPage' })
@Component
export struct ProductionEquipmentPage {
  @Provide deviceType: string = ProductionEquipmentEnum.ADDEQUIPMENTS; // 当前类型

  build() {
    Column() {
      Row() {
        Button('发送转向').onClick(() => {

        });
      }.width('100%').padding({ left: 12, top: 12 });

      if (this.deviceType === ProductionEquipmentEnum.ADDEQUIPMENTS) {
        // 添加设备
        AddEquipments({
          succ: () => {
            this.deviceType = ProductionEquipmentEnum.SELECTIONSORT;
          }
        });
      } else if (this.deviceType === ProductionEquipmentEnum.SELECTIONSORT) {
        // 设备选择
        SelectionSort({
          succ: () => {
            this.deviceType = ProductionEquipmentEnum.CONFIGURATIONWIZARD;
          },
          close: () => {
            this.deviceType = ProductionEquipmentEnum.ADDEQUIPMENTS;
          }
        });
      } else if (this.deviceType === ProductionEquipmentEnum.CONFIGURATIONWIZARD) {
        // 配置向导
        ConfigurationWizard({
          succ: () => {
            this.deviceType = ProductionEquipmentEnum.CONNECTINGDEVICE;
          },
          close: () => {
            this.deviceType = ProductionEquipmentEnum.SELECTIONSORT;
          }
        });
      } else if (this.deviceType === ProductionEquipmentEnum.CONNECTINGDEVICE) {
        // 连接设备
        ConnectingDevice({
          succ: () => {
            this.deviceType = ProductionEquipmentEnum.PRODUCTIONDIFFICULTY;
          },
          close: () => {
            this.deviceType = ProductionEquipmentEnum.CONFIGURATIONWIZARD;
          }
        });
      } else if (this.deviceType === ProductionEquipmentEnum.PRODUCTIONDIFFICULTY) {
        // 生产设备、故障管理
        ProductionDifficulty({
          succ: () => {
          },
          close: () => {
            this.deviceType = ProductionEquipmentEnum.CONNECTINGDEVICE;
          }
        });
      }
    }
    .onAppear(() => {
      setTimeout(() => {
        PageViewUtils.tabClick();
      }, 500);
    })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}