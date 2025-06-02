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

import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { CustomDataSource } from '../components/CustomDataSource';
import {
  FileModel,
  FileType,
  fileUtils,
  logger,
  requestFiles,
  requestDownload,
  BackgroundTaskState,
  TOAST_BOTTOM
} from '@ohos/uploaddownload';
import { SelectFolderDialog } from '../components/SelectFolderDialog';
import { common } from '@kit.AbilityKit';
import { picker } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'DownloadSample';
const userDir: string =  'file://docs/storage/Users/currentUser';

@Entry
@Component
struct Download {
  private fileData: CustomDataSource = new CustomDataSource([]);
  private documentSelectOptions = new picker.DocumentSelectOptions();
  @StorageLink('isBackground') isBackground: boolean = false;
  @StorageLink('backDownTaskState') backDownTaskState: BackgroundTaskState = BackgroundTaskState.NONE;
  @StorageLink('downloadServer') downloadServerStr: string = './';
  @Provide downloadFolder: Array<string> = [];
  @State isGetData: boolean = false;
  @State checkFile: Array<string> = [];
  @State checkList: Array<boolean> = [];
  @State isRunning: boolean = false;
  @State isUserFolder: boolean = true;
  @State isPause: boolean = false;
  @State progress: number = 0;
  private selectFolder = (folder: string) => {
    logger.info(TAG, `selectFolder = ${folder}`);
    this.download('./' + folder);
  }
  private folderDialogController: CustomDialogController = new CustomDialogController({
    builder: SelectFolderDialog({ selectFolder: this.selectFolder }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -12 }
  });
  async selectUserFolder() {
    const documentSaveOptions = new picker.DocumentSaveOptions();    
    console.info(TAG, `documentSaveOptions: ${JSON.stringify(documentSaveOptions)}`)
    console.info(TAG, `documentSelectOptions: ${JSON.stringify(this.documentSelectOptions)}`)
    this.checkFile = [];
    if (this.checkList === undefined) {
      return;
    }
    logger.info(TAG, `checkList = ${JSON.stringify(this.checkList)}`);
    for (let i = 0; i < this.checkList.length; i++) {
      if (this.checkList[i]) {
        let fileModel = this.fileData.getData(i);
        logger.info(TAG, `fileModel = ${JSON.stringify(fileModel)}`);
        fileModel.files.forEach((url: string) => {
          let splitUrl = url.split('//')[1].split('/');
          if (splitUrl[splitUrl.length-1] !== '') {
            this.checkFile.push(url);
            documentSaveOptions.newFileNames = [splitUrl[splitUrl.length-1]];
          }
        });
      }
    }

    logger.info(TAG, `checkFile = ${JSON.stringify(this.checkFile)}`);
    
    if (this.checkFile.length === 0) {
      promptAction.showToast({ message: $r('app.string.check_file_tips'), bottom: TOAST_BOTTOM });
      return;
    }

    console.info(TAG, `documentSaveOptions: ${documentSaveOptions}`)
    let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    console.info(TAG, `context: ${JSON.stringify(context)}`)
    const documentViewPicker = new picker.DocumentViewPicker(context);
    console.info(TAG, `documentViewPicker: ${JSON.stringify(documentViewPicker)}`)
    await documentViewPicker.save(documentSaveOptions).then((documentSaveResult: Array<string>) => {
      console.info(TAG, `documentSaveResult: ${documentSaveResult}`)
      let splitUrl = documentSaveResult[0].split('/');
      console.info(TAG, `splitUrl: ${splitUrl}`)
      splitUrl.pop();
      console.info(TAG, `splitUrl: ${splitUrl}`)
      let splitUrl1=splitUrl.join('/');
      logger.info(TAG, `selectFolder = ${splitUrl1}`);
      this.documentSelectOptions.defaultFilePathUri = splitUrl1
      this.download(splitUrl1);
      logger.info(TAG, `selectFolder = ${splitUrl1}`);
    }).catch((err: BusinessError) => {
      console.error(TAG, `code : ${err.code} message : ${err.message}`)
    });
  }

