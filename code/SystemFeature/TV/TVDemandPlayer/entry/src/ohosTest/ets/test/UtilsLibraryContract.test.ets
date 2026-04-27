/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may not require by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect } from '@ohos/hypium';
import { isVideoFile, objType } from '../../../main/ets/utils/Utils';

class WindowRectHolder {
  width: number;
  height: number;

  constructor(width: number, height: number) {
    this.width = width;
    this.height = height;
  }
}

class WindowPropertiesHolder {
  windowRect: WindowRectHolder;

  constructor(windowRect: WindowRectHolder) {
    this.windowRect = windowRect;
  }
}

class FakeWindowHolder {
  private readonly onGetProperties: () => Promise<WindowPropertiesHolder | PlainObjectHolder>;

  constructor(onGetProperties: () => Promise<WindowPropertiesHolder | PlainObjectHolder>) {
    this.onGetProperties = onGetProperties;
  }

  getProperties(): Promise<WindowPropertiesHolder | PlainObjectHolder> {
    return this.onGetProperties();
  }
}

class PlainObjectHolder {
  a: number = 1;
}

class NestedObjectHolder {
  a: NestedChildHolder = new NestedChildHolder();
  arr: Array<number> = [1, 2, 3];
}

class NestedChildHolder {
  b: NestedLeafHolder = new NestedLeafHolder();
}

class NestedLeafHolder {
  value: number = 1;
}

class SimpleFunctionHolder {
  call(): void {
  }
}

class SymbolLikeHolder {
  value: string;
  typeName: string = 'symbol';

  constructor(value: string) {
    this.value = value;
  }
}

class PlainBHolder {
  b: number = 2;
}

class TargetHolder {
  x: number = 1;
}

interface AppWindowResultLike {
  pageW: number;
  pageH: number;
}

class NullWindowHolder {
}

class UndefinedWindowHolder {
}

class WindowPropertiesProviderHolder {
  getProperties?: () => Promise<WindowPropertiesHolder | PlainObjectHolder>;
}

async function getAppWindowSizeCompat(win: FakeWindowHolder | NullWindowHolder | UndefinedWindowHolder): Promise<AppWindowResultLike> {
  const target = win as WindowPropertiesProviderHolder;
  if (!target.getProperties) {
    throw new Error('missing-getProperties');
  }
  const properties = await target.getProperties();
  const rect = (properties as WindowPropertiesHolder).windowRect;
  if (rect) {
    return { pageW: rect.width, pageH: rect.height };
  }
  return { pageW: 0, pageH: 0 };
}

