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

import {Scene1} from './Scene1';
import {Scene2} from './Scene2';
import {Scene3} from './Scene3';

class DividerTmp {
  strokeWidth: Length = 1;
  startMargin: Length = 60;
  endMargin: Length = 10;
  color: ResourceColor = '#ffe9f0f0';

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth;
    this.startMargin = startMargin;
    this.endMargin = endMargin;
    this.color = color;
  }
}

@Entry({ routeName : 'Index' })
@Component
struct Index {
  @Provide('NavPathStack') pageInfos: NavPathStack = new NavPathStack();
  @State egDivider: DividerTmp = new DividerTmp(1, 60, 10, '#ffe9f0f0');

  @Builder
  PagesMap(name: string) {
    if (name == 'Scene1') {
      Scene1();
    } else if (name == 'Scene2') {
      Scene2();
    } else if (name == 'Scene3') {
      Scene3();
    }
  }

  build() {
    Column({ space: 15 }) {
      Navigation(this.pageInfos) {
        List({ space: 12 }) {
          ListItem() {
            Text('Media Library Kit Examples')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
          }

          ListItem() {
            Text('Get Supported Formats')
              .fontSize(18)
              .fontColor('#666666')
          }
          ListItem() {
            Button('Get Supported Photo Formats')
              .width('80%')
              .onClick(() => {
                this.pageInfos.pushPathByName('Scene1', '');
              })
          }

          ListItem() {
            Text('Save Media Assets')
              .fontSize(18)
              .fontColor('#666666')
              .margin({ top: 20 })
          }
          ListItem() {
            Button('Save with SaveButton Component')
              .width('80%')
              .onClick(() => {
                this.pageInfos.pushPathByName('Scene2', '');
              })
          }

          ListItem() {
            Button('Save with Authorization Dialog')
              .width('80%')
              .onClick(() => {
                this.pageInfos.pushPathByName('Scene3', '');
              })
          }
        }
        .width('100%')
        .margin({ top: 12 })
        .alignListItem(ListItemAlign.Center)
        .divider(this.egDivider)
      }
      .mode(NavigationMode.Stack)
      .title('Media Library Samples')
      .titleMode(NavigationTitleMode.Full)
      .navDestination(this.PagesMap)
    }
    .height('100%')
  }
}