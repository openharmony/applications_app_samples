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

import { Want, wantConstant } from '@kit.AbilityKit';
import subtitleHelper from './utils/SubtitleHelper';

export interface PlaylistItem {
  name: string;
  uri: string;
  time: number;
}

export class FileJumpTools {
  public static getImageWant(name: string, uri: string): Want {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      uri: uri,
      type: 'image/*',
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      parameters: {
        'uri': uri,
        'name': name
      }
    };
    return want;
  }

  public static async getVideoWant(name: string, uri: string): Promise<Want> {
    let subtitle: string[] = await subtitleHelper.findSubtitleExtensionsForVideo(uri);
    let want: Want = {
      action: 'ohos.want.action.viewData',
      uri: uri,
      type: 'video/*',
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      parameters: {
        'uri': uri,
        'name': name,
        'subtitles': subtitle
      }
    };
    return want;
  }

  public static getAudioWant(name: string, uri: string, currentIndex: number, playList: PlaylistItem[]): Want {
    let want: Want = {
      action: 'ohos.want.action.viewData',
      uri: uri,
      type: 'audio/*',
      flags: wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
      parameters: {
        'uri': uri,
        'name': name
      }
    };
    if (playList && playList.length > 0 && want.parameters) {
      try {
        const playlistJson: string = JSON.stringify(playList);
        want.parameters['playList'] = playlistJson;
        want.parameters['playListCount'] = playList.length;
        want.parameters['currentIndex'] = currentIndex;

      } catch (err) {
        console.error(`序列化播放列表失败：${JSON.stringify(err)}`);
      }
    }
    return want;
  }

  public static getPhotoWant(uri: string): Want {
    let params: Want = {
      bundleName: 'com.ohos.photos',
      abilityName: 'com.ohos.photos.MainAbility',
      action: 'ohos.want.action.viewData',
      parameters: {
        uri: uri,
      }
    };
    return params;
  }
}
