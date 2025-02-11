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
import { window, KeyboardAvoidMode } from '@kit.ArkUI';
import { inputMethod } from '@kit.IMEKit';
import { KeyboardDataSource } from '../basicDataResource/BasicDataSource';
import { common } from '@kit.AbilityKit';

/**
 * 功能描述: 本示例介绍使用TextInput组件和LazyForEach实现组件随软键盘弹出避让场景
 *
 * 推荐场景: 需要用户手动输入文字的场景
 *
 * 核心组件:
 * 1. KeyboardAvoid.liftUpComponents
 * 2. KeyboardAvoid.scalingComponents
 *
 * 实现步骤:
 * 1. 在输入按钮的点击事件中调用focusControl.requestFocus API，即可实现给TextInput组件申请焦点功能
 * 2. 通过监听键盘高度，可以感知到键盘的拉起收起状态，实现缩放组件尺寸的调整，配合KeyboardAvoidMode.RESIZE避让模式，实现组件上抬压缩效果
 */
@Component
export struct KeyboardAvoid {
  @State keyboardHeight: number = 0; // 软键盘高度
  @State contentData: string[] =
    ['第一条数据', '第二条数据', '第三条数据', '第四条数据', '第五条数据', '第六条数据', '第七条数据', '第八条数据',
      '第九条数据', '第十条数据', '第十一条数据', '第十二条数据'];
  @State isLiftUpShow: boolean = true;
  @State isScalingShow: boolean = false;
  @StorageLink('avoidAreaBottomToModule') avoidAreaBottomToModule: number = 0;
  private scrollerForLiftUp: Scroller = new Scroller();
  private scrollerForScaling: Scroller = new Scroller();
  private dataSource: KeyboardDataSource = new KeyboardDataSource(this.contentData);

