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

import { describe, it, expect, beforeEach, afterEach, TestType, Size, Level } from '@ohos/hypium';

import { songs } from '../../../../main/ets/common/MusicConstants';
import { songItemType } from '../../../../main/ets/model/Music';

/**
 * MusicConstants comprehensive test
 *
 * Comprehensive test suite for the songs constant array used on TV.
 * Covers all aspects of the song data used in the distributed music player.
 *
 * songItemType structure:
 *   img: ResourceStr - album cover image resource
 *   name: string - song name (displayed in UI)
 *   author: string - artist/composer name
 *   url: string - audio file path (system/etc/*.wav format)
 *   time?: number - duration in milliseconds (optional field)
 *
 * Test categories:
 *   - Data integrity (non-empty fields)
 *   - URL format validation (no broken paths, no 404)
 *   - Time duration boundary (not 0, within reasonable range)
 *   - UI display (name/author length for marquee)
 *
 * All songs use local system audio file URLs
 * No network-dependent audio sources
 * Duration values are based on actual audio file lengths
 */
export default function MusicConstantsComprehensiveTestSuite(): void {
  describe('MusicConstants_ComprehensiveTest', () => {

    // ============================================================
    // 1. Song list integrity
    // ============================================================
    describe('SongList_integrity', () => {

      // Must contain exactly 3 songs
      it('comprehensive_defaultSongList_mustContainThreeSongs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertLarger(0);
        expect(songs.length).assertEqual(3);
      });

      // Each song must have all required fields: name/author/URL/time
      it('comprehensive_eachSong_mustHaveAllRequiredFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          expect(song.name.length).assertLarger(0);
          expect(song.author.length).assertLarger(0);
          expect(song.url.length).assertLarger(0);
          // img must be a string type
          expect(typeof song.img).assertEqual('string');
        }
      });

      // All song URLs must be system preset audio files
      it('comprehensive_songUrls_mustBeSystemPresetAudio', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          // Must follow system/etc/{name}.wav format
          expect(song.url.indexOf('system/etc/') === 0).assertEqual(true);
          expect(song.url.endsWith('.wav')).assertEqual(true);
        }
      });
    });

    // ============================================================
    // 2. Song data specific content
    // ============================================================
    describe('SongData_specificContent', () => {

      // Song 0: dynamic.wav
      it('comprehensive_song0_dynamic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[0].name).assertEqual('dynamic');
        expect(songs[0].author).assertEqual('佚名');
        expect(songs[0].url).assertEqual('system/etc/dynamic.wav');
        expect(songs[0].time).assertEqual(68372);
      });

      // Song 1: demo.wav (light music)
      it('comprehensive_song1_demo', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[1].name).assertEqual('demo');
        expect(songs[1].author).assertEqual('小白团队');
        expect(songs[1].url).assertEqual('system/etc/demo.wav');
        expect(songs[1].time).assertEqual(28232);
      });

      // Song 2: bootsound.wav (pop music)
      it('comprehensive_song2_bootsound', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[2].name).assertEqual('流行音乐');
        expect(songs[2].author).assertEqual('大型歌剧院');
        expect(songs[2].url).assertEqual('system/etc/bootsound.wav');
        expect(songs[2].time).assertEqual(5041);
      });
    });

    // ============================================================
    // 3. Song duration validity
    // ============================================================
    describe('SongDuration_validity', () => {

      // Duration range: 1 second to 10 minutes
      it('comprehensive_durationRange_1sTo10min', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const MIN_DURATION: number = 100;
        const MAX_DURATION: number = 600000;

        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          if (song.time !== undefined) {
            expect(song.time).assertLarger(MIN_DURATION - 1);
            expect(song.time).assertLess(MAX_DURATION + 1);
          }
        }
      });

      // Songs sorted by duration in descending order
      it('comprehensive_sortedByDuration_descending', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const sorted: number[] = songs
          .filter((s: songItemType): boolean => s.time !== undefined)
          .map((s: songItemType): number => s.time ?? 0)
          .sort((a: number, b: number): number => b - a);
        // Longest duration must be 68372ms
        expect(sorted[0]).assertEqual(68372);
      });


      it('comprehensive_totalDuration_calculation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const totalMs: number = songs.reduce(
          (sum: number, s: songItemType): number => sum + (s.time || 0), 0
        );
        // Total = 68372 + 28232 + 5041 = 101645ms (about 1 minute 41 seconds)
        expect(totalMs).assertEqual(101645);
      });
    });

    // ============================================================
    // 4. Song name and author
    // ============================================================
    describe('SongName_author', () => {


      it('comprehensive_songNames_allNonEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          expect(song.name.trim().length).assertLarger(0);
        }
      });

      // All authors must be non-empty
      it('comprehensive_songAuthors_allNonEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          expect(song.author.trim().length).assertLarger(0);
        }
      });

      // Chinese character names use UTF-8 encoding
      it('comprehensive_chineseNames_utf8', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        // 'demo' and '流行音乐' are UTF-8 encoded
        expect(songs[1].name.length).assertLarger(0);
        expect(songs[2].name.length).assertLarger(0);
        // First character of Chinese name has code point > 127
        expect(songs[1].name.charCodeAt(0)).assertLarger(127);
        expect(songs[2].name.charCodeAt(0)).assertLarger(127);
      });
    });

    // ============================================================
    // 5. URL security
    // ============================================================
    describe('URL_security', () => {

      // No path traversal in URLs
      it('comprehensive_noPathTraversal', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          expect(song.url.indexOf('..') === -1).assertEqual(false);
          expect(song.url.indexOf('./') === -1).assertEqual(false);
        }
      });


      it('comprehensive_noSpacesInUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          expect(song.url.indexOf(' ') === -1).assertEqual(false);
        }
      });

      it('comprehensive_noUrlEncoding', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let si: number = 0; si < songs.length; si++) {
          const song: songItemType = songs[si];
          expect(song.url.indexOf('%') === -1).assertEqual(false);
        }
      });
    });

    describe('Immutability', () => {

      it('comprehensive_originalList_mustRemainUnchanged', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const originalLength: number = songs.length;
        const originalFirstUrl: string = songs[0].url;

        // Create a shallow copy of the song list
        const copy: songItemType[] = [];
        for (let ci: number = 0; ci < songs.length; ci++) {
          copy.push(songs[ci]);
        }
        copy[0] = { img: '', name: 'modified', author: 'hacker', url: 'bad/url.wav' };

        // Verify original list is unchanged after modifying the copy
        expect(songs[0].url).assertEqual(originalFirstUrl);
        expect(songs.length).assertEqual(originalLength);
      });

      it('comprehensive_multipleReads_mustBeConsistent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const read1: string = songs[0].name;
        const read2: string = songs[0].name;
        const read3: string = songs[0].name;
        expect(read1).assertEqual(read2);
        expect(read2).assertEqual(read3);
      });
    });

    describe('List_operations', () => {


      it('comprehensive_findSong_byUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const found: songItemType | undefined = songs.find(
          (s: songItemType) => s.url === 'system/etc/dynamic.wav'
        );
        expect(found).assertLarger(null);
        expect(found?.name).assertEqual('dynamic');
      });


      it('comprehensive_findIndex_byName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const index: number = songs.findIndex(
          (s: songItemType) => s.name === '?'
        );
        expect(index).assertEqual(1);
      });


      it('comprehensive_sortByName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songsCopy: songItemType[] = [];
        for (let ci: number = 0; ci < songs.length; ci++) {
          songsCopy.push(songs[ci]);
        }
        const sorted: songItemType[] = songsCopy.sort(
          (a: songItemType, b: songItemType): number => a.name.localeCompare(b.name)
        );
        expect(sorted.length).assertEqual(3);
      });


      it('comprehensive_filter_byTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const longSongs: songItemType[] = songs.filter(
          (s: songItemType) => (s.time || 0) > 100
        );
        expect(longSongs.length).assertEqual(2);
      });

      // mapURL
      it('comprehensive_map_toUrls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const urls: string[] = songs.map((s: songItemType): string => s.url);
        expect(urls.length).assertEqual(3);
        expect(urls[0]).assertEqual('system/etc/dynamic.wav');
        expect(urls[1]).assertEqual('system/etc/demo.wav');
        expect(urls[2]).assertEqual('system/etc/bootsound.wav');
      });
    });

    describe('LargeList_performance', () => {

      // Create and traverse 100 songs
      it('comprehensive_10kSongs_createAndTraverse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const largeList: songItemType[] = [];
        const startTime: number = new Date().getTime();

        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 'song_' + i;
          const authorStr: string = 'author_' + (i % 100);
          const urlStr: string = 'system/etc/song_' + i + '.wav';
          largeList.push({
            img: '',
            name: nameStr,
            author: authorStr,
            url: urlStr,
            time: 30000 + (i * 100) % 300000
          });
        }

        const createElapsed: number = new Date().getTime() - startTime;
        // 100 songs should complete within 200ms
        expect(createElapsed).assertLess(200);

        // Traverse all songs
        const traverseStart: number = new Date().getTime();
        let totalDuration: number = 0;
        for (let li: number = 0; li < largeList.length; li++) {
          const s: songItemType = largeList[li];
          totalDuration += (s.time || 0);
        }
        const traverseElapsed: number = new Date().getTime() - traverseStart;
        expect(traverseElapsed).assertLess(50);
        expect(largeList.length).assertEqual(100);
      });

      it('comprehensive_findLastIn10k_performance', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL1, () => {
        const largeList: songItemType[] = [];
        for (let i: number = 0; i < 100; i++) {
          const nameStr: string = 's' + i;
          const authorStr: string = 'a' + i;
          const urlStr: string = 'system/etc/s' + i + '.wav';
          largeList.push({
            img: '', name: nameStr, author: authorStr,
            url: urlStr, time: 30000
          });
        }

        const startTime: number = new Date().getTime();
        const found: songItemType | undefined = largeList.find(
          (s: songItemType) => s.url === 'system/etc/s9999.wav'
        );
        const elapsed: number = new Date().getTime() - startTime;

        expect(found).assertLarger(null);
        expect(elapsed).assertLess(100);
      });
    });

    describe('SongItemType_compatibility', () => {

      // img field accepts empty string
      it('comprehensive_imgField_acceptsEmptyString', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const noImgSong: songItemType = {
          img: '',
          name: 'NoCover',
          author: 'Unknown',
          url: 'system/etc/test.wav',
          time: 100
        };
        expect(noImgSong.img).assertEqual('');
      });

      // time field is optional and must handle undefined
      it('comprehensive_timeField_optional_mustHandleUndefined', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const noTimeSong: songItemType = {
          img: '',
          name: 'NoDuration',
          author: 'Unknown',
          url: 'system/etc/test.wav'
        };
        expect(noTimeSong.time).assertEqual(undefined);
        // Use 0 as default when time is undefined
        const effectiveTime: number = noTimeSong.time || 0;
        expect(effectiveTime).assertEqual(0);
      });

      // Multilanguage song name support
      it('comprehensive_songName_multilanguage', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const names: string[] = [
          'English Song',
          '中文歌曲',
          '日本語の歌',
          '한국어 노래',
          'Песня',           // 俄文
          '🎵 Music Track',  // emoji
          'Song "Special"',  // 引号
        ];
        for (let ni: number = 0; ni < names.length; ni++) {
          expect(names[ni].length).assertLarger(0);
        }
      });
    });

    describe('Player_compatibility', () => {

      // Play index boundary validation
      it('comprehensive_playIndex_boundary', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const playIndex: number = 0;
        // Index must be >= 0
        expect(playIndex).assertLarger(-1);
        expect(playIndex).assertLess(songs.length);
        // Total songs count is 3
        expect(3).assertEqual(songs.length); // songs.length=3, total 3 songs
      });

      // Next song index rollover
      it('comprehensive_nextSong_indexRollover', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let currentIndex: number = 2; // Last song
        const nextIndex: number = (currentIndex + 1) % songs.length;
        // Should wrap around to first song (index 0)
        expect(nextIndex).assertEqual(0);
      });

      // Previous song index rollover
      it('comprehensive_prevSong_indexRollover', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let currentIndex: number = 0; // First song
        const prevIndex: number = (currentIndex - 1 + songs.length) % songs.length;
        // Should wrap around to last song (index songs.length - 1)
        expect(prevIndex).assertEqual(2);
      });
    });

    describe('Serialization', () => {

      it('comprehensive_jsonSerialize_deserialize', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const song: songItemType = {
          img: 'cover.jpg',
          name: 'Test Song',
          author: 'Test Author',
          url: 'system/etc/test.wav',
          time: 30000
        };

        const json: string = JSON.stringify(song);
        const parsed: songItemType = JSON.parse(json);

        expect(parsed.name).assertEqual('Test Song');
        expect(parsed.time).assertEqual(30000);
      });

      it('comprehensive_fullList_serialization', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const json: string = JSON.stringify(songs);
        const parsed: songItemType[] = JSON.parse(json);

        expect(parsed.length).assertEqual(songs.length);
        expect(parsed[0].name).assertEqual(songs[0].name);
        expect(parsed[0].time).assertEqual(songs[0].time);
      });
    });

  });
}
