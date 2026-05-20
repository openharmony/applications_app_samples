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

import { DateTools } from '../../common/utils/DateTools';
import { FileInfo } from '../../common/data/FileInfo';
import { IsFile } from '../../common/utils/Tools';
import { MLog } from '../../common/utils/MLog';
import { checkSuffix, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT, SUFFIX_VIDEO } from '../../common/ConstantsMedia';
import { FileIoManager } from '../../common/manager/FileIoManager';

export class FileBean {
  private readonly _id: string;
  private _name: string;
  private path: string;
  public relativePath: string;
  private _isDir: boolean = false;
  private _size: number = 0;
  private _time: number = 0;
  private _timeStr: string = '';
  private mimeType: string = '';
  private mode: number = 0;
  private _isChecked: boolean = false;
  private deviceType: number = -1;
  private _fileType: number = -1;
  private _imageWidth: number = 0;
  private _imageHeight: number = 0;
  public isRoot: boolean = false;

  constructor(index?: string, info?: FileInfo) {
    if (info) {
      this._id = info.uri;
      this._name = info.fileName;
      this.path = info.uri;
      this.relativePath = info.relativePath;
      this._size = info.size;
      this._time = info.mtime;
      this.mimeType = info.mimeType;
      this.mode = info.mode;
      if (info.isRoot) {
        this.isRoot = info.isRoot;
      }
      if (info.deviceType !== undefined && info.deviceType >= 0) {
        this.deviceType = info.deviceType;
      }
    } else {
      let date: number = Date.now();
      this._id = `fake${index ?? ''}-${date}`;
      this._name = `fake${index ?? ''}-${date}`;
      this.path = `fake/${date}`;
      this.relativePath = `fake/relativePath/${date}`;
      this._isDir = true;
    }
  }

  public setFileType(type: number): FileBean {
    this._fileType = type;
    return this;
  }

  public isMediaFile(): boolean {
    return this._fileType > 0;
  }

  get id(): string {
    return this._id;
  }

  get size(): number {
    return this._size;
  }

  get time(): number {
    return this._time;
  }

  get timeStr(): string {
    if (!this._timeStr && this._time > 0) {
      this._timeStr = DateTools.formatDate(this._time, 'yyyy-MM-dd HH:mm:ss');
    }
    return this._timeStr;
  }

  set isChecked(check: boolean) {
    this._isChecked = check;
  }

  get isChecked(): boolean {
    return this._isChecked;
  }

  set name(str: string) {
    this._name = str;
  }

  get name(): string {
    return this._name;
  }

  get imageWidth(): number {
    return this._imageWidth;
  }

  get imageHeight(): number {
    return this._imageHeight;
  }

  public setImageDimensions(width: number, height: number): void {
    this._imageWidth = width;
    this._imageHeight = height;
  }

  public hasImageDimensions(): boolean {
    return this._imageWidth > 0 && this._imageHeight > 0;
  }

  public getPath(): string {
    return this.path;
  }

  public setPath(path: string): string {
    return this.path = path;
  }

  public updateDirType(): FileBean {
    try {
      FileIoManager.isDir(this.relativePath).then(ret => {
        MLog.print('FileBean',
          `FileIoManager isDir:${ret} uri:${this.path} relativePath:${this.relativePath}`);
        this._isDir = ret;
      });
    } catch (e) {
      MLog.printError('FileBean', `updateDirType error`, e);
    }
    return this;
  }

  public isFile(): boolean {
    return !this._isDir && IsFile(this.mode);
  }

  public isDir(): boolean {
    if (this.isDevice()) {
      return true;
    }
    return this._isDir;
  }

  public isDevice(): boolean {
    return this.deviceType >= 0;
  }

  public isMediaType(): boolean {
    return this.id.length === 1;
  }

  public toString(): string {
    return `[${this._id}] mimeType:${this.mimeType} ${this._name} - ${this.path} size:${this.size} time:${this.time} deviceType:${this.deviceType} mode:${this.mode} `;
  }

  public isVideo(): boolean {
    return checkSuffix(this.name, SUFFIX_VIDEO);
  }

  public isAudio(): boolean {
    return checkSuffix(this.name, SUFFIX_AUDIO);
  }

  public isImage(): boolean {
    return checkSuffix(this.name, SUFFIX_IMAGE);
  }

  public isDoc(): boolean {
    return checkSuffix(this.name, SUFFIX_TEXT);
  }
}
