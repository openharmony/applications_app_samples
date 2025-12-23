import { common }from '@kit.AbilityKit';
import { media } from '@kit.MediaKit';
import { hilog } from '@kit.PerformanceAnalysisKit'
import { VideoData } from '../model/VideoData';
import { FrameNode } from '@kit.ArkUI';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { CommonConstants, VideoDataType } from '../common/constants/CommonConstants';

const TAG = '[AVPlayerController]';

@Observed
export class AVPlayerController {
  @Track surfaceID: string = '';
  @Track isPlaying: boolean = false;
  @Track currentTime: number = 0;
  @Track durationTime: number = 0;
  private avPlayer?: media.AVPlayer;
  private curSource?: VideoData;
  private context: common.Context | undefined = undefined
  private seekTime?: number
  private isMuted: boolean | undefined = undefined

  constructor(context: common.Context) {
    this.context = context;
  }

  public async initAVPlayer(source: VideoData, surfaceId: string) {
    this.curSource = source;
    if (source.seekTime) {
      this.seekTime = source.seekTime;
    }
    if (source.isMuted) {
      this.isMuted = source.isMuted
    }
    if (!this.curSource) {
      return;
    }
    this.surfaceID = surfaceId;
    try {
      this.avPlayer = await media.createAVPlayer();
      this.setAVPlayerCallback();
      switch (this.curSource.type) {
        case VideoDataType.RAW_FILE:
          let fileDescriptor = await this.context?.resourceManager.getRawFd(this.curSource.videoSrc);
          this.avPlayer.fdSrc = fileDescriptor;
          break;
        case VideoDataType.URL:
          this.avPlayer.url = this.curSource.videoSrc;
          break;
        case VideoDataType.RAW_M3U8_FILE:
          let m3u8Fd = await this.context?.resourceManager.getRawFd(this.curSource.videoSrc);
          let fdUrl = 'fd://' + m3u8Fd?.fd + '?offset=' + m3u8Fd?.offset + '&size=' + m3u8Fd?.length;
          let mediaSource = media.createMediaSourceWithUrl(fdUrl);
          mediaSource.setMimeType(media.AVMimeTypes.APPLICATION_M3U8);
          let playbackStrategy: media.PlaybackStrategy = { preferredBufferDuration:20, showFirstFrameOnPrepare: true };
          await this.avPlayer.setMediaSource(mediaSource, playbackStrategy);
          break;
        case VideoDataType.RAW_MAP4_FILE:
          let mp4Fd = await this.context?.resourceManager.getRawFd(this.curSource.videoSrc);
          let mp4FdUrl = 'fd://' + mp4Fd?.fd;
          this.avPlayer.url = mp4FdUrl;
          break;
        default :
          break;
      }
    } catch (err) {
      hilog.error(CommonConstants.LOG_DOMAIN, TAG,
        `InitPlayer failed, code is ${err.code}, message is ${err.message}`);
    }
  }
  private setAVPlayerCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('durationUpdate', (time: number) => {
      AppStorage.setOrCreate('DurationTime', time);
    });
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
      AppStorage.setOrCreate('CurrentTime', time);
    });
    this.avPlayer.on('error', (err: BusinessError) => {
      if (!this.avPlayer) {
        return;
      }
      hilog.error(CommonConstants.LOG_DOMAIN, TAG,
        `Invoke avPlayer failed, code is ${err.code}, messasge is ${err.message}`);
      this.avPlayer.reset().catch((err: BusinessError) => {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `Reset failed, code is ${err.code}, message is ${err.message}`);
      });
      this.setStateChangeCallback();
    })
  }

  private setStateChangeCallback() {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('stateChange', async (state) => {
      if(!this.avPlayer) {
        return;
      }
      switch (state) {
        case 'idle':
          hilog.info(CommonConstants.LOG_DOMAIN, TAG, `setAVPlayerCallback AVPlayer state idle called.`);
          break;
        case 'initialized':
          this.avPlayer.surfaceId = this.surfaceID;
          this.avPlayer.prepare().catch((err: BusinessError) => {
            hilog.error(CommonConstants.LOG_DOMAIN, TAG,
              `prepare failed, code is ${err.code}, message is ${err.message}`);
          });
          break;
        case 'prepared':
          this.avPlayer.loop = true;
          this.durationTime = this.avPlayer.duration;
          this.currentTime = this.avPlayer.currentTime;
          if (this.seekTime) {
            this.avPlayer.seek(this.seekTime!, media.SeekMode.SEEK_CLOSEST);
          }
          let eventData: emitter.EventData = {
            data: {
              'percent': this.avPlayer.width / this.avPlayer.height
            }
          };
          emitter.emit(CommonConstants.AVPLAYER_PREPARED, eventData);
          if (this.isMuted) {
            try {
              await this.avPlayer.setMediaMuted(media.MediaType.MEDIA_TYPE_AUD, this.isMuted!)
            } catch (err) {
              hilog.error(CommonConstants.LOG_DOMAIN,TAG,
                `setMediaMuted failed, code is ${err.code}, message is ${err.message}`);
            }
          }
          this.avPlayer.videoScaleType = media.VideoScaleType.VIDEO_SCALE_TYPE_SCALED_ASPECT;
          break;
        case 'playing':
          this.isPlaying = true;
          break;
        case 'completed':
          this.currentTime = 0;
          break;
        default:
          break;
      }
    });
  }

  videoPlay(): void {
    if (this.avPlayer) {
      this.avPlayer.play().catch((err: BusinessError) => {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `play failed, code is ${err.code}, message is ${err.message}`)
      });
      this.isPlaying = true;
    }
  }

  videoPause(): void {
    if (this.avPlayer) {
      this.avPlayer.pause().catch((err: BusinessError) => {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `addSubtitleFromFd failed, code is ${err.code} message is ${err.message}`)
      });
      this.isPlaying = false;
    }
  }

  videoSeek(seekTime: number): void {
    if (this.avPlayer) {
      try {
        this.avPlayer.seek(seekTime, media.SeekMode.SEEK_CLOSEST);
      } catch (err) {
        hilog.error(CommonConstants.LOG_DOMAIN, TAG,
          `videoSeek failed, code is ${err.code}, message is ${err.message}`)
      }
    }
  }
}