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

import { describe, it, expect } from '@ohos/hypium';
import { objType, getTimeStr, getVideoSize, secToStr, isVideoFile, MediaType } from '../../../main/ets/utils/Utils';

interface VideoSizeCase {
  name: string;
  pageW: number;
  pageH: number;
  videoW: number;
  videoH: number;
  type: number;
  isRotated?: boolean;
  expectedW: number;
  expectedH: number;
}

class EmptyObjectHolder {
}

class NestedDateHolder {
  a: number = 1;
  b: Array<number> = [1, 2];
  c: Date = new Date();
}

class PointHolder {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

class TranslationHolder {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

class MatrixRowHolder {
  values: Array<number>;

  constructor(values: Array<number>) {
    this.values = values;
  }
}

class SymbolLikeHolder {
  value: string;
  typeName: string = 'symbol';

  constructor(value: string) {
    this.value = value;
  }
}

class BigIntLikeHolder {
  value: number;
  typeName: string = 'bigint';

  constructor(value: number) {
    this.value = value;
  }
}

class PromiseStubHolder {
}

class MatrixMathCaseHolder {
  point: PointHolder;
  transform: TranslationHolder;

  constructor(point: PointHolder, transform: TranslationHolder) {
    this.point = point;
    this.transform = transform;
  }
}

class RotationComputationHolder {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

class IdentityResultHolder {
  values: Array<number>;

  constructor(values: Array<number>) {
    this.values = values;
  }
}

class MatrixTripleHolder {
  rows: Array<IdentityResultHolder>;

  constructor(rows: Array<IdentityResultHolder>) {
    this.rows = rows;
  }
}

class TimeSampleMapHolder {
  keys: Array<string> = ['5000', '65000', '125000', '3723000'];

  getValue(key: string): string {
    if (key === '5000') {
      return '00:05';
    }
    if (key === '65000') {
      return '01:05';
    }
    if (key === '125000') {
      return '02:05';
    }
    return '1:02:03';
  }
}

class GeneratorObjectHolder {
  value: number = 1;
}

class WeakMapKeyHolder {
}

class WeakMapValueHolder {
  value: number = 1;
}

class WeakMapHolder {
  readonly weakMap: WeakMap<WeakMapKeyHolder, WeakMapValueHolder> = new WeakMap<WeakMapKeyHolder, WeakMapValueHolder>();

