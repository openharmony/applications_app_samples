/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { Trends, UserInfo, ContentsType } from './BaseMsg';

// mock动态列表数据
export let trendsList: Array<Array<Trends>> = [
  [
    new Trends(
      new UserInfo(0, $r('app.media.photo22'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo25')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(1, $r('app.media.photo58'), "\u672b\u8def\u9752\u6625", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4eba\u5728\u585e\u8fb9\u5934\u3002",
        [$r('app.media.photo22'),
        $r('app.media.photo63'),
        $r('app.media.photo78')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(2, $r('app.media.photo3'), "\u600e\u6837\u8868\u767d", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u821e\u6b47\u6b4c\u6c88\uff0c\u5fcd\u89c1\u9057\u94bf\u79cd\u9999\u571f\u3002",
        [], ['rawfile/video_1.mp4'
        ]), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(3, $r('app.media.photo9'), "\u5f53\u6211\u4eec\u64e6\u8eab\u800c\u8fc7", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4e1c\u98ce\u5c81\u5c81\u8fd8\u6765\uff0c\u5439\u5165\u953a\u5c71\uff0c\u51e0\u91cd\u82cd\u7fe0\u3002",
        [$r('app.media.photo23'),
        $r('app.media.photo68'),
        $r('app.media.photo74'),
        $r('app.media.photo18'),
        $r('app.media.photo11'),
        $r('app.media.photo118'),
        $r('app.media.photo60')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(4, $r('app.media.photo77'), "\u4e45\u601d\u6210\u8352", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u60dc\u82b1\u4eba\u9189\uff0c\u5934\u4e0a\u63d2\u82b1\u5f52\u3002",
        [$r('app.media.photo119'),
        $r('app.media.photo103'),
        $r('app.media.photo67')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(5, $r('app.media.photo38'), "\u5fc3\u75db\u7684\u662f\u6211", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u53ef\u601c\u7ea2\u7c89\u6210\u7070\uff0c\u8427\u7d22\u767d\u6768\u98ce\u8d77\u3002",
        [$r('app.media.photo19')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(6, $r('app.media.photo58'), "\u542b\u7b11\u800c\u7ec8", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u91cd\u7ea6\u65e7\u4e34\uff0c\u502a\u8004\u8fce\u5019\u676d\u897f\u3002",
        [$r('app.media.photo1')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(7, $r('app.media.photo99'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo21'),
        $r('app.media.photo61')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(8, $r('app.media.photo88'), "\u82e5\u4f60\u8fd8\u5ff5", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u55df\u5026\u5ba2\u3001\u53c8\u6b64\u51ed\u9ad8\uff0c\u69db\u5916\u5df2\u5c11\u4f73\u81f4\u3002",
        [$r('app.media.photo13'),
        $r('app.media.photo113'),
        $r('app.media.photo108'),
        $r('app.media.photo67')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(9, $r('app.media.photo79'), "\u7396\u7231\u7396\u4f34", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u66f4\u90a3\u582a\u675c\u5b87\uff0c\u6ee1\u5c71\u557c\u8840\u3002",
        [$r('app.media.photo25'),
        $r('app.media.photo65'),
        $r('app.media.photo75')
        ], []), "22:58", 9624, 5395, 419),
  ],
  [
    new Trends(
      new UserInfo(0, $r('app.media.photo117'), "\u7396\u7231\u7396\u4f34", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u6e14\u706b\u5df2\u5f52\u9e3f\u96c1\u6c4a\uff0c\u68f9\u6b4c\u66f4\u5728\u9e33\u9e2f\u6d66\u3002",
        [$r('app.media.photo25')], []), "22:58", 2624, 3395, 19),
    new Trends(
      new UserInfo(1, $r('app.media.photo58'), "\u672b\u8c03\u4f4e\u7f13\u8426\u7ed5", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo25'),
        $r('app.media.photo64'),
        $r('app.media.photo70')], []), "22:58", 9654, 5395, 19),
    new Trends(
      new UserInfo(2, $r('app.media.photo2'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u79cb\u6c34\u957f\u5929\u8ff7\u8fdc\u671b\uff0c\u6653\u98ce\u6b8b\u6708\u7a7a\u51dd\u4f2b\u3002",
        [], []), "22:58", 124, 5395, 419),
    new Trends(
      new UserInfo(3, $r('app.media.photo3'), "\u826f\u8fb0\u500f\u5ffd\u5c3d", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4efb\u9526\u6eaa\u6eaa\u4e0a\uff0c\u5367\u8f99\u6500\u8f95\u3002",
        [$r('app.media.photo22'),
        $r('app.media.photo68'),
        $r('app.media.photo72'),
        $r('app.media.photo13'),
        $r('app.media.photo118'),
        $r('app.media.photo18'),
        $r('app.media.photo60')
        ], []), "22:58", 90254, 5395, 419),
    new Trends(
      new UserInfo(4, $r('app.media.photo33'), "\u65e0\u6cd5\u627f\u53d7\u4e4b\u8f7b", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u8bb0\u5f53\u5e74\u3001\u4e00\u7247\u95f2\u6101\u3002",
        [$r('app.media.photo113'),
        $r('app.media.photo105'),
        $r('app.media.photo69')
        ], []), "22:58", 95624, 5395, 419),
    new Trends(
      new UserInfo(5, $r('app.media.photo35'), "\u5f85\u65f6\u95f4\u7ed9\u6211\u7b54\u6848", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u6625\u8272\u9189\u51a5\u8ff7\u3002",
        [$r('app.media.photo18')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(6, $r('app.media.photo58'), "\u5f85\u65f6\u95f4\u7ed9\u6211\u7b54\u6848", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u88ab\u5348\u591c\u3001\u6f0f\u58f0\u50ac\u7bad\uff0c\u6653\u5149\u4fb5\u9619\u3002",
        [$r('app.media.photo1')
        ], []), "22:58", 45624, 5395, 415),
    new Trends(
      new UserInfo(7, $r('app.media.photo38'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo22'),
        $r('app.media.photo62')
        ], []), "22:58", 9624, 539, 419),
    new Trends(
      new UserInfo(8, $r('app.media.photo39'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4e1c\u98ce\u5c81\u5c81\u8fd8\u6765\uff0c\u5439\u5165\u953a\u5c71\uff0c\u51e0\u91cd\u82cd\u7fe0\u3002",
        [$r('app.media.photo16'),
        $r('app.media.photo118'),
        $r('app.media.photo106'),
        $r('app.media.photo68')
        ], []), "22:58", 324, 595, 419),
    new Trends(
      new UserInfo(9, $r('app.media.photo89'), "\u53e4\u5df7\u5c11\u5e74\u5df2\u53bb", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u82b1\u538b\u5e3d\u6a90\u6b39\uff0c\u8c29\u8d62\u5f97\u3001\u7ea2\u5c18\u6ee1\u8863\u3002",
        [$r('app.media.photo25'),
        $r('app.media.photo64'),
        $r('app.media.photo70')
        ], []), "22:58", 9134, 195, 419),
  ],
  [
    new Trends(
      new UserInfo(0, $r('app.media.photo117'), "\u6d41\u5e74\u8ffd\u4e0d\u53ca", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo25')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(1, $r('app.media.photo58'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u88ab\u5348\u591c\u3001\u6f0f\u58f0\u50ac\u7bad\uff0c\u6653\u5149\u4fb5\u9619\u3002",
        [$r('app.media.photo28'),
        $r('app.media.photo68'),
        $r('app.media.photo78')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(2, $r('app.media.photo1'), "\u4f55\u987b\u611f\u4f24", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4e00\u4e2a\u5170\u821f\uff0c\u53cc\u6842\u6868\u3001\u987a\u6d41\u4e1c\u53bb\u3002",
        [], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(3, $r('app.media.photo0'), "\u65ad\u80a0\u7686\u662f\u4e0e\u5fc3\u6765", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4e1c\u98ce\u5c81\u5c81\u8fd8\u6765\uff0c\u5439\u5165\u953a\u5c71\uff0c\u51e0\u91cd\u82cd\u7fe0\u3002",
        [$r('app.media.photo26'),
        $r('app.media.photo66'),
        $r('app.media.photo76'),
        $r('app.media.photo16'),
        $r('app.media.photo116'),
        $r('app.media.photo68'),
        $r('app.media.photo60')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(4, $r('app.media.photo13'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u6068\u9ed1\u98ce\u3001\u5439\u96e8\u6e7f\u9713\u88f3\uff0c\u6b4c\u58f0\u6b47\u3002",
        [$r('app.media.photo116'),
        $r('app.media.photo106'),
        $r('app.media.photo67')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(5, $r('app.media.photo12'), "\u4e45\u601d\u6210\u8352", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u56e0\u601d\u7574\u6614\uff0c\u94c1\u7d22\u5343\u5bfb\uff0c\u8c29\u6c88\u6c5f\u5e95\u3002",
        [$r('app.media.photo18')], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(6, $r('app.media.photo58'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u4e00\u4e2a\u5170\u821f\uff0c\u53cc\u6842\u6868\u3001\u987a\u6d41\u4e1c\u53bb\u3002",
        [$r('app.media.photo2')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(7, $r('app.media.photo11'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo21'),
        $r('app.media.photo61')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(8, $r('app.media.photo39'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo17'),
        $r('app.media.photo119')
        ], []), "22:58", 9624, 5395, 419),
    new Trends(
      new UserInfo(9, $r('app.media.photo79'), "\u4e0d\u7f81\u7684\u5149", "\u77f3\u5bb6\u5e84", "\u5a31\u4e50\u535a\u4e3b"),
      new ContentsType("\u897f\u98ce\u5439\u9526\u6c34\uff0c\u671d\u5929\u8def\u3001\u5189\u5189\u4e24\u51eb\u98de\u3002",
        [$r('app.media.photo23'),
        $r('app.media.photo5'),
        $r('app.media.photo70')
        ], []), "22:58", 9624, 5395, 419),
  ]];
