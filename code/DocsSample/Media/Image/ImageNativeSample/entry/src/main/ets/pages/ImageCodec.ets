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
import { MyButton } from '../utils/MyButton'
import { SourceFunctions } from '../utils/SourceFunctions'
import { common } from '@kit.AbilityKit';
import { GotoButton } from '../utils/MyButton'

@Entry
@Component
struct ImageCodec {
  @State message: number = 0;
  @State picture: image.Picture | null = null;
  @State returnMessage: string = 'No';
  @State fileName: string = 'test.jpeg';
  @State gifName: string = 'test.gif';
  @State packSourceName: string = 'packToFileFromImageSource.jpg';
  @State packPixelName: string = 'packToFileFromPixelMap.jpg';
  private test = new SourceFunctions();
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State isOpen: boolean = false;
  @State propertyKey: image.PropertyKey = image.PropertyKey.F_NUMBER;
  @State value: string = '';
  @State keyOptions: image.PropertyKey[] = [
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

  build() {
    Row() {
      Column() {
        Text('请先创建ImageSource!')
        MyButton({ text: 'CreateImageSource', context: this.context,  fileName: this.fileName,
          chooseFun: 'fun1', fun1: this.test.createImageSource})
        MyButton({ text: 'packToFileFromImageSource', context: this.context,  fileName: this.packSourceName,
          chooseFun: 'fun5', fun5: this.test.packToFileFromImageSourceTestJs})
        MyButton({ text: 'GetImageInfo', chooseFun: 'fun', fun: this.test.getImageInfo})
        MyButton({ text: 'createPixelMap', chooseFun: 'fun', fun: this.test.createPixelMap})
        MyButton({ text: 'packToFileFromPixelmap', context: this.context,  fileName: this.packPixelName,
          chooseFun: 'fun5', fun5: this.test.packToFileFromPixelmapTestJs})
        MyButton({ text: 'CreatePixelmapUsingAllocator', context: this.context, fileName: this.fileName,
          chooseFun: 'fun1', fun1: this.test.createPixelmapUsingAllocator })
        Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
        MyButton({ text: 'ReleaseImageSource', chooseFun: 'fun', fun: this.test.releaseImageSource })
        GotoButton({ text: 'back', dstUri: 'pages/Index'})
      }
      .width('100%')
      .height('100%')
    }
  }
}