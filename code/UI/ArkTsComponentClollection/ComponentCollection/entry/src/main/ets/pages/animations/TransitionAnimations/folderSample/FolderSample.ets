/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';
import Folder from './Folder';

@Entry
@Component
struct FolderSample {
  @StorageProp('windowHeight') windowHeight: number = 720;
  @State isOpen: boolean = false;
  @State widthSize: number = 80;
  @State heightSize: number = 80;
  @State translateY: number = 0;

  click() {
    if (!this.isOpen) {
      this.widthSize = 280;
      this.heightSize = 280;
      this.translateY = this.windowHeight * 0.1;
    } else {
      this.widthSize = 80;
      this.heightSize = 80;
      this.translateY = 0;
    }
    animateTo({ duration: 500 }, () => {
      this.isOpen = !this.isOpen;
    });
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.Folder_expansion') })
      Column() {
        Folder({ isOpen: $isOpen })
          .id('folderComponent')
          .onClick(() => {
            this.click();
          })
          .width(this.widthSize)
          .height(this.heightSize)
          .translate({ y: this.translateY })
          .animation({
            duration: 500,
            curve: Curve.Linear,
            playMode: PlayMode.Normal
          })
      }
      .padding(20)
      .width('100%')
      .height('100%')
      .backgroundImageSize({
        height: '100%'
      })
      .backgroundImage($r('app.media.img_test_2'))
      .backdropBlur(this.isOpen ? 10 : 0)
      .onClick(() => {
        if (this.isOpen) {
          this.click();
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}