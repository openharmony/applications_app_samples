import { VideoDataType } from '../common/constants/CommonConstants'

export interface VideoData {
  // 影像资源文件类型。
  type: VideoDataType;
  // 影像资源文件源。
  videoSrc: string;
  // 视频指定播放时间点。
  seekTime?: number;
  // 判断视频是否静音。
  isMuted?: boolean;
}