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

import Matrix4 from '@ohos.matrix4';
import router from '@system.router';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { EventPipeline, AnimationOption, Matrix4TransitWithMatrix4x4 } from '../common/EventPipeline';
import { Broadcast } from '../common/Broadcast';
import { Log } from '../utils/Log';
import { Constants } from '../constants/BrowserConstants';
import { RouterConstants } from '../constants/RouterConstants';
import { LoadingPanel } from './LoadingPanel';
import { VideoIcon } from './VideoIcon';
import { getThumbnail } from '../models/ThumbnailModel';

const TAG = 'PhotoItem'

class PreItemType{
  rotate: number = 0;
  height: number = 0;
  width: number = 0;
}

@Component
export struct PhotoItem {
  item: UserFileDataItem = new UserFileDataItem('', [], '', 0);
  pageName: string = '';
  @State matrix: Matrix4.Matrix4Transit | null = Matrix4.identity().copy();
  @State photoItemDirection: PanDirection = PanDirection.Vertical;
  @Consume broadCast: Broadcast;
  @State objectFit: ImageFit = ImageFit.Contain;
  @State thumbnail: PixelMap | undefined = undefined;
  @State ratio: number = 1.0;
  @State showError: boolean = false;
  @Consume isPullingDown: boolean;
  @Consume pageFrom: number;
  @Consume('transitionIndex') @Watch('onTransitionChange') updateTransition: number;
  private eventPipeline: EventPipeline | null = null;
  private animationOption: AnimationOption | null = null;
  private animationEndMatrix: Matrix4TransitWithMatrix4x4 | null = null;
  @Provide isLoading: boolean = true;
  private imgScale: number = 1;
  private firstLoad: boolean = true;
  private preItem: PreItemType = { rotate: 0, height: 0, width: 0 };
  private timeStamp: string = '';

  onTransitionChange() {
    Log.info(TAG, 'onTransitionChange, ' + this.updateTransition + ' ' + this.item.index);
    this.updateThumbnail()
    if (this.updateTransition === this.item.index) {
      this.broadCast.emit(Constants.PHOTO_SHOW_STATE, [!this.showError]);
    } else {
      this.isPullingDown = false;
    }
    // reset matrix
    if (this.imgScale !== 1) {
      this.matrix = Matrix4.identity().scale({
        x: this.imgScale,
        y: this.imgScale
      }).copy();
      if(this.eventPipeline != null) this.eventPipeline.setDefaultScale(this.imgScale);
    } else {
      this.matrix = Matrix4.identity().copy();
      if(this.eventPipeline != null)  this.eventPipeline.reset();
    }
    Log.info(TAG, 'onTransitionChange end, ' + this.updateTransition + ' ' + this.item.index);
  }

  async aboutToAppear(): Promise<void> {
    Log.info(TAG, 'aboutToAppear');
    this.timeStamp = (new Date()).valueOf().toString();
    this.eventPipeline = new EventPipeline(this.broadCast, this.item, this.timeStamp, (m: Matrix4.Matrix4Transit): void => this.updateMatrixBindImpl(m));
    this.matrix = Matrix4.identity().copy();
    this.firstLoad = true;
    this.isLoading = true;
    this.thumbnail = await this.item.getThumbnail(this.item.imgWidth, this.item.imgHeight);
    this.item.load(true).then<void, void>((): void => {
      this.isLoading = false
      this.updateThumbnail()
      Log.info(TAG, 'aboutToAppear loadFinish thumbnail ' + this.thumbnail);
    })
    // register event handling
    this.broadCast.on(Constants.TOUCH_EVENT + this.item.uri + this.timeStamp, (matrix: Matrix4.Matrix4Transit): void => {
      this.matrix = matrix;
    });

    this.broadCast.on(Constants.DIRECTION_CHANGE + this.item.uri + this.timeStamp, (direction: PanDirection): void => {
      Log.info(TAG, 'direction: ' + direction);
      this.photoItemDirection = direction;
    });

    this.broadCast.on(Constants.ANIMATION_EVENT + this.item.uri + this.timeStamp, (animationOption: AnimationOption, animationEndMatrix: Matrix4TransitWithMatrix4x4): void => {
      Log.info(TAG, 'animationOption: ' + JSON.stringify(animationOption));
      this.animationOption = animationOption;
      this.animationEndMatrix = animationEndMatrix;
    });
    this.onTransitionChange();
    this.onViewDataChanged();
    Log.info(TAG, 'photoItem aboutToAppear ' + this.item.uri + ' end ' + this.item.orientation);
  }

  private updateMatrix(matrix: Matrix4.Matrix4Transit) {
    this.updateMatrixBindImpl(matrix)
  }

