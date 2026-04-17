import media from '@ohos.multimedia.media';
import { KeyCode } from '@kit.InputKit';
import { ItemsType } from '../const/Type';
import { EventBus } from '../utils/EventBus';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { display } from '@kit.ArkUI';
import { getVideoSize } from '../utils/utils';
import { rpc } from '@kit.IPCKit';
import { DistributedEventCode } from '../const/distributedEventCode';
import { getLanguageName } from '../utils/LanguageCodeUtil';
import { fileIo } from '@kit.CoreFileKit';
import { log } from '../utils/log';
import { drm } from '@kit.DrmKit';

type AVPlayerEventCallback =
  ((state: media.AVPlayerState, reason: media.StateChangeReason) => void) |
  ((err: BusinessError) => void) |
  (() => void) |
  ((info: media.SubtitleInfo) => void) |
  ((mediaKeySystemInfo: drm.MediaKeySystemInfo[]) => void) |
  ((infoType: media.BufferingInfoType, value: number) => void) |
  ((time: number) => void) |
  ((duration: number) => void);

export abstract class TestableAVPlayer {
  abstract currentTime: number;
  abstract duration: number;
  abstract state: media.AVPlayerState;
  abstract surfaceId: string;
  abstract url: string;
  abstract fdSrc: media.AVFileDescriptor;
  abstract width: number;
  abstract height: number;
  abstract on(event: 'stateChange', callback: (state: media.AVPlayerState, reason: media.StateChangeReason) => void): void;
  abstract on(event: 'error', callback: (err: BusinessError) => void): void;
  abstract on(event: 'seekDone' | 'startRenderFrame', callback: () => void): void;
  abstract on(event: 'subtitleUpdate', callback: (info: media.SubtitleInfo) => void): void;
  abstract on(event: 'mediaKeySystemInfoUpdate', callback: (mediaKeySystemInfo: drm.MediaKeySystemInfo[]) => void): void;
  abstract on(event: 'bufferingUpdate', callback: (infoType: media.BufferingInfoType, value: number) => void): void;
  abstract on(event: 'timeUpdate' | 'durationUpdate', callback: (value: number) => void): void;
  abstract on(event: string, callback: AVPlayerEventCallback): void;
  abstract off(event: 'error' | 'startRenderFrame' | 'timeUpdate' | 'durationUpdate'): void;
  abstract off(event: string): void;
  abstract getTrackDescription(callback: (error: BusinessError, data: media.MediaDescription[]) => void): void;
  abstract setPlaybackStrategy(strategy: media.PlaybackStrategy): Promise<void>;
  abstract prepare(): Promise<void>;
  abstract play(): Promise<void>;
  abstract pause(): Promise<void>;
  abstract reset(): Promise<void>;
  abstract release(): Promise<void>;
  abstract setSpeed(speed: number): void;
  abstract seek(time: number, mode?: media.SeekMode): void;
  abstract selectTrack(trackId: number, mode: media.SwitchMode): Promise<void>;
  abstract addSubtitleFromUrl(url: string): Promise<void>;
  abstract setDecryptionConfig(session: drm.MediaKeySession, svp: boolean): void;
}

export class VideoAVPlayerClass {
  // 创建的播放器实例
  public avPlayer: media.AVPlayer | TestableAVPlayer | null = null;
  public time: number = 0
  public duration: number = 0
  public isCompleted: boolean = false
  public vWidth: number = 0
  public vHeight: number = 0
  public currentAudioTrackIndex: number = -1

  // 初始化播放器
  public async init() {

    this.avPlayer = await media.createAVPlayer();
  }

