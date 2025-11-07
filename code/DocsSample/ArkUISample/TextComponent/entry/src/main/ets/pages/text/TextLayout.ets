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
// [Start onCreate_Menu]
// xxx.ets
// $r('app.media.xxx')需要替换为开发者所需的图像资源文件
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

// [StartExclude onCreate_Menu]
@Entry
@Component
export struct TextLayout {
  // [EndExclude onCreate_Menu]
  onCreateMenu = (menuItems: Array<TextMenuItem>) => {
    let item1: TextMenuItem = {
      content: 'customMenu1',
      icon: $r('app.media.app_icon'),
      id: TextMenuItemId.of('customMenu1'),
    };
    let item2: TextMenuItem = {
      content: 'customMenu2',
      id: TextMenuItemId.of('customMenu2'),
      icon: $r('app.media.app_icon'),
    };
    menuItems.push(item1);
    menuItems.unshift(item2);
    return menuItems;
  }
  onMenuItemClick = (menuItem: TextMenuItem, textRange: TextRange) => {
    if (menuItem.id.equals(TextMenuItemId.of('customMenu2'))) {
      hilog.info(DOMAIN, 'testTag', '%{public}s',
        'id: customMenu2 start:' + textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.COPY)) {
      hilog.info(DOMAIN, 'testTag', '%{public}s', ' COPY start:' + textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.SELECT_ALL)) {
      hilog.info(DOMAIN, 'testTag', '%{public}s',
        'SELECT_ALL start:' + textRange.start + '; end:' + textRange.end);
      return false;
    }
    return false;
  };

  // [End onCreate_Menu]
  build() {
    NavDestination() {
      Column() {
        //设置是否在文本布局过程中优化每行末尾的空格
        // [Start Last_space]
        Column() {
          // 启用优化行尾空格功能
          Text('Trimmed space enabled     ')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })
            .optimizeTrailingSpace(true)
            .textAlign(TextAlign.Center)
          // 不启用优化行尾空格功能
          Text('Trimmed space disabled     ')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })
            .optimizeTrailingSpace(false)
            .textAlign(TextAlign.Center)
        }

        // [End Last_space]
        Column() {
          // [Start text_VerticalAlign]
          // $r('app.media.xxx')需要替换为开发者所需的图像资源文件
          Text() {
            Span('Hello')
              .fontSize(50)
            ImageSpan($r('app.media.startIcon'))
              .width(30).height(30)
              .verticalAlign(ImageSpanAlignment.FOLLOW_PARAGRAPH)
            Span('World')
          }
          .textVerticalAlign(TextVerticalAlign.CENTER)

          // [End text_VerticalAlign]
        }.margin({ top: 20 })

        Column() {
          // [Start copy_Option]
          // 'app.string.selected_menu'资源文件中的value值为'这是一段文本，用来展示选中菜单'
          Text($r('app.string.selected_menu'))
            .fontSize(30)
            .copyOption(CopyOptions.InApp)
          // [End copy_Option]
        }.margin({ top: 20 })

        Column() {
          // [Start editMenu_Options]
          Text($r('app.string.display_the_selected_menu'))
            .fontSize(20)
            .copyOption(CopyOptions.LocalDevice)
            .editMenuOptions({
              onCreateMenu: this.onCreateMenu, onMenuItemClick: this.onMenuItemClick
            })
          // [End editMenu_Options]
        }.margin({ top: 30 })

        Column() {
          // 'app.string.Phone_number'资源文件中的value值为''电话号码：' + '(86) (755) ********' + '\n' +
          // '链接：' + 'www.********.com' + '\n' + '邮箱：' + '***@example.com' + '\n' +
          // '地址：' + 'XX省XX市XX区XXXX' + '\n' + '时间：' + 'XX年XX月XX日XXXX''
          Text(
            $r('app.string.Phone_number')
          )
            .fontSize(16)
            .copyOption(CopyOptions.LocalDevice)
            .enableDataDetector(true)// 使能实体识别
            .dataDetectorConfig({
              // 配置识别样式
              // types可支持PHONE_NUMBER电话号码、URL链接、EMAIL邮箱、ADDRESS地址、DATE_TIME时间
              // types设置为null或者[]时，识别所有类型的实体
              types: [], onDetectResultUpdate: (result: string) => {
              }
            })
        }.margin({ top: 30 })
      }
    }.backgroundColor('#f1f 2f3')
    .title($r('app.string.text_layout'))
  }

  // [StartExclude onCreate_Menu]
}

// [EndExclude onCreate_Menu]
