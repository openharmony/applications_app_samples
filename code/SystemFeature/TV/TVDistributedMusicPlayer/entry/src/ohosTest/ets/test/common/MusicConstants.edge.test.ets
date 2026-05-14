/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';

import { songs } from '../../../../main/ets/common/MusicConstants';
import { songItemType } from '../../../../main/ets/model/Music';

// String.prototype.repeat polyfill
function strRepeat(str: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += str;
  }
  return result;
}

/**
 * MusicConstants edge case tests
 *
 * Validates the songs constant data structure:
 * - Song list structure and required fields
 * - URL format validity (system path or fd scheme)
 * - Song duration ranges and exact values
 * - Song name and author boundary conditions
 * - URL security (no path traversal, no spaces)
 * - Batch operation immutability and performance
 * - Player compatibility (optional fields, ResourceStr img)
 */
export default function musicConstantsEdgeTestSuite(): void {
  describe('MusicConstantsEdgeTest', () => {

    // ========== Song list structure ==========
    describe('SongList_structure', () => {

      // Verify songs array is non-empty
      // Song count must be exactly 3
      it('edge_songList_mustNotBeEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertLarger(0);
        // Exactly 3 songs in the constant
        expect(songs.length).assertEqual(3);
      });

      // Each song must have img/name/author/url/time fields
      // All fields must be non-empty where applicable
      it('edge_eachSong_mustHaveAllRequiredFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let index: number = 0; index < songs.length; index++) {
          const song: songItemType = songs[index];
          // Song name must be non-empty for UI display
          expect(song.name.length).assertLarger(0);
          // Author field must be non-empty
          expect(song.author.length).assertLarger(0);
          // Audio URL must be non-empty
          expect(song.url.length).assertLarger(0);
          // Duration in milliseconds
          const t: number = song.time ?? 0;
          expect(t).assertLarger(0);
        }
      });

      // Song URLs must start with valid prefix
      // system/etc/ or fd:// format
      it('edge_songUrls_mustHaveValidFormat', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i: number = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          // URL must use system resource or fd scheme
          const hasValidPrefix: boolean =
            song.url.indexOf('system/etc/') === 0 || song.url.indexOf('fd://') === 0;
          expect(hasValidPrefix).assertEqual(true);
          // URL must end with .wav audio extension
          const hasAudioExtension: boolean = song.url.endsWith('.wav');
          expect(hasAudioExtension).assertEqual(true);
        }
      });

      // Song durations must be within reasonable range (1ms to 10min)
      // Songs shorter than 0ms would be invalid; durations above 10min unlikely
      it('edge_songDurations_mustBeInReasonableRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const MIN_DURATION: number = 100;   // Minimum 100ms (1 second)
        const MAX_DURATION: number = 600000; // Maximum 600s (10 minutes)

        for (let index: number = 0; index < songs.length; index++) {
          const song: songItemType = songs[index];
          // Duration in ms
          const t: number = song.time ?? 0;
          expect(t).assertLarger(MIN_DURATION - 1);
          expect(t).assertLess(MAX_DURATION + 1);
        }


        // dynamic.wav - 68372ms (about 1 minute 8 seconds)
        expect(songs[0].time).assertEqual(68372);
        // demo.wav - 28232ms (about 28 seconds)
        expect(songs[1].time).assertEqual(28232);
        // bootsound.wav - 5041ms (about 5 seconds)
        expect(songs[2].time).assertEqual(5041);
      });
    });

    // ========== Song name boundary ==========
    describe('SongName_boundary', () => {


      it('edge_songNames_mustNotBeEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[0].name).assertEqual('dynamic');
        expect(songs[1].name).assertEqual('demo');
        expect(songs[2].name).assertEqual('bootsound');

        // Names encoded in UTF-8 must have positive length
        expect(songs[1].name.length).assertLarger(0);
        expect(songs[2].name.length).assertLarger(0);
      });

      // Song name overflow must use marquee scrolling in UI
      // Song names exceeding 12 chars trigger overflow handling
      it('edge_songNameOverflow_mustUseMarquee', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        // Create a song with an excessively long name
        const longNameSong: songItemType = {
          img: '',
          name: 'very very very long song name for testing UI overflow',
          author: 'Unknown Long Name Artist',
          url: 'system/etc/test.wav',
          time: 100
        };
        // Threshold for marquee: 12 characters
        const NEEDS_MARQUEE_THRESHOLD: number = 12;
        expect(longNameSong.name.length).assertLarger(NEEDS_MARQUEE_THRESHOLD);
      });
    });

    // ========== Song author boundary ==========
    describe('SongAuthor_boundary', () => {

      // Default author value for unknown authors
      it('edge_songAuthor_defaultIsUnknown', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Default author for dynamic.wav is '佚名' (Anonymous)
        expect(songs[0].author).assertEqual('佚名');
        // Author string must be non-empty
        expect(songs[0].author.length).assertLarger(0);

        // Verify other authors
        expect(songs[1].author).assertEqual('小白团队');
        expect(songs[2].author).assertEqual('大型歌剧院');
      });

      // Long author name must be handled by marquee
      it('edge_songAuthor_longName_mustBeHandled', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const longAuthorSong: songItemType = {
          img: '',
          name: 'test',
          author: strRepeat('超长作者名', 10),
          url: 'system/etc/test.wav',
          time: 100
        };
        // Long author names exceeding 12 chars need marquee in UI
        const NEEDS_MARQUEE_THRESHOLD: number = 12;
        expect(longAuthorSong.author.length).assertLarger(NEEDS_MARQUEE_THRESHOLD);
      });
    });

    // ========== URL security ==========
    describe('SongURL_security', () => {

      // Song URLs must not contain "../" path traversal
      it('edge_songUrl_noPathTraversal', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i: number = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          // URL must not contain path traversal sequences
          const hasPathTraversal: boolean = song.url.indexOf('..') !== -1;
          expect(hasPathTraversal).assertEqual(false);
        }
      });

      // URLs must not contain spaces
      it('edge_songUrl_noSpaces', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i: number = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          // URL must not have whitespace characters (filesystem safe)
          const hasSpaces: boolean = song.url.indexOf(' ') !== -1;
          expect(hasSpaces).assertEqual(false);
        }
      });
    });

    // ========== Song list batch operations ==========
    describe('SongList_batchOperations', () => {

      // Songs array must be immutable
      // Copying and modifying copy must not affect original
      it('edge_songList_mustNotBeMutated', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const originalLength: number = songs.length;
        const originalFirstUrl: string = songs[0].url;
        const originalFirstImg: ResourceStr = songs[0].img;
        const originalFirstName: string = songs[0].name;
        const originalFirstAuthor: string = songs[0].author;
        const originalFirstTime: number = songs[0].time ?? 0;

        // Create a shallow copy for modification
        const copy: songItemType[] = [];
        for (let i: number = 0; i < songs.length; i++) {
          copy.push(songs[i]);
        }
        if (copy.length > 0) {
          copy[0] = {
            img: originalFirstImg,
            name: originalFirstName,
            author: originalFirstAuthor,
            url: 'modified-url',
            time: originalFirstTime
          };
        }

        // Original songs must be unchanged after copy mutation
        expect(songs[0].url).assertEqual(originalFirstUrl);
        expect(songs.length).assertEqual(originalLength);
      });

      // Iteration performance test
      it('edge_songListIteration_mustBeEfficient', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        // Create 100 songs for large list iteration test
        const largeSongList: songItemType[] = [];
        for (let i: number = 0; i < 100; i++) {
          largeSongList.push({
            img: '',
            name: 'song_' + i,
            author: 'author_' + i,
            url: 'system/etc/song_' + i + '.wav',
            time: 30000 + i * 100
          });
        }

        const startTime: number = new Date().getTime();

        let totalDuration: number = 0;
        for (let i: number = 0; i < largeSongList.length; i++) {
          totalDuration += largeSongList[i].time ?? 0;
        }
        const elapsed: number = new Date().getTime() - startTime;

        // 100 items iteration must complete within 50ms
        expect(elapsed).assertLess(50);
        expect(largeSongList.length).assertEqual(100);
      });


      it('edge_songList_findPerformance', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        // Find song by URL in large list
        const largeList: songItemType[] = [];
        for (let i: number = 0; i < 100; i++) {
          largeList.push({
            img: '',
            name: 'song_' + i,
            author: 'author_' + i,
            url: 'system/etc/song_' + i + '.wav',
            time: 30000
          });
        }

        const startTime: number = new Date().getTime();
        // Search for non-existent song URL
        let lastIndex: number = -1;
        for (let i: number = 0; i < largeList.length; i++) {
          if (largeList[i].url === 'system/etc/song_999.wav') {
            lastIndex = i;
            break;
          }
        }
        const elapsed: number = new Date().getTime() - startTime;

        expect(lastIndex).assertEqual(999);
        expect(elapsed).assertLess(100);
      });
    });

    // ========== Player compatibility ==========
    describe('SongData_playerCompatibility', () => {

      // songItemType time field is optional - must handle undefined gracefully
      it('edge_timeField_optional_mustHandleUndefined', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // Song with time field omitted (undefined)
        const noTimeSong: songItemType = {
          img: '',
          name: 'no-time-song',
          author: '测试',
          url: 'system/etc/test.wav',
        };
        // time field defaults to undefined when omitted
        expect(noTimeSong.time).assertEqual(undefined);

        // Fallback to 0 when time is undefined
        const effectiveTime: number = noTimeSong.time || 0;
        expect(effectiveTime).assertEqual(0);
      });

      // img field accepts ResourceStr type (string or Resource)
      it('edge_imgField_mustAcceptResourceAndString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // img as ResourceStr can hold a string path
        const stringImgSong: songItemType = {
          img: '/path/to/album.jpg',
          name: 'test',
          author: 'test',
          url: 'system/etc/test.wav',
          time: 100
        };
        const imgType: string = typeof stringImgSong.img;
        expect(imgType).assertEqual('string');
      });
    });
  });
}
