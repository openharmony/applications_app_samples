/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import userFileManager from '@ohos.filemanagement.userFileManager';
import media from '@ohos.multimedia.media';
import Logger from '../model/Logger';

const TAG = 'myMedia:';

export class myMedia {
  public resourceAddress: userFileManager.FileAsset = undefined;
  public fileName: string = undefined;
  public totalDuration: number = 0;
  public format: string;
  public mediaType: number;
  private playStatus: string;
  private playMode: string;
  private currentNode: string;
  private media: media.AVPlayer;
  private surfaceId: string = '';
  private isLoop: boolean;
  private audioData: userFileManager.FileAsset[];
  private videoData: userFileManager.FileAsset[];
  private fileIndex: number = 0;
  private mediaDataLen: number;
  private uri: string = undefined;

  getAudioData(audioData) {
    this.audioData = audioData;
  }

  getVideoData(videoData) {
    this.videoData = videoData;
  }

  prev(surfaceId) {
    if (this.fileIndex > 0) {
      this.fileIndex -= 1;
    } else {
      this.fileIndex = this.mediaDataLen - 1;
    }
    if (this.resourceAddress.fileType == userFileManager.FileType.AUDIO) {
      this.resourceAddress = this.audioData[this.fileIndex];
      this.init(this.resourceAddress);
    } else if (this.resourceAddress.fileType == userFileManager.FileType.VIDEO) {
      this.resourceAddress = this.videoData[this.fileIndex];
      this.init(this.resourceAddress, surfaceId);
    }
  }

  next(surfaceId?) {
    if (this.fileIndex < this.mediaDataLen - 1) {
      this.fileIndex += 1;
    } else {
      this.fileIndex = 0;
    }
    if (this.resourceAddress.fileType == userFileManager.FileType.AUDIO) {
      this.resourceAddress = this.audioData[this.fileIndex];
      this.init(this.resourceAddress);
    } else if (this.resourceAddress.fileType == userFileManager.FileType.VIDEO) {
      this.resourceAddress = this.videoData[this.fileIndex];
      this.init(this.resourceAddress, surfaceId);
    }
  }

  getFileIndex(data) {
    data.forEach((file, index) => {
      if (file.uri === this.resourceAddress.uri) {
        this.fileIndex = index;
      }
    });
  }

  getResourceAddress() {
    return this.resourceAddress;
  }

  async httpInit(url, surfaceId?) {
    this.uri = url;
    if (surfaceId) {
      this.surfaceId = surfaceId.toString();
      Logger.info(TAG, `surfaceId success: ${surfaceId}`);
    }
    this.stop();
    this.release();
    this.media = await media.createAVPlayer();
    this.setVideoCallBack(this.media);
    this.media.url = url;
    this.media.surfaceId = this.surfaceId;
    Logger.info(TAG, 'httpInit success');
    await this.media.prepare();
    this.totalDuration = this.media.duration;
    this.fileName = 'Http';
    this.media.play();
  }

  async init(resourceAddress: userFileManager.FileAsset, surfaceId?) {
    Logger.info(TAG, 'init state');
    if (surfaceId) {
      this.surfaceId = surfaceId.toString();
      Logger.info(TAG, `surfaceId success: ${surfaceId}`);
    }
    this.stop();
    this.release();
    this.resourceAddress = resourceAddress;
    Logger.info(TAG, `resourceAddress success: ${this.resourceAddress}`);
    this.fileName = resourceAddress.displayName;
    Logger.info(TAG, `fileName success: ${this.fileName}`);
    this.totalDuration = resourceAddress.get('duration') as number;
    Logger.info(TAG, `totalDuration success: ${this.totalDuration}`);
    this.resourceAddress.open('r').then(async (fd) => {
      Logger.info(TAG, `fd success: ${fd}`);
      this.media = await media.createAVPlayer();
      this.media.url = 'fd://' + fd;
      if (this.resourceAddress.fileType == userFileManager.FileType.AUDIO) {
        Logger.info(TAG, 'AUDIO success');
        this.getFileIndex(this.audioData);
        this.mediaDataLen = this.audioData.length;
        Logger.info(TAG, `AUDIO success: ${this.media}`);
        this.setAudioCallBack(this.media);
      } else if (this.resourceAddress.fileType == userFileManager.FileType.VIDEO) {
        Logger.info(TAG, 'VIDEO success');
        this.getFileIndex(this.videoData);
        this.mediaDataLen = this.videoData.length;
        this.setVideoCallBack(this.media);
        this.media.surfaceId = this.surfaceId;
        await this.media.prepare();
        Logger.info(TAG, 'VIDEO end');
      }
      this.getPlay();
      this.getPlayMode(this.isLoop);
    });
  }

