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

import ConfigData from '../viewmodel/ConfigData';
import { Callback } from '@kit.BasicServicesKit';
import { scale } from '../util/ScreenAdaptation';
import { PageViewUtils } from '@ohos/common';

@Component
export struct LocationInfo {
  @State isTouched: boolean = false;
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  @Prop settingSubTitle: string | Resource = '';
  settingIcon: string | Resource = '';

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
          Text(this.settingSubTitle)
            .fontSize($r('app.string.fp_11'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .height(ConfigData.WH_100_100);

      Row() {
        Image(this.settingIcon)
          .width($r('app.string.wh_value_12'))
          .height($r('app.string.wh_value_24'))
          .margin({
            left: $r('app.string.distance_4'),
            right: $r('app.string.distance_8'),
            top: $r('app.string.distance_16'),
            bottom: $r('app.string.distance_16')
          })
          .fillColor($r('sys.color.ohos_id_color_fourth'));
      }
      .align(Alignment.End)
      .height(ConfigData.WH_100_100);
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'))
    .onTouch((event?: TouchEvent | undefined) => {
      if (event?.type === TouchType.Down) {
        this.isTouched = true;
      }
      if (event?.type === TouchType.Up) {
        this.isTouched = false;
      }
    });
  }
}

@Component
export struct deviceStatus {
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  @Prop online: boolean = false;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Text(this.settingTitle)
          .fontSize($r('app.string.font_16'))
          .lineHeight($r('app.string.lineHeight_22'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .fontColor($r('app.color.default_text_color'))
          .align(Alignment.Start)
          .margin({
            left: $r('app.string.distance_16'),
            top: $r('app.string.distance_17'),
            bottom: $r('app.string.distance_17')
          });
      }
      .align(Alignment.Start)
      .height(ConfigData.WH_100_100);

      Row() {
        Text(this.online ? $r('app.string.online') : $r('app.string.offline'))
          .fontSize($r('app.string.font_16'))
          .lineHeight($r('app.string.lineHeight_22'))
          .fontWeight(this.online ? FontWeight.Medium : FontWeight.Normal)
          .fontFamily('HarmonyHeiTi')
          .fontColor(this.online ? $r('app.color.text_color_white') :
          $r('app.color.default_text_color'))
          .align(Alignment.End);
        Image(this.online ? $r('app.media.online') : $r('app.media.offline'))
          .width($r('app.string.wh_value_12'))
          .height($r('app.string.wh_value_12'))
          .margin({
            left: $r('app.string.distance_4'),
            right: $r('app.string.distance_8'),
            top: $r('app.string.distance_16'),
            bottom: $r('app.string.distance_16')
          });
      }
      .align(Alignment.End)
      .height(ConfigData.WH_100_100);
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'));
  }
}

@Component
export struct deviceItemComponent {
  @State isTouched: boolean = false;
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  private settingSubTitle: string | Resource = '';
  settingIcon: string | Resource = '';

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      if (this.settingSubTitle != '') {
        Row() {
          Column() {
            Text(this.settingTitle)
              .fontSize($r('app.string.font_16'))
              .lineHeight($r('app.string.lineHeight_22'))
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.default_text_color'))
              .align(Alignment.Start);
            Text(this.settingSubTitle)
              .fontSize($r('app.string.font_16'))
              .lineHeight($r('app.string.lineHeight_22'))
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.default_text_color'))
              .align(Alignment.Start);
          };
        }
        .height(ConfigData.WH_100_100);
      } else {
        Row() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
              top: $r('app.string.distance_17'),
              bottom: $r('app.string.distance_17')
            });
        }
        .align(Alignment.Start)
        .height(ConfigData.WH_100_100);
      }

      Row() {
        Image(this.settingIcon)
          .width($r('app.string.wh_value_12'))
          .height($r('app.string.wh_value_24'))
          .margin({
            left: $r('app.string.distance_4'),
            right: $r('app.string.distance_8'),
            top: $r('app.string.distance_16'),
            bottom: $r('app.string.distance_16')
          })
          .fillColor($r('sys.color.ohos_id_color_fourth'));
      }
      .align(Alignment.End)
      .height(ConfigData.WH_100_100);
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'))
    .onTouch((event?: TouchEvent | undefined) => {
      if (event?.type === TouchType.Down) {
        this.isTouched = true;
      }
      if (event?.type === TouchType.Up) {
        this.isTouched = false;
      }
    });
  }
}

