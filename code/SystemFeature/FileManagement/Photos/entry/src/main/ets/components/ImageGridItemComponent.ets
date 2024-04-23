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

import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { Log } from '../utils/Log';
import { AnimationConstants } from '../constants/AnimationConstants';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { DateUtil } from '../utils/DateUtil';
import { Broadcast } from '../common/Broadcast';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { MediaConstants } from '../constants/MediaConstants';
import { LazyItem} from '../common/ItemDataSource';

const TAG = 'ImageGridItemComponent'
// General grid picture control
@Component
export struct ImageGridItemComponent {
  @Consume broadCast: Broadcast;
  @Consume  @Watch('restPress') isSelectedMode: boolean;
  @Consume @Watch('onShow') isShow: boolean;
  @State thumbnail: PixelMap | undefined = undefined;
  @State isFavourite: boolean = false;
  @State pressAnimScale: number = 1.0;
  @State isError: boolean = false;
  pageName = '';
  mediaItem: UserFileDataItem = new UserFileDataItem('', [], '', 0);
  lazyItem: LazyItem<UserFileDataItem> = new LazyItem(this.mediaItem, 0);
  isThird = false;
  private isEnteringPhoto = false;
  private isPush = false;
  private isPreview = false;
  @Link isSelectUpperLimited : boolean;

  private resetPressAnim(): void {
    this.pressAnimScale = 1;
    Log.error(TAG, 'isEnteringPhoto false');
    this.isEnteringPhoto = false;
  }

  private restPress(): void {
    this.pressAnimScale = 1;
  }

  aboutToAppear(): void {
    Log.debug(TAG, 'aboutToAppear');
    this.resetShow();
  }

  private async resetShow(): Promise<void> {
    if (this.mediaItem.isLoad()) {
      this.thumbnail = await this.mediaItem.getThumbnail(MediaConstants.DEFAULT_SIZE, MediaConstants.DEFAULT_SIZE);
      this.mediaItem.isFavor().then<void, void>((status: boolean): void => {
        this.isFavourite = status;
      })
    } else {
      this.mediaItem.load(false).then<void, void>(async (): Promise<void> => {
        this.thumbnail = await this.mediaItem.getThumbnail(MediaConstants.DEFAULT_SIZE, MediaConstants.DEFAULT_SIZE);
        this.isError = false;
        this.mediaItem.isFavor().then<void, void>((status: boolean): void => {
          this.isFavourite = status;
        })
      })
    }
    this.resetPressAnim();
    this.isPush = false;
  }

  aboutToDisappear(): void {
    Log.debug(TAG, 'aboutToDisappear');
    this.resetPressAnim();
  }

  private onShow(): void {
    if(!this.isShow){
      return;
    }
    if (this.isEnteringPhoto) {
      this.resetShow();
    } else {
      this.resetPressAnim();
    }
  }

