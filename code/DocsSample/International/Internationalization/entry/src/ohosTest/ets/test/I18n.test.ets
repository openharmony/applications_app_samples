/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { describe, expect, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, MatchPattern, ON } from '@kit.TestKit';
import hilog from '@ohos.hilog';
import { resourceToString } from '../../../main/ets/component/ResourceToString';
import { application } from '@kit.AbilityKit';

const BUNDLE = 'I18nTest_';
const TAG: string = '[Sample_Internationalization]';
const DOMAIN = 0xF811;
const DELAY_TIME = 500;
const DELAY_TIME_LONG = 3000;
const SCROLL_SPEED = 3000;
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver = Driver.create();

async function checkAndClickByText(text: string) {
  await driver.assertComponentExist(ON.text(text, MatchPattern.CONTAINS));
  let component = await driver.findComponent(ON.text(text));
  await component.click();
  await driver.delayMs(DELAY_TIME);
}

async function goBack() {
  await driver.assertComponentExist(ON.id('btnBack'));
  let backButton = await driver.findComponent(ON.id('btnBack'));
  await backButton.click();
  await driver.delayMs(DELAY_TIME);
}

async function scrollView(scrollId: string, textId: string, arr: string[]) {
  let scroll = await driver.findComponent(ON.id(scrollId));
  await driver.delayMs(DELAY_TIME);
  await scroll.scrollToBottom(SCROLL_SPEED);
  let text = await driver.findComponents(ON.id(textId));
  expect(text).not().assertNull();
  if (!Array.isArray(text)) {
    throw new Error('Expected an array of components, but received a different type');
  }
  expect(text.length).not().assertNull();
  for (let index = 0; index < Math.min(text.length, arr.length); index++) {
    const element = text[index];
    const actualText = await element.getText();
    expect(actualText.includes(arr[index].toString())).assertTrue();
  }
  await driver.delayMs(DELAY_TIME);
}

async function scrollOuterBottomView(scrollId: string) {
  let scroll = await driver.findComponent(ON.id(scrollId));
  await driver.delayMs(DELAY_TIME);
  await scroll.scrollToBottom(SCROLL_SPEED);
  await driver.delayMs(DELAY_TIME);
}

const expectedIdsText = ['America/Adak', 'Asia/Hovd', 'America/Sao_Paulo', 'Asia/Jerusalem', 'Europe/London'];
const expectedCityIdArrayText = ['Auckland', 'Magadan', 'Lord Howe Island'];
const expectedTimezoneListText = [resourceToString($r('app.string.Yerevan')), 'Asia/Yerevan', 'GMT4000000', 'Yerevan'];
const expectedTransIdsText = ['ASCII-Latin', 'Accents-Any'];
const LAST_INDEX = 23;

