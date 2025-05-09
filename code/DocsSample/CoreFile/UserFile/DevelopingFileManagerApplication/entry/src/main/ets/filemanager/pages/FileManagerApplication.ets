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

// [Start import_interface_file_manager]
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { Filter, fileAccess } from '@kit.CoreFileKit';
import Logger from '../../common/Logger';
// [End import_interface_file_manager]

let rootInfos: fileAccess.RootInfo[] = [];
let rootInfo: fileAccess.RootInfo = rootInfos[0];
let fileInfos: fileAccess.FileInfo[] = [];
let isDone: boolean = false;
let rootIterator: fileAccess.RootIterator;
// 从指定的目录开始
let fileInfoDir: fileAccess.FileInfo = fileInfos[0]; // fileInfoDir 表示某个目录信息
let subFileInfos: fileAccess.FileInfo[] = [];
let isDone02: boolean = false;
let sourceUri: string = 'file://docs/storage/Users/currentUser/Download';
let displayName: string = 'file2';
let fileUri: string = '';

// [Start file_access_root_info]
// 获取应用上下文
let context = getContext(this) as common.UIAbilityContext;
// 创建连接系统内所有文件管理服务端的helper对象
let fileAccessHelperAllServer: fileAccess.FileAccessHelper;

function createFileAccessHelper(): void {
  try { // this.context是EntryAbility传过来的Context
    fileAccessHelperAllServer = fileAccess.createFileAccessHelper(context);
    if (!fileAccessHelperAllServer) {
      Logger.error('createFileAccessHelper interface returns an undefined object');
    }
  } catch (err) {
    let error: BusinessError = err as BusinessError;
    Logger.error('createFileAccessHelper failed, errCode:' + error.code + ', errMessage:' + error.message);
  }
}
// [End file_access_root_info]

@Entry
@Component
struct Index {
  @State uriMessage: string = ''; // 初始化状态变量，用于显示消息
  @State subFileInfos: fileAccess.FileInfo[] = [];

  build() {
    Column() {
      // 创建文件按钮
      Button($r('app.string.createFileButton'))
        .width('80%') // 按钮宽度占屏幕宽度80%
        .height('10%') // 按钮高度占屏幕高度10%
        .fontSize($r('app.float.size_25')) // 按钮字体大小为25
        .borderRadius($r('app.float.size_25')) // 按钮圆角半径为25
        .backgroundColor($r('app.color.whiteColor')) // 按钮背景颜色为白色
        .shadow({
          radius: $r('app.float.size_10'), // 阴影半径为10
          color: $r('app.color.grayColor'), // 阴影颜色为灰色
          offsetX: $r('app.float.size_15'), // 阴影水平偏移量为15
          offsetY: $r('app.float.size_15') // 阴影垂直偏移量为15
        })
        .fontColor($r('app.color.blackColor')) // 按钮字体颜色为黑色
        .onClick(() => {
          this.creatFile();
        })
      Text(this.uriMessage)
        .fontSize($r('app.float.size_50')) // 文本字体大小为50
        .fontWeight(FontWeight.Bold) // 文本字体加粗
        .margin({ top: $r('app.float.size_20') }) // 文本上边距为20
    }
    .width('100%') // 外层列布局宽度占满屏幕
    .height('100%') // 外层列布局高度占满屏幕
    .alignItems(HorizontalAlign.Center) // 水平居中对齐
    .justifyContent(FlexAlign.Center) // 垂直居中对齐
    .backgroundColor($r('app.color.lightGrayColor')) // 背景颜色为浅灰色
  }

  // [Start file_access_get_root]
  async getRoots(): Promise<void> {
    try {
      rootIterator = await fileAccessHelperAllServer.getRoots();
      if (!rootIterator) {
        Logger.error('getRoots interface returns an undefined object');
        return;
      }
      while (!isDone) {
        let result = rootIterator.next();
        Logger.info('next result = ' + JSON.stringify(result));
        isDone = result.done;
        if (!isDone) {
          rootInfos.push(result.value);
        }
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('getRoots failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }
  // [End file_access_get_root]

  // [Start file_info_dir]
  async listRootFiles(): Promise<void> {
    try {
      let fileIterator = rootInfo.listFile(); // 遍历设备rootinfos[0]的根目录，返回迭代器对象
      if (!fileIterator) {
        Logger.error('listFile interface returns an undefined object');
      }
      while (!isDone) {
        let result = fileIterator.next();
        Logger.info('next result = ' + JSON.stringify(result));
        isDone = result.done;
        if (!isDone) {
          fileInfos.push(result.value);
        }
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('listFile failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }

  async listFiles(): Promise<void> {
    try {
      let fileIterator = fileInfoDir.listFile(); // 遍历特定的目录fileinfo，返回迭代器对象
      if (!fileIterator) {
        Logger.error('listFile interface returns an undefined object');
      }
      while (!isDone02) {
        let result = fileIterator.next();
        Logger.info('next result = ' + JSON.stringify(result));
        isDone02 = result.done;
        if (!isDone02) {
          subFileInfos.push(result.value);
        }
      }
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('listFile failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }
  // [End file_info_dir]

  // [Start create_file_promise]
  async creatFile(): Promise<void> {
    try {
      // fileAccessHelperAllServer 参考 fileAccess.createFileAccessHelper 示例代码获取
      fileUri = await fileAccessHelperAllServer.createFile(sourceUri, displayName);
      if (!fileUri) {
        Logger.error('createFile return undefined object');
      }
      Logger.info('createFile sucess, fileUri: ' + JSON.stringify(fileUri));
      this.uriMessage = 'CreateDocumentUriSuccess';
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      Logger.error('createFile failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
    ;
  }
  // [End create_file_promise]
}

// 在组件加载时创建文件访问助手
createFileAccessHelper();