/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import {
  memo,
  __memo_context_type,
  __memo_id_type
} from '@ohos.arkui.stateManagement';
import {Entry,Text,TextAttribute,Column,Component,
  Button,ButtonAttribute,ClickEvent,Row,TextAlign,Visibility,List,ListItem,ForEach,TextOverflow,
  Image,HorizontalAlign,Progress,ProgressType,FlexAlign,SafeAreaType,JSON,$r,Margin,TextDecorationType
} from '@ohos.arkui.component';
import {State,Link,MutableState,stateOf,observableProxy,Prop,Watch} from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import request from '@ohos.request'; // 导入上传下载模块。需要配置ohos.permission.INTERNET权限
import { downloadFilesData } from '../model/dataType';
const BYTE_CONVERSION: number = 1024; // 字节转换

@Component
export struct FileDownloadItem {
  @State fileName: string = '';
  // 下载任务状态
  @State state: string = '';
  // 监听是否全部开始下载
  @Prop @Watch('onDownLoadUpdated') isStartAllDownload: boolean;
  // 下载任务对象初始化。用于下载失败和下载过程中暂停和重新启动下载。
  private downloadTask: request.agent.Task | undefined;
  // 待下载任务数量
  @Link downloadCount: number;
  // 下载失败任务数量
  @Link downloadFailCount: number;
  // 下载状态图标显隐控制。下载中显示图标，下载完成或者下载失败隐藏图标
  @State isShow: boolean = false;
  // 是否正在下载标志位
  @State downloading: boolean = false;
  // 下载文件大小。类型字符串
  @State sFileSize: string = '-';
  // 下载文件大小。类型数值
  @State nFileSize: number = 0;
  // 当前已下载数据量。类型字符串
  @State sCurrentDownloadSize: string = '-';
  // 当前已下载数据量。类型数值
  @State nCurrentDownloadSize: number = 0;
  // 下载文件数据
  @Prop fileDataInfo: downloadFilesData;
  // 下载历史列表
  @Link historyArray: downloadFilesData[];
  // 下载列表
  @Link downloadFileArray: downloadFilesData[];

  // 监听是否开始下载/暂停下载
  onDownLoadUpdated(param: string):void {
    if (this.isStartAllDownload) {
      // 如果下载失败，则重新下载。下载失败原因一般是网络原因导致。
      if (this.state === '下载失败') {
        // 下载任务完成或者任务失败时，底层会自动销毁任务资源。所以如果需要重新下载，重新创建任务即可。这里只做了初始化task对象
        this.downloadTask = undefined;
        // 隐藏下载状态图标
        this.isShow = false;
        // 重置下载任务状态
        this.state = '';
      }
      this.startDownload();
    } else {
      if (this.downloadFailCount > 0 && this.downloadFailCount === this.downloadCount) {
        // 如果是任务全部下载失败，重置isStartAllDownload为false的情况，重置downloadFailCount
        this.downloadFailCount = 0;
      } else {
        // 暂停下载
        this.pauseDownload();
      }
    }
  }

  // 启动下载任务
  startDownload() {
    // 首次下载，创建任务
    if (this.downloadTask === undefined) {
      let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      (request.agent.create(context, {
        action: request.agent.Action.DOWNLOAD, // 配置任务选项，这里配置为下载任务
        url: this.fileDataInfo.url, // 配置下载任务url
        overwrite: true, // 下载过程中路径已存在时的解决方案选择。true表示覆盖已存在的文件
        method: 'GET', // HTTP标准方法。下载时，使用GET或POST。
        saveas: './', // 这里'./'表示下载至应用当前缓存路径下。
        mode: request.agent.Mode.BACKGROUND, // 任务模式设置后台任务。
        gauge: true, // 后台任务的过程进度通知策略，仅应用于后台任务。true表示发出每个进度已完成或失败的通知。
        retry: false, // 默认为true，如果没有网络或者网络不满足时，会自动暂停waiting，等网络满足时进行一次重试。设置为false时，没网直接走失败回调
      } as request.agent.Config) as Promise<request.agent.Task>)
        .then((task: request.agent.Task) => {
          this.downloadTask = task as request.agent.Task;
          // 注册下载任务相关回调
          task.on('completed', this.completedCallback); // 下载任务完成回调
          task.on('failed', this.failedCallback); // 下载任务失败回调
          task.on('progress', this.progressCallback); // 下载进度更新回调
          task.on('pause', this.pauseCallback); // 暂停任务回调
          task.on('resume', this.resumeCallback); // 重新启动任务回调

          // 启动下载任务。本例在每个FileDownloadItem中使用task.start方法启动各自的下载任务。
          task.start((err: BusinessError | null) => {
            if (err) {
              hilog.error(0x0000, 'TAGhttp',
                `task.start Failed to task start with error message: ${err.message}, error code: ${err.code}`);
              return;
            }
          });
        });
    } else {
      // 任务已存在时，继续下载
      this.resumeDownload();
    }
  }

