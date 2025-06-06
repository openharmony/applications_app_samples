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

import router from '@ohos.router';

@Component
export struct MenuSCComponent {
  @State select: boolean = true
  @Builder
  MyMenu(){
    Menu() {
      MenuItemGroup({ header: $r('app.string.list_desc') }) {
        MenuItem({ content: $r('app.string.index_desc') })
          .onChange((selected) => {
            console.info('menuItem select' + selected);
            router.pushUrl({
              url: 'pages/Index' // 目标url
            }, router.RouterMode.Single, (err) => {
              if (err) {
                console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.');
            });
          })

        MenuItem({ content: $r('app.string.saving_file_desc') })
          .onChange((selected) => {
            router.pushUrl({
              url: 'pages/Scene1' // 目标url
            }, router.RouterMode.Single, (err) => {
              if (err) {
                console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.');
            });
          })

        MenuItem({ content: $r('app.string.streaming_desc') })
          .onChange((selected) => {
            router.pushUrl({
              url: 'pages/Scene2' // 目标url
            }, router.RouterMode.Single, (err) => {
              if (err) {
                console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                return;
              }
              console.info('Invoke pushUrl succeeded.');
            });
          })

        MenuItem({ content: $r('app.string.streaming_surface_mode_desc')})
          .onChange((selected) => {
          router.pushUrl({
            url: 'pages/Scene3' // 目标url
          }, router.RouterMode.Single, (err) => {
            if (err) {
              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Invoke pushUrl succeeded.');
          });
        })

        MenuItem({ content: $r('app.string.js_saving_file_desc')})
          .onChange((selected) => {
          router.pushUrl({
            url: 'pages/Scene4' // 目标url
          }, router.RouterMode.Single, (err) => {
            if (err) {
              console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
              return;
            }
            console.info('Invoke pushUrl succeeded.');
          });
        })
      }
    }
  }

  build() {
        Button($r('app.string.choose_mode_desc'), { type: ButtonType.Capsule, stateEffect: true })
          .fontSize(25)
          .backgroundColor(0x317aff)
          .fontWeight(800)
          .bindMenu(this.MyMenu)
        }
 }