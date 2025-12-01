/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { ImageInterfaceCalled } from '../tools/CodecUtility';
import { ExifUtility } from '../tools/ExifUtility';
import { UIComponentsBuilder } from '../tools/components';
import {Router} from '@ohos.arkui.UIContext';

const router = new Router();
// 创建 UIComponentsBuilder 实例
const uiComponents = new UIComponentsBuilder();
let fileName: string = 'allAux.jpg'; // 根据解码需求选择不同的解码资源进行解码

@Entry
@Component
struct EditExif {
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State imageSource: image.ImageSource | undefined = undefined;
  @State modifySource: image.ImageSource | undefined = undefined;
  @State imageInterfaceCalled: ImageInterfaceCalled = new ImageInterfaceCalled();
  @State exifUtility: ExifUtility = new ExifUtility();
  @State info: string = '';
  @State propertyKey: image.PropertyKey = image.PropertyKey.BITS_PER_SAMPLE;
  @State value: string = '';
  @State visible: Visibility = Visibility.Hidden;
  @State isOpen: boolean = false;
  @State keyOptions: image.PropertyKey[] = [
    image.PropertyKey.ROLL_ANGLE,
    image.PropertyKey.GPS_LATITUDE,
    image.PropertyKey.EXPOSURE_TIME,
    image.PropertyKey.GPS_LONGITUDE,
    image.PropertyKey.LENS_MAKE,
    image.PropertyKey.MAKER_NOTE,
    image.PropertyKey.USER_COMMENT,
    image.PropertyKey.FOCUS_MODE,
    image.PropertyKey.PHOTOGRAPHIC_SENSITIVITY,
    image.PropertyKey.EXPOSURE_TIME,
    image.PropertyKey.F_NUMBER
  ];
  // 实际调用释放资源接口
  releaseActual() {
    this.imageSource?.release();
    this.imageSource = undefined;
    this.modifySource?.release();
    this.modifySource = undefined;
  }

  build() {
    Column() {
      Row() {
        Column() {
          Button('指定propertyKey值').onClick(async () => {
            this.isOpen = !this.isOpen;
            this.visible = Visibility.Hidden;
          })
            .width('50%')
            .margin(10)

          if (this.isOpen) {
            Column() {
              ForEach(this.keyOptions, (item: image.PropertyKey) => {
                Text(item).onClick(async () => {
                  this.propertyKey = item;
                  this.isOpen = !this.isOpen;
                })
                  .border({width: 1, color: Color.Blue})
                  .width('100%')
                  .padding(10)
                  .zIndex(999) // 设置 z-index 确保按钮显示在上层
              })
            }
            .margin({top: 5})
            .width('100%')
            .height('100%')
            .backgroundColor(Color.Pink)
            .border({width: 1, color: Color.Blue})
          }
          Text('输入指定property的key值')
          TextInput()
            .onChange((value: string)=> {
              this.value = value;
            })
            .id('valueInput')
          Button('获取Exif信息').onClick(async () => {
            this.visible = Visibility.Hidden;
            this.releaseActual();
            await uiComponents.pushSourceToBox(this.context, fileName);
            this.imageSource = this.imageInterfaceCalled.createImageSourceByFd(this.context, fileName);
            this.info = await this.exifUtility.getExif(this.imageSource, this.propertyKey);
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
          Button('修改Exif信息').onClick(async () => {
            this.visible = Visibility.Hidden;
            this.releaseActual();
            await uiComponents.pushSourceToBox(this.context, fileName);
            this.modifySource = this.imageInterfaceCalled.createImageSourceByFd(this.context, fileName);
            this.info = await this.exifUtility.modifyExif(this.modifySource, this.propertyKey, this.value);
            this.visible = Visibility.Visible;
          })
            .width('50%')
            .margin(10)
          Button('资源释放').onClick(async () => {
            this.releaseActual();
            this.visible = Visibility.Hidden;
          })
            .width('50%')
            .margin(10)
          Button('back')
            .width('50%')
            .margin(10)
            .onClick(() => {
              router.pushUrl({ url: 'pages/Index' });
            })
            .width('50%')
            .margin(10)
        }
        .width('100%')
        .height('100%')
        .margin(10)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('60%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      Text(this.info)
        .fontSize(25)
        .width('80%')
        .visibility(this.visible)
        .border({width: 1, color: Color.Red})
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