  // 下载任务完成回调
  private completedCallback: (progress: request.agent.Progress) => void  = (progress: request.agent.Progress) => {
    try {
      // 下载状态设置为下载完成
      this.state = '下载完成';
      // 文件下载完成，待下载任务数量减1
      if(this.downloadCount > 0) {
        this.downloadCount--;
      }
      if (this.sFileSize === '未知大小') {
        this.nCurrentDownloadSize = 1;
      }

      // 隐藏下载状态图标
      this.isShow = false;
      this.getFileStatusAndTime(1);
    } catch(err:Error) {
      hilog.error(0x0000, 'TAGhttp,err: ', String(err.message));
    }
  }

  // 下载任务失败回调。任务下载失败一般是由于网络不好，底层重试也失败后进入该下载失败回调。如果网络没问题，建议重新下载再试。
  private failedCallback: (progress: request.agent.Progress) => void   = (progress: request.agent.Progress) => {
    try {
      this.state = '下载失败';
      this.getFileStatusAndTime(2)
      // 当所有任务下载失败时，'全部暂停'状态重置为'全部开始'。
      this.downloadFailCount++;
      if (this.downloadFailCount === this.downloadCount) {
        this.isStartAllDownload = false;
      }
    } catch(err:Error) {
      hilog.error(0x0000, 'TAGhttp,err: ', String(err.message))
    }
  }

  // 文件下载成功和下载失败更改文件的状态
  getFileStatusAndTime(status: number) {
    this.fileDataInfo.fileStatus = status;
    this.historyArray = [...this.historyArray, this.fileDataInfo]
    // 下载列表删除下载成功的数据
    this.downloadFileArray = this.downloadFileArray.filter((item:downloadFilesData) => {
      return item.id !== this.fileDataInfo.id;
    });
  }

  // 下载进度更新回调
  private progressCallback: (progress: request.agent.Progress) => void = (progress: request.agent.Progress) => {
    try {
      // 性能知识点: 如果注册了progress下载进度更新监听，不建议在progress下载进度更新回调中加日志打印，减少不必要的性能损耗。
      this.nFileSize = progress.sizes[0];

      this.state = '  下载中';
      this.downloading = true;
      // 显示下载状态图标
      this.isShow = true;
      // 第一次开始下载
      if (this.sFileSize === '-') {
        // 如果下载url文件的服务器采用chunk分块传输文件数据，是获取不到下载文件总大小的。传过来的值为-1，则在页面上显示'未知大小'
        if (progress.sizes[0] === -1) {
          this.sFileSize = '未知大小';
          // 文件大小无法获取的情况下，进度条的值设置为0，总进度设置为1
          this.nCurrentDownloadSize = 0;
          this.nFileSize = 1;
        } else {
          // 能获取文件大小时，按实际下载数据量更新进度
          this.nFileSize = progress.sizes[0];
          this.sFileSize = String(progress.sizes[0] / BYTE_CONVERSION).split('.')[0] as string + 'kb';
          this.nCurrentDownloadSize = progress.processed;
        }
      } else {
        // 非首次下载(暂停过下载任务后重新启动下载时)，文件大小能获取到的情况，更新下载进度
        this.nCurrentDownloadSize = progress.processed;
      }
      // 用于显示已下载文件数据大小
      this.sCurrentDownloadSize = String(progress.processed / BYTE_CONVERSION).split('.')[0] as string + 'kb';
    } catch(err:Error) {
      hilog.error(0x0000, 'TAGhttp,err: ', String(err.message))
    }
  }

  // 暂停任务回调
  private pauseCallback: (progress: request.agent.Progress) => void  = (progress: request.agent.Progress) => {
    try {
      this.state = '已暂停';
      // 切换下载状态图标
      this.downloading = false;
    } catch(err:Error) {
      hilog.error(0x0000, 'TAGhttp,err: ', String(err.message))
    }
  }

