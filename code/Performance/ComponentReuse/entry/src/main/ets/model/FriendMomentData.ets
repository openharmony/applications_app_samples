/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { BasicDataSource, FriendMoment } from './BasicDataSource';
import { util } from '@kit.ArkTS';
import { Constants } from '../common/Constants';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class FriendMomentsData extends BasicDataSource<FriendMoment> {
  private friendMoments: Array<FriendMoment> = [];
  private mode: string | undefined = '';
  private context: Context | undefined = undefined;

  constructor(context?: Context,mode?: string) {
    super();
    this.context = context;
    this.mode = mode;
  }

  public totalCount(): number {
    return this.friendMoments.length;
  }

  public getData(index: number): FriendMoment {
    if (index === this.friendMoments.length - 1) {
      this.getFriendMomentFromRawFile();
    }
    return this.friendMoments[index];
  }

  public pushData(data: FriendMoment): void {
    this.friendMoments.push(data);
    this.notifyDataAdd(this.friendMoments.length - 1);
  }

  public async getFriendMomentFromRawFile(): Promise<void> {
    const resourceManager = this.context!.resourceManager;
    try {
      const res = await resourceManager.getRawFileContent('mockFriendMomentOneModelData.json');
      const textDecoder = util.TextDecoder.create();
      const friendMomentArray = (JSON.parse(textDecoder.decodeToString(res)) as FriendMomentsData).friendMoments;
      friendMomentArray.forEach(item => {
        if (item.id) {
          item.id = Math.floor(this.totalCount() / 10) + item.id;
        }
        item.userName = resourceManager.getStringSync($r('app.string.userName').id, parseInt(item.id) + 1);
        if (this.mode === Constants.NAV_DESTINATION_ITEM_3 || this.mode === Constants.NAV_DESTINATION_ITEM_3_1) {
          item.text = resourceManager.getStringSync($r('app.string.with_func_title').id, parseInt(item.id) + 1);
        } else {
          item.text = resourceManager.getStringSync($r('app.string.jump_text_one').id, parseInt(item.id) + 1);
        }
        this.pushData(item);
      })
    } catch (e) {
      let err = e as BusinessError;
      hilog.error(0x0000, 'testTag', `failed code=${err.code}, message=${err.message}`);
    }
  }
}