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
import { LengthMetrics } from '@kit.ArkUI';


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
  // [Start richEditor_bindSelectionMenu]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  sliderShow: boolean = false;
  private theme: SelectionMenuTheme = defaultTheme;

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
  // [End richEditor_bindSelectionMenu]
}

@Component
struct attr2 {
  // [Start richEditor_color]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [End richEditor_color]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_2'),
        description: $r('app.string.Set_Attributes_title_2_desc')
      }) {
        // [Start richEditor_color]
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
        // [End richEditor_color]
      }
    }
  }
}

@Component
struct attr3 {
  // [Start richEditor_placeholder]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [StartExclude richEditor_placeholder]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_3'),
        description: $r('app.string.Set_Attributes_title_3_desc')
      }) {
        // [EndExclude richEditor_placeholder]
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
        // [End richEditor_placeholder]
      }
    }
  }
}

@Component
struct attr4 {
  // [Start richEditor_maxLines]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [End richEditor_maxLines]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_4'),
        description: $r('app.string.Set_Attributes_title_4_desc')
      }) {
        // [Start richEditor_maxLines]
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
        // [End richEditor_maxLines]
      }
    }
  }
}

@Component
struct attr5 {
  // [Start richEditor_maxLength]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [StartExclude richEditor_maxLength]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_5'),
        description: $r('app.string.Set_Attributes_title_5_desc')
      }) {
        // [EndExclude richEditor_maxLength]
        RichEditor(this.options)
          .placeholder(resource.resourceToString($r('app.string.SetAttributes_Text_8')))
          .onReady(() => {})
          .maxLength(7)
          // [End richEditor_maxLength]
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

// [Start richEditor_decoration]
@Component
struct Decoration {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_9'),
        description: $r('app.string.Set_Attributes_title_9_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan('一段预置的文本', {
              style: {
                fontSize: 25,
                decoration: {
                  type: TextDecorationType.LineThrough,
                  color: Color.Blue,
                  // 设置装饰线粗细比例为6
                  thicknessScale: 6
                }
              }
            })
          })
      }
    }.width('100%')
  }
}
// [End richEditor_decoration]

@Component
struct DecorationOptions {
  styledStringController: RichEditorStyledStringController = new RichEditorStyledStringController();

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_10'),
        description: $r('app.string.Set_Attributes_title_10_desc')
      }) {
        // [Start richEditor_decorationOptions]
        RichEditor({ controller: this.styledStringController })
        Button('多装饰线文本')
          .fontSize(20)
          .onClick(() => {
            let mutString: MutableStyledString = new MutableStyledString('设置富文本多装饰线', [
              {
                start: 0,
                length: 9,
                styledKey: StyledStringKey.FONT,
                styledValue: new TextStyle({ fontSize: LengthMetrics.vp(25) })
              },
              {
                start: 0,
                length: 5,
                styledKey: StyledStringKey.DECORATION,
                styledValue: new DecorationStyle(
                  {
                    type: TextDecorationType.Underline,
                  },
                  {
                    // 开启多装饰线
                    enableMultiType: true
                  })
              },
              {
                start: 2,
                length: 4,
                styledKey: StyledStringKey.DECORATION,
                styledValue: new DecorationStyle(
                  {
                    type: TextDecorationType.LineThrough,
                  },
                  {
                    // 开启多装饰线
                    enableMultiType: true
                  })
              }
            ])
            this.styledStringController.setStyledString(mutString);
          })
        // [End richEditor_decorationOptions]
      }
    }
  }
}

