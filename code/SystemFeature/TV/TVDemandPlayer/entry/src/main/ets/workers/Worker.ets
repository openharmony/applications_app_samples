/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { fileAccess } from '@kit.CoreFileKit';
import { FoldListType, UrlType } from '../const/Type';
import { BusinessError } from '@kit.BasicServicesKit';
import { isVideoFile, secToStr  } from '../utils/Utils';
import { fileIo as fs } from '@kit.CoreFileKit';

export class WorkerDataHolder {
  key: string = '';
  num: number = 0;

  constructor(key: string = '', num: number = 0) {
    this.key = key;
    this.num = num;
  }
}

export class WorkerPortHolder {
  postMessage(_message: string): void {
  }

  terminate(): void {
  }
}

export class Worker {
  data: string | number | boolean | Array<number> | WorkerDataHolder | null | undefined = null;
  dataLen: number = 0;
  worker: WorkerPortHolder | null = null;
  url: string = '';
  srcPath: string = '';

  constructor(data: string | number | boolean | Array<number> | WorkerDataHolder | null | undefined = null,
    dataLen: number = 0, url: string = '', srcPath: string = '') {
    this.data = data;
    this.dataLen = dataLen;
    this.url = url;
    this.srcPath = srcPath;
  }
}


let workerPort: ThreadWorkerGlobalScope | null = null;

function getWorkerPort(): ThreadWorkerGlobalScope | null {
  if (workerPort !== null) {
    return workerPort;
  }
  try {
    workerPort = worker.workerPort;
    return workerPort;
  } catch (_error) {
    return null;
  }
}

let context : Context | undefined
let pendingLocalVideoScan: boolean = false
/**
 * Defines the event handler to be called when the worker thread receives a message sent by the host thread.
 * The event handler is executed in the worker thread.
 *
 * @param event message data
 */
interface folderList {
  id: string,
  name: string,
  num: number,
  videoList: Array<UrlType>
}

type AllType = UrlType[]


function getFileAccesssHelper() {
  if (!context) {
    throw new Error('worker context is undefined');
  }
  return fileAccess.createFileAccessHelper(context);
}

function  getMediaVideoFilesPromise(fileInfo: fileAccess.RootInfo): Promise<AllType> {
  return new Promise((resolve, reject) => {
    let videos: UrlType[] = [];
    let fileIterator = fileInfo.listFile();
    let allPro: Promise<AllType>[] = [];
    let fileInfos: fileAccess.FileInfo[] = [];
    if (fileIterator) {
      let done = false;
      while (!done) {
        let info = fileIterator.next();
        done = info.done;
        if (done || !info.value) {
          continue;
        }

        let uri = info.value.uri;
        let isInVideoOrImage: boolean = uri.includes('/video')
        if (isInVideoOrImage) {
          allPro.push(scanVideosPromise(info.value));
        }
      }
      Promise.all(allPro).then((res) => {
        res.forEach((data) => {
          videos = videos.concat(data);
        })
        videos.forEach(t => {
          t.deviceType = 1
        })
        resolve(videos);
      }).catch((e: BusinessError) => {
        resolve([])
      })
    } else {
      resolve([])
    }
  });
}

function  getVideoFilesPromise(fileInfo: fileAccess.RootInfo): Promise<UrlType[]> {
  return new Promise((resolve, reject) => {
    let videos: UrlType[] = [];
    let fileIterator = fileInfo.listFile();
    if (fileIterator) {
      let done = false;
      let allPro: Promise<AllType>[] = [];
      while (!done) {
        let info = fileIterator.next();
        done = info.done;
        if (done || !info.value) {
          continue;
        }
        let arr = scanVideos(info.value)
        allPro.push(arr)
      }
      Promise.all(allPro).then((res: AllType[]) => {
        res.forEach((data) => {
          videos = videos.concat(data);
        })
        videos.forEach(t => {
          t.deviceType = 2
        })
        resolve(videos);
      }).catch((e: BusinessError) => {
        resolve([])
      })
    } else {
      resolve([]);
    }
  })
}

