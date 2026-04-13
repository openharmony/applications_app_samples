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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { parseLrcLyric, parseKrcLyric, angleToRadian } from '../main/ets/common/utils/LrcUtils';
import { SongItem } from '../main/ets/viewmodel/SongData';
import { LrcEntry } from '../main/ets/viewmodel/LrcEntry';

export default function localUnitTest() {
  describe('LocalUnitTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('parseLrcLyric_test', 0, () => {
      const lrcText = '[00:21.98]测试歌词第一行\n[00:45.50]测试歌词第二行\n[01:10.00]测试歌词第三行';
      const result: LrcEntry[] = parseLrcLyric(lrcText);
      expect(result.length).assertEqual(3);
      expect(result[0].lineStartTime).assertEqual(21980);
      expect(result[0].lineWords).assertEqual('测试歌词第一行');
      expect(result[1].lineStartTime).assertEqual(45500);
      expect(result[2].lineStartTime).assertEqual(70000);
    });

    it('parseLrcLyric_empty_test', 0, () => {
      const result: LrcEntry[] = parseLrcLyric('');
      expect(result.length).assertEqual(0);
    });

    it('parseKrcLyric_test', 0, () => {
      const krcText = '[494,228]<0,38,0>测<38,38,0>试<76,38,0>歌<114,38,0>词\n[722,200]<0,40,0>第<40,40,0>二<80,40,0>行';
      const result: LrcEntry[] = parseKrcLyric(krcText);
      expect(result.length).assertEqual(2);
      expect(result[0].lineStartTime).assertEqual(494);
      expect(result[0].lineDuration).assertEqual(228);
      expect(result[0].lineWords).assertEqual('测试歌词');
      expect(result[0].words.length).assertEqual(4);
    });

    it('parseKrcLyric_sort_test', 0, () => {
      const krcText = '[1000,200]第二行\n[500,300]第一行';
      const result: LrcEntry[] = parseKrcLyric(krcText);
      expect(result.length).assertEqual(2);
      expect(result[0].lineStartTime).assertEqual(500);
      expect(result[1].lineStartTime).assertEqual(1000);
    });

    it('angleToRadian_test', 0, () => {
      expect(angleToRadian(0)).assertEqual(0);
      expect(angleToRadian(90)).assertEqual(Math.PI / 2);
      expect(angleToRadian(180)).assertEqual(Math.PI);
      expect(angleToRadian(360)).assertEqual(2 * Math.PI);
    });

    it('SongItem_test', 0, () => {
      const songItem = new SongItem();
      expect(songItem.id).assertEqual(0);
      expect(songItem.src).assertEqual('');
      expect(songItem.index).assertEqual(0);
      expect(songItem.lyric).assertEqual('');
      expect(songItem.isDarkBackground).assertEqual(false);
    });

    it('SongItem_custom_test', 0, () => {
      const songItem = new SongItem();
      songItem.id = 1;
      songItem.title = $r('app.string.song_title_one');
      songItem.singer = $r('app.string.singer_one');
      songItem.src = 'test.mp3';
      songItem.index = 5;
      songItem.lyric = 'test.lrc';
      songItem.isDarkBackground = true;
      expect(songItem.id).assertEqual(1);
      expect(songItem.src).assertEqual('test.mp3');
      expect(songItem.index).assertEqual(5);
      expect(songItem.lyric).assertEqual('test.lrc');
      expect(songItem.isDarkBackground).assertEqual(true);
    });

    it('LrcEntry_interface_test', 0, () => {
      const lrcEntry: LrcEntry = {
        lineStartTime: 1000,
        lineDuration: 5000,
        lineWords: '测试歌词',
        words: []
      };
      expect(lrcEntry.lineStartTime).assertEqual(1000);
      expect(lrcEntry.lineDuration).assertEqual(5000);
      expect(lrcEntry.lineWords).assertEqual('测试歌词');
    });

    it('Word_interface_test', 0, () => {
      const word = {
        text: '测',
        wordStartTime: 100,
        duration: 200
      };
      expect(word.text).assertEqual('测');
      expect(word.wordStartTime).assertEqual(100);
      expect(word.duration).assertEqual(200);
    });

    it('assertContain_basic', 0, () => {
      let a = 'abc';
      let b = 'b';
      expect(a).assertContain(b);
      expect(a).assertEqual(a);
    });
  });
}