@Component
struct SetTextVerticalAlign {
  // [Start richEditor_textVerticalAlign]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [End richEditor_textVerticalAlign]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_11'),
        description: $r('app.string.Set_Attributes_title_11_desc')
      }) {
        // [Start richEditor_textVerticalAlign]
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addImageSpan($r('app.media.startIcon'), {
              imageStyle: {
                size: [100, 100]
              }
            })
            this.controller.addTextSpan('这是一段富文本，展示了文本垂直居中的效果。', {
              style: {
                fontColor: Color.Pink,
                fontSize: '32'
              },
              paragraphStyle: {
                textAlign: TextAlign.Start,
                textVerticalAlign: TextVerticalAlign.CENTER,
                leadingMargin: 16
              }
            })
          })
        // [End richEditor_textVerticalAlign]
      }
    }
  }
}


@Component
struct EnableAutoSpacing {
  // [Start richEditor_enableAutoSpacing]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [End richEditor_enableAutoSpacing]

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_12'),
        description: $r('app.string.Set_Attributes_title_12_desc')
      }) {
        // [Start richEditor_enableAutoSpacing]
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan('中西文Auto Spacing自动间距',
              {
                style:
                {
                  fontColor: Color.Orange,
                  fontSize: 20
                }
              })
          })
          .enableAutoSpacing(true)
        // [End richEditor_enableAutoSpacing]
      }
    }
  }
}


@Component
struct PrepareMenu {
  // [Start richEditor_prepareMenu]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  @State endIndex: number | undefined = 0;
  onCreateMenu = (menuItems: Array<TextMenuItem>) => {
    const idsToFilter = [
      TextMenuItemId.TRANSLATE,
      TextMenuItemId.SHARE,
      TextMenuItemId.SEARCH,
      TextMenuItemId.AI_WRITER
    ]
    const items = menuItems.filter(item => !idsToFilter.some(id => id.equals(item.id)))
    let item1: TextMenuItem = {
      content: 'create1',
      icon: $r('app.media.startIcon'),
      id: TextMenuItemId.of('create1'),
    };
    let item2: TextMenuItem = {
      content: 'create2',
      id: TextMenuItemId.of('create2'),
      icon: $r('app.media.startIcon'),
    };
    items.push(item1);
    items.unshift(item2);
    return items;
  }

  onMenuItemClick = (menuItem: TextMenuItem, textRange: TextRange) => {
    if (menuItem.id.equals(TextMenuItemId.of('create2'))) {
      console.info('拦截 id: create2 start:' + textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.of('prepare1'))) {
      console.info('拦截 id: prepare1 start:' + textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.COPY)) {
      console.info('拦截 COPY start:' + textRange.start + '; end:' + textRange.end);
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.SELECT_ALL)) {
      console.info('不拦截 SELECT_ALL start:' + textRange.start + '; end:' + textRange.end);
      return false;
    }
    return false;
  }

  onPrepareMenu = (menuItems: Array<TextMenuItem>) => {
    let item1: TextMenuItem = {
      content: 'prepare1_' + this.endIndex,
      icon: $r('app.media.startIcon'),
      id: TextMenuItemId.of('prepare1'),
    };
    menuItems.unshift(item1);
    return menuItems;
  }

  @State editMenuOptions: EditMenuOptions = {
    onCreateMenu: this.onCreateMenu,
    onMenuItemClick: this.onMenuItemClick,
    onPrepareMenu: this.onPrepareMenu
  };

  build() {
    Column() {
      ComponentCard({
        title: $r('app.string.Set_Attributes_title_13'),
        description: $r('app.string.Set_Attributes_title_13_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan('RichEditor editMenuOptions');
          })
          .editMenuOptions(this.editMenuOptions)
          .onSelectionChange((range: RichEditorRange) => {
            console.info('onSelectionChange, (' + range.start + ',' + range.end + ')');
            this.endIndex = range.end;
          })
          .height(50)
          .margin({ top: 100 })
          .borderWidth(1)
          .borderColor(Color.Red)
      }
    }
  }
  // [End richEditor_prepareMenu]
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
          Decoration();
          DecorationOptions();
          SetTextVerticalAlign();
          EnableAutoSpacing();
          PrepareMenu();
        }
        .width('100%')
        .padding({ left: 12, right: 12 })
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Set_Attributes_title'))
  }
}