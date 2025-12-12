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
import { PictureFunctions } from '../utils/PictureFunctions';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct PictureCodec {
  @State message: number = 0;
  @State picture: image.Picture | null = null;
  @State returnMessage: string = 'No';
  @State fileName: string = 'allAux.jpg';
  @State packFileName: string = 'packToFileFromPicture.jpg';
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private test = new PictureFunctions();

  build() {
    Row() {
      Column() {
        Text('请先配置解码参数，再进行解码!')
        MyButton({ text: 'SetDesiredAuxiliaryPictures', fun: this.test.setDesiredAuxiliaryPictures })
        MyButton({ text: 'CreatePictureByImageSource', context: this.context, fileName: this.fileName,
          chooseFun: 'fun1', fun1: this.test.createPictureByImageSource })
        MyButton({ text: 'packToDataFromPicture', fun: this.test.packToDataFromPicture })
        MyButton({ text: 'packToFileFromPicture', context: this.context, fileName: this.packFileName,
          chooseFun: 'fun5', fun5: this.test.packToFileFromPicture })
        Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
        MyButton({ text: 'ReleasePictureSource', fun: this.test.releasePictureSource })
        GotoButton({ text: 'back', dstUri: 'pages/Index'})
      }
      .width('%100')
      .height('%100')
    }
  }
}