export default function abilityTest() {
  describe('I18nTestSuite', () => {
    /**
     * @tc.number LaunchIndexPage_001
     * @tc.name LaunchIndexPage_001
     * @tc.desc 启动应用
     */
    it(BUNDLE + 'LaunchIndexPage_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LaunchIndexPage_001, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await delegator.startAbility({
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(DELAY_TIME_LONG);
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.LanguagePreferenceSetting'), context)));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.NumberMeasurementFormatting'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.PhoneNumberFormatting'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.CalendarSetting'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.TimezoneDstSetting'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.MultilingualSorting'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.CharacterProcessing'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.NameLocalization'), context)));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'LaunchIndexPage_001, end');
    });

    /**
     * @tc.number I18nTestLanguagePreferenceSetting_002
     * @tc.name I18nTestLanguagePreferenceSetting_002
     * @tc.desc 设置语言与用户偏好
     */
    it(BUNDLE + 'LanguagePreferenceSetting_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguagePreferenceSetting_002, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.LanguagePreferenceSetting'), context));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfSetSystemLanguageAndRegion'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetSystemLanguage'), context)}zh-Hans --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetSystemRegion'), context)}CN --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetSystemLocale'), context)}zh-Hans-CN --passed`));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfSetPreferredLanguage'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetPreferredLanguage'), context)}zh-Hans --passed`));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfSetUserPreference'), context)));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguagePreferenceSetting_002, end');
    });

    /**
     * @tc.number I18nTestNumberMeasurementFormatting_003
     * @tc.name I18nTestNumberMeasurementFormatting_003
     * @tc.desc 数字与度量衡国际化
     */
    it(BUNDLE + 'NumberMeasurementFormatting_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NumberMeasurementFormatting_003, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.NumberMeasurementFormatting'), context));
      await scrollOuterBottomView('outerScrollInNumberMeasure');
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfMeasureTrans'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.MeasureTrans'), context)}236.588 L --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LongMeasureTrans'), context)}236.588 liters --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NumberMeasurementFormatting_003, end');
    });

    /**
     * @tc.number I18nTestPhoneNumberFormatting_004
     * @tc.name I18nTestPhoneNumberFormatting_004
     * @tc.desc 电话号码格式化
     */
    it(BUNDLE + 'PhoneNumberFormatting_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhoneNumberFormatting_004, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.PhoneNumberFormatting'), context));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfPhoneNumberFormat'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.PhoneNumberFormat'), context)}158 2312 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.RFC3966TypeNumberFormat'), context)}tel:+86-1582312 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.IsValidNumber'), context)}false --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CNLocationName'), context)} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.FormatResult'), context)}0755 453 --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhoneNumberFormatting_004, end');
    });

    /**
     * @tc.number I18nTestCalendarFormatting_005
     * @tc.name I18nTestCalendarFormatting_005
     * @tc.desc 设置日历和历法
     */
    it(BUNDLE + 'CalendarFormatting_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CalendarFormatting_005, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.CalendarSetting'), context));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfTheGregorianCalendar'), context)));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.TheGregorianCalendarSets'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.Timezone'), context)}Asia/Shanghai --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.FirstDayOfWeek'), context)}1 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.MinimalDaysInFirstWeek'), context)}1 --passed`));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.SetMinimalDaysInFirstWeek'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.YearOfTheFirstWeekIs3'), context)}2022 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LocalizedCalendarName'), context)}` +
          `${resourceToString($r('app.string.Calendar'), context)} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.IsWeekend'), context)}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DateAfterAddingDays'), context)}17 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DaysBetweenDates'), context)}-3 --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.LunarCalendar'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LunarYear'), context)}40 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LunarMonth'), context)}5 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.LunarDate'), context)}8 --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CalendarFormatting_005, end');
    });

    /**
     * @tc.number I18nTestTimezoneDstSetting_006
     * @tc.name I18nTestTimezoneDstSetting_006
     * @tc.desc 时区与夏令时国际化
     */
    it(BUNDLE + 'TimezoneDstSetting_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimezoneDstSetting_006, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.TimezoneDstSetting'), context));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfTimezoneFunction'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetAucklandID'), context)}Pacific/Auckland --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.TimeZoneLocalName'), context)}` +
        `${resourceToString($r('app.string.ExpectedTimeZone'), context)}`, MatchPattern.CONTAINS));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.AucklandDisplayName'), context)}` +
          `${resourceToString($r('app.string.ExpectedCityDisplayName'), context)} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetRawOffset'), context)}-10800000 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetOffset'), context)}-10800000 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetAvailableIDs'), context)}passed`));
      await scrollView('idsScroll', 'idsText', expectedIdsText)
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetAvailableZoneCityIDs'), context)}passed`));
      await scrollView('cityIdArrayScroll', 'cityIdArrayText', expectedCityIdArrayText);
      await scrollOuterBottomView('outerScrollInTimezone');
      await scrollView('timezoneListScroll', `timezoneListText${LAST_INDEX}`, expectedTimezoneListText);
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimezoneDstSetting_006, end');
    });

    /**
     * @tc.number I18nTestMultilingualSorting_007
     * @tc.name I18nTestMultilingualSorting_007
     * @tc.desc 多语言排序
     */
    it(BUNDLE + 'MultilingualSorting_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'MultilingualSorting_007, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.MultilingualSorting'), context));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfIndexList'), context)}passed`));
      await driver.assertComponentExist(ON.text('…,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' +
        '…,А,Б,В,Г,Д,Е,Ж,З,И,Й,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ы,Э,Ю,Я,…'));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfIndex'), context)}N --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'MultilingualSorting_007, end');
    });

    /**
     * @tc.number I18nTestCharacterProcessing_008
     * @tc.name I18nTestCharacterProcessing_008
     * @tc.desc 字符处理
     */
    it(BUNDLE + 'CharacterProcessing_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CharacterProcessing_008, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.CharacterProcessing'), context));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfCharacterType'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.Character1IsNumber'), context)}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.AIsRightToLeft'), context)}false --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.HuaIsIdeograph'), context)}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.AGetType'), context)}U_LOWERCASE_LETTER --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfTrans'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CharacterTransResult'), context)}zhōng guó --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ChinaTrans'), context)}zhong guo --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.TeachersSurnameTrans'), context)}shàn lǎo shī --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultsOfSupportedId'), context)}passed`));
      await scrollView('transIdsScroll', 'transIdsText', expectedTransIdsText);
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfNormalize'), context)));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.NFCNormalizeResult'), context)}ẛ̣ --passed`));
      await scrollOuterBottomView('outerScrollInCharacter');
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfBreakIterator'), context)));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.FirstPos'), context)}0 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.NextPos'), context)}9 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.IsBoundary'), context)}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.BreakText'), context)}Apple is my favorite fruit. --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CharacterProcessing_008, end');
    });

    /**
     * @tc.number I18nTestNameLocalization_009
     * @tc.name I18nTestNameLocalization_009
     * @tc.desc 本地化名称
     */
    it(BUNDLE + 'NameLocalization_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NameLocalization_009, begin');
      const context = await application.createModuleContext(application.getApplicationContext(), "entry_test");
      await checkAndClickByText(resourceToString($r('app.string.NameLocalization'), context));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfLanguageRegion'), context)));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.DisplayLanguage'), context)}` +
        `${resourceToString($r('app.string.ExpectedDisplayLanguage'), context)} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DisplayCountry'), context)}Saudi Arabia --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfDisplayTimezone'), context)));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ResultOfTimezoneName'), context)}` +
        `${resourceToString($r('app.string.ExpectedTimeZone'), context)}`, MatchPattern.CONTAINS));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NameLocalization_009, end');
    });
  });
}
