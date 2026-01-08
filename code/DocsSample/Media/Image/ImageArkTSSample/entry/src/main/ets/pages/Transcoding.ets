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
import { reEncoding } from '../tools/TranscodingUtility'
import { common } from '@kit.AbilityKit';
import { UIComponentsBuilder } from '../tools/components';
import { Router } from '@ohos.arkui.UIContext';
import { PromptAction } from '@kit.ArkUI';

const router = new Router();
const uiComponents = new UIComponentsBuilder();
const promptAction = new PromptAction();
@Entry
@Component
struct Transcoding {
  @State message: string = 'Transcoding';
  @State context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  @State fd: number = 0;
  @State fileName: string = 'test.heic';

  build() {
    Column() {
      Text('将HEIF图片转码成JPEG图片示例')
        .margin('20')
      Button(this.message)
        .id('transcoding')
        .width('50%')
        .margin('20')
        .onClick(async () => {
          this.fileName = await uiComponents.switchFileName(this.context, 'HEIF');
          if (this.fileName == 'unknown') {
            promptAction.showToast({ message: '当前设备不支持heic解码！' });
            console.error('当前设备不支持heic解码！');
          } else {
            await uiComponents.pushSourceToBox(this.context, this.fileName);
            this.fd = uiComponents.getFileFd(this.context, this.fileName);
            await reEncoding(this.context, this.fd);
          }
        })
        .alignSelf(ItemAlign.Center)
      Button('back')
        .width('50%')
        .margin('20')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Index' });
        })
    }
    .height('100%')
    .width('100%')
  }
}