  build() {
    Navigation() {
      Column() {
        if (this.isGetData) {
          LoadingProgress()
            .width(100)
            .layoutWeight(1)
        } else {
          List({ space: 12 }) {
            LazyForEach(this.fileData, (item: FileModel, index?: number) => {
              ListItem() {
                if (index !== undefined) {
                  this.FileItem(item, index)
                }
              }
            }, (item: FileModel) => JSON.stringify(item))
          }
          .width('100%')
          .scrollBar(BarState.Off)
          .layoutWeight(1)
          .backgroundColor(Color.White)
          .borderRadius(24)
          .padding({ top: 4, bottom: 4 })
          .divider({ strokeWidth: 1, startMargin: 44, endMargin: 12 })
        }
        this.BottomView()
      }
      .padding({ left: 12, right: 12, bottom: 12 })
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .hideBackButton(false)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.light_gray'))
    .hideToolBar(false)
    .title(this.isUserFolder?$r('app.string.downloadToUser'):$r('app.string.download'))
  }

  @Builder
  FileItem(file: FileModel, index: number) {
    Row() {
      Row() {
        if (file.fileType === FileType.FOLDER) {
          Image($r('app.media.ic_files_folder'))
            .size({ width: 24, height: 24 })
            .objectFit(ImageFit.Contain)
        } else if (file.fileType === FileType.IMAGE) {
          Image($r('app.media.ic_public_picture'))
            .size({ width: 24, height: 24 })
            .objectFit(ImageFit.Contain)
        } else if (file.fileType === FileType.MUSIC) {
          Image($r('app.media.ic_public_music'))
            .size({ width: 24, height: 24 })
            .objectFit(ImageFit.Contain)
        } else if (file.fileType === FileType.Video) {
          Image($r('app.media.ic_public_video'))
            .size({ width: 24, height: 24 })
            .objectFit(ImageFit.Contain)
        } else {
          Image($r('app.media.ic_public_document'))
            .size({ width: 24, height: 24 })
            .objectFit(ImageFit.Contain)
        }

        Text(decodeURIComponent(file.name))
          .fontSize(16)
          .fontWeight(400)
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 12 })
      }
      .layoutWeight(1)

      Checkbox({ name: '', group: 'checkboxGroup' })
        .select(this.checkList[index])
        .selectedColor($r('app.color.button_blue'))
        .margin({ left: 12 })
        .hitTestBehavior(HitTestMode.None)
    }
    .width('100%')
    .padding({ left: 12, right: 12 })
    .height(48)
    .onClick(() => {
      this.fileCheck(index);
    })
  }

  @Builder
  BottomView() {
    Column({ space: 12 }) {
      if (this.isBackground && this.backDownTaskState !== BackgroundTaskState.NONE) {
        Button() {
          Row() {
            Text(this.backDownTaskState === BackgroundTaskState.PAUSE ? $r('app.string.continue') : $r('app.string.pause'))
              .fontColor(Color.White)
              .fontSize(16)
          }
        }
        .id('download_to')
        .type(ButtonType.Capsule)
        .height(45)
        .width('100%')
        .backgroundColor($r('app.color.button_blue'))
        .onClick(() => {
          requestDownload.pauseOrResume();
        })

        Button() {
          Row() {
            Text($r('app.string.cancel'))
              .fontColor(Color.White)
              .fontSize(16)
          }
        }
        .id('download_to')
        .type(ButtonType.Capsule)
        .height(45)
        .width('100%')
        .backgroundColor($r('app.color.button_blue'))
        .onClick(() => {
          requestDownload.deleteAllBackTasks();
        })
      }
      if (!this.isBackground || this.isBackground && this.backDownTaskState === BackgroundTaskState.NONE) {
        Button() {
          Row() {
            if (!this.isBackground && this.isRunning) {
              Text(`${this.progress}%`)
                .fontColor(Color.White)
                .fontSize(16)
              Text($r('app.string.downloading'))
                .fontColor(Color.White)
                .fontSize(16)
                .margin({ left: 12 })
            } else {
              Text(this.isUserFolder?$r('app.string.downloadToUser'):$r('app.string.download'))
                .fontColor(Color.White)
                .fontSize(16)
            }
          }
        }
        .id('download_to')
        .type(ButtonType.Capsule)
        .height(45)
        .width('100%')
        .backgroundColor($r('app.color.button_blue'))
        .onClick(async () => {
          if (!this.isRunning) {
            if (this.isUserFolder ) {
              await this.selectUserFolder();
            } else {
              this.folderDialogController.open();
            }
          }
        })
      }
      Button($r('app.string.view_download_files'))
        .id('view_download_files')
        .type(ButtonType.Capsule)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .width('100%')
        .fontSize(16)
        .margin({ bottom: 12 })
        .fontColor($r('app.color.btn_text_blue'))
        .onClick(() => {
          if (this.isUserFolder ) {
            let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
            console.info(TAG, `context: ${JSON.stringify(context)}`)
            const documentViewPicker = new picker.DocumentViewPicker(context);
            console.info(TAG, `documentViewPicker: ${JSON.stringify(documentViewPicker)}`)
            console.info(TAG, `documentSelectOptions: ${JSON.stringify(this.documentSelectOptions)}`)
            documentViewPicker.select(this.documentSelectOptions).then((documentSelectResult: Array<string>) =>{
              console.info(TAG, `documentSelectResult: ${documentSelectResult}`)
            })
          } else {
            let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
            AppStorage.setOrCreate('downloadDir', context.cacheDir);
            router.pushUrl({
              url: 'pages/DownloadFiles'
            })
          }            
        })
    }
    .margin({ top: 12, left: 12, right: 12 })
  }

  aboutToAppear() {
    logger.debug(TAG, 'aboutToAppear');
    this.isRunning = false;
    this.isPause = false;
    this.isGetData = true;
    const params = router.getParams();
    console.info(`router.params: ${params}`);
    if (params) {
      this.isUserFolder=true;
      this.checkList = [];
      this.isRunning = false;      
      let itemtxt:FileModel = new FileModel('test.txt',false,[this.downloadServerStr + 'test.txt']);
      let itemjpg:FileModel = new FileModel('edge_picture.jpg',false,[this.downloadServerStr + 'edge_picture.jpg']);
      let itemmp3:FileModel = new FileModel('audio_test.mp3',false,[this.downloadServerStr + 'audio_test.mp3']);
      let itemmp4:FileModel = new FileModel('video_media.mp4',false,[this.downloadServerStr + 'video_media.mp4']);
      this.fileData.dataArray = [itemtxt,itemjpg,itemmp3,itemmp4] ;
      this.fileData.dataArray.forEach((item: FileModel) => {
        logger.debug(TAG, `item:${JSON.stringify(item)}`);
        this.checkList.push(false);
      })
      this.isGetData = false;
      this.fileData.notifyDataReload();
      fileUtils.listFolders(userDir).then((folders: Array<string>) => {
        logger.debug(TAG, `folders:${JSON.stringify(folders)}`);
        this.downloadFolder = folders;
      })      
    } else {
      this.isUserFolder=false;
      requestFiles.requestFiles().then((data: FileModel[]) => {
        this.checkList = [];
        this.isRunning = false;
        this.fileData.dataArray = data;
        this.fileData.dataArray.forEach((item: FileModel) => {
          this.checkList.push(false);
        })
        this.isGetData = false;
        this.fileData.notifyDataReload();
      })    
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      fileUtils.listFolders(context.cacheDir).then((folders: Array<string>) => {
        logger.debug(TAG, `folders:${JSON.stringify(folders)}`);
        this.downloadFolder = folders;
      })
    }
  }

  fileCheck(index: number) {
    logger.debug(TAG, `fileCheck= ${index}`);
    if (!this.isBackground) {
      for (let i = 0; i < this.checkList.length; i++) {
        if (i !== index) {
          this.checkList[i] = false;
        }
      }
    }
    this.checkList[index] = !this.checkList[index];
    logger.info(TAG, `this.checkList = ${JSON.stringify(this.checkList)}`);
  }

  download(folder: string) {
    logger.debug(TAG, `download folder= ${folder}`);
    this.checkFile = [];
    if (this.checkList === undefined) {
      return;
    }
    logger.info(TAG, `this.checkList = ${JSON.stringify(this.checkList)}`);
    for (let i = 0; i < this.checkList.length; i++) {
      if (this.checkList[i]) {
        let fileModel = this.fileData.getData(i);
        logger.info(TAG, `fileModel = ${JSON.stringify(fileModel)}`);
        fileModel.files.forEach((url: string) => {
          let splitUrl = url.split('//')[1].split('/');
          if (splitUrl[splitUrl.length-1] !== '') {
            this.checkFile.push(url);
          }
        });
      }
    }
    logger.info(TAG, `this.checkFile = ${JSON.stringify(this.checkFile)}`);
    if (this.checkFile.length === 0) {
      promptAction.showToast({ message: $r('app.string.check_file_tips'), bottom: TOAST_BOTTOM });
      return;
    }
    this.progress = 0;
    logger.info(TAG, `this.isBackground = ${JSON.stringify(this.isBackground)}`);
    if (this.isBackground) {
      this.isRunning = false;
      this.backDownTaskState = BackgroundTaskState.RUNNING;
      requestDownload.downloadFilesBackground(folder, this.checkFile);
      this.checkFile = [];
      this.checkList = [];
      this.fileData.dataArray.forEach((item: FileModel) => {
        this.checkList.push(false);
      })
      this.fileData.notifyDataReload();
      promptAction.showToast({ message: $r('app.string.background_task_start'), bottom: TOAST_BOTTOM });
    } else {
      this.isRunning = true;
      requestDownload.downloadFile(folder, this.checkFile[0], this.downloadFileCallback);
    }
  }

  downloadFilesCallback = (downloadCount: number, isSuccess: boolean) => {
    logger.debug(TAG, 'downloadFilesCallback');
    this.progress = downloadCount;
    if (downloadCount === this.checkFile.length) {
      this.downloadFinish(isSuccess);
    }
  }
  downloadFileCallback = (progress: number, isSuccess: boolean) => {
    logger.debug(TAG, 'downloadFileCallback');
    this.progress = progress;
    if (this.progress === 100) {
      this.downloadFinish(isSuccess);
    }
  }

  downloadFinish(isSuccess: boolean) {
    logger.debug(TAG, 'downloadFinish');
    this.isRunning = false;
    this.checkFile = [];
    this.checkList = [];
    this.fileData.dataArray.forEach((item: FileModel) => {
      this.checkList.push(false);
    })
    this.fileData.notifyDataReload();
    let message = isSuccess ? $r('app.string.download_finish') : $r('app.string.download_fail');
    promptAction.showToast({ message: message, bottom: TOAST_BOTTOM });
  }
}