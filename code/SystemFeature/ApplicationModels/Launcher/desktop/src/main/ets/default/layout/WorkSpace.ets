/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import CommonEvent from '@ohos.commonEvent'
import LauncherGridLayout from '../components/LauncherGridLayout'
import { DesktopLayoutModel } from '../model/DesktopLayoutModel'
import { EventConstants, GridLayoutItemInfo, Logger } from '@ohos/base'

const TAG: string = 'WorkSpace';

@Component
export struct WorkSpace {
  @StorageLink('DesktopLayoutModel') desktopLayoutModel: DesktopLayoutModel | undefined = undefined;
  @StorageLink('isRefresh') @Watch('refreshWorkSpace') isRefresh: boolean = false;
  @State appPages: Array<Array<GridLayoutItemInfo>> | undefined = [[]];
  private swiperController: SwiperController = new SwiperController();

  build() {
    Column() {
      Swiper(this.swiperController) {
        ForEach(this.appPages, (item: Array<GridLayoutItemInfo>) => {
          LauncherGridLayout({ gridInfos: item })
        }, (item: Array<GridLayoutItemInfo>) => JSON.stringify(item))
      }
      .indicatorStyle({
        selectedColor: Color.White
      })
      .width('100%')
      .height('95%')
      .gesture(
      PanGesture({ fingers: 1, direction: PanDirection.Up, distance: 20 })
        .onActionStart((event: GestureEvent) => {
          console.info('Pan start');
        })
        .onActionUpdate((event: GestureEvent) => {
        })
        .onActionEnd(() => {
          console.info('Pan end')
          CommonEvent.publish(EventConstants.EVENT_ENTER_RECENTS, () => {
            Logger.info(TAG, 'publish EVENT_ENTER_RECENTS');
          })
        })
      )
    }
    .width('100%')
    .height('100%')
    .padding({ top: 40, bottom: 40 })
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear');
    this.getData();
  }

  refreshWorkSpace() {
    Logger.info(TAG, 'refreshWorkSpace');
    if (this.isRefresh) {
      this.appPages = this.desktopLayoutModel?.getLayoutInfoCache();
      AppStorage.SetOrCreate('isRefresh', false);
      Logger.info(TAG, 'refreshWorkSpace' + JSON.stringify(this.appPages));
    }
  }

  async getData() {
    this.appPages = await this.desktopLayoutModel?.getLayoutInfo();
    Logger.info(TAG, `getLauncherAbilityList end,appPages = ${JSON.stringify(this.appPages)}`);
  }
}