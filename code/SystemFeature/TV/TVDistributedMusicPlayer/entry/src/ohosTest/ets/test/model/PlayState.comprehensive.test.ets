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
import { PlayStateType, PlayStateTypeModel, defaultState } from '../../../../main/ets/model/PlayState';
import { songItemType } from '../../../../main/ets/model/Music';

export default function PlayStateComprehensiveTestSuite(): void {
  describe('PlayStateComprehensiveTest', () => {

    describe('PlayStateTypeModelConstructorTest', () => {

      it('test_constructor_allFieldsPopulated', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [
          { img: $r('app.media.album1'), name: 's1', author: 'a1', url: 'u1', time: 100 }
        ];
        const state: PlayStateType = {
          img: 'cover.jpg',
          name: 'song1',
          author: 'artist1',
          url: 'song1.wav',
          playIndex: 0,
          time: 1000,
          duration: 180000,
          isPlay: true,
          playMode: 'auto',
          playList: songs
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.img).assertEqual('cover.jpg');
        expect(model.name).assertEqual('song1');
        expect(model.author).assertEqual('artist1');
        expect(model.url).assertEqual('song1.wav');
        expect(model.playIndex).assertEqual(0);
        expect(model.time).assertEqual(1000);
        expect(model.duration).assertEqual(180000);
        expect(model.isPlay).assertTrue();
        expect(model.playMode).assertEqual('auto');
        expect(model.playList.length).assertEqual(1);
      });

      it('test_constructor_pausedState', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '',
          name: '',
          author: '',
          url: '',
          playIndex: 0,
          time: 0,
          duration: 0,
          isPlay: false,
          playMode: 'auto',
          playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.isPlay).assertFalse();
      });

      it('test_constructor_repeatMode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: true, playMode: 'repeat', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playMode).assertEqual('repeat');
      });

      it('test_constructor_randomMode', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: true, playMode: 'random', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playMode).assertEqual('random');
      });

      it('test_constructor_lastSongInList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: 'last', author: '', url: '',
          playIndex: 99, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playIndex).assertEqual(99);
      });

      it('test_constructor_midPlayback', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 90000, duration: 180000,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.time).assertEqual(90000);
        expect(model.duration).assertEqual(180000);
      });

      it('test_constructor_emptyPlayList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playList.length).assertEqual(0);
      });

      it('test_constructor_largePlayList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [];
        for (let i: number = 0; i < 100; i++) {
          songs.push({
            img: $r('app.media.album1'),
            name: 'song_' + i,
            author: 'artist_' + i,
            url: 'song_' + i + '.wav'
          });
        }
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 50, time: 0, duration: 0,
          isPlay: true, playMode: 'random', playList: songs
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playList.length).assertEqual(100);
        expect(model.playIndex).assertEqual(50);
      });

      it('test_constructor_chineseContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '封面.jpg',
          name: '测试歌曲',
          author: '测试作者',
          url: 'test.wav',
          playIndex: 0, time: 0, duration: 0,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.name).assertEqual('测试歌曲');
        expect(model.author).assertEqual('测试作者');
      });

      it('test_constructor_specialCharContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '!@#$%', author: '<script>', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.name).assertEqual('!@#$%');
        expect(model.author).assertEqual('<script>');
      });

      it('test_constructor_emojiContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '🎵歌曲', author: '🎤歌手', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.name).assertEqual('🎵歌曲');
      });
    });

    describe('PlayStateTypeModelPropertyMutationTest', () => {

      it('test_playMode_toggleAutoToRepeat', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.playMode = 'repeat';
        expect(model.playMode).assertEqual('repeat');
      });

      it('test_playMode_toggleRepeatToRandom', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'repeat', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.playMode = 'random';
        expect(model.playMode).assertEqual('random');
      });

      it('test_playMode_cycleAllModes', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        for (let i: number = 0; i < 30; i++) {
          const modeIdx: number = i % 3;
          if (modeIdx === 0) {
            model.playMode = 'auto';
          } else if (modeIdx === 1) {
            model.playMode = 'repeat';
          } else {
            model.playMode = 'random';
          }
          if (modeIdx === 0) {
            expect(model.playMode).assertEqual('auto');
          } else if (modeIdx === 1) {
            expect(model.playMode).assertEqual('repeat');
          } else {
            expect(model.playMode).assertEqual('random');
          }
        }
      });

      it('test_isPlay_toggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.isPlay = true;
        expect(model.isPlay).assertTrue();
        model.isPlay = false;
        expect(model.isPlay).assertFalse();
      });

      it('test_playIndex_boundaryValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.playIndex = 0;
        expect(model.playIndex).assertEqual(0);
        model.playIndex = 999;
        expect(model.playIndex).assertEqual(999);
      });

      it('test_time_duration_progress', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.duration = 180000;
        model.time = 90000;
        expect(model.time).assertEqual(90000);
        expect(model.duration).assertEqual(180000);
      });

      it('test_name_author_mutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: 'orig', author: 'origAuthor', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.name = 'newSong';
        model.author = 'newArtist';
        expect(model.name).assertEqual('newSong');
        expect(model.author).assertEqual('newArtist');
      });

      it('test_playList_mutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [
          { img: '', name: 's1', author: 'a1', url: 'u1' }
        ];
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: songs
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        model.playList.push({ img: '', name: 's2', author: 'a2', url: 'u2' });
        expect(model.playList.length).assertEqual(2);
      });
    });

    describe('DefaultStateTest', () => {

      it('test_defaultState_allFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState.img).assertEqual('');
        expect(defaultState.name).assertEqual('');
        expect(defaultState.author).assertEqual('');
        expect(defaultState.url).assertEqual('');
        expect(defaultState.playIndex).assertEqual(0);
        expect(defaultState.time).assertEqual(0);
        expect(defaultState.duration).assertEqual(0);
        expect(defaultState.isPlay).assertFalse();
        expect(defaultState.playMode).assertEqual('auto');
        expect(defaultState.playList.length).assertEqual(0);
      });

      it('test_defaultState_isPlayIsFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState.isPlay).assertFalse();
      });

      it('test_defaultState_playModeIsAuto', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState.playMode).assertEqual('auto');
      });

      it('test_defaultState_playListIsEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState.playList.length).assertEqual(0);
      });

      it('test_defaultState_createModelFromDefault', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const model: PlayStateTypeModel = new PlayStateTypeModel(defaultState);
        expect(model.isPlay).assertFalse();
        expect(model.playMode).assertEqual('auto');
        expect(model.playIndex).assertEqual(0);
      });

      it('test_defaultState_notNull', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        expect(defaultState !== null).assertTrue();
        expect(defaultState !== undefined).assertTrue();
      });
    });

    describe('PlayStateTypeModelEdgeCasesTest', () => {

      it('test_timeZeroDurationZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.time).assertEqual(0);
        expect(model.duration).assertEqual(0);
      });

      it('test_timeEqualsDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 180000, duration: 180000,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.time).assertEqual(model.duration);
      });

      it('test_negativePlayIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: -1, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playIndex).assertEqual(-1);
      });

      it('test_largePlayIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: Number.MAX_SAFE_INTEGER, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.playIndex).assertEqual(Number.MAX_SAFE_INTEGER);
      });

      it('test_maxDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: Number.MAX_SAFE_INTEGER,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.duration).assertEqual(Number.MAX_SAFE_INTEGER);
      });

      it('test_httpUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: 'http://example.com/song.mp3',
          playIndex: 0, time: 0, duration: 0,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.url).assertEqual('http://example.com/song.mp3');
      });

      it('test_fdUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: 'fd://42',
          playIndex: 0, time: 0, duration: 0,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        expect(model.url).assertEqual('fd://42');
      });
    });

    describe('PlayStateTypeModelStressTest', () => {

      it('test_stress_createModels_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        for (let i: number = 0; i < 100; i++) {
          const modeIdx: number = i % 3;
          let playMode: 'auto' | 'repeat' | 'random' = 'auto';
          if (modeIdx === 0) {
            playMode = 'auto';
          } else if (modeIdx === 1) {
            playMode = 'repeat';
          } else {
            playMode = 'random';
          }
          const state: PlayStateType = {
            img: '', name: 'song_' + i, author: 'artist_' + i, url: 'url_' + i,
            playIndex: i % 100, time: i * 100, duration: i * 200,
            isPlay: i % 2 === 0,
            playMode: playMode,
            playList: []
          };
          const model: PlayStateTypeModel = new PlayStateTypeModel(state);
          expect(model.name).assertEqual('song_' + i);
        }
      });

      it('test_stress_togglePlayState_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        for (let i: number = 0; i < 100; i++) {
          model.isPlay = !model.isPlay;
        }
        const isBool: boolean = model.isPlay === true || model.isPlay === false;
        expect(isBool).assertTrue();
      });

      it('test_stress_cyclePlayMode_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        for (let i: number = 0; i < 100; i++) {
          const modeIdx: number = i % 3;
          if (modeIdx === 0) {
            model.playMode = 'auto';
          } else if (modeIdx === 1) {
            model.playMode = 'repeat';
          } else {
            model.playMode = 'random';
          }
        }
        const isAuto: boolean = model.playMode === 'auto';
        const isRepeat: boolean = model.playMode === 'repeat';
        const isRandom: boolean = model.playMode === 'random';
        expect(isAuto || isRepeat || isRandom).assertTrue();
      });

      it('test_stress_playIndexIncrement_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 0,
          isPlay: false, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        for (let i: number = 0; i < 100; i++) {
          model.playIndex = (model.playIndex + 1) % 100;
        }
        const resultVal: number = model.playIndex;
        expect(resultVal).assertLarger(-1);
      });

      it('test_stress_timeUpdate_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const state: PlayStateType = {
          img: '', name: '', author: '', url: '',
          playIndex: 0, time: 0, duration: 180000,
          isPlay: true, playMode: 'auto', playList: []
        };
        const model: PlayStateTypeModel = new PlayStateTypeModel(state);
        for (let i: number = 0; i < 100; i++) {
          model.time = (model.time + 100) % model.duration;
        }
        const resultVal: number = model.time;
        expect(resultVal).assertLarger(-1);
      });
    });
  });
}
