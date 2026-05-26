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
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { DefaultDialog, Logger, NavBar, PageViewUtils } from '@ohos/common';
import { CountryComponentInfo, CountryItemInfo, getCountryComponentInfo } from '../../viewmodel/CountryViewModel';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { Country } from '../../model/entity/Country';
import { KeyCode } from '@kit.InputKit';
import { it } from '@ohos/hypium';

/**
 * 地区元素组件
 */
const TAG = 'CountryItemComponent';

@Component
struct CountryItemComponent {
  @ObjectLink itemInfo: CountryItemInfo;
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontSize: ResourceStr = $r('app.string.font_20');
  @State fontWeight: boolean = false;

  build() {
    Row() {
      Text(this.itemInfo.country.countryDisplay)
        .fontColor(this.fontColor)
        .fontSize(this.fontSize)
        .fontWeight(this.fontWeight ? FontWeight.Bold : FontWeight.Medium)
        .focusable(true)
        .focusBox({
          strokeWidth: LengthMetrics.px(0)
        })
        .onFocus(() => {
          this.fontColor = $r('app.color.text_color_focus');
          this.fontSize = $r('app.string.font_22');
          this.fontWeight = true;
        })
        .onBlur(() => {
          this.fontColor = $r('app.color.default_text_color');
          this.fontSize = $r('app.string.font_20');
          this.fontWeight = false;
        });
      Blank();
      if (this.itemInfo.isSelected) {
        Image($r('app.media.ic_select')).height(15);
      }
    }.width('100%').padding(5);
  }
}

/**
 * 地区页面UI组件
 */
@HMRouter({ pageUrl: 'CountryPage' })
@Component
export struct CountryPage {
  @State info: CountryComponentInfo = new CountryComponentInfo();
  @State selectCountry: CountryItemInfo | null = null;
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: DefaultDialog({
      content: $r('app.string.page_area_switch_message'),
      leftText: $r('app.string.cancel'),
      rightText: $r('app.string.sure'),
      cancel: () => {
        this.showFunc(this.selectCountry!, false);
        console.info('Callback when the first button is clicked');
        this.dialogController.close();
      },
      confirm: () => {
        this.selectCountry!.handleFunc();
        console.info('Callback when the second button is clicked');
        this.dialogController.close();
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
  });

  aboutToAppear(): void {
    getCountryComponentInfo().then((data) => { //获取地区信息
      this.info = data;
      this.selectCountry = this.info.oldSelectedCountryList[0];
    });
  }

  invokeFunc: Function = (item: CountryItemInfo) => { //点击地区跳出弹窗
    this.selectCountry = item;
    this.dialogController.open();
  };

  showFunc(item: CountryItemInfo, isShow: boolean) { //地区选择动效
    for (let newItem of this.info.newSelectedCountryList) {
      newItem.showFunc(false);
    }
    item.showFunc(isShow);
    this.info.newSelectedCountryList = [];
    if (isShow) {
      this.info.newSelectedCountryList.push(item);
    }
    for (let old of this.info.oldSelectedCountryList) {
      old.showFunc(!isShow);
    }
  }

  handleClick(item: CountryItemInfo) { //点击地区执行方法
    this.showFunc(item, true);
    this.invokeFunc(item);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.page_settings_area'))
          .fontColor($r('app.color.text_color_white'))
          .fontSize($r('app.string.font_20'))
          .fontWeight(FontWeight.Bold)
          .focusable(false)
          .onClick(() => {
            HMRouterMgr.pop();
          });
      }.width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center);

      Column() {
        Column() {
          if (this.info.oldSelectedCountryList.length > 0) { //数据库中存储的已选择地区
            List() {
              ForEach(this.info.oldSelectedCountryList, (item: CountryItemInfo) => {
                ListItem() {
                  CountryItemComponent({ itemInfo: item });
                };
              }, (item: CountryItemInfo) => item.country.countryCode);
            };

            Divider().margin({ left: 5, right: 5, bottom: 10 }).color($r('app.color.default_button_bg'));
          }
          if (this.info.newSelectedCountryList.length > 0) { //页面操作时选择的地区
            List() {
              ForEach(this.info.newSelectedCountryList, (item: CountryItemInfo) => {
                ListItem() {
                  CountryItemComponent({ itemInfo: item });
                };
              }, (item: CountryItemInfo) => item.country.countryCode);
            };

            Divider().margin({ left: 5, right: 5, bottom: 10 }).color($r('app.color.default_button_bg'));
          }
          List() { //所有地区信息
            ForEach(this.info.countryList, (item: CountryItemInfo) => {
              ListItem() {
                CountryItemComponent({ itemInfo: item });
              }.onClick(() => {
                this.handleClick(item);
              })
              .margin(5);
            }, (item: CountryItemInfo) => item.country.countryCode);
          }.flexShrink(1);
        }
        .backgroundColor($r('app.color.default_component_color'))
        .borderRadius(15)
        .margin(10)
        .padding(10)
        .height('100%');
      }
      .width('70%')
      .height('70%')
      .margin({ top: $r('app.string.20_vp') });

      Blank();

      Button($r('app.string.sure'))
        .width(150)
        .height(50)
        .backgroundColor($r('app.color.default_button_bg'))
        .fontColor($r('app.color.text_color_black'))
        .fontWeight(FontWeight.Bold)
        .fontSize($r('app.string.font_20'))
        .focusBox({
          margin: LengthMetrics.px(10),
          strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
          strokeWidth: LengthMetrics.px(2)
        });
    }
    .onAppear(() => {
      setTimeout(() => {
        PageViewUtils.tabClick();
      }, 100);
    })
    .width('100%')
    .height('100%')
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .backgroundColor($r('app.color.page_background'))
    .onKeyEvent((event) => {
      if (event.keyCode == KeyCode.KEYCODE_ESCAPE) {
        HMRouterMgr.pop();
      }
    });
  }
}
