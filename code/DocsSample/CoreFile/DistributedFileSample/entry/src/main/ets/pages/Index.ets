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


// [Start import_interface_distributed]
import { BusinessError } from '@kit.BasicServicesKit';
import { common, abilityAccessCtrl } from '@kit.AbilityKit';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { fileIo as fs, ListFileOptions, fileUri, securityLabel } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import Logger from '../common/Logger';
import { showToast } from '../common/ShowToast';

// [Start import_interface_distributed]
const BUFFER: number = 4096; // 读写文件的缓冲区
const DELAY: number = 1000; // 延时1秒
const MARGIN: number = 5; // 组件的间隔

// 设备A上在分布式路径下创建测试文件，并写入内容
function createFile(context: common.UIAbilityContext): void {
  // [Start access_A_write_distributed_file]
  let pathDir: string = context.distributedFilesDir;
  // 获取分布式目录的文件路径
  let filePath: string = pathDir + '/test.txt';

  try {
    // 在分布式目录下创建文件
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    console.info('Succeeded in creating.');
    // 向文件中写入内容
    fs.writeSync(file.fd, 'content');
    // 关闭文件
    fs.closeSync(file.fd);
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Failed to openSync / writeSync / closeSync. Code: ${err.code}, message: ${err.message}`);
  }
  // [End access_A_write_distributed_file]
}

// [Start set_security_label]
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

// [End set_security_label]

// 定义访问公共文件目录的回调
let listeners: fs.DfsListeners = {
  onStatus: (networkId: string, status: number): void => {
    Logger.info('Failed to access public directory');
  }
}

// 授权分布式数据同步权限。
async function applyPermission(context: common.UIAbilityContext) {
  // [Start distributed_Data_Permission]
  let atManager = abilityAccessCtrl.createAtManager();
  try {
    //以动态弹窗的方式向用户申请授权
    atManager.requestPermissionsFromUser(context, ['ohos.permission.DISTRIBUTED_DATASYNC']).then((result) => {
      console.info(`request permission result: ${JSON.stringify(result)}`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to request permissions from user. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Catch err. Failed to request permissions from user. Code: ${err.code}, message: ${err.message}`);
  }
  // [End distributed_Data_Permission]
}

// 设备B主动向设备A发起建链，建链成功后设备B可在分布式路径下读取测试文件
async function mountPublicDir(context: common.UIAbilityContext) {
  // [Start access_ConnectDfs]
  // 通过分布式设备管理的接口获取设备A的networkId信息
  let dmInstance = distributedDeviceManager.createDeviceManager('com.example.hap');
  let deviceInfoList: distributedDeviceManager.DeviceBasicInfo[] = dmInstance.getAvailableDeviceListSync();
  if (deviceInfoList && deviceInfoList.length > 0) {
    console.info(`Success to get available device list`);
    let networkId = deviceInfoList[0].networkId;
    // 定义访问公共文件目录的回调
    let listeners : fs.DfsListeners = {
      onStatus: (networkId: string, status: number): void => {
        console.info('Failed to access public directory');
      }
    };
    // 开始跨设备文件访问
    fs.connectDfs(networkId, listeners).then(() => {
      console.info('Success to connect dfs');
      let pathDir: string = context.distributedFilesDir;
      // 获取分布式目录的文件路径
      let filePath: string = pathDir + '/test.txt';
      try {
        // 打开分布式目录下的文件
        let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
        // 定义接收读取数据的缓存
        let arrayBuffer = new ArrayBuffer(4096);
        // 读取文件的内容，返回值是读取到的字节个数
        class Option {
          public offset: number = 0;
          public length: number = 0;
        };
        let option = new Option();
        option.length = arrayBuffer.byteLength;
        let num = fs.readSync(file.fd, arrayBuffer, option);
        // 打印读取到的文件数据
        let buf = buffer.from(arrayBuffer, 0, num);
        console.info('read result: ' + buf.toString());
        fs.closeSync(file);
      } catch (error) {
        let err: BusinessError = error as BusinessError;
        console.error(`Failed to openSync / readSync. Code: ${err.code}, message: ${err.message}`);
      }
    }).catch((error: BusinessError) => {
      let err: BusinessError = error as BusinessError;
      console.error(`Failed to connect dfs. Code: ${err.code}, message: ${err.message}`);
    });
  }
  // [End access_ConnectDfs]
}



// B设备访问跨设备文件完成，断开链路。
function disMountPublicDir(): void {
  // [Start access_DisConnectDfs]
  // 获取设备A的networkId
  let dmInstance = distributedDeviceManager.createDeviceManager('com.example.hap');
  let deviceInfoList: distributedDeviceManager.DeviceBasicInfo[] = dmInstance.getAvailableDeviceListSync();
  if (deviceInfoList && deviceInfoList.length > 0) {
    console.info(`Success to get available device list`);
    let networkId = deviceInfoList[0].networkId;
    // 关闭跨设备文件访问
    fs.disconnectDfs(networkId).then(() => {
      console.info(`Success to disconnect dfs`);
    }).catch((err: BusinessError) => {
      console.error(`Failed to disconnect dfs. Code: ${err.code}, message: ${err.message}`);
    })
  }
  // [End access_DisConnectDfs]
}