  private updateMatrixBindImpl(matrix: Matrix4.Matrix4Transit) {
    Log.info(TAG, 'updateMatrix start ' + matrix);
    this.matrix = matrix;
  }

  private updateThumbnail() {
    getThumbnail(this.item, this.updateTransition === this.item.index).then<void, void>((thumbnail: PixelMap): void => {
      this.thumbnail = thumbnail
    })
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear ' + this.item.uri + '/' + this.thumbnail);
    // clean up event registration
    this.broadCast.off(Constants.TOUCH_EVENT + this.item.uri + this.timeStamp, null);
    this.broadCast.off(Constants.DIRECTION_CHANGE + this.item.uri + this.timeStamp, null);
    this.broadCast.off(Constants.ANIMATION_EVENT + this.item.uri + this.timeStamp, null);
    this.isPullingDown = false;
    Log.info(TAG, 'aboutToDisappear ' + this.item.uri + '/' + this.thumbnail + 'end');
  }

  onViewDataChanged(): void {
    Log.info(TAG, 'onViewDataChanged start');
    this.ratio = this.calcRatio(this.item);
    if ((this.preItem.rotate === this.item.orientation && this.preItem.height === this.item.imgHeight &&
    this.preItem.width === this.item.imgWidth) && !this.firstLoad) {
      this.preItem.rotate = this.item.orientation;
      this.preItem.width = this.item.imgWidth;
      this.preItem.height = this.item.imgHeight;
      if (this.eventPipeline != undefined && this.eventPipeline != null) {
        this.eventPipeline.onDataChanged(this.item)
      }
      return;
    }
    this.matrix = Matrix4.identity().copy();
    if(this.eventPipeline != null) {
      this.eventPipeline.setDefaultScale(1);
      this.eventPipeline.onDataChanged(this.item);
    }

    this.firstLoad = false;
    this.preItem.width = this.item.imgWidth;
    this.preItem.height = this.item.imgHeight;
    Log.debug(TAG, 'onViewDataChanged thumbnail: ' + JSON.stringify(this.thumbnail));
  }

  calcRatio(info: UserFileDataItem): number {
    if (info == null || info == undefined) {
      return 1;
    }
    if (info.width === 0 || info.height === 0) {
      return 1;
    }
    return  info.width / info.height;
  }

