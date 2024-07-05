/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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
import DateTimeUtil from '../model/DateTimeUtil';
import MediaManager from './MediaManager';

const dateTimeUtil = new DateTimeUtil();

@Observed
export class Record {
  fileAsset: userFileManager.FileAsset | undefined = undefined;
  title: string = '';
  duration: string = '';
  dateTime: string = '0';
  isCheck: boolean = false;
  context: Context | undefined = undefined;

  constructor(context: Context) {
    this.context = context;
  }

  async init(fileAsset: userFileManager.FileAsset | undefined, isCheck: boolean) {
    this.fileAsset = fileAsset;
    if (fileAsset && this.context) {
      this.dateTime = fileAsset.get('date_added') as string;
      let duration = fileAsset.get('duration') as number;

      if (duration > 0) {
        this.duration = dateTimeUtil.getDurationString(Number(duration));
      } else {
        let mediaManager = new MediaManager(this.context);
        this.duration = await mediaManager.getFileDuration(fileAsset.displayName);
      }
      this.title = fileAsset.displayName;
    } else {
      this.duration = '00:00';
      this.title = '';
    }
    this.isCheck = isCheck;
  }
}