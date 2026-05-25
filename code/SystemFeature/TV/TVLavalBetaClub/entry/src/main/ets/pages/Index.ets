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
import IssueReporterHome from './IssueReporter/IssueReporterHome';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { vpChangeLpx } from './IssueReporter/models/IssueDetailInfo';
import photoManager from '../manager/PhotoManager';
import { AlbumModel, AlbumType, PhotoModel } from '../models/PhotoModel';
import { PointerUtil } from '../common/Utils/PointerUtil';
import { common } from '@kit.AbilityKit';

export function tabClick() {
  let keyDownOpt: inputEventClient.KeyEvent = {
    isPressed: true,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };
  let keyUpOpt: inputEventClient.KeyEvent = {
    isPressed: false,
    keyCode: KeyCode.KEYCODE_TAB,
    keyDownDuration: 0,
    isIntercepted: false
  };


  try {
    // 触发tab点击，使默认焦点组件多态样式生效
    inputEventClient.injectEvent({ KeyEvent: keyDownOpt });
    inputEventClient.injectEvent({ KeyEvent: keyUpOpt });
  } catch (err) {
    console.error('settingList inputEventClient' + err);
  }
}

@Entry
@Component
struct Index {
  @State isShowLoading: boolean = false;
  @State page: number = 0;

  aboutToAppear(): void {
    AppStorage.setOrCreate('page', this.page);
    photoManager.getLoader(AlbumType.ALL)?.registerChangeCallback(this.allPhotoObserver);
    PointerUtil.changePointStyle(false);
  }

  private allPhotoObserver = (photos: PhotoModel[], albumModel: AlbumModel) => {
    console.info('allPhotoObserver tmpList: ' + JSON.stringify(photos));
    AppStorage.setOrCreate('photoGroupList', photos);
  };

  aboutToDisappear(): void {
    photoManager.getLoader(AlbumType.ALL)?.unRegisterChangeCallback(this.allPhotoObserver);
  }

  onBackPress() {
    (getContext(this) as common.UIAbilityContext).terminateSelf();
  }

  build() {
    Stack() {
      IssueReporterHome();

      if (this.isShowLoading) {
        Column() {
          LoadingProgress()
            .color(Color.Blue)
            .width(vpChangeLpx(200))
            .height(vpChangeLpx(200));
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .height('100%')
        .width('100%');
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.global_default_background'))
    .padding({ left: vpChangeLpx(449), right: vpChangeLpx(449) })
    // 通过设置ratios为[0.0, 1.0]，实现当组件完全显示或完全消失在屏幕中时触发回调
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      console.info('Test Text isVisible: ' + isVisible + ', currentRatio:' + currentRatio);
      if (isVisible && currentRatio >= 1.0) {
        console.info('IssueReporterHome onPageShow xx');
        tabClick();
        console.info('IssueReporterHome onPageShow');
      }
    })
    .onTouch((event) => {
      PointerUtil.changePointStyle(event.type == TouchType.Down);
    });

  }
}