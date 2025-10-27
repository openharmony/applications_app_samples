/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF InputStyle KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BusinessError } from '@ohos.base';
import { KeyStyle, StyleConfiguration } from '../common/StyleConfiguration';
import { SubMenuType } from '../model/KeyboardKeyData';
import inputMethod from '@ohos.inputMethod';
import { util } from '@kit.ArkTS';
import { inputMethodEngine, InputMethodSubtype } from '@kit.IMEKit';
import App from '@system.app';

class Contact {
  public name: string;
  private icon: Resource;

  constructor(name: string, icon: Resource) {
    this.name = name;
    this.icon = icon;
  }
}

@Preview
@Component
export struct Submenu {
  @StorageLink('submenuType') submenuType: number = SubMenuType.NORMAL;
  @StorageLink('inputStyle') inputStyle: KeyStyle = StyleConfiguration.getSavedInputStyle();
  private contacts: Array<Contact> = []
  @State a: inputMethod.InputMethodProperty[] = []
  @State b: InputMethodSubtype[] = []
  @State currentInputMethodSubtype: string = '';

  async inputList() {
    this.a = await inputMethod.getSetting().getInputMethods(true); // 获取已使能的输入法列表
  }

  async typeList() {
    this.b = await inputMethod.getSetting().listCurrentInputMethodSubtype(); // 获取当前输入法的所有子类型
    this.currentInputMethodSubtype = inputMethod.getCurrentInputMethodSubtype().id;
    console.log('onPageShow11', JSON.stringify(this.b));
  }

  // [Start input_case_input_switchInputMethodgetInputMethods]
  async switchInputMethod(item: string) {
    this.a = await inputMethod.getSetting().getInputMethods(true); // 获取已使能的输入法列表
    let currentInputMethod = inputMethod.getCurrentInputMethod(); // 获取当前输入法
    console.log('onPageShow22', JSON.stringify(currentInputMethod));
    for (let i = 0; i < this.a.length; i++) {
      if (item != currentInputMethod.name) { // 判断不是当前输入法时，切换到该输入法，实际开发中可以切换到固定输入法
        await inputMethod.switchInputMethod(this.a[i]);
      }
    }
  }

  async switchCurrentInputMethodSubtype(item: InputMethodSubtype) {
    try {
      await inputMethod.switchCurrentInputMethodSubtype(item);
      this.currentInputMethodSubtype = inputMethod.getCurrentInputMethodSubtype().id;
      console.log('GJ switchCurrentInputMethodSubtype', JSON.stringify(item));
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      console.log('GJ switchCurrentInputMethodSubtype error', JSON.stringify(error));
    }
  }
  // [End input_case_input_switchInputMethodgetInputMethods]

  aboutToAppear(): void {
    this.inputList()
    this.typeList()
    console.log(JSON.stringify(inputMethod.getCurrentInputMethodSubtype()), 'haha1111')
  }

  build() {
    Grid() {
      GridItem() {
        Column() {
          Image($r('app.media.ic_edit'))
            .size({ width: this.inputStyle.editPicSize, height: this.inputStyle.editPicSize })
            .objectFit(ImageFit.Cover)
          Text($r('app.string.edit'))
            .fontColor($r('app.color.text_normal'))
            .fontSize(this.inputStyle.editFontSize)
            .opacity(0.6)
            .margin({ top: 8 })
        }
        .width('100%')
        .height('50%')
        .justifyContent(FlexAlign.Center)
        .id('btnEdit')
        .onClick(() => {
          this.submenuType = SubMenuType.EDIT;
        })
      }
      GridItem() {
        Column() {
          List() {
            ForEach(this.a, (item: Contact, index: number) => {
              ListItem() {
                Column() {
                  Row() {
                    if (item.name == inputMethod.getCurrentInputMethod().name) {
                      Image($r('app.media.ic_arrow_right'))
                        .width(40)
                        .height(40)
                        .margin(10)
                    } else {
                      Text()
                        .width(40)
                        .height(40)
                        .margin(10)
                    }
                    Text(item.name).fontSize(20)
                      .onClick(() => {
                        this.switchInputMethod(item.name)
                      })
                  }
                  if (this.a[index].name == inputMethod.getCurrentInputMethod().name) {
                    List() {
                      ForEach(this.b, (item: InputMethodSubtype) => {
                        ListItem() {
                          Row() {
                            Text(item.locale).fontSize(20)
                            Blank()
                            if (item.id == this.currentInputMethodSubtype) {
                              Image($r('app.media.ic_cursor_left'))
                                .width(40)
                                .height(40)
                                .margin(10)
                            }
                          }
                          .width('90%')
                          .height(35)
                          .justifyContent(FlexAlign.Start)
                          .onClick(() => {
                            this.switchCurrentInputMethodSubtype(item)
                          })
                        }
                      })
                    }
                    .width('90%')
                    .margin({left: '10%'})
                    .divider({color: '#000000', strokeWidth: 1})
                  }
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
              }
            }, (item: Contact) => JSON.stringify(item))
          }
          .width('100%')
        }
        .width('350%')
        .height('100%')
        .id('btnEdit')
      }
    }
    .width('100%')
    .height('100%')
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(12)
    .rowsGap(12)
    .backgroundColor('#F1F3F5')
  }
}