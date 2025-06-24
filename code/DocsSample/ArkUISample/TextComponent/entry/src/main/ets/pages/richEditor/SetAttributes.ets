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

import { ComponentCard } from '../../common/Card';
import resource from '../../common/resource';

// 自定义SelectionMenuTheme接口
export interface SelectionMenuTheme {
  imageSize: number;
  buttonSize: number;
  menuSpacing: number;
  editorOptionMargin: number;
  expandedOptionPadding: number;
  defaultMenuWidth: number;
  imageFillColor: Resource;
  backGroundColor: Resource;
  iconBorderRadius: Resource;
  containerBorderRadius: Resource;
  cutIcon: Resource;
  copyIcon: Resource;
  pasteIcon: Resource;
  selectAllIcon: Resource;
  shareIcon: Resource;
  translateIcon: Resource;
  searchIcon: Resource;
  arrowDownIcon: Resource;
  iconPanelShadowStyle: ShadowStyle;
  iconFocusBorderColor: Resource;
}

// 定义defaultTheme变量
export const defaultTheme: SelectionMenuTheme = {
  imageSize: 24,
  buttonSize: 48,
  menuSpacing: 8,
  editorOptionMargin: 1,
  expandedOptionPadding: 3,
  defaultMenuWidth: 256,
  imageFillColor: $r('sys.color.ohos_id_color_primary'),
  backGroundColor: $r('sys.color.ohos_id_color_dialog_bg'),
  iconBorderRadius: $r('sys.float.ohos_id_corner_radius_default_m'),
  containerBorderRadius: $r('sys.float.ohos_id_corner_radius_card'),
  cutIcon: $r('sys.media.ohos_ic_public_cut'),
  copyIcon: $r('sys.media.ohos_ic_public_copy'),
  pasteIcon: $r('sys.media.ohos_ic_public_paste'),
  selectAllIcon: $r('sys.media.ohos_ic_public_select_all'),
  shareIcon: $r('sys.media.ohos_ic_public_share'),
  translateIcon: $r('sys.media.ohos_ic_public_translate_c2e'),
  searchIcon: $r('sys.media.ohos_ic_public_search_filled'),
  arrowDownIcon: $r('sys.media.ohos_ic_public_arrow_down'),
  iconPanelShadowStyle: ShadowStyle.OUTER_DEFAULT_MD,
  iconFocusBorderColor: $r('sys.color.ohos_id_color_focused_outline'),
}

@Component
struct attr1 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  sliderShow: boolean = false;
  private theme: SelectionMenuTheme = defaultTheme;

  @Builder
  SystemMenu() {
    Column() {
      Menu() {
        if (this.controller) {
          MenuItemGroup() {
            MenuItem({
              startIcon: this.theme.cutIcon,
              content: resource.resourceToString($r('app.string.SetAttributes_Text_1')),
              labelInfo: 'Ctrl+X'
            })
            MenuItem({
              startIcon: this.theme.copyIcon,
              content: resource.resourceToString($r('app.string.SetAttributes_Text_2')),
              labelInfo: 'Ctrl+C'
            })
            MenuItem({
              startIcon: this.theme.pasteIcon,
              content: resource.resourceToString($r('app.string.SetAttributes_Text_3')),
              labelInfo: 'Ctrl+V'
            })
          }
        }
      }
      .radius(this.theme.containerBorderRadius)
      .clip(true)
      .backgroundColor(Color.White)
      .width(this.theme.defaultMenuWidth)
    }
    .width(this.theme.defaultMenuWidth)
  }

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_1'),
        description: $r('app.string.Set_Attributes_title_1_desc'),
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(resource.resourceToString($r('app.string.SetAttributes_Text_4')), {
              style: {
                fontColor: Color.Black,
                fontSize: 18
              }
            })
          })
          .bindSelectionMenu(RichEditorSpanType.TEXT, this.SystemMenu, ResponseType.LongPress, {
            onDisappear: () => {
              this.sliderShow = false
            }
          })
          // 绑定自定义菜单
          .width(300)
          .height(300)
      }
    }
  }
}

@Component
struct attr2 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_2'),
        description: $r('app.string.Set_Attributes_title_2_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(resource.resourceToString($r('app.string.SetAttributes_Text_5')), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .caretColor(Color.Orange)
          .width(300)
          .height(300)
      }
    }
  }
}

@Component
struct attr3 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_3'),
        description: $r('app.string.Set_Attributes_title_3_desc')
      }) {
        RichEditor(this.options)
          .placeholder(resource.resourceToString($r('app.string.SetAttributes_Text_6')), {
            fontColor: Color.Gray,
            font: {
              size: 15,
              weight: FontWeight.Normal,
              family: 'HarmonyOS Sans',
              style: FontStyle.Normal
            }
          })
          .width(300)
          .height(50)
      }
    }
  }
}

@Component
struct attr4 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_4'),
        description: $r('app.string.Set_Attributes_title_4_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(resource.resourceToString($r('app.string.SetAttributes_Text_7')),
              {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
          })
          .maxLines(2)
      }
    }
  }
}

@Component
struct attr5 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_5'),
        description: $r('app.string.Set_Attributes_title_5_desc')
      }) {
        RichEditor(this.options)
          .placeholder(resource.resourceToString($r('app.string.SetAttributes_Text_8')))
          .onReady(() => {
          })
          .maxLength(7)
      }
    }
  }
}

@Component
struct attr6 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_6'),
        description: $r('app.string.Set_Attributes_title_6_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(resource.resourceToString($r('app.string.SetAttributes_Text_9')), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
      }
    }
  }
}

@Entry
@Component
export struct SetAttributes {
  scroller: Scroller = new Scroller();
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({ space: 12 }) {
          attr1();
          attr2();
          attr3();
          attr4();
          attr5();
          attr6();
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Set_Attributes_title'))
  }
}