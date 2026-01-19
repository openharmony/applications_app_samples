/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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
struct BindSelectionMenu {
  // [Start richEditor_bindSelectionMenu]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  sliderShow: boolean = false;
  private theme: SelectionMenuTheme = defaultTheme;

  build() {
    Column() {
      // [StartExclude richEditor_bindSelectionMenu]
      // 请将$r('app.string.Set_Attributes_title_1')替换为实际资源文件，在本示例中该资源文件的value值为"设置自定义选择菜单"
      Text($r('app.string.Set_Attributes_title_1'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_bindSelectionMenu]
      RichEditor(this.options)
        .onReady(() => {
          // 请将$r('app.string.SetAttributes_Text_4')替换为实际资源文件，在本示例中该资源文件的value值为"组件设置了自定义菜单，长按可触发。"
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
      // [StartExclude richEditor_bindSelectionMenu]
      // 请将$r('app.string.Set_Attributes_title_1_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过bindSelectionMenu设置自定义选择菜单"
      Text($r('app.string.Set_Attributes_title_1_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_bindSelectionMenu]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }

  @Builder
  SystemMenu() {
    Column() {
      Menu() {
        if (this.controller) {
          MenuItemGroup() {
            MenuItem({
              startIcon: this.theme.cutIcon,
              // 请将$r('app.string.SetAttributes_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"剪切"
              content: resource.resourceToString($r('app.string.SetAttributes_Text_1')),
              labelInfo: 'Ctrl+X'
            })
            MenuItem({
              startIcon: this.theme.copyIcon,
              // 请将$r('app.string.SetAttributes_Text_2')替换为实际资源文件，在本示例中该资源文件的value值为"复制"
              content: resource.resourceToString($r('app.string.SetAttributes_Text_2')),
              labelInfo: 'Ctrl+C'
            })
            MenuItem({
              startIcon: this.theme.pasteIcon,
              // 请将$r('app.string.SetAttributes_Text_3')替换为实际资源文件，在本示例中该资源文件的value值为"粘贴"
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

  build() {
    Column() {
      // [StartExclude richEditor_color]
      // 请将$r('app.string.Set_Attributes_title_2')替换为实际资源文件，在本示例中该资源文件的value值为"设置输入框光标、手柄颜色"
      Text($r('app.string.Set_Attributes_title_2'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_color]
      RichEditor(this.options)
        .onReady(() => {
          // 请将$r('app.string.SetAttributes_Text_5')替换为实际资源文件，在本示例中该资源文件的value值为"组件设置了光标手柄颜色。"
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
      // [StartExclude richEditor_color]
      // 请将$r('app.string.Set_Attributes_title_2_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过caretColor设置输入框光标、手柄颜色"
      Text($r('app.string.Set_Attributes_title_2_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_color]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_color]
}

@Component
struct attr3 {
  // [Start richEditor_placeholder]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      // [StartExclude richEditor_placeholder]
      Text($r('app.string.Set_Attributes_title_3'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_placeholder]
      RichEditor(this.options)
        // 请将$r('app.string.SetAttributes_Text_6')替换为实际资源文件，在本示例中该资源文件的value值为"此处为提示文本..."
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
      // [StartExclude richEditor_placeholder]
      Text($r('app.string.Set_Attributes_title_3_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_placeholder]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_placeholder]
}

@Component
struct attr4 {
  // [Start richEditor_maxLines]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      // [StartExclude richEditor_maxLines]
      // 请将$r('app.string.Set_Attributes_title_4')替换为实际资源文件，在本示例中该资源文件的value值为"设置最大行数"
      Text($r('app.string.Set_Attributes_title_4'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_maxLines]
      /*
       * 请将$r('app.string.SetAttributes_Text_7')替换为实际资源文件，在本示例中该资源文件的
       * value值为"组件设置了最大行数\n超出内容将会以滚动显示\n超出1行\n超出2行\n超出3行\n超出4行"
       */
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
      // [StartExclude richEditor_maxLines]
      // 请将$r('app.string.Set_Attributes_title_4_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过maxLines设置富文本可显示的最大行数"
      Text($r('app.string.Set_Attributes_title_4_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_maxLines]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_maxLines]
}

@Component
struct attr5 {
  // [Start richEditor_maxLength]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      // [StartExclude richEditor_maxLength]
      // 请将$r('app.string.Set_Attributes_title_5')替换为实际资源文件，在本示例中该资源文件的value值为"设置最大长度"
      Text($r('app.string.Set_Attributes_title_5'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_maxLength]
      RichEditor(this.options)
        // 请将$r('app.string.SetAttributes_Text_8')替换为实际资源文件，在本示例中该资源文件的value值为"组件设置了最大字符数：7"
        .placeholder(resource.resourceToString($r('app.string.SetAttributes_Text_8')))
        .maxLength(7)
      // [StartExclude richEditor_maxLength]
      // 请将$r('app.string.Set_Attributes_title_5_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过maxLength设置富文本的最大输入字符数"
      Text($r('app.string.Set_Attributes_title_5_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_maxLength]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_maxLength]
}

@Component
struct attr6 {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      ComponentCard({
        // 请将$r('app.string.Set_Attributes_title_6')替换为实际资源文件，在本示例中该资源文件的value值为"默认选中菜单"
        title: $r('app.string.Set_Attributes_title_6'),
        // 请将$r('app.string.Set_Attributes_title_6_desc')替换为实际资源文件，在本示例中该资源文件的value值为"富文本中的文字被选中时会弹出包含剪切、复制、翻译、分享的菜单"
        description: $r('app.string.Set_Attributes_title_6_desc')
      }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.SetAttributes_Text_9')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段文本,用来展示选中菜单"
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


@Component
struct Decoration {
  // [Start richEditor_decoration]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      // [StartExclude richEditor_decoration]
      // 请将$r('app.string.Set_Attributes_title_9')替换为实际资源文件，在本示例中该资源文件的value值为"设置富文本组件中文本装饰线"
      Text($r('app.string.Set_Attributes_title_9'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_decoration]
      RichEditor(this.options)
        .onReady(() => {
          // 请将$r('app.string.Demo_oneText')替换为实际资源文件，在本示例中该资源文件的value值为"一段预置的文本"
          this.controller.addTextSpan($r('app.string.Demo_oneText'), {
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
      // [StartExclude richEditor_decoration]
      // 请将$r('app.string.Set_Attributes_title_9_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过decoration设置富文本组件中文本装饰线"
      Text($r('app.string.Set_Attributes_title_9_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_decoration]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_decoration]
}

@Component
struct DecorationOptions {
  styledStringController: RichEditorStyledStringController = new RichEditorStyledStringController();

  build() {
    Column() {
      ComponentCard({
        // 请将$r('app.string.Set_Attributes_title_10')替换为实际资源文件，在本示例中该资源文件的value值为"设置富文本多装饰线"
        title: $r('app.string.Set_Attributes_title_10'),
        // 请将$r('app.string.Set_Attributes_title_10_desc')替换为实际资源文件，在本示例中该资源文件的value值为"通过StyledString类型的富文本设置多装饰线"
        description: $r('app.string.Set_Attributes_title_10_desc')
      }) {
        Column({ space: 3 }) {
          // [Start richEditor_decorationOptions]
          RichEditor({ controller: this.styledStringController });
          // 请将$r('app.string.Demo_SetStyledStringButton')替换为实际资源文件，在本示例中该资源文件的value值为"多装饰线文本"
          Button($r('app.string.Demo_SetStyledStringButton'))
            .fontSize(20)
            .onClick(() => {
              let mutString: MutableStyledString = new MutableStyledString(
                // 请将$r('app.string.Demo_styledString')替换为实际资源文件，在本示例中该资源文件的value值为"需设置富文本多装饰线"
                resource.resourceToString($r('app.string.Demo_styledString')), [
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
}

@Component
struct SetTextVerticalAlign {
  // [Start richEditor_textVerticalAlign]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    Column() {
      // [StartExclude richEditor_textVerticalAlign]
      // 请将$r('app.string.Set_Attributes_title_11')替换为实际资源文件，在本示例中该资源文件的value值为"设置垂直居中"
      Text($r('app.string.Set_Attributes_title_11'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_textVerticalAlign]
      RichEditor(this.options)
        .onReady(() => {
          // 请将$r('app.media.startIcon')替换为实际资源文件
          this.controller.addImageSpan($r('app.media.startIcon'), {
            imageStyle: {
              size: [100, 100]
            }
          })
          // 请将$r('app.string.Demo_verticalAlignString')替换为实际资源文件，在本示例中该资源文件的value值为"这是一段富文本，展示了文本垂直居中的效果。"
          this.controller.addTextSpan($r('app.string.Demo_verticalAlignString'), {
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
      // [StartExclude richEditor_textVerticalAlign]
      /* 请将$r('app.string.Set_Attributes_title_11_desc')替换为实际资源文件，在本示例中该资源文件的
        value值为"通过textVerticalAlign设置文本段落在垂直方向的对齐方式" */
      Text($r('app.string.Set_Attributes_title_11_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_textVerticalAlign]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
  // [End richEditor_textVerticalAlign]
}

// [Start richEditor_enableAutoSpacing]
@Component
struct EnableAutoSpacing {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  @State
  enableAutoSpace:boolean = false;

  build() {
    Column() {
      // [StartExclude richEditor_enableAutoSpacing]
      // 请将$r('app.string.Set_Attributes_title_12')替换为实际资源文件，在本示例中该资源文件的value值为"设置中西文自动间距"
      Text($r('app.string.Set_Attributes_title_12'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_enableAutoSpacing]
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.Demo_autoSpacingString')替换为实际资源文件，在本示例中该资源文件的value值为"中西文Auto Spacing自动间距"
            this.controller.addTextSpan($r('app.string.Demo_autoSpacingString'),
              {
                style:
                {
                  fontColor: Color.Orange,
                  fontSize: 20
                }
              })
          })
          .enableAutoSpacing(this.enableAutoSpace)
        // 请将$r('app.string.Demo_autoSpacingButton')替换为实际资源文件，在本示例中该资源文件的value值为"开启中西文自动间距"
        Button($r('app.string.Demo_autoSpacingButton'))
          .fontSize(20)
          .onClick(() => {
            this.enableAutoSpace = true;
          })
      }
      // [StartExclude richEditor_enableAutoSpacing]
      /* 请将$r('app.string.Set_Attributes_title_12_desc')替换为实际资源文件，
       在本示例中该资源文件的value值为"通过enableAutoSpacing设置是否开启中文与西文的自动间距" */
      Text($r('app.string.Set_Attributes_title_12_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_enableAutoSpacing]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
}
// [End richEditor_enableAutoSpacing]

// [Start richEditor_prepareMenu]
@Component
struct PrepareMenu {
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
    const items = menuItems.filter(item => !idsToFilter.some(id => id.equals(item.id)));
    // 请将$r('app.media.xxx')替换为实际资源文件
    let item1: TextMenuItem = {
      content: 'create1',
      icon: $r('app.media.startIcon'),
      id: TextMenuItemId.of('create1'),
    }
    let item2: TextMenuItem = {
      content: 'create2',
      id: TextMenuItemId.of('create2'),
      icon: $r('app.media.startIcon'),
    }
    items.push(item1);
    items.unshift(item2);
    return items;
  }

  onMenuItemClick = (menuItem: TextMenuItem, textRange: TextRange) => {
    if (menuItem.id.equals(TextMenuItemId.of('create2'))) {
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.of('prepare1'))) {
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.COPY)) {
      return true;
    }
    if (menuItem.id.equals(TextMenuItemId.SELECT_ALL)) {
      return false;
    }
    return false;
  }

  onPrepareMenu = (menuItems: Array<TextMenuItem>) => {
    // 请将$r('app.media.xxx')替换为实际资源文件
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
      // [StartExclude richEditor_prepareMenu]
      // 请将$r('app.string.Set_Attributes_title_13')替换为实际资源文件，在本示例中该资源文件的value值为"管理选中菜单项"
      Text($r('app.string.Set_Attributes_title_13'))
        .fontSize(14)
        .fontColor('#666')
      // [EndExclude richEditor_prepareMenu]
      RichEditor(this.options)
        .onReady(() => {
          this.controller.addTextSpan('RichEditor editMenuOptions');
        })
        .editMenuOptions(this.editMenuOptions)
        .onSelectionChange((range: RichEditorRange) => {
          this.endIndex = range.end;
        })
        .height(50)
        .margin({ top: 100 })
        .borderWidth(1)
        .borderColor(Color.Red)
      // [StartExclude richEditor_prepareMenu]
      /*
       * 请将$r('app.string.Set_Attributes_title_13_desc')替换为实际资源文件，在本示例中该资源文件的
       * value值为"当富文本选择区域变化后显示菜单之前触发onPrepareMenu回调，可在该回调中进行菜单数据设置"
       */
      Text($r('app.string.Set_Attributes_title_13_desc'))
        .backgroundColor('#eee')
        .borderRadius(4)
        .padding(4)
        .fontSize(12)
        .fontColor('#999')
        .width('100%')
      // [EndExclude richEditor_prepareMenu]
    }.alignItems(HorizontalAlign.Start)
    .backgroundColor('#fff')
    .borderRadius(12)
    .padding(12)
    .width('100%')
  }
}
// [End richEditor_prepareMenu]

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
          BindSelectionMenu();
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
    // 请将$r('app.string.Set_Attributes_title_13_desc')替换为实际资源文件，在本示例中该资源文件的value值为"设置属性"
    .title($r('app.string.Set_Attributes_title'))
  }
}