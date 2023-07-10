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
import { Log } from '../utils/Log';
import { ViewType } from '../models/ViewType';
import { userFileModel } from './UserFileModel';
import { MediaConstants } from '../constants/MediaConstants';
import { setOrientation } from './UserFileDataHelper';
import { selectManager } from '../common/SelectManager';
import userFileManager from '@ohos.filemanagement.userFileManager';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import { screenManager } from '../common/ScreenManager';

const TAG = "UserFileDataItem"
const STATUS_UNDEFINED = -1
const STATUS_FALSE = 0
const STATUS_TRUE = 1

export interface DateAdded {
    dateAdded: number;
    viewType: ViewType;
}

export class UserFileDataItem implements DateAdded {
    viewType: ViewType = ViewType.ITEM
    readonly hashIndex: number
    index: number
    dateAdded: number | null = null
    dateModified: number
    dateTaken: number
    status: number = MediaConstants.UNDEFINED
    isSelect: boolean = false
    uri: string
    orientation: number
    duration: number
    size: number
    width: number; // width changed by orientation
    height: number; // height changed by orientation
    imgWidth: number; // may be smaller than width, as width is too large
    imgHeight: number; // may be smaller than height, as height is too large
    path: string = ''
    title: string
    displayName: string
    mediaType: userFileManager.FileType
    favouriteStatus: number = STATUS_UNDEFINED
    canRotate: number = STATUS_UNDEFINED
    selections: string = ""
    selectionArgs: string[] = [];
    deviceId: string = ''

    constructor(selections: string, selectionArgs: string[], deviceId: string, index: number) {
        this.selections = selections
        this.selectionArgs = selectionArgs
        this.deviceId = deviceId
        this.hashIndex = index
        this.index = index
    }

    getHashCode(): string {
        //时间线界面角度，收藏状态变更，都需要刷新界面；大图浏览界面角度变更，需要刷新界面
        return this.status == MediaConstants.UNDEFINED ?
                "" + this.hashIndex :
                this.uri + this.favouriteStatus + " " + this.orientation + " " + this.isSelect
    }

    async loadFileAsset(): Promise<userFileManager.FileAsset> {
        return await userFileModel.getMediaItemByUri(this.uri)
    }

    isLoad():boolean {
        if (this.status > MediaConstants.UNDEFINED) {
            return true
        }
        return false
    }

    async load(isForce: boolean): Promise<void> {
        Log.info(TAG, "load " + this.status)
        if (this.status > (isForce ? MediaConstants.PART_LOADED : MediaConstants.UNDEFINED)) {
            return
        }
        let fileAsset = await this.loadFileAsset()
        if (fileAsset != null) {
            this.update(fileAsset)
        }
        return
    }

    update(fileAsset: userFileManager.FileAsset): void {
        this.uri = fileAsset.uri;
        this.displayName = fileAsset.displayName;
        this.mediaType = fileAsset.fileType;
        this.width  = screenManager.getWinWidth();
        this.height = screenManager.getWinHeight();
        this.orientation = MediaConstants.ROTATE_NONE
        try{
            this.orientation = fileAsset.get(userFileManager.ImageVideoKey.ORIENTATION.toString()) as number;
        }catch (err) {
            Log.error(TAG, "get orientation " + JSON.stringify(err));
        }
        try{
            this.duration = fileAsset.get(userFileManager.ImageVideoKey.DURATION.toString()) as number;
        }catch (err) {
            Log.error(TAG, "get duration " + JSON.stringify(err));
        }
        try{
            if (this.orientation == MediaConstants.ROTATE_ONCE || this.orientation == MediaConstants.ROTATE_THIRD) {
                this.width = fileAsset.get(userFileManager.ImageVideoKey.HEIGHT.toString()) as number;
                this.height = fileAsset.get(userFileManager.ImageVideoKey.WIDTH.toString()) as number;
            } else {
                this.width = fileAsset.get(userFileManager.ImageVideoKey.WIDTH.toString()) as number;
                this.height = fileAsset.get(userFileManager.ImageVideoKey.HEIGHT.toString()) as number;
            }
        }catch (err) {
            Log.error(TAG, "get width height " + JSON.stringify(err));
        }
        try{
            this.title = fileAsset.get(userFileManager.ImageVideoKey.TITLE.toString()) as string;
        }catch (err) {
            Log.error(TAG, "get title " + JSON.stringify(err));
        }
        try{
            this.dateAdded = fileAsset.get(userFileManager.ImageVideoKey.DATE_ADDED.toString()) as number* 1000;
            this.dateModified = fileAsset.get(userFileManager.ImageVideoKey.DATE_MODIFIED.toString()) as number* 1000;
            this.dateTaken = fileAsset.get(userFileManager.ImageVideoKey.DATE_TAKEN.toString()) as number* 1000;
        }catch (err) {
            Log.error(TAG, "get date " + JSON.stringify(err));
        }
        try{
            this.favouriteStatus = fileAsset.get(userFileManager.ImageVideoKey.FAVORITE.toString()) as boolean ? STATUS_TRUE : STATUS_FALSE
        }catch (err) {
            Log.error(TAG, "get favouriteStatus " + JSON.stringify(err));
        }
        this.isSelect = selectManager.isSelect(this.uri, this.isSelect);
        this.imgWidth = this.width;
        this.imgHeight = this.height;
        if (this.width > 0 && this.height > 0) {
            this.status = MediaConstants.LOADED;
        } else {
            this.status = MediaConstants.PART_LOADED;
        }
    }