  public async setAVPlayerCallback(surfaceId: string, callback: (audioTrackList: ItemsType[]) => void) {

    let innerEvent: emitter.InnerEvent = {
      eventId: 1,
      priority: emitter.EventPriority.HIGH
    };
    let eventDataFalse: emitter.EventData = {
      data: {
        'flag': true
      }
    };

    let preparedStateEvent: emitter.InnerEvent = {
      eventId: 2,
      priority: emitter.EventPriority.HIGH
    };

    // 监听状态变化
    this.avPlayer?.on('stateChange', async (state: media.AVPlayerState, reason: media.StateChangeReason) => {
      switch (state) {
        case 'idle':
          AppStorage.setOrCreate('isPlaying', false)
          console.info('AVPlayer is in idle state.');
          break;
        case 'initialized':
          console.log('====77777initialized', Date.now())
          // 起播水线定为预计可以播放10s的缓存值
          let playStrategy: media.PlaybackStrategy = {
            preferredBufferDuration: 10,
          };
          await this.avPlayer!.setPlaybackStrategy(playStrategy);
          if (surfaceId) {
            this.avPlayer!.surfaceId = surfaceId
            console.info('AVPlayer is initialized.' + surfaceId);
          } else {
            console.error('surfaceId is null');
          }
          // 准备播放
          try {
            await this.avPlayer!.prepare();
          } catch (e) {
            console.info('AVPlayer to be prepared. failed:', JSON.stringify(e));
          }
          break;
        case 'prepared':
          console.log('====8888prepared', Date.now())
          console.info('AVPlayer is prepared.');

          try {
            this.avPlayer?.getTrackDescription((error: BusinessError, data: media.MediaDescription[]) => {
              if (data?.length > 0) {
                let audioTrackList: ItemsType[] = []
                data.forEach((item: media.MediaDescription, index: number) => {
                  let codeMineStr = item["codec_mime"] as string
                  let codeMine = codeMineStr.split('/')
                  if (codeMine[0] === "video") {
                    this.vWidth = item["width"] as number
                    this.vHeight = item["height"] as number
                    // Surface尺寸由 videoPlayer.ets 的 preparedStateEvent 统一处理，
                    // 避免在此处重复设置导致与旋转角度逻辑冲突
                  } else if (codeMine[0] === "audio") {
                    const languageName = getLanguageName(item[media.MediaDescriptionKey.MD_KEY_LANGUAGE] as string)
                    const audioTrackItem: ItemsType = {
                      id: 's_4_' + index,
                      name: languageName,
                      param: index
                    }
                    audioTrackList.push(audioTrackItem)
                  }
                })
                // 默认选择第一个音轨
                if (audioTrackList.length > 0) {
                  this.setAudioTracks(audioTrackList[0], 0)
                } else {
                  // 如果视频里面不带有音轨属性，让其等于未知
                  audioTrackList.push({
                    id: 's_4_' + 0,
                    name: getLanguageName(''),
                    param: 0
                  })
                }
                audioTrackList = this.processAudioTracks(audioTrackList)
                callback(audioTrackList)
              } else {
                console.error(`Failed to do getTrackDescription, error:${error}`);
              }
            })
          } catch (e) {
            console.error(`Failed to do getTrackDescription, error:${e}`);
          }

          if (globalThis.startByOther || globalThis.startByLauncher) {
            this.avPlayer?.seek(globalThis.currentTime + 40);
          }
          if (globalThis.isTransferData) {
            let sendOption = new rpc.MessageOption();
            let sendData = new rpc.MessageSequence();
            let sendReply = new rpc.MessageSequence();
            let remote = (globalThis.localExtensionRemote as rpc.IRemoteObject)
            remote.sendMessageRequest(DistributedEventCode.SYNC_PLAYER_TIME_SERVICE, sendData, sendReply, sendOption)
            this.avPlayer?.seek(globalThis.currentTime)
          }
          this.avPlayer!.play();
          emitter.emit(preparedStateEvent);
          console.log('====99999play', Date.now())
          break;
        case 'playing':
          // 同步状态
          AppStorage.setOrCreate('isPlaying', true)
          AppStorage.setOrCreate('hideXComponent', false)
          if (!globalThis.isPlay) {
            this.avPlayer!.pause();
          }
          console.info('AVPlayer is playing.');
          break;
        case 'paused':
          AppStorage.setOrCreate('isPlaying', false)
          console.info('AVPlayer is paused.');
          break;
        case 'completed':
          AppStorage.setOrCreate('isPlaying', false)
          this.isCompleted = true
          this.avPlayer?.setSpeed(1)
          if (this.isCompleted) {
            this.avPlayer?.reset()
            emitter.emit(innerEvent, eventDataFalse);
            this.isCompleted = false
          }
          break;
        case 'stopped':
          AppStorage.setOrCreate('isPlaying', false)
          console.info('AVPlayer is stopped.');
          break;
        case 'released':
          AppStorage.setOrCreate('isPlaying', false)
          console.info('AVPlayer is released.');
          break;
        default:
          console.info('Unknown AVPlayer state.');
          break;
      }
    });

    // 监听错误事件
    this.avPlayer!.on('error', (err) => {
      console.error('AVPlayer error:', err);
    });

    this.avPlayer!.on("seekDone", () => {
      AppStorage.setOrCreate('isSeek', false)
      if (this.avPlayer?.state == 'paused') {
        this.avPlayer?.play();
      }
    })
    // 字幕回调函数
    this.avPlayer!.on('subtitleUpdate', (info: media.SubtitleInfo) => {
      if (info) {
        let text = (!info.text) ? '' : info.text;
        let startTime = (!info.startTime) ? 0 : info.startTime;
        let duration = (!info.duration) ? 0 : info.duration;
        console.info(`subtitleUpdate info: text=${text} startTime=${startTime} duration=${duration}`);
        AppStorage.setOrCreate('subtitles', text);
      } else {
        console.info(`subtitleUpdate info is null`);
      }
    });
  }


