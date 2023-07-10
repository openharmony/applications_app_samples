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

import mediaquery from '@ohos.mediaquery'

export class BreakpointType<T> {
  sm: T
  md: T
  lg: T

  constructor(sm: T, md: T, lg: T) {
    this.sm = sm
    this.md = md
    this.lg = lg
  }

  GetValue(currentBreakpoint: string) {
    if (currentBreakpoint === 'sm') {
      return this.sm
    }
    if (currentBreakpoint === 'md') {
      return this.md
    }
    if (currentBreakpoint === 'lg') {
      return this.lg
    }
    return undefined
  }
}

export class SideBarMode<T> {
  list: T
  tabs: T

  constructor(list: T, tabs: T) {
    this.list = list
    this.tabs = tabs
  }

  GetValue(currentSideBarMode: string) {
    if (currentSideBarMode === 'list') {
      return this.list
    }
    if (currentSideBarMode === 'tabs') {
      return this.tabs
    }
    return undefined
  }
}

export class BreakpointSystem {
  private currentBreakpoint: string = 'md'
  private smListener: mediaquery.MediaQueryListener
  private mdListener: mediaquery.MediaQueryListener
  private lgListener: mediaquery.MediaQueryListener

  private updateCurrentBreakpoint(breakpoint: string) {
    if (this.currentBreakpoint !== breakpoint) {
      this.currentBreakpoint = breakpoint
      AppStorage.Set<string>('currentBreakpoint', this.currentBreakpoint)
    }
  }

  private isBreakpointSM = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint('sm')
    }
  }
  private isBreakpointMD = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint('md')
    }
  }
  private isBreakpointLG = (mediaQueryResult) => {
    if (mediaQueryResult.matches) {
      this.updateCurrentBreakpoint('lg')
    }
  }

  public register() {
    this.smListener = mediaquery.matchMediaSync("(320vp<width<520vp)")
    this.smListener.on("change", this.isBreakpointSM)
    this.mdListener = mediaquery.matchMediaSync("(520vp<width<840vp)")
    this.mdListener.on("change", this.isBreakpointMD)
    this.lgListener = mediaquery.matchMediaSync("(840vp<width)")
    this.lgListener.on("change", this.isBreakpointLG)
  }

  public unregister() {
    this.smListener.off("change", this.isBreakpointSM)
    this.mdListener.off("change", this.isBreakpointMD)
    this.lgListener.off("change", this.isBreakpointLG)
  }
}
