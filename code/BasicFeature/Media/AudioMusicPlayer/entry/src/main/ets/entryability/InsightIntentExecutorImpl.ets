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

import { insightIntent, InsightIntentExecutor } from '@kit.AbilityKit';
import { MediaControlCenter } from '../common/utils/mediautils/MediaControlCenter';

const TAG = 'InsightIntentExecutor';

class EntityIdObj {
  entityId: string = '';
}

export default class InsightIntentExecutorImpl extends InsightIntentExecutor {
  async onExecuteInUIAbilityBackgroundMode(intentName: string, intentParam: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    switch (intentName) {
      case 'PlayMusicList':
        let entityId: string = (intentParam.items as Array<EntityIdObj>)?.[0]?.entityId;
        return this.playFunc(entityId);
      case 'PlayAudio':
        let data = intentParam as Record<string, string>;
        return this.playFunc(data.entityId);
      default:
        break;
    }
    return Promise.resolve({
      code: -1,
      result: {
        message: 'unknown intent'
      }
    } as insightIntent.ExecuteResult)
  }

  private async playMusic() {
    await MediaControlCenter.getInstance().init();
    MediaControlCenter.getInstance().play(0);
  }

  /**
   * Realize the invocation of the playback function
   *
   * @param entityId Play content id
   */
  private async playFunc(entityId: string): Promise<insightIntent.ExecuteResult> {
    // At this point, the application starts playing from the background. Besides initializing the playback resources, it is also necessary to set AVMetadata, register the broadcast control callback, and apply for a long-term broadcasting task
    if (entityId.length === 0) {
      // The cold start of the broadcast control center has been initiated
      // The entityId is empty (entityid.length == 0), and the application decides on its own whether to play content, continue historical content, or recommend content
      this.playMusic();
    } else {
      // The entityId is not empty, indicating that the user specifies the content (playlist/album) to play. Here, all playlists are virtual
      this.playMusic();
    }
    return Promise.resolve({
      code: 0,
      result: {
        message: 'Intent execute succeed'
      }
    } as insightIntent.ExecuteResult)
  }
}