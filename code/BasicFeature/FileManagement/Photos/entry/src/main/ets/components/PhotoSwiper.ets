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

import { PhotoItem } from './PhotoItem';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { Log } from '../utils/Log';
import { Broadcast } from '../common/Broadcast';
import { AnimationConstants } from '../constants/AnimationConstants';
import { GroupItemDataSource } from '../common/GroupItemDataSource';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { Constants } from '../constants/BrowserConstants';
import { LazyItem } from '../common/ItemDataSource';

const TAG = 'PhotoSwiper'

@Component
export struct PhotoSwiper {
  photoSwiperTransition: string = '';
  private dataSource: GroupItemDataSource = new GroupItemDataSource();
  @Consume currentIndex: number;
  @Consume broadCast: Broadcast;
  @Consume canSwipe: boolean;
  @State duration: number = 400;
  onPhotoChanged: Function | null = null;
  private swiperController?: SwiperController;

  aboutToAppear(): void {
    this.broadCast.on(BroadcastConstants.ON_DATA_RELOADED, (): void => {
      Log.debug(TAG, 'animate to data reloaded start');
      animateTo({
        duration: AnimationConstants.DELETE_ANIMATE_DURATION,
        onFinish: (): void => {
        } }, (): void => {
        if (this.dataSource != null && this.dataSource != undefined) {
          this.dataSource.dataRemove();
          this.broadCast.emit(Constants.DATA_SIZE_CHANGED,[this.dataSource.totalCount()]);
        }
      })
    });

    this.broadCast.on(BroadcastConstants.CHANGE_SWIPER_DURATION, (value: number): void => {
      Log.debug(TAG, 'change duration start ' + value);
      this.duration = value;
    });
  }

  private getIndex(item: LazyItem<UserFileDataItem>): number {
    let ind = 1
    if (item != undefined && item != null && item.index === this.currentIndex) {
      ind = 2
    }
    return ind
  }

  build() {
    Swiper(this.swiperController) {
      LazyForEach(this.dataSource, (item: LazyItem<UserFileDataItem>): void => {
        if (item != undefined && item != null && item.get() != undefined && item.get() != null) {
          PhotoItem({
            item: item.get(),
            pageName: this.photoSwiperTransition
          })
          .zIndex(this.getIndex(item))
        }
      }, (item: LazyItem<UserFileDataItem>): string => item.getHashCode())
    }
    .itemSpace('8vp')
    .gesture(PanGesture({
      direction: PanDirection.Horizontal
    }))
    .index(this.currentIndex)
    .indicator(false)
    .loop(false)
    .onChange((index: number): void => {
      if (AppStorage.Get<number>('isDelete') === 0) {
        if (this.currentIndex - index === 1) {
          AppStorage.SetOrCreate<number>('isLeftSwiper', 1);
        } else if (this.currentIndex - index === -1) {
          AppStorage.SetOrCreate<number>('isLeftSwiper', 0);
        }
      }
      if (this.duration !== 0 && this.onPhotoChanged !== null) {
        this.onPhotoChanged(index);
      }
    })
    .disableSwipe(this.canSwipe)
  }
}
