/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { keySourceListData, numberSourceListData, symbolSourceListData, keySourceListType, sourceListType
} from '../model/keyboardKeyData'
import { InputHandler } from '../model/KeyboardController'
import styleConfiguration from '../common/styleConfiguration'
import Log from '../model/Log'
import deviceInfo from '@ohos.deviceInfo'

let deviceType = deviceInfo.deviceType
let TAG: string = 'index->'
//有大小写的按键组件
@Component
struct keyItemNumber {
  private keyValue: keySourceListType
  @Link inputStyle: any
  @Link upper: number

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      if (this.inputStyle.deviceType == 'phone_landSpace') {
        Stack({ alignContent: Alignment.TopEnd }) {
          Text(this.upper === 0 ? this.keyValue.content : this.keyValue.upperContent)
            .fontSize(this.inputStyle.en_fontSize)
            .fontColor('#000')
            .fontWeight(FontWeight.Regular)
            .width('100%')
            .height('100%')
            .textAlign(TextAlign.Center)
          Text(this.keyValue.title)
            .fontSize(this.inputStyle.litterNumberFontSize)
            .fontColor('#000')
            .fontWeight(FontWeight.Regular)
            .width('12vp')
            .height('12vp')
            .textAlign(TextAlign.Center)
            .margin({ top: 1, right: 1 })
        }
        .width('100%')
        .height('100%')
      } else {
        Text(this.keyValue.title)
          .fontSize(this.inputStyle.litterNumberFontSize)
          .fontColor('#606060')
          .fontWeight(FontWeight.Regular)
          .margin({ top: 4 })
        Text(this.upper === 0 ? this.keyValue.content : this.keyValue.upperContent)
          .fontSize(this.inputStyle.en_fontSize)
          .fontColor('#000')
          .fontWeight(FontWeight.Regular)
      }
    }
    .backgroundColor('#ffffff')
    .borderRadius(4)
    .onClick(() => {
      if (this.upper === 0) {
        InputHandler.getInstance().insertText(this.keyValue.content);
      } else {
        if (this.upper === 1) {
          this.upper = 0
        }
        InputHandler.getInstance().insertText(this.keyValue.upperContent);
      }
    })
    .width(this.inputStyle.basicButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//无大小写的按键组件
@Component
struct keyItem {
  private keyValue: keySourceListType
  private color: string
  @Link inputStyle: any
  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.keyValue.content)
        .fontSize(this.inputStyle.symbol_fontSize)
        .fontColor('#000')
    }
    .backgroundColor('#fff')
    .borderRadius(4)
    .width(this.inputStyle.basicButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .padding({ top: '5%', bottom: '5%' })
    .onClick(() => {
      InputHandler.getInstance().insertText(this.keyValue.content);
    })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//无大小写的灰色组件
@Component
struct keyItemGray {
  private keyValue: string
  @Link inputStyle: any
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Stack() {
      Text(this.keyValue).fontSize(this.inputStyle.switchNumberFontSize).fontColor('black')
    }
    .backgroundColor('#a8abb7')
    .borderRadius(4)
    .onClick(() => {
      if (this.keyValue === "?123") {
        this.menuType = 1
      } else if (this.keyValue === "=/\<") {
        this.menuType = 2
      } else if (this.keyValue === 'ABC') {
        this.menuType = 0
      }
    })
    .height('100%')
    .width(this.inputStyle.switchButtonWidth)
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//删除组件
@Component
struct deleteItem {
  @Link inputStyle: any
  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Stack() {
      Image($rawfile('delete.svg'))
        .width(this.inputStyle.featurePicSize)
        .height(this.inputStyle.featurePicSize)
    }
    .backgroundColor('#a8abb7')
    .borderRadius(4)
    .onClick(() => {
      InputHandler.getInstance().deleteBackward(1);
    })
    .width(this.inputStyle.switchButtonWidth)
    .height('100%')
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//返回组件
@Component
struct returnItem {
  private returnWidth: any
  @Link inputStyle: any
  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Stack() {
      Image($rawfile('return.svg'))
        .width(this.inputStyle.returnPicSize)
        .height(this.inputStyle.returnPicSize)
    }
    .backgroundColor('#a8abb7')
    .width(this.returnWidth)
    .borderRadius(4)
    .height('100%')
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .onClick(() => {
      InputHandler.getInstance().sendKeyFunction();
    })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//空格组件
@Component
struct spaceItem {
  private spaceWith: any
  @Link inputStyle: any
  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Stack() {
      Text('space')
        .fontSize(this.inputStyle.symbol_fontSize)
        .fontColor('black')
    }
    .backgroundColor('#ffffff')
    .width(this.spaceWith)
    .borderRadius(4)
    .height('100%')
    .onClick(() => {
      InputHandler.getInstance().insertText(' ');
    })
    .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
    .stateStyles({
      normal: this.normalStyles, pressed: this.pressedStyles
    })
  }
}

//key键盘
@Component
struct keyMenu {
  private keyList: keySourceListType[]
  @Link inputStyle: any
  @State public upper: number = 0
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#868b95")
  }

  @Styles normalStyles() {
    .backgroundColor("#a8abb7")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.keyList.slice(0, 10), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper, inputStyle: $inputStyle })
        }, (item: keySourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Stack() {
        }.width('4%').height(0)

        ForEach(this.keyList.slice(10, 19), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper, inputStyle: $inputStyle })
        }, (item: keySourceListType) => item.content)
        Stack() {
        }.width('4%').height(0)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Stack() {
          Image($rawfile(this.upper === 1 ? 'shift light.svg' : this.upper === 2 ? 'shift light long.svg' : 'shift.svg'))
            .width(this.inputStyle.featurePicSize)
            .height(this.inputStyle.featurePicSize)
        }
        .backgroundColor('#a8abb7')
        .borderRadius(4)
        .onClick(() => {
          if (this.upper === 0) {
            this.upper = 1
          } else if (this.upper === 1) {
            this.upper = 2
          } else if (this.upper === 2) {
            this.upper = 0
          }
        })
        .height('100%')
        .width(this.inputStyle.switchButtonWidth)
        .shadow({ radius: 1, color: '#76787c', offsetY: 3 })
        .stateStyles({
          normal: this.normalStyles, pressed: this.pressedStyles
        })


        ForEach(this.keyList.slice(19), (item: keySourceListType) => {
          keyItemNumber({ keyValue: item, upper: $upper, inputStyle: $inputStyle })
        }, (item: keySourceListType) => item.content)
        deleteItem({ inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: '?123', menuType: $menuType, inputStyle: $inputStyle })
        keyItem({
          keyValue: { content: ',', title: ',', upperContent: ',' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        spaceItem({ spaceWith: this.inputStyle.spaceButtonWidth_1, inputStyle: $inputStyle })

        keyItem({
          keyValue: { content: '.', title: '.', upperContent: '.' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        returnItem({ returnWidth: this.inputStyle.returnButtonWidthType_1, inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

    }
    .width('100%')
    .height('100%')
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    })
  }
}

//数字键盘
@Component
struct numberMenu {
  private numberList: sourceListType[]
  @Link inputStyle: any
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.numberList.slice(0, 10), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff',
            inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.numberList.slice(10, 20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff',
            inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: '=/\<', menuType: $menuType, inputStyle: $inputStyle })
        ForEach(this.numberList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff',
            inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
        deleteItem({ inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: 'ABC', menuType: $menuType, inputStyle: $inputStyle })
        keyItem({
          keyValue: { content: '_', title: '_', upperContent: '_' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        keyItem({
          keyValue: { content: ',', title: ',', upperContent: ',' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })

        spaceItem({ spaceWith: this.inputStyle.spaceButtonWidth_2, inputStyle: $inputStyle })
        keyItem({
          keyValue: { content: '.', title: '.', upperContent: '.' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        returnItem({ returnWidth: this.inputStyle.returnButtonWidthType_2, inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })
    }
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    })
  }
}

//符号键盘
@Component
struct symbolMenu {
  private symbolList: sourceListType[]
  @Link inputStyle: any
  @Link menuType: number

  @Styles pressedStyles() {
    .backgroundColor("#AEB3BD")
  }

  @Styles normalStyles() {
    .backgroundColor("#ffffff")
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(0, 10), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff', inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        ForEach(this.symbolList.slice(10, 20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff', inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: '?123', menuType: $menuType, inputStyle: $inputStyle })
        ForEach(this.symbolList.slice(20), (item: sourceListType) => {
          keyItem({
            keyValue: { content: item.content, title: item.content, upperContent: item.content },
            color: '#ffffff', inputStyle: $inputStyle
          })
        }, (item: sourceListType) => item.content)
        deleteItem({ inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })


      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        keyItemGray({ keyValue: 'ABC', menuType: $menuType, inputStyle: $inputStyle })
        keyItem({
          keyValue: { content: '<', title: '<', upperContent: '<' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        keyItem({
          keyValue: { content: '>', title: '>', upperContent: '>' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        spaceItem({ spaceWith: this.inputStyle.spaceButtonWidth_2, inputStyle: $inputStyle })
        keyItem({
          keyValue: { content: '.', title: '.', upperContent: '.' },
          color: '#a8abb7',
          inputStyle: $inputStyle
        })
        returnItem({ returnWidth: this.inputStyle.returnButtonWidthType_2, inputStyle: $inputStyle })
      }
      .width('100%')
      .height(this.inputStyle.basicButtonHeight)
      .margin({ top: this.inputStyle.paddingTop })
    }
    .padding({
      left: this.inputStyle.paddingLeftRight,
      right: this.inputStyle.paddingLeftRight
    })
  }
}

//下拉按钮
@Component
struct downMenu {
  @Link inputStyle: any
  build() {
    Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
      Stack() {
        Image($rawfile('down.svg'))
          .width(this.inputStyle.downMenuPicWidth)
          .height(this.inputStyle.downMenuPicHeight)
          .onClick(() => {
            InputHandler.getInstance().hideKeyboardSelf();
          })
      }
      .width(this.inputStyle.downMenuWidth)
      .borderRadius(4)
      .height('100%')
    }
    .width('100%')
    .height(this.inputStyle.downMenuHeight)
    .padding(1)
    .backgroundColor('#ffffff')
    .borderColor('#33000000')
    .borderWidth(0.5)
  }
}

@Entry
@Component
struct Index {
  private keyList: keySourceListType[]= keySourceListData
  private numberList: sourceListType[]= numberSourceListData
  private symbolList: sourceListType[]= symbolSourceListData
  @State menuType: number= 0
  @StorageLink('isLandscape') @Watch('change') isLandscape: boolean = false
  @StorageLink('isRkDevice') isRkDevice: boolean = false;
  @StorageLink('inputStyle')  inputStyle: any = styleConfiguration.getInputStyle(this.isLandscape, this.isRkDevice, deviceType);
  onBackPress(): boolean{
    Log.showInfo(TAG, 'kikaInput onBackPress');
    InputHandler.getInstance().hideKeyboardSelf();
    return true;
  }

  change() {
    AppStorage.Set('inputStyle', styleConfiguration.getInputStyle(this.isLandscape, this.isRkDevice, deviceType))
  }
  build() {
    Stack() {
      Column() {
        downMenu({ inputStyle: $inputStyle })
        Column() {
          if (this.menuType === 0) {
            keyMenu({
              keyList: this.keyList,
              menuType: $menuType,
              inputStyle: $inputStyle
            })
          } else if (this.menuType === 1) {
            numberMenu({
              numberList: this.numberList,
              menuType: $menuType,
              inputStyle: $inputStyle })
          } else {
            symbolMenu({
              symbolList: this.symbolList,
              menuType: $menuType,
              inputStyle: $inputStyle })
          }

        }.width('100%')
        .height(this.inputStyle.keyboardHeight)
        .backgroundColor('#D5D7DD')
      }.height('100%')
    }
  }
}