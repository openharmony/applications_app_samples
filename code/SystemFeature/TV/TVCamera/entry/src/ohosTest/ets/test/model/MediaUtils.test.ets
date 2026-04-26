/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     `http://www.apache.org/licenses/LICENSE-2.0`
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeEach, afterEach, it, expect } from '@ohos/hypium';
import MediaUtils from '../../../../main/ets/model/MediaUtils';
import { Constants } from '../../../../main/ets/common/Constants';

interface MediaInfoResult {
  prefix: string;
  suffix: string;
}

interface MediaUriResult {
  uri: string;
}

interface PhotoFormatCase {
  format: number;
  expectedSuffix: string;
}

class EmptyFileAsset {
}

class PseudoFileAsset {
  open(): number {
    return 9;
  }
}

/**
 * 功能描述：更新拍照格式并复用真实单例实例。
 * 参数说明：`mediaUtils` 为待测单例；`photoFormat` 为拍照格式枚举。
 * 返回值：void，用于统一所有格式映射测试的状态准备。
 */
function setPhotoFormat(mediaUtils: MediaUtils, photoFormat: number): void {
  mediaUtils.updatePhotoFormat(photoFormat);
}

/**
 * 功能描述：断言媒体前后缀契约是否匹配。
 * 参数说明：`info` 为 `getInfoFromType` 返回值；`prefix` 与 `suffix` 为期望契约。
 * 返回值：void，用于在多组格式矩阵中复用同一组高价值断言。
 */
function expectInfo(info: MediaInfoResult, prefix: string, suffix: string): void {
  expect(info.prefix).assertEqual(prefix);
  expect(info.suffix).assertEqual(suffix);
}

/**
 * 功能描述：断言 URI 结构匹配目录、文件名前缀与后缀。
 * 参数说明：`uri` 为输出路径；`prefix` 和 `suffix` 为期望文件名边界。
 * 返回值：void，用于替代时间桩，验证稳定命名结构。
 */
function expectUriPattern(uri: string, prefix: string, suffix: string): void {
  const basePath = 'file:///data/storage/el2/base/haps/entry/files/';
  expect(uri.indexOf(basePath)).assertEqual(0);
  let fileName = uri.substring(basePath.length);
  if (prefix.length > 0) {
    expect(fileName.indexOf(prefix)).assertEqual(0);
  }
  if (suffix.length > 0) {
    expect(fileName.lastIndexOf(suffix)).assertEqual(fileName.length - suffix.length);
  }
}

/**
 * 功能描述：注册 MediaUtils 主测试集合。
 * 参数说明：无。
 * 返回值：void，用于向 Hypium 挂载媒体命名与 URI 契约测试。
 */
