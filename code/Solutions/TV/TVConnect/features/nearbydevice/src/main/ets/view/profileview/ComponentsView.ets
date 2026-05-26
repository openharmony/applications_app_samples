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
import { ClickCheck, Logger } from '@ohos/common';
import {
  CharacteristicPermissions,
  Characteristics,
  EnumEntry,
  EnumList,
  isSupportPermissions,
  ProfileManager,
  UnitType
} from './ViewModel';
import { promptAction } from '@kit.ArkUI';
import { cloudDeviceRadio } from '../DeviceItemComponent';

const TAG = 'ComponentsView';

@Extend(Row)
function rowStyle() {
  .alignItems(VerticalAlign.Center)
  .justifyContent(FlexAlign.SpaceBetween)
  .width('100%')
  .height($r('app.string.80_vp'));
}

@Extend(Text)
function titleStyle() {
  .fontSize($r('app.string.font_16'))
  .fontColor($r('app.color.default_text_color'))
  .fontWeight(FontWeight.Medium)
  .fontFamily('HarmonyHeiTi');
}

@Extend(Text)
function valueStyle() {
  .fontSize($r('app.string.font_14'))
  .fontColor($r('sys.color.ohos_id_color_text_secondary'))
  .fontFamily('HarmonyHeiTi');
}

@Component
export struct PowerComponents {
  @Consume profileManager: ProfileManager;
  @Prop serviceId: string;
  @Prop serviceType: string;

