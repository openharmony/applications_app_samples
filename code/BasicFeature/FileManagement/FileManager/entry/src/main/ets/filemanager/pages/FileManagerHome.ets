/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import { FileManager } from '@ohos/feature-file-manager';
import fs from '@ohos.file.fs';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Logger } from '../../common/Common';
import MyWatcher from '../fileFs/MyWatcher';

class MainListItemModel {
  image: Resource | null = null
  title: Resource | null = null
  routerUrl: string = ''
  isReady?: boolean = true
  isFileWatcher?: boolean = false
}

const ONE_SECOND: number = 1000
const MAIN_LIST_ITEMS: MainListItemModel[] = [
  {
    image: $r('app.media.image'),
    title: $r('app.string.image'),
    routerUrl: 'filemanager/pages/image/ImageFileList'
  },
  {
    image: $r('app.media.video'),
    title: $r('app.string.video'),
    routerUrl: 'filemanager/pages/video/VideoFileList' },
  {
    image: $r('app.media.document'),
    title: $r('app.string.document'),
    routerUrl: 'filemanager/pages/document/DocumentFileList'
  },
  {
    image: $r('app.media.music'),
    title: $r('app.string.audio'),
    routerUrl: 'filemanager/pages/audio/AudioFileList'
  },
  {
    image: $r('app.media.compressed_package'),
    title: $r('app.string.compressed_package'),
    routerUrl: '',
    isReady: false
  },
  {
    image: $r('app.media.my_phone'),
    title: $r('app.string.my_phone'),
    routerUrl: 'filemanager/pages/MyPhone/MyPhone'
  },
  {
    image: $r('app.media.watcher'),
    title: $r('app.string.watcherFileText'),
    routerUrl: 'pages/WatcherFile',
    isFileWatcher: true
  }
]

@Component
export default struct FileManagerHome {
  private baseDir: string = AppStorage.Get<string>('sanBoxFileDir') as string;

  aboutToAppear() {
    FileManager.requestPermission(getContext(this));
  }

  aboutToDisappear(): void {
    let filePathDir = this.baseDir + '/watcherDir';
    try {
      let isDirectory = fs.statSync(filePathDir).isDirectory();
      if (isDirectory) {
        fs.rmdirSync(filePathDir);
        AppStorage.SetOrCreate('eventLog', 'unknown');
        AppStorage.SetOrCreate('fileNameLog', 'unknown');
        AppStorage.SetOrCreate('cookieLog', 'unknown');
      }
    } catch (e) {
      Logger.error(`remove fileRemove has failed for: {message: ${e.message}, code: ${e.code}}`);
    }
  }

  build() {
    Column() {
      Text($r('app.string.file_manager'))
        .fontSize(24)
        .margin({ left: 20, top: 10, bottom: 20 })
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.black'))
        .alignSelf(ItemAlign.Start)
      List() {
        ForEach(MAIN_LIST_ITEMS, (listItem: MainListItemModel, no: number) => {
          ListItem() {
            MainListItemComponent({ mainListItem: listItem });
          }
          .id('ListItem' + no)
        })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor($r('app.color.background'))
    .padding(20)
  }
}

@Component
struct MainListItemComponent {
  private mainListItem: MainListItemModel = new MainListItemModel();
  myWatcher: MyWatcher = new MyWatcher();
  private filePathDir: string = '';
  private baseDir: string = AppStorage.Get<string>('sanBoxFileDir') as string;

  @Styles itemPressedStyles() {
    .backgroundColor($r('app.color.item_pressed'))
  }

  readyForWatcher(): void {
    this.filePathDir = this.baseDir + '/watcherDir';
    if (!fs.accessSync(this.filePathDir)) {
      fs.mkdirSync(this.filePathDir);
    }
    let isDirectory = fs.statSync(this.filePathDir).isDirectory();
    if (isDirectory) {
      fs.rmdirSync(this.filePathDir);
      AppStorage.SetOrCreate('eventLog', 'unknown');
      AppStorage.SetOrCreate('fileNameLog', 'unknown');
      AppStorage.SetOrCreate('cookieLog', 'unknown');
    }
    AppStorage.Set('eventArray', ['test']);
    AppStorage.SetOrCreate('addIndex', 10);
    this.myWatcher.readyFilesToWatcher(this.filePathDir);
  }

  build() {
    Row() {
      Image(this.mainListItem.image)
        .width(24)
        .height(24)
        .margin({ left: 20 })
        .objectFit(ImageFit.Fill)

      Text(this.mainListItem.title)
        .fontSize(16)
        .margin({ left: 16 })
        .fontColor($r('app.color.black'))

      Blank()

      Image($r('app.media.right_arrow'))
        .width(12)
        .height(24)
        .margin({ right: 6 })
    }
    .height(56)
    .width('100%')
    .borderRadius(24)
    .backgroundColor($r('app.color.white'))
    .margin({ top: 10 })
    .stateStyles({
      pressed: this.itemPressedStyles
    })
    .onClick(() => {
      if (this.mainListItem.isReady == false) {
        prompt.showToast({
          duration: ONE_SECOND,
          message: $r('app.string.not_supported_tip')
        })
        return
      }
      if (this.mainListItem.isFileWatcher) {
        this.readyForWatcher();
      }
      if (this.mainListItem.routerUrl === MAIN_LIST_ITEMS[5].routerUrl) {
        let want: Want = {
          deviceId: '',
          bundleName: 'com.samples.my_phone_file',
          abilityName: 'EntryAbility'
        };
        let context: common.UIAbilityContext | undefined = AppStorage.get('context');
        context && context.startAbility(want, (err: BusinessError) => {
          if (err.code) {
            Logger.error(`Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
          }
        }
        );
        return;
      }
      router.pushUrl({ url: this.mainListItem.routerUrl });
    })
  }
}