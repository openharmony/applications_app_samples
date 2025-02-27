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

import { TipsDialog } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { logger } from '../common/util/Logger';

/**
 * 权限引导弹窗
 */
@CustomDialog
export struct CommonTipsDialog {
  @Link isDialogShow: boolean;
  dialogController?: CustomDialogController;

  build() {
    TipsDialog({
      title: $r('app.string.custom_scan_tips_camera_permissions_reason'),
      content: $r('app.string.custom_scan_access_tips'),
      primaryButton: {
        value: $r('app.string.custom_scan_cancel'),
        action: () => {
          this.closeDialog();
        },
      },
      secondaryButton: {
        value: $r('app.string.custom_scan_access_setting'),
        action: () => {
          this.openPermissionsInSystemSettings();
        }
      },
    })
  }

  /**
   * 关闭弹窗
   */
  closeDialog(): void {
    logger.info('Start to close dialog.');
    if (this.isDialogShow && this.dialogController !== undefined) {
      this.isDialogShow = false;
      this.dialogController.close();
      logger.info('Succeeded in closing dialog.');
    }
  }

  /**
   * 拉起设置指定应用页面弹窗
   */
  openPermissionsInSystemSettings(): void {
    logger.info('Start to open permissions in system settings.');
    let context = getContext(this) as common.UIAbilityContext;
    let wantInfo: Want = {
      bundleName: 'com.huawei.hmos.settings',
      abilityName: 'com.huawei.hmos.settings.MainAbility',
      uri: 'application_info_entry',
      parameters: {
        settingsParamBundleName: 'com.north.cases' // 当前应用包名
      }
    };
    try {
      context.startAbility(wantInfo).then(() => {
        logger.info('Succeeded in starting ability.');
      }).catch((error: BusinessError) => {
        logger.error(`Failed to start ability by promise. Code: ` + error.code);
      })
    } catch (error) {
      logger.error(`Failed to start ability by catch. Code: ` + error.code);
    }

  }
}
