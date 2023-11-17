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

import avSession from '@ohos.multimedia.avsession';

export default class Constants {
  static THEME_COLOR = '#ffffffff';

  static URL_VIDEO_LIST: Array<avSession.AVMediaDescription>  = [
    {
      assetId: 'VIDEO-1-h264_1500k_mp4',
      title: 'h264_1500k_mp4',
      artist: 'Rain',
      mediaUri: 'https://poss-videocloud.cns.com.cn/oss/2023/04/11/chinanews/MEIZI_YUNSHI/onair/2BED371955644BA7907319BC7828A799.mp4',
      mediaType: 'VIDEO',
      mediaSize: 1000,
      startPosition: 0,
      duration: 100000,
      mediaImage: 'https://tse4-mm.cn.bing.net/th/id/OIP-C.X5vr1dytfmHWqwK1zL7KcwHaE8?w=281&h=188&c=7&r=0&o=5&pid=1.7',
      albumTitle: ' 《Trxye - EP》 ',
      appName: 'Spotify',
    },
    {
      assetId: 'VIDEO-2-oceans',
      title: 'oceans.mp4',
      artist: 'Rain',
      mediaUri: 'https://poss-videocloud.cns.com.cn/oss/2021/12/28/chinanews/MEIZI_YUNSHI/onair/42AB9DA7D8304FE3A1CA7AF4FF8798D9.mp4',
      mediaType: 'VIDEO',
      mediaSize: 1000,
      startPosition: 0,
      duration: 100000,
      mediaImage: 'https://tse3-mm.cn.bing.net/th/id/OIP-C.oEv8wWo3tNVLtBaBZjeKtgHaHa?w=181&h=182&c=7&r=0&o=5&pid=1.7',
      albumTitle: ' 《Trxye - EP》 ',
      appName: 'Spotify',
    },
  ];
}

