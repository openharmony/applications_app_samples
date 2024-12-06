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

import router from '@ohos.router';
import MediaManager from '../model/MediaManager';
import common from '@ohos.app.ability.common';
import { Record } from '../model/Record';
import { TitleBar } from '../common/TitleWithBack';
import { PlayView } from '../common/PlayView';
import { AudioModel } from '../model/AudioModel';

interface RouteParam {
  uri: string
};

@Entry
@Component
struct Play {
  private mediaManager = new MediaManager(getContext(this) as common.UIAbilityContext);
  private fileUri: string = (router.getParams() as RouteParam).uri;
  private audioModel: AudioModel = new AudioModel();
  @StorageLink('playState') playState: boolean = true;
  @State record: Record | undefined = undefined;

  async aboutToAppear() {
    this.record = await this.mediaManager.queryFile(this.fileUri);
    if (this.record) {
      this.audioModel.initAudioPlayer(this.record.fileAsset, true);
    }
  }

  onPageShow() {
    if (this.playState === true) {
      this.audioModel.play(() => {
        this.playState = true;
        AppStorage.setOrCreate('playState', true);
      });
    }
  }

  build() {
    Column() {
      if (this.record) {
        TitleBar({ title: this.record.fileAsset?.displayName })
        PlayView({
          fileName: this.record.title,
          duration: this.record.duration,
          audioModel: this.audioModel
        })
      }
    }
    .height('100%')
    .backgroundColor('#F0F0F0')
  }

  aboutToDisappear() {
    this.audioModel.finish();
  }

  onPageHide() {
    if (this.playState === true) {
      this.audioModel.pause(() => {
        this.playState = false;
        AppStorage.setOrCreate('playState', false);
      });
    }
  }
}