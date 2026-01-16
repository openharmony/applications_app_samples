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
import { image } from '@kit.ImageKit';
import { GotoButton, MyButton } from '../utils/MyButton'
import { SourceFunctions } from '../utils/SourceFunctions'
import { common } from '@kit.AbilityKit';
import { PromptAction } from '@kit.ArkUI';

@Entry
@Component
struct EditExif {
  @State message: string = 'loading...';
  @State picture: image.Picture | null = null;
  @State returnMessage: string = 'No';
  @State fileName: string = 'test.jpeg';
  private test = new SourceFunctions();
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State isOpen: boolean = false;
  @State propertyKey: image.PropertyKey = image.PropertyKey.F_NUMBER;
  @State value: string = '23';
  @State keyOptions: image.PropertyKey[] = [
    image.PropertyKey.ORIENTATION,
    image.PropertyKey.ROLL_ANGLE,
    image.PropertyKey.GPS_LATITUDE,
    image.PropertyKey.EXPOSURE_TIME,
    image.PropertyKey.GPS_LONGITUDE,
    image.PropertyKey.MAKER_NOTE,
    image.PropertyKey.FOCUS_MODE,
    image.PropertyKey.PHOTOGRAPHIC_SENSITIVITY,
    image.PropertyKey.EXPOSURE_TIME,
    image.PropertyKey.F_NUMBER
  ];
  @State promptAction: PromptAction = this.getUIContext().getPromptAction();

  build() {
    Row() {
      Column() {
        Text('请先创建ImageSource!')
        MyButton({ text: 'CreateImageSource', context: this.context,  fileName: this.fileName,
          chooseFun: 'fun1', fun1: this.test.createImageSource})
        Button('ChoosePropertyKey')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 20,
            font: {
              size: 20,
              weight: FontWeight.Bolder,
              family: 'cursive',
              style: FontStyle.Italic
            }
          })
          .margin({ top: 5 })
          .onClick(() => {
            this.isOpen = !this.isOpen;
          })
        Blank().height(20);
        Divider();
        if (this.isOpen) {
          Column() {
            ForEach(this.keyOptions, (item: image.PropertyKey) => {
              Text(item)
                .onClick(() => {
                  this.propertyKey = item;
                  this.isOpen = !this.isOpen;
                })
                .border({ width: 1, color: Color.Blue })
                .width('100%')
                .padding(10)
                .zIndex(999)
            })
          }
          .margin({ top: 5 })
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Pink)
          .border({ width: 1, color: Color.Blue })
        }
        Button('GetImageProperty')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 20,
            font: {
              size: 20,
              weight: FontWeight.Bolder,
              family: 'cursive',
              style: FontStyle.Italic
            }
          })
          .margin({ top: 5 })
          .onClick(() => {
            this.message = this.test.getImageProperty(this.propertyKey);
            this.promptAction.showToast({ message: this.message });
          })
        Blank().height(20);
        Divider();
        Text('输入指定property的key值')
          .margin({ top: 5 })
        TextInput()
          .onChange((value: string) => {
            this.value = value;
            console.log(`this.value ${this.value}`);
          })
          .margin({ top: 5 })
          .id('valueInput')
        Button('ModifyImageProperty')
          .labelStyle({
            overflow: TextOverflow.Clip,
            maxLines: 2,
            minFontSize: 20,
            maxFontSize: 20,
            font: {
              size: 20,
              weight: FontWeight.Bolder,
              family: 'cursive',
              style: FontStyle.Italic
            }
          })
          .margin({ top: 5 })
          .onClick(() => {
            this.message = this.test.modifyImageProperty(this.propertyKey, this.value);
            this.promptAction.showToast({ message: this.message });
          })
        Blank().height(20);
        Divider();
        Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
        MyButton({ text: 'ReleaseImageSource', chooseFun: 'fun', fun: this.test.releaseImageSource })
        GotoButton({ text: 'back', dstUri: 'pages/Index'})
      }
      .width('100%')
      .height('100%')
    }
  }
}