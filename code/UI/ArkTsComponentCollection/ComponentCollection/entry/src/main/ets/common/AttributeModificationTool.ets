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

import common from '@ohos.app.ability.common'

const TOOL_WIDTH: SizeOptions = { width: 150, height: 38 }

class ResourceObjectType {
  value!: Resource;
}

/**
 * Slider in item style
 *
 * @param changeValue slide to change
 */
@Component
export struct CommonItemSlider {
  @Link changeValue: number;
  private min: number = 0;
  private max: number = 0;
  private name: ResourceStr = '';
  private step: number = 1;
  private testId: string = 'test_colorSelect';
  private vpTest: string = 'vp';

  build() {
    Row() {
      Text(this.name)
      Slider({
        value: this.changeValue,
        step: this.step,
        min: this.min,
        max: this.max })
        .id(this.testId)
        .layoutWeight(1)
        .onChange((value: number) => {
          this.changeValue = value
          console.log('Sample_ComponentCollection' + String(value))
        }).onClick((event: ClickEvent) => {
        let text = '  screenX:' + event.screenX + '  screenY:' + event.screenY
        console.log('Sample_ComponentCollection' + text)
      })
      Text(`${Math.trunc(this.changeValue)}` + this.vpTest)
    }
    .id(this.testId)
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.SpaceAround)
  }
}

/**
 *  New Slider style to two row
 *  Text Name at the top left of the slider
 *  ChangeValue at the top right of the slider
 * @param changeValue slide to change
 */
@Component
export struct CommonItemTwoRowSlider {
  @Link changeValue: number;
  private min: number = 0;
  private max: number = 0;
  private name: ResourceStr = '';
  private step: number = 1;
  private testId: string = 'test_colorSelect';
  private vpTest: string = 'vp';

  build() {
    Column() {
      Row() {
        Text(this.name)
        Text(`${Math.trunc(this.changeValue)}` + this.vpTest)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 4 })
      .width('100%')

      Slider({
        value: this.changeValue,
        step: this.step,
        min: this.min,
        max: this.max })
        .id(this.testId)
        .width('100%')
        .onChange((value: number) => {
          this.changeValue = value
          console.log('Sample_ComponentCollection' + String(value))
        }).onClick((event: ClickEvent) => {
        let text = '  screenX:' + event.screenX + '  screenY:' + event.screenY
        console.log('Sample_ComponentCollection' + text)
      })
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceAround)
  }
}

/**
 * Select in item style, provide multiple choices based on menuList
 */
@Component
export struct CommonItemSelect {
  private selects: ResourceStr[] = [];
  private callback: (index: number, value: string) => void = (index: number, value: string) => {};
  private selectOption: SelectOption[] = [];
  private name: ResourceStr = '';
  private testId: string = 'test_itemSelect';
  private selectIndex: number = 0;
  private fontSize: Font = { size: 15, weight: FontWeight.Medium };
  private isItemStyle: boolean = true;
  private text: string = "请选择";

  aboutToAppear() {
    this.selects.forEach((selects, index) => {
      this.selectOption[index] = { value: selects }
    })
  }

