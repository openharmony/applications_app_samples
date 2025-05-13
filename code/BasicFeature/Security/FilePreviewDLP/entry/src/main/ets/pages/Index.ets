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

import { common, Want } from '@kit.AbilityKit';
import { picker } from '@kit.CoreFileKit';
import { logger } from '../log/Logger';
import { promptAction } from '@kit.ArkUI';

const FONT_WEIGHT = 400;

@Entry
@Component
struct Index {
  @State fileArray: Array<string> = [];

  build() {
    Column() {
      Row() {
        Image($r("app.media.file_preview_dlp_add"))
          .width($r('app.integer.file_preview_dlp_integer_28'))
          .height($r('app.integer.file_preview_dlp_integer_28'))
          .onClick(() => {
            // 打开文件管理选择dlp文件
            this.selectDlp()
          })
        Blank()
        Text($r('app.string.file_preview_dlp_text'))
          .fontSize($r('app.integer.file_preview_dlp_integer_20'))
          .fontWeight(FONT_WEIGHT)
          .fontColor(Color.Black)
        Blank()
        Image($r("app.media.file_preview_dlp_sift"))
          .width($r('app.integer.file_preview_dlp_integer_28'))
          .height($r('app.integer.file_preview_dlp_integer_28'))
          .onClick(() => {
            // 当前调用Toast显示提示:此样式仅为案例展示
            promptAction.showToast({ message: $r('app.string.file_preview_dlp_show_ui') });
          })
      }
      .alignItems(VerticalAlign.Center)
      .height($r('app.integer.file_preview_dlp_integer_69'))
      .width($r('app.string.file_preview_dlp_hundred_percent'))
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .padding({
        left: $r('app.integer.file_preview_dlp_integer_20'),
        right: $r('app.integer.file_preview_dlp_integer_20')
      })

      List() {
        ForEach(this.fileArray, (files: string, index: number) => {
          FileItemComponent({ index: index })
            .onClick(() => {
              // 点击DLP文件打开该文件
              this.viewDlp(files)
            })
        })
      }
      .layoutWeight(1)
      .backgroundColor('#F5F7FA')
      .padding({
        left: $r('app.integer.file_preview_dlp_integer_15'),
        right: $r('app.integer.file_preview_dlp_integer_15'),
        top: $r('app.integer.file_preview_dlp_integer_24')
      })

    }
    .width($r('app.string.file_preview_dlp_hundred_percent'))
    .height($r('app.string.file_preview_dlp_hundred_percent'))
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  selectDlp() {
    try {
      let context = getContext(this) as common.UIAbilityContext;
      // 文档选择选项
      let documentSelectOptions = new picker.DocumentSelectOptions();
      // 可以选择三个文件
      documentSelectOptions.maxSelectNumber = 3;
      // 文件选择器对象，用来支撑选择和保存各种格式文档
      let documentPicker = new picker.DocumentViewPicker(context);
      documentPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
        // 将选择的文件路径保存到本地数组中
        for (let index = 0; index < documentSelectResult.length; index++) {
          this.fileArray.push(documentSelectResult[index]);
        }
      })
    } catch (err) {
      logger.error('Select DLP failed ' + JSON.stringify(err))
    }
  }

  viewDlp(dlpUri: string) {
    let context = getContext(this) as common.UIAbilityContext;
    // 构造want参数
    let want: Want = {
      'action': 'ohos.want.action.viewData',
      'uri': dlpUri,
    }
    try {
      // 通过调用startAbility接口，由系统从已安装的应用中寻找文件预览，打开选定的文件
      context.startAbility(want);
    } catch (err) {
      logger.error('View DLP failed ' + JSON.stringify(err))
    }
  }
}

@Component
export struct FileItemComponent {
  @State index: number = 0;

  getTime() {
    const now = new Date();
    // 获取年、月、日
    const year = now.getFullYear();
    const month = now.getMonth() + 1; // 月份是从0开始的，所以需要加1
    const day = now.getDate();

    // 转换为字符串
    const formattedDate = `${year}-${month.toString().padStart(2, '0')}-${day.toString().padStart(2, '0')}`;
    return formattedDate
  }

  getSize() {
    return (Math.random() * 10).toFixed(1) + 'MB';
  }

  build() {
    Row() {
      Image($r('app.media.file_preview_dlp_word'))
        .width($r('app.integer.file_preview_dlp_integer_50'))
        .height($r('app.integer.file_preview_dlp_integer_50'))
        .objectFit(ImageFit.Cover)
        .draggable(false)// TODO：知识点：保持默认值true时，图片有默认拖拽效果，会影响Grid子组件拖拽判断，所以修改为false
        .margin({ left: $r('app.integer.file_preview_dlp_integer_21') })
      Column() {
        Text(`Text${this.index + 1}`)
          .fontColor(Color.Black)
          .fontSize($r('app.integer.file_preview_dlp_integer_15'))
          .fontWeight(FONT_WEIGHT)
          .textAlign(TextAlign.Start)

        Text(this.getTime())
          .fontSize($r('app.integer.file_preview_dlp_integer_13'))
          .fontWeight(FONT_WEIGHT)
          .fontColor($r('app.color.file_preview_dlp_color_8A9095'))
          .margin({ top: $r('app.integer.file_preview_dlp_integer_10') })
      }
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ left: $r('app.integer.file_preview_dlp_integer_15') })
      .height($r('app.integer.file_preview_dlp_integer_50'))

      Blank()
      Column() {
        Text($r('app.string.file_preview_dlp_show_text'))
          .fontSize($r('app.integer.file_preview_dlp_integer_13'))
          .fontColor($r('app.color.file_preview_dlp_color_8A9095'))
          .margin({
            right: $r('app.integer.file_preview_dlp_integer_15')
          })
        // 仅做样式调整，开发者可根据文件实际大小来渲染
        Text(this.getSize())
          .fontSize($r('app.integer.file_preview_dlp_integer_13'))
          .fontColor($r('app.color.file_preview_dlp_color_8A9095'))
          .margin({
            right: $r('app.integer.file_preview_dlp_integer_15'),
            top: $r('app.integer.file_preview_dlp_integer_15')
          })
      }

    }
    .padding({
      top: $r('app.integer.file_preview_dlp_integer_12'),
      bottom: $r('app.integer.file_preview_dlp_integer_12')
    })
    .margin({ bottom: $r('app.integer.file_preview_dlp_integer_12') })
    .borderRadius($r('app.integer.file_preview_dlp_integer_12'))
    .width($r('app.string.file_preview_dlp_hundred_percent'))
    .backgroundColor($r('sys.color.white'))
  }
}

