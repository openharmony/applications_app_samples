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

import { BusinessError } from '@kit.BasicServicesKit';
import { common, abilityAccessCtrl } from '@kit.AbilityKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { fileIo as fs, ListFileOptions, fileUri, securityLabel } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import Logger from '../common/Logger';
import { showToast } from '../common/ShowToast';

const BUFFER: number = 4096; // 读写文件的缓冲区
const DELAY: number = 1000; // 延时1秒
const MARGIN: number = 5; // 组件的间隔

let context = getContext(this) as common.UIAbilityContext; // 获取UIAbilityContext信息
let pathDir: string = context.filesDir; // 应用沙箱路径
let distributedPathDir: string = context.distributedFilesDir; // 应用分布式路径
let atManager = abilityAccessCtrl.createAtManager();

// 定义访问公共文件目录的回调
let listeners: fs.DfsListeners = {
  onStatus: (networkId: string, status: number): void => {
    Logger.info('Failed to access public directory');
  }
}

// 设备A上在分布式路径下创建测试文件，并写入内容
function createFile(path: string, fileName: string): void {
  let filePath = path + '/' + fileName + '.txt';
  let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  setFileLv(filePath);
  showToast('Successfully created file of level s0', DELAY);
  fs.writeSync(file.fd, 'content OpenHarmony Distributed File System test');
  Logger.info('Succeeded in creating.');
  fs.closeSync(file.fd);
}

// 打开文件并设置文件数据等级为‘s0’
function setFileLv(path: string): void {
  let file = fs.openSync(path, fs.OpenMode.READ_ONLY);
  securityLabel.setSecurityLabel(path, 's0').then(() => {
    Logger.info('Successfully set the security label to s0.');
    fs.closeSync(file);
  }).catch((err: BusinessError) => {
    let error: BusinessError = err as BusinessError;
    console.error(`Failed to setSecurityLabel. Code: ${error.code}, message: ${error.message}`);
  });
}

// 申请多设备协同权限
async function applyPermission() {
  try {
    await atManager.requestPermissionsFromUser(context, ['ohos.permission.DISTRIBUTED_DATASYNC']).then((data) => {
      Logger.info('data: ' + JSON.stringify(data));
    }).catch((err: object) => {
      Logger.error('err: ' + JSON.stringify(err));
    })
  } catch (error) {
    Logger.error('catch err->' + JSON.stringify(error));
  }
}

