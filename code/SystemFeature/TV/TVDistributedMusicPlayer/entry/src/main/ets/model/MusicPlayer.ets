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

//播放器静态类
import { media } from '@kit.MediaKit';
import logger from '../utils/Logger';
import { songItemType } from './Music';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { songs } from '../common/MusicConstants';
import preferencesUtils from '../utils/Preferences';
// 暂时注释掉AppStorage导入，使用全局变量替代
// import { AppStorageV2 as AppStorage } from '@kit.ArkUI';

// 全局变量替代AppStorage
let sendSongInfo: songItemType | null = null;


const TAG = 'MusicPlayer';
const KEY = 'musicList';

export default class AVPlayerClass {
  public player: media.AVPlayer | null = null;
  public duration: number = 0;
  public time: number = 0;
  //当前播放的时间
  public isPlay: boolean = false;
  //记录播放状态
  public playList: songItemType[] = [];
  // 播放列表 ，记录播放过的歌曲
  public playIndex: number = 0;
  //当前列表中播放的歌曲的序号
  public context: object | null = null;
  public hisIsPlay: boolean = false;
  public musicUri: string = '';

  // 初始化音乐播放器
  // 创建AVPlayer实例，加载播放列表，设置播放状态监听器
  public async init() {
    try {
      await media.createAVPlayer().then((value) => {
        let songInfo = sendSongInfo as songItemType;
        this.player = value;
        // 首次启动时使用默认歌曲列表，否则读取保存的列表
        if (preferencesUtils.readData('isFirst') === 'false') {
          this.playList = preferencesUtils.readData(KEY) as songItemType[];
        } else {
          this.playList = songs;
          preferencesUtils.writeData(KEY, songs);
        }

        // 如果有外部传入的音乐信息，添加到播放列表开头
        if (songInfo) {
          songInfo.img = $r('app.media.album4');
          this.playList.unshift(songInfo);
        }
      });
      console.info('musicPlayer list0:', JSON.stringify(this.playList[0]));
      // 暂时注释掉上下文获取，使用null替代
      this.context = null;
    } catch (e) {
      console.error('musicPlayer error:', 'err code : ', JSON.stringify(e));
      return;
    }
    // 延迟初始化播放器，确保AVPlayer实例完全创建
    setTimeout(() => {
      if (this.player) {
        // 打开第一首歌曲文件，设置播放器源
        let filePath: number = fileIo.openSync(this.playList[0].url).fd;
        this.player.url = 'fd://' + filePath;
      }

      // 监听播放器状态变化
      this.player?.on('stateChange', (state: media.AVPlayerState) => {
        if (this.player) {
          console.info('musicPlayer state:', state);
          switch (state) {
            case 'initialized':
              // 初始化完成后准备播放
              this.player.prepare();
              break;
            case 'prepared':
              // 准备完成后，根据历史播放状态决定是否暂停
              if (!this.hisIsPlay) {
                this.player.pause();
                break;
              }
              // 恢复播放进度
              this.player.seek(this.time);
              this.isPlay = true;
              break;
            case 'completed':
              // 播放完成后，自动播放下一首
              if (this.playList.length > 1) {
                this.playIndex++;
                this.playIndex = (this.playIndex + this.playList.length) % this.playList.length;
              }
              this.singlePlay(this.playList[this.playIndex]);
              break;
          }
        }
      });
      // 监听歌曲时长更新
      this.player?.on('durationUpdate', (duration) => {
        this.duration = duration;
        this.playList[this.playIndex].time = duration;
      });
      // 监听播放进度更新
      this.player?.on('timeUpdate', (time) => {
        if (time !== 0 && time !== this.time) {
          this.time = time;
        }
      });
      // 监听 seek 操作完成
      this.player?.on('seekDone', () => {
        if (this.player && this.isPlay) {
          this.player.play();
        }
      });
    }, 800);
  }

  // 根据传入的状态信息，找到对应的歌曲并恢复播放
  restorePlayingStatus(status: Record<string, string | number | boolean | object>,
    callback: ((index: number) => void)) {
    logger.info(TAG, `1 restorePlayingStatus ${JSON.stringify(status)}`);
    // 遍历播放列表，寻找与状态中uri匹配的歌曲
    for (let i = 0; i < this.playList.length; i++) {
      logger.info(TAG, `2 restorePlayingStatus ${i}`);
      if (this.playList[i].url === status.uri) {
        logger.info(TAG, `3 restorePlayingStatus ${i}`);
        logger.info(TAG, `restore to index ${i}`);
        // 预加载找到的歌曲，然后播放
        this.preLoad(i, () => {
          this.singlePlay(this.playList[this.playIndex]);
          logger.info(TAG, 'restore play status');
          // 回调通知恢复完成
          callback(i);
        });
        return;
      }
    }
    logger.info(TAG, '4 restorePlayingStatus failed');
    // 未找到对应的歌曲，回调通知失败
    callback(-1);
  }

  // 切换播放/暂停状态
  // 根据当前播放状态，执行相应的操作
  public playAndPause() {
    if (this.player) {
      if (this.isPlay) {
        // 当前正在播放，执行暂停操作
        this.player.pause();
        this.hisIsPlay = false;
        this.isPlay = false;
      } else {
        // 当前已暂停，执行播放操作
        this.player.play();
        this.hisIsPlay = true;
        this.isPlay = true;
      }
    }
  }

