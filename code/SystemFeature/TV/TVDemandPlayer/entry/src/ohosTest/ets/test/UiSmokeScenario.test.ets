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

/**
 * UI冒烟场景测试合并文件
 *
 * 业务背景：建立 UI smoke 的页面契约清单，验证"入口-页面-标题/模块提示"的回归框架。
 * 本文件汇聚了首页导航、页面hint验证、路径可达性、DLNA特殊返回等场景。
 */

interface UiSmokeScenario {
  name: string;
  entry: string;
  targetPage: string;
  hints: Array<string>;
}

interface UiPathScenario {
  name: string;
  path: Array<string>;
  finalPage: string;
  requiredHints: Array<string>;
}

function buildSmokeScenarios(): Array<UiSmokeScenario> {
  return [
    {
      name: 'HomeToHttpList',
      entry: '网络视频',
      targetPage: 'pages/HttpVideoList',
      hints: ['网络点播', '暂无网络视频']
    },
    {
      name: 'HomeToLocalFolder',
      entry: '本地视频',
      targetPage: 'pages/LocalFolderList',
      hints: ['本地点播', '本地视频']
    },
    {
      name: 'HttpListToPlayer',
      entry: '网络点播项',
      targetPage: 'pages/VideoPlayer',
      hints: ['视频播放器', '视频设置']
    },
    {
      name: 'LocalFolderToVideoList',
      entry: '本地文件夹',
      targetPage: 'pages/LocalVideoList',
      hints: ['视频列表']
    },
    {
      name: 'DlnaAbilityToDlnaPlayer',
      entry: 'DLNA',
      targetPage: 'pages/DlnaPlayer',
      hints: ['播放', '暂停']
    }
  ];
}

function buildUiPathScenarios(): Array<UiPathScenario> {
  return [
    {
      name: 'HomeHttpPlayerPath',
      path: ['首页', '网络视频', '网络列表', '播放器'],
      finalPage: 'pages/VideoPlayer',
      requiredHints: ['视频播放器', '视频设置']
    },
    {
      name: 'HomeLocalFolderVideoListPath',
      path: ['首页', '本地视频', '本地目录', '本地列表'],
      finalPage: 'pages/LocalVideoList',
      requiredHints: ['视频列表']
    },
    {
      name: 'HomeDlnaAbilityPath',
      path: ['DLNA拉起', 'DlnaPlayer'],
      finalPage: 'pages/DlnaPlayer',
      requiredHints: ['播放', '暂停']
    }
  ];
}

function hasAnyHint(actualTexts: Array<string>, hints: Array<string>): boolean {
  for (let i = 0; i < hints.length; i++) {
    if (actualTexts.includes(hints[i])) {
      return true;
    }
  }
  return false;
}

function shouldReturnHomeAfterBack(fromPage: string): boolean {
  return fromPage !== 'pages/DlnaPlayer';
}

function pathCanReachPage(path: Array<string>, finalPage: string): boolean {
  if (path.length === 0) {
    return false;
  }
  if (finalPage === 'pages/VideoPlayer') {
    return path.includes('播放器');
  }
  if (finalPage === 'pages/LocalVideoList') {
    return path.includes('本地列表');
  }
  if (finalPage === 'pages/DlnaPlayer') {
    return path.includes('DlnaPlayer');
  }
  return false;
}

function uiPathHasHints(actualHints: Array<string>, requiredHints: Array<string>): boolean {
  for (let i = 0; i < requiredHints.length; i++) {
    if (!actualHints.includes(requiredHints[i])) {
      return false;
    }
  }
  return true;
}

