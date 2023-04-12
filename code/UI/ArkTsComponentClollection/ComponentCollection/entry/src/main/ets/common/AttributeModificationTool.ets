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

import common from "@ohos.app.ability.common"
const TOOL_WIDTH: SizeOptions = { width: 150, height: 38 }

/**
 * Slider in item style
 *
 * @param changeValue slide to change
 */
@Component
export struct CommonItemSlider {
  @Link changeValue: number
  private min: number
  private max: number
  private name: ResourceStr

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
        })
      Text(`${Math.trunc(this.changeValue)}vp`)
    }
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.SpaceAround)
  }
}

/**
 * Select in item style, provide multiple choices based on menuList
 */
@Component
export struct CommonItemSelect {
  private selects: ResourceStr[] = []
  private callback: (index: number, value?: string) => void
  private selectOption: SelectOption[] = []
  private name: ResourceStr
  private selectIndex: number
  private fontSize: Font = { size: 20, weight: FontWeight.Medium }
  private isItemStyle: boolean = true

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
        .backgroundColor($r("app.color.background_shallow_grey"))
        .borderRadius(19)
        .constraintSize({ minWidth: 150 })
        .selected(this.selectIndex)
        .font(this.fontSize)
        .optionFont(this.fontSize)
        .padding({ left: 20, right: 20, top: 8, bottom: 8 })
        .onSelect((index, value) => {
          this.callback(index, value)
          this.selectIndex = index
        })
    }
    .size({ width: '100%', height: this.isItemStyle ? 42 : 70 })
    .padding({ left: this.isItemStyle ? 0 : 12, right: this.isItemStyle ? 0 : 12 })
    .borderRadius(this.isItemStyle ? 0 : 24)
    .backgroundColor(this.isItemStyle ? Color.Transparent : Color.White)
  }
}

/**
 * Select Color
 *
 * @param color change color
 */
@Component
export struct CommonItemColorSelect {
  @Link selectColor: Resource
  @State selectIndex: number = 0
  private name: Resource
  private isItemStyle: boolean = true
  private colorNames: Array<{ value: Resource }> =
    [{ value: $r('app.string.divider_color_blue') }, { value: $r('app.string.divider_color_green') },
     { value: $r('app.string.divider_color_orange') }, { value: $r('app.string.divider_color_pink') }]

  changeResourceToString(resourceData:Resource){
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
        .backgroundColor($r("app.color.background_shallow_grey"))
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
    }
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
  @Link inputValue: string
  private name: Resource
  private placeholder?: ResourceStr = ''

  build() {
    Row() {
      Text(this.name)
        .margin({ left: 12, right: 12 })
      Blank()
      TextInput({ placeholder: this.placeholder })
        .size(TOOL_WIDTH)
        .onChange(value => {
          this.inputValue = value
        })
    }
    .size({ width: '100%', height: 70 })
    .padding({ left: 12, right: 12 })
    .borderRadius(24)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 12, bottom: 12 })
  }
}