/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import promptAction from '@ohos.prompt';
import { TitleBar } from '../../../../common/TitleBar';
import { IntroductionTitle } from '../../../../common/IntroductionTitle';

@Extend(Button) function MyButtonStyle() {
  .margin(8)
  .fontSize(16)
  .width('90%')
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Extend(Row) function rowStyle() {
  .padding(8)
  .borderRadius(24)
  .width('100%')
  .backgroundColor(Color.White)
  .margin({ left: 12, right: 12 })
}

@Extend(ListItem) function itemCardStyle() {
  .backgroundColor($r('app.color.background_grey'))
  .borderRadius(12)
  .width('100%')
  .padding(10)
}

class MyButtonNormalModifier implements AttributeModifier<ButtonAttribute> {
  isBlue: boolean = false
  applyNormalAttribute(instance: ButtonAttribute): void {
    if (this.isBlue) {
      instance.backgroundColor(Color.Red);
    } else {
      instance.backgroundColor(Color.Blue);
    }
  }
}

class MyButtonPressedModifier implements AttributeModifier<ButtonAttribute> {
  applyNormalAttribute(instance: ButtonAttribute): void {
      instance.backgroundColor(Color.Blue);
  }
  applyPressedAttribute(instance: ButtonAttribute): void {
      instance.backgroundColor(Color.Red);
  }
}

class MyListItemPressedModifier implements AttributeModifier<ListItemAttribute> {
  applyNormalAttribute(instance: ListItemAttribute): void {
    instance.backgroundColor($r('app.color.background_grey'));
  }
  applyPressedAttribute(instance: ListItemAttribute): void {
    instance.backgroundColor(Color.Red);
  }
}

class MyButtonDisableModifier implements AttributeModifier<ButtonAttribute> {
  applyNormalAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Blue);
  }
  applyDisabledAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Red);
  }
}

class MyRadioSelectModifier implements AttributeModifier<RadioAttribute> {
  applyNormalAttribute(instance: RadioAttribute): void {
    instance.backgroundColor(Color.Blue);
  }
  applySelectedAttribute(instance: RadioAttribute): void {
    instance.radioStyle({
      checkedBackgroundColor: Color.Red
    })
  }
}

class MyButtonFocusModifier implements AttributeModifier<ButtonAttribute> {
  applyNormalAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Blue);
  }
  applyFocusedAttribute(instance: ButtonAttribute): void {
    instance.backgroundColor(Color.Red);
  }
}

@Entry
@Component
struct AttributeModifierSample {
  @State normalModifier: MyButtonNormalModifier = new MyButtonNormalModifier();
  @State buttonPressModifier: MyButtonPressedModifier = new MyButtonPressedModifier();
  @State listItemPressModifier: MyListItemPressedModifier = new MyListItemPressedModifier();
  @State buttonIsDisabled: boolean = false;
  @State disableModifier: MyButtonDisableModifier = new MyButtonDisableModifier();
  @State selectValue: boolean = false;
  @State selectModifier: MyRadioSelectModifier = new MyRadioSelectModifier();
  @State focusedModifier: MyButtonFocusModifier = new MyButtonFocusModifier();