@Component
export struct deviceControlComponent {
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  private settingSubTitle: string | Resource = '';
  settingIcon: string | Resource = '';

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
          Text(this.settingSubTitle)
            .fontSize($r('app.string.fp_11'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .height(ConfigData.WH_100_100);

      Row() {
        Image(this.settingIcon)
          .width($r('app.string.wh_value_48'))
          .height($r('app.string.wh_value_48'))
          .margin({
            left: $r('app.string.distance_4'),
            right: $r('app.string.distance_16'),
            top: $r('app.string.distance_16'),
            bottom: $r('app.string.distance_16')
          })
          .fillColor($r('sys.color.ohos_id_color_fourth'));
      }
      .align(Alignment.End)
      .height(ConfigData.WH_100_100);
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .linearGradient({
      angle: 90,
      direction: GradientDirection.Right,
      colors: [[$r('sys.color.ohos_id_color_foreground_contrary'), 1],
        [$r('sys.color.ohos_id_color_foreground_contrary'), 1]]
    });
  }
}

@Component
export struct deviceSwitch {
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  private settingSubTitle: string | Resource = '';
  @Prop switch: boolean = false;
  @Prop enabledSwitch: boolean = true;
  onChange: Callback<boolean> | undefined = undefined;
  private switchTime = 0;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
          Text(this.settingSubTitle)
            .fontSize($r('app.string.fp_11'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .height(ConfigData.WH_100_100);

      Toggle({ type: ToggleType.Switch, isOn: this.switch })
        .margin({ right: scale(8) })
        .hitTestBehavior(HitTestMode.None);
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'))
    .onClick(() => {
      if (!this.enabledSwitch) {
        return;
      }
      let currentTime = new Date().getTime();
      if (currentTime - this.switchTime < 600) {
        return;
      }
      this.switchTime = currentTime;
      if (this.onChange) {
        this.onChange(!this.switch);
      }
    });
  }
}

@Component
export struct deviceRadio {
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  private settingSubTitle: string | Resource = '';
  @Prop enabledSwitch: boolean = true;
  @Prop value: string = '';
  @Link selectedValue: string;
  onChange: Callback<string> | undefined = undefined;
  private switchTime = 0;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
          Text(this.settingSubTitle)
            .fontSize($r('app.string.fp_11'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .height(ConfigData.WH_100_100);

      Radio({ value: this.value, group: 'radioGroup' })
        .checked(false)
        .margin({ right: scale(8) })
        .height('25lpx')
        .width('25lpx')
        .onChange((isChecked: boolean) => {
          console.log('===>isChecked', isChecked);
          if (isChecked) {
            this.selectedValue = this.value;
            if (this.onChange) {
              this.onChange(this.value);
            }
          }
        })
        .focusable(true);
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'));
  }
}

@Component
export struct cloudDeviceRadio {
  settingHeight: string = '';
  settingTitle: string | Resource = '';
  private settingSubTitle: string | Resource = '';
  @Prop isChecked: boolean = false;
  @Prop enabledSwitch: boolean = true;
  @Prop value: string = '';
  onChange: Callback<string> | undefined = undefined;
  private switchTime = 0;

  aboutToAppear(): void {
    console.log('aboutToAppear radio');
    PageViewUtils.tabClick();
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
          Text(this.settingSubTitle)
            .fontSize($r('app.string.fp_11'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .height(ConfigData.WH_100_100);

      Radio({ value: this.value, group: 'radioGroup' }).checked(this.isChecked)
        .margin({ right: scale(8) })
        .onChange((isChecked: boolean) => {
          console.log('===>isChecked', isChecked);
          if (isChecked) {
            if (this.onChange) {
              this.onChange(this.value);
            }
          }
        });
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'))
    .onAppear(() => {
      console.log('onAppear radio');
    });
  }
}

@Component
export struct coapDeviceRadio {
  @Prop settingHeight: string = '';
  @Prop settingTitle: string | Resource = '';
  private settingSubTitle: string | Resource = '';
  @Prop isChecked: boolean = false;
  @Prop enabledSwitch: boolean = true;
  @Prop value: string = '';
  @Link selectedValue: string;
  onChange: Callback<string> | undefined = undefined;
  private switchTime = 0;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Column() {
          Text(this.settingTitle)
            .fontSize($r('app.string.font_16'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('app.color.default_text_color'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
          Text(this.settingSubTitle)
            .fontSize($r('app.string.fp_11'))
            .lineHeight($r('app.string.lineHeight_22'))
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .align(Alignment.Start)
            .margin({
              left: $r('app.string.distance_16'),
            });
        }
        .alignItems(HorizontalAlign.Start);
      }
      .height(ConfigData.WH_100_100);

      Radio({ value: this.value, group: 'radioGroup' })
        .checked(this.isChecked)
        .margin({ right: scale(8) })
        .height('25lpx')
        .width('25lpx')
        .onChange((isChecked: boolean) => {
          console.log('===>isChecked', isChecked);
          console.log('===>isCheckedtitle1', this.settingTitle);
          if (isChecked) {
            this.selectedValue = this.value;
            if (this.onChange) {
              this.onChange(this.value);
            }
          }
        });
    }
    .width('100%')
    .height($r(this.settingHeight))
    .borderRadius($r('app.string.radius_16'))
    .backgroundColor($r('app.color.default_component_color'));
  }
}