  // 开始播放
  // 设置播放状态为true，并调用播放器的play方法
  play() {
    this.isPlay = true;
    this.player?.play();
  }

  // 播放指定的歌曲
  // 如果播放器未设置url，直接设置；否则切换到指定歌曲
  public singlePlay(song: songItemType) {
    if (this.player) {
      // 设置历史播放状态为true
      this.hisIsPlay = true;
      if (this.player.url === '') {
        // 播放器未设置url，直接设置为当前歌曲
        this.player.url = song.url;
      } else {
        // 找到歌曲在播放列表中的索引
        this.playIndex = this.playList.findIndex(item => item.url === song.url);
        // 切换到该歌曲
        this.changePlay();
      }
    }
  }

  // 预加载指定索引的歌曲
  // 打开文件并设置播放器源，准备播放
  preLoad(index: number, callback: (() => void)) {
    if (this.player === undefined || this.player?.state === undefined) {
      logger.error(TAG, 'preLoad failed player state is undefined');
      return;
    }
    logger.info(TAG, `preLoad ${index}/${this.playList.length}`);
    // 检查索引是否有效
    if (index < 0 || index >= this.playList.length) {
      logger.error(TAG, 'preLoad ignored');
      return;
    }
    // 更新当前播放索引
    this.playIndex = index;
    let uri: string = this.playList[index].url;
    // 打开歌曲文件（Promise方式）
    fileIo.open(uri).then((fdNumber: fileIo.File) => {
      // 构建文件描述符路径
      let fdPath: string = 'fd://';
      let source: string = fdPath + fdNumber.fd;
      logger.info(TAG, `preLoad source ${source}`);
      if (typeof (source) === 'undefined') {
        logger.error(TAG, `preLoad ignored source= ${source}`);
        return;
      }
      logger.info(TAG, `preLoad ${source} begin`);
      logger.info(TAG, `state= ${this.player?.state}`);
      // 如果源未改变且播放器状态不是idle，直接回调
      if (source === this.player?.url && this.player?.state !== 'idle') {
        logger.info(TAG, 'preLoad finished. src not changed');
        callback();
      } else {
        // 重置播放器
        this.player?.reset();
        logger.info(TAG, `player.reset done, state= ${this.player?.state}`);
        // 监听播放器状态变化，准备完成后回调
        this.player?.on('stateChange', (state: media.AVPlayerState) => {
          if (state === 'prepared') {
            logger.info(TAG, `prepared callback, state= ${this.player?.state}`);
            callback();
          }
        });
        logger.info(TAG, `player.src= ${source}`);
        if (this.player === undefined) {
          logger.error(TAG, `player= undefined`);
        } else {
          if (this.player) {
            // 设置播放器源
            this.player.url = source;
            logger.info(TAG, 'source : ', source);
          }
        }
      }
      logger.info(TAG, `preLoad ${source} end`);
    }).catch((err: BusinessError) => {
      logger.error('open failed with error message: ' + err.message + ', error code: ' + err.code);
    });
  }

  // 切换播放歌曲
  // 重置播放器，清空播放进度，根据歌曲类型设置播放源
  public async changePlay() {
    if (this.player) {
      // 重置播放器
      await this.player.reset();
      // 清空播放进度和时长
      this.duration = 0;
      this.time = 0;
      let uri: string = this.playList[this.playIndex].url;
      try {
        if (uri.includes('http')) {
          // 网络音乐，直接设置url
          console.log('hmlog==>','网络音乐');
          this.player.url = uri;
          return;
        }
        // 本地文件，通过文件描述符打开
        let file: fileIo.File = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
        let fd: number = file.fd;
        this.player.url = `fd://${fd}`;
      } catch (e) {
        console.log('hmlog==》', JSON.stringify(e));
      }
    }
  }

  // 暂停播放
  // 调用播放器的pause方法，更新播放状态
  public async pause() {
    if (this.player) {
      // 暂停播放
      await this.player.pause();
      // 更新播放状态为false
      this.isPlay = false;
      // 收集通知的数据
    }
  }

  // 播放下一首歌曲
  // 增加播放索引，循环播放，然后播放对应歌曲
  next() {
    if (this.playList.length === 0) {
      return;
    }
    if (this.playList.length > 1) {
      // 增加播放索引
      this.playIndex++;
      // 循环播放，确保索引在有效范围内
      this.playIndex = (this.playIndex + this.playList.length) % this.playList.length;
    }
    // 播放当前索引对应的歌曲
    this.singlePlay(this.playList[this.playIndex]);
  }


  // 播放上一首歌曲
  // 减少播放索引，循环播放，然后播放对应歌曲
  public previous() {
    if (this.playList.length === 0) {
      return;
    }
    if (this.playList.length > 1) {
      // 减少播放索引
      this.playIndex--;
      // 循环播放，确保索引在有效范围内
      this.playIndex = (this.playIndex + this.playList.length) % this.playList.length;
    }
    // 播放当前索引对应的歌曲
    this.singlePlay(this.playList[this.playIndex]);
  }

  // 更新播放列表并播放指定索引的歌曲
  // 替换当前播放列表，设置新的播放索引，然后播放对应歌曲
  musicList(list: songItemType[], index: number) {
    // 更新播放列表
    this.playList = list;
    // 设置新的播放索引
    this.playIndex = index;
    // 播放当前索引对应的歌曲
    this.singlePlay(this.playList[this.playIndex]);
  }
}
