/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import router from '@system.router';
import { RouterOptions } from '@system.router';
import { Log } from '../utils/Log';
import { getResourceString } from '../utils/ResourceUtils';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { MenuOperationCallback } from './MenuOperationCallback';
import { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { JumpSourceToMain } from '../models/JumpSourceToMain';
import { SimpleAlbumDataItem } from '../common/SimpleAlbumDataItem';
import { showToast } from '../utils/UiUtil';
import { userFileModel } from '../base/UserFileModel';
import { AlbumDataItem } from '../common/AlbumDataItem';
import { LazyItem } from '../common/ItemDataSource';
import { MediaConstants } from '../constants/MediaConstants';
import { AlbumsDataSource } from '../common/AlbumsDataSource';

const TAG = 'AlbumSetNewMenuOperation';

export class AlbumSetNewMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private onOperationEnd: Function;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.warn(TAG, 'menuContext is null, return');
      return;
    }
    getResourceString($r('app.string.album_new_album')).then<void, void>((name: string): void => {
      Log.info(TAG, 'The display name is ' + name);
      let newAlbumDisplayName = this.getNewAlbumDefaultName(name);
      Log.info(TAG, `The display name of new album is ${newAlbumDisplayName}`);
      this.confirmCallback = (displayName: string): Promise<void> => this.confirmCallbackBindImpl(displayName);
      this.cancelCallback = (): void => this.cancelCallbackBindImpl();

      this.menuContext.broadCast.emit(BroadcastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
          [newAlbumDisplayName, this.confirmCallback, this.cancelCallback]);
    })
  }

  private async confirmCallback(displayName: string): Promise<void> {
    return await this.confirmCallbackBindImpl(displayName);
  }

  private async confirmCallbackBindImpl(displayName: string): Promise<void> {
    Log.info(TAG, 'AlbumSet new album confirm and the new name is: ' + displayName);
    let simpleAlbumDataItem: SimpleAlbumDataItem = new SimpleAlbumDataItem('', displayName, '', '', '', -1, -1);
    if (displayName != undefined && displayName != null) {
      let isExit = await this.checkAlbumExit(simpleAlbumDataItem);
      if (isExit) {
        getResourceString($r('app.string.name_already_use')).then<void, void>((message: string): void => {
            showToast(message);
        })
        return;
      }
    }
    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;
    if (onOperationStart != null) onOperationStart();

    if (this.menuContext.jumpSourceToMain === JumpSourceToMain.ALBUM) {
      Log.info(TAG, 'go back to photo grid');
      this.menuContext.broadCast.emit(BroadcastConstants.MEDIA_OPERATION, [simpleAlbumDataItem, (): void => this.onCompletedBindImpl()]);
    } else {
      let params: Object = {
        albumInfo: JSON.stringify(simpleAlbumDataItem),
        isNewAlbum: true
      };
      let routerOptions: RouterOptions = {
        uri: 'pages/AlbumSelect',
        params: params
      };
      router.push(routerOptions);
      this.onCompleted();
    }
  }

  private async checkAlbumExit(simpleAlbumDataItem: SimpleAlbumDataItem): Promise<boolean> {
    return await userFileModel.getUserAlbumCountByName(simpleAlbumDataItem.displayName) > 0;
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, 'AlbumSet new album cancel');
  }

  onCompleted(): void {
    this.onCompletedBindImpl();
  }

  private onCompletedBindImpl(): void {
    Log.info(TAG, 'new album data succeed!');
    if (this.onOperationEnd != null) this.onOperationEnd();
  }

  onError(): void {
    Log.error(TAG, 'new album data failed!');
    if (this.onOperationEnd != null) this.onOperationEnd();
  }

  private checkAndAddNumber(albumInfo: AlbumDataItem, prefixName: string, numbers: number[]): void {
    let res = albumInfo.displayName.match(new RegExp('^' + prefixName + '[1-9][0-9]*$'));
    Log.info(TAG, `check name res ${res}`);
    if (res) {
      let number = res[0].match(new RegExp(`[1-9][0-9]*`));
      numbers.push(parseInt(number[0]));
    }
  }

  private getNewAlbumDefaultName(prefixName: string): string {
    let numbers: number[] = [];
    for (let i = 0; i < this.menuContext.dataSource.totalCount(); i++) {
      let album = this.menuContext.dataSource as AlbumsDataSource;
      this.checkAndAddNumber(album.getDataByIndex(i), prefixName, numbers);
    }

    Log.debug(TAG, `${JSON.stringify(numbers)}`);

    if (numbers.length <= 0) {
      return `${prefixName}1`;
    } else if (numbers.length === 1) {
      if (numbers[0] - 1 > 0) {
        return `${prefixName}1`;
      } else {
        return `${prefixName}${numbers[0] + 1}`;
      }
    }

    numbers.sort(function (a, b) {
      return a - b;
    });

    if (numbers[0] - 1 > 0) {
      return `${prefixName}1`;
    }

    for (let i = 1; i < numbers.length; i++) {
      let res = numbers[i - 1] + 1;
      if (res < numbers[i]) {
        return `${prefixName}${res}`;
      }
    }
    return `${prefixName}${numbers[numbers.length - 1] + 1}`;
  }
}
