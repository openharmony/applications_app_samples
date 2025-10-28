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

// [Start data_sync_on_distributed_data_object_cross_device_migration_one]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { commonType, distributedDataObject } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

// 业务数据定义
export class ContentInfo {
  public mainTitle: string | undefined;
  public textContent: string | undefined;
  public imageUriArray: Array<ImageInfo> | undefined;
  public isShowLocalInfo: boolean | undefined;
  public isAddLocalInfo: boolean | undefined;
  public selectLocalInfo: string | undefined;
  public attachments?: commonType.Assets | undefined;

  constructor(
    mainTitle: string | undefined,
    textContent: string | undefined,
    imageUriArray: Array<ImageInfo> | undefined,
    isShowLocalInfo: boolean | undefined,
    isAddLocalInfo: boolean | undefined,
    selectLocalInfo: string | undefined,
    attachments?: commonType.Assets | undefined
  ) {
    this.mainTitle = mainTitle;
    this.textContent = textContent;
    this.imageUriArray = imageUriArray;
    this.isShowLocalInfo = isShowLocalInfo;
    this.isAddLocalInfo = isAddLocalInfo;
    this.selectLocalInfo = selectLocalInfo;
    this.attachments = attachments;
  }

  flatAssets(): object {
    let obj: object = this;
    if (!this.attachments) {
      return obj;
    }
    for (let i = 0; i < this.attachments.length; i++) {
      obj[`attachments${i}`] = this.attachments[i];
    }
    return obj;
  }
}
// [End data_sync_on_distributed_data_object_cross_device_migration_one]
// [Start data_sync_on_distributed_data_object_cross_device_migration_two]

export interface ImageInfo {
  /**
   * image PixelMap.
   */
  imagePixelMap: PixelMap;

  /**
   * Image name.
   */
  imageName: string;
}

const DOMAIN: number = 0x0000;
const TAG: string = '[DistributedDataObject]';
let dataObject: distributedDataObject.DataObject;

export default class EntryAbility extends UIAbility {
  private imageUriArray: Array<ImageInfo> = [];
  private distributedObject: distributedDataObject.DataObject | undefined = undefined;

  // 1. 迁移发起端在onContinue接口中创建分布式数据对象并保存数据到接收端
  async onContinue(wantParam: Record<string, Object | undefined>): Promise<AbilityConstant.OnContinueResult> {
    // 1.1 获取需要设置的分布式对象的资产关键uri
    try {
      let sessionId: string = distributedDataObject.genSessionId();
      wantParam.distributedSessionId = sessionId;

      let distrUriArray: string[] = [];
      let assetUriArray = AppStorage.get<Array<string>>('assetUriArray');
      if (assetUriArray) {
        distrUriArray = assetUriArray;
      }
      // 1.2 创建分布式数据对象
      let contentInfo: ContentInfo = new ContentInfo(
        AppStorage.get('mainTitle'),
        AppStorage.get('textContent'),
        AppStorage.get('imageUriArray'),
        AppStorage.get('isShowLocalInfo'),
        AppStorage.get('isAddLocalInfo'),
        AppStorage.get('selectLocalInfo'),
      );
      let source = contentInfo.flatAssets();
      this.distributedObject = distributedDataObject.create(this.context, source);
      // [End data_sync_on_distributed_data_object_cross_device_migration_two]
      // [Start data_sync_on_distributed_data_object_cross_device_migration_three]

      // 1.3 将需要设置的分布式对象的资产或资产数组填充完成
      if (assetUriArray?.length === 1) {
        this.distributedObject?.setAsset('attachments', distrUriArray[0]).then(() => {
          hilog.info(DOMAIN, TAG, 'OnContinue setAsset');
        })
      } else {
        this.distributedObject?.setAssets('attachments', distrUriArray).then(() => {
          hilog.info(DOMAIN, TAG, 'OnContinue setAssets');
        })
      }
      // 1.4 将设置的资产或资产数组保存至迁移发起端
      this.distributedObject?.setSessionId(sessionId);
      this.distributedObject?.save(wantParam.targetDevice as string).catch((err: BusinessError) => {
        hilog.error(DOMAIN, TAG, 'OnContinue failed to save. code: ', err.code);
        hilog.error(DOMAIN, TAG, 'OnContinue failed to save. message: ', err.message);
      });
    } catch (error) {
      hilog.error(DOMAIN, TAG, 'OnContinue failed code: ', error.code);
      hilog.error(DOMAIN, TAG, 'OnContinue failed message: ', error.message);
    }
    hilog.info(DOMAIN, TAG, 'OnContinue success!');
    return AbilityConstant.OnContinueResult.AGREE;
  }

  // 2. 接收端在onCreate和onNewWant接口中创建分布式数据对象并加入组网进行数据恢复
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      if (want.parameters && want.parameters.distributedSessionId) {
        this.restoreDistributedObject(want);
      }
    }
  }

  // 2. 接收端在onCreate和onNewWant接口中创建分布式数据对象并加入组网进行数据恢复
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (launchParam.launchReason === AbilityConstant.LaunchReason.CONTINUATION) {
      if (want.parameters && want.parameters.distributedSessionId) {
        this.restoreDistributedObject(want);
      }
    }
  }
  // [End data_sync_on_distributed_data_object_cross_device_migration_three]
  // [Start data_sync_on_distributed_data_object_cross_device_migration_four]

  async restoreDistributedObject(want: Want): Promise<void> {
    if (!want.parameters || !want.parameters.distributedSessionId) {
      hilog.error(DOMAIN, TAG, 'missing sessionId');
      return;
    }

    // 2.1 调用create接口创建并得到一个分布式数据对象实例
    let mailInfo: ContentInfo = new ContentInfo(undefined, undefined, [], undefined, undefined, undefined, undefined);
    dataObject = distributedDataObject.create(this.context, mailInfo);

    // 2.2 注册恢复状态监听。收到状态为'restored'的回调通知时，表示接收端分布式数据对象已恢复发起端保存过来的数据（有资产数据时，对应的文件也迁移过来了）
    dataObject.on('status', (sessionId: string, networkId: string, status: string) => {
      hilog.info(DOMAIN, TAG, `status change, sessionId:  ${sessionId}`);
      hilog.info(DOMAIN, TAG, `status change, networkId:  ${networkId}`);
      if (status === 'restored') { // 收到'restored'的状态通知表示已恢复发起端保存的数据
        hilog.info(DOMAIN, TAG, `title: ${dataObject['title']}, text: ${dataObject['text']}`);
        AppStorage.setOrCreate('mainTitle', dataObject['mainTitle']);
        AppStorage.setOrCreate('textContent', dataObject['textContent']);
        AppStorage.setOrCreate('imageUriArray', dataObject['imageUriArray']);
        AppStorage.setOrCreate('isShowLocalInfo', dataObject['isShowLocalInfo']);
        AppStorage.setOrCreate('isAddLocalInfo', dataObject['isAddLocalInfo']);
        AppStorage.setOrCreate('selectLocalInfo', dataObject['selectLocalInfo']);
        AppStorage.setOrCreate<Array<ImageInfo>>('imageUriArray', this.imageUriArray);
      }
    });

    // 2.3 从want.parameters中获取发起端放入的sessionId，调用setSessionId接口设置同步的sessionId
    let sessionId = want.parameters.distributedSessionId as string;
    hilog.info(DOMAIN, TAG, `get sessionId: ${sessionId}`);
    dataObject.setSessionId(sessionId);
  }
}

// [End data_sync_on_distributed_data_object_cross_device_migration_four]