  build() {
    Row() {
      Text(this.name)
        .margin({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
      Blank()
      Select(this.selectOption)
        .id(this.testId)
        .value(this.text)
        .backgroundColor(Color.White)
        .borderRadius(19)
        .constraintSize({ minWidth: 150 })
        .selected(this.selectIndex)
        .font(this.fontSize)
        .optionFont(this.fontSize)
        .onSelect((index, value) => {
          this.callback(index, value)
          this.selectIndex = index
        })
        .height('100%')
    }
    .size({ width: '100%', height: this.isItemStyle ? 42 : 70 })
    .padding({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
    .borderRadius(this.isItemStyle ? 0 : 24)
    .backgroundColor(this.isItemStyle ? Color.Transparent : Color.White)
    .margin({ bottom: 6 })
  }
}

/**
 * Select Color
 *
 * @param color change color
 */
@Component
export struct CommonItemColorSelect {
  @Link selectColor: Resource;
  @State selectIndex: number = 0;
  private testId: string = 'test_colorSelect';
  private name!: Resource;
  private isItemStyle: boolean = true;
  private colorNames: Array<ResourceObjectType> = [{ value: $r('app.string.divider_color_blue') }, {
    value: $r('app.string.divider_color_green')
  }, { value: $r('app.string.divider_color_orange') }, { value: $r('app.string.divider_color_pink') }];

  changeResourceToString(resourceData: Resource) {
    let context = getContext(this) as common.UIAbilityContext
    return context.resourceManager.getStringSync(resourceData.id)
  }

  build() {
    Row() {
      Text(this.name)
        .margin({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
      Blank()
      Select(this.colorNames)
        .value(this.changeResourceToString(this.colorNames[this.selectIndex].value))
        .borderRadius(19)
        .font({ size: 20 })
        .optionFont({ size: 20 })
        .constraintSize({ minWidth: 150 })
        .selected(this.selectIndex)
        .selectedOptionFont({ size: 20 })
        .backgroundColor($r('app.color.background_shallow_grey'))
        .padding({ left: 20, right: 20, top: 8, bottom: 8 })
        .onSelect((index) => {
          this.selectIndex = index
          switch (index) {
            case 0:
              this.selectColor = $r('app.color.background_blue')
              break
            case 1:
              this.selectColor = $r('app.color.background_green')
              break
            case 2:
              this.selectColor = $r('app.color.background_orange')
              break
            case 3:
              this.selectColor = $r('app.color.background_pink')
              break
            default:
              this.selectColor = $r('app.color.background_dark')
          }
        })
        .id(this.testId)
    }
    .margin({ bottom: 6 })
    .borderRadius(this.isItemStyle ? 0 : 24)
    .size({ width: '100%', height: this.isItemStyle ? 42 : 70 })
    .padding({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
    .backgroundColor(this.isItemStyle ? Color.Transparent : Color.White)
  }
}

/**
 * Select Color
 *
 * @param color change color
 */
@Component
export struct CommonItemColorSelectDef {
  @Link selectColor: Color;
  @State selectIndex: number = 0;
  private testId: string = 'test_colorSelect_def';
  private name!: Resource;
  private isItemStyle: boolean = true;
  private colorNames: Array<ResourceObjectType> = [{ value: $r('app.string.divider_color_blue') }, {
    value: $r('app.string.divider_color_green')
  }, { value: $r('app.string.divider_color_orange') }, { value: $r('app.string.divider_color_pink') }];

  changeResourceToString(resourceData: Resource) {
    let context = getContext(this) as common.UIAbilityContext
    return context.resourceManager.getStringSync(resourceData.id)
  }

  build() {
    Row() {
      Text(this.name)
        .margin({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
      Blank()
      Select(this.colorNames)
        .value(this.changeResourceToString(this.colorNames[this.selectIndex].value))
        .borderRadius(19)
        .font({ size: 20 })
        .optionFont({ size: 20 })
        .constraintSize({ minWidth: 150 })
        .selected(this.selectIndex)
        .selectedOptionFont({ size: 20 })
        .backgroundColor($r('app.color.background_shallow_grey'))
        .padding({ left: 20, right: 20, top: 8, bottom: 8 })
        .onSelect((index) => {
          console.log("selectColor index : " + index)
          this.selectIndex = index
          switch (index) {
            case 0:
              this.selectColor = Color.Blue
              break
            case 1:
              this.selectColor = Color.Green
              break
            case 2:
              this.selectColor = Color.Orange
              break
            case 3:
              this.selectColor = Color.Pink
              break
            default:
              this.selectColor = Color.Black
          }
        })
        .id(this.testId)
    }
    .margin({ bottom: 6 })
    .borderRadius(this.isItemStyle ? 0 : 24)
    .size({ width: '100%', height: this.isItemStyle ? 42 : 70 })
    .padding({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
    .backgroundColor(this.isItemStyle ? Color.Transparent : Color.White)
  }
}

/**
 * TextInput of change panel
 *
 * @param inputValue change inputValue
 */
@Component
export struct CommonItemInput {
  @Link inputValue: string;
  private name!: Resource;
  private placeholder?: ResourceStr = '';

  build() {
    Row() {
      Text(this.name)
        .margin({ left: 12, right: 12 })
      Blank()
      TextInput({ placeholder: this.placeholder })
        .size(TOOL_WIDTH)
        .onChange(value => {
          this.inputValue = value
        }).id('test_input')
        .enableKeyboardOnFocus(false)
    }
    .size({ width: '100%', height: 70 })
    .padding({ left: 12, right: 12 })
    .borderRadius(24)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 12, bottom: 12 })
  }
}


@Component
export struct CommonSwitcher {
  @Link bool: boolean;
  private name: ResourceStr = '';
  private testId: string = '';
  private testID: string = '';

  build() {
    Row() {
      Text(this.name)
      Blank()
      Toggle({ type: ToggleType.Switch, isOn: this.bool })
        .onChange((isOn) => {
          this.bool = isOn
        })
        .id(this.testId || this.testID)
    }.width('100%')
    .height(40)
  }
}

@Component
export struct ImageItemSlider {
  @Link changeValue: number;
  private min: number = 0;
  private max: number = 0;
  private name: ResourceStr = '';

  build() {
    Row() {
      Text(this.name)
      Slider({
        value: this.changeValue,
        step: 1,
        min: this.min,
        max: this.max })
        .layoutWeight(1)
        .onChange((value: number) => {
          this.changeValue = value
          console.log('Sample_ComponentCollection' + String(value))
        }).onClick((event: ClickEvent) => {
        let text = '  screenX:' + event.screenX + '  screenY:' + event.screenY
        console.log('Sample_ComponentCollection' + text)
      })
      Text(`${Math.trunc(this.changeValue)}`)
    }
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.SpaceAround)
  }
}
