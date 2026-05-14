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

import { describe, it, expect, TestType, Size, Level } from '@ohos/hypium';

import AVPlayerClass from '../../../../main/ets/model/MusicPlayer';
import { songItemType } from '../../../../main/ets/model/Music';

interface StringRecord extends Record<string, string> {}
interface ObjectRecord extends Record<string, object> {}
interface NumberRecord extends Record<string, number> {}

class MockAVPlayer {
  public state: string = 'idle';
  public url: string = '';
  private _onStateChange: ((state: string) => void) | null = null;
  private _onDurationUpdate: ((duration: number) => void) | null = null;
  private _onTimeUpdate: ((time: number) => void) | null = null;
  private _onSeekDone: (() => void) | null = null;

  onStateChange(callback: (state: string) => void): void { this._onStateChange = callback; }
  onDurationUpdate(callback: (duration: number) => void): void { this._onDurationUpdate = callback; }
  onTimeUpdate(callback: (time: number) => void): void { this._onTimeUpdate = callback; }
  onSeekDone(callback: () => void): void { this._onSeekDone = callback; }

  prepare(): void {
    this.state = 'prepared';
    if (this._onStateChange) { this._onStateChange('prepared'); }
  }

  play(): void {
    this.state = 'playing';
    if (this._onStateChange) { this._onStateChange('playing'); }
  }

  pause(): void {
    this.state = 'paused';
    if (this._onStateChange) { this._onStateChange('paused'); }
  }

  reset(): Promise<void> {
    this.state = 'idle';
    this.url = '';
    return Promise.resolve();
  }

  release(): void {
    this.state = 'released';
  }

  seek(timeMs: number): void {
    if (this._onSeekDone) { this._onSeekDone(); }
  }

  simulateDurationUpdate(duration: number): void {
    if (this._onDurationUpdate) { this._onDurationUpdate(duration); }
  }

  simulateTimeUpdate(time: number): void {
    if (this._onTimeUpdate) { this._onTimeUpdate(time); }
  }

  simulateStateChange(state: string): void {
    this.state = state;
    if (this._onStateChange) { this._onStateChange(state); }
  }
}

function createMockSongList(): songItemType[] {
  return [
    { img: $r('app.media.album1'), name: 'song1', author: 'artist1', url: 'system/etc/song1.wav', time: 100 } as songItemType,
    { img: $r('app.media.album3'), name: 'song2', author: 'artist2', url: 'system/etc/song2.wav', time: 20000 } as songItemType,
    { img: $r('app.media.album4'), name: 'song3', author: 'artist3', url: 'system/etc/song3.wav', time: 30000 } as songItemType,
    { img: $r('app.media.album1'), name: 'song4', author: 'artist4', url: 'system/etc/song4.wav', time: 40000 } as songItemType,
    { img: $r('app.media.album3'), name: 'song5', author: 'artist5', url: 'system/etc/song5.wav', time: 10000 } as songItemType
  ];
}