  aboutToAppear(): void {
    // TODO：知识点：虚拟键盘抬起时，页面的避让模式设置为RESIZE模式
    let context = getContext(this) as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      currentWindow.on('keyboardHeightChange', (data: number) => {
        this.keyboardHeight = px2vp(data);
      })
    })
  }

  // 上抬组件
  @Builder
  liftUpComponents() {
    Scroll(this.scrollerForLiftUp) {
      Column() {
        LazyForEach(this.dataSource, (item: string) => {
          this.liftUpContentComponent(item)
        }, (item: string) => item)
      }
      .id('KeyboardAvoidLiftUpComponents')
      .width($r('app.string.key_board_components_weight'))
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.End)
      .backgroundColor($r('app.color.key_board_page_background_color'))
    }
    .height($r('app.string.key_board_lift_up_components_height'))
    .layoutWeight(1)
    .visibility(this.isLiftUpShow ? Visibility.Visible : Visibility.None)
    .borderRadius($r('app.string.key_board_scenes_main_page_list_borderRadius'))
  }

  // 上抬组件成员
  @Builder
  liftUpContentComponent(item: string) {
    Row() {
      Image('')
        .borderRadius($r('app.string.key_board_scenes_item_image_border_radius'))
        .objectFit(ImageFit.Contain)
        .width($r('app.string.key_board_scenes_item_image_height'))
        .height($r('app.string.key_board_scenes_item_image_height'))
        .backgroundColor($r('app.color.key_board_item_image_background_color'))
        .margin($r('app.string.key_board_scenes_item_image_border_radius'))
      Text(item)
        .padding({
          left: $r('app.string.key_board_scenes_main_page_padding6'),
          right: $r('app.string.key_board_scenes_main_page_padding6')
        })
        .width($r('app.string.key_board_components_weight'))
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .fontSize($r('app.string.key_board_scenes_item_text_font_size'))
        .fontColor($r('app.color.key_board_item_font_color'))
        .margin({
          top: $r('app.string.key_board_scenes_main_page_margin_top'),
          bottom: $r('app.string.key_board_scenes_main_page_margin_top')
        })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .linearGradient({
      angle: 180,
      colors: [[$r('app.color.key_board_item_background_color1'), 0],
        [$r('app.color.key_board_item_background_color2'), 1]]
    })
    .width($r('app.string.key_board_components_weight'))
    .borderRadius($r('app.string.key_board_scenes_main_page_list_borderRadius'))
    .margin($r('app.string.key_board_scenes_item_gap_half'))
  }

  // 缩放组件
  @Builder
  scalingComponents() {
    Scroll(this.scrollerForScaling) {
      Column() {
        Grid() {
          LazyForEach(this.dataSource, (item: string) => {
            GridItem() {
              this.scalingContentComponent(item)
            }
          }, (item: string) => item)
        }
        .backgroundColor($r('app.color.key_board_page_background_color'))
        .cachedCount(Number($r('app.integer.key_board_grid_cache_count')))
      }
      .id('KeyboardAvoidScalingComponents')
      .width($r('app.string.key_board_components_weight'))
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.End)
    }
    .height($r('app.string.key_board_lift_up_components_height'))
    .layoutWeight(1)
    .visibility(this.isScalingShow ? Visibility.Visible : Visibility.None)
    .borderRadius($r('app.string.key_board_scenes_main_page_list_borderRadius'))
  }

  // 缩放组件成员
  @Builder
  scalingContentComponent(item: string) {
    Column() {
      Image('')
        .borderRadius(8)
        .objectFit(ImageFit.Contain)
        .width(this.keyboardHeight > 0 ? $r('app.string.key_board_scenes_item_small_image_height') :
        $r('app.string.key_board_scenes_item_big_image_height'))
        .height(this.keyboardHeight > 0 ? $r('app.string.key_board_scenes_item_small_image_height') :
        $r('app.string.key_board_scenes_item_big_image_height'))
        .backgroundColor($r('app.color.key_board_item_image_background_color'))
        .margin($r('app.string.key_board_scenes_item_gap_half'))
      Text(item)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.string.key_board_scenes_item_text_font_size'))
        .fontColor($r('app.color.key_board_item_font_color'))
        .margin({
          top: $r('app.string.key_board_scenes_main_page_margin_top'),
          bottom: $r('app.string.key_board_scenes_main_page_margin_top')
        })
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .linearGradient({
      angle: 180,
      colors: [[$r('app.color.key_board_item_background_color1'), 0],
        [$r('app.color.key_board_item_background_color2'), 1]]
    })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width(this.keyboardHeight > 0 ? $r('app.string.key_board_scenes_item_small_height') :
    $r('app.string.key_board_scenes_item_big_height'))
    .height(this.keyboardHeight > 0 ? $r('app.string.key_board_scenes_item_small_height') :
    $r('app.string.key_board_scenes_item_big_height'))
    .borderRadius($r('app.string.key_board_scenes_main_page_list_borderRadius'))
    .margin($r('app.string.key_board_scenes_item_gap_half'))
  }

  build() {
    Column() {
      this.liftUpComponents()
      this.scalingComponents()
      TextInput()// TODO：知识点：输入框自动获焦
        .id('keyboardAvoidTextInput')
        .defaultFocus(true)
        .key($r('app.string.key_board_text_input_key_string').toString())
        .border({
          width: $r('app.integer.key_board_text_input_border_width'),
          color: $r('app.color.key_board_input_border_color')
        })
        .opacity($r('app.string.key_board_scenes_item_image_opacity'))
        .margin($r('app.integer.key_board_scenes_tab_bar_image_more_row_margin'))
      Row() {
        Button($r('app.string.key_board_button_input_string'))
          .id('KeyboardAvoidButtonPopUpKeyboard')
          .opacity(this.keyboardHeight > 0 ? 0.5 : 1)
          .onClick(() => {
            // TODO：知识点：使用focusControl.requestFocus API实现textInput获焦拉起键盘
            focusControl.requestFocus($r('app.string.key_board_text_input_key_string').toString());
          })
        Button($r('app.string.key_board_button_lift_up_string'))
          .id('KeyboardAvoidButtonLiftUp')
          .fontColor(this.isLiftUpShow ? Color.White : Color.Black)
          .backgroundColor(this.isLiftUpShow ? $r('app.color.key_board_button_selected_color') :
          $r('app.color.key_board_button_unselected_color'))
          .opacity(this.isLiftUpShow ? 1 : 0.8)
          .onClick(() => {
            // 点击按钮实现上抬组件显示，缩放组件隐藏
            this.isLiftUpShow = true;
            this.isScalingShow = false;
          })
        Button($r('app.string.key_board_button_scaling_string'))
          .id('KeyboardAvoidButtonScaling')
          .fontColor(this.isScalingShow ? Color.White : Color.Black)
          .backgroundColor(this.isScalingShow ? $r('app.color.key_board_button_selected_color') :
          $r('app.color.key_board_button_unselected_color'))
          .opacity(this.isScalingShow ? 1 : 0.8)
          .onClick(() => {
            // 点击按钮实现缩放组件显示，上抬组件隐藏
            this.isScalingShow = true;
            this.isLiftUpShow = false;
          })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width($r('app.string.key_board_components_weight'))
    }
    .id('KeyboardAvoidBlank')
    .padding({ bottom: px2vp(this.avoidAreaBottomToModule) })
    .width($r('app.string.key_board_components_weight'))
    .height($r('app.string.key_board_components_height'))
    .onClick(() => {
      // 点击收起键盘
      inputMethod.getController().stopInputSession();
    })
  }
}