  // 暂停下载任务
  pauseDownload(): void {
    if (this.downloadTask) {
      // 使用request.agent.show，根据任务id可查询任务的详细信息。本处用于查询下载任务状态
      request.agent.show(this.downloadTask!.tid,
        (err: BusinessError<void>|null, taskInfo: request.agent.TaskInfo|undefined) => {
        if (err && err.code !== 0) {
          hilog.error(0x0000, 'TAGhttp',  `Failed to show with error message: ${err.message}, error code: ${err.code}`);
          return;
        }
        if (taskInfo == undefined) {
          return;
        }
        // 判断当前下载任务状态是否满足暂停条件。
        if (this.downloadTask && (taskInfo.progress.state === request.agent.State.WAITING ||
          taskInfo.progress.state === request.agent.State.RUNNING ||
          taskInfo.progress.state === request.agent.State.RETRYING)) {
          this.downloadTask!.pause().then(() => {
            // 暂停任务成功
          }).catch((err: Error) => {
            hilog.error(0x0000, 'TAGhttp', `Failed to pause with error message: ${err.message}, error code: ${err.code}`);
          });
        } else {
          if (this.downloadTask) {
            // 不满足暂停任务条件
            hilog.error(0x0000, 'TAGhttp', `Not meeting the pause task conditions,current task state: ${taskInfo.progress.state}`);
          }
        }
      });
    }
  }

  // 重新启动任务回调。如果下载url文件的服务器不支持分片传输，则文件将重新下载。如果服务器支持分片传输，则会基于之前暂停时的下载进度继续下载。
  private resumeCallback: (progress: request.agent.Progress) => void  = (progress: request.agent.Progress) => {
    try {
      this.state = '下载中';
      // 切换下载状态图标
      this.downloading = true;
    } catch(err:Error) {
      hilog.error(0x0000, 'TAGhttp err: ', String(err.message));
    }
  }

  // 重新启动下载任务
  resumeDownload(): void {
    if (this.downloadTask) {
      // 查询任务状态
      request.agent.show(this.downloadTask!.tid,
        (err: BusinessError<void>|null, taskInfo: request.agent.TaskInfo|undefined) => {
        if (err && err.code !== 0) {
          hilog.error(0x0000, 'TAGhttp', `Failed to show with error message: ${err.message}, error code: ${err.code}`);
          return;
        }
        if(taskInfo == undefined) {
          return;
        }
        // 判断如果任务是暂停状态，则重新启动下载任务
        if (this.downloadTask && taskInfo.progress.state === request.agent.State.PAUSED) {
          // 使用task.resume可以重新启动任务，可恢复暂停的后台任务。
          this.downloadTask!.resume((err: BusinessError<void>|null) => {
            if (err && err.code !== 0) {
              hilog.error(0x0000, 'TAGhttp', `Failed to resume with error message: ${err.message}, error code: ${err.code}`);
              return;
            }
            // 重新启动下载任务成功
          });
        }
      });
    }
  }

  build(){
    Row() {
      Row() {
        Image($r('app.media.multiple_files_download_file'))
          .height(50)
          .width(50)
          .borderRadius(8)
          .id('fileImage')
      }.width('17%')

      Column() {
        Row() {
          Column() {
            Text(this.fileDataInfo.url.split('/').pop() || '文件')
              .height(22)
              .width('100%')
              .fontSize(14)
              .fontColor('#000000')
              .textAlign(TextAlign.Start)
              .maxLines(1)// 限制为单行
              .id('fileName')

            Row() {
              Text(this.sCurrentDownloadSize + '/' + this.sFileSize)
                .fontSize(12)
                .fontColor('#66182431')
                .id('downloadVal')

              Text(this.state)
                .fontSize(12)
                .fontColor('#66182431')
                .margin({left: 10} as Margin)
                .id(this.fileName + 'state')
            }.width('100%')
            .height(23)
          }
          .width('90%')

          Image(this.downloading ?
          $r('app.media.multiple_files_download_start') : $r('app.media.multiple_files_download_stop'))
            .height(25)
            .width('10%')
            .id('downloadImage')
        }

        // 下载进度条，用于显示从下载进度更新回调中获取到的已下载数据大小
        Progress({ value: this.nCurrentDownloadSize, total: this.nFileSize, type: ProgressType.Capsule })
          .value(1)
          .value(this.nCurrentDownloadSize)
          .height(5)
          .id('progress')

      }
      .width('83%')
      .height(50)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(50)
    .margin({ top: 15, bottom: 15 } as Margin)
  }
}