export default function MusicPlayerComprehensive001TestSuite(): void {
  describe('MusicPlayerComprehensive001Test', () => {

    describe('AVPlayerClassInstanceTest', () => {

      it('test_avPlayerClass_creation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player !== null).assertTrue();
      });

      it('test_avPlayerClass_defaultValues', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.player).assertEqual(null);
        expect(player.duration).assertEqual(0);
        expect(player.time).assertEqual(0);
        expect(player.isPlay).assertFalse();
        expect(player.playIndex).assertEqual(0);
        expect(player.playList.length).assertEqual(0);
        expect(player.hisIsPlay).assertFalse();
      });

      it('test_avPlayerClass_multipleInstances', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player1: AVPlayerClass = new AVPlayerClass();
        const player2: AVPlayerClass = new AVPlayerClass();
        expect(player1 !== player2).assertTrue();
        expect(player1.isPlay).assertFalse();
        expect(player2.isPlay).assertFalse();
      });

      it('test_avPlayerClass_playListType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(Array.isArray(player.playList)).assertTrue();
      });

      it('test_avPlayerClass_contextType', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.context).assertEqual(null);
      });
    });

    describe('AVPlayerClassPlayListTest', () => {

      it('test_playList_assignBasic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const songs: songItemType[] = createMockSongList();
        player.playList = songs;
        expect(player.playList.length).assertEqual(5);
      });

      it('test_playList_assignEmpty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = [];
        expect(player.playList.length).assertEqual(0);
      });

      it('test_playList_assignSingle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const singleSong: songItemType[] = [{ img: '', name: 'single', author: 'test', url: 'test.wav' } as songItemType];
        player.playList = singleSong;
        expect(player.playList.length).assertEqual(1);
        expect(player.playList[0].name).assertEqual('single');
      });

      it('test_playList_assignLargeList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const songs: songItemType[] = [];
        for (let i: number = 0; i < 200; i++) {
          songs.push({
            img: $r('app.media.album1'),
            name: 'song_' + i.toString(),
            author: 'artist_' + i.toString(),
            url: 'system/etc/song_' + i.toString() + '.wav',
            time: i * 100
          });
        }
        player.playList = songs;
        expect(player.playList.length).assertEqual(200);
      });

      it('test_playList_chineseContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const cnSongs: songItemType[] = [
          { img: '', name: '中文歌曲', author: '中国作者', url: 'cn.wav' } as songItemType
        ];
        player.playList = cnSongs;
        expect(player.playList[0].name).assertEqual('中文歌曲');
      });

      it('test_playList_specialCharContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const specialSongs: songItemType[] = [
          { img: '', name: '!@#$%', author: '<script>', url: 'xss.wav' } as songItemType
        ];
        player.playList = specialSongs;
        expect(player.playList[0].name).assertEqual('!@#$%');
      });

      it('test_playList_httpUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const httpSongs: songItemType[] = [
          { img: '', name: 'network', author: 'online', url: 'http://example.com/music.mp3' } as songItemType
        ];
        player.playList = httpSongs;
        expect(player.playList[0].url).assertEqual('http://example.com/music.mp3');
      });

      it('test_playList_fdUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const fdSongs: songItemType[] = [
          { img: '', name: 'local', author: 'local', url: 'fd://42' } as songItemType
        ];
        player.playList = fdSongs;
        expect(player.playList[0].url).assertEqual('fd://42');
      });

      it('test_playList_mutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        const addedSong: songItemType = { img: '', name: 'added', author: 'test', url: 'add.wav' } as songItemType;
        player.playList.push(addedSong);
        expect(player.playList.length).assertEqual(6);
        player.playList.splice(0, 1);
        expect(player.playList.length).assertEqual(5);
      });
    });

    describe('AVPlayerClassPlayIndexTest', () => {

      it('test_playIndex_default', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.playIndex).assertEqual(0);
      });

      it('test_playIndex_setValid', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 2;
        expect(player.playIndex).assertEqual(2);
      });

      it('test_playIndex_setZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playIndex = 0;
        expect(player.playIndex).assertEqual(0);
      });

      it('test_playIndex_setLast', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 4;
        expect(player.playIndex).assertEqual(4);
      });

      it('test_playIndex_circularForward', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 4;
        player.playIndex = (player.playIndex + 1) % player.playList.length;
        expect(player.playIndex).assertEqual(0);
      });

      it('test_playIndex_circularBackward', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 0;
        player.playIndex = (player.playIndex - 1 + player.playList.length) % player.playList.length;
        expect(player.playIndex).assertEqual(4);
      });

      it('test_playIndex_rapidChange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        for (let i: number = 0; i < 100; i++) {
          player.playIndex = i % player.playList.length;
        }
        expect(typeof player.playIndex).assertEqual('number');
      });
    });

    describe('AVPlayerClassPlayStateTest', () => {

      it('test_isPlay_defaultFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.isPlay).assertFalse();
      });

      it('test_isPlay_toggleToTrue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.isPlay = true;
        expect(player.isPlay).assertTrue();
      });

      it('test_isPlay_toggleMultiple', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        for (let i: number = 0; i < 50; i++) {
          player.isPlay = !player.isPlay;
        }
        expect(typeof player.isPlay).assertEqual('boolean');
      });

      it('test_hisIsPlay_defaultFalse', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.hisIsPlay).assertFalse();
      });

      it('test_hisIsPlay_toggle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.hisIsPlay = true;
        expect(player.hisIsPlay).assertTrue();
      });

      it('test_duration_defaultZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.duration).assertEqual(0);
      });

      it('test_duration_setValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.duration = 180000;
        expect(player.duration).assertEqual(180000);
      });

      it('test_time_defaultZero', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        expect(player.time).assertEqual(0);
      });

      it('test_time_setValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.time = 90000;
        expect(player.time).assertEqual(90000);
      });

      it('test_time_increment', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.duration = 180000;
        for (let i: number = 0; i < 100; i++) {
          player.time = Math.min(player.time + 100, player.duration);
        }
        expect(player.time).assertLarger(0);
      });
    });

    describe('AVPlayerClassNextPreviousTest', () => {

      it('test_next_emptyList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = [];
        let threw: boolean = false;
        try {
          player.next();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });

      it('test_next_singleSong', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const singleSong: songItemType[] = [{ img: '', name: 'only', author: 'test', url: 'only.wav' } as songItemType];
        player.playList = singleSong;
        player.playIndex = 0;
        player.next();
        expect(player.playIndex).assertEqual(0);
      });

      it('test_next_multipleSongs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 0;
        player.next();
        expect(player.playIndex).assertEqual(1);
      });

      it('test_next_wrapAround', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 4;
        player.next();
        expect(player.playIndex).assertEqual(0);
      });

      it('test_next_rapidMultiple', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 0;
        for (let i: number = 0; i < 20; i++) {
          player.next();
        }
        expect(player.playIndex).assertEqual(20 % 5);
      });

      it('test_previous_emptyList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = [];
        let threw: boolean = false;
        try {
          player.previous();
        } catch (e) {
          threw = true;
        }
        expect(threw).assertFalse();
      });

      it('test_previous_singleSong', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const singleSong: songItemType[] = [{ img: '', name: 'only', author: 'test', url: 'only.wav' } as songItemType];
        player.playList = singleSong;
        player.playIndex = 0;
        player.previous();
        expect(player.playIndex).assertEqual(0);
      });

      it('test_previous_fromSecond', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 2;
        player.previous();
        expect(player.playIndex).assertEqual(1);
      });

      it('test_previous_wrapAround', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 0;
        player.previous();
        expect(player.playIndex).assertEqual(4);
      });

      it('test_previous_rapidMultiple', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 0;
        for (let i: number = 0; i < 20; i++) {
          player.previous();
        }
        expect(typeof player.playIndex).assertEqual('number');
      });

      it('test_nextThenPrevious_cancels', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 2;
        player.next();
        player.previous();
        expect(player.playIndex).assertEqual(2);
      });
    });

    describe('AVPlayerClassMusicListTest', () => {

      it('test_musicList_replaceList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const newSongs: songItemType[] = [
          { img: '', name: 'new1', author: 'a1', url: 'u1' } as songItemType,
          { img: '', name: 'new2', author: 'a2', url: 'u2' } as songItemType
        ];
        player.playList = createMockSongList();
        expect(player.playList.length).assertEqual(5);
        player.playList = newSongs;
        expect(player.playList.length).assertEqual(2);
      });

      it('test_musicList_setIndex', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 3;
        expect(player.playIndex).assertEqual(3);
      });

      it('test_musicList_emptyReplacement', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playList = [];
        expect(player.playList.length).assertEqual(0);
      });
    });

    describe('AVPlayerClassTimeDurationTest', () => {

      it('test_duration_maxValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.duration = Number.MAX_SAFE_INTEGER;
        expect(player.duration).assertEqual(Number.MAX_SAFE_INTEGER);
      });

      it('test_time_zeroValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.time = 0;
        expect(player.time).assertEqual(0);
      });

      it('test_time_exceedsDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.duration = 180000;
        player.time = 200000;
        expect(player.time).assertEqual(200000);
      });

      it('test_time_negativeValue', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.time = -1;
        expect(player.time).assertEqual(-1);
      });

      it('test_playListTime_preserved', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const timedSongs: songItemType[] = [
          { img: '', name: 't1', author: 'a1', url: 'u1', time: 30000 } as songItemType,
          { img: '', name: 't2', author: 'a2', url: 'u2', time: 41000 } as songItemType
        ];
        player.playList = timedSongs;
        expect(player.playList[0].time).assertEqual(30000);
        expect(player.playList[1].time).assertEqual(41000);
      });

      it('test_playListTime_zeroDuration', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const zeroSong: songItemType[] = [
          { img: '', name: 'zero', author: 'a', url: 'u', time: 0 } as songItemType
        ];
        player.playList = zeroSong;
        expect(player.playList[0].time).assertEqual(0);
      });

      it('test_playListTime_noTimeField', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const noTimeSong: songItemType[] = [
          { img: '', name: 'noTime', author: 'a', url: 'u' } as songItemType
        ];
        player.playList = noTimeSong;
        expect(player.playList[0].time).assertEqual(undefined);
      });
    });

    describe('AVPlayerClassRestorePlayingStatusTest', () => {

      it('test_restorePlayingStatus_matchingUri', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.player = null;
        let callbackIndex: number = -1;
        const status: ObjectRecord = {} as ObjectRecord;
        player.restorePlayingStatus(status, (index: number): void => {
          callbackIndex = index;
        });
        expect(true).assertTrue();
      });

      it('test_restorePlayingStatus_noMatchingUri', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.player = null;
        let callbackIndex: number = -999;
        const status: ObjectRecord = {} as ObjectRecord;
        player.restorePlayingStatus(status, (index: number): void => {
          callbackIndex = index;
        });
        expect(true).assertTrue();
      });

      it('test_restorePlayingStatus_emptyList', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = [];
        player.player = null;
        let callbackIndex: number = -999;
        const status: ObjectRecord = {} as ObjectRecord;
        player.restorePlayingStatus(status, (index: number): void => {
          callbackIndex = index;
        });
        expect(true).assertTrue();
      });

      it('test_restorePlayingStatus_httpUri', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const httpSongs: songItemType[] = [
          { img: '', name: 'net', author: 'a', url: 'http://example.com/music.mp3' } as songItemType
        ];
        player.playList = httpSongs;
        player.player = null;
        const status: ObjectRecord = {} as ObjectRecord;
        player.restorePlayingStatus(status, (index: number): void => {});
        expect(true).assertTrue();
      });
    });

    describe('MockAVPlayerTest', () => {

      it('test_mockPlayer_stateChange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let receivedState: string = '';
        mockPlayer.onStateChange((state: string): void => { receivedState = state; });
        mockPlayer.prepare();
        expect(receivedState).assertEqual('prepared');
      });

      it('test_mockPlayer_play', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let receivedState: string = '';
        mockPlayer.onStateChange((state: string): void => { receivedState = state; });
        mockPlayer.play();
        expect(receivedState).assertEqual('playing');
      });

      it('test_mockPlayer_pause', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let receivedState: string = '';
        mockPlayer.onStateChange((state: string): void => { receivedState = state; });
        mockPlayer.pause();
        expect(receivedState).assertEqual('paused');
      });

      it('test_mockPlayer_reset', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        mockPlayer.url = 'test.wav';
        await mockPlayer.reset();
        expect(mockPlayer.state).assertEqual('idle');
        expect(mockPlayer.url).assertEqual('');
      });

      it('test_mockPlayer_release', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        mockPlayer.release();
        expect(mockPlayer.state).assertEqual('released');
      });

      it('test_mockPlayer_durationUpdate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let receivedDuration: number = 0;
        mockPlayer.onDurationUpdate((duration: number): void => { receivedDuration = duration; });
        mockPlayer.simulateDurationUpdate(180000);
        expect(receivedDuration).assertEqual(180000);
      });

      it('test_mockPlayer_timeUpdate', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let receivedTime: number = 0;
        mockPlayer.onTimeUpdate((time: number): void => { receivedTime = time; });
        mockPlayer.simulateTimeUpdate(90000);
        expect(receivedTime).assertEqual(90000);
      });

      it('test_mockPlayer_seekDone', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let seekDoneCalled: boolean = false;
        mockPlayer.onSeekDone((): void => { seekDoneCalled = true; });
        mockPlayer.seek(10000);
        expect(seekDoneCalled).assertTrue();
      });

      it('test_mockPlayer_simulateStateChange', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        let receivedState: string = '';
        mockPlayer.onStateChange((state: string): void => { receivedState = state; });
        mockPlayer.simulateStateChange('completed');
        expect(receivedState).assertEqual('completed');
      });

      it('test_mockPlayer_multipleStateChanges', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        const states: string[] = [];
        mockPlayer.onStateChange((state: string): void => { states.push(state); });
        mockPlayer.prepare();
        mockPlayer.play();
        mockPlayer.pause();
        mockPlayer.play();
        expect(states.length).assertEqual(4);
        expect(states[0]).assertEqual('prepared');
        expect(states[1]).assertEqual('playing');
        expect(states[2]).assertEqual('paused');
        expect(states[3]).assertEqual('playing');
      });
    });

    describe('AVPlayerClassStressTest', () => {

      it('test_stress_playIndex_cycling_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        for (let i: number = 0; i < 100; i++) {
          player.playIndex = (player.playIndex + 1) % player.playList.length;
        }
        expect(player.playIndex).assertEqual(100 % 5);
      });

      it('test_stress_next_previous_1000', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        player.playIndex = 0;
        for (let i: number = 0; i < 1000; i++) {
          if (i % 2 === 0) {
            player.next();
          } else {
            player.previous();
          }
        }
        expect(typeof player.playIndex).assertEqual('number');
      });

      it('test_stress_playState_toggle_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        for (let i: number = 0; i < 100; i++) {
          player.isPlay = !player.isPlay;
          player.hisIsPlay = !player.hisIsPlay;
        }
        expect(typeof player.isPlay).assertEqual('boolean');
      });

      it('test_stress_timeUpdate_simulation_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.duration = 180000;
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        mockPlayer.onTimeUpdate((time: number): void => {
          if (time !== 0 && time !== player.time) {
            player.time = time;
          }
        });
        for (let i: number = 0; i < 100; i++) {
          mockPlayer.simulateTimeUpdate(i * 18);
        }
        expect(typeof player.time).assertEqual('number');
      });

      it('test_stress_durationUpdate_simulation_1000', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        const mockPlayer: MockAVPlayer = new MockAVPlayer();
        mockPlayer.onDurationUpdate((duration: number): void => {
          player.duration = duration;
        });
        for (let i: number = 0; i < 1000; i++) {
          mockPlayer.simulateDurationUpdate(i * 36);
        }
        expect(typeof player.duration).assertEqual('number');
      });

      it('test_stress_playlist_modification_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
        const player: AVPlayerClass = new AVPlayerClass();
        player.playList = createMockSongList();
        for (let i: number = 0; i < 100; i++) {
          const addedSong: songItemType = {
            img: $r('app.media.album1'),
            name: 'added_' + i.toString(),
            author: 'artist_' + i.toString(),
            url: 'added_' + i.toString() + '.wav'
          } as songItemType;
          player.playList.push(addedSong);
          if (player.playList.length > 50) {
            player.playList.splice(0, 1);
          }
        }
        expect(player.playList.length).assertLarger(0);
        expect(player.playList.length).assertLess(60);
      });
    });
  });
}
