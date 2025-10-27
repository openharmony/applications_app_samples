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

import { BusinessError, request } from '@kit.BasicServicesKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';

import { bundleManager } from '@kit.AbilityKit';
import { abilityAccessCtrl, Context, PermissionRequestResult, common } from '@kit.AbilityKit';
import { logger } from '../../utils/Logger';

const TAG: string = 'MediaDownload';

class MediaDownload {
  // [Start media_user_file_download]
  async mediaFileAgentTask(url: string, callback: (progress: number, isSuccess: boolean) => void,
    context: common.UIAbilityContext) {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    // 获取应用程序的accessTokenID。
    let tokenID = -1;
    try {
      await bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
        logger.info(TAG, `Request getBundleInfoForSelf successfully. Data: ${JSON.stringify(data)}`);
        tokenID = data.appInfo.accessTokenId;
      }).catch((err: BusinessError) => {
        logger.error(TAG, `GetBundleInfoForSelf failed, code=${err.code}, message=${err.message}`);
      });
    } catch (err) {
      let message = (err as BusinessError).message;
      logger.error(`GetBundleInfoForSelf failed: ${message}`);
    }

    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let grant = true;
    // 校验应用是否授予权限。使用Promise异步回调。
    await atManager.checkAccessToken(tokenID, 'ohos.permission.WRITE_IMAGEVIDEO')
      .then((data: abilityAccessCtrl.GrantStatus) => {
        logger.info(TAG, `Request checkAccessToken success, data->${JSON.stringify(data)}`);
        if (data != abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
          grant = false;
        }
      })
      .catch((err: BusinessError) => {
        logger.error(TAG, `CheckAccessToken fail, code=${err.code}, message=${err.message}`);
      });

    if (!grant) {
      // 用于UIAbility拉起弹框请求用户授权。使用callback异步回调。
      await atManager.requestPermissionsFromUser(context, ['ohos.permission.WRITE_IMAGEVIDEO'])
        .then((data: PermissionRequestResult) => {
          logger.info(TAG, `Request grant: ${JSON.stringify(data)}`);
          logger.info(TAG, `Request grant permissions: ${data.permissions}`);
          logger.info(TAG, `Request grant authResults: ${data.authResults}`);
          logger.info(TAG, `Request grant dialogShownResults: ${data.dialogShownResults}`);
        }).catch((err: BusinessError) => {
          logger.error(TAG, `Grant error, code=${err.code}, message=${err.message}`);
        });
    }

    try {
      let photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;
      let extension: string = 'jpg';
      let options: photoAccessHelper.CreateOptions = {
        title: 'media'
      }
      // 获取相册管理模块的实例，用于访问和修改相册中的媒体文件。
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      // 指定文件类型、后缀和创建选项，创建图片或视频资源，以Promise方式返回结果。
      let uri: string = await phAccessHelper.createAsset(photoType, extension, options);
      logger.info(TAG, `Request createAsset uri ${uri}`);

      let config: request.agent.Config = {
        action: request.agent.Action.DOWNLOAD,
        url: url,
        // saveas字段是PhotoAccessHelper保存的文件的uri
        saveas: uri,
        gauge: true,
        // overwrite字段必须为true
        overwrite: true,
        network: request.agent.Network.WIFI,
        // mode字段必须为request.agent.Mode.FOREGROUND
        mode: request.agent.Mode.FOREGROUND,
      };
      request.agent.create(context, config).then((task: request.agent.Task) => {
        task.start((err: BusinessError) => {
          if (err) {
            logger.error(TAG, `Failed to start the download task, Code: ${err.code}  message: ${err.message}`);
            return;
          }
        });
        task.on('progress', async (progress) => {
          logger.info(TAG, `Request download status ${progress.state}, downloaded ${progress.processed}`);
        })
        task.on('completed', async (progress) => {
          logger.info(TAG, `Request download completed, ${JSON.stringify(progress)}`);
          callback(100, true);
          //该方法需用户管理任务生命周期，任务结束后调用remove释放task对象
          request.agent.remove(task.tid);
        })
      }).catch((err: BusinessError) => {
        logger.error(TAG, `Failed to operate a download task, Code: ${err.code}, message: ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      logger.error(TAG, `Failed to create a media download task, code=${err.code}, message=${err.message}`);
    }
  }

  // [End media_user_file_download]
}

export const mediaDownload = new MediaDownload();