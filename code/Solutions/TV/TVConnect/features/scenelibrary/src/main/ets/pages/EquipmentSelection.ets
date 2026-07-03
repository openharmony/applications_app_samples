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
import HeadTitleComponent from '../view/HeadTitleComponent';
import { CommonConstants, Logger, PageViewUtils } from '@ohos/common';
import { ColorMetrics, LengthMetrics, promptAction, router } from '@kit.ArkUI';
import { DeviceList } from '../model/SceneCondition';
import { KeyCode } from '@kit.InputKit';
import { HMRouterMgr } from '@hadss/hmrouter';

@Component
struct DeviceItem {
  @Prop deviceItem: DeviceList;
  @State fontsize: ResourceStr = $r('app.string.font_20');
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontWeight: boolean = false;

  build() {
    Row() {
      Text(this.deviceItem.name || '')
        .fontSize(this.fontsize)
        .fontColor(this.fontColor)
        .fontWeight(this.fontWeight ? FontWeight.Bold : FontWeight.Medium)
        .focusable(false);
      Row() {
        Row({ space: 6 }) {
          Text(this.deviceItem.type == '1' ? '在线' : '离线')
            .fontSize($r('app.string.font_20'))
            .fontColor($r('app.color.default_text_color'))
            .fontWeight(FontWeight.Medium);

          Row() {
          }
          .width('20vp')
          .height('20vp')
          .borderRadius('20vp')
          .backgroundColor(this.deviceItem.type == '1' ? '#64BB5C' : 'red');
        };

        Row() {
          if (this.deviceItem.check) {
            Image($r('app.media.ic_select'))
              .width($r('app.string.icon_width'))
              .height($r('app.string.icon_height'));
          }
        }
        .margin({ left: 20 });
      };
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .backgroundColor($r('app.color.default_component_color'))
    .borderRadius(16)
    .padding(15);
  }
}

@Entry
@Component
export struct EquipmentSelection {
  @StorageLink('modeId') modeId: string = ''; // 当前选中项id
  @StorageLink('actionId') actionId: string = '';
  @StorageLink('deviceName') deviceName: string = '';
  @StorageLink('actionName') actionName: string = '';
  @StorageLink('deviceType') deviceType: string = '';
  @State type: number = 1;
  @State title: Resource = $r('app.string.device_select');
  @State isLeftIcon: string | Resource = $r('app.media.ic_public_confirm');
  // 在线
  @State onLinedeviceList: DeviceList[] = [
    new DeviceList('1', '摄像头1', '1', false),
    new DeviceList('2', '摄像头2', '1', false),
    new DeviceList('3', '摄像头3', '1', false),
  ];
  // 离线
  @State offLinedeviceList: DeviceList[] = [
    new DeviceList('1', '摄像头1', '0', false),
    new DeviceList('2', '摄像头2', '0', false),
    new DeviceList('3', '摄像头3', '0', false),
  ];

  toast(msg: string | Resource) {
    promptAction.showToast({
      message: msg,
      duration: 2000,
      bottom: '160vp'
    });
  }

  onPageShow(): void {
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 200);
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text(this.title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
            .focusable(false);
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: $r('app.string.10_vp') });


        Column() {
          // 在线
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Column() {
              Text($r('app.string.on_line_equipment'))
                .padding({ left: $r('app.string.p_12'), bottom: $r('app.string.padding_tab_title_left') })
                .fontSize($r('app.string.font_20'))
                .fontColor($r('app.color.default_text_color'))
                .fontWeight(FontWeight.Medium)
                .width(CommonConstants.FULL_WIDTH_PERCENT);

              Column() {
                List() {
                  ForEach(this.onLinedeviceList, (item: DeviceList, index: number) => {
                    ListItem() {
                      Row() {
                        DeviceItem({ deviceItem: item });
                      }
                      .borderRadius(16)
                      .margin({ bottom: 10 })
                      .focusBox({
                        margin: LengthMetrics.px(5),
                        strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
                        strokeWidth: LengthMetrics.px(2)
                      })
                      .onClick(() => {
                        this.onLinedeviceList.forEach((res) => res.check = false);
                        item.check = !item.check;
                      });
                    }
                    .padding(5);
                  });
                }
                .borderRadius($r('app.string.card_border_radius'))
                .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') });
              }
              .height(180);
            }
            .margin({ top: '22vp' });
          }
          .height('50%')
          .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
          .margin({ bottom: 20 });

          // 离线
          Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
            Column() {
              Text($r('app.string.off_line_equipment'))
                .padding({ left: $r('app.string.p_12'), bottom: $r('app.string.padding_tab_title_left') })
                .fontSize($r('app.string.font_20'))
                .fontColor($r('app.color.default_text_color'))
                .fontWeight(FontWeight.Medium)
                .width(CommonConstants.FULL_WIDTH_PERCENT);

              Column() {
                List() {
                  ForEach(this.offLinedeviceList, (item: DeviceList, index: number) => {
                    ListItem() {
                      Row() {
                        DeviceItem({ deviceItem: item });
                      }
                      .borderRadius(16)
                      .margin({ bottom: 10 })
                      .focusBox({
                        margin: LengthMetrics.px(5),
                        strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
                        strokeWidth: LengthMetrics.px(2)
                      })
                      .onClick(() => {
                        this.offLinedeviceList.forEach((res) => res.check = false);
                        item.check = !item.check;
                      });
                    }
                    .padding(5);
                  });
                }
                .borderRadius($r('app.string.card_border_radius'))
                .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') });
              }
              .height(130);
            }
            .margin({ top: '22vp' });
          }
          .padding({ left: $r('app.string.p_12'), right: $r('app.string.p_12') })
          .height('45%');
        }
        .width('100%')
        .layoutWeight(1);

        Button($r('app.string.sure'), { type: ButtonType.Capsule, stateEffect: true })
          .fontColor($r('app.color.text_color_black'))
          .fontSize('14fp')
          .width(150)
          .defaultFocus(true)
          .backgroundColor($r('app.color.default_button_bg'))
          .padding({
            left: 30,
            right: 30,
            top: 10,
            bottom: 10
          })
          .key('button')
          .onClick(() => {
            let data = this.onLinedeviceList.find((res) => res.check);
            if (data) {
              this.modeId = data.id || '';
              this.deviceName = data.name;
              this.deviceType = data.type;
              this.actionName = '';
              this.actionId = '';
            } else {
              this.toast($r('app.string.device_unknown'));
              return;
            }
            router.back();
          });
      }
      .width('70%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween);
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .backgroundColor($r('app.color.page_background'))
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.20_vp') })
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}