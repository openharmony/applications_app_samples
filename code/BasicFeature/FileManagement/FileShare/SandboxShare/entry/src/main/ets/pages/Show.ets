/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import fileFs from '../fileFs/fileFs';
import Logger from '../common/Logger';

const TAG = 'show';
@Entry
@Component
struct Show {
  @State myContext: Context = getContext(this) as common.UIAbilityContext;
  @State myFileName: string = router.getParams()['fileName'];
  @StorageLink('myFileSize') myFileSize: number = 0;
  @StorageLink('myFileContent') myFileContent: string = router.getParams()['fileContent'];
  @State path: string = router.getParams()['path'];
  @State opacityValue: number = 0.6;
  @State fileFs: fileFs = new fileFs();
  scroller: Scroller = new Scroller();

  onPageShow() {
    this.myFileContent = this.fileFs.getFileContent(this.path);
    this.myFileSize = fs.statSync(this.path).size;
  }

  aboutToDisappear() {

  }

  onPageHide() {

  }

  build() {
    Column() {
      // 第一行
      Row() {
        // 后退箭头
        Row() {
          Image($r('app.media.ic_back'))
            .focusable(true)
            .focusOnTouch(true)
            .width(25)
            .height(25)
            .id('back')
            .align(Alignment.Start)
            .onClick(() => {
              router.back();
            })
        }
        .margin({ right: '5%' })

        // 文件名及信息
        Column() {
          Row() { // 文件名
            Text(this.myFileName)
              .focusable(true)
              .focusOnTouch(true)
              .fontSize(20)
              .fontFamily('HarmonyHeiTi-Bold')
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
              .fontWeight(700)
              .lineHeight(28)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .align(Alignment.Start)
          .margin({ top: '0.4%', bottom: '0.3%' })
          .width('100%')

          Row() { // 文件大小
            Text('size: ' + JSON.stringify(this.myFileSize) + 'B')
              .focusable(true)
              .focusOnTouch(true)
              .opacity(0.6)
              .fontFamily('HarmonyHeiTi')
              .fontSize(14)
              .fontColor('#182431')
              .textAlign(TextAlign.Start)
              .lineHeight(19)
              .fontWeight(400)
          }
          .margin({ top: '0.3%', bottom: '0.5%' })
          .align(Alignment.Start)
          .width('100%')
        }
        .width('45%')

        // 右边两个图标
        Row() {
          Image($r('app.media.ic_refresh'))
            .focusable(true)
            .focusOnTouch(true)
            .width(25)
            .height(25)
            .margin({ right: '12%' })
            .id('refresh')
            .onClick(() => {
              let sta = fs.statSync(this.path);
              this.myFileSize = sta.size;
              this.myFileContent = this.fileFs.getFileContent(this.path);
              AppStorage.SetOrCreate('myFileSize', this.myFileSize);
              AppStorage.SetOrCreate('myFileContent', this.myFileContent);

              promptAction.showToast({ message: $r('app.string.refresh') });
            })

          Image($r('app.media.ic_share'))
            .focusable(true)
            .focusOnTouch(true)
            .width(25)
            .height(25)
            .id('share')
            .margin({ right: '5%' })
            .onClick(() => {
              let file = fs.openSync(this.path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
              let context = getContext(this);
              Logger.info(TAG, "context this "+ context);
              this.fileFs.implicitStartAbility(context, this.myFileName, this.myFileSize, file.fd, this.path);
            })
        }
        .height('100%')
        .width('50%')
        .padding({ right: '6%' })
        .justifyContent(FlexAlign.End)
      }
      .height('7.4%')
      .width('100%')


      Scroll(this.scroller) {
        // TextArea的行容器
        Row() {
          TextArea({ text: this.myFileContent })
            .id('textArea')
            .fontSize(16)
            .fontColor('#182431')
            .opacity(this.opacityValue)
            .fontWeight(400)
            .align(Alignment.Center)
            .textAlign(TextAlign.Start)
            .backgroundColor('#f1f3f5')
            .fontFamily('HarmonyHeiTi')
            .focusable(false)
            .focusOnTouch(true)
            .defaultFocus(false)
            .padding({
              top: 8,
              right: 0,
              left: 0,
              bottom: 8
            }) // 默认为top: 8 vp, right: 16 vp, bottom: 8 vp, left: 16 vp，需要更改
        }
        .padding({ top: 8 })
      }
      .margin({ top: 8 })
    }
    .backgroundColor('#f1f3f5')
    .height('100%')
    .width('100%')
    .padding({ left: '6.7%', right: '6.7%' })
  }
}