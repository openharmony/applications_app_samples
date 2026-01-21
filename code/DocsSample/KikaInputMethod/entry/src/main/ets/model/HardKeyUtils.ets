/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

export function GetHardKeyValue(keyCode: number, isShift: boolean): string {
  let keyList: Map<number, string> = new Map<number, string>();
  keyList.set(2000, '0');
  keyList.set(2001, '1');
  keyList.set(2002, '2');
  keyList.set(2003, '3');
  keyList.set(2004, '4');
  keyList.set(2005, '5');
  keyList.set(2006, '6');
  keyList.set(2007, '7');
  keyList.set(2008, '8');
  keyList.set(2009, '9');
  keyList.set(2010, '*');
  keyList.set(2011, '#');
  keyList.set(2012, 'KEYCODE_DPAD_UP');
  keyList.set(2013, 'KEYCODE_DPAD_DOWN');
  keyList.set(2014, 'KEYCODE_DPAD_LEFT');
  keyList.set(2015, 'KEYCODE_DPAD_RIGHT');
  keyList.set(2016, 'KEYCODE_DPAD_CENTER');
  keyList.set(2017, 'a');
  keyList.set(2018, 'b');
  keyList.set(2019, 'c');
  keyList.set(2020, 'd');
  keyList.set(2021, 'e');
  keyList.set(2022, 'f');
  keyList.set(2023, 'g');
  keyList.set(2024, 'h');
  keyList.set(2025, 'i');
  keyList.set(2026, 'j');
  keyList.set(2027, 'k');
  keyList.set(2028, 'l');
  keyList.set(2029, 'm');
  keyList.set(2029, 'm');
  keyList.set(2030, 'n');
  keyList.set(2031, 'o');
  keyList.set(2032, 'p');
  keyList.set(2033, 'q');
  keyList.set(2034, 'r');
  keyList.set(2035, 's');
  keyList.set(2036, 't');
  keyList.set(2037, 'u');
  keyList.set(2038, 'v');
  keyList.set(2039, 'w');
  keyList.set(2040, 'x');
  keyList.set(2041, 'y');
  keyList.set(2042, 'z');
  keyList.set(2043, ',');
  keyList.set(2044, '.');
  keyList.set(2047, 'KEYCODE_SHIFT_LEFT');
  keyList.set(2048, 'KEYCODE_SHIFT_RIGHT');
  keyList.set(2050, ' ');
  keyList.set(2055, 'KEYCODE_DEL');
  keyList.set(2058, '=');
  keyList.set(2071, 'KEYCODE_FORWARD_DEL');
  keyList.set(2064, '/');
  keyList.set(2065, '@');
  keyList.set(2066, '+');
  keyList.set(2121, '(');
  keyList.set(2122, ')');

  if (keyList.has(keyCode)) {
    let value = keyList.get(keyCode);
    if (isShift && keyCode >= 2017 && keyCode <= 2042 && value !== undefined) {
      return value.toUpperCase();
    }
    return value ? value : '';
  }
  if (keyCode === 2000) {
    return '0';
  }
  return '';
}