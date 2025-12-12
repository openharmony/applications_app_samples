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
import { ReceiverFunctions } from '../utils/ReceiverFunctions'
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct ImageReceiver {
  @State message: number = 0;
  @State picture: image.Picture | null = null;
  @State returnMessage: string = 'No';
  private test = new ReceiverFunctions();

  build() {
    Row() {
      Column() {
        Text('请先初始化ImageReceiver，注册回调函数!')
        MyButton({ text: 'initImageReceiver', chooseFun: 'fun', fun: this.test.initImageReceiver})
        Text('点击takePhoto按钮，会触发回调，并获取image信息!')
        MyButton({ text: 'takePhoto', chooseFun: 'funGroup1',
          fun: this.test.takePhoto, fun4: this.test.getReceiverImageInfo})
        Text('资源释放后再进行其他操作会引起崩溃，请重新创建后再进行具体操作!')
        MyButton({ text: 'releaseImageReceiver', chooseFun: 'fun', fun: this.test.releaseImageReceiver})
        GotoButton({ text: 'back', dstUri: 'pages/Index'})
      }
      .width('100%')
      .height('100%')
    }
  }
}