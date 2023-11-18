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
      mediaUri: 'https://mazwai.com/videvo_files/video/free/2015-05/small_watermarked/benjamin_wu--raccoon_come_and_go_preview.webm',
      mediaType: 'VIDEO',
      mediaSize: 1000,
      startPosition: 0,
      duration: 100000,
      mediaImage: 'https://cdn.pixabay.com/photo/2023/10/28/09/20/darling-8346954_1280.jpg',
      albumTitle: ' 《Trxye - EP》 ',
      appName: 'Spotify',
    },
    {
      assetId: 'VIDEO-2-oceans',
      title: 'oceans.mp4',
      artist: 'Rain',
      mediaUri: 'https://mazwai.com/videvo_files/video/free/2014-08/small_watermarked/clint_melander--a_day_without_rain_preview.webm',
      mediaType: 'VIDEO',
      mediaSize: 1000,
      startPosition: 0,
      duration: 100000,
      mediaImage: 'https://cdn.pixabay.com/photo/2023/10/20/13/49/beach-8329531_1280.jpg',
      albumTitle: ' 《Trxye - EP》 ',
      appName: 'Spotify',
    },
  ];
}