// 设备B主动向设备A发起建链，建链成功后设备B可在分布式路径下读取测试文件
async function mountPublicDir() {
  // 通过分布式设备管理的接口获取设备A的networkId信息
  let dmInstance = distributedDeviceManager.createDeviceManager('ohos.samples.distributedmusicplayer');
  let deviceInfoList: distributedDeviceManager.DeviceBasicInfo[] = dmInstance.getAvailableDeviceListSync();
  let networkId = deviceInfoList[0].networkId; // 0表示可信设备列表中第一台设备
  // 访问并挂载公共文件目录
  fs.connectDfs(networkId, listeners).then(() => {
    Logger.info('Success to connectDfs');
    let context = getContext(); // 获取设备B的UIAbilityContext信息
    let distributedFilesDir: string = context.distributedFilesDir;
    // 获取分布式目录的文件路径
    let filePath: string = distributedFilesDir + '/distributedTest.txt';
    try {
      // 打开分布式目录下的文件
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      // 定义接收读取数据的缓存
      let arrayBuffer = new ArrayBuffer(BUFFER);

      // 读取文件的内容，返回值是读取到的字节个数
      class Option {
        public offset: number = 0; // 0表示从头开始读取文件内容
        public length: number = 0; // 读取的文件长度，初始化为0
      }

      let option = new Option();
      option.length = arrayBuffer.byteLength;
      let num = fs.readSync(file.fd, arrayBuffer, option);
      // 打印读取到的文件数据
      let buf = buffer.from(arrayBuffer, 0, num);
      Logger.info('read result: ' + buf.toString());
      showToast('Success to connectDfs', DELAY);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Failed to openSync / readSync. Code: ${err.code}, message: ${err.message}`);
    }
  }).catch((error: BusinessError) => {
    let err: BusinessError = error as BusinessError;
    Logger.error(`Failed to connectDfs Code: ${err.code}, message: ${err.message}`);
  });
}

// 取消公共文件目录挂载,断开链路。
function disMountPublicDir(): void {
  // 通过分布式设备管理的接口获取设备A的networkId信息
  let dmInstance = distributedDeviceManager.createDeviceManager('ohos.samples.distributedmusicplayer');
  let deviceInfoList: distributedDeviceManager.DeviceBasicInfo[] = dmInstance.getAvailableDeviceListSync();
  // 两台设备组网连接，deviceInfoList[0]即对应另一台设备
  let networkId = deviceInfoList[0].networkId;
  fs.disconnectDfs(networkId).then(() => {
    Logger.info('Success to disconnectDfs');
  }).catch((error: BusinessError) => {
    let err: BusinessError = error as BusinessError;
    Logger.error(`Failed to disconnectDfs Code: ${err.code}, message: ${err.message}`);
  })
}

// 将A设备的待拷贝沙箱文件，拷贝到A设备的分布式路径下。
function copySandFile(): void {
  // 待拷贝文件沙箱路径
  let filePath: string = pathDir + '/src.txt';
  try {
    // 文件不存在时，需要创建文件并写入内容
    let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    fs.writeSync(file.fd, 'Create file success');
    fs.closeSync(file);
  } catch (err) {
    let error: BusinessError = err as BusinessError;
    Logger.error(`Failed to createFile. Code: ${error.code}, message: ${error.message}`);
  }
  // 获取待拷贝文件uri
  let srcUri = fileUri.getUriFromPath(filePath);
  // 将待拷贝的沙箱文件，拷贝到分布式目录下
  let destUri: string = fileUri.getUriFromPath(distributedPathDir + '/src.txt');
  try {
    // 将沙箱路径下的文件拷贝到分布式路径下
    fs.copy(srcUri, destUri).then(() => {
      Logger.info('Succeeded in copying---. ');
      Logger.info('src: ' + srcUri + 'dest: ' + destUri);
      setFileLv(distributedPathDir + '/src.txt');
      showToast('Succeed copy from sandDir to distributedDir', DELAY);
    }).catch((error: BusinessError) => {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (err) {
    let error: BusinessError = err as BusinessError;
    Logger.error(`Failed to getData. Code: ${error.code}, message: ${error.message}`);
  }
}

// B设备在获取A端沙箱文件时，从B设备的分布式路径下将对应的文件拷贝走，以此完成跨设备拷贝。
function copyDistributedFile(): void {
  // 待拷贝文件的目标沙箱路径
  let filePath: string = pathDir + '/dest.txt';
  // 获取目标路径uri
  let destUri = fileUri.getUriFromPath(filePath);
  // 获取分布式路径下的源文件
  let srcUri: string = fileUri.getUriFromPath(distributedPathDir + '/src.txt');
  // 定义拷贝回调
  let progressListener: fs.ProgressListener = (progress: fs.Progress) => {
    Logger.info(`progressSize: ${progress.processedSize}, totalSize: ${progress.totalSize}`);
  };
  let options: fs.CopyOptions = {
    'progressListener': progressListener
  };
  try {
    // 将分布式路径下的文件拷贝到其他沙箱路径下
    fs.copy(srcUri, destUri, options).then(() => {
      Logger.info('Succeeded in copying of paste. ');
      showToast('Succeeded in copying of paste. ', DELAY);
      Logger.info('src: ' + srcUri + 'dest: ' + destUri);
    }).catch((error: BusinessError) => {
      let err: BusinessError = error as BusinessError;
      Logger.error(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (err) {
    let error: BusinessError = err as BusinessError;
    Logger.error(`Failed to copy. Code: ${error.code}, message: ${error.message}`);
  }
}

// 查看文件列表
function getListFile(pathDir: string): void {
  let listFileOption: ListFileOptions = {
    recursion: false,
    listNum: 0, // 0表示不限制列出的文件数量
    filter: {
      suffix: ['.png', '.jpg', '.txt', '.jpeg'],
      displayName: ['*'],
      fileSizeOver: 0, // 文件大小必须大于 0 字节
      lastModifiedAfter: new Date(0).getTime()
    }
  };
  let files = fs.listFileSync(pathDir, listFileOption);
  for (let i = 0; i < files.length; i++) {
    Logger.info(pathDir);
    Logger.info(`The name of file: ${files[i]}`);
  }
}

@Entry
@Component
struct Distributed {

  build() {
    Column() {
      Row() {
        Button($r('app.string.CreateFile'))
          .width('30%')
          .height('40%')
          .margin(MARGIN)
          .onClick(() => {
            createFile(distributedPathDir, 'distributedTest');
          })
        Button($r('app.string.AccessPublicFileDir'))
          .width('30%')
          .height('40%')
          .margin(MARGIN)
          .onClick(() => {
            mountPublicDir();
          })
        Button($r('app.string.DisconnectingLink'))
          .width('30%')
          .height('40%')
          .onClick(() => {
            disMountPublicDir();
          })
      }
      .width('100%')
      .height('20%')
      .align(Alignment.Center);

      Row() {
        Button($r('app.string.CopySandToDistributed'))
          .width('45%')
          .height('40%')
          .margin(MARGIN)
          .onClick(() => {
            copySandFile();
          })
        Button($r('app.string.CopyDistributedToSand'))
          .width('45%')
          .height('40%')
          .onClick(() => {
            copyDistributedFile();
          })
      }
      .width('100%')
      .height('20%')
      .align(Alignment.Center);

      Button($r('app.string.ApplyPermission'))
        .margin(MARGIN)
        .width('30%')
        .height('8%')
        .align(Alignment.Center)
        .onClick(() => {
          applyPermission();
        })
      Button($r('app.string.GetFileList'))
        .width('30%')
        .height('8%')
        .align(Alignment.Center)
        .onClick(() => {
          getListFile(pathDir);
          getListFile(distributedPathDir);
        })
    }
  }
}