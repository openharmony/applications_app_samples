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
import { MLog } from '../../common/utils/MLog';
import { FileBean } from '../bean/FileBean';
import FileDataSource from './FileDataSource';


const TAG = 'ListPageAdapter';

export default class ListPageAdapter extends FileDataSource {

  constructor(ctx: Context) {
    super(ctx, [])
  }

  public pushRoot(beans: FileBean[]) {
    MLog.print(TAG, `pushRoot beans:${beans.length}`);
    this.push(beans);
  }

  public clear(): void {
    MLog.print(TAG, `ListPageAdapter clear`);
    super.clear();
    this.notifyDataReload();
  }




}