  setAudioCallBack(audioPlayer) {
    audioPlayer.on('dataLoad', () => {
      Logger.info(TAG, 'AUDIO case dataLoad called');
      Logger.info(TAG, `AUDIO audioPlayer.duration : ${audioPlayer.duration}`);
    });
    audioPlayer.on('pause', () => {
      Logger.info(TAG, 'AUDIO case pause called');
    });
    audioPlayer.on('play', () => {
      Logger.info(TAG, 'AUDIO case play called');
    });
    audioPlayer.on('stop', () => {
      Logger.info(TAG, 'AUDIO case stop called');
    });
    audioPlayer.on('finish', () => {
      Logger.info(TAG, 'AUDIO case finish called');
      this.release();
      if (this.resourceAddress && this.resourceAddress.fileType) {
        this.next();
      }
    });
    audioPlayer.on('error', (err) => {
      Logger.info(TAG, ` AUDIO audioPlayer error called : ${err}`);
    });
  }

  setVideoCallBack(videoPlayer) {
    videoPlayer.on('prepare', () => {
      Logger.info(TAG, 'VIDEO start');
      Logger.info(TAG, 'VIDEO videoPlayer duration');
    });

    videoPlayer.on('playing', () => {
      Logger.info(TAG, 'VIDEO playing finish');
    });
    videoPlayer.on('paused', () => {
      Logger.info(TAG, 'VIDEO paused finish');
    });
    videoPlayer.on('stopped', () => {
      Logger.info(TAG, 'VIDEO stopped finish');
    });
    videoPlayer.on('error', (err) => {
      Logger.info(TAG, `VIDEO error : ${err}`);
    });
    videoPlayer.on('playbackCompleted', () => {
      Logger.info(TAG, 'VIDEO playbackCompleted finish');
      this.release();
      if (this.resourceAddress && this.resourceAddress.fileType) {
        this.next();
      }
    });
  }

  setIsLoopCallBack(boole) {
    this.isLoop = boole;
  }

  private getPlayStatus() {
    return this.media.state;
  }

  getPlayMode(boole) {
    Logger.info(TAG, `getPlayMode state : ${boole}`);
    if (boole) {
      this.media.loop = true;
    } else {
      this.media.loop = false;
    }
  }

  getPlay() {
    if (typeof (this.media) != 'undefined') {
      Logger.info(TAG, 'getPlay success');
      this.media.play();
    }
  }

  stop() {
    if (typeof (this.media) != 'undefined') {
      this.media.stop();
    }
  }

  release() {
    if (typeof (this.media) != 'undefined') {
      this.media.release();
    }
  }

  reset() {
    if (typeof (this.media) != 'undefined') {
      this.media.reset();
    }
  }

  getPause() {
    if (typeof (this.media) != 'undefined') {
      this.media.pause();
    }
  }

  getCurrentTime() {
    if (typeof (this.media) != 'undefined') {
      return this.media.currentTime;
    }
    return 0;
  }

  setSpeed(speed) {
    if (typeof (this.media) != 'undefined') {
      this.media.setSpeed(speed);
      Logger.info(TAG, 'setSpeed success');
    }
  }

  async seek(time) {
    if (typeof (this.media) != 'undefined') {
      await this.media.seek(time);
    }
  }
}