function    scanVideosPromise(info: fileAccess.FileInfo): Promise<UrlType[]> {
  return new Promise((resolve, reject) => {
    let videos: UrlType[] = [];
    if (info) {
      let uri = info.uri;
      let fileName = info.fileName;
      let mtime = info.mtime;
      let fileIterator = info.listFile();
      let allPro: Promise<AllType>[] = [];
      if (fileIterator) {
        let done = false;
        while (!done) {
          let fileIteratorInfo = fileIterator.next();
          done = fileIteratorInfo.done;
          if (done || !fileIteratorInfo.value) {
            continue;
          }
          allPro.push(scanVideos(fileIteratorInfo.value));
        }

        Promise.all(allPro).then((res) => {
          res.forEach((data) => {
            videos = videos.concat(data);
          })
          resolve(videos);
        }).catch((e: BusinessError) => {
          resolve([])
        })
      } else {
        if (isVideoFile(info.fileName)) {
          let createTime = secToStr(mtime * 1000);
          resolve([{
            uri,
            url:'',
            displayName: fileName,
            createTime
          }])
        }
      }
    } else {
      resolve([]);
    }
  })
}

async function  scanVideos(info: fileAccess.FileInfo): Promise<UrlType[]> {
  let videos: UrlType[] = [];
  if (info) {
    let uri = info.uri;
    let fileName = info.fileName;
    let mtime = info.mtime;
    let fileIterator = info.listFile();
    if (fileIterator) {
      let done = false;
      while (!done) {
        let fileIteratorInfo = fileIterator.next();
        done = fileIteratorInfo.done;
        if (done || !fileIteratorInfo.value) {
          continue;
        }
        let files = await scanVideos(fileIteratorInfo.value);
        videos = Array.from([...videos, ...files]);
      }
    } else {
      if (isVideoFile(info.fileName)) {
        let createTime = secToStr(mtime * 1000) as string
        return [{
          uri,
          url: '',
          displayName: fileName,
          createTime
        }]
      }
    }
  }
  return videos;
}

// 设置只扫根目录和一级目录
async function getUSBFiles(fileInfo: fileAccess.RootInfo) {
  console.log('wjx: getUSBFiles IN')
  let videos: UrlType[] = [];
  try {
    let fileIterator = fileInfo.listFile();
    if (fileIterator) {
      let done = false;
      while (!done) {
        let info = fileIterator.next();
        done = info.done;
        if (!done && info.value) {
          loopVideoFiles(videos, info.value);
        }
      }
    }
  } catch (e) {
    console.log('wjx: getUSBFiles catch e:' + JSON.stringify(e));
  }
  videos.forEach((t: UrlType) => {
    t.deviceType = 6
  })

  return videos;
}

// 递归遍历目录
function loopVideoFiles(videos: UrlType[], info: fileAccess.FileInfo) {
  try {
    // ========== 修复点 1：必须判空 ==========
    if (!info || !info.relativePath) {
      return;
    }

    let uri = info.uri;
    let fileName = info.fileName;
    let mtime = info.mtime;

    let stat = fs.statSync(info.relativePath);

    if (stat.isFile()) {
      if (isVideoFile(fileName)) {
        let createTime = secToStr(mtime * 1000);
        videos.push({
          uri,
          url: '',
          displayName: fileName,
          createTime
        });
      }
    } else {
      let fileIterator = info.listFile();
      if (fileIterator) {
        let done = false;
        while (!done) {
          let fileIteratorInfo = fileIterator.next();
          done = fileIteratorInfo.done;
          if (!done && fileIteratorInfo.value) {
            loopVideoFiles(videos, fileIteratorInfo.value);
          }
        }
      }
    }
  } catch (e) {
    console.log('wjx: loopVideoFiles catch e:' + JSON.stringify(e));
  }
}
function  parseVideos(res: AllType[], folderList: FoldListType[]) {
  let mediaVideos: UrlType[] = res.shift() || [];
  let shareVideos: UrlType[] = res.shift() || [];

  let localVideos: UrlType[] = mediaVideos.concat(shareVideos);
  folderList[0].num = localVideos.length;
  folderList[0].videoList = localVideos;

  const currentWorkerPort = getWorkerPort();
  if (currentWorkerPort === null) {
    return;
  }
  currentWorkerPort.postMessage({ key: 'folderList', value: folderList });
  currentWorkerPort.postMessage({ key: 'initFocus'});
  currentWorkerPort.postMessage({ key: 'isLoading', value: false });
}


