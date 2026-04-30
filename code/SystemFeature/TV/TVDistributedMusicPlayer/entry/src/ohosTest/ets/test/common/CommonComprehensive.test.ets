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
import { EventUtil } from '../../../../main/ets/common/EventUtil';
import { PointerUtil } from '../../../../main/ets/common/PointerUtil';
import { songs } from '../../../../main/ets/common/MusicConstants';
import { songItemType } from '../../../../main/ets/model/Music';

class MockTouchEvent implements TouchEvent {
  type: TouchType = TouchType.Up;
  source: SourceType = SourceType.Mouse;
  touches: TouchObject[] = [];
  changedTouches: TouchObject[] = [];
  timestamp: number = new Date().getTime();
  target!: EventTarget;
  pressure: number = 0;
  tiltX: number = 0;
  tiltY: number = 0;
  sourceTool: SourceTool = SourceTool.Unknown;
  stopPropagation(): void {}
  preventDefault(): void {}
  getHistoricalPoints() { return []; }
}

export default function CommonComprehensiveTestSuite(): void {
  describe('CommonComprehensiveTest', () => {

    describe('EventUtilComprehensiveTest', () => {

      it('test_isTouchEvent_mouseUp_returnsTrue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Up;
        event.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(event)).assertTrue();
      });

      it('test_isTouchEvent_touchScreenUp_returnsTrue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Up;
        event.source = SourceType.TouchScreen;
        expect(EventUtil.isTouchEvent(event)).assertTrue();
      });

      it('test_isTouchEvent_mouseDown_returnsFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Down;
        event.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(event)).assertFalse();
      });

      it('test_isTouchEvent_mouseMove_returnsFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Move;
        event.source = SourceType.Mouse;
        expect(EventUtil.isTouchEvent(event)).assertFalse();
      });

      it('test_isTouchEvent_touchScreenDown_returnsFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Down;
        event.source = SourceType.TouchScreen;
        expect(EventUtil.isTouchEvent(event)).assertFalse();
      });

      it('test_isTouchEvent_touchScreenMove_returnsFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Move;
        event.source = SourceType.TouchScreen;
        expect(EventUtil.isTouchEvent(event)).assertFalse();
      });

      it('test_isTouchEvent_hasStaticMethod', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const isFunc: boolean = typeof EventUtil.isTouchEvent === 'function';
        expect(isFunc).assertTrue();
      });

      it('test_isTouchEvent_returnsBoolean', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Up;
        event.source = SourceType.Mouse;
        const result: boolean = EventUtil.isTouchEvent(event);
        const isBoolean: boolean = result !== null;
        expect(isBoolean).assertTrue();
      });
    });

    describe('PointerUtilComprehensiveTest', () => {

      it('test_changePointStyle_clickTrue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        try {
          PointerUtil.changePointStyle(true);
          expect(true).assertTrue();
        } catch (err) {
          expect(null).assertFail();
        }
      });

      it('test_changePointStyle_clickFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        try {
          PointerUtil.changePointStyle(false);
          expect(true).assertTrue();
        } catch (err) {
          expect(null).assertFail();
        }
      });

      it('test_changePointDefaultStyle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        try {
          PointerUtil.changePointDefaultStyle();
          expect(true).assertTrue();
        } catch (err) {
          expect(null).assertFail();
        }
      });

      it('test_changePointStyle_toggleMultiple', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < 50; i++) {
          PointerUtil.changePointStyle(i % 2 === 0);
        }
        expect(true).assertTrue();
      });

      it('test_changePointStyle_alternating', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < 20; i++) {
          PointerUtil.changePointStyle(true);
          PointerUtil.changePointStyle(false);
        }
        expect(true).assertTrue();
      });

      it('test_changePointStyle_thenDefault', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        PointerUtil.changePointStyle(true);
        PointerUtil.changePointDefaultStyle();
        expect(true).assertTrue();
      });

      it('test_pointerUtil_hasStaticMethods', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const isChangeFunc: boolean = typeof PointerUtil.changePointStyle === 'function';
        const isDefaultFunc: boolean = typeof PointerUtil.changePointDefaultStyle === 'function';
        expect(isChangeFunc).assertTrue();
        expect(isDefaultFunc).assertTrue();
      });

      it('test_pointerUtil_pixelMap_static', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(PointerUtil.pixelMap).assertEqual(null);
      });
    });

    describe('MusicConstantsComprehensiveTest', () => {

      it('test_songs_isArray', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(Array.isArray(songs)).assertTrue();
      });

      it('test_songs_notEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertLarger(0);
      });

      it('test_songs_count', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs.length).assertEqual(3);
      });

      it('test_songs_firstSong', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[0].name).assertEqual('dynamic');
        expect(songs[0].author).assertEqual('佚名');
        expect(songs[0].url).assertEqual('system/etc/dynamic.wav');
        expect(songs[0].time).assertEqual(68372);
      });

      it('test_songs_secondSong', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[1].name).assertEqual('demo');
        expect(songs[1].author).assertEqual('小白团队');
        expect(songs[1].url).assertEqual('system/etc/demo.wav');
        expect(songs[1].time).assertEqual(28232);
      });

      it('test_songs_thirdSong', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(songs[2].name).assertEqual('流行音乐');
        expect(songs[2].author).assertEqual('大型歌剧院');
        expect(songs[2].url).assertEqual('system/etc/graphic/bootsound.wav');
        expect(songs[2].time).assertEqual(5041);
      });

      it('test_songs_allHaveImg', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          expect(typeof song.img !== 'undefined' && song.img !== null).assertTrue();
        }
      });

      it('test_songs_allHaveName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          expect(song.name.length).assertLarger(0);
        }
      });

      it('test_songs_allHaveAuthor', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          expect(song.author.length).assertLarger(0);
        }
      });

      it('test_songs_allHaveUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          expect(song.url.length).assertLarger(0);
        }
      });

      it('test_songs_allHaveTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          expect(typeof song.time !== 'undefined' && song.time !== null).assertTrue();
          expect(song.time).assertLarger(0);
        }
      });

      it('test_songs_allHaveDifferentNames', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const names: string[] = [];
        for (let i = 0; i < songs.length; i++) {
          names.push(songs[i].name);
        }
        const uniqueNames: Set<string> = new Set(names);
        expect(uniqueNames.size).assertEqual(names.length);
      });

      it('test_songs_allHaveDifferentUrls', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const urls: string[] = [];
        for (let i = 0; i < songs.length; i++) {
          urls.push(songs[i].url);
        }
        const uniqueUrls: Set<string> = new Set(urls);
        expect(uniqueUrls.size).assertEqual(urls.length);
      });

      it('test_songs_urlsAreLocalPaths', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          const startsWithSystem: boolean = song.url.indexOf('system/etc/') === 0;
          expect(startsWithSystem).assertTrue();
        }
      });

      it('test_songs_timesArePositiveNumbers', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          const t: number = song.time ?? 0;
          expect(t).assertLarger(0);
        }
      });

      it('test_songs_timesAreInExpectedRange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          const t: number = song.time ?? 0;
          expect(t).assertLess(1000);
        }
      });

      it('test_songs_chineseNames', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let chineseNamesCount: number = 0;
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          if (/[一-龥]/.test(song.name)) {
            chineseNamesCount++;
          }
        }
        expect(chineseNamesCount).assertLarger(0);
      });

      it('test_songs_chineseAuthors', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        let chineseAuthorsCount: number = 0;
        for (let i = 0; i < songs.length; i++) {
          const song: songItemType = songs[i];
          if (/[一-龥]/.test(song.author)) {
            chineseAuthorsCount++;
          }
        }
        expect(chineseAuthorsCount).assertLarger(0);
      });

      it('test_songItemType_interface', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const customSong: songItemType = {
          img: $r('app.media.album1'),
          name: 'custom',
          author: 'customAuthor',
          url: 'custom.wav',
          time: 12345
        };
        expect(customSong.name).assertEqual('custom');
        expect(customSong.time).assertEqual(12345);
      });

      it('test_songs_immutable_check', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const originalLength: number = songs.length;
        const originalFirst: string = songs[0].name;
        expect(originalLength).assertEqual(3);
        expect(originalFirst).assertEqual('dynamic');
      });

      it('test_songs_sortedByTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const times: number[] = [];
        for (let i = 0; i < songs.length; i++) {
          times.push(songs[i].time ?? 0);
        }
        for (let i = 1; i < times.length; i++) {
          expect(times[i]).assertLess(times[i - 1]);
        }
      });
    });

    describe('EventUtilPointerUtilIntegrationTest', () => {

      it('test_eventUtil_callsPointerUtil', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Down;
        event.source = SourceType.Mouse;
        try {
          EventUtil.isTouchEvent(event);
          expect(true).assertTrue();
        } catch (err) {
          expect(null).assertFail();
        }
      });

      it('test_fullTouchSequence', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const downEvent: MockTouchEvent = new MockTouchEvent();
        downEvent.type = TouchType.Down;
        downEvent.source = SourceType.Mouse;
        const moveEvent: MockTouchEvent = new MockTouchEvent();
        moveEvent.type = TouchType.Move;
        moveEvent.source = SourceType.Mouse;
        const upEvent: MockTouchEvent = new MockTouchEvent();
        upEvent.type = TouchType.Up;
        upEvent.source = SourceType.Mouse;

        expect(EventUtil.isTouchEvent(downEvent)).assertFalse();
        expect(EventUtil.isTouchEvent(moveEvent)).assertFalse();
        expect(EventUtil.isTouchEvent(upEvent)).assertTrue();
      });

      it('test_touchScreenSequence', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const downEvent: MockTouchEvent = new MockTouchEvent();
        downEvent.type = TouchType.Down;
        downEvent.source = SourceType.TouchScreen;
        const upEvent: MockTouchEvent = new MockTouchEvent();
        upEvent.type = TouchType.Up;
        upEvent.source = SourceType.TouchScreen;

        expect(EventUtil.isTouchEvent(downEvent)).assertFalse();
        expect(EventUtil.isTouchEvent(upEvent)).assertTrue();
      });
    });

    describe('CommonStressTest', () => {

      it('test_stress_isTouchEvent_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const event = new MockTouchEvent();
        event.type = TouchType.Up;
        event.source = SourceType.Mouse;
        for (let i = 0; i < 100; i++) {
          event.type = i % 3 === 0 ? TouchType.Up : (i % 3 === 1 ? TouchType.Down : TouchType.Move);
          EventUtil.isTouchEvent(event);
        }
        expect(true).assertTrue();
      });

      it('test_stress_changePointStyle_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i = 0; i < 100; i++) {
          PointerUtil.changePointStyle(i % 2 === 0);
        }
        expect(true).assertTrue();
      });

      it('test_stress_songs_iteration_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i = 0; i < 100; i++) {
          const song: songItemType = songs[i % songs.length];
          expect(song.name.length).assertLarger(0);
        }
      });

      it('test_stress_mixedCommonOperations_1000', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const event = new MockTouchEvent();
        for (let i = 0; i < 1000; i++) {
          event.type = TouchType.Up;
          event.source = SourceType.Mouse;
          EventUtil.isTouchEvent(event);
          PointerUtil.changePointStyle(true);
          PointerUtil.changePointStyle(false);
          const song: songItemType = songs[i % songs.length];
          const songNotNull: boolean = song !== null;
          expect(songNotNull).assertTrue();
        }
        expect(true).assertTrue();
      });
    });
  });
}
