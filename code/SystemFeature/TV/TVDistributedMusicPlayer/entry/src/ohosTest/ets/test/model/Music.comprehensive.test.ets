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
import {
  songItemType,
  recommendListType,
  recommendDailyType,
  favoriteListType,
  momentListType,
  SongItemTypeModel,
  RecommendListTypeModel,
  RecommendDailyTypeModel,
  FavoriteListTypeModel,
  MomentListTypeModel
} from '../../../../main/ets/model/Music';

function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += s;
  }
  return result;
}

export default function MusicComprehensiveTestSuite(): void {
  describe('MusicComprehensiveTest', () => {

    describe('SongItemTypeModelTest', () => {

      it('test_SongItemTypeModel_constructor_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: $r('app.media.album1'),
          name: 'dynamic',
          author: '佚名',
          url: 'system/etc/dynamic.wav',
          time: 68372
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.name).assertEqual('dynamic');
        expect(model.author).assertEqual('佚名');
        expect(model.url).assertEqual('system/etc/dynamic.wav');
      });

      it('test_SongItemTypeModel_constructor_minimal', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: '',
          author: '',
          url: ''
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.name).assertEqual('');
        expect(model.author).assertEqual('');
        expect(model.url).assertEqual('');
      });

      it('test_SongItemTypeModel_chineseName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: $r('app.media.album1'),
          name: '?',
          author: '小白团队',
          url: 'system/etc/demo.wav'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.name).assertEqual('?');
      });

      it('test_SongItemTypeModel_specialCharName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: '!@#$%^&*()',
          author: 'test',
          url: 'test'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.name).assertEqual('!@#$%^&*()');
      });

      it('test_SongItemTypeModel_longName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longName: string = strRepeat('x', 100);
        const item: songItemType = {
          img: '',
          name: longName,
          author: 'test',
          url: 'test'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.name).assertEqual(longName);
      });

      it('test_SongItemTypeModel_longUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longUrl: string = strRepeat('/path/', 200) + 'file.wav';
        const item: songItemType = {
          img: '',
          name: 'test',
          author: 'test',
          url: longUrl
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.url).assertEqual(longUrl);
      });

      it('test_SongItemTypeModel_withTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: $r('app.media.album4'),
          name: '流行音乐',
          author: '大型歌剧院',
          url: 'system/etc/graphic/bootsound.wav',
          time: 5041
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect((model as songItemType).time).assertEqual(5041);
      });

      it('test_SongItemTypeModel_zeroTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'zero',
          author: 'test',
          url: 'test',
          time: 0
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect((model as songItemType).time).assertEqual(0);
      });

      it('test_SongItemTypeModel_negativeTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'neg',
          author: 'test',
          url: 'test',
          time: -1
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect((model as songItemType).time).assertEqual(-1);
      });

      it('test_SongItemTypeModel_largeTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'large',
          author: 'test',
          url: 'test',
          time: Number.MAX_SAFE_INTEGER
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect((model as songItemType).time).assertEqual(Number.MAX_SAFE_INTEGER);
      });

      it('test_SongItemTypeModel_httpUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'network',
          author: 'online',
          url: 'http://example.com/music.mp3'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.url).assertEqual('http://example.com/music.mp3');
      });

      it('test_SongItemTypeModel_httpsUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'secure',
          author: 'online',
          url: 'https://example.com/music.mp3'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.url).assertEqual('https://example.com/music.mp3');
      });

      it('test_SongItemTypeModel_fdUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'fd',
          author: 'local',
          url: 'fd://42'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        expect(model.url).assertEqual('fd://42');
      });

      it('test_SongItemTypeModel_propertyMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'original',
          author: 'origAuthor',
          url: 'origUrl'
        };
        const model: SongItemTypeModel = new SongItemTypeModel(item);
        model.name = 'changed';
        model.author = 'changedAuthor';
        expect(model.name).assertEqual('changed');
        expect(model.author).assertEqual('changedAuthor');
      });

      it('test_SongItemTypeModel_rapidCreate_100', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i: number = 0; i < 100; i++) {
          const item: songItemType = {
            img: $r('app.media.album1'),
            name: 'song_' + i,
            author: 'artist_' + i,
            url: 'system/etc/song_' + i + '.wav',
            time: i * 100
          };
          const model: SongItemTypeModel = new SongItemTypeModel(item);
          expect(model.name).assertEqual('song_' + i);
        }
      });
    });

    describe('RecommendListTypeModelTest', () => {

      it('test_RecommendListTypeModel_constructor_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendListType = {
          img: 'cover.jpg',
          title: '推荐歌单',
          count: '50?'
        };
        const model: RecommendListTypeModel = new RecommendListTypeModel(item);
        expect(model.img).assertEqual('cover.jpg');
        expect(model.title).assertEqual('推荐歌单');
        expect(model.count).assertEqual('50?');
      });

      it('test_RecommendListTypeModel_constructor_empty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendListType = { img: '', title: '', count: '' };
        const model: RecommendListTypeModel = new RecommendListTypeModel(item);
        expect(model.img).assertEqual('');
        expect(model.title).assertEqual('');
        expect(model.count).assertEqual('');
      });

      it('test_RecommendListTypeModel_chineseContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendListType = {
          img: '推荐封面.png',
          title: '推荐歌单',
          count: '100首'
        };
        const model: RecommendListTypeModel = new RecommendListTypeModel(item);
        expect(model.title).assertEqual('推荐歌单');
      });

      it('test_RecommendListTypeModel_longTitle', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const longTitle: string = strRepeat('推', 100);
        const item: recommendListType = { img: '', title: longTitle, count: '' };
        const model: RecommendListTypeModel = new RecommendListTypeModel(item);
        expect(model.title).assertEqual(longTitle);
      });

      it('test_RecommendListTypeModel_propertyMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendListType = { img: 'a', title: 'b', count: 'c' };
        const model: RecommendListTypeModel = new RecommendListTypeModel(item);
        model.title = 'changed';
        expect(model.title).assertEqual('changed');
      });

      it('test_RecommendListTypeModel_rapidCreate_50', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i: number = 0; i < 50; i++) {
          const item: recommendListType = {
            img: 'img_' + i + '.jpg',
            title: '歌单_' + i,
            count: (i * 10) + '?'
          };
          const model: RecommendListTypeModel = new RecommendListTypeModel(item);
          expect(model.title).assertEqual('歌单_' + i);
        }
      });
    });

    describe('RecommendDailyTypeModelTest', () => {

      it('test_RecommendDailyTypeModel_constructor_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendDailyType = {
          img: 'daily.jpg',
          title: '每日推荐',
          type: '歌单',
          top: 'Top 1',
          bottom: '2024-01-01'
        };
        const model: RecommendDailyTypeModel = new RecommendDailyTypeModel(item);
        expect(model.title).assertEqual('每日推荐');
        expect(model.type).assertEqual('歌单');
      });

      it('test_RecommendDailyTypeModel_constructor_empty', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendDailyType = { img: '', title: '', type: '', top: '', bottom: '' };
        const model: RecommendDailyTypeModel = new RecommendDailyTypeModel(item);
        expect(model.img).assertEqual('');
        expect(model.title).assertEqual('');
      });

      it('test_RecommendDailyTypeModel_allFieldsPopulated', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendDailyType = {
          img: 'img.png',
          title: '今日推荐',
          type: '摇滚',
          top: 'Top 10',
          bottom: '2024-12-31'
        };
        const model: RecommendDailyTypeModel = new RecommendDailyTypeModel(item);
        expect(model.img).assertEqual('img.png');
        expect(model.title).assertEqual('今日推荐');
        expect(model.type).assertEqual('摇滚');
        expect(model.top).assertEqual('Top 10');
        expect(model.bottom).assertEqual('2024-12-31');
      });

      it('test_RecommendDailyTypeModel_propertyMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: recommendDailyType = { img: '', title: 'orig', type: '', top: '', bottom: '' };
        const model: RecommendDailyTypeModel = new RecommendDailyTypeModel(item);
        model.title = 'changed';
        expect(model.title).assertEqual('changed');
      });
    });

    describe('FavoriteListTypeModelTest', () => {

      it('test_favoriteListTypeModel_constructor_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songItem: songItemType = {
          img: $r('app.media.album1'),
          name: 'favSong',
          author: 'favArtist',
          url: 'fav.wav'
        };
        const item: favoriteListType = {
          name: '我的收藏',
          nickName: '用户A',
          avatar: $r('app.media.album2'),
          songs: [songItem]
        };
        const model: FavoriteListTypeModel = new FavoriteListTypeModel(item);
        expect(model.name).assertEqual('我的收藏');
        expect(model.nickName).assertEqual('用户A');
        expect(model.songs.length).assertEqual(1);
      });

      it('test_favoriteListTypeModel_constructor_emptySongs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: favoriteListType = {
          name: '?',
          nickName: 'empty',
          avatar: '',
          songs: []
        };
        const model: FavoriteListTypeModel = new FavoriteListTypeModel(item);
        expect(model.songs.length).assertEqual(0);
      });

      it('test_favoriteListTypeModel_multipleSongs', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [];
        for (let i: number = 0; i < 50; i++) {
          songs.push({
            img: $r('app.media.album1'),
            name: 'fav_' + i,
            author: 'artist_' + i,
            url: 'fav_' + i + '.wav'
          });
        }
        const item: favoriteListType = {
          name: '?',
          nickName: 'collector',
          avatar: '',
          songs: songs
        };
        const model: FavoriteListTypeModel = new FavoriteListTypeModel(item);
        expect(model.songs.length).assertEqual(50);
      });

      it('test_favoriteListTypeModel_chineseName', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: favoriteListType = {
          name: '我喜欢的音乐',
          nickName: 'nick',
          avatar: '',
          songs: []
        };
        const model: FavoriteListTypeModel = new FavoriteListTypeModel(item);
        expect(model.name).assertEqual('我喜欢的音乐');
      });

      it('test_favoriteListTypeModel_propertyMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: favoriteListType = {
          name: 'orig',
          nickName: 'origNick',
          avatar: '',
          songs: []
        };
        const model: FavoriteListTypeModel = new FavoriteListTypeModel(item);
        model.name = 'changed';
        expect(model.name).assertEqual('changed');
      });
    });

    describe('MomentListTypeModelTest', () => {

      it('test_momentListTypeModel_constructor_basic', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songItem: songItemType = {
          img: $r('app.media.album1'),
          name: 'momentSong',
          author: 'momentArtist',
          url: 'moment.wav'
        };
        const item: momentListType = {
          author: 'user1',
          avatar: 'avatar1.jpg',
          content: '动态内容',
          comment: 5,
          like: 10,
          song: songItem
        };
        const model: MomentListTypeModel = new MomentListTypeModel(item);
        expect(model.author).assertEqual('user1');
        expect(model.content).assertEqual('动态内容');
        expect(model.comment).assertEqual(5);
        expect(model.like).assertEqual(10);
      });

      it('test_momentListTypeModel_constructor_zeroInteractions', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songItem: songItemType = { img: '', name: '', author: '', url: '' };
        const item: momentListType = {
          author: '',
          avatar: '',
          content: '',
          comment: 0,
          like: 0,
          song: songItem
        };
        const model: MomentListTypeModel = new MomentListTypeModel(item);
        expect(model.comment).assertEqual(0);
        expect(model.like).assertEqual(0);
      });

      it('test_momentListTypeModel_largeInteractions', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songItem: songItemType = { img: '', name: '', author: '', url: '' };
        const item: momentListType = {
          author: 'popular',
          avatar: '',
          content: 'viral post',
          comment: Number.MAX_SAFE_INTEGER,
          like: Number.MAX_SAFE_INTEGER,
          song: songItem
        };
        const model: MomentListTypeModel = new MomentListTypeModel(item);
        expect(model.comment).assertEqual(Number.MAX_SAFE_INTEGER);
        expect(model.like).assertEqual(Number.MAX_SAFE_INTEGER);
      });

      it('test_momentListTypeModel_chineseContent', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songItem: songItemType = { img: '', name: '歌曲', author: '歌手', url: '' };
        const item: momentListType = {
          author: '动态作者',
          avatar: '头像.jpg',
          content: '分享了一首很棒的歌',
          comment: 100,
          like: 999,
          song: songItem
        };
        const model: MomentListTypeModel = new MomentListTypeModel(item);
        expect(model.author).assertEqual('动态作者');
        expect(model.content).assertEqual('分享了一首很棒的歌');
      });

      it('test_momentListTypeModel_propertyMutation', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songItem: songItemType = { img: '', name: '', author: '', url: '' };
        const item: momentListType = {
          author: 'orig',
          avatar: '',
          content: 'orig',
          comment: 0,
          like: 0,
          song: songItem
        };
        const model: MomentListTypeModel = new MomentListTypeModel(item);
        model.author = 'changed';
        model.content = 'changed';
        model.like = 100;
        expect(model.author).assertEqual('changed');
        expect(model.content).assertEqual('changed');
        expect(model.like).assertEqual(100);
      });

      it('test_momentListTypeModel_rapidCreate_50', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        for (let i: number = 0; i < 50; i++) {
          const songItem: songItemType = {
            img: '',
            name: 'moment_song_' + i,
            author: 'moment_artist_' + i,
            url: 'moment_' + i + '.wav'
          };
          const item: momentListType = {
            author: 'user_' + i,
            avatar: 'avatar_' + i + '.jpg',
            content: '?_' + i,
            comment: i,
            like: i * 2,
            song: songItem
          };
          const model: MomentListTypeModel = new MomentListTypeModel(item);
          expect(model.author).assertEqual('user_' + i);
        }
      });
    });

    describe('SongItemInterfaceTest', () => {

      it('test_songItemType_allFields', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: $r('app.media.album1'),
          name: 'test',
          author: 'tester',
          url: 'test.wav',
          time: 30000
        };
        expect(item.name).assertEqual('test');
        expect(item.author).assertEqual('tester');
        expect(item.url).assertEqual('test.wav');
        expect(item.time).assertEqual(30000);
      });

      it('test_songItemType_optionalTime', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const item: songItemType = {
          img: '',
          name: 'noTime',
          author: 'test',
          url: 'test.wav'
        };
        expect(item.time).assertEqual(undefined);
      });

      it('test_songItemType_arrayOperations', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [
          { img: '', name: 's1', author: 'a1', url: 'u1', time: 100 },
          { img: '', name: 's2', author: 'a2', url: 'u2', time: 2000 },
          { img: '', name: 's3', author: 'a3', url: 'u3', time: 3000 }
        ];
        expect(songs.length).assertEqual(3);
        songs.push({ img: '', name: 's4', author: 'a4', url: 'u4', time: 4000 });
        expect(songs.length).assertEqual(4);
        const found: songItemType | undefined = songs.find((s: songItemType): boolean => s.name === 's2');
        expect(found !== undefined).assertTrue();
        if (found !== undefined) {
          expect(found.author).assertEqual('a2');
        }
      });

      it('test_songItemType_findByUrl', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [
          { img: '', name: 's1', author: 'a1', url: 'url1.wav' },
          { img: '', name: 's2', author: 'a2', url: 'url2.wav' }
        ];
        const idx: number = songs.findIndex((s: songItemType): boolean => s.url === 'url2.wav');
        expect(idx).assertEqual(1);
      });

      it('test_songItemType_splice', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [
          { img: '', name: 's1', author: 'a1', url: 'u1' },
          { img: '', name: 's2', author: 'a2', url: 'u2' },
          { img: '', name: 's3', author: 'a3', url: 'u3' }
        ];
        songs.splice(1, 1);
        expect(songs.length).assertEqual(2);
        expect(songs[1].name).assertEqual('s3');
      });

      it('test_songItemType_unshift', TestType.FUNCTION | Size.SMALLTEST | Level.LEVEL0, () => {
        const songs: songItemType[] = [
          { img: '', name: 's1', author: 'a1', url: 'u1' }
        ];
        songs.unshift({ img: '', name: 's0', author: 'a0', url: 'u0' });
        expect(songs.length).assertEqual(2);
        expect(songs[0].name).assertEqual('s0');
      });
    });

    it('test_stress_createAllModels_100', TestType.RELIABILITY | Size.LARGETEST | Level.LEVEL3, () => {
      for (let i: number = 0; i < 100; i++) {
        const song: SongItemTypeModel = new SongItemTypeModel({
          img: $r('app.media.album1'),
          name: 'stress_' + i,
          author: 'artist_' + i,
          url: 'stress_' + i + '.wav',
          time: i * 100
        });
        const rec: RecommendListTypeModel = new RecommendListTypeModel({
          img: 'img_' + i,
          title: 'title_' + i,
          count: i + '?'
        });
        const daily: RecommendDailyTypeModel = new RecommendDailyTypeModel({
          img: 'daily_' + i,
          title: 'daily_' + i,
          type: 'pop',
          top: 'top_' + i,
          bottom: 'bottom_' + i
        });
        expect(song.name).assertEqual('stress_' + i);
        expect(rec.title).assertEqual('title_' + i);
        expect(daily.title).assertEqual('daily_' + i);
      }
    });
  });
}
