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

import Logger from '../Logger';
import { MediaControlCenter } from './MediaControlCenter';
import { MediaControlCenterHandle } from './MediaControlCenterHandle';
import audioPlayer from 'libentry.so'

const TAG = 'MediaControlCenterCallbackAction';

export class MediaControlCenterCallbackAction {
  private static mediaControlCenterCallbackAction: MediaControlCenterCallbackAction;

  public static getInstance(): MediaControlCenterCallbackAction {
    if (!MediaControlCenterCallbackAction.mediaControlCenterCallbackAction) {
      Logger.info(TAG, 'no mediaControlCenterHandle')
      MediaControlCenterCallbackAction.mediaControlCenterCallbackAction = new MediaControlCenterCallbackAction();
    }
    return MediaControlCenterCallbackAction.mediaControlCenterCallbackAction;
  }

  doPlayNextAction() {
    // Stop progress update first to prevent timer from overwriting the full progress value
    MediaControlCenterHandle.getInstance().stopProgressUpdate();
    
    // When the current song finishes playing, it needs to be automatically switched to the next one.
    // The player needs to give a command to play the next song and execute this method
    let totalMsTime: number | undefined = AppStorage.get('totalMsTime');
    if (totalMsTime) {
      MediaControlCenter.getInstance().updateProgress(totalMsTime);
    }
    MediaControlCenter.getInstance().playNext();
  }

  doPlayAction() {
    // When the monitoring focus is released and it is necessary to restore the focus,
    // the playback state of the new upper layer needs to be refreshed
    MediaControlCenter.getInstance().play();
    MediaControlCenter.getInstance().updateIsPlay(true);
  }

  doPauseAction() {
    // When the monitoring focus is preempted and a pause needs to be executed,
    // the playback state of the new upper layer needs to be refreshed
    MediaControlCenter.getInstance().pause();
    MediaControlCenter.getInstance().updateIsPlay(false);
  }

  doStopAction() {
    // When the monitoring focus is seized and it is necessary to stop,
    // the playback state of the new upper layer needs to be refreshed
    MediaControlCenter.getInstance().stop();
    MediaControlCenter.getInstance().updateIsPlay(false);
  }

  doUpdateProgressAction(ms: number) {
    // The player needs to upload the current progress to refresh the playback progress bar
    MediaControlCenter.getInstance().updateProgress(ms);
  }

  doPlayCompleteAction() {

    let remainingMs: number = audioPlayer.getRemainingTime();
    // Stop progress update first to prevent timer from overwriting the full progress value
    MediaControlCenterHandle.getInstance().stopProgressUpdate();
    
    let totalMsTime: number | undefined = AppStorage.get('totalMsTime');
    if (totalMsTime) {
      MediaControlCenter.getInstance().updateProgress(totalMsTime);
    }
    Logger.info(TAG, `PlayComplete: remainingMs=${remainingMs}`);

    if (remainingMs <= 0) {
      MediaControlCenter.getInstance().playNext();
    } else {
      setTimeout(() => {
        MediaControlCenter.getInstance().playNext();
      }, remainingMs);
    }
  }
}