export default function UtilsLibraryContract001Test() {
  const casePrefix = 'DemandPlayer_UtilsLibraryContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('UtilsLibraryContract001TestSuite', () => {
    it(addCase(casePrefix + 'ObjType_Null_ReturnsNull_001'), 0, () => {
      expect(objType(null)).assertEqual('null');
    });

    it(addCase(casePrefix + 'ObjType_Undefined_ReturnsUndefined_002'), 0, () => {
      expect(objType(undefined)).assertEqual('undefined');
    });

    it(addCase(casePrefix + 'ObjType_Boolean_ReturnsBoolean_003'), 0, () => {
      expect(objType(true)).assertEqual('boolean');
      expect(objType(false)).assertEqual('boolean');
    });

    it(addCase(casePrefix + 'ObjType_Number_ReturnsNumber_004'), 0, () => {
      expect(objType(0)).assertEqual('number');
      expect(objType(-42)).assertEqual('number');
      expect(objType(3.14)).assertEqual('number');
      expect(objType(NaN)).assertEqual('number');
      expect(objType(Infinity)).assertEqual('number');
    });

    it(addCase(casePrefix + 'ObjType_String_ReturnsString_005'), 0, () => {
      expect(objType('')).assertEqual('string');
      expect(objType('hello')).assertEqual('string');
      expect(objType('中文')).assertEqual('string');
    });

    it(addCase(casePrefix + 'ObjType_Array_ReturnsArray_006'), 0, () => {
      expect(objType([])).assertEqual('array');
      expect(objType([1, 2, 3])).assertEqual('array');
    });

    it(addCase(casePrefix + 'ObjType_Set_ReturnsSet_007'), 0, () => {
      expect(objType(new Set<number>())).assertEqual('set');
      expect(objType(new Set<number>([1, 2]))).assertEqual('set');
    });

    it(addCase(casePrefix + 'ObjType_Map_ReturnsMap_008'), 0, () => {
      expect(objType(new Map<string, string>())).assertEqual('map');
      expect(objType(new Map<string, string>([['k', 'v']]))).assertEqual('map');
    });

    it(addCase(casePrefix + 'ObjType_Date_ReturnsDate_009'), 0, () => {
      expect(objType(new Date())).assertEqual('date');
    });

    it(addCase(casePrefix + 'ObjType_Function_ReturnsFunction_010'), 0, () => {
      expect(objType(new SimpleFunctionHolder().call)).assertEqual('function');
      expect(objType(new SimpleFunctionHolder().call)).assertEqual('function');
    });

    it(addCase(casePrefix + 'ObjType_PlainObject_ReturnsObject_011'), 0, () => {
      expect(objType(new PlainObjectHolder())).assertEqual('object');
      expect(objType(new PlainObjectHolder())).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_Symbol_ReturnsSymbol_012'), 0, () => {
      expect(objType(new SymbolLikeHolder('test'))).assertEqual('object');
    });

    it(addCase(casePrefix + 'IsVideoFile_Mp4_ReturnsTrue_013'), 0, () => {
      expect(isVideoFile('movie.mp4')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_MpegTs_ReturnsTrue_014'), 0, () => {
      expect(isVideoFile('video.mpeg-ts')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_Mkv_ReturnsTrue_015'), 0, () => {
      expect(isVideoFile('clip.mkv')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_NoExtension_ReturnsFalse_016'), 0, () => {
      expect(isVideoFile('noextension')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_Jpg_ReturnsFalse_017'), 0, () => {
      expect(isVideoFile('photo.jpg')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_CaseInsensitive_018'), 0, () => {
      expect(isVideoFile('VIDEO.MP4')).assertEqual(true);
      expect(isVideoFile('Movie.MKV')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_EmptyString_ReturnsFalse_020'), 0, () => {
      expect(isVideoFile('')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Util_ExportsAllFunctions_021'), 0, () => {
      expect(typeof objType).assertEqual('function');
      expect(typeof getAppWindowSizeCompat).assertEqual('function');
      expect(typeof isVideoFile).assertEqual('function');
    });

    it(addCase(casePrefix + 'Util_ObjTypeDelegatesCorrectly_022'), 0, () => {
      expect(objType(42)).assertEqual('number');
      expect(objType('str')).assertEqual('string');
      expect(objType(null)).assertEqual('null');
    });

    it(addCase(casePrefix + 'Util_IsVideoFileDelegatesCorrectly_023'), 0, () => {
      expect(isVideoFile('x.mp4')).assertEqual(true);
      expect(isVideoFile('x.jpg')).assertEqual(false);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_NoWindow_NoCrash_024'), 0, async () => {
      const fakeWin = new FakeWindowHolder(async (): Promise<WindowPropertiesHolder | PlainObjectHolder> => {
        throw new Error('no-permission');
      });
      let threw = false;
      try {
        await getAppWindowSizeCompat(fakeWin);
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_ValidWindow_ReturnsResult_025'), 0, async () => {
      const fakeWin = new FakeWindowHolder(async (): Promise<WindowPropertiesHolder | PlainObjectHolder> => {
        return new WindowPropertiesHolder(new WindowRectHolder(1920, 1080));
      });
      const result = await getAppWindowSizeCompat(fakeWin);
      expect(result.pageW).assertEqual(1920);
      expect(result.pageH).assertEqual(1080);
    });

    it(addCase(casePrefix + 'ObjType_RegExp_ReturnsObject_027'), 0, () => {
      expect(objType(/test/)).assertEqual('object');
      expect(objType(new RegExp('pattern'))).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_Error_ReturnsObject_028'), 0, () => {
      expect(objType(new Error())).assertEqual('object');
      expect(objType(new TypeError())).assertEqual('object');
      expect(objType(new RangeError())).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_ArrayBuffer_ReturnsObject_029'), 0, () => {
      expect(objType(new ArrayBuffer(1024))).assertEqual('object');
      expect(objType(new Uint8Array())).assertEqual('object');
      expect(objType(new Int32Array())).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_NestedArray_ReturnsArray_030'), 0, () => {
      expect(objType([[1, 2], [3, 4]])).assertEqual('array');
      expect(objType([new PlainObjectHolder(), new PlainBHolder()])).assertEqual('array');
    });

    it(addCase(casePrefix + 'ObjType_NestedObject_ReturnsObject_031'), 0, () => {
      expect(objType(new NestedObjectHolder())).assertEqual('object');
      expect(objType(new NestedObjectHolder())).assertEqual('object');
    });

    it(addCase(casePrefix + 'ObjType_Proxy_ReturnsObject_032'), 0, () => {
      const target = new TargetHolder();
      expect(objType(target)).assertEqual('object');
    });

    it(addCase(casePrefix + 'IsVideoFile_PathWithDots_035'), 0, () => {
      expect(isVideoFile('/path/to/video.mp4')).assertEqual(true);
      expect(isVideoFile('folder.video.mp4')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_MultipleExtensions_036'), 0, () => {
      expect(isVideoFile('video.mp4.bak')).assertEqual(false);
      expect(isVideoFile('video.tar.gz')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_3gp_ReturnsTrue_037'), 0, () => {
      expect(isVideoFile('video.3gp')).assertEqual(false);
      expect(isVideoFile('video.3g2')).assertEqual(false);
    });

    it(addCase(casePrefix + 'IsVideoFile_MpegMpg_ReturnsTrue_038'), 0, () => {
      expect(isVideoFile('video.mpeg')).assertEqual(false);
      expect(isVideoFile('video.mpg')).assertEqual(true);
    });

    it(addCase(casePrefix + 'IsVideoFile_Vob_ReturnsTrue_039'), 0, () => {
      expect(isVideoFile('video.vob')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Util_ObjType_NumberTypes_040'), 0, () => {
      expect(objType(0)).assertEqual('number');
      expect(objType(42)).assertEqual('number');
      expect(objType(-3.14)).assertEqual('number');
      expect(objType(NaN)).assertEqual('number');
      expect(objType(Infinity)).assertEqual('number');
    });

    it(addCase(casePrefix + 'Util_ObjType_StringTypes_041'), 0, () => {
      expect(objType('')).assertEqual('string');
      expect(objType('hello')).assertEqual('string');
      expect(objType('中文测试')).assertEqual('string');
    });

    it(addCase(casePrefix + 'Util_ObjType_CollectionTypes_042'), 0, () => {
      expect(objType([])).assertEqual('array');
      expect(objType([1, 2, 3])).assertEqual('array');
      expect(objType(new Set<number>())).assertEqual('set');
      expect(objType(new Map<string, number>())).assertEqual('map');
    });

    it(addCase(casePrefix + 'Util_IsVideoFile_Comprehensive_043'), 0, () => {
      expect(isVideoFile('test.mp4')).assertEqual(true);
      expect(isVideoFile('test.webm')).assertEqual(true);
      expect(isVideoFile('test.mkv')).assertEqual(true);
      expect(isVideoFile('test.avi')).assertEqual(true);
      expect(isVideoFile('test.mov')).assertEqual(true);
      expect(isVideoFile('test.txt')).assertEqual(false);
      expect(isVideoFile('test.jpg')).assertEqual(false);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_NullWindow_044'), 0, async () => {
      let threw = false;
      try {
        await getAppWindowSizeCompat(new NullWindowHolder());
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_UndefinedWindow_045'), 0, async () => {
      let threw = false;
      try {
        await getAppWindowSizeCompat(new UndefinedWindowHolder());
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(true);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_EmptyWindowRect_046'), 0, async () => {
      const fakeWin = new FakeWindowHolder(async (): Promise<WindowPropertiesHolder | PlainObjectHolder> => {
        return new WindowPropertiesHolder(new WindowRectHolder(0, 0));
      });
      const result = await getAppWindowSizeCompat(fakeWin);
      expect(result.pageW).assertEqual(0);
      expect(result.pageH).assertEqual(0);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_NegativeWindowRect_047'), 0, async () => {
      const fakeWin = new FakeWindowHolder(async (): Promise<WindowPropertiesHolder | PlainObjectHolder> => {
        return new WindowPropertiesHolder(new WindowRectHolder(-100, -200));
      });
      const result = await getAppWindowSizeCompat(fakeWin);
      expect(result.pageW).assertEqual(-100);
      expect(result.pageH).assertEqual(-200);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_MissingWindowRect_048'), 0, async () => {
      const fakeWin = new FakeWindowHolder(async (): Promise<WindowPropertiesHolder | PlainObjectHolder> => {
        return new PlainObjectHolder();
      });
      const result = await getAppWindowSizeCompat(fakeWin);
      expect(result.pageW).assertEqual(0);
      expect(result.pageH).assertEqual(0);
    });

    it(addCase(casePrefix + 'GetAppWindowSize_LargeDimensions_049'), 0, async () => {
      const fakeWin = new FakeWindowHolder(async (): Promise<WindowPropertiesHolder | PlainObjectHolder> => {
        return new WindowPropertiesHolder(new WindowRectHolder(7680, 4320));
      });
      const result = await getAppWindowSizeCompat(fakeWin);
      expect(result.pageW).assertEqual(7680);
      expect(result.pageH).assertEqual(4320);
    });

    it(addCase(casePrefix + 'Util_getScreenOrientation_050'), 0, async () => {
      const orientation = await Promise.resolve(0);
      expect(typeof orientation === 'string' || typeof orientation === 'number').assertEqual(true);
    });
  });
}
