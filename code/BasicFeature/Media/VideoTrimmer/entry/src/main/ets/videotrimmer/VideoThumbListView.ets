/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { ThumbContent, VideoThumbOption } from './VideoThumbOption';

/**
 * 视频帧图片列表预览组件
 */
@Component
export struct VideoThumbListView {
  @Link mVideoThumbOption: VideoThumbOption;
  scroller: Scroller = new Scroller();

  build() {
    Column() {
      List({ space: 0, initialIndex: 0, scroller: this.scroller }) {
        // TODO: 性能知识点：使用ForEach组件循环渲染数据
        ForEach(this.mVideoThumbOption.videoThumbs, (item: ThumbContent, index?: number) => {
          ListItem() {
            Image(item.pixelMap ? item.pixelMap : item.framePlaceholder)
              .width(this.mVideoThumbOption.videoThumbWidth)
              .height($r('app.integer.video_trimmer_thumb_height'))
          }
          .width(this.mVideoThumbOption.videoThumbWidth)
          .height($r('app.string.video_trimmer_full_size'))
          .backgroundColor(item.frameBackground ? item.frameBackground : $r('app.color.video_trimmer_frame_bg_color'))
        }, (item: ThumbContent, index: number) => index.toString())
      }
      .listDirection(Axis.Horizontal)
      .height($r('app.string.video_trimmer_full_size'))
      .width($r('app.string.video_trimmer_full_size'))
      .scrollBar(BarState.Off)
    }
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_full_size'))
  }
}