export default function UiSmokeScenarioTest() {
  const casePrefix = 'DemandPlayer_UiSmokeScenario_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  /**
   * ========== 第一部分：场景目录与Hint验证 ==========
   */
  describe('UiSmokeScenario_ScenarioCatalogRules', () => {
    it(addCase(casePrefix + 'ScenarioCatalog_Coverage_001'), 0, () => {
      const scenarios = buildSmokeScenarios();
      expect(scenarios.length).assertEqual(5);
      expect(scenarios[0].targetPage).assertEqual('pages/HttpVideoList');
      expect(scenarios[4].targetPage).assertEqual('pages/DlnaPlayer');
    });

    it(addCase(casePrefix + 'HttpList_HintsExist_002'), 0, () => {
      const texts = ['网络点播', '暂无网络视频', '图片加载中...'];
      const scenarios = buildSmokeScenarios();
      expect(hasAnyHint(texts, scenarios[0].hints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'LocalFolder_HintsExist_003'), 0, () => {
      const texts = ['本地点播', '共3条视频'];
      const scenarios = buildSmokeScenarios();
      expect(hasAnyHint(texts, scenarios[1].hints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Player_HintsExist_004'), 0, () => {
      const texts = ['视频播放器', '字幕', '视频设置'];
      const scenarios = buildSmokeScenarios();
      expect(hasAnyHint(texts, scenarios[2].hints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'LocalVideoList_HintsExist_005'), 0, () => {
      const texts = ['视频列表', 'movie-a.mp4'];
      const scenarios = buildSmokeScenarios();
      expect(hasAnyHint(texts, scenarios[3].hints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'DlnaPlayer_HintsExist_006'), 0, () => {
      const texts = ['播放', '暂停', '00:15'];
      const scenarios = buildSmokeScenarios();
      expect(hasAnyHint(texts, scenarios[4].hints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'BackNavigation_NormalPagesReturnHome_007'), 0, () => {
      expect(shouldReturnHomeAfterBack('pages/HttpVideoList')).assertEqual(true);
      expect(shouldReturnHomeAfterBack('pages/LocalFolderList')).assertEqual(true);
    });

    it(addCase(casePrefix + 'BackNavigation_DlnaSpecialCase_008'), 0, () => {
      expect(shouldReturnHomeAfterBack('pages/DlnaPlayer')).assertEqual(false);
    });

    /**
     * ========== 第二部分：路径可达性与Hint完整性 ==========
     */
    it(addCase(casePrefix + 'ScenarioCatalog_PathCount_009'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(scenarios.length).assertEqual(3);
      expect(scenarios[0].finalPage).assertEqual('pages/VideoPlayer');
      expect(scenarios[1].finalPage).assertEqual('pages/LocalVideoList');
    });

    it(addCase(casePrefix + 'PathReach_Player_010'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(pathCanReachPage(scenarios[0].path, scenarios[0].finalPage)).assertEqual(true);
    });

    it(addCase(casePrefix + 'PathReach_LocalVideoList_011'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(pathCanReachPage(scenarios[1].path, scenarios[1].finalPage)).assertEqual(true);
    });

    it(addCase(casePrefix + 'PathReach_DlnaPlayer_012'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(pathCanReachPage(scenarios[2].path, scenarios[2].finalPage)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Hints_PlayerPage_013'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(uiPathHasHints(['视频播放器', '视频设置', '字幕'], scenarios[0].requiredHints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Hints_LocalListPage_014'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(uiPathHasHints(['视频列表', 'movie.mp4'], scenarios[1].requiredHints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Hints_DlnaPage_015'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(uiPathHasHints(['播放', '暂停', '00:00'], scenarios[2].requiredHints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'PathReject_UnknownPage_016'), 0, () => {
      expect(pathCanReachPage(['首页', '网络视频'], 'pages/Unknown')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Scenario_HomeToLocalFolder_NavigationPath_019'), 0, () => {
      const scenarios = buildSmokeScenarios();
      const localScenario = scenarios[1];
      expect(localScenario.entry).assertEqual('本地视频');
      expect(localScenario.targetPage).assertEqual('pages/LocalFolderList');
    });

    it(addCase(casePrefix + 'Scenario_HttpListToPlayer_HintsValidation_020'), 0, () => {
      const scenarios = buildSmokeScenarios();
      const playerScenario = scenarios[2];
      const texts = ['视频播放器', '视频设置'];
      expect(hasAnyHint(texts, playerScenario.hints)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Scenario_LocalFolderToVideoList_PathExists_021'), 0, () => {
      const scenarios = buildSmokeScenarios();
      const localListScenario = scenarios[3];
      expect(localListScenario.targetPage).assertEqual('pages/LocalVideoList');
    });

    it(addCase(casePrefix + 'Scenario_DlnaAbilityToDlnaPlayer_EntryCorrect_022'), 0, () => {
      const scenarios = buildSmokeScenarios();
      const dlnaScenario = scenarios[4];
      expect(dlnaScenario.entry).assertEqual('DLNA');
      expect(dlnaScenario.targetPage).assertEqual('pages/DlnaPlayer');
    });

    it(addCase(casePrefix + 'Path_HomeHttpPlayerPath_AllStepsExist_023'), 0, () => {
      const scenarios = buildUiPathScenarios();
      const path = scenarios[0].path;
      expect(path.includes('首页')).assertEqual(true);
      expect(path.includes('网络视频')).assertEqual(true);
      expect(path.includes('播放器')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Path_HomeLocalFolderVideoListPath_AllStepsExist_024'), 0, () => {
      const scenarios = buildUiPathScenarios();
      const path = scenarios[1].path;
      expect(path.includes('首页')).assertEqual(true);
      expect(path.includes('本地视频')).assertEqual(true);
      expect(path.includes('本地列表')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Path_HomeDlnaAbilityPath_SpecialEntry_025'), 0, () => {
      const scenarios = buildUiPathScenarios();
      const path = scenarios[2].path;
      expect(path.includes('DLNA拉起')).assertEqual(true);
      expect(path.includes('DlnaPlayer')).assertEqual(true);
    });

    it(addCase(casePrefix + 'BackNavigation_DlnaDoesNotReturnHome_026'), 0, () => {
      expect(shouldReturnHomeAfterBack('pages/DlnaPlayer')).assertEqual(false);
    });

    it(addCase(casePrefix + 'BackNavigation_HttpListReturnsHome_027'), 0, () => {
      expect(shouldReturnHomeAfterBack('pages/HttpVideoList')).assertEqual(true);
    });

    it(addCase(casePrefix + 'BackNavigation_LocalFolderListReturnsHome_028'), 0, () => {
      expect(shouldReturnHomeAfterBack('pages/LocalFolderList')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Hints_PlayerPage_CompleteHints_029'), 0, () => {
      const hints = ['视频播放器', '视频设置', '字幕', '清晰度'];
      const required = ['视频播放器', '视频设置'];
      expect(uiPathHasHints(hints, required)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Hints_PlayerPage_MissingRequiredHint_030'), 0, () => {
      const hints = ['视频播放器'];
      const required = ['视频播放器', '视频设置'];
      expect(uiPathHasHints(hints, required)).assertEqual(false);
    });

    it(addCase(casePrefix + 'Hints_LocalListPage_CompleteHints_031'), 0, () => {
      const hints = ['视频列表', 'movie.mp4', 'movie2.mp4'];
      const required = ['视频列表'];
      expect(uiPathHasHints(hints, required)).assertEqual(true);
    });

    it(addCase(casePrefix + 'Hints_DlnaPage_AllHintsPresent_032'), 0, () => {
      const hints = ['播放', '暂停', '00:00', '进度条'];
      const required = ['播放', '暂停'];
      expect(uiPathHasHints(hints, required)).assertEqual(true);
    });

    it(addCase(casePrefix + 'PathReach_EmptyPath_ReturnsFalse_033'), 0, () => {
      expect(pathCanReachPage([], 'pages/VideoPlayer')).assertEqual(false);
    });

    it(addCase(casePrefix + 'PathReach_UnknownFinalPage_ReturnsFalse_034'), 0, () => {
      expect(pathCanReachPage(['首页', '网络视频'], 'pages/UnknownPage')).assertEqual(false);
    });

    it(addCase(casePrefix + 'PathReach_LocalVideoList_WithCorrectPath_035'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(pathCanReachPage(scenarios[1].path, scenarios[1].finalPage)).assertEqual(true);
    });

    it(addCase(casePrefix + 'PathReach_DlnaPlayer_WithCorrectPath_036'), 0, () => {
      const scenarios = buildUiPathScenarios();
      expect(pathCanReachPage(scenarios[2].path, scenarios[2].finalPage)).assertEqual(true);
    });

    it(addCase(casePrefix + 'ScenarioCatalog_AllNamesUnique_037'), 0, () => {
      const scenarios = buildSmokeScenarios();
      const names = scenarios.map(s => s.name);
      const uniqueNames = new Set(names);
      expect(uniqueNames.size).assertEqual(names.length);
    });

    it(addCase(casePrefix + 'ScenarioCatalog_AllPathsUnique_038'), 0, () => {
      const scenarios = buildUiPathScenarios();
      const paths = scenarios.map(s => JSON.stringify(s.path));
      const uniquePaths = new Set(paths);
      expect(uniquePaths.size).assertEqual(paths.length);
    });

    it(addCase(casePrefix + 'HasAnyHint_EmptyHints_ReturnsFalse_039'), 0, () => {
      const texts = ['网络点播', '暂无网络视频'];
      expect(hasAnyHint(texts, [])).assertEqual(false);
    });

    it(addCase(casePrefix + 'HasAnyHint_NoMatch_ReturnsFalse_040'), 0, () => {
      const texts = ['首页', '导航'];
      const hints = ['视频播放器', '视频设置'];
      expect(hasAnyHint(texts, hints)).assertEqual(false);
    });

    it(addCase(casePrefix + 'HasAnyHint_PartialMatch_ReturnsTrue_041'), 0, () => {
      const texts = ['网络点播', '首页'];
      const hints = ['网络点播', '本地点播'];
      expect(hasAnyHint(texts, hints)).assertEqual(true);
    });
  });
}
