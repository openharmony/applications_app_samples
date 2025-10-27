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

import player from 'libplayer.so';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


@Entry
@Component
struct Index {
  private pathStack: NavPathStack = new NavPathStack();

  @Builder
  NavigationTitle() {
    Column() {
      Text($r('app.string.title'))
        .width(328)
        .height(40)
        .margin({ left: '16' })
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
    }.alignItems(HorizontalAlign.Start)
  }
  aboutToDisappear(): void {
    player.stopNative();
  }

  @State message: string = 'Hello World';
  private resourceManager: resourceManager.ResourceManager | undefined;

  aboutToAppear(): void {
    try {
      this.resourceManager = this.getUIContext().getHostContext()?.resourceManager;
      let path = this.getUIContext().getHostContext()?.filesDir + '/rawfile';
      if (!fs.accessSync(path)) {
        fs.mkdirSync(path);
      }
      let buffer = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync('shaders/vert.spv');
      let file = fs.openSync(path + '/vert.spv', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      if (buffer != null) {
        fs.writeSync(file.fd, buffer.buffer);
      }
      buffer = this.getUIContext().getHostContext()?.resourceManager.getRawFileContentSync('shaders/frag.spv');
      file = fs.openSync(path + '/frag.spv', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      if (buffer != null) {
        fs.writeSync(file.fd, buffer.buffer);
      }
    } catch (error) {
      hilog.info(0x0000,'testTag','%{public}s','write file error');
    }
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          Row() {
            XComponent({
              id: 'Vulkan',
              type: XComponentType.SURFACE,
              libraryname: 'player'
            })
              .height(200)
              .width('100%')
          }
        }
        .width('100%')

        Blank()
        Column() {
          Button($r('app.string.play'))
            .onClick(() => {
              if (this.resourceManager) {
                this.resourceManager.getRawFd('sample.mp4',
                  (error: BusinessError, value: resourceManager.RawFileDescriptor) => {
                    if (error != null) {
                      console.error(`callback getRawFd failed error code: ${error.code}, message: ${error.message}.`);
                      return;
                    }
                    player.playNative(value.fd, value.offset, value.length, 'Vulkan');
                  });
              }
            })
            .size({
              width: '100%',
            })
        }
        .padding({ left: 16, right: 16, bottom: 16 })
        .width('100%')
        .justifyContent(FlexAlign.End)
      }
      .height('100%')
      .width('100%')
    }
    .title($r('app.string.vulkan_title'))
  }
}
