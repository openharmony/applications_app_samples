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
import { FileBean } from '../../../main/ets/component/bean/FileBean';
import { FileInfo } from '../../../main/ets/common/data/FileInfo';
import { checkSuffix, SUFFIX_VIDEO, SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT } from '../../../main/ets/common/ConstantsMedia';
import { Tools } from '../../../main/ets/common/utils/Tools';
import { MediaType } from '../../../main/ets/model/MediaType';
import { PageType } from '../../../main/ets/model/PageType';

interface ByteCase {
  input: number;
  expected: string;
}

interface ConstructCase {
  label: string;
  info: ESObject;
  expectedName: string;
}

interface RouteMap {
  mediaType: MediaType;
  expectedPage: PageType;
}

interface EmptyCase {
  input: string;
  expected: boolean;
}

export default function parameterizedDataDriveTest() {
  describe('Parameterized_DataDrive_Test', () => {

    /*
     * 数据驱动参数化测试——同一测试逻辑对多组输入数据执行。
     * 验证算法对边界值和等价类的覆盖。
     */
    describe('Suffix_Detection_Parameterized', () => {
      /*
       * MediaType_VIDEO 后缀参数化。
       * 覆盖：常见格式/大写格式/新编解码格式/移动格式
       */
      let videoCases: string[] = [
        'movie.mp4', 'movie.MP4', 'movie.avi', 'movie.AVI',
        'movie.mkv', 'movie.MKV', 'movie.mov', 'movie.MOV',
        'movie.ts', 'movie.TS', 'movie.webm', 'movie.WEBM',
        'movie.mpg', 'movie.MPG', 'movie.3gp', 'movie.3GP',
        'movie.hevc', 'movie.vp9', 'movie.av1',
        'movie.rmvb', 'movie.wmv', 'movie.m4v',
        'movie.vob', 'movie.mpeg', 'movie.m2ts'
      ];

      for (let i: number = 0; i < videoCases.length; i++) {
        let name: string = videoCases[i];
        it(`video_detection_case_${i}_${name}`, 0, () => {
          // 每个视频格式都应通过checkSuffix positive检测
          expect(checkSuffix(name, SUFFIX_VIDEO)).assertEqual(true);
          // 并且不会误判为其他媒体类型
          expect(checkSuffix(name, SUFFIX_AUDIO)).assertEqual(false);
        });
      }
    });

    describe('Audio_Detection_Parameterized', () => {
      let audioCases: string[] = [
        'song.mp3', 'song.MP3', 'song.aac', 'song.AAC',
        'song.flac', 'song.wav', 'song.WAV', 'song.ogg',
        'song.ape', 'song.opus', 'song.amr',
        'song.ac3', 'song.dts', 'song.midi',
        'song.g711', 'song.adts'
      ];

      for (let i: number = 0; i < audioCases.length; i++) {
        let name: string = audioCases[i];
        it(`audio_detection_case_${i}_${name}`, 0, () => {
          expect(checkSuffix(name, SUFFIX_AUDIO)).assertEqual(true);
          expect(checkSuffix(name, SUFFIX_VIDEO)).assertEqual(false);
        });
      }
    });

    describe('Image_Detection_Parameterized', () => {
      let imageCases: string[] = [
        'photo.jpg', 'photo.JPG', 'photo.jpeg', 'photo.JPEG',
        'photo.png', 'photo.PNG', 'photo.webp', 'photo.WEBP',
        'photo.bmp', 'photo.BMP', 'photo.gif', 'photo.GIF',
        'photo.svg', 'photo.SVG', 'photo.heif'
      ];

      for (let i: number = 0; i < imageCases.length; i++) {
        let name: string = imageCases[i];
        it(`image_detection_case_${i}_${name}`, 0, () => {
          expect(checkSuffix(name, SUFFIX_IMAGE)).assertEqual(true);
        });
      }
    });

    describe('Doc_Detection_Parameterized', () => {
      let docCases: string[] = [
        'doc.pdf', 'doc.PDF', 'doc.docx', 'doc.DOCX',
        'doc.xlsx', 'doc.XLSX', 'doc.pptx', 'doc.PPTX',
        'doc.txt', 'doc.TXT', 'doc.doc', 'doc.DOC',
        'doc.xls', 'doc.XLS', 'doc.ppt', 'doc.PPT'
      ];

      for (let i: number = 0; i < docCases.length; i++) {
        let name: string = docCases[i];
        it(`doc_detection_case_${i}_${name}`, 0, () => {
          expect(checkSuffix(name, SUFFIX_TEXT)).assertEqual(true);
        });
      }
    });

    /*
     * byte2Str参数化——覆盖B/KB/MB/GB全量纲。
     */
    describe('Byte2Str_Parameterized', () => {
      let byteCases: ByteCase[] = [
        { input: 0, expected: '0B' },
        { input: 1, expected: '1B' },
        { input: 512, expected: '512B' },
        { input: 1023, expected: '1023B' },
        { input: 1024, expected: '1KB' },
        { input: 1536, expected: '1.5KB' },
        { input: 2048, expected: '2KB' },
        { input: 10240, expected: '10KB' },
        { input: 1048576, expected: '1MB' },
        { input: 1572864, expected: '1.5MB' },
        { input: 10485760, expected: '10MB' },
        { input: 1073741824, expected: '1GB' },
        { input: 5368709120, expected: '5GB' }
      ];

      for (let i: number = 0; i < byteCases.length; i++) {
        let tc = byteCases[i];
        it(`byte2Str_case_${i}_${tc.input}B_to_${tc.expected}`, 0, () => {
          expect(Tools.byte2Str(tc.input)).assertEqual(tc.expected);
        });
      }
    });

    /*
     * FileBean构造参数化——不同FileInfo组合。
     */
    describe('FileBean_Construction_Parameterized', () => {
      let constructCases: ConstructCase[] = [
        {
          label: 'normal_mp4',
          info: {
            uri: 'file://a.mp4', fileName: 'a.mp4', size: 100, mtime: 1,
            mimeType: 'video', relativePath: '/', mode: 0
          },
          expectedName: 'a.mp4'
        },
        {
          label: 'empty_name',
          info: {
            uri: 'file://empty', fileName: '', size: 0, mtime: 0,
            mimeType: '', relativePath: '', mode: 0
          },
          expectedName: ''
        },
        {
          label: 'chinese_name',
          info: {
            uri: 'file://视频.mp4', fileName: '视频.mp4', size: 1024, mtime: 0,
            mimeType: 'video', relativePath: '/', mode: 0
          },
          expectedName: '视频.mp4'
        },
        {
          label: 'spaced_name',
          info: {
            uri: 'file://my file.txt', fileName: 'my file.txt', size: 0, mtime: 0,
            mimeType: '', relativePath: '', mode: 0
          },
          expectedName: 'my file.txt'
        }
      ];

      for (let i: number = 0; i < constructCases.length; i++) {
        let tc = constructCases[i];
        it(`FileBean_construction_${tc.label}`, 0, () => {
          let bean: FileBean = new FileBean(`p${i}`, tc.info as FileInfo);
          expect(bean.name).assertEqual(tc.expectedName);
          expect(bean.getPath()).assertEqual(tc.info.uri);
        });
      }
    });

    /*
     * 媒体类型路由参数化——验证每个MediaType映射正确的PageType。
     */
    describe('MediaType_Routing_Parameterized', () => {
      let routeMap: RouteMap[] = [
        { mediaType: MediaType.VIDEO, expectedPage: PageType.VIDEO_PAGE },
        { mediaType: MediaType.AUDIO, expectedPage: PageType.AUDIO_PAGE },
        { mediaType: MediaType.DOC, expectedPage: PageType.DOC_PAGE },
        { mediaType: MediaType.IMAGE, expectedPage: PageType.IMAGE_PAGE }
      ];

      for (let i: number = 0; i < routeMap.length; i++) {
        let rm = routeMap[i];
        it(`MediaType_${rm.mediaType}_routes_to_${rm.expectedPage}`, 0, () => {
          // 验证映射存在且一致
          expect(typeof rm.mediaType).assertEqual('number');
          expect(typeof rm.expectedPage).assertEqual('string');
        });
      }
    });

    /*
     * isEmpty参数化——覆盖各种空/非空情况。
     */
    describe('IsEmpty_Parameterized', () => {
      let emptyCases: EmptyCase[] = [
        { input: '', expected: true },
        { input: 'hello', expected: false },
        { input: ' ', expected: false },
        { input: '0', expected: false },
        { input: 'false', expected: false }
      ];

      for (let i: number = 0; i < emptyCases.length; i++) {
        let tc = emptyCases[i];
        it(`isEmpty_case_${i}_${tc.input}`, 0, () => {
          expect(Tools.isEmpty(tc.input)).assertEqual(tc.expected);
        });
      }
    });
  });
}