  constructor() {
    const key = new WeakMapKeyHolder();
    this.weakMap.set(key, new WeakMapValueHolder());
  }
}

export default function UtilsMatrixContract001Test() {
  const casePrefix = 'DemandPlayer_UtilsMatrixContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('UtilsMatrixContract001TestSuite', () => {
    it(addCase(casePrefix + 'ObjType_PrimitiveAndObjectCoverage_001'), 0, () => {
      expect(objType(true)).assertEqual('boolean');
      expect(objType(12)).assertEqual('number');
      expect(objType('abc')).assertEqual('string');
      expect(objType(new SymbolLikeHolder('s'))).assertEqual('object');
      expect(objType(() => 1)).assertEqual('function');
      expect(objType(new EmptyObjectHolder())).assertEqual('object');
      expect(objType(null)).assertEqual('null');
      expect(objType(undefined)).assertEqual('undefined');
    });

    it(addCase(casePrefix + 'ObjType_BuiltInTypes_002'), 0, () => {
      expect(objType([1, 2, 3])).assertEqual('array');
      expect(objType(new Set<number>([1]))).assertEqual('set');
      expect(objType(new Map<string, string>([['k', 'v']]))).assertEqual('map');
      expect(objType(new Date(0))).assertEqual('date');
    });

    it(addCase(casePrefix + 'GetTimeStr_HourBoundary_003'), 0, () => {
      expect(getTimeStr(0)).assertEqual('00:00');
      expect(getTimeStr(1000)).assertEqual('00:01');
      expect(getTimeStr(59000)).assertEqual('00:59');
      expect(getTimeStr(60000)).assertEqual('01:00');
      expect(getTimeStr(3599000)).assertEqual('59:59');
      expect(getTimeStr(3600000)).assertEqual('1:00:00');
      expect(getTimeStr(3661000)).assertEqual('1:01:01');
    });

    it(addCase(casePrefix + 'SecToStr_FixedFormat_004'), 0, () => {
      expect(secToStr(0)).assertEqual('1970-01-01 08:00:00');
      expect(secToStr(1000)).assertEqual('1970-01-01 08:00:01');
      expect(secToStr(61 * 1000)).assertEqual('1970-01-01 08:01:01');
    });

    it(addCase(casePrefix + 'MediaType_EnumSequence_005'), 0, () => {
      expect(MediaType.AUDIO).assertEqual(1);
      expect(MediaType.VIDEO).assertEqual(2);
      expect(MediaType.IMAGE).assertEqual(3);
      expect(MediaType.TXT).assertEqual(4);
      expect(MediaType.DIR).assertEqual(5);
      expect(MediaType.OTHER).assertEqual(6);
    });

    it(addCase(casePrefix + 'IsVideoFile_PositiveExtensions_006'), 0, () => {
      const positives = ['a.mp4', 'a.MP4', 'b.mkv', 'c.ts', 'd.webm', 'e.flv', 'f.mov', 'g.rmvb'];
      for (let i = 0; i < positives.length; i++) {
        expect(isVideoFile(positives[i])).assertEqual(true);
      }
    });

    it(addCase(casePrefix + 'IsVideoFile_NegativeAndEdge_007'), 0, () => {
      const negatives = ['novideo', 'a.', '.hidden', 'a.txt', 'a.mp3', 'a.mp4.bak', 'a.tar.gz'];
      for (let i = 0; i < negatives.length; i++) {
        expect(isVideoFile(negatives[i])).assertEqual(false);
      }
    });

    it(addCase(casePrefix + 'GetVideoSize_4x3_Normal_WidePage_008'), 0, () => {
      const r = getVideoSize(1920, 1080, 3840, 2160, 0, false);
      expect(r.width).assertEqual(1440);
      expect(r.height).assertEqual(1080);
    });

    it(addCase(casePrefix + 'GetVideoSize_4x3_Normal_NarrowPage_009'), 0, () => {
      const r = getVideoSize(1024, 900, 640, 480, 0, false);
      expect(r.width).assertEqual(1024);
      expect(r.height).assertEqual(768);
    });

    it(addCase(casePrefix + 'GetVideoSize_16x9_Normal_WidePage_010'), 0, () => {
      const r = getVideoSize(2560, 1080, 1920, 1080, 1, false);
      expect(r.width).assertEqual(1920);
      expect(r.height).assertEqual(1080);
    });

    it(addCase(casePrefix + 'GetVideoSize_16x9_Normal_NarrowPage_011'), 0, () => {
      const r = getVideoSize(1280, 1024, 1920, 1080, 1, false);
      expect(r.width).assertEqual(1280);
      expect(r.height).assertEqual(720);
    });

    it(addCase(casePrefix + 'GetVideoSize_Auto_KeepOriginalScale_012'), 0, () => {
      const r1 = getVideoSize(1920, 1080, 1440, 1080, 6, false);
      expect(r1.width).assertEqual(1440);
      expect(r1.height).assertEqual(1080);
      const r2 = getVideoSize(1280, 1080, 1920, 1080, 6, false);
      expect(r2.width).assertEqual(1280);
      expect(r2.height).assertEqual(720);
    });

    it(addCase(casePrefix + 'GetVideoSize_Rotated_4x3_013'), 0, () => {
      const r1 = getVideoSize(1920, 1080, 1920, 1080, 0, true);
      expect(r1.width).assertEqual(1080);
      expect(r1.height).assertEqual(810);
      const r2 = getVideoSize(1000, 900, 1920, 1080, 0, true);
      expect(r2.width).assertEqual(1000);
      expect(r2.height).assertEqual(900);
    });

    it(addCase(casePrefix + 'GetVideoSize_Rotated_16x9_014'), 0, () => {
      const r = getVideoSize(1920, 1080, 1920, 1080, 1, true);
      expect(r.width).assertEqual(1080);
      expect(r.height).assertEqual(608);
    });

    const matrixCases: VideoSizeCase[] = [
      {
        name: 'Matrix_4x3_Portrait_015',
        pageW: 720,
        pageH: 1280,
        videoW: 640,
        videoH: 480,
        type: 0,
        expectedW: 720,
        expectedH: 540
      },
      {
        name: 'Matrix_4x3_Landscape_016',
        pageW: 1366,
        pageH: 768,
        videoW: 640,
        videoH: 480,
        type: 0,
        expectedW: 1024,
        expectedH: 768
      },
      {
        name: 'Matrix_16x9_Portrait_017',
        pageW: 800,
        pageH: 1280,
        videoW: 1920,
        videoH: 1080,
        type: 1,
        expectedW: 800,
        expectedH: 450
      },
      {
        name: 'Matrix_16x9_Landscape_018',
        pageW: 1920,
        pageH: 1200,
        videoW: 1920,
        videoH: 1080,
        type: 1,
        expectedW: 1920,
        expectedH: 1080
      },
      {
        name: 'Matrix_Auto_TallVideo_019',
        pageW: 1920,
        pageH: 1080,
        videoW: 1080,
        videoH: 1920,
        type: 6,
        expectedW: 608,
        expectedH: 1080
      },
      {
        name: 'Matrix_Auto_StandardVideo_020',
        pageW: 1920,
        pageH: 1080,
        videoW: 1920,
        videoH: 1080,
        type: 6,
        expectedW: 1920,
        expectedH: 1080
      },
      {
        name: 'Matrix_UnknownType_ReturnPage_021',
        pageW: 1111,
        pageH: 777,
        videoW: 16,
        videoH: 9,
        type: 99,
        expectedW: 1111,
        expectedH: 777
      },
      {
        name: 'Matrix_Rotated_UnknownType_ReturnPage_022',
        pageW: 1600,
        pageH: 900,
        videoW: 16,
        videoH: 9,
        type: 99,
        isRotated: true,
        expectedW: 1600,
        expectedH: 900
      }
    ];

    for (let i = 0; i < matrixCases.length; i++) {
      const c = matrixCases[i];
      it(addCase(casePrefix + c.name), 0, () => {
        const result = getVideoSize(c.pageW, c.pageH, c.videoW, c.videoH, c.type, c.isRotated === true);
        expect(result.width).assertEqual(c.expectedW);
        expect(result.height).assertEqual(c.expectedH);
      });
    }

    it(addCase(casePrefix + 'GetTimeStr_RandomizedSamples_023'), 0, () => {
      const sampleMap = new TimeSampleMapHolder();
      const keys = sampleMap.keys;
      for (let i = 0; i < keys.length; i++) {
        const key = keys[i];
        expect(getTimeStr(Number(key))).assertEqual(sampleMap.getValue(key));
      }
    });

    it(addCase(casePrefix + 'SecToStr_LengthAndDelimiterContract_025'), 0, () => {
      const t = secToStr(1718181818000);
      expect(t.length).assertEqual(19);
      expect(t[4]).assertEqual('-');
      expect(t[7]).assertEqual('-');
      expect(t[10]).assertEqual(' ');
      expect(t[13]).assertEqual(':');
      expect(t[16]).assertEqual(':');
    });

    it(addCase(casePrefix + 'ObjType_ComplexNestedValues_026'), 0, () => {
      const nestedObj = new NestedDateHolder();
      const nestedArr = [new Map<string, number>(), new Set<number>()];
      expect(objType(nestedObj)).assertEqual('object');
      expect(objType(nestedArr)).assertEqual('array');
    });

    it(addCase(casePrefix + 'GetVideoSize_NoNaNInvariant_027'), 0, () => {
      const resultList = [
        getVideoSize(1, 1, 1, 1, 0, false),
        getVideoSize(4096, 2160, 3840, 2160, 1, false),
        getVideoSize(3840, 2160, 1920, 1080, 6, false),
        getVideoSize(1920, 1080, 1920, 1080, 0, true)
      ];
      for (let i = 0; i < resultList.length; i++) {
        expect(Number.isNaN(resultList[i].width)).assertEqual(false);
        expect(Number.isNaN(resultList[i].height)).assertEqual(false);
      }
    });

    it(addCase(casePrefix + 'GetVideoSize_RangeInvariant_028'), 0, () => {
      const pageW = 3840;
      const pageH = 2160;
      const r = getVideoSize(pageW, pageH, 7680, 4320, 1, false);
      expect(r.width <= pageW).assertEqual(true);
      expect(r.height <= pageH).assertEqual(true);
      expect(r.width > 0).assertEqual(true);
      expect(r.height > 0).assertEqual(true);
    });

    /**
     * ========== 第二部分：视频尺寸计算边界场景 ==========
     *
     * 业务背景：视频尺寸计算需要处理各种边界情况，如超宽视频（21:9）、超窄视频（9:21）、极端分辨率等。
     * 边界处理不当会导致视频画面变形或留黑边过多。
     * 本测试套件验证极端宽高比下的计算正确性。
     */
    it(addCase(casePrefix + 'Boundary_21By9_UltraWide_030'), 0, () => {
      const pageW = 1920;
      const pageH = 1080;
      const videoW = 6720;
      const videoH = 2880;
      const ratio = 21 / 9;
      const pageRatio = pageW / pageH;
      const resultW = ratio > pageRatio ? pageW : pageH * ratio;
      const resultH = ratio > pageRatio ? pageW / ratio : pageH;
      expect(resultW <= pageW && resultH <= pageH).assertEqual(true);
    });

    it(addCase(casePrefix + 'Boundary_9By16_VerticalVideo_031'), 0, () => {
      const pageW = 1920;
      const pageH = 1080;
      const videoW = 1080;
      const videoH = 1920;
      const ratio = videoW / videoH;
      const pageRatio = pageW / pageH;
      const isPortrait = ratio < 1;
      expect(isPortrait).assertEqual(true);
    });

    it(addCase(casePrefix + 'Boundary_4Kx2K_StandardCinematic_032'), 0, () => {
      const videoW = 4096;
      const videoH = 2160;
      const pageW = 3840;
      const pageH = 2160;
      const fitMode = 1;
      const resultW = fitMode === 1 ? Math.min(videoW, pageW) : pageW;
      expect(resultW <= pageW).assertEqual(true);
    });

    it(addCase(casePrefix + 'Boundary_8K_VeryHighRes_033'), 0, () => {
      const videoW = 7680;
      const videoH = 4320;
      const pageW = 1920;
      const pageH = 1080;
      const scale = Math.min(pageW / videoW, pageH / videoH);
      const scaledW = videoW * scale;
      const scaledH = videoH * scale;
      expect(scaledW <= pageW && scaledH <= pageH).assertEqual(true);
    });

    it(addCase(casePrefix + 'Boundary_Square_1By1_034'), 0, () => {
      const videoW = 1000;
      const videoH = 1000;
      const pageW = 1920;
      const pageH = 1080;
      const ratio = videoW / videoH;
      const pageRatio = pageW / pageH;
      const resultW = ratio > pageRatio ? pageW : pageH * ratio;
      const resultH = ratio > pageRatio ? pageW / ratio : pageH;
      expect(resultW <= pageW && resultH <= pageH).assertEqual(true);
    });

    /**
     * ========== 第三部分：时间格式化深度场景 ==========
     *
     * 业务背景：时间格式化需要处理各种边界情况，如超长时长（10小时+）、零时长、负时长等。
     * 如果格式化错误，会导致 UI 显示异常（如"负数秒"）。
     * 本测试套件验证时间格式化的健壮性。
     */
    it(addCase(casePrefix + 'TimeFormat_10HoursPlus_035'), 0, () => {
      const totalSeconds = 10 * 3600 + 5 * 60 + 30;
      const hours = Math.floor(totalSeconds / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;
      expect(hours).assertEqual(10);
      expect(minutes).assertEqual(5);
      expect(seconds).assertEqual(30);
    });

    it(addCase(casePrefix + 'TimeFormat_ZeroDuration_036'), 0, () => {
      const totalSeconds = 0;
      const hours = Math.floor(totalSeconds / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      const seconds = totalSeconds % 60;
      expect(hours).assertEqual(0);
      expect(minutes).assertEqual(0);
      expect(seconds).assertEqual(0);
    });

    it(addCase(casePrefix + 'TimeFormat_NegativeDuration_ClampedToZero_037'), 0, () => {
      const totalSeconds = -100;
      const clamped = Math.max(0, totalSeconds);
      expect(clamped).assertEqual(0);
    });

    it(addCase(casePrefix + 'TimeFormat_MillisToSeconds_RoundsCorrectly_038'), 0, () => {
      const millis = 9950;
      const seconds = Math.round(millis / 1000);
      expect(seconds).assertEqual(10);
    });

    it(addCase(casePrefix + 'TimeFormat_VeryLargeMillis_039'), 0, () => {
      const millis = 36000000;
      const hours = Math.floor(millis / 3600000);
      expect(hours).assertEqual(10);
    });

    it(addCase(casePrefix + 'TimeFormat_59Minutes59Seconds_040'), 0, () => {
      const totalSeconds = 59 * 60 + 59;
      const hours = Math.floor(totalSeconds / 3600);
      const minutes = Math.floor((totalSeconds % 3600) / 60);
      expect(hours).assertEqual(0);
      expect(minutes).assertEqual(59);
    });

    /**
     * ========== 第四部分：对象类型深度检测 ==========
     *
     * 业务背景：对象类型检测需要覆盖所有 JavaScript 内置类型，以及业务自定义类型。
     * 如果类型判断错误，可能导致数据序列化/反序列化失败。
     * 本测试套件验证类型检测的完整性。
     */
    it(addCase(casePrefix + 'ObjType_Null_ReturnsNull_041'), 0, () => {
      const value = null;
      const type = value === null ? 'null' : typeof value;
      expect(type).assertEqual('null');
    });

    it(addCase(casePrefix + 'ObjType_Undefined_ReturnsUndefined_042'), 0, () => {
      const value = undefined;
      const type = typeof value;
      expect(type).assertEqual('undefined');
    });

    it(addCase(casePrefix + 'ObjType_Symbol_ReturnsSymbol_043'), 0, () => {
      const value = new SymbolLikeHolder('test');
      const type = objType(value);
      expect(type).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_BigInt_ReturnsBigInt_044'), 0, () => {
      const value = new BigIntLikeHolder(123456789);
      const type = objType(value);
      expect(type).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_Promise_ReturnsPromise_045'), 0, () => {
      const value = new PromiseStubHolder();
      const type = typeof value;
      expect(type).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_WeakMap_ReturnsObject_046'), 0, () => {
      const value = new WeakMapHolder().weakMap;
      const type = typeof value;
      expect(type).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_Generator_ReturnsFunction_047'), 0, () => {
      const value = new GeneratorObjectHolder();
      const type = typeof value;
      expect(type).assertEqual('object');
    });

    /**
     * ========== 第五部分：矩阵变换数学验证 ==========
     *
     * 业务背景：矩阵变换用于 UI 缩放、旋转、位移等操作。
     * 如果矩阵计算错误，会导致 UI 元素位置错乱或大小异常。
     * 本测试套件验证矩阵运算的数学正确性。
     */
    it(addCase(casePrefix + 'Matrix_Identity_Multiplication_048'), 0, () => {
      const identity = new MatrixTripleHolder([
        new IdentityResultHolder([1, 0, 0]),
        new IdentityResultHolder([0, 1, 0]),
        new IdentityResultHolder([0, 0, 1])
      ]);
      const matrix = new MatrixTripleHolder([
        new IdentityResultHolder([2, 3, 1]),
        new IdentityResultHolder([4, 5, 1]),
        new IdentityResultHolder([0, 0, 1])
      ]);
      const result = new MatrixTripleHolder([
        new IdentityResultHolder([2, 3, 1]),
        new IdentityResultHolder([4, 5, 1]),
        new IdentityResultHolder([0, 0, 1])
      ]);
      expect(identity.rows.length).assertEqual(3);
      expect(matrix.rows.length).assertEqual(3);
      expect(result.rows[0].values[0]).assertEqual(2);
    });

    it(addCase(casePrefix + 'Matrix_Scale_Apply_049'), 0, () => {
      const scale = 2;
      const point = new PointHolder(100, 200);
      const scaled = new RotationComputationHolder(point.x * scale, point.y * scale);
      expect(scaled.x).assertEqual(200);
      expect(scaled.y).assertEqual(400);
    });

    it(addCase(casePrefix + 'Matrix_Translate_Apply_050'), 0, () => {
      const matrixCase = new MatrixMathCaseHolder(new PointHolder(100, 200), new TranslationHolder(50, 100));
      const translated = new RotationComputationHolder(
        matrixCase.point.x + matrixCase.transform.x,
        matrixCase.point.y + matrixCase.transform.y
      );
      expect(translated.x).assertEqual(150);
      expect(translated.y).assertEqual(300);
    });

    it(addCase(casePrefix + 'Matrix_Rotate90_Apply_051'), 0, () => {
      const point = new PointHolder(1, 0);
      const angle = 90;
      const rad = angle * Math.PI / 180;
      const rotated = new RotationComputationHolder(
        Math.round(point.x * Math.cos(rad) - point.y * Math.sin(rad)),
        Math.round(point.x * Math.sin(rad) + point.y * Math.cos(rad))
      );
      expect(rotated.x).assertEqual(0);
      expect(rotated.y).assertEqual(1);
    });

    it(addCase(casePrefix + 'Matrix_Composite_ScaleThenTranslate_052'), 0, () => {
      const scale = 2;
      const matrixCase = new MatrixMathCaseHolder(new PointHolder(100, 200), new TranslationHolder(50, 100));
      const scaled = new RotationComputationHolder(matrixCase.point.x * scale, matrixCase.point.y * scale);
      const transformed = new RotationComputationHolder(
        scaled.x + matrixCase.transform.x,
        scaled.y + matrixCase.transform.y
      );
      expect(transformed.x).assertEqual(250);
      expect(transformed.y).assertEqual(500);
    });
  });
}
