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
import {
  EmptyComponents,
  SingleSelectComponents,
  StepOneComponents,
  StepSlideComponents,
  StringComponents,
  PowerComponents,
  ProductComponents
} from './ComponentsView';
import { Characteristics, CharacteristicType, ProfileManager, ProfileModel, ProfileServices } from './ViewModel';
import { HttpApi } from '@ohos/connect_cloud';
import { Logger } from '@ohos/common';

const TAG = 'ProfileComponents';

@Component
export struct ProfileComponents {
  @Provide profileManager: ProfileManager = new ProfileManager();
  @Prop productId: string;
  @Prop gatewayId: string;
  @Prop deviceId: string;
  @Prop projectId: string;

  aboutToAppear(): void {
    Logger.info('ProfileComponents',
      `===>aboutToAppear productId: ${this.productId}, gatewayId: ${this.gatewayId}, deviceId:${this.deviceId}, projectId:${this.projectId}`);
    this.profileManager.initProfileModel(this.projectId, this.deviceId, this.productId, this.gatewayId);
    HttpApi.getInstance().getDevAllSnapshotMsg(this.deviceId, this.projectId);
  }

  aboutToDisappear(): void {
    this.profileManager.unregisterListener();
  }

  @Builder
  controlComponents(serviceId: string, serviceType: string, item: Characteristics, showTitle: boolean) {
    if (item.characteristicType == CharacteristicType.ENUM || item.characteristicType == CharacteristicType.BOOL) {
      SingleSelectComponents({
        serviceId,
        serviceType,
        characteristic: item,
        showTitle
      });
    } else if (item.characteristicType == CharacteristicType.INT ||
      item.characteristicType == CharacteristicType.FLOAT) {
      if (item.unitType?.step == 1) {
        StepOneComponents({
          serviceId,
          serviceType,
          characteristic: item,
          showTitle
        });
      } else {
        StepSlideComponents({
          serviceId,
          serviceType,
          characteristic: item,
          showTitle
        });
      }
    } else if (item.characteristicType == CharacteristicType.STRING) {
      StringComponents({
        serviceId,
        serviceType,
        characteristic: item,
        showTitle
      });
    } else {
      EmptyComponents();
    }
  }

  @Builder
  buildComponents(serviceId: string, serviceType: string, item: Characteristics, showTitle: boolean) {
    if (item.characteristicType == CharacteristicType.ENUM || item.characteristicType == CharacteristicType.BOOL) {
      SingleSelectComponents({
        serviceId,
        serviceType,
        characteristic: item,
        showTitle
      });
    } else if (item.characteristicType == CharacteristicType.INT ||
      item.characteristicType == CharacteristicType.FLOAT) {
      if (item.unitType?.step == 1) {
        StepOneComponents({
          serviceId,
          serviceType,
          characteristic: item,
          showTitle
        });
      } else {
        StepSlideComponents({
          serviceId,
          serviceType,
          characteristic: item,
          showTitle
        });
      }
    } else if (item.characteristicType == CharacteristicType.STRING) {
      if (serviceId !== 'gps' || serviceType !== 'gps') {
        StringComponents({
          serviceId,
          serviceType,
          characteristic: item,
          showTitle
        });
      }
    } else {
      EmptyComponents();
    }
  }

  build() {
    Column() {
      List() {
        ForEach(this.profileManager.getProfileModelList(), (item: ProfileServices) => {
          if (item.serviceId == 'OnAndOff') {
            ListItem() {
              PowerComponents({ serviceId: item.serviceId });
            }
            .width('100%')
            .padding(0)
            .borderRadius(0)
            .backgroundColor($r('sys.color.ohos_id_color_sub_background_transparent'))
            .margin({ bottom: $r('app.string.16_vp') });
          } else {
            ListItem() {
              Column() {
                if (item.serviceName != '位置信息') {
                  Text(item.serviceName == '开关' ? '熄屏' : item.serviceName)
                    .fontSize($r('app.string.font_18'))
                    .fontColor($r('sys.color.ohos_id_color_foreground_contrary'))
                    .fontWeight(FontWeight.Medium)
                    .fontFamily('HarmonyHeiTi');
                }
                ForEach(item.characteristics, (characteristic: Characteristics) => {
                  this.buildComponents(item.serviceId, item.serviceType, characteristic,
                    item.characteristics.length > 1);
                });
              }.alignItems(HorizontalAlign.Start)
              .width('100%');
            }
            .width('50%')
            .borderRadius($r('app.string.16_vp'))
            .margin({ bottom: $r('app.string.24_vp') });
          }

        }, (item: ProfileModel) => JSON.stringify(item));
      }
      .padding({ left: $r('app.string.12_vp'), right: $r('app.string.12_vp') })
      .width('100%')
      .flexShrink(1)
      .alignListItem(ListItemAlign.Center);
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%');
  }
}