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

class PromptType {
  image: string | Resource = ''
  text: string | Resource = ''

  constructor(image: string | Resource = '', text: string | Resource = '') {
    this.image = image;
    this.text = text;
  }
}

class MessageDetail {
  message: Resource;

  constructor(message: Resource) {
    this.message = message;
  }
}

// divider组件的strokWidth为1
const DIVIDER_LINE_STROKWIDTH: number = 1;
// initialIndex的初始值
const INITIAL_INDEX: number = 0;
// space的初始值
const SPACE: number = 2;


// 首页右上角点击加号时弹出的列表
@CustomDialog
export struct CustomDialogExample {
  controller: CustomDialogController = new CustomDialogController({ builder: CustomDialogExample({}) });
  // 懒加载开关
  @StorageLink('lazy_for_each') lazyForEach: boolean | undefined = AppStorage.get('lazy_for_each');
  // 组件复用开关
  @StorageLink('reusable') reusable: boolean | undefined = AppStorage.get('reusable');
  // 同步加载开关
  @StorageLink('image_sync_load') imageSyncLoad: boolean | undefined = AppStorage.get('image_sync_load');
  // 布局优化开关
  @StorageLink('page_layout') pageLayout: boolean | undefined = AppStorage.get('page_layout');
  // 缓存数量开关
  @StorageLink('list_cached_count') listCachedCount: boolean | undefined = AppStorage.get('list_cached_count');
  private promptArr: PromptType[] = [
    new PromptType($r('app.media.pic1'),$r('app.string.add_friends')),
    new PromptType($r('app.media.pic2'),$r('app.string.group_chat')),
    new PromptType($r('app.media.pic3'),$r('app.string.scan')),
    new PromptType($r('app.media.pic4'),$r('app.string.collection_payment'))
  ];

  build() {
    Column() {
      // 首页右上角点击加号按钮弹出的列表框的前4个item
      List({ space: SPACE, initialIndex: INITIAL_INDEX }) {
        ForEach(this.promptArr, (item: PromptType) => {
          ListItem() {
            Prompt({ image: item.image, text: item.text, controller: this.controller })
          }
        }, (item: PromptType) => JSON.stringify(item))
      }
      .friction($r("app.float.customDialog_list_friction"))
      .listDirection(Axis.Vertical) // 排列方向
      // 每行之间的分界线
      .divider({
        strokeWidth:DIVIDER_LINE_STROKWIDTH,
        color: $r("app.color.customDialog_list_divider_color"),
        startMargin: $r("app.integer.customDialog_divider_startMargin"),
        endMargin: $r("app.integer.customDialog_divider_endMargin")
      })

      // 分隔线组件
      Divider()
        .strokeWidth(DIVIDER_LINE_STROKWIDTH)
        .color($r("app.color.customDialog_list_divider_color"))
        .margin({
          left: $r("app.integer.customDialog_divider_startMargin"),
          right: $r('app.integer.customDialog_divider_endMargin')
        })
      // 懒加载开关
      ToggleComponent({ text_option: $r('app.string.prop_lazy_for_each'), isOn: $lazyForEach })
      diaLogDivider()
      // 组件复用开关
      ToggleComponent({ text_option: $r('app.string.prop_reusable'), isOn: $reusable })
      diaLogDivider()
      // 同步加载开关
      ToggleComponent({ text_option: $r('app.string.prop_syncLoad'), isOn: $imageSyncLoad })
      diaLogDivider()
      // 布局优化开关
      ToggleComponent({ text_option: $r('app.string.prop_layout'), isOn: $pageLayout })
      diaLogDivider()
      // 缓存数量开关
      ToggleComponent({ text_option: $r('app.string.prop_cachedCount'), isOn: $listCachedCount })
    }
    .backgroundColor($r("app.color.customDialog_list_backgroundColor"))
    .borderRadius($r("app.integer.customDialog_list_borderRadius"))
    .padding({
      top: $r("app.integer.customDialog_list_padding_top"),
      bottom: $r("app.integer.customDialog_list_padding_bottom")
    })
    .width($r("app.integer.customDialog_list_width"))
  }
}

// 由图片icon和文字构成的组件Prompt
@Component
struct Prompt {
  image: string | Resource = $r("app.media.empresa");
  text: string | Resource = '';
  controller: CustomDialogController = new CustomDialogController({ builder: CustomDialogExample({}) });

  build() {
    Row() {
      Image(this.image)
        .height($r("app.integer.customDialog_Prompt_Image_height"))
        .width($r("app.integer.customDialog_Prompt_Image_width"))
        .margin({
          left: $r("app.integer.customDialog_Prompt_Image_margin_left"),
        })
        .objectFit(ImageFit.Contain)
      Text(this.text)
        .fontSize($r("app.integer.customDialog_Prompt_Text_fontSize"))
        .fontColor($r("app.color.customDialog_Prompt_Text_fontColor"))
        .margin({
          left: $r("app.integer.customDialog_Prompt_Text_margin_left")
        })
    }
    .width('100%')
    .height($r('app.integer.customDialog_Prompt_height'))
    .justifyContent(FlexAlign.Start)
    .onClick(() => {
      this.controller.close()
      AlertDialog.show(
        new MessageDetail($r('app.string.alert_dialog'))
      )
    })
  }
}

// 分隔线组件
@Component
struct diaLogDivider {
  build() {
    Column() {
      Divider()
        .strokeWidth(DIVIDER_LINE_STROKWIDTH)
        .color($r("app.color.customDialog_list_divider_color"))
        .margin({
          left: $r("app.integer.customDialog_diaLogDivider_margin_left"),
          right: $r('app.integer.customDialog_diaLogDivider_margin_right')
        })
    }
  }
}

// 由按钮开关和文字构成的组件ToggleComponent
@Component
struct ToggleComponent {
  text_option: string | Resource = '';
  @Link isOn: boolean;

  build() {
    Column() {
      Row() {
        Text(this.text_option)
          .fontSize($r("app.integer.customDialog_ToggleComponent_fontSize"))
          .fontColor($r("app.color.customDialog_ToggleComponent_fontColor"))
          .margin({
            left: $r("app.integer.customDialog_ToggleComponent_margin_left")
          })

        // 状态按钮样式的开关组件
        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .selectedColor($r("app.color.customDialog_Toggle_selectedColor"))
          .width($r("app.integer.customDialog_Toggle_width"))
          .height($r("app.integer.customDialog_Toggle_height"))
          .switchPointColor($r("app.color.customDialog_Toggle_switchPointColor"))
          .onChange((isOn: boolean) => {
            this.isOn = isOn
          })
      }
      .width('100%')
      .height($r('app.integer.customDialog_Prompt_height'))
      .padding({
        right: $r("app.integer.customDialog_ToggleComponent_margin_right")
      })
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}
