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
import { NavBar, PageViewUtils } from '@ohos/common';
import { LanguageComponentInfo, LanguageItemInfo } from '../../viewmodel/LanguageViewModel';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { scale } from '../../model/utils/ScreenAdaptation';

/**
 * 设置页面-语言项组件
 */
@Component
struct LanguageItemComponent {
  @ObjectLink itemInfo: LanguageItemInfo;
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontSize: ResourceStr = $r('app.string.font_20');
  @State fontWeight: boolean = false;

  build() {
    Row() {
      Text(this.itemInfo.language.languageDisplay)
        .fontColor(this.fontColor)
        .fontSize(this.fontSize)
        .fontWeight(this.fontWeight ? FontWeight.Bold : FontWeight.Medium)
        .focusable(true)
        .focusBox({
          strokeWidth: LengthMetrics.px(0)
        })
        .onFocus(() => {
          this.fontColor = $r('app.color.text_color_white');
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
        Image($r('app.media.ic_select')).height(scale(15));
      }
    }.width('100%').padding(scale(10));
  }
}

/**
 * 语言页面UI组件
 */
@HMRouter({ pageUrl: 'LanguagePage' })
@Component
export struct LanguagePage {
  @State info: LanguageComponentInfo | undefined = undefined;

  aboutToAppear(): void {
    LanguageComponentInfo.getInstance().then((data) => {
      this.info = data;
    });
  }

  showFunc(item: LanguageItemInfo, isShow: boolean) { //切换语言动效展示
    for (let newItem of LanguageComponentInfo.newSelectedLanguageList) {
      newItem.showFunc(false);
    }
    item.showFunc(isShow);
    LanguageComponentInfo.newSelectedLanguageList = [];
    if (isShow) {
      LanguageComponentInfo.newSelectedLanguageList.push(item);
    }
    for (let old of LanguageComponentInfo.oldSelectedLanguageList) {
      old.showFunc(!isShow);
    }
  }

  handleClick(item: LanguageItemInfo) { //点击语言某项时执行动作
    this.showFunc(item, !item.isSelected);
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.page_settings_language'))
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
        Column() { //数据库中已选择的语言，第一次设置之前为默认的中文
          if (this.info != undefined) {
            List() {
              ForEach(LanguageComponentInfo.oldSelectedLanguageList, (item: LanguageItemInfo) => {
                ListItem() {
                  LanguageItemComponent({ itemInfo: item });
                };
              });
            };

            Divider().margin({ left: scale(5), right: scale(5) }).color($r('app.color.default_button_bg'));
            List() { //可选语言列表
              ForEach(LanguageComponentInfo.languageList, (item: LanguageItemInfo) => {
                ListItem() {
                  LanguageItemComponent({ itemInfo: item });
                }.onClick(() => {
                  this.handleClick(item);
                }).margin(scale(5));
              });
            };
          }
        }
        .backgroundColor($r('app.color.default_component_color'))
        .borderRadius(scale(15))
        .height('100%')
        .margin(scale(10))
        .padding(scale(5));
      }
      .width('70%')
      .height('70%')
      .margin({ top: $r('app.string.20_vp') });

      Blank();

      Button($r('app.string.sure'))
        .width(scale(150))
        .height(scale(50))
        .backgroundColor($r('app.color.default_button_bg'))
        .fontColor($r('app.color.text_color_black'))
        .fontWeight(FontWeight.Bold)
        .fontSize($r('app.string.font_20'))
        .focusBox({
          margin: LengthMetrics.lpx(8),
          strokeColor: ColorMetrics.resourceColor($r('app.color.text_color_white')),
          strokeWidth: LengthMetrics.lpx(2)
        })
        .onClick(() => {
          // 点击确认切换应用偏好语言
          if (LanguageComponentInfo.newSelectedLanguageList.length == 1 &&
            LanguageComponentInfo.newSelectedLanguageList[0] != undefined &&
            LanguageComponentInfo.newSelectedLanguageList[0].language != undefined) {
            LanguageComponentInfo.setAppLanguage(LanguageComponentInfo.newSelectedLanguageList[0].language);
          }
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
