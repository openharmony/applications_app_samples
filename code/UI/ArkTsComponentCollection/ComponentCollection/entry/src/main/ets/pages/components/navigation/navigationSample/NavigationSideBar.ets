/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import router from '@ohos.router';

@Entry
@Component
struct NavigationSideBar {
  navarray: number[] = [1, 2, 3];
  contentarray: number[] = [1, 2, 3, 4];
  @State expand: boolean = false;
  @State selectnav: number = -1;

  build() {
    Column() {
      Navigation() {
        TitleBar({ title: $r('app.string.navigation_sidebar_title') })
        Column() {
          ForEach(this.navarray, (navidx: number) => {
            NavRouter() {
              Row() {
                Text($r('app.string.navigation_navbar_list', navidx))
                  .fontSize(16)
                Blank()
                Image($r('app.media.ic_right_arrow'))
                  .objectFit(ImageFit.ScaleDown)
                  .height(22)
              }
              .height(48)
              .padding(13)
              .width('90%')
              .borderRadius(24)
              .backgroundColor(this.selectnav === navidx ? 0x007DFF : Color.Transparent)
              .id(`nav${navidx}`)

              NavDestination() {
                Row() {
                  Image($r('app.media.ic_back'))
                    .width(20)
                    .height(20)
                    .margin({ left: 26 })
                    .objectFit(ImageFit.Contain)
                    .onClick(() => {
                      router.back()
                    })
                  Text($r('app.string.navigation_navbar_list', navidx))
                    .fontSize(20)
                    .layoutWeight(1)
                    .margin({ left: 16 })
                    .align(Alignment.Start)
                  Blank()
                }
                .height(56)
                .width('100%')

                List() {
                  ForEach(this.contentarray, (contentidx: number) => {
                    ListItem() {
                      Row() {
                        Text($r('app.string.navigation_navcontent_list', contentidx))
                          .fontSize(16)
                        Blank()
                        Image($r('app.media.ic_right_arrow'))
                          .objectFit(ImageFit.ScaleDown)
                          .height(22)
                      }
                      .height(48)
                      .padding({ top: 13, bottom: 13 })
                      .width('100%')
                    }
                  })
                }
                .borderRadius('24')
                .backgroundColor(Color.White)
                .width('95%')
                .padding(12)
              }
              .hideTitleBar(true)
              .backgroundColor($r('app.color.background_shallow_grey'))
              .onShown(() => {
                this.selectnav = navidx;
              })
            }
          })
        }
        .backgroundColor(Color.White)
        .borderRadius(24)
        .padding(5)
      }
      .hideTitleBar(true)
      .mode(NavigationMode.Split)
      .navBarWidthRange([100, 800])
      .minContentWidth(100)
      .width('100%')
      .height('90%')
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}
