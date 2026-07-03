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
import { checkSuffix, SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';

export default function exhaustiveSuffixTest() {
  describe('Exhaustive_Suffix_Test', () => {

    /*
     * 对ConstantsMedia中每个声明的后缀格式进行逐一检测。
     * 确保IgnoreCase函数正确生成了大小写两份，checkSuffix能正确匹配。
     * 这是文件类型判断正确性的最终保障。
     */
    describe('SUFFIX_VIDEO_Exhaustive', () => {
      let baseVideoSuffixes: string[] = [
        '.ts', '.mpg', '.mp4', '.mov', '.m3u8', '.mkv', '.avi', '.webm',
        '.avc', '.hevc', '.mpeg-4', '.vp9', '.vp8', '.av1', '.wmv',
        '.3gpp', '.3gp', '.matroska', '.m2ts', '.mts', '.ogg', '.rm',
        '.rmvb', '.m4v', '.trp', '.vob', '.mpeg'
      ];

      for (let i: number = 0; i < baseVideoSuffixes.length; i++) {
        let suffix: string = baseVideoSuffixes[i];
        it(`video_${suffix}_lowercase_matches`, 0, () => {
          expect(checkSuffix('test' + suffix, SUFFIX_VIDEO)).assertEqual(true);
        });
        it(`video_${suffix}_uppercase_matches`, 0, () => {
          expect(checkSuffix('test' + suffix.toUpperCase(), SUFFIX_VIDEO)).assertEqual(true);
        });
      }
    });

    describe('SUFFIX_AUDIO_Exhaustive', () => {
      let baseAudioSuffixes: string[] = [
        '.mp3', '.aac', '.flac', '.m4a', '.wav', '.vorbis', '.opus',
        '.pcm', '.wave', '.ac3', '.dts', '.midi', '.amr-nb', '.amr-wb',
        '.amr', '.ogg', '.ape', '.g711', '.l2hc-ai', '.adts',
        '.imelody', '.rtttl', '.ota', '.cook'
      ];

      for (let i: number = 0; i < baseAudioSuffixes.length; i++) {
        let suffix: string = baseAudioSuffixes[i];
        it(`audio_${suffix}_matches`, 0, () => {
          expect(checkSuffix('test' + suffix, SUFFIX_AUDIO)).assertEqual(true);
        });
      }

      for (let i: number = 0; i < baseAudioSuffixes.length; i++) {
        let suffix: string = baseAudioSuffixes[i];
        it(`audio_${suffix}_uppercase_matches`, 0, () => {
          expect(checkSuffix('test' + suffix.toUpperCase(), SUFFIX_AUDIO)).assertEqual(true);
        });
      }
    });

    describe('SUFFIX_IMAGE_Exhaustive', () => {
      let baseImageSuffixes: string[] = [
        '.jpg', '.jpeg', '.png', '.heif', '.webp', '.bmp', '.gif', '.svg'
      ];

      for (let i: number = 0; i < baseImageSuffixes.length; i++) {
        let suffix: string = baseImageSuffixes[i];
        it(`image_${suffix}_matches`, 0, () => {
          expect(checkSuffix('test' + suffix, SUFFIX_IMAGE)).assertEqual(true);
        });
      }

      for (let i: number = 0; i < baseImageSuffixes.length; i++) {
        let suffix: string = baseImageSuffixes[i];
        it(`image_${suffix}_uppercase_matches`, 0, () => {
          expect(checkSuffix('test' + suffix.toUpperCase(), SUFFIX_IMAGE)).assertEqual(true);
        });
      }
    });

    describe('SUFFIX_TEXT_Exhaustive', () => {
      // 文档后缀
      let baseTextSuffixes: string[] = [
        '.doc', '.docx', '.ppt', '.pptx', '.xls', '.xlsx', '.pdf', '.txt'
      ];

      for (let i: number = 0; i < baseTextSuffixes.length; i++) {
        let suffix: string = baseTextSuffixes[i];
        it(`text_${suffix}_matches`, 0, () => {
          expect(checkSuffix('test' + suffix, SUFFIX_TEXT)).assertEqual(true);
        });
      }

      for (let i: number = 0; i < baseTextSuffixes.length; i++) {
        let suffix: string = baseTextSuffixes[i];
        it(`text_${suffix}_uppercase_matches`, 0, () => {
          expect(checkSuffix('test' + suffix.toUpperCase(), SUFFIX_TEXT)).assertEqual(true);
        });
      }
    });

    /*
     * 交叉验证——每种后缀只属于一个类别。
     */
    describe('Cross_Category_NonOverlap', () => {
      it('video_suffixes_not_in_audio', 0, () => {
        let videoOnly: string[] = ['.mp4', '.mkv', '.avi', '.ts', '.mov'];
        for (let s of videoOnly) {
          expect(checkSuffix('test' + s, SUFFIX_AUDIO)).assertEqual(false);
        }
      });

      it('audio_suffixes_not_in_video', 0, () => {
        let audioOnly: string[] = ['.mp3', '.aac', '.flac'];
        for (let s of audioOnly) {
          expect(checkSuffix('test' + s, SUFFIX_VIDEO)).assertEqual(false);
        }
      });

      it('image_suffixes_not_in_video_or_audio', 0, () => {
        let imageOnly: string[] = ['.jpg', '.png', '.webp', '.bmp'];
        for (let s of imageOnly) {
          expect(checkSuffix('test' + s, SUFFIX_VIDEO)).assertEqual(false);
          expect(checkSuffix('test' + s, SUFFIX_AUDIO)).assertEqual(false);
        }
      });

      it('text_suffixes_not_in_media_categories', 0, () => {
        let textOnly: string[] = ['.pdf', '.docx', '.xlsx', '.txt'];
        for (let s of textOnly) {
          expect(checkSuffix('test' + s, SUFFIX_VIDEO)).assertEqual(false);
          expect(checkSuffix('test' + s, SUFFIX_AUDIO)).assertEqual(false);
          expect(checkSuffix('test' + s, SUFFIX_IMAGE)).assertEqual(false);
        }
      });

      // 特殊情况：.ogg 同时出现在VIDEO和AUDIO中
      it('ogg_shared_between_video_and_audio', 0, () => {
        // .ogg既是音频格式又是视频容器格式
        let hasInVideo: boolean = SUFFIX_VIDEO.find((it: string) => it === '.ogg') !== undefined;
        let hasInAudio: boolean = SUFFIX_AUDIO.find((it: string) => it === '.ogg') !== undefined;
        // 两个类别中都包含.ogg（设计如此）
        expect(hasInVideo).assertEqual(true);
        expect(hasInAudio).assertEqual(true);
      });
    });

    /*
     * IgnoreCase函数生成的数组长度验证。
     */
    describe('IgnoreCase_Array_Length', () => {
      it('SUFFIX_VIDEO_has_double_count_due_to_case', 0, () => {
        // 27个基础格式 × 2(大小写) = 54个
        expect(SUFFIX_VIDEO.length >= 27 * 2).assertEqual(true);
      });

      it('SUFFIX_AUDIO_has_double_count_due_to_case', 0, () => {
        expect(SUFFIX_AUDIO.length >= 22 * 2).assertEqual(true);
      });

      it('SUFFIX_IMAGE_has_double_count_due_to_case', 0, () => {
        expect(SUFFIX_IMAGE.length >= 8 * 2).assertEqual(true);
      });

      it('SUFFIX_TEXT_has_double_count_due_to_case', 0, () => {
        expect(SUFFIX_TEXT.length >= 9 * 2).assertEqual(true);
      });
    });

    /*
     * contains检测——checkSuffix用endsWith场景。
     */
    describe('EndsWith_Semantics', () => {
      it('exact_suffix_match_required', 0, () => {
        // endsWith严格匹配后缀
        // 'test.mp4.backup' 的endsWith('.mp4')=false
        expect(checkSuffix('test.mp4.backup', SUFFIX_VIDEO)).assertEqual(false);
      });

      it('partial_suffix_not_matched', 0, () => {
        // 'test.mp4a' 的endsWith('.mp4')=false
        expect(checkSuffix('test.mp4a', SUFFIX_VIDEO)).assertEqual(false);
      });

      it('name_equals_suffix_matches', 0, () => {
        // '.mp4' endsWith('.mp4')=true
        expect(checkSuffix('.mp4', SUFFIX_VIDEO)).assertEqual(true);
      });

      it('name_shorter_than_suffix_never_matches', 0, () => {
        // 'mp' endsWith('.mp4')=false
        expect(checkSuffix('mp', SUFFIX_VIDEO)).assertEqual(false);
      });
    });
  });
}
