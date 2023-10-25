/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Log } from '../utils/Log';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { AlbumDataItem } from '../common/AlbumDataItem';

const TAG = 'AlbumListCard'

@Component
export struct AlbumListCard {
  @State useAlt: boolean = false;
  @Consume broadCast: Broadcast;
  item: AlbumDataItem = new AlbumDataItem('',0,'',0,'',0,0);
  @State thumbnail: PixelMap | undefined = undefined;
  @State mediaRes: Resource | undefined = undefined;

  aboutToAppear(): void {
    Log.info(TAG, 'album mediaSet ' + JSON.stringify(this.item));
    this.item.load().then<void, void>(async (): Promise<void>  => {
      this.thumbnail = await this.item.getThumbnail();
      Log.error(TAG,'this.thumbnail：'+this.thumbnail);
    })
    this.item.getVideoCount().then<void, void>((videoCount: number): void  => {
      this.mediaRes = this.showMediaRes(videoCount);
    })
  }

  mediaOperation() {
    this.broadCast.emit(BroadcastConstants.MEDIA_OPERATION, [this.item]);
  }

  showMediaRes(videoCount: number): Resource {
    if (videoCount === 0) {
      return $r('app.plural.show_photo_num', this.item.count, this.item.count);
    } else if (videoCount === this.item.count) {
      return $r('app.plural.show_video_num', this.item.count, this.item.count);
    } else if (videoCount === 1) {
      return $r('app.plural.show_one_video_with_photo_num', this.item.count - videoCount,
        this.item.count - videoCount, videoCount);
    } else {
      return $r('app.plural.show_multi_video_with_photo_num', this.item.count - videoCount,
        this.item.count - videoCount, videoCount)
    }
  }

  build() {
    Row() {
      if (this.useAlt) {
        Row() {
          Image($r('app.media.ic_goto_photos'))
            .height($r('app.float.icon_size'))
            .width($r('app.float.icon_size'))
            .objectFit(ImageFit.Cover)
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.default_background_color'))
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_s'))
        .height($r('app.float.list_card_image_size'))
        .width($r('app.float.list_card_image_size'))
      } else {
        Image(this.thumbnail)
          .height($r('app.float.list_card_image_size'))
          .width($r('app.float.list_card_image_size'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_s'))
          .onError((): void => {
            if (this.thumbnail != undefined) {
              this.useAlt = true;
            }
            Log.error(TAG, 'alt Image error');
          })
      }
      Column() {
        Text(this.item.displayName)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontColor($r('sys.color.ohos_id_color_primary'))
          .padding({
            bottom: $r('sys.float.ohos_id_text_margin_vertical')
          })
        if (this.item.count !== 0) {
          Text(this.mediaRes)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        }
      }
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: $r('app.float.crop_vertical_padding'),
      })
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height($r('app.float.list_card_height'))
    .onClick((): void => {
      this.mediaOperation();
    })
  }
}
