/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

/**
 * define the testcase type : TestType, Size , Level
 */
export const DEFAULT = 0B0000;
export class TestType {}
TestType.FUNCTION = 0B1;
TestType.PERFORMANCE = 0B1 << 1;
TestType.POWER = 0B1 << 2;
TestType.RELIABILITY = 0B1 << 3;
TestType.SECURITY = 0B1 << 4;
TestType.GLOBAL = 0B1 << 5;
TestType.COMPATIBILITY = 0B1 << 6;
TestType.USER = 0B1 << 7;
TestType.STANDARD = 0B1 << 8;
TestType.SAFETY = 0B1 << 9;
TestType.RESILIENCE = 0B1 << 10;
export class Size {}
Size.SMALLTEST = 0B1 << 16;
Size.MEDIUMTEST = 0B1 << 17;
Size.LARGETEST = 0B1 << 18;
export class Level {}
Level.LEVEL0 = 0B1 << 24;
Level.LEVEL1 = 0B1 << 25;
Level.LEVEL2 = 0B1 << 26;
Level.LEVEL3 = 0B1 << 27;
Level.LEVEL4 = 0B1 << 28;