/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { MediaTypeModel, MEDIA_TYPE } from '../common/Constants';
import { NavStack } from '../common/manager/NavPathStackManager';
import { MLog } from '../common/utils/MLog';
import { MediaType } from '../model/MediaType';
import { PageType } from '../model/PageType';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { Units } from '../common/utils/PixelUnitConversion';
import lpx from '../common/utils/Lpx';

const TAG ='Home';
@Component
export struct Home {
  @State focusIndex: number = -1;
  @StorageLink('Tindex') beforeFocusIndex: number = 0;
  focusController = this.getUIContext().getFocusController();
  @Link isFocusable: boolean;

  aboutToDisappear(): void {
    this.isFocusable = false;
  }

  build() {
    Row() {
      Scroll() {
        Grid() {
          ForEach(MEDIA_TYPE, (item: MediaTypeModel, index: number) => {
            GridItem() {
              Column() {
                Stack() {
                  Image(item.image)
                    .width(lpx(Units.px2vp(120)))
                    .width(lpx(Units.px2vp(120)))
                  if (this.focusIndex == index) {
                    Image($r('app.media.ic_media_type_selected'))
                      .width('100%')
                      .height('100%')
                  }
                }
                .width(lpx(Units.px2vp(130)))
                .height(lpx(Units.px2vp(130)))

                Text(item.title)
                  .fontSize(lpx(Units.px2fp(18)))
                  .fontColor($r('app.color.title_bar_hint_text'))
                  .margin({ top: lpx(Units.px2vp(16)) })
              }
              .onFocus(() => {
                this.isFocusable = true;
                this.focusIndex = index;
                AppStorage.SetOrCreate('Tindex', index);
              })
              .key(index.toString())
              .onHover(() => {
                this.focusController.requestFocus(index.toString());
              })
              .onTouch((event) => {
                if (event.type === TouchType.Down) {
                  this.focusIndex = index;
                  this.focusController.requestFocus(index.toString());
                }
              })
              .onClick(() => this.itemClicked(item))
              .backgroundColor(Color.Transparent)
          }
          .margin({ right: lpx(Units.px2vp(20)) })
          .focusable(true)
          .defaultFocus(true)
          .focusBox( {
            strokeColor: ColorMetrics.numeric(Color.Transparent),
            strokeWidth:LengthMetrics.px(0)
          })

          })
        }
        .width('100%')
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .padding({ top: lpx(Units.px2vp(16)) })
        .onAppear(() => {
          setTimeout(() => {
            this.focusController.requestFocus(this.beforeFocusIndex.toString())
          })
        })
        .onBlur(() => {
          this.focusIndex = -1;
          MLog.print(TAG, `onBlur Grid focusIndex:${this.focusIndex}`);
        })
      }//.height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Top)
    .backgroundColor(Color.Transparent)
    .onAppear(()=>{
        MLog.print(TAG,`onAppear home`);
        NavStack.getIns().isShowHomePage = true;
    })
  }

  private itemClicked(item: MediaTypeModel) {
    // NavStack.getIns().pushPath({ name: 'FileList', param: new Object({ mediaType: item.mediaType })})
    switch(item.mediaType){
      case MediaType.VIDEO:
        NavStack.getIns().pushRoot(PageType.VIDEO_PAGE);
      break;
      case MediaType.AUDIO:
        NavStack.getIns().pushRoot(PageType.AUDIO_PAGE);
      break;
      case MediaType.DOC:
        NavStack.getIns().pushRoot(PageType.DOC_PAGE);
      break;
      case MediaType.IMAGE:
        NavStack.getIns().pushRoot(PageType.IMAGE_PAGE);
      break;
      default:
        NavStack.getIns().pushRoot(PageType.ROOT_PAGE);
      break;
    }

  }
}