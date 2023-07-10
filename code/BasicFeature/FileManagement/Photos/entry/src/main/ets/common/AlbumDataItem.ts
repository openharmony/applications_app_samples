/*
 * Copyright (c) 2022 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import userFileManager from '@ohos.filemanagement.userFileManager';
import { userFileModel } from '../base/UserFileModel';
import { selectManager } from './SelectManager';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

const TAG = "AlbumDataItem"

let objectIndex = 0

export class AlbumDataItem {
    index: number;
    id: string;
    uri: string;
    orientation: number;
    displayName: string;
    count: number;
    isDisableRename: boolean;
    isDisableDelete: boolean;
    innerId: number;
    selectType: number = MediaConstants.SELECT_TYPE_ALL;
    deviceId: string = "";
    isSelect: boolean = false;
    status: number = MediaConstants.UNDEFINED;
    objectIndex: number;
    albumType:number;
    albumSubType:number;
    fileUir:string

    constructor(id: string, count: number, displayName: string, selectType: number, deviceId: string,albumType:number,albumSubType:number) {
        this.id = id;
        this.displayName = displayName;
        this.count = count;
        this.isDisableRename = MediaConstants.ALBUM_DISABLE_RENAME_LIST.has(id);
        this.isDisableDelete = MediaConstants.ALBUM_DISABLE_DELETE_LIST.has(id);
        this.selectType = selectType;
        this.deviceId = deviceId;
        this.objectIndex = objectIndex++;
        this.albumType = albumType;
        this.albumSubType = albumSubType;
    }

    getHashCode(): string {
        return this.objectIndex + "" + this.id + " " + this.orientation + " " + this.isSelect
    }

    async load(): Promise<void> {
        if (this.status >= MediaConstants.LOADED) {
            return;
        }
        let fileAsset = (await userFileModel.getMediaItemByUri(this.fileUir));
        this.update(fileAsset);
    }

    update(fileAsset: userFileManager.FileAsset): void {
        Log.info(TAG, "this.uri " + this.displayName);
        Log.info(TAG, "this.uri " + this.uri);
        if (fileAsset!=null){
            this.fileUir = fileAsset.uri;
            Log.info(TAG, "this.fileUri " + this.fileUir);
        }
        this.status = MediaConstants.LOADED;
        this.isSelect = selectManager.isSelect(this.id, this.isSelect);
    }

    getThumbnail(): string {
        Log.debug(TAG, "this.uri " + this.uri);
        return this.fileUir + "/thumbnail/256/256";
    }

    async getVideoCount(): Promise<number> {
        if (this.selectType == MediaConstants.SELECT_TYPE_IMAGE) {
            return 0;
        }
        let fileAssets: userFileManager.FileAsset[] = [];
        let predicates = new dataSharePredicates.DataSharePredicates();
        predicates.equalTo("file_type",userFileManager.FileType.VIDEO)
        let fileFetchOption = {
            fetchColumns: MediaConstants.FILE_ASSET_FETCH_COLUMNS,
            predicates: predicates
        };
        fileAssets = await userFileModel.getAllMediaItemsByType(this.albumType, this.albumSubType,null,fileFetchOption)
        return fileAssets.length;
    }

    setSelect(isSelect: boolean): void {
        this.isSelect = isSelect;
        selectManager.setSelect(this.id, this.isSelect);
    }

    async onDelete(): Promise<boolean> {
        try {
            Log.error(TAG, this.displayName)
            await userFileModel.deleteAlbum(this.displayName);
            selectManager.deleteSelect(this.uri);
            this.status = MediaConstants.TRASHED;
            return true;
        } catch (err) {
            Log.error(TAG, "onDelete error: " + JSON.stringify(err));
            return false;
        }
    }

    isDeleted(): boolean {
        return this.status == MediaConstants.TRASHED;
    }
}
