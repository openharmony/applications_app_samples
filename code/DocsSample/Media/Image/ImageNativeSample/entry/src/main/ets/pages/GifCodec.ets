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

@Entry
@Component
struct GifCodec {
  @State message: number = 0;
  @State picture: image.Picture | null = null;
  @State returnMessage: string = 'No';
  @State gifName: string = 'test.gif';
  private test = new SourceFunctions();
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;

  build() {
    Row() {
      Column() {
        Text('请先创建ImageSource!')
        MyButton({ text: 'CreateAnimatedImageSource', context: this.context,  fileName: this.gifName,
          chooseFun: 'fun1', fun1: this.test.createAnimatedImageSource })
        MyButton({ text: 'GetAnimatedFrameCount', chooseFun: 'fun', fun: this.test.getAnimatedFrameCount })
        MyButton({ text: 'GetAnimatedDelayTimeList', chooseFun: 'funGroup1', fun: this.test.getAnimatedFrameCount,
          fun4: this.test.getAnimatedDelayTimeList })
        MyButton({ text: 'CreateAnimatedPixelmapList', chooseFun: 'funGroup1', fun: this.test.getAnimatedFrameCount,
          fun4: this.test.createAnimatedPixelmapList })
        MyButton({ text: 'CreateAnimatedPixelmapByIndex', chooseFun: 'fun',
          fun: () => this.test.createAnimatedPixelmapByIndex(0) })
        Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
        MyButton({ text: 'ReleaseAnimatedImageSource', chooseFun: 'fun', fun: this.test.releaseAnimatedImageSource })
        GotoButton({ text: 'back', dstUri: 'pages/Index'})
      }
      .width('100%')
      .height('100%')
    }
  }
}