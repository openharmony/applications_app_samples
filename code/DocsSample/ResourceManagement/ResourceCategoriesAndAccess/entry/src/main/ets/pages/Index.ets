/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start config_resource]
import { BusinessError } from '@kit.BasicServicesKit';

// [Start hsp_resource]
@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller();
  // [StartExclude config_resource]
  text: string = '[library].string.test_string';
  fontSize: string = '[library].float.font_size';
  fontColor: string = '[library].color.font_color';
  image: string = '[library].media.image';
  rawfile: string = '[library].icon.png';
  // [EndExclude config_resource]
  // [StartExclude hsp_resource]
  @State englishString: string = "";
  @State germanString: string = "";
  // [EndExclude hsp_resource]

  build() {
    Scroll(this.scroller) {
      Column() {
        // [StartExclude config_resource]
        // [StartExclude hsp_resource]
        // [Start app_resource]
        //通过$r('app.type.name')访问
        Text($r('app.string.string_hello'))
          .id('app_resource')
          .fontColor($r('app.color.color_emphasize'))
          .fontSize($r('app.float.text_size_headline1'))
          .fontFamily($r('app.string.font_family_medium'))
          .backgroundColor($r('app.color.color_palette_aux1'))

        Image($r('app.media.app_icon'))
          .border({
            color: $r('app.color.color_palette_aux1'),
            radius: $r('app.float.corner_radius_button'), width: 2
          })
          .margin({
            top: $r('app.float.elements_margin_horizontal_m'),
            bottom: $r('app.float.elements_margin_horizontal_l')
          })
          .height(100)
          .width(100)

        // 对于string.json中name为"message_notification"，value为"Hello, %1$s!,You have %2$d new messages."
        // 该资源存在%1$s、%2$d两个占位符，需要替代为'LiHua'、2，则采用如下方式访问
        Text($r('app.string.message_notification', 'LiHua', 2)).id('app_string_resource')
        // 对于plural.json中name为"eat_apple"，单数的value为"%d apple"，复数的value为"%d apples"
        // 访问plural.json资源，第一个参数控制字符串显示单数形式或复数形式，传递1表示单数，大于1表示复数，且在中文环境下始终为复数
        // 该资源存在%d一个占位符，需要替代为2，则采用如下方式访问
        Text($r('app.plural.eat_apple', 2, 2)).id('app_plural_resource')
        // [End app_resource]

        // [Start system_resource]
        Text('Hello')
          .fontColor($r('sys.color.ohos_id_color_emphasize'))
          .fontSize($r('sys.float.ohos_id_text_size_headline1'))
          .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
          .backgroundColor($r('sys.color.ohos_id_color_palette_aux1'))

        Image($r('sys.media.ohos_app_icon'))
          .border({
            color: $r('sys.color.ohos_id_color_palette_aux1'),
            radius: $r('sys.float.ohos_id_corner_radius_button'), width: 2
          })
          .margin({
            top: $r('sys.float.ohos_id_elements_margin_horizontal_m'),
            bottom: $r('sys.float.ohos_id_elements_margin_horizontal_l')
          })
          .height(100)
          .width(100)
        // [End system_resource]
        // [EndExclude hsp_resource]

        // 使用字面量[模块名].type.name获取资源
        Text($r('[library].string.test_string'))
          .id('hsp_resource_one')
          .fontSize($r('[library].float.font_size'))
          .fontColor($r('[library].color.font_color'))
        Image($rawfile('[library].icon.png'))
          .height(100)
          .width(100)

        // 使用变量获取资源
        Text($r(this.text))
          .id('hsp_resource_two')
          .fontSize($r(this.fontSize))
          .fontColor($r(this.fontColor))

        Image($r(this.image))
          .height(100)
          .width(100)

        Image($rawfile(this.rawfile))
          .height(100)
          .width(100)
        // [EndExclude config_resource]

        // [StartExclude hsp_resource]
        Text(this.getString())
          .id('config_resource_one')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.englishString)
          .id('config_resource_two')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text(this.germanString)
          .id('config_resource_three')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        // [EndExclude hsp_resource]
      }
      .width('100%')
    }
    .scrollable(ScrollDirection.Vertical)
    .edgeEffect(EdgeEffect.Spring)
  }

  // [StartExclude hsp_resource]
  getString(): string {
    let resMgr = this.getUIContext().getHostContext()?.resourceManager;
    if (!resMgr) {
      return "";
    }
    let currentLanguageString: string = "";
    try {
      let resId = $r('app.string.greetings').id;

      //获取符合当前系统语言地区、颜色模式、分辨率等配置的资源
      currentLanguageString = resMgr.getStringSync(resId);

      //获取符合当前系统颜色模式、分辨率等配置的英文资源
      let overrideConfig = resMgr.getOverrideConfiguration();
      overrideConfig.locale = "en_US"; //指定资源的语言为英语，地区为美国
      let overrideResMgr = resMgr.getOverrideResourceManager(overrideConfig);
      this.englishString = overrideResMgr.getStringSync(resId);

      //获取符合当前系统颜色模式、分辨率等配置的日文资源
      overrideConfig.locale = "ja_JP"; //指定资源的语言为日文，地区为日本
      overrideResMgr.updateOverrideConfiguration(overrideConfig); //等效于resMgr.updateOverrideConfiguration(overrideConfig)
      this.germanString = overrideResMgr.getStringSync(resId);
    } catch (err) {
      const code = (err as BusinessError).code;
      const message = (err as BusinessError).message;
      console.error(`get override resource failed, error code: ${code}, error msg: ${message}`);
    }
    return currentLanguageString;
  }
  // [EndExclude hsp_resource]
}
// [End hsp_resource]
// [End config_resource]