// 将A设备的待拷贝沙箱文件，拷贝到A设备的分布式路径下。
function copySandFile(context: common.UIAbilityContext): void {
  // [Start copy_sand_to_distributed]
  let pathDir: string = context.filesDir;
  let distributedPathDir: string = context.distributedFilesDir;
  // 待拷贝文件沙箱路径
  let filePath: string = pathDir + '/src.txt';
  try {
    // 准备待拷贝沙箱文件
    let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    fs.writeSync(file.fd, 'Create file success');
    fs.closeSync(file);
  } catch (error) {
    console.error(`Failed to createFile. Code: ${error.code}, message: ${error.message}`);
  }

  // 获取待拷贝源文件uri
  let srcUri = fileUri.getUriFromPath(filePath);
  // 获取目标路径(分布式目录)的uri
  let destUri: string = fileUri.getUriFromPath(distributedPathDir + '/src.txt');
  try {
    // 将沙箱路径下的源文件拷贝到目标分布式目录下
    fs.copy(srcUri, destUri).then(()=>{
      console.info(`Succeeded in copying---. `);
      console.info(`src: ${srcUri} dest: ${destUri}`);
    }).catch((error: BusinessError)=>{
      let err: BusinessError = error as BusinessError;
      console.error(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
    })
  } catch (error) {
    console.error(`Catch err. Failed to copy. Code: ${error.code}, message: ${error.message}`);
  }
  // [End copy_sand_to_distributed]
}

// B设备在获取A端沙箱文件时，从B设备的分布式路径下将对应的文件拷贝走，以此完成跨设备拷贝。
function copyDistributedFile(context: common.UIAbilityContext): void {
  // [End copy_distributed_to_sand]
  let pathDir: string = context.filesDir;
  let distributedPathDir: string = context.distributedFilesDir;
  // 待拷贝文件的目标路径(沙箱路径)
  let destPath: string = pathDir + '/dest.txt';
  // 获取目标路径uri
  let destUri = fileUri.getUriFromPath(destPath);

  // 拷贝源文件路径(分布式目录)
  let srcPath = distributedPathDir + '/src.txt';
  // 获取源路径uri
  let srcUri: string = fileUri.getUriFromPath(srcPath);

  // 定义拷贝回调
  let progressListener: fs.ProgressListener = (progress: fs.Progress) => {
    console.info(`progressSize: ${progress.processedSize}, totalSize: ${progress.totalSize}`);
  };
  let options: fs.CopyOptions = {
    'progressListener' : progressListener
  };
  // 通过分布式设备管理的接口获取设备A的networkId信息
  let dmInstance = distributedDeviceManager.createDeviceManager('com.example.hap');
  let deviceInfoList: distributedDeviceManager.DeviceBasicInfo[] = dmInstance.getAvailableDeviceListSync();
  if (deviceInfoList && deviceInfoList.length > 0) {
    console.info(`success to get available device list`);
    let networkId = deviceInfoList[0].networkId; // 这里只是两个设备连接，列表中首个即为A设备的networkId
    // 定义访问分布式目录的回调
    let listeners : fs.DfsListeners = {
      onStatus: (networkId: string, status: number): void => {
        console.error(`Failed to access public directory，${status}`);
      }
    };
    // 开始跨设备文件拷贝
    fs.connectDfs(networkId, listeners).then(()=>{
      try {
        // 将分布式目录下的文件拷贝到其他沙箱路径下
        fs.copy(srcUri, destUri, options).then(()=>{
          console.info(`Succeeded in copying from distribted path`);
          console.info(`src: ${srcUri} dest: ${destUri}`);
          fs.unlinkSync(srcPath); // 拷贝完成后清理分布式目录下的临时文件
        }).catch((error: BusinessError)=>{
          let err: BusinessError = error as BusinessError;
          console.error(`Failed to copy. Code: ${err.code}, message: ${err.message}`);
        })
      } catch (error) {
        console.error(`Catch err. Failed to copy. Code: ${error.code}, message: ${error.message}`);
      }
    }).catch((error: BusinessError) => {
      let err: BusinessError = error as BusinessError;
      console.error(`Failed to connect dfs. Code: ${err.code}, message: ${err.message}`);
    });
  }
  // [End copy_distributed_to_sand]
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
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            createFile(context);
          })
        Button($r('app.string.AccessPublicFileDir'))
          .width('30%')
          .height('40%')
          .margin(MARGIN)
          .onClick(() => {
            // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            mountPublicDir(context);
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
            // 请在组件内获取context，确保this.getUIContext().getHostContext()返回结果为UIAbilityContext
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            copySandFile(context);
          })
        Button($r('app.string.CopyDistributedToSand'))
          .width('45%')
          .height('40%')
          .onClick(() => {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            copyDistributedFile(context);
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
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          applyPermission(context);
        })
      Button($r('app.string.GetFileList'))
        .width('30%')
        .height('8%')
        .align(Alignment.Center)
        .onClick(() => {
          let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          let pathDir: string = context.filesDir; // 应用沙箱路径
          let distributedPathDir: string = context.distributedFilesDir; // 应用分布式路径
          getListFile(pathDir);
          getListFile(distributedPathDir);
        })
    }
  }
}