  build() {
    Stack() {
      Column() {
        LoadingPanel()
      }
      .width('100%')
      .height('100%')

      Row() {
        if (this.thumbnail !== null && this.thumbnail !== undefined) {
          Image(this.thumbnail)
            .rotate({ x: 0, y: 0, z: 1, angle: 0 })
            .transform(this.matrix)
            .autoResize(false)
            .fitOriginalSize(false)
            .aspectRatio(this.ratio)
            .objectFit(ImageFit.Cover)
            .width('100%')
            .height('100%')
            .constraintSize({maxWidth:'100%', maxHeight:'100%'})
            .sharedTransition(this.item.index === this.updateTransition ? this.pageName + this.item.getHashCode() : Constants.DEFAULT_TRANSITION_ID, {
              duration: Constants.SHARE_TRANSITION_DURATION,
              zIndex: 0,
            })
            .onComplete((): void => {
              Log.info(TAG, 'onComplete finish, index: ' + this.item.index +', item: ' + JSON.stringify(this.item) + ', uri: ' + this.thumbnail + '.');
              this.showError = false;
              this.isLoading = false;
              if (this.updateTransition === this.item.index) {
                this.broadCast.emit(Constants.PHOTO_SHOW_STATE, [true]);
              }
            })
            .onError((): void => {
              Log.error(TAG, 'image show error ' + this.thumbnail + ' ' + this.item.width + ' ' + this.item.height);
              if (this.thumbnail == undefined || this.item.width === 0 || this.item.height === 0) {
                this.updateThumbnail();
                return;
              }
              this.showError = true;
              this.isLoading = true;
              if (this.updateTransition === this.item.index) {
                this.broadCast.emit(Constants.PHOTO_SHOW_STATE, [false]);
              }
            })
        }

      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .onClick((): void => {
        this.broadCast.emit(Constants.TOGGLE_BAR, []);
      })
      .parallelGesture(
      GestureGroup(GestureMode.Parallel,
      PinchGesture({
        fingers: 2,
        distance: 1
      })
        .onActionStart((event: GestureEvent): void => {
          Log.debug(TAG, 'PinchGesture onActionStart');
          if (this.isPullingDown) {
            Log.debug(TAG, 'Not allow to pinch when pullingDown');
            return;
          }
          Log.debug(TAG, 'PinchGesture onActionStart scale:' +
              event.scale + ', cx: ' + event.pinchCenterX + ', cy: ' + event.pinchCenterY);
          if (this.item.mediaType === photoAccessHelper.PhotoType.IMAGE) {
            this.eventPipeline?.onScaleStart(event.scale, event.pinchCenterX, event.pinchCenterY);
          }
        })
        .onActionUpdate((event: GestureEvent): void => {
          Log.debug(TAG, 'PinchGesture onActionUpdate scale: ' + event.scale);
          if (this.isPullingDown) {
            Log.debug(TAG, 'Not allow to pinch when pullingDown');
            return;
          }
          if (this.item.mediaType === photoAccessHelper.PhotoType.IMAGE) {
            this.eventPipeline?.onScale(event.scale);
          }
        })
        .onActionEnd((): void => {
          Log.debug(TAG, 'PinchGesture onActionEnd');
          if (this.isPullingDown) {
            Log.debug(TAG, 'Not allow to pinch when pullingDown');
            return;
          }
          if (this.item.mediaType === photoAccessHelper.PhotoType.IMAGE) {
            this.eventPipeline?.onScaleEnd();
            if (this.animationOption != null) {
              animateTo({
                duration: this.animationOption.duration,
                curve: this.animationOption.curve,
                onFinish: (): void => {
                  this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
                  this.animationOption = null;
                  this.animationEndMatrix = null;
                }
              }, (): void => {
                this.matrix = this.animationEndMatrix;
              })
            }
          }
        }),
      PanGesture({
        direction: this.photoItemDirection
      })
        .onActionStart((event: GestureEvent): void => {
          Log.debug(TAG, 'PanGesture start offsetX: ' +
                  vp2px(event.offsetX) + ', offsetY: ' + vp2px(event.offsetY));
          this.eventPipeline?.onMoveStart(vp2px(event.offsetX), vp2px(event.offsetY));
        })
        .onActionUpdate((event: GestureEvent): void => {
          Log.debug(TAG, 'PanGesture update offsetX: ' +
                  vp2px(event.offsetX) + ', offsetY: ' + vp2px(event.offsetY));
          this.eventPipeline?.onMove(vp2px(event.offsetX), vp2px(event.offsetY));
        })
        .onActionEnd((event: GestureEvent): void => {
          Log.debug(TAG, 'PanGesture end offsetX: ' +
                  vp2px(event.offsetX) + ', offsetY: ' + vp2px(event.offsetY));
          this.eventPipeline?.onMoveEnd(vp2px(event.offsetX), vp2px(event.offsetY));
          if (this.animationOption != null) {
            animateTo({
              duration: this.animationOption.duration,
              curve: this.animationOption.curve,
              onFinish: (): void => {
                this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
                this.animationOption = null;
                this.animationEndMatrix = null;
              }
            }, (): void => {
              this.matrix = this.animationEndMatrix;
            })
          }
        }),
      TapGesture({
        count: 2
      })
        .onAction((event: GestureEvent): void => {
          if (this.isPullingDown) {
            Log.debug(TAG, 'Not allow to double tap when pullingDown');
            return;
          }
          Log.debug(TAG, 'onDoubleTap event: ' + JSON.stringify(event));
          if (this.item.mediaType === photoAccessHelper.PhotoType.VIDEO) {
            return;
          }
          this.eventPipeline?.onDoubleTap(event.fingerList[0].localX, event.fingerList[0].localY);
          if (this.animationOption != null) {
            Log.debug(TAG, 'TapGesture animateTo start');
            animateTo({
              duration: this.animationOption.duration,
              curve: this.animationOption.curve,
              onFinish: (): void => {
                this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
                this.animationOption = null;
                this.animationEndMatrix = null;
              }
            }, (): void => {
              this.matrix = this.animationEndMatrix;
            })
          }
        })
      )
      )
      .clip(true)
      .onTouch((event: TouchEvent): void => {
        this.eventPipeline?.onTouch(event);
      })

      if (this.isVideoPlayBtnShow()) {
        Row() {
          VideoIcon()
        }
        .width($r('app.float.icon_video_size'))
        .height($r('app.float.icon_video_size'))
        .onClick((): void => {
          if (this.item != undefined) {
            router.push({
              uri: 'pages/VideoBrowser',
              params: {
                uri: this.item.uri,
                dateAdded: this.item.dateAdded,
                previewUri: this.thumbnail
              }
            })
          }
        })
      }

    }.width('100%')
    .height('100%')
  }

  private isVideoPlayBtnShow(): boolean {
    Log.debug(TAG, 'isVideoPlayBtnShow: ' + this.item.mediaType);
    return ((this.item != undefined && this.item != null) && (this.item.mediaType === photoAccessHelper.PhotoType.VIDEO));
  }
}
