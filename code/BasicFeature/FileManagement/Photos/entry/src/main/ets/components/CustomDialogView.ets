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

import { Constants } from '../constants/Constants';
import { Broadcast } from '../common/Broadcast';
import { Assets } from '../menus/ProcessMenuOperation';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { Log } from '../utils/Log';
import { MediaDetails, DetailsDialog } from './DetailsDialog';
import { MultiSelectDetails, MultiSelectDialog } from './MultiSelectDialog';
import { DeleteDialog } from './DeleteDialog';
import { DialogCallback } from '../utils/DialogUtil';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { CancelOperationDialog, CancelParam } from './CancelOperationDialog';
import { RenameDialog } from './RenameDialog';
import { AddNotesDialog } from './AddNotesDialog';
import { ProgressDialog, ProgressParam } from './ProgressDialog';
import { DeleteProgressDialog, DeleteProgressParam } from './DeleteProgressDialog';
import { SaveDialog, SaveDialogCallback } from './SaveDialog';
import { NewAlbumDialog } from './NewAlbumDialog';
import { FindSameNameDialog, FindSameNameParam } from './FindSameNameDialog';
import { screenManager } from '../common/ScreenManager';
import { SaveImageDialog } from './SaveImageDialog';

const TAG: string = 'CustomDialogView'

