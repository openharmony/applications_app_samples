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
import { SimpleItem } from './ListComponents';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import { Logger } from '@ohos/common';


/**
 * 设置-软件升级项
 */
@Builder
export function UpgradePageItem() {
  UpgradeItem();
}

/**
 * 设置-软件升级项UI组件
 */
@Component
struct UpgradeItem {
  appId: string = '';

  startAppGalleryDetailAbility(): void {
    const want: Want = {
      uri: `store://appgallery.huawei.com`
    };
    const context = getContext(this) as common.UIAbilityContext;
    context.startAbility(want).then(() => {
      Logger.info('start appgallery success');
    }).catch((err: BusinessError) => {
      Logger.info(`start appgallery error,code:${err.code},msg:${err.message}`);
    });
  }

  build() {
    Column() {
      SimpleItem({ name: $r('app.string.page_settings_upgrade') });
    }.onClick(() => {
      this.startAppGalleryDetailAbility();
    });
  }
}