  build() {
    Row() {
      Row() {
        Text('开关')
          .titleStyle();
        Button() {
          Image(this.profileManager.isPowerOn() ? $r('app.media.button_open') : $r('app.media.button_off'))
            .width($r('app.string.30_vp'))
            .height($r('app.string.30_vp'));
        }
        .width($r('app.string.48_vp'))
        .height($r('app.string.48_vp'))
        .borderRadius($r('app.string.24_vp'))
        .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        .onClick(() => {
          if (ClickCheck.checkDouble()) {
            Logger.warn(TAG, `===>onClick if`);
            this.profileManager.switchPower();
          }
        });
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('48%')
      .height($r('app.string.80_vp'))
      .padding({ left: $r('app.string.12_vp'), right: $r('app.string.12_vp') })
      .borderRadius($r('app.string.radius_16'))
      .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'));

      Row() {
        Text(this.profileManager.isOnline() ? $r('app.string.online') : $r('app.string.offline'))
          .fontSize($r('app.string.font_16'))
          .lineHeight($r('app.string.lineHeight_22'))
          .fontWeight(this.profileManager.isOnline() ? FontWeight.Medium : FontWeight.Normal)
          .fontFamily('HarmonyHeiTi')
          .fontColor(this.profileManager.isOnline() ? $r('sys.color.ohos_id_color_text_primary') :
          $r('sys.color.ohos_id_color_text_secondary'));

        Image(this.profileManager.isOnline() ? $r('app.media.online') : $r('app.media.offline'))
          .width($r('app.string.wh_value_12'))
          .height($r('app.string.wh_value_12'))
          .margin({
            left: $r('app.string.distance_4'),
          });
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .height($r('app.string.80_vp'))
      .width('48%')
      .padding({ left: $r('app.string.12_vp'), right: $r('app.string.12_vp') })
      .borderRadius($r('app.string.radius_16'))
      .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'));
    }.width('100%').justifyContent(FlexAlign.SpaceBetween);
  }
}

@Component
export struct StepOneComponents {
  @Prop characteristic: Characteristics;
  @Prop showTitle: boolean;
  @Consume profileManager: ProfileManager;
  @State unit: string = '';
  private unitType: UnitType | undefined = undefined;
  @Prop serviceId: string;
  @Prop serviceType: string;
  @State hapPutPermissions: boolean = false;
  @State value: number = 0;

  aboutToAppear(): void {
    this.unitType = this.characteristic.unitType;
    this.unit = this.unitType?.unit || '';
    this.hapPutPermissions =
      isSupportPermissions(this.characteristic.permission, CharacteristicPermissions.PUT);

  }

  private controlDevice(add: boolean) {
    if (!ClickCheck.checkDouble()) {
      return;
    }
    let currentValue = this.characteristic.value as number || 0;
    let step = this.unitType?.step || 1;
    let value = 0;
    if (add) {
      value = currentValue + step;
    } else {
      value = currentValue - step;
    }
    let max = this.unitType?.max || 0;
    let min = this.unitType?.min || 0;
    if (value < min || value > max) {
      promptAction.showToast({ message: $r('app.string.exceeding_data_range') });
      return;
    }
    this.profileManager.controlDevice(this.serviceId, this.serviceType, this.characteristic, value);
  }

  build() {
    Row() {
      Text(`${this.characteristic.attrName}:`)
        .titleStyle().visibility(this.showTitle ? Visibility.Visible : Visibility.None);

      Row() {
        Button() {
          Image($r('app.media.button_delete'))
            .width($r('app.string.16_vp'))
            .height($r('app.string.16_vp'));
        }
        .visibility(this.hapPutPermissions ? Visibility.Visible : Visibility.None)
        .width($r('app.string.24_vp'))
        .height($r('app.string.24_vp'))
        .borderRadius($r('app.string.12_vp'))
        .backgroundColor($r('app.color.theme_colour'))
        .margin({ right: $r('app.string.12_vp') })
        .onClick(() => {
          this.controlDevice(false);
        });

        Text(`${this.value} ${this.unit}`)
          .width($r('app.string.80_vp'))
          .height($r('app.string.30_vp'))
          .textAlign(TextAlign.Center)
          .borderRadius($r('app.string.6_vp'))
          .fontSize($r('app.string.font_16'))
          .backgroundColor($r('app.color.page_color_f1f3f5'));

        Button() {
          Image($r('app.media.button_add'))
            .width($r('app.string.16_vp'))
            .height($r('app.string.16_vp'));
        }
        .visibility(this.hapPutPermissions ? Visibility.Visible : Visibility.None)
        .width($r('app.string.24_vp'))
        .height($r('app.string.24_vp'))
        .borderRadius($r('app.string.12_vp'))
        .backgroundColor($r('app.color.theme_colour'))
        .margin({ left: $r('app.string.12_vp') })
        .onClick(() => {
          this.controlDevice(true);
        });
      };
    }.rowStyle();
  }
}

@Component
export struct StepSlideComponents {
  @Prop characteristic: Characteristics;
  @Prop showTitle: boolean;
  @Consume profileManager: ProfileManager;
  @State sliderValue: number = 0;
  @State unitType: UnitType | undefined = undefined;
  @Prop serviceId: string;
  @Prop serviceType: string;
  @State hapPutPermissions: boolean = false;

  aboutToAppear(): void {
    if (this.characteristic.value != undefined) {
      this.sliderValue = this.characteristic.value as number;
    }
    this.unitType = this.characteristic.unitType;
    this.hapPutPermissions =
      isSupportPermissions(this.characteristic.permission, CharacteristicPermissions.PUT);
  }

  build() {
    Column() {
      Text(`${this.characteristic.attrName}:`)
        .titleStyle().visibility(this.showTitle ? Visibility.Visible : Visibility.None);
      Row() {
        if (this.hapPutPermissions) {
          Slider({
            value: this.sliderValue,
            min: Number(this.unitType?.min) || 0,
            max: Number(this.unitType?.max) || 100,
            step: this.unitType?.step || 0.1,
            style: SliderStyle.NONE
          })
            .blockColor($r('app.color.theme_colour'))
            .trackColor('#99999')
            .width('80%')
            .onChange((value: number, mode: SliderChangeMode) => {
              this.sliderValue = Number(value.toFixed(1));
              if (mode == SliderChangeMode.End) {
                this.profileManager.controlDevice(this.serviceId, this.serviceType, this.characteristic,
                  this.sliderValue);
              }
            });
        } else {
          Progress({ value: this.sliderValue, total: Number(this.unitType?.max) || 100, type: ProgressType.Linear })
            .width('80%');
        }
        Text(`当前值:${this.sliderValue}`)
          .fontSize($r('app.string.font_14'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .margin({ left: $r('app.string.12_vp') });

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center);

    }.alignItems(HorizontalAlign.Start)
    .margin({ top: $r('app.string.12_vp') });
  }
}

@Component
export struct SingleSelectComponents {
  @Prop characteristic: Characteristics;
  @Prop showTitle: boolean;
  @State checkIndex: number = -1;
  @Consume profileManager: ProfileManager;
  @State enumType: EnumList = [];
  @Prop serviceId: string;
  @Prop serviceType: string;
  @State hapPutPermissions: boolean = false;

  aboutToAppear(): void {
    this.enumType = this.characteristic.enumList || [];
    this.hapPutPermissions =
      isSupportPermissions(this.characteristic.permission, CharacteristicPermissions.PUT);
    this.enumType.forEach((item, index) => {
      if (item.enumVal == this.characteristic.value) {
        this.checkIndex = index;
      }
    });
  }

  build() {
    Column() {
      Text(`${this.characteristic.attrName}:`)
        .titleStyle().visibility(this.showTitle ? Visibility.Visible : Visibility.None);

      ForEach(this.enumType, (item: EnumEntry, index: number) => {
        Row({ space: 15 }) {
          cloudDeviceRadio({
            settingHeight: 'app.string.wh_value_60',
            settingTitle: item.descCh,
            enabledSwitch: this.hapPutPermissions,
            value: this.characteristic.attrName,
            onChange: (value: string) => {
              Logger.warn(`===>currnt checked value is: ${value}`);
              this.profileManager.controlDevice(this.serviceId, this.serviceType, this.characteristic, item.enumVal);
            }
          });
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .margin({
          left: $r('app.string.distance_4'),
          top: $r('app.string.distance_8'),
          bottom: $r('app.string.distance_8')
        });
      }, (item: EnumEntry) => JSON.stringify(item));
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: $r('app.string.12_vp') })
    .width('100%');
  }
}

@Component
export struct StringComponents {
  @Prop characteristic: Characteristics;
  @Prop showTitle: boolean;
  @State textFocusable: boolean = false;
  @Consume profileManager: ProfileManager;
  @State showCommitBtn: boolean = true;
  @State inputText: string = '';
  @Prop serviceId: string;
  @Prop serviceType: string;
  @State hapPutPermissions: boolean = false;
  @State maxLength: number = 32;

  aboutToAppear(): void {
    this.hapPutPermissions =
      isSupportPermissions(this.characteristic.permission, CharacteristicPermissions.PUT);
    this.showCommitBtn = this.hapPutPermissions == true;
    if (this.characteristic.value != undefined) {
      this.inputText = this.characteristic.value as string;
    }
    this.maxLength = this.characteristic.maxLength || 32;
  }

  @Builder
  readView() {
    Column() {
      Row() {
        Text(`${this.characteristic.attrName}:`)
          .titleStyle().visibility(this.showTitle ? Visibility.Visible : Visibility.None);
        Text(this.characteristic.value as string)
          .margin({ left: 8 })
          .valueStyle();
      };
    }.margin({ top: $r('app.string.12_vp') });
  }

  @Builder
  putView() {
    Column() {
      Row() {
        Text(this.characteristic.attrName)
          .titleStyle();
        if (this.showCommitBtn) {
          Button() {
            Text(this.textFocusable ? '确定' : '修改')
              .fontSize($r('app.string.font_14'))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'));
          }
          .width($r('app.string.56_vp'))
          .height($r('app.string.28_vp'))
          .borderRadius($r('app.string.6_vp'))
          .backgroundColor($r('sys.color.ohos_id_color_sub_background'));
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .onClick(() => {
        this.textFocusable = !this.textFocusable;
        if (this.textFocusable) {
          focusControl.requestFocus('InputTextArea');
        } else {
          this.profileManager.controlDevice(this.serviceId, this.serviceType, this.characteristic, this.inputText);
        }
      });

      TextArea({ text: this.inputText })
        .id('InputTextArea')
        .focusable(this.textFocusable)
        .flexShrink(1)
        .fontSize($r('app.string.font_16'))
        .fontColor($r('app.color.default_text_color'))
        .margin({ top: $r('app.string.8_vp') })
        .height($r('app.string.80_vp'))
        .borderRadius($r('app.string.6_vp'))
        .backgroundColor($r('app.color.default_component_color'))
        .onChange((value: string) => {
          if (value.length < this.maxLength) {
            this.inputText = value;
          }
        });
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(HorizontalAlign.Start)
    .margin({ left: $r('app.string.distance_4'), top: $r('app.string.12_vp') });
  }

  build() {
    if (this.hapPutPermissions) {
      this.putView();
    } else {
      this.readView();
    }
  }
}

@Component
export struct EmptyComponents {
  build() {
    Row() {
    }.rowStyle();
  }
}


@Component
export struct ProductComponents {
  @Prop deviceImage: string | ResourceStr;
  @Prop deviceName: string;

  build() {
    Column() {
      Image(this.deviceImage)
        .width($r('app.string.wh_value_160'))
        .height($r('app.string.wh_value_160'));

      Text(this.deviceName)
        .titleStyle()
        .margin({ top: $r('app.string.distance_4') });
    }.alignItems(HorizontalAlign.Center)
    .width('100%')
    .margin({ top: $r('app.string.distance_4'), bottom: $r('app.string.distance_8') });
  }
}



