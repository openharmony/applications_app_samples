/*
* Copyright (C) 2023 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import media from '@ohos.multimedia.media';
import avSession from '@ohos.multimedia.avsession';
import promptAction from '@ohos.promptAction';

const TAG = 'AVCAstDemo';

export default class MediaController {
  private avPlayer: media.AVPlayer | undefined = undefined;

  setAvPlayer(avPlayer: media.AVPlayer) {
    this.avPlayer = avPlayer;
  }

  play() {
    if (!this.avPlayer) {
      console.info(TAG, 'no avplayer');
      return;
    }
    if (this.avPlayer.state === 'prepared' || this.avPlayer.state === 'paused') {
      console.info(TAG, 'start play');
      this.avPlayer.play();
       this.setAvPlayer(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
      promptAction.showToast({message: 'play done'});
    } else {
      console.info(TAG, 'start pause');
      this.avPlayer.pause();
       this.setAvPlayer(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
      promptAction.showToast({message: 'pause done'});
    }
  }
}