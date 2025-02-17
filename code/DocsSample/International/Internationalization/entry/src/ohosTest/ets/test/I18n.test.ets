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
      await delegator.startAbility({
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      });
      await driver.delayMs(DELAY_TIME_LONG);
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.LocaleCulturalDivisionExample'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.LanguagePreferenceSetting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.DateTimeFormatting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.NumberMeasurementFormatting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.PhoneNumberFormatting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.CalendarSetting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.TimezoneDstSetting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.MultilingualSorting'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.CharacterProcessing'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.NameLocalization'))));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'LaunchIndexPage_001, end');
    });

    /**
     * @tc.number I18nTestLocaleCulturalDivision_002
     * @tc.name I18nTestLocaleCulturalDivision_002
     * @tc.desc 区域标识与文化习惯划分(时间日期格式化为例)
     */
    it(BUNDLE + 'LocaleCulturalDivision_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LocaleCulturalDivision_002, begin');
      await checkAndClickByText(resourceToString($r('app.string.LocaleCulturalDivisionExample')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.MethodOne'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfMethodOne'))}2023/10/15 --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.MethodTwo'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfMethodTwo'))}10/15/23 --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.MethodThree'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfMethodThree'))}2023/10/15 --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'LocaleCulturalDivision_002, end');
    });

    /**
     * @tc.number I18nTestLanguagePreferenceSetting_003
     * @tc.name I18nTestLanguagePreferenceSetting_003
     * @tc.desc 设置语言与用户偏好
     */
    it(BUNDLE + 'LanguagePreferenceSetting_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguagePreferenceSetting_003, begin');
      await checkAndClickByText(resourceToString($r('app.string.LanguagePreferenceSetting')));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.ResultsOfSetSystemLanguageAndRegion'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetSystemLanguage'))}zh --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetSystemRegion'))}CN --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetSystemLocale'))}zh-Hans-CN --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfSetPreferredLanguage'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetAndGetPreferredLanguage'))}zh-Hans --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfSetUserPreference'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetApplicationInterfaceNumber'))}٢٥‏/١٠‏/٢٠٢٣ --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SetFormatTo24Format'))}16:48:00 --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'LanguagePreferenceSetting_003, end');
    });

    /**
     * @tc.number I18nTestDateTimeFormatting_004
     * @tc.name I18nTestDateTimeFormatting_004
     * @tc.desc 时间日期国际化
     */
    it(BUNDLE + 'DateTimeFormatting_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DateTimeFormatting_004, begin');
      await checkAndClickByText(resourceToString($r('app.string.DateTimeFormatting')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfDateTimeFormat'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.FullDateStyle'))}` +
        `${resourceToString($r('app.string.ExpectedFormattedDate1'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ShortDateStyle'))}2021/9/17 13:04 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CustomDateStyle'))}2021/09/17 13:04:00 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString(
        $r('app.string.PartDateStyle'))}${resourceToString($r('app.string.ExpectedFormattedDate4'))} --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString(
        $r('app.string.CustomTimeStyle'))}${resourceToString($r('app.string.ExpectedFormattedDate5'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CustomNumberingSystem'))}٢٠٢١/٩/١٧ ١٣:٠٤ --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.FormatDateRange'))}17/09/2021 – 18/09/2021 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.FormatDateStyle'))}full --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfRelativeTimeFormat'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.FormatRelativeTime'))}1 day ago --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.AutoFormatRelativeTime'))}yesterday --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LongFormatRelativeTime'))}il y a 1 jour --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.NarrowFormatRelativeTime'))}-1 j --passed`));
      await driver.assertComponentExist(
        ON.text(resourceToString($r('app.string.CustomFormatRelativeTime')) +
          '[{"type":"literal","value":"in "},' +
          '{"type":"integer","value":"1","unit":"day"},' +
          '{"type":"literal","value":" day"}] --passed'
        )
      );
      await scrollOuterBottomView('outerScrollInDateTime');
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetRelativeTimeFormatOptions'))}auto --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DateTimeFormatting_004, end');
    });

    /**
     * @tc.number I18nTestNumberMeasurementFormatting_005
     * @tc.name I18nTestNumberMeasurementFormatting_005
     * @tc.desc 数字与度量衡国际化
     */
    it(BUNDLE + 'NumberMeasurementFormatting_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NumberMeasurementFormatting_005, begin');
      await checkAndClickByText(resourceToString($r('app.string.NumberMeasurementFormatting')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfNumberFormat'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ScientificDisplayNumber'))}1.23E5 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CompactDisplayNumber'))}` +
          `${resourceToString($r('app.string.ExpectedFormattedNumber2'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.SignDisplayNumber'))}+123,400 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.PercentDisplayNumber'))}25% --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfCurrencyAndUnit'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DisplayCurrency'))}US$123,400.00 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DisplayCurrencyName'))}` +
          `${resourceToString($r('app.string.ExpectedFormattedNumber6'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DisplayUnit'))}123,400 ha --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DisplayUnitLand'))}304,928.041 ac --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfMeasureTrans'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.MeasureTrans'))}236.588 L --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LongMeasureTrans'))}236.588 liters --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NumberMeasurementFormatting_005, end');
    });

    /**
     * @tc.number I18nTestPhoneNumberFormatting_006
     * @tc.name I18nTestPhoneNumberFormatting_006
     * @tc.desc 电话号码格式化
     */
    it(BUNDLE + 'PhoneNumberFormatting_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhoneNumberFormatting, begin');
      await checkAndClickByText(resourceToString($r('app.string.PhoneNumberFormatting')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfPhoneNumberFormat'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.PhoneNumberFormat'))}158 1234 2312 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.RFC3966TypeNumberFormat'))}tel:+86-158-1234-2312 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.IsValidNumber'))}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CNLocationName'))}Zhanjiang, Guangdong --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.FormatResult'))}0755 453 --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'PhoneNumberFormatting_006, end');
    });

    /**
     * @tc.number I18nTestCalendarFormatting_007
     * @tc.name I18nTestCalendarFormatting_007
     * @tc.desc 设置日历和历法
     */
    it(BUNDLE + 'CalendarFormatting_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CalendarFormatting_007, begin');
      await checkAndClickByText(resourceToString($r('app.string.CalendarSetting')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfTheGregorianCalendar'))));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.TheGregorianCalendarSets'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.Timezone'))}Asia/Shanghai --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.FirstDayOfWeek'))}1 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.MinimalDaysInFirstWeek'))}1 --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.SetMinimalDaysInFirstWeek'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.YearOfTheFirstWeekIs3'))}2022 --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.LocalizedCalendarName'))}` +
          `${resourceToString($r('app.string.Calendar'))} --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.IsWeekend'))}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DateAfterAddingDays'))}17 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.DaysBetweenDates'))}-3 --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.LunarCalendar'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.LunarYear'))}40 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.LunarMonth'))}5 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.LunarDate'))}8 --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CalendarFormatting_007, end');
    });

    /**
     * @tc.number I18nTestTimezoneDstSetting_008
     * @tc.name I18nTestTimezoneDstSetting_008
     * @tc.desc 时区与夏令时国际化
     */
    it(BUNDLE + 'TimezoneDstSetting_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimezoneDstSetting_008, begin');
      await checkAndClickByText(resourceToString($r('app.string.TimezoneDstSetting')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfTimezoneFunction'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetTimezoneID'))}America/Sao_Paulo --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetAucklandID'))}Pacific/Auckland --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.TimeZoneLocalName'))}` +
        `${resourceToString($r('app.string.ExpectedTimeZone'))}`, MatchPattern.CONTAINS));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.AucklandDisplayName'))}` +
          `${resourceToString($r('app.string.ExpectedCityDisplayName'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.GetRawOffset'))}-10800000 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.GetOffset'))}-10800000 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.GetAvailableIDs'))}passed`));
      await scrollView('idsScroll', 'idsText', expectedIdsText)
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.GetAvailableZoneCityIDs'))}passed`));
      await scrollView('cityIdArrayScroll', 'cityIdArrayText', expectedCityIdArrayText);
      await scrollOuterBottomView('outerScrollInTimezone');
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.TimezoneList'))}passed`));
      await scrollView('timezoneListScroll', `timezoneListText${LAST_INDEX}`, expectedTimezoneListText);
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.IDOfGeographicCoordinate'))}America/Sao_Paulo --passed`))
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultsOfDualClockFeature'))}passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ExpectedTimeZoneData1'))}`,
        MatchPattern.CONTAINS))
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ExpectedTimeZoneData2'))}`,
        MatchPattern.CONTAINS))
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfDaylightSavingTimeJumps'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DaylightSavingTimeHourDifference'))}23 --passed`,
          MatchPattern.CONTAINS));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TimezoneDstSetting_008, end');
    });

    /**
     * @tc.number I18nTestMultilingualSorting_009
     * @tc.name I18nTestMultilingualSorting_009
     * @tc.desc 多语言排序
     */
    it(BUNDLE + 'MultilingualSorting_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'MultilingualSorting_009, begin');
      await checkAndClickByText(resourceToString($r('app.string.MultilingualSorting')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfLocalSort'))));
      await driver.assertComponentExist(ON.text(
        `${resourceToString($r('app.string.ResultOfEnglishSort'))}animal ANIMAL app App apple Apple APPLE --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfChineseSort'))}` +
          `${resourceToString($r('app.string.ExpectedChineseSort'))} --passed`));
      await driver.assertComponentExist(ON.text(
        `${resourceToString($r('app.string.ResultOfChineseStrokeSort'))}` +
          `${resourceToString($r('app.string.ExpectedChineseStrokeSort'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ResultOfSearchMatch'))}Türkiye,TüRkiye --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfCreateIndex'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ResultOfIndexList'))}passed`));
      await driver.assertComponentExist(ON.text('…,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,' +
        '…,А,Б,В,Г,Д,Е,Ж,З,И,Й,К,Л,М,Н,О,П,Р,С,Т,У,Ф,Х,Ц,Ч,Ш,Щ,Ы,Э,Ю,Я,…'));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ResultOfIndex'))}N --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'MultilingualSorting_009, end');
    });

    /**
     * @tc.number I18nTestCharacterProcessing_010
     * @tc.name I18nTestCharacterProcessing_010
     * @tc.desc 字符处理
     */
    it(BUNDLE + 'CharacterProcessing_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CharacterProcessing_010, begin');
      await checkAndClickByText(resourceToString($r('app.string.CharacterProcessing')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfCharacterType'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.Character1IsNumber'))}true --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.AIsRightToLeft'))}false --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.HuaIsIdeograph'))}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.AGetType'))}U_LOWERCASE_LETTER --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfTrans'))));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.CharacterTransResult'))}zhōng guó,dé guó,měi guó,fǎ guó --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ChinaTrans'))}zhong guo --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.TeachersSurnameTrans'))}shàn lǎo shī --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.ZhangSunWuJiTrans'))}zhǎng sūn wú jì --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ResultsOfSupportedId'))}passed`));
      await scrollView('transIdsScroll', 'transIdsText', expectedTransIdsText);
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfNormalize'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.NFCNormalizeResult'))}ẛ̣ --passed`));
      await scrollOuterBottomView('outerScrollInCharacter');
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfBreakIterator'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.FirstPos'))}0 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.NextPos'))}9 --passed`));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.IsBoundary'))}true --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.BreakText'))}Apple is my favorite fruit. --passed`));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CharacterProcessing_010, end');
    });

    /**
     * @tc.number I18nTestNameLocalization_011
     * @tc.name I18nTestNameLocalization_011
     * @tc.desc 本地化名称
     */
    it(BUNDLE + 'NameLocalization_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'NameLocalization_011, begin');
      await checkAndClickByText(resourceToString($r('app.string.NameLocalization')));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfLanguageRegion'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.DisplayLanguage'))}` +
        `${resourceToString($r('app.string.ExpectedDisplayLanguage'))} --passed`));
      await driver.assertComponentExist(
        ON.text(`${resourceToString($r('app.string.DisplayCountry'))}Saudi Arabia --passed`));
      await driver.assertComponentExist(ON.text(resourceToString($r('app.string.ResultsOfDisplayTimezone'))));
      await driver.assertComponentExist(ON.text(`${resourceToString($r('app.string.ResultOfTimezoneName'))}` +
        `${resourceToString($r('app.string.ExpectedTimeZone'))}`, MatchPattern.CONTAINS));
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'NameLocalization_011, end');
    });
  });
}
