/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
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
/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
 */

import avMusicTemplate from '@ohos.multimedia.avMusicTemplate';
import { ControllerManager } from '../manager/ControllerManager';
import { TAB_ID_MINE } from '../pages/Index';

const TAG: string = 'TabContentComponent';
const PLAYBACK_STATE_PREPARE: avMusicTemplate.PlaybackState = 0;
const SINGLE: avMusicTemplate.EntityType = 1;
const SINGER: avMusicTemplate.EntityType = 2;
const ALBUM: avMusicTemplate.EntityType = 3;
const RANKING: avMusicTemplate.EntityType = 4;
const BANNER: avMusicTemplate.EntityType = 5;
const RADIO_STATION: avMusicTemplate.EntityType = 6;

@Component
export struct TabContentComponent {
  @Prop @Watch('getMediaTabContent') tabId: string = '';
  @State compilations: avMusicTemplate.Compilation[] = [];
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.getMediaTabContent(this.tabId);
  }

  build() {
    Column() {
      List({ scroller: this.scroller, space: '16vp' }) {
        ForEach(this.compilations, (item: avMusicTemplate.Compilation, index?: number) => {
          ListItem() {
            Column() {
              Text(item.title)
                .fontSize($r('sys.float.Title_M'))
                .fontColor($r('sys.color.font_primary'))
                .fontWeight(FontWeight.Medium);

              Divider()
                .vertical(true)
                .color($r('sys.color.icon_fourth'))
                .width('100%')
                .height('1vp')
                .margin({
                  top: '6vp',
                  bottom: '6vp'
                });

              this.buildCompilationItem(item.topElements);
            }
            .width('100%')
            .height('auto')
            .borderRadius('16vp')
            .backgroundColor('#FFFFFF')
            .alignItems(HorizontalAlign.Start)
          }
        });
      }
      .listDirection(Axis.Vertical)
      .scrollBar(BarState.Off);
    }
    .layoutWeight(1)
    .height('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildCompilationItem(mediaEntities: avMusicTemplate.MediaEntity[]) {
    List({ scroller: this.scroller, space: '6vp' }) {
      ForEach(mediaEntities, (item: avMusicTemplate.MediaEntity, index?: number) => {
        ListItem() {
          Column() {
            Text(`${item.title}${index ?? ''}`)
              .fontSize($r('sys.float.Body_L'))
              .fontColor($r('sys.color.font_primary'))
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Medium);

            Text(item.desc ?? '简介')
              .fontSize($r('sys.float.Body_S'))
              .fontColor($r('sys.color.font_primary'))
              .fontColor('#FFFFFF')
              .margin({
                top: '10vp'
              })
              .fontWeight(FontWeight.Medium);
          }
          .padding('16vp')
          .alignItems(HorizontalAlign.Start)
          .backgroundColor('#666666')
          .onClick(() => {
          })
          .height('200vp')
          .width('200vp')
        }
      });
    }
    .listDirection(Axis.Horizontal)
    .scrollBar(BarState.Off)
  }

  async getMediaTabContent(tabId: string) {
    if (this.tabId === '') {
      console.warn(TAG, `getMediaTabContent: tabId: ${tabId}`)
      return;
    }
    console.info(TAG, `getMediaTabContent: tabId: ${tabId}`)
    let mediaTabContent: avMusicTemplate.MediaTabContent | undefined = undefined;
    try {
      mediaTabContent = await ControllerManager.getInstance().queryMediaTabContent(tabId);
    } catch (e) {
      console.error(TAG, `getMediaTabContent fail: errCode: ${tabId}`);
    }

    // 模拟home页数据。
    if (tabId !== TAB_ID_MINE) {
      mediaTabContent = this.createHomeTabData(tabId);
    }
    if (!mediaTabContent?.compilations) {
      console.warn(TAG, `getMediaTabContent: tabId: ${tabId}`)
      return;
    }
    this.compilations = mediaTabContent.compilations;
  }

  /**
   * 模拟首页内容。
   *
   * @param tabId 首页ID。
   */
  private createHomeTabData(tabId: string): avMusicTemplate.MediaTabContent {
    let compilations: avMusicTemplate.Compilation[] = [];
    compilations.push(this.createCompilation(BANNER));
    compilations.push(this.createCompilation(SINGLE));
    compilations.push(this.createCompilation(SINGER));
    compilations.push(this.createCompilation(ALBUM));
    compilations.push(this.createCompilation(RANKING));
    compilations.push(this.createCompilation(RANKING));
    compilations.push(this.createCompilation(RADIO_STATION));
    let mediaTabContent: avMusicTemplate.MediaTabContent = {
      errorCode: 0,
      tabId: tabId,
      compilations: compilations
    }
    return mediaTabContent;
  }

  /**
   * 模拟合集数据。
   *
   * @param mediaType 媒体类型。
   */
  private createCompilation(mediaType: avMusicTemplate.EntityType): avMusicTemplate.Compilation {
    let mediaEntities: avMusicTemplate.MediaEntity[] = [];
    for (let i: number = 0; i < 5; i++) {
      mediaEntities.push(this.createMediaEntity());
    }
    let compilation: avMusicTemplate.Compilation = {
      errorCode: 0,
      id: `compilation${mediaType}`,
      title: this.getMediaTypeStr(mediaType),
      hasMoreData: true,
      totalSize: 6,
      memberMediaType: mediaType,
      topElements: mediaEntities
    }
    return compilation;
  }

  /**
   * 模拟媒体实体数据。
   *
   * @returns 媒体实体。
   */
  private createMediaEntity(): avMusicTemplate.MediaEntity {
    let mediaEntity: avMusicTemplate.MediaEntity = {
      mediaId: 'mediaId',
      mediaType: SINGLE,
      parentId: 'parentId',
      parentMediaType: SINGLE,
      title: 'title',
      imageUrl: 'imageUrl',
      playState: PLAYBACK_STATE_PREPARE
    }
    return mediaEntity;
  };

  /**
   * 模拟类型名称。
   *
   * @param mediaType 媒体类型。
   * @returns 类型名称。
   */
  private getMediaTypeStr(mediaType: avMusicTemplate.EntityType): string {
    switch (mediaType) {
      case SINGLE:
        return '单曲';
      case SINGER:
        return '歌手';
      case ALBUM:
        return '专辑';
      case RANKING:
        return '排行榜';
      case BANNER:
        return '海报';
      case RADIO_STATION:
        return '电台';
      default:
        return '未知';
    }
  }
}