/**
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import promptAction from '@ohos.promptAction';
import picker from '@ohos.file.picker';
import util from '@ohos.util';
import router from '@ohos.router';
import fs, { Filter } from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import Logger from '../utils/Logger';
import MediaFileUri from '../media/MediaFileUri';
import dlpPermission from '@ohos.dlpPermission';
import Want from '@ohos.app.ability.Want';
import fileUri from '@ohos.file.fileuri';
import account from '@ohos.account.distributedAccount';
import account_osAccount from '@ohos.account.osAccount';

const accountAbility = account.getDistributedAccountAbility();

interface FileInfo {
  uuid: string;
  name: string;
  path: string;
  uri: string,
  time: string;
  icon: Resource;
}

interface dlpInfo {
  name: string;
  id: string;
  event: string;
  nickname: string;
  avatar: string;
}

class ListFileOption {
  public recursion: boolean = false;
  public listNum: number = 0;
  public filter: Filter = {};
}

const RECENT_MAX = 10; // 最近打开最大文件数
const TAG = '[dlpmanager_index]';

@Entry
@Component
export struct Index {
  mediaFileUri: MediaFileUri = new MediaFileUri();
  @State uri: string = 'Hello World';
  @State filename: string = '';
  @State accountName: string = '';
  @State isDLPFile: boolean = false;
  @StorageLink('pathDir') pathDir: string = '';
  @State fileInfoList: Array<FileInfo> = [];
  @StorageLink('fileUriList') fileUriList: Array<string> = [];
  @StorageLink('fileNameList') fileNameList: Array<string> = [];
  @StorageLink('filePathList') filePathList: Array<string> = [];
  @StorageLink('fileTimeList') fileTimeList: Array<string> = [];

  /**
   * 拉起picker选择文件
   */
  async callFilePickerSelectFile(): Promise<void> {
    try {
      let DocumentSelectOptions = new picker.DocumentSelectOptions();
      DocumentSelectOptions.defaultFilePathUri = 'file://com.sample.dlpmanager/data/storage/el2/base/haps/entry/files';
      DocumentSelectOptions.maxSelectNumber = 20;
      let documentPicker = new picker.DocumentViewPicker();
      documentPicker.select(DocumentSelectOptions).then((DocumentSelectResult) => {
        Logger.info(TAG, 'DocumentViewPicker.select successfully, DocumentSelectOptions : ' + JSON.stringify(DocumentSelectOptions));
        Logger.info(TAG, 'DocumentViewPicker.select successfully, DocumentSelectResult uri: ' + JSON.stringify(DocumentSelectResult));
        let editFlag = false;
        if (DocumentSelectResult !== null && DocumentSelectResult !== undefined) {
          DocumentSelectResult.forEach((value) => {
            this.uri = value;
            editFlag = true;
            Logger.info(TAG, `select file uri: ${this.uri}`);
          });
        }
        if (editFlag) {
          this.getFilenameByUri(this.uri);
        }
      }).catch((err: BusinessError) => {
        Logger.error(TAG, 'DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
      });
    } catch (err) {
      Logger.error(TAG, 'DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
  }

  async getFilenameByUri(myUri: string): Promise<void> {
    this.filename = (myUri.split('/').pop()) as string;
    let fd: number = fs.openSync(myUri).fd;
    Logger.info(TAG, myUri + ';fd:' + fd);
    let fileUriObject = new fileUri.FileUri(myUri);
    let name = fileUriObject.name;
    let path = fileUriObject.path;
    Logger.info(TAG, 'The name of FileUri is ' + name + ';The path is ' + path);
    let fileSuffix = '.' + (this.filename.split('.').pop()) as string;
    await this.isDlpFileFunc(fd);
    await sleep(2);
    if (this.isDLPFile) {
      await this.OpenDlpFile(myUri, this.filename, fd);
    } else {
      await this.routerUri(this.filename, path, fd, myUri, this.isDLPFile, fileSuffix);
    }
  }

  /**
   * 获取文件夹下所有文件的文件名和访问时间
   */
  async getListFileName(): Promise<void> {
    let option = new ListFileOption();
    let uuidList: string[] = [];
    option.filter.suffix = ['.txt', '.doc', '.docx', '.dlp'];
    fs.listFile(this.pathDir, option).then((filenames: Array<string>) => {
      Logger.info(TAG, 'listFile succeed');
      for (let i = 0; i < filenames.length && this.fileInfoList.length < filenames.length && i < RECENT_MAX; i++) {
        uuidList[i] = util.generateRandomUUID(true);
        Logger.info(TAG, 'filename: ', filenames[i]);
        this.fileNameList[i] = filenames[i];
        this.filePathList[i] = this.pathDir + '/' + this.fileNameList[i];
        this.fileUriList[i] = fileUri.getUriFromPath(this.filePathList[i]);
        fs.stat(this.filePathList[i]).then((stat: fs.Stat) => {
          Logger.info(TAG, 'get file info succeed, the size of file is ' + stat.mode);
          Logger.info(TAG, 'get file info succeed, the size of file is ' + stat.atime);
          this.fileTimeList[i] = timestampToDate(stat.atime);
          Logger.info(TAG, 'get file info succeed, the size of fileTimeList: ' + this.fileTimeList[i]);
          let fileSuffix = (this.fileNameList[i].split('.').pop()) as string;
          this.fileInfoList.push(
            {
              uuid: uuidList[i],
              name: this.fileNameList[i],
              path: this.filePathList[i],
              uri: this.fileUriList[i],
              time: this.fileTimeList[i],
              icon: fileSuffix == 'txt' ? $r('app.media.ic_normal_white_grid_txt') : $r('app.media.ic_normal_dark_grid_dlp')
            });
        }).catch((err: BusinessError) => {
          Logger.info(TAG, 'get file info failed with error message: ' + err.message + ', error code: ' + err.code);
        });
      }
      AppStorage.setOrCreate('fileNameList', this.fileNameList);
      AppStorage.setOrCreate('filePathList', this.filePathList);
      AppStorage.setOrCreate('fileUriList', this.fileUriList);
      AppStorage.setOrCreate('fileTimeList', this.fileTimeList);
    }).catch((err: BusinessError) => {
      Logger.info(TAG, 'list file failed with error message: ' + err.message + ', error code: ' + err.code);
    });
  }

  /**
   * 获取文件夹下所有文件的文件名和访问时间
   */
  async getRecentFileName(): Promise<void> {
    let option = new ListFileOption();
    let uuidList: string[] = [];
    option.filter.suffix = ['.txt', '.doc', '.docx', '.dlp'];
    try {
      let info: Array<dlpPermission.AccessedDLPFileInfo> = await dlpPermission.getDLPFileAccessRecords();
      Logger.info(TAG, 'getRecentFile：' + JSON.stringify(info));
      if (info.length === 0) {
        return;
      }
      for (let i = 0; i < info.length; i++) {
        uuidList[i] = util.generateRandomUUID(true);
        Logger.info(TAG, 'filename: ', info[i].uri);
        let file = fs.openSync(info[i].uri);
        this.fileNameList[i] = file.name;
        this.filePathList[i] = file.path;
        this.fileUriList[i] = info[i].uri;
        fs.stat(this.filePathList[i]).then((stat: fs.Stat) => {
          Logger.info(TAG, 'get file info succeed, the size of file is ' + stat.mode);
          Logger.info(TAG, 'get file info succeed, the size of file is ' + stat.atime);
          this.fileTimeList[i] = timestampToDate(stat.atime);
          Logger.info(TAG, 'get file info succeed, the size of fileTimeList: ' + this.fileTimeList[i]);
          this.fileInfoList.push(
            {
              uuid: uuidList[i],
              name: this.fileNameList[i],
              path: this.filePathList[i],
              uri: this.fileUriList[i],
              time: this.fileTimeList[i],
              icon: $r('app.media.ic_normal_dark_grid_dlp')
            });
        }).catch((err: BusinessError) => {
          Logger.info(TAG, "get file info failed with error message: " + err.message + ", error code: " + err.code);
        });

        AppStorage.setOrCreate('fileNameList', this.fileNameList);
        AppStorage.setOrCreate('filePathList', this.filePathList);
        AppStorage.setOrCreate('fileUriList', this.fileUriList);
        AppStorage.setOrCreate('fileTimeList', this.fileTimeList);
      }
    } catch (err) {
      Logger.info(TAG, "list file failed with error message: ", err);
    }
  }

  /**
   * 获取dlp文件的uri和访问时间
   */
  async getDLPFile(): Promise<void> {
    try {
      let info: Array<dlpPermission.AccessedDLPFileInfo> = await dlpPermission.getDLPFileAccessRecords(); // 获取DLP访问列表
      promptAction.showToast({ message: "getDLPFile：" + decodeURIComponent(JSON.stringify(info)), duration: 2000 });
      Logger.info(TAG, 'getDLPFile:', JSON.stringify(info));
    } catch (err) {
      Logger.error(TAG, 'getDLPFileAccessRecords error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 设置沙箱保留
   */
  async setSandboxFile(docUris: Array<string>): Promise<void> {
    try {
      dlpPermission.setRetentionState(docUris); // 设置沙箱保留
    } catch (err) {
      Logger.error(TAG, 'setRetentionState error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 取消沙箱保留
   */
  async cancelSandboxFile(docUris: Array<string>): Promise<void> {
    try {
      dlpPermission.cancelRetentionState(docUris); // 取消沙箱保留
    } catch (err) {
      Logger.error(TAG, 'cancelRetentionState error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 获取沙箱保留信息
   */
  async getSandboxList(): Promise<void> {
    try {
      let res: Array<dlpPermission.RetentionSandboxInfo> = await dlpPermission.getRetentionSandboxList(); // 获取沙箱保留列表
      Logger.info(TAG, 'getRetentionSandboxList:' + JSON.stringify(res));
      promptAction.showToast({
        message: 'getRetentionSandboxList:' + decodeURIComponent(JSON.stringify(res)),
        duration: 2000
      });
    } catch (err) {
      Logger.error(TAG, 'getRetentionSandboxList error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 打开dlp文件
   */
  async OpenDlpFile(dlpUri: string, dlpName: string, fd: number) {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      'action': 'ohos.want.action.viewData',
      'bundleName': 'com.sample.dlpmanager',
      'type': 'text/plain',
      'abilityName': 'FuncAbility',
      'uri': dlpUri,
      'parameters': {
        'fileName': {
          'name': dlpName,
        },
        'keyFd': {
          'type': 'FD',
          'value': fd,
        }
      }
    };
    try {
      Logger.info(TAG, 'openDLPFile:' + JSON.stringify(want));
      context.startAbility(want, (error: BusinessError) => {
        Logger.error(TAG, 'want error.code =' + error.code + ',error.message =' + error.message);
      });
    } catch (err) {
      Logger.error('openDLPFile startAbility failed' + (err as BusinessError).code + (err as BusinessError).message);
      return;
    }
  }

  /**
   * 监听DLP文件打开
   */
  async onOpenDlpFile() {
    try {
      dlpPermission.on('openDLPFile', (info: dlpPermission.AccessedDLPFileInfo) => {
        Logger.info(TAG, 'openDlpFile event:' + info.uri + info.lastOpenTime);
        promptAction.showToast({
          message: 'openDlpFile event:' + decodeURIComponent(info.uri) + info.lastOpenTime,
          duration: 2000
        });
      });
    } catch (err) {
      Logger.error(TAG, 'onOpenDLPFile error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
  }

  /**
   * 是否为dlp文件
   */
  async isDlpFileFunc(fd: number): Promise<boolean> {
    try {
      this.isDLPFile = await dlpPermission.isDLPFile(fd); // 是否加密DLP文件
      Logger.info(TAG, 'isDlpFile:' + this.isDLPFile);
      promptAction.showToast({ message: 'isDlpFile:' + this.isDLPFile, duration: 2000 });
      return this.isDLPFile;
    } catch (err) {
      Logger.error(TAG, 'isDLPFile error:' + (err as BusinessError).code + (err as BusinessError).message);
    }
    return this.isDLPFile;
  }

  // 获取帐号信息
  async getOsAccountInfo() {
    let accountMgr: account_osAccount.AccountManager;
    try {
      accountMgr = account_osAccount.getAccountManager();
      let user = await accountMgr.getCurrentOsAccount();
      Logger.info(TAG, "accountLogin user:" + JSON.stringify(user));
    } catch (err) {
      Logger.error(TAG, 'getCurrentOsAccount failed:' + err.code + err.message);
    }
  }

  // 帐号登录
  async accountLogin(accountName: string) {
    let info: dlpInfo = {
      name: "aa",
      id: "1234",
      event: "Ohos.account.event.LOGIN",
      nickname: "nickname",
      avatar: "avatar",
    };
    if (accountName) {
      info.name = accountName;
      Logger.info(TAG, "info.name:" + accountName);
    } else {
      Logger.info(TAG, "info.name:aa");
    }
    info.event = "Ohos.account.event.LOGIN";
    try {
      await accountAbility.setOsAccountDistributedInfo(info);
      Logger.info(TAG, "login success;info:" + JSON.stringify(info))
      promptAction.showToast({
        message: "login success;info:" + decodeURIComponent(JSON.stringify(info)),
        duration: 2000
      })
    } catch (err) {
      Logger.error(TAG, "setOsAccountDistributedInfo LOGIN failed：" + err.code + err.message);
      return
    }
    let user = await accountAbility.getOsAccountDistributedInfo();
    Logger.info(TAG, "accountLogin user:" + JSON.stringify(user));
  }

  //跳转页面
  async routerUri(name: string, path: string, fd: number, uri: string, isDlpFile: boolean, fileSuffix: string) {
    router.pushUrl({
      url: 'media/filePage',
      params: {
        fileName: name,
        myPath: path,
        fd: fd,
        myUri: uri,
        isDlpFile: isDlpFile,
        fileSuffix: fileSuffix,
      }
    }, router.RouterMode.Standard).then(() => {
      Logger.info(TAG, 'Succeeded in jumping to the second page');
    }).catch((err: BusinessError) => {
      Logger.error(TAG, `Failed to jump to the second page.Code is ${err.code}, message is ${err.message}`);
    })
  }

  aboutToDisappear(): void {
    this.fileNameList = [];
    this.fileUriList = [];
    this.filePathList = [];
    this.fileTimeList = [];
    dlpPermission.off('openDLPFile', (info: dlpPermission.AccessedDLPFileInfo) => {
      Logger.info(TAG, 'openDlpFile event' + info.uri + info.lastOpenTime);
    });
  }

  onPageShow(): void {
    this.getListFileName();
    this.getRecentFileName();
    this.onOpenDlpFile();
    Logger.info(TAG, 'sandbox path is:' + this.pathDir);
    this.accountLogin(this.accountName);
  }

  aboutToAppear() {
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Column() {
          Text($r('app.string.file_manager'))
            .fontFamily('HarmonyHeiTi-Bold')
            .fontSize('30vp')
            .fontColor($r('app.color.font_color_182431'))
            .align(Alignment.TopStart)
            .textAlign(TextAlign.Start)
            .padding({ left: '24vp', right: '24vp', top: '8vp', bottom: '2vp' })
            .fontWeight(700)
            .height('50vp')
            .width('100%')
            .id('noteBook')
          Text($r('app.string.file'))
            .opacity(0.6)
            .fontFamily('HarmonyHeiTi')
            .fontSize('14vp')
            .fontColor($r('app.color.font_color_182431'))
            .textAlign(TextAlign.Start)
            .padding({ left: '24vp', right: '24vp', bottom: '12vp' })
            .fontWeight(400)
            .height('30vp')
            .width('100%')
            .id('latestFile')
        }.zIndex(1).width('100%').height('82vp')

        Image($r('app.media.ic_public_more'))
          .height('24vp')
          .width('24vp')
          .margin({ left: '312vp', right: '24vp', top: '34vp', bottom: '24vp' })
          .zIndex(2)
          .bindMenu(this.homePageMenu, { placement: Placement.BottomRight, offset: { y: '16vp' } })
          .id('moreIcon')
      }.width('100%').height('84vp')

      Stack({ alignContent: Alignment.TopEnd }) {
        List() {
          ForEach(this.fileInfoList, (item: FileInfo, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Image(item.icon)
                    .width('30vp')
                    .height('34vp')
                    .margin({ left: '20vp', right: '18vp', top: '12vp', bottom: '8vp' })
                  Column() {
                    Text(item.name)
                      .fontSize('14vp')
                      .fontFamily('HarmonyHeiTi-Medium')
                      .fontColor($r('app.color.font_color_182431'))
                      .textAlign(TextAlign.Start)
                      .fontWeight(500)
                      .width('135vp')
                      .height('19vp')
                      .margin({ right: '157vp', top: '7vp', bottom: '4vp' })
                    Text(item.time)
                      .fontSize('12vp')
                      .fontFamily('HarmonyHeiTi-Medium')
                      .fontColor($r('app.color.font_color_66182431'))
                      .textAlign(TextAlign.Start)
                      .fontWeight(500)
                      .width('149vp')
                      .height('16vp')
                      .margin({ right: '143vp', bottom: '8vp' })
                  }
                  .id('file' + index)
                  .onClick(async () => {
                    let path = this.pathDir + '/' + item.name;
                    let fd: number = fs.openSync(path).fd;
                    Logger.info(TAG, "path:" + path + ";fd:" + fd);
                    let uri = fileUri.getUriFromPath(path);
                    Logger.info(TAG, "uri:" + uri);
                    let fileSuffix = "." + (item.name.split(".").pop()) as string;
                    await this.isDlpFileFunc(fd);
                    await sleep(2);
                    if (this.isDLPFile) {
                      await this.OpenDlpFile(uri, item.name, fd);
                    } else {
                      await this.routerUri(item.name, this.filePathList[index], fd, uri, this.isDLPFile, fileSuffix);
                    }
                  })
                }.width('100%')

                Divider()
                  .width('448vp')
                  .height('0.5vp')
                  .opacity(0.05)
                  .backgroundColor($r('app.color.divider_color_182431'))
                  .margin({ left: '16vp', right: '16vp' })
              }.width('100%').height('54vp')
            }.width('100%').height('54vp')
          }, (item: FileInfo) => item.uuid)
        }
        .zIndex(1)
        .width('100%')
        .listDirection(Axis.Vertical) // 排列方向
        .id('indexList')
        .edgeEffect(EdgeEffect.Spring) // 滑动到边缘无效果
        .scrollBar(BarState.Auto)

        Image($r('app.media.add'))
          .height('48vp')
          .width('48vp')
          .margin({ left: '288vp', right: '24vp', top: '546vp', bottom: '80vp' })
          .zIndex(2)
          .id('add')
          .onClick(() => {
            this.callFilePickerSelectFile();
          })
      }
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  homePageMenu() {
    Menu() {
      MenuItem(this.homePageTextMenu1)
        .width('128vp')
        .height('48vp')
        .margin({ left: '16vp', right: '16vp' })
        .onClick(() => {
          this.getDLPFile();
        })

      MenuItem(this.homePageDivider)

      MenuItem(this.homePageTextMenu2)
        .width('160vp')
        .height('48vp')
        .onClick(() => {
          this.getSandboxList();
        })

    }
    .width('160vp')
    .height('102vp')
    .backgroundColor('#FFFFFF')
    .borderRadius('16.00vp')
  }

  @Builder
  homePageTextMenu1() {
    Text($r('app.string.obtain_visit_record'))
      .width('99vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', right: '29vp' })
      .id('obtain_visit_record')
  }

  @Builder
  homePageTextMenu2() {
    Text($r('app.string.obtain_sandbox_retention_information'))
      .width('128vp')
      .height('21vp')
      .fontSize('16vp')
      .fontFamily('HarmonyHeiTi')
      .fontWeight(400)
      .fontColor($r('app.color.font_color_182431'))
      .align(Alignment.Start)
      .margin({ top: '13vp', bottom: '14vp', left: '16vp', right: '16vp' })
      .id('obtain_sandbox_retention_information')
  }

  @Builder
  homePageDivider() {
    Divider()
      .width('128vp')
      .height('0.5vp')
      .opacity(0.05)
      .backgroundColor($r('app.color.divider_color_182431'))
      .margin({ left: '16vp', right: '16vp' })
  }
}

export function timestampToDate(timestamp: number): string {
  const date = new Date(timestamp * 1000);
  let year = date.getFullYear();
  let month: string | number = date.getMonth() + 1;
  month = month >= 10 ? month : ('0' + month);
  let day: string | number = date.getDate();
  day = day >= 10 ? day : ('0' + day);
  let hours: string | number = date.getHours();
  hours = hours >= 10 ? hours : ('0' + hours);
  let minutes: string | number = date.getMinutes();
  minutes = minutes >= 10 ? minutes : ('0' + minutes);
  let seconds: string | number = date.getSeconds();
  seconds = seconds >= 10 ? seconds : ('0' + seconds);
  return `${year}/${month}/${day} ${hours}:${minutes}:${seconds}`;
}

export function sleep(time: number) {
  setTimeout(() => {
    Logger.info('delay ' + time);
  }, time * 1000)
}
