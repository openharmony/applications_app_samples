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
import { GotoButton, MyButton } from '../utils/MyButton';
import { HdrColorSpaceFunctions } from '../utils/HdrColorSpaceFunctions';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct HdrColorSpaceCodec {
  @State fileName: string = 'allAux.jpg';
  @State packFileName: string = 'packHdrPixelMap.jpg';
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private test = new HdrColorSpaceFunctions();

  build() {
    Row() {
      Column() {
        Text('请先创建ImageSource!')
        MyButton({ text: 'CreateHdrImageSource', context: this.context, fileName: this.fileName,
          chooseFun: 'fun1', fun1: this.test.createHdrImageSource })
        MyButton({ text: 'DecodeHdrPixelMap', chooseFun: 'fun', fun: this.test.decodeHdrPixelMap })
        MyButton({ text: 'CheckHdrDynamicRange', chooseFun: 'fun', fun: this.test.checkHdrDynamicRange })
        MyButton({ text: 'DecodeSdrPixelMap', chooseFun: 'fun', fun: this.test.decodeSdrPixelMap })
        MyButton({ text: 'DecodeHdrPicture', chooseFun: 'fun', fun: this.test.decodeHdrPicture })
        MyButton({ text: 'GetMainPixelmapFromPicture', chooseFun: 'fun', fun: this.test.getMainPixelmapFromPicture })
        MyButton({ text: 'GetGainmapPixelmapFromPicture', chooseFun: 'fun', fun: this.test.getGainmapPixelmapFromPicture })
        MyButton({ text: 'GetHdrComposedPixelmapFromPicture', chooseFun: 'fun',
          fun: this.test.getHdrComposedPixelmapFromPicture })
        MyButton({ text: 'PackHdrPixelMap', context: this.context, fileName: this.packFileName,
          chooseFun: 'fun5', fun5: this.test.packHdrPixelMap })
        Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
        MyButton({ text: 'ReleaseHdrColorSpaceSource', chooseFun: 'fun', fun: this.test.releaseHdrColorSpaceSource })
        GotoButton({ text: 'back', dstUri: 'pages/Index'})
      }
      .width('100%')
      .height('100%')
    }
  }
}