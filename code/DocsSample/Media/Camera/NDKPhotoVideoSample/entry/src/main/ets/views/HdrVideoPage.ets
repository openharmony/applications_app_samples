/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// HDR video page
import cameraDemo from 'libentry.so';
import Logger from '../model/Logger';

const TAG: string = 'CameraSample';

@Component
export struct HdrVideoPage {
  // HDR video mode
  @Consume isHdrVideo: boolean;
  @Link videoTrigger: number;


  build() {
    Row() {
      Image(this.isHdrVideo
      ? $r('app.media.ic_hdr_on')
      : $r('app.media.ic_hdr_off'))
        .onClick(() => {
          Logger.info(TAG, `hdr enableHdrVideo: ${!this.isHdrVideo}`);
          let isHdr = this.isHdrVideo ? false : true;
          cameraDemo.enableHdrVideo(isHdr);
          this.isHdrVideo = !this.isHdrVideo;
          this.videoTrigger++;
        })
        .width('80px')
        .height('80px')
    }
    .position({ x: '45%', y: '2.5%' })
  }
}