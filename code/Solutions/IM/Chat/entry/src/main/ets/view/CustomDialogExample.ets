/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import resourceManager from '@ohos.resourceManager';

class PromptType {
  img: string | Resource = ''
  text: string | Resource = ''
}

@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController = new CustomDialogController({ builder: CustomDialogExample({}) })
  @StorageLink('lazy_for_each') lazy_for_each: boolean | undefined = AppStorage.get('lazy_for_each')
  @StorageLink('reusable') reusable: boolean | undefined = AppStorage.get('reusable')
  @StorageLink('img_syncLoad') img_syncLoad: boolean | undefined = AppStorage.get('img_syncLoad')
  @StorageLink('page_layout') page_layout: boolean | undefined = AppStorage.get('page_layout')
  @StorageLink('list_cachedCount') list_cachedCount: boolean | undefined = AppStorage.get('list_cachedCount')
  private promptArr: PromptType[] = [
    { img: $r('app.media.pic1'), text: $r('app.string.add_friends') },
    { img: $r('app.media.pic2'), text: $r('app.string.group_chat') },
    { img: $r('app.media.pic3'), text: $r('app.string.scan') },
    { img: $r('app.media.pic4'), text: $r('app.string.collection_payment') }]

  build() {
    Column() {
      List({ space: 2, initialIndex: 0 }) {
        ForEach(this.promptArr, (item: PromptType, index) => {
          ListItem() {
            Prompt({ img: item.img, text: item.text, controller: this.controller })
          }
        }, (item: PromptType) => JSON.stringify(item))
      }
      .friction($r("app.float.customDialog_list_friction"))
      .listDirection(Axis.Vertical) // 排列方向
      // 每行之间的分界线
      .divider({
        strokeWidth: $r("app.float.customDialog_list_friction"),
        color: $r("app.color.customDialog_list_divider_color"),
        startMargin: $r("app.integer.customDialog_divider_startMargin"),
        endMargin:$r("app.integer.customDialog_divider_endMargin") })

      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_lazy_for_each'), isOn: $lazy_for_each })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_reusable'), isOn: $reusable })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_syncLoad'), isOn: $img_syncLoad })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_layout'), isOn: $page_layout })
      diaLogDivider()
      ToggleComponent({ text_option: $r('app.string.prop_cachedCount'), isOn: $list_cachedCount })
    }
    .backgroundColor($r("app.color.customDialog_list_backgroundColor"))
    .borderRadius($r("app.integer.customDialog_list_borderRadius"))
    .padding({ left: $r("app.integer.customDialog_list_padding_left"), bottom: $r("app.integer.customDialog_list_padding_bottom") })
    .width($r("app.integer.customDialog_list_width"))
  }
}

@Component
struct Prompt {
  img: string | Resource = $r("app.media.empresa")
  text: string | Resource = ''
  controller: CustomDialogController = new CustomDialogController({ builder: CustomDialogExample({}) })

  build() {
    Row() {
      Image(this.img)
        .height($r("app.integer.customDialog_Prompt_Image_height"))
        .width($r("app.integer.customDialog_Prompt_Image_width"))
        .margin({ top: $r("app.integer.customDialog_Prompt_Image_margin_top"), right: $r("app.integer.customDialog_Prompt_Image_margin_right") })
      Text(this.text)
        .fontSize($r("app.integer.customDialog_Prompt_Text_fontSize"))
        .fontColor($r("app.color.customDialog_Prompt_Text_fontColor"))
        .margin({ top: $r("app.integer.customDialog_Prompt_Text_margin_top") })
    }
    .width('100%')
    .padding($r("app.integer.customDialog_Prompt_padding"))
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      this.controller.close()
      AlertDialog.show(
        {
          message: $r('app.string.alert_dialog'),
        }
      )
    })
  }
}

@Component
struct diaLogDivider {
  resource: Resource = $r('app.float.customDialog_diaLogDivider_strokeWidth')
  res: resourceManager.Resource = {
    bundleName: this.resource.bundleName,
    moduleName: this.resource.moduleName,
    id: this.resource.id
  }
  build() {
    Column(){
      Divider().strokeWidth(0.5).color('#888888').margin({left:40})
    }
  }
}

@Component
struct ToggleComponent {
  text_option: string | Resource = ''
  @Link isOn: boolean

  build() {
    Column() {
      Row() {
        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .selectedColor($r("app.color.customDialog_Toggle_selectedColor"))
          .width($r("app.integer.customDialog_Toggle_width"))
          .switchPointColor($r("app.color.customDialog_Toggle_switchPointColor"))
          .onChange((isOn: boolean) => {
            this.isOn = isOn
          })
        Text(this.text_option)
          .fontSize($r("app.integer.customDialog_ToggleComponent_fontSize"))
          .fontColor($r("app.color.customDialog_ToggleComponent_fontColor"))
          .margin({ left: $r("app.integer.customDialog_ToggleComponent_margin_left") })
      }
      .width('100%')
      .padding($r("app.integer.customDialog_ToggleComponent_padding"))
      .justifyContent(FlexAlign.Start)
    }
  }
}

export { CustomDialogExample }