@Component
export struct CustomDialogView {
  @State isShow: boolean = false;
  @Provide dialogMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide dialogDeleteMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide progressMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide dialogCallback: DialogCallback = { confirmCallback: null, cancelCallback: undefined };
  @Provide saveDialogCallback: SaveDialogCallback = new SaveDialogCallback();
  @Consume broadCast: Broadcast;
  @Provide progressParam: ProgressParam = new ProgressParam();
  @Provide deleteProgress: number = 0;
  @Provide deleteProgressParam: DeleteProgressParam = { currentCount: 0, totalCount: 0, message: null, deleteProgress: 0};
  @Provide cancelParam: CancelParam = new CancelParam();
  @Provide findSameNameParam: FindSameNameParam = new FindSameNameParam();
  @Provide cancelMessage: Resource = $r('app.string.common_place_holder', String(''));
  @Provide renameFileName: string = '';
  @Provide mediaDetails: MediaDetails = {
    mediaType: 0,
    height: 0,
    width: 0,
    size: 0,
    path: '',
    duration: 0,
    title: '',
    dateTaken: 0,
    dateAdded: 0,
    uri: '',
    displayName: '',
    dateModified: 0
  };
  @Provide targetMediaDetails: MediaDetails = {
    mediaType: 0,
    height: 0,
    width: 0,
    size: 0,
    path: '',
    duration: 0,
    title: '',
    dateTaken: 0,
    dateAdded: 0,
    uri: '',
    displayName: '',
    dateModified: 0
  };
  @Provide multiSelectDetails: MultiSelectDetails = {
    count: 0,
    size: 0,
  };
  @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = screenManager.isSidebar();
  dialogController?: CustomDialogController ;
  multiSelectDialog?: CustomDialogController ;
  deleteDialogController?: CustomDialogController ;
  deleteProgressDialogController?: CustomDialogController ;
  progressDialogController?: CustomDialogController ;
  cancelDialogController?: CustomDialogController ;
  renameFileDialogController?: CustomDialogController ;
  saveDialogController?: CustomDialogController ;
  addNotesDialogController?: CustomDialogController ;
  newAlbumDialogController?: CustomDialogController ;
  findSameNameDialog?: CustomDialogController ;
  saveImageDialogController?: CustomDialogController ;

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    this.dialogController = undefined;
    this.multiSelectDialog = undefined;
    this.deleteDialogController = undefined;
    this.deleteProgressDialogController = undefined;
    this.progressDialogController = undefined;
    this.cancelDialogController = undefined;
    this.renameFileDialogController = undefined;
    this.saveDialogController = undefined;
    this.addNotesDialogController = undefined;
    this.newAlbumDialogController = undefined;
    this.findSameNameDialog = undefined;
    this.saveImageDialogController = undefined;
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    let self = this;
    this.dialogController = new CustomDialogController({
      builder: DetailsDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.multiSelectDialog = new CustomDialogController({
      builder: MultiSelectDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.deleteDialogController = new CustomDialogController({
      builder: DeleteDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.deleteProgressDialogController = new CustomDialogController({
      builder: DeleteProgressDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.progressDialogController = new CustomDialogController({
      builder: ProgressDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.cancelDialogController = new CustomDialogController({
      builder: CancelOperationDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.renameFileDialogController = new CustomDialogController({
      builder: RenameDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.saveDialogController = new CustomDialogController({
      builder: SaveDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });
    this.addNotesDialogController = new CustomDialogController({
      builder: AddNotesDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });
    this.newAlbumDialogController = new CustomDialogController({
      builder: NewAlbumDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.findSameNameDialog = new CustomDialogController({
      builder: FindSameNameDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      offset: {
        dx: 0,
        dy: this.isHorizontal || this.isSidebar ? 0 : $r('app.float.dialog_offset_bottom')
      },
      customStyle: true
    });
    this.saveImageDialogController = new CustomDialogController({
      builder: SaveImageDialog(),
      autoCancel: false,
      alignment: this.isHorizontal || this.isSidebar ? DialogAlignment.Center : DialogAlignment.Bottom,
      customStyle: true
    });

    this.broadCast.on(BroadcastConstants.SHOW_DETAIL_DIALOG, (item: UserFileDataItem): void => {
      this.showDetailDialog(item)
    });

    this.broadCast.on(BroadcastConstants.SHOW_MULTI_SELECT_DIALOG,
      (count: number, size: number): void => {
        Log.info(TAG, 'SHOW_MULTI_SELECT_DIALOG ');
        self.multiSelectDetails = {
          size: size,
          count: count
        };

        self.multiSelectDialog?.open();
      });

    this.broadCast.on(BroadcastConstants.SHOW_DELETE_DIALOG,
      (deleteMessage: Resource, dialogDeleteMessage: Resource, confirmCallback: Function|null, cancelCallback?: Function): void => {
        Log.info(TAG, 'SHOW_DELETE_DIALOG ');
        self.dialogMessage = deleteMessage;
        self.dialogDeleteMessage = dialogDeleteMessage;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.deleteDialogController?.open();
      });
    this.broadCast.on(BroadcastConstants.SHOW_RENAME_PHOTO_DIALOG,
      (fileName: string, confirmCallback: Function, cancelCallback?: Function): void => {
        Log.info(TAG, 'SHOW_RENAME_PHOTO_DIALOG ');
        self.renameFileName = fileName;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.renameFileDialogController?.open();
      });

    this.broadCast.on(BroadcastConstants.SHOW_ADD_NOTES_PHOTO_DIALOG,
      (confirmCallback: Function, cancelCallback?: Function): void => {
        Log.info(TAG, 'SHOW_ADD_NOTES_PHOTO_DIALOG ');
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.addNotesDialogController?.open();
      });

    this.broadCast.on(BroadcastConstants.SHOW_PROGRESS_DIALOG,
      (message: Resource, operationType: string, cancelFunc?: Function): void => {
        Log.info(TAG, 'SHOW_PROGRESS_DIALOG');
        if (message != null) {
          self.progressMessage = message;
        }

        if (operationType != null) {
          self.progressParam.operationType = operationType;
        }

        if (cancelFunc != null) {
          self.progressParam.cancelFunc = cancelFunc;
        }

        self.progressDialogController?.open();
      });

    this.broadCast.on(BroadcastConstants.UPDATE_PROGRESS,
      (progress: number, currentCount: number): void => {
         Log.info(TAG, 'UPDATE_PROGRESS ' + progress + ', ' + currentCount);
        self.deleteProgress = progress;
        self.deleteProgressParam.deleteProgress = progress;
        self.deleteProgressParam.currentCount = currentCount;
        if (progress === Constants.PROGRESS_MAX) {
          Log.info(TAG, 'Update progress 100%');
          self.progressDialogController?.close();
          self.deleteProgress = 0;
          self.deleteProgressParam.deleteProgress = 0;
          self.deleteProgressDialogController?.close();
          self.deleteProgressParam.currentCount = 0;
        }
      });

    this.broadCast.on(BroadcastConstants.CANCEL_OPERATE,
      (cancelMessage: Resource, continueFunc: Function, cancelFunc: Function): void => {
        self.cancelMessage = cancelMessage;
        self.cancelParam.continueFunc = continueFunc;
        self.cancelParam.cancelFunc = cancelFunc;
        Log.info(TAG, 'CANCEL_OPERATE');
        self.cancelDialogController?.open();
      });

    this.broadCast.on(BroadcastConstants.SHOW_SAVE_PHOTO_DIALOG,
      (saveAsNewCallback: Function, replaceOriginalCallback: Function): void => {
        Log.info(TAG, 'SHOW_SAVE_PHOTO_DIALOG');
        self.saveDialogCallback
        = { saveAsNewCallback: saveAsNewCallback, replaceOriginalCallback: replaceOriginalCallback };
        self.saveDialogController?.open();
      });

    this.broadCast.on(BroadcastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
      (fileName: string, confirmCallback: Function, cancelCallback?: Function): void => {
        Log.info(TAG, 'SHOW_NEW_ALBUM_PHOTO_DIALOG');
        self.renameFileName = fileName;
        self.dialogCallback = { confirmCallback: confirmCallback, cancelCallback: cancelCallback };
        self.newAlbumDialogController?.open();
      });

    this.broadCast.on(BroadcastConstants.FIND_SAME_FILE_DIALOG,
      (assets: Assets, count: number, replaceFunc: Function, skipFunc: Function,
            cancelFunc: Function, doSameFunc: Function): void => {
        Log.info(TAG, 'FIND_SAME_FILE_DIALOG');
        self.findSameNameParam.sourceFileAsset = assets.sourceAsset;
        self.findSameNameParam.targetFileAsset = assets.targetAsset;
        self.findSameNameParam.replaceFunc = replaceFunc;
        self.findSameNameParam.skipFunc = skipFunc;
        self.findSameNameParam.cancelFunc = cancelFunc;
        self.findSameNameParam.singlePhoto = (count == 1);
        self.findSameNameParam.doSameFunc = doSameFunc;
        self.findSameNameDialog?.open();
      });

    this.broadCast.on(BroadcastConstants.DELETE_PROGRESS_DIALOG,
      (message: Resource, totalCount: number): void => {
        Log.info(TAG, 'DELETE_PROGRESS_DIALOG');
        self.deleteProgressParam.currentCount = 0;
        self.deleteProgressParam.totalCount = totalCount;
        self.deleteProgressParam.message = message;
        self.deleteProgress = 0;
        self.deleteProgressParam.deleteProgress = 0;
        self.deleteProgressDialogController?.open();
      });
  }

  private showDetailDialog(item: UserFileDataItem): void {
    Log.info(TAG, 'SHOW_DETAIL_DIALOG ');
    item.load(true).then<void, void>((): void => {
      this.mediaDetails = {
        mediaType: item.mediaType,
        height: item.height,
        width: item.width,
        size: item.size,
        path: item.path,
        duration: item.duration,
        title: item.title,
        dateTaken: item.dateTaken,
        dateAdded: item.dateAdded,
        uri: item.uri,
        displayName: item.displayName,
        dateModified: item.dateModified
      };
      this.dialogController?.open();
    })
  }

  build() {
  }
}