  build() {
    Column() {
      TitleBar({ title: $r('app.string.attribute_modifier') })
      Row() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.select_to_see_status') })
          Row({ space: 10 }) {
            Radio({ value: 'Radio1', group: 'radioGroup1' })
              .checked(this.selectValue)
              .height(40)
              .width(40)
              .borderWidth(0)
              .borderRadius(30)
              .id('radio1')
              .attributeModifier(this.selectModifier)
              .onClick(() => {
                this.selectValue = !this.selectValue;
              })
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(24)
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ left: 12, right: 12 })
          .padding({ left: 12 })

          IntroductionTitle({ introduction: $r('app.string.disable_to_see_status') })
          Row({ space: 10 }) {
              Text($r('app.string.button_disabled'))
                .fontSize(18)
                .margin({ left: 12 })
              Checkbox()
                .select(this.buttonIsDisabled)
                .id('checkbox1')
                .onChange((value: boolean) => {
                  this.buttonIsDisabled = value;
                })
              Button($r('app.string.component_id_disable_to_see_attributeModifier'))
                .attributeModifier(this.disableModifier)
                .enabled(!this.buttonIsDisabled)
                .id('disableButton')
                .width('65%')
                .margin({ right: 12, top: 8, bottom: 8 })
                .onClick(() => {
                  promptAction.showToast({
                    message: 'Button Clicked'
                  })
                })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .rowStyle()
          .padding({ left: 12, right: 12 })

          IntroductionTitle({ introduction: $r('app.string.click_to_see_status') })
          Row({ space: 10 }) {
            Button($r('app.string.component_id_click_to_see_attributeModifier'))
              .MyButtonStyle()
              .id('clickButton')
              .attributeModifier(this.normalModifier)
              .onClick(() => {
                this.normalModifier.isBlue = !this.normalModifier.isBlue;
              })
          }
          .justifyContent(FlexAlign.Center)
          .borderRadius(24)
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ left: 12, right: 12 })

          IntroductionTitle({ introduction: $r('app.string.press_to_see_status') })
          Column({ space: 8 }) {
            Button($r('app.string.component_id_press_to_see_attributeModifier'))
              .MyButtonStyle()
              .attributeModifier(this.buttonPressModifier)
              .id('longClickButton')

            Row(){
              Text($r('app.string.component_id_press_list_to_see_attributeModifier'))
                .fontSize(18)
            }

            List({ space: 5 }) {
              ForEach([1, 2, 3, 4, 5, 6, 7, 8], (item: string) => {
                ListItem() {
                  Text(item + "")
                    .width('100%')
                    .fontSize(18)
                    .textAlign(TextAlign.Center)
                }
                .id('ListItem'+item)
                .width('100%')
                .itemCardStyle()
                .attributeModifier(this.listItemPressModifier)
              })
            }
            .height(150)
            .width('100%')
            .backgroundColor(Color.White)
            .padding({ left: 24, right: 24, bottom: 8, top: 8 })
            .borderRadius(24)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .borderRadius(24)
          .width('100%')
          .backgroundColor(Color.White)
          .margin({ left: 12, right: 12 })

          IntroductionTitle({ introduction: $r('app.string.focus_control_tab_status') })
          Row({ space: 20 }) {
            Column({ space: 5 }) {
              Button($r('app.string.focus_control_group1'))
                .id('focusButton1')
                .width(195)
                .height(40)
                .fontColor(Color.White)
                .attributeModifier(this.focusedModifier)
                .focusOnTouch(true) // 该Button组件点击后可获焦
              Row({ space: 5 }) {
                Button()
                  .id('focusButton2')
                  .width(95)
                  .height(40)
                  .attributeModifier(this.focusedModifier)
                  .fontColor(Color.White)
                Button()
                  .id('focusButton3')
                  .width(95)
                  .height(40)
                  .attributeModifier(this.focusedModifier)
                  .fontColor(Color.White)
                  .focusOnTouch(true) // 该Button组件点击后可获焦
              }
            }
            .padding(5)
            .width('45%')
            .borderWidth(2)
            .borderColor(Color.Red)
            .borderStyle(BorderStyle.Dashed)
            .margin({ left: 12 })
            .tabIndex(1) // 该Column组件为按TAB键走焦的第一个获焦的组件

            Column({ space: 5 }) {
              Button($r('app.string.focus_control_group2'))
                .width(195)
                .height(40)
                .fontColor(Color.White)
              Row({ space: 5 }) {
                Button()
                  .width(95)
                  .height(40)
                  .fontColor(Color.White)
                Button()
                  .width(95)
                  .height(40)
                  .fontColor(Color.White)
                  .groupDefaultFocus(true) // 该Button组件上级Column组件获焦时获焦
              }
            }
            .padding(5)
            .margin({ right: 12 })
            .width('45%')
            .borderWidth(2)
            .borderColor(Color.Orange)
            .borderStyle(BorderStyle.Dashed)
            .tabIndex(2) // 该Column组件为按TAB键走焦的第二个获焦的组件
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .rowStyle()
        }
      }
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
