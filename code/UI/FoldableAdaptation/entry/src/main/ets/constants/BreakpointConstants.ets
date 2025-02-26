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

/**
 * Constants for breakpoint.
 */
export class BreakpointConstants {
  /**
   * Breakpoints that represent small device types.
   */
  public static readonly BREAKPOINT_SM: string = 'sm';
  /**
   * Breakpoints that represent middle device types.
   */
  public static readonly BREAKPOINT_MD: string = 'md';
  /**
   * Breakpoints that represent large device types.
   */
  public static readonly BREAKPOINT_LG: string = 'lg';
  /**
   * Grid row column list.
   */
  public static readonly GRID_ROW_COLUMNS: number[] = [4, 8, 12];
  /**
   * Grid column span list.
   */
  public static readonly GRID_COLUMN_SPANS: number[] = [0, 4, 8];
  /**
   * Breakpoints ranges.
   */
  public static readonly BREAKPOINT_RANGES: number[] = [320, 600, 840];
}