async function getLocalVideos() {
  console.log('wjx: getLocalVideos is called ')

  if (!context) {
    pendingLocalVideoScan = true;
    return;
  }

  pendingLocalVideoScan = false;
  const currentWorkerPort = getWorkerPort();
  if (currentWorkerPort === null) {
    pendingLocalVideoScan = true;
    return;
  }
  currentWorkerPort.postMessage({ key: 'isLoading', value: true });
  let folderList: folderList[] = [
    {
      id: 'f_3',
      name: 'USB设备',
      num: 0,
      videoList: []
    }
  ]
  try {
    let fileAccesssHelper: fileAccess.FileAccessHelper = getFileAccesssHelper();
    let roots = await fileAccesssHelper.getRoots();
    console.log('wjx: roots')
    let done = false;
    let promiseArr: Promise<AllType>[] = [];
    let usbIndex = 3;
    while (!done) {
      let data = roots.next();
      done = data.done;
      if (done || !data.value) {
        continue;
      }

      let deviceType = data.value.deviceType;
      let displayName = data.value.displayName;
      console.log(`wjx: displayName:${displayName}`);
      if (deviceType == 1) { // 获取本地媒体库视频
        promiseArr[0] = getMediaVideoFilesPromise(data.value);
      } else if (deviceType == 2) { // 获取本地share目录视频
        promiseArr[1] = getVideoFilesPromise(data.value)
      } else if (deviceType == 6) { // 获取USB设备视频
        const currentWorkerPort = getWorkerPort();
        if (currentWorkerPort !== null) {
          currentWorkerPort.postMessage({ key: 'isUSBEnable', value: true });
        }

        getUSBFiles(data.value).then((res: UrlType[]) => {
          let usbVideos = res
          if (usbVideos.length > 0) {
            folderList[0].num = res.length
            folderList[0].videoList = usbVideos;
          }
          const currentWorkerPort = getWorkerPort();
          if (currentWorkerPort !== null) {
            currentWorkerPort.postMessage({ key: 'folderListSplice', value: folderList[0] });
          }

        })
      }
    }
    const currentWorkerPort = getWorkerPort();
    if (currentWorkerPort !== null) {
      currentWorkerPort.postMessage({ key: 'isLoading', value: false });
    }

    Promise.all(promiseArr).then((res: AllType[]) => {
      parseVideos(res, folderList);
    }).catch((e: BusinessError) => {
      console.log('wjx: zj e', JSON.stringify(e))
    })
  } catch (e) {
    const currentWorkerPort = getWorkerPort();
    if (currentWorkerPort !== null) {
      currentWorkerPort.postMessage({ key: 'isLoading', value: false });
    }
    console.log(`wjx: tgetLocalVideos catch err:` + JSON.stringify(e));
  }
}

function registerWorkerHandlers(): void {
  const currentWorkerPort = getWorkerPort();
  if (currentWorkerPort === null) {
    return;
  }

  currentWorkerPort.onmessage = (e: MessageEvents): void => {
    console.log('wjx: '+ e.data.key)
    if(e.data.key=='getLocalVideos'){
      getLocalVideos()
    } else if(e.data.key == 'context'){
      context = e.data.value
      if (pendingLocalVideoScan) {
        getLocalVideos()
      }
    }
  }

  /**
   * Defines the event handler to be called when the worker receives a message that cannot be deserialized.
   * The event handler is executed in the worker thread.
   *
   * @param event message data
   */
  currentWorkerPort.onmessageerror = (event: MessageEvents) => {
    console.error('workerPort onmessageerror');
  };

  /**
   * Defines the event handler to be called when an exception occurs during worker execution.
   * The event handler is executed in the worker thread.
   *
   * @param event error message
   */
  currentWorkerPort.onerror = (event: ErrorEvent) => {
    console.error('workerPort onerror err is: ', event.message);
  };
}

registerWorkerHandlers();