  async routePage(isError: boolean): Promise<void> {
    Log.info(TAG, 'routePage ' + isError);
    try {
      if (this.isThird || this.isPreview) {
        this.broadCast.emit(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
      } else {
        this.broadCast.emit(BroadcastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
      }
    } catch (err) {
      Log.error(TAG, 'fail callback, code: ' + err.code + ', msg: ' + err.msg);
    }
  }

  async routeToPreviewPage(): Promise<void> {
    try {
      Log.info(TAG, 'routeToPreviewPage');
      this.broadCast.emit(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
    } catch (err) {
      Log.error(TAG, 'fail callback, code: ' + err.code + ', msg: ' + err.msg);
    }
  }

  private onSelected(): void {
    Log.info(TAG, 'onSelected');
    if ((this.isSelectUpperLimited != undefined && !this.isSelectUpperLimited) || this.mediaItem.isSelect) {
      this.mediaItem.setSelect(!this.mediaItem.isSelect);
      if (this.lazyItem != null) {
        this.lazyItem.update(this.mediaItem)
      }
    }
    this.broadCast.emit(BroadcastConstants.SELECT, [this.mediaItem.index]);
  }

  private selectStateChange(): void {
    Log.info(TAG, 'change selected ' + this.isSelectedMode);
    if (!this.isSelectedMode) {
      this.isSelectedMode = true;
      this.pressAnimScale = 1;
    }
    this.onSelected();
  }

  async jumpToPhotoBrowser(): Promise<void> {
    Log.info(TAG,'jumpToPhotoBrowser'+this.isEnteringPhoto)
    if(this.isEnteringPhoto){
      return;
    }
    this.isEnteringPhoto = true;
    this.thumbnail = await this.mediaItem.getThumbnail(this.mediaItem.imgWidth, this.mediaItem.imgHeight);
    Log.info(TAG,'column click, first change source:'+this.thumbnail)
    this.isPush = true;
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Image(this.isError ? this.mediaItem.getAlt() : this.thumbnail)
        .aspectRatio(1)
        .rotate({ x: 0, y: 0, z: 1, angle: 0 })
        .objectFit(ImageFit.Cover)
        .autoResize(false)
        .onComplete((): void => {
          Log.debug(TAG, 'Draw the image! ' + this.thumbnail);
          if (this.isEnteringPhoto && this.isPush) {
            Log.info(TAG, 'image onComplete, broadCast, thumbnail:'+this.thumbnail);
            this.isPush = false;
            if (this.isThird || this.isPreview) {
              this.broadCast.emit(BroadcastConstants.JUMP_THIRD_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
            } else {
              this.broadCast.emit(BroadcastConstants.JUMP_PHOTO_BROWSER, [this.pageName, this.mediaItem]);
            }
          }

        })
        .onError((): void => {
          Log.error(TAG, 'alt Image ' + this.mediaItem.index + ' error :' + this.thumbnail);
          if (this.thumbnail == undefined || this.mediaItem.width === 0 || this.mediaItem.height === 0) {
            this.resetShow()
          } else {
            this.isError = true
          }
        })
        .sharedTransition(this.pageName + this.mediaItem.getHashCode(), {
          duration: AnimationConstants.SHARE_TRANSITION_DURATION,
          zIndex: 0,
        })

      if (this.mediaItem.mediaType === photoAccessHelper.PhotoType.VIDEO) {
        Column()
          .position({ x: '0%', y: '50%' })
          .height('50%')
          .width('100%')
          .linearGradient({
            angle: 0,
            colors: [
              [$r('app.color.album_cover_gradient_start_color'), 0] as [ResourceColor, number],
              [$r('app.color.transparent'), 1.0] as [ResourceColor, number]
            ] as [ResourceColor, number][]
          })
        Text(DateUtil.getFormattedDuration(this.mediaItem.duration))
          .fontSize($r('sys.float.ohos_id_text_size_caption'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('app.color.text_color_above_picture'))
          .lineHeight($r('app.float.grid_item_text_line_height'))
          .position({ x: '0%', y: '100%' })
          .markAnchor({
            x: $r('app.float.grid_item_duration_markAnchor_x'),
            y: $r('app.float.grid_item_duration_markAnchor_y')
          })
          .margin({ right: $r('app.float.grid_item_duration_margin_right') })
      }
      if (this.isFavourite) {
        Image($r('app.media.ic_favorite_overlay'))
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .objectFit(ImageFit.Contain)
          .position({ x: '100%', y: '0%' })
          .markAnchor({
            x: $r('app.float.grid_item_favor_markAnchor_x'),
            y: $r('app.float.grid_item_favor_markAnchor_y')
          })
      }

      Column()
        .height('100%')
        .width('100%')
        .backgroundColor(this.isSelectedMode && this.mediaItem.isSelect ?
        $r('app.color.item_selection_bg_color') : $r('app.color.transparent'))
        .onClick((): void => {
          if (this.isSelectedMode) {
            this.onSelected();
           } else {
            this.isPreview = false;
            this.jumpToPhotoBrowser();
           }
        })
      if (this.isSelectedMode) {
        Image($r('app.media.ic_photo_preview'))
          .onClick((): void => {
            this.isPreview = true;
            this.jumpToPhotoBrowser();
            Log.info(TAG, 'expand.');
          })
          .height($r('app.float.icon_size_hot'))
          .width($r('app.float.icon_size_hot'))
          .position({ x: '0%', y: '0%' })
          .markAnchor({ x: 0, y: 0 })
          .padding($r('app.float.grid_item_preview_padding'))
        Image(this.mediaItem.isSelect
          ? $r('app.media.ic_gallery_public_checkbox_filled') : $r('app.media.ic_checkbox_off_overlay'))
          .height($r('app.float.icon_size'))
          .width($r('app.float.icon_size'))
          .position({ x: '100%', y: '100%' })
          .markAnchor({
            x: $r('app.float.grid_item_checkbox_markAnchor'),
            y: $r('app.float.grid_item_checkbox_markAnchor')
          })
          .onClick((): void => {
            this.onSelected();
          })
      }
    }
    .aspectRatio(1)
    .scale({
      x: this.pressAnimScale,
      y: this.pressAnimScale
    })
    .animation({
      duration: AnimationConstants.PRESS_ANIM_DURATION,
      curve: Curve.Ease
    })
    .onTouch((event: TouchEvent): void => {
      Log.info(TAG, 'onTouch trigger: isSelectedMode: ' + this.isSelectedMode +
      ', isEnteringPhoto: ' + this.isEnteringPhoto + ', ' + JSON.stringify(event));
      if (this.isSelectedMode) {
        return;
      }
      // Press animation
      if (event.type === TouchType.Down) {
        this.pressAnimScale = AnimationConstants.PRESS_ANIM_SCALE;
      }

      if (event.type === TouchType.Up && !this.isEnteringPhoto && this.pressAnimScale !== 1) {
        this.pressAnimScale = 1;
      }
    })
    .gesture(LongPressGesture().onAction((event: GestureEvent): void => {
      if (!this.isThird) {
        Log.info(TAG, 'LongPressGesture ' + this.isSelectedMode);
        this.selectStateChange();
      }
    }))
  }
}
