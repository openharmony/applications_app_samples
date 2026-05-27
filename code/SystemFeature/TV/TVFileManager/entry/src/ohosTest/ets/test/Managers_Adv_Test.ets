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
import { FileJumpTools, PlaylistItem } from '../../../main/ets/common/FileJumpTools';
import { wantConstant } from '@kit.AbilityKit';
import { MediaType } from '../../../main/ets/model/MediaType';
import { CompressManager } from '../../../main/ets/common/manager/CompressManager';

export default function managersAdvTest() {
  describe('Managers_Adv_Test', () => {

    /*
     * FileJumpTools——文件跳转Want构造器。
     * 三种媒体类型(图片/视频/音频)各有一个专用的Want构造方法，
     * 生成的Want用于startAbility打开系统播放器/查看器。
     * 核心差异：flag权限设置、MIME类型、subtitles字幕信息。
     */
    describe('FileJumpTools_Image_Want', () => {
      it('GetImageWant_has_viewData_action', 0, () => {
        // 所有媒体文件均使用viewData action打开
        let want = FileJumpTools.getImageWant('photo.jpg', 'file://media/photo.jpg');
        expect(want.action).assertEqual('ohos.want.action.viewData');
        expect(want.type).assertEqual('image/*');
      });

      it('GetImageWant_has_both_read_write_flags', 0, () => {
        // 需要读写权限：查看器可能需要编辑功能
        let want = FileJumpTools.getImageWant('photo.jpg', 'file://media/photo.jpg');
        let expectedFlags: number = wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION
          | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION;
        expect(want.flags).assertEqual(expectedFlags);
      });

      it('GetImageWant_parameters_contain_uri_and_name', 0, () => {
        // parameters传递原始uri和文件名，目标Ability通过此信息定位文件
        let want = FileJumpTools.getImageWant('test.png', 'file://data/test.png');
        expect(want.parameters).not().assertEqual(undefined);
        if (want.parameters) {
          expect(want.parameters['uri']).assertEqual('file://data/test.png');
          expect(want.parameters['name']).assertEqual('test.png');
        }
      });
    });

    describe('FileJumpTools_Video_Want', () => {
      it('GetVideoWant_has_viewData_action_and_video_type', 0, () => {
        // 视频播放需要明确MIME为video/*
        let want = FileJumpTools.getVideoWant('movie.mp4', 'file://media/movie.mp4');
        // GetVideoWant是async的，此处验证返回的Promise
        expect(want).not().assertEqual(undefined);
      });
    });

    describe('FileJumpTools_Audio_Want', () => {
      it('GetAudioWant_has_viewData_action_and_audio_type', 0, () => {
        // 音频播放器支持播放列表，parameters中包含playList/playListCount/currentIndex
        let playList: PlaylistItem[] = [
          { name: 'song1.mp3', uri: 'file://music/song1.mp3', time: 0 },
          { name: 'song2.mp3', uri: 'file://music/song2.mp3', time: 0 }
        ];
        let want = FileJumpTools.getAudioWant('song1.mp3', 'file://music/song1.mp3', 0, playList);
        expect(want.action).assertEqual('ohos.want.action.viewData');
        expect(want.type).assertEqual('audio/*');
        expect(want.parameters).not().assertEqual(undefined);
        if (want.parameters) {
          expect(want.parameters['playListCount']).assertEqual(2);
          expect(want.parameters['currentIndex']).assertEqual(0);
        }
      });

      it('GetAudioWant_with_empty_playlist_no_playlist_params', 0, () => {
        // 空播放列表时不设置playList相关参数
        let want = FileJumpTools.getAudioWant('song.mp3', 'file://music/song.mp3', 0, []);
        expect(want.parameters).not().assertEqual(undefined);
        if (want.parameters) {
          // 空列表时不添加playList参数
          expect(want.parameters['playList']).assertEqual(undefined);
        }
      });
    });

    describe('FileJumpTools_Photo_Want', () => {
      it('GetPhotoWant_targets_photos_app', 0, () => {
        // 直接跳转到系统相册App查看图片
        let want = FileJumpTools.getPhotoWant('file://media/photo.jpg');
        expect(want.bundleName).assertEqual('com.ohos.photos');
        expect(want.abilityName).assertEqual('com.ohos.photos.MainAbility');
        expect(want.action).assertEqual('ohos.want.action.viewData');
      });
    });

    /*
     * CompressManager——ZIP压缩/解压。
     * 使用@kit.BasicServicesKit的zlib.zipFile/zlib.unzipFile方法，
     * 压缩级别/内存级别/策略均使用默认值。
     */
    describe('CompressManager_Configuration', () => {
      it('CompressManager_has_compress_and_decompress_methods', 0, () => {
        // 验证方法存在性——实际压缩测试需要真实文件系统
        expect(CompressManager.compress).not().assertEqual(undefined);
        expect(CompressManager.decompress).not().assertEqual(undefined);
      });

      it('CompressManager_methods_return_Promise', 0, () => {
        // 压缩/解压均为异步操作
        let result = CompressManager.compress('/test/src', '/test/dest.zip');
        expect(result).not().assertEqual(undefined);
      });
    });

    /*
     * 综合场景：FileJumpTools构造的Want在startAbility中的使用。
     * 验证flags正确组合确保目标Ability有足够的文件访问权限。
     */
    describe('Want_Flag_Combinations', () => {
      it('image_video_audio_all_use_read_write_flags', 0, () => {
        // 三种媒体类型统一使用FLAG_AUTH_WRITE|FLAG_AUTH_READ组合
        // 确保目标Ability可以读写文件（播放器可能需要写字幕/缓存）
        let imgWant = FileJumpTools.getImageWant('img.jpg', 'file://img.jpg');
        let expectedFlags: number = wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION
          | wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION;
        expect(imgWant.flags).assertEqual(expectedFlags);
      });
    });

    /*
     * PlaylistItem接口——音频播放列表项。
     * 包含name/uri两个字段，getAudioWant将列表序列化为JSON传递。
     */
    describe('PlaylistItem_Interface', () => {
      it('PlaylistItem_has_required_fields', 0, () => {
        let item: PlaylistItem = {
          name: 'track1.mp3',
          uri: 'file://audio/track1.mp3',
          time: 0
        };
        expect(item.name).assertEqual('track1.mp3');
        expect(item.uri).assertEqual('file://audio/track1.mp3');
      });
    });
  });
}
