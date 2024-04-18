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

import { Log } from '../utils/Log';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { MenuOperationCallback } from './MenuOperationCallback';
import { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import { userFileModel } from '../base/UserFileModel';
import { Constants } from '../constants/BrowserConstants';
import { getResourceString } from '../utils/ResourceUtils';
import { showToast } from '../utils/UiUtil';
import { UserFileDataItem } from '../base/UserFileDataItem';

const TAG = 'RenameMenuOperation';

export class RenameMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null) {
      Log.warn(TAG, 'menuContext is null, return');
      return;
    }
    let mediaItem = this.menuContext.items[0];
    if (mediaItem == null) {
      Log.warn(TAG, 'mediaItem is null, return');
      return;
    }

    this.confirmCallback = (title: string): Promise<void> => this.confirmCallbackBindImpl(title);
    this.cancelCallback = (): void => this.cancelCallbackBindImpl();
    let fileName = '';
    if (mediaItem.title != null) {
      fileName = mediaItem.title;
    } else if (mediaItem.displayName != null) {
      let index = mediaItem.displayName.lastIndexOf('.');
      fileName = mediaItem.displayName.substr(0, index);
    }

    this.menuContext.broadCast.emit(BroadcastConstants.SHOW_RENAME_PHOTO_DIALOG,
      [fileName, this.confirmCallback, this.cancelCallback]);
  }

  onCompleted(): void {
    Log.info(TAG, 'Rename data succeed!');
  }

  onError(): void {
    Log.error(TAG, 'Rename data failed!');
  }

  private async confirmCallback(title: string): Promise<void> {
    return await this.confirmCallbackBindImpl(title);
  }

  private async confirmCallbackBindImpl(title: string): Promise<void> {
    Log.info(TAG, 'Rename confirm new name: ' + title);
    let mediaItem = (this.menuContext.items[0] as UserFileDataItem);
    if (mediaItem == null) {
      Log.warn(TAG, 'mediaItem is null, return');
      return;
    }

    let hasSameName = await this.hasSameNameAsset(mediaItem, title);
    if (hasSameName) {
      Log.info(TAG, 'show find same file dialog');
      getResourceString($r('app.string.name_already_use')).then<void, void>((message: string): void => {
        showToast(message);
      })
      return;
    }
    try {
      let result = await this.rename(mediaItem, title);
      Log.info(TAG, 'Rename confirm result: ' + result);
      this.menuContext.broadCast.emit(Constants.RENAME, [result]);
    } catch (err) {
      Log.error(TAG, 'Rename error: ' + err);
      getResourceString($r('app.string.rename_failed')).then<void, void>((message: string): void => {
        showToast(message);
      })
    }

  }

  private async rename(item: UserFileDataItem, name: string): Promise<Object[]> {
    Log.info(TAG, 'renameSinglePhoto start');
    await item.setName(name);
    return [item.title, item.displayName] as Object[];
  }

  private async hasSameNameAsset(item: UserFileDataItem, name: string): Promise<boolean> {
    Log.debug(TAG, 'hasSameNameAsset start');
    let fileAsset = await item.loadFileAsset();
    let displayName = fileAsset.displayName;
    let index = displayName.lastIndexOf('.');
    displayName = name + displayName.slice(index);
    let counts = (await userFileModel.getMediaItemCountsByDisplayName(fileAsset.uri));
    if (counts === 0) {
      Log.info(TAG, 'hasSameNameAsset is false');
      return false;
    }
    Log.info(TAG, 'hasSameNameAsset true');
    return true;
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, 'Rename cancel');
  }
}