    getThumbnail(width: number, height: number): string {
        Log.debug(TAG, "getThumbnail " + this.status);
        if (this.status != MediaConstants.LOADED && this.status != MediaConstants.PART_LOADED) {
            Log.warn(TAG, "getThumbnail fail as status: " + this.status);
            return "";
        }
        Log.debug(TAG, "this.uri " + this.uri);
        return this.uri + "/thumbnail/" + width + "/" + height;
    }

    getAlt(): Resource {
        if (this.mediaType == userFileManager.FileType.VIDEO) {
            return $r('app.media.alt_video_placeholder');
        } else {
            return $r('app.media.alt_placeholder');
        }
    }

    setSelect(isSelect: boolean): void {
        this.isSelect = isSelect;
        selectManager.setSelect(this.uri, this.isSelect);
    }

    async onDelete(): Promise<boolean> {
        try {
            userFileModel.deleteOne(this.uri)
            selectManager.deleteSelect(this.uri);
            this.status = MediaConstants.TRASHED;
            return true;
        } catch (err) {
            Log.error(TAG, "onDelete " + this.index + " error: " + JSON.stringify(err));
            return false;
        }
    }

    isDeleted(): boolean {
        return this.status == MediaConstants.TRASHED;
    }

    async isFavor(): Promise<boolean> {
        if (this.favouriteStatus == STATUS_UNDEFINED) {
            let fileAsset = await this.loadFileAsset();
            try{
                this.favouriteStatus = (fileAsset.get(userFileManager.ImageVideoKey.FAVORITE.toString()) as boolean) ? STATUS_TRUE : STATUS_FALSE;
            }catch (err){
                Log.error(TAG, "isFavor error: " + JSON.stringify(err));
            }
        }
        return this.favouriteStatus == STATUS_TRUE;
    }

    async setFavor(): Promise<boolean> {
        let status = !(await this.isFavor());
        try {
            let fileAsset = await this.loadFileAsset();
            await fileAsset.favorite(status);
            this.favouriteStatus = status ? STATUS_TRUE : STATUS_FALSE;
            return true;
        } catch (err) {
            return false;
        }
    }

    async setOrientation(): Promise<void> {
        let fileAsset = await this.loadFileAsset();
        this.orientation = (this.orientation + MediaConstants.ROTATE_ONCE) % MediaConstants.ROTATE_AROUND;
        await setOrientation(fileAsset, this.orientation);
        let tmp = this.width;
        this.width = this.height;
        this.height = tmp;
    }

    async setName(name: string): Promise<void> {
        let fileAsset = await this.loadFileAsset();
        let displayName = fileAsset.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);

        this.displayName = displayName;
        fileAsset.displayName = displayName;

        this.title = name;
        try{
            fileAsset.set(userFileManager.ImageVideoKey.TITLE.toString(),name);
        }catch (err){
            Log.error(TAG, "isFavor error: " + JSON.stringify(err));
        }
        await fileAsset.commitModify();
    }
}
