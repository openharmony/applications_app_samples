/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';

const LENGTH_START: number = 0;
const LENGTH: number = 9;

export default class GetPictures {
  async getImage(): Promise<void> {
    let mContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    let abilityResult: common.AbilityResult = await mContext.startAbilityForResult(
      {
        bundleName: 'com.ohos.photos',
        abilityName: 'com.ohos.photos.MainAbility',
        parameters: {
          uri: 'multipleselect',
          filterMediaType: 'FILTER_MEDIA_TYPE_IMAGE',
          maxSelectCount: LENGTH
        }
      }
    );
    let want: Want | undefined = abilityResult.want;
    if (want !== null && want !== undefined) {
      let param: Want | undefined = want.parameters;
      if (param !== null && param !== undefined) {
        let result: Array<string> = param['select-item-list'] as Array<string>;
        let select: Array<string> = [];
        if (result.length === LENGTH) {
          for (let i: number = LENGTH_START; i < LENGTH; i++) {
            select.push(result[i]);
          }
        } else {
          result.forEach(item => {
            select.push(item);
          })
        }
        let imageList:Array<string> = AppStorage.Get('imageList') as Array<string>;
        AppStorage.SetOrCreate<Array<string>>('imageList', imageList.concat(select));
      }
    }
  }
}