  // 设置播放源并播放
  public async play(url: string) {
    // 添加字幕源
    let subtitleUrl: string = ''
    let subtitle = AppStorage.get('subtitleUrl') as string
    let videoUri = AppStorage.get('videoUri') as string
    let fdPath = AppStorage.get('fdPath') as string
    if (subtitle) {
      // let subtitleUrl_or = decodeURI(videoUri.replace(/\.[^/.]+$/, subtitle));不用解码也行
      let subtitleUrl_or = videoUri.replace(/\.[^/.]+$/, subtitle);
      let urlFd = fileIo.openSync(subtitleUrl_or)?.fd;
      subtitleUrl = 'fd://' + urlFd;
    }
    // 重置播放器到idle状态
    await this.avPlayer!.reset();
    this.currentAudioTrackIndex = -1
    if (this.avPlayer?.state == 'idle') {
      if (url?.startsWith('rawfile://')) {
        let fileName = url.substring('rawfile://'.length);
        this.avPlayer!.fdSrc = getContext(this).resourceManager.getRawFdSync(fileName);
      } else {
        this.avPlayer!.url = url;
        // 添加字幕
        if (fdPath == url) {
          try {
            await this.avPlayer.addSubtitleFromUrl(subtitleUrl);
          } catch (e) {
            console.log('addSubtitleFromUrl_fail', JSON.stringify(e))
          }
        }
      }
    }
  }

  // 左右按键快进快退
  public async keyEventLeftRight(e: KeyEvent) {
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT || e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT) {
      e.stopPropagation();
    }
    if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT) {

      if (e.type == KeyType.Down && this.avPlayer?.state == "playing") { // left Down
        this.seekVideo(1);
      }
    } else if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && this.avPlayer?.state == "playing") {

      if (e.type == KeyType.Down) { // right Down
        this.seekVideo(0);
      }
    }
  }

  // 0：前进10秒，1：后退10秒
  public seekVideo(n: number) {
    if (this.avPlayer) {
      let currentTime = this.avPlayer.currentTime;
      if (n == 0) {
        currentTime += 10000;
      } else if (n == 1) {
        currentTime -= 10000;
      }

      if (currentTime >= this.avPlayer.duration) {
        currentTime = this.avPlayer.duration - 50;
      }
      if (currentTime <= 0) {
        currentTime = 0;
      }
      this.avPlayer.seek(currentTime, media.SeekMode.SEEK_CLOSEST)
    }
  }

  // 设置倍速
  public setSpeed(data: ItemsType) {
    let speed = Number(data.param);
    globalThis.videoSpeed = speed;
    if (this.avPlayer) {
      this.avPlayer.setSpeed(speed)
    }
  }

  // 设置分辨率
  public setResolution(data: ItemsType) {

  }

  // 设置声道
  public setAudioChannelMode(data: ItemsType) {

  }

  //设置音频轨道
  public async setAudioTracks(data: ItemsType, time: number, keepPlaying: boolean = false) {
    if (!this.avPlayer || data.param === undefined) {
      return;
    }
    const trackIndex = Number(data.param);
    if (!Number.isInteger(trackIndex) || trackIndex < 0) {
      return;
    }
    if (this.currentAudioTrackIndex === trackIndex) {
      return;
    }
    const allowSwitchStates: media.AVPlayerState[] = ['prepared', 'playing', 'paused', 'completed'];
    if (!allowSwitchStates.includes(this.avPlayer.state)) {
      return;
    }
    const shouldResumeAfterSwitch = keepPlaying || this.avPlayer.state === 'playing';
    try {
      await this.avPlayer.selectTrack(trackIndex, media.SwitchMode.CLOSEST);
      this.currentAudioTrackIndex = trackIndex;
    } catch (err) {
      log(`setAudioTracks selectTrack fail: ${JSON.stringify(err)}`);
      return;
    }
    const seekBaseTime = Number.isFinite(time) ? time : this.avPlayer.currentTime;
    const seekTime = Math.max(0, Math.floor(seekBaseTime + 40));
    if (['playing', 'paused', 'completed'].includes(this.avPlayer.state)) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_CLOSEST);
      } catch (err) {
        log(`setAudioTracks seek fail: ${JSON.stringify(err)}`);
      }
    }
    if (shouldResumeAfterSwitch && this.avPlayer.state !== 'playing') {
      try {
        await this.avPlayer.play();
      } catch (err) {
        log(`setAudioTracks resume play fail: ${JSON.stringify(err)}`);
      }
    }
  }

  //停止播放
  public stop() {
    this.avPlayer?.reset()
    this.currentAudioTrackIndex = -1
    AppStorage.setOrCreate('hideXComponent', true)
  }

  // 处理音轨显示把有未知的放到后面并重命名音轨1，音轨2这些
  processAudioTracks(audioTrackList: ItemsType[]): ItemsType[] {
    const knownTracks: ItemsType[] = [];
    const unknownTracks: ItemsType[] = [];

    audioTrackList.forEach(item => {
      if (item.name !== '未知') {
        knownTracks.push(item);
      } else {
        unknownTracks.push(item);
      }
    });
    audioTrackList.length = 0;
    knownTracks.forEach(item => audioTrackList.push(item));
    unknownTracks.forEach((item, index) => {
      item.name = `音轨${knownTracks.length + index + 1}`;
      audioTrackList.push(item);
    });
    return audioTrackList;
  }
}