export default function MediaUtilsTest(): void {
  describe('MediaUtilsTest', () => {
    let util: MediaUtils;

    beforeEach(() => {
      // 业务背景：MediaUtils 是拍照与录像输出路径的统一入口。
      // 每次用单例入口取实例并复位格式，才能覆盖真实业务访问路径。
      util = MediaUtils.getInstance();
      setPhotoFormat(util, 1);
    });

    afterEach(() => {
      // 业务背景：每次用例结束后恢复默认图片格式，避免格式状态在用例间串扰。
      setPhotoFormat(util, 1);
    });

    it('MediaUtils_GetInstance_ReturnsSingleton_001', 0, () => {
      // 业务背景：保存路径与照片格式在多个页面之间共享。
      // 一旦单例失效，不同页面会使用不同 photoFormat，最终写出错误后缀。
      expect(MediaUtils.getInstance() === MediaUtils.getInstance()).assertTrue();
    });

    it('MediaUtils_OnChangePhotoFormat_FullMatrix_002', 0, () => {
      // 业务背景：格式映射一旦偏移，就会导致图片已保存但图库识别失败。
      // 这里用完整矩阵而不是只测默认值，防止后续枚举插入时映射被整体错位。
      let cases: PhotoFormatCase[] = [
        { format: 0, expectedSuffix: 'png' },
        { format: 1, expectedSuffix: 'jpg' },
        { format: 2, expectedSuffix: 'bmp' },
        { format: 3, expectedSuffix: 'webp' },
        { format: 4, expectedSuffix: 'jpeg' }
      ];

      for (let index = 0; index < cases.length; index++) {
        let currentCase = cases[index];
        setPhotoFormat(util, currentCase.format);
        expect(util.onChangePhotoFormat()).assertEqual(currentCase.expectedSuffix);
      }
    });

    it('MediaUtils_OnChangePhotoFormat_InvalidValuesFallbackToJpg_003', 0, () => {
      // 业务背景：设置来源可能被旧版本配置、异常同步或脏数据污染。
      // 默认回退到 jpg 可以保障主链路可用，比直接抛错更符合媒体保存容错需求。
      let invalidFormats: number[] = [-1, 5, 99, 9999];

      for (let index = 0; index < invalidFormats.length; index++) {
        setPhotoFormat(util, invalidFormats[index]);
        expect(util.onChangePhotoFormat()).assertEqual('jpg');
      }
    });

    it('MediaUtils_OnChangePhotoFormat_LastWriteWins_004', 0, () => {
      // 业务背景：设置页可能连续切换格式，保存逻辑必须读取最后一次选择。
      // 这条用例验证状态没有被中间值缓存，避免 UI 展示与真实保存格式不一致。
      setPhotoFormat(util, 0);
      setPhotoFormat(util, 4);
      setPhotoFormat(util, 2);
      expect(util.onChangePhotoFormat()).assertEqual('bmp');
    });

    it('MediaUtils_GetInfoFromType_ImageReflectsCurrentFormat_005', 0, () => {
      // 业务背景：图片命名逻辑依赖当前 photoFormat，而不是写死后缀。
      // 如果 `getInfoFromType` 和设置状态脱钩，后续文件扩展名会与用户选择不一致。
      setPhotoFormat(util, 3);
      let info: MediaInfoResult = util.getInfoFromType(Constants.IMAGE) as MediaInfoResult;
      expectInfo(info, 'IMG_', '.webp');
    });

    it('MediaUtils_GetInfoFromType_VideoAlwaysUsesMp4_006', 0, () => {
      // 业务背景：视频编码链路当前只承诺 mp4，不能被拍照格式设置串改。
      // 这里先把 photoFormat 改成图片场景值，再验证视频契约稳定不受影响。
      setPhotoFormat(util, 0);
      let info: MediaInfoResult = util.getInfoFromType(Constants.VIDEO) as MediaInfoResult;
      expectInfo(info, 'VID_', '.mp4');
    });

    it('MediaUtils_GetInfoFromType_UnknownTypeReturnsEmptyContract_007', 0, () => {
      // 业务背景：非法媒体类型如果拼接出伪路径，问题会在更深层的媒体库中才暴露。
      // 提前返回空契约能够让调用方在边界处发现问题，而不是把错误文件写入磁盘。
      let info: MediaInfoResult = util.getInfoFromType(-100) as MediaInfoResult;
      expectInfo(info, '', '');
    });

    it('MediaUtils_GetInfoFromType_ReturnsFreshObjects_008', 0, () => {
      // 业务背景：调用方可能会修改返回对象做二次拼接，返回共享对象会污染后续保存流程。
      // 这里验证每次都是独立快照，避免不同保存任务互相覆盖 prefix 或 suffix。
      setPhotoFormat(util, 1);
      let firstInfo: MediaInfoResult = util.getInfoFromType(Constants.IMAGE) as MediaInfoResult;
      firstInfo.prefix = 'BROKEN_';
      firstInfo.suffix = '.bad';

      let secondInfo: MediaInfoResult = util.getInfoFromType(Constants.IMAGE) as MediaInfoResult;
      expectInfo(secondInfo, 'IMG_', '.jpg');
    });

    it('MediaUtils_CreateAndGetUri_ImageUsesExpectedPattern_009', 0, async () => {
      // 业务背景：图片 URI 至少要满足固定目录、IMG_ 前缀和格式后缀约束。
      // 不依赖时间桩可规避 ArkTS 对原型改写限制，同时保留关键命名契约覆盖。
      setPhotoFormat(util, 4);
      let uriResult: MediaUriResult = await util.createAndGetUri(Constants.IMAGE) as MediaUriResult;
      expectUriPattern(uriResult.uri, 'IMG_', '.jpeg');
    });

    it('MediaUtils_CreateAndGetUri_VideoUsesExpectedPattern_010', 0, async () => {
      // 业务背景：视频 URI 必须保留 VID_ 前缀与 mp4 后缀，确保媒体扫描和上传规则稳定。
      // 这里显式验证视频规则不受图片格式配置影响。
      setPhotoFormat(util, 2);
      let uriResult: MediaUriResult = await util.createAndGetUri(Constants.VIDEO) as MediaUriResult;
      expectUriPattern(uriResult.uri, 'VID_', '.mp4');
    });

    it('MediaUtils_CreateAndGetUri_UnknownTypeStillBuildsReachablePath_011', 0, async () => {
      // 业务背景：当前实现对未知类型不会抛错，而是生成无前后缀的基础文件名。
      // 这属于“现状契约”，必须被测试固化，否则未来调用方会在行为变化时无感知回归。
      let uriResult: MediaUriResult = await util.createAndGetUri(-1) as MediaUriResult;
      const basePath = 'file:///data/storage/el2/base/haps/entry/files/';
      expect(uriResult.uri.indexOf(basePath)).assertEqual(0);
      let fileName = uriResult.uri.substring(basePath.length);
      expect(fileName.indexOf('IMG_')).assertEqual(-1);
      expect(fileName.indexOf('VID_')).assertEqual(-1);
    });

    it('MediaUtils_CreateAndGetUri_ReflectsLatestFormatAtInvocationTime_012', 0, async () => {
      // 业务背景：设置页和拍照页之间可能存在时序交错，最终写出的后缀必须遵从最新状态。
      // 这里先写入旧值再覆盖成新值，验证 URI 读取的是调用瞬间格式而不是历史缓存。
      setPhotoFormat(util, 0);
      setPhotoFormat(util, 3);
      let uriResult: MediaUriResult = await util.createAndGetUri(Constants.IMAGE) as MediaUriResult;
      expectUriPattern(uriResult.uri, 'IMG_', '.webp');
    });

    it('MediaUtils_CreateAndGetUri_ResultStartsWithApplicationFilesPath_013', 0, async () => {
      // 业务背景：媒体输出目录固定在应用 files 目录下，上层清理与扫描逻辑依赖这个前提。
      // 这里不绑定具体时间，而是锁定目录前缀，防止重构后路径跑到不可访问目录。
      let uriResult: MediaUriResult = await util.createAndGetUri(Constants.IMAGE) as MediaUriResult;
      expect(uriResult.uri.indexOf('file:///data/storage/el2/base/haps/entry/files/')).assertEqual(0);
    });

    it('MediaUtils_CreateAndGetUri_ImageMatchesPatternAcrossFormats_014', 0, async () => {
      // 业务背景：不同图片格式都应共享同一套时间命名策略，仅后缀变化。
      // 用多格式矩阵覆盖可以同时发现前缀丢失、分隔符错误和后缀漂移等问题。
      let formats: PhotoFormatCase[] = [
        { format: 0, expectedSuffix: 'png' },
        { format: 1, expectedSuffix: 'jpg' },
        { format: 2, expectedSuffix: 'bmp' },
        { format: 3, expectedSuffix: 'webp' },
        { format: 4, expectedSuffix: 'jpeg' }
      ];

      for (let index = 0; index < formats.length; index++) {
        let currentCase = formats[index];
        setPhotoFormat(util, currentCase.format);
        let uriResult: MediaUriResult = await util.createAndGetUri(Constants.IMAGE) as MediaUriResult;
        expectUriPattern(uriResult.uri, 'IMG_', `.${currentCase.expectedSuffix}`);
      }
    });

    it('MediaUtils_GetFdPath_ReturnsPlaceholderForEmptyAsset_015', 0, async () => {
      // 业务背景：当前 fd 获取链路尚未接入真实文件服务，但调用方已经依赖返回值存在。
      // 测试现状占位契约，可以在未来替换真实实现时明确触发对应回归修改。
      expect(await util.getFdPath(new EmptyFileAsset())).assertEqual(1);
    });

    it('MediaUtils_GetFdPath_IgnoresAssetShape_016', 0, async () => {
      // 业务背景：在未接入真实 FileAsset 前，接口不应因为传入对象形态不同而出现额外分支。
      // 这能防止调用方在测试环境用 mock 对象时遭遇与生产实现无关的失败。
      let pseudoFileAsset = new PseudoFileAsset();
      expect(await util.getFdPath(pseudoFileAsset as object)).assertEqual(1);
    });

    it('MediaUtils_GetInfoFromType_ImageSuffixTracksRepeatedTransitions_017', 0, () => {
      // 业务背景：相机设置经常在多个分辨率和格式组合间快速切换。
      // 连续跳转覆盖比单点断言更容易发现状态机残留或错误缓存问题。
      let transitions: PhotoFormatCase[] = [
        { format: 1, expectedSuffix: '.jpg' },
        { format: 4, expectedSuffix: '.jpeg' },
        { format: 0, expectedSuffix: '.png' },
        { format: 3, expectedSuffix: '.webp' }
      ];

      for (let index = 0; index < transitions.length; index++) {
        let currentCase = transitions[index];
        setPhotoFormat(util, currentCase.format);
        let info: MediaInfoResult = util.getInfoFromType(Constants.IMAGE) as MediaInfoResult;
        expectInfo(info, 'IMG_', currentCase.expectedSuffix);
      }
    });

    it('MediaUtils_GetInfoFromType_VideoIsStableAcrossPhotoFormatChanges_018', 0, () => {
      // 业务背景：图片配置与录像配置经常共存于同一设置页，必须避免跨域污染。
      // 通过在多次格式切换后重复读取视频信息，可以验证视频后缀完全独立。
      let formats: number[] = [0, 1, 2, 3, 4, 88];

      for (let index = 0; index < formats.length; index++) {
        setPhotoFormat(util, formats[index]);
        let info: MediaInfoResult = util.getInfoFromType(Constants.VIDEO) as MediaInfoResult;
        expectInfo(info, 'VID_', '.mp4');
      }
    });
  });
}
