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
 
export class EventConstants {
  // system events
  public static readonly EVENT_PACKAGE_ADDED: string = 'usual.event.PACKAGE_ADDED';
  public static readonly EVENT_PACKAGE_CHANGED: string = 'usual.event.PACKAGE_CHANGED';
  public static readonly EVENT_PACKAGE_REMOVED: string = 'usual.event.PACKAGE_REMOVED';
  // pagedesktop events
  public static readonly EVENT_REQUEST_PAGEDESK_ITEM_ADD: string =
    'launcher.event.REQUEST_PAGEDESK_ITEM_ADD'; //request add app to pageDesk
  public static readonly EVENT_REQUEST_PAGEDESK_ITEM_DELETE: string =
    'launcher.event.REQUEST_PAGEDESK_ITEM_DELETE'; //request delete app from pageDesk
  public static readonly EVENT_REQUEST_PAGEDESK_ITEM_UPDATE: string =
    'launcher.event.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE'; //request pagedesktop rebuild layout
  public static readonly EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD: string = 'launcher.event.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD';
  public static readonly EVENT_REQUEST_FORM_ITEM_VISIBLE: string = 'launcher.event.REQUEST_FORM_ITEM_VISIBLE';
  public static readonly EVENT_SMARTDOCK_INIT_FINISHED: string = 'launcher.event.EVENT_SMARTDOCK_INIT_FINISHED';
  public static readonly EVENT_BADGE_UPDATE: string = 'launcher.event.EVENT_BADGE_UPDATE';
  public static readonly EVENT_REQUEST_PAGEDESK_REFRESH: string = 'EVENT_REQUEST_PAGEDESK_REFRESH'; // pageDesktop refresh

  // smartdock events
  public static readonly EVENT_REQUEST_DOCK_ITEM_ADD: string =
    'launcher.event.REQUEST_DOCK_ITEM_ADD'; //request add app to smartDock
  public static readonly EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE: string =
    'launcher.event.REQUEST_DOCK_ITEM_DELETE'; //request delete app from resident dock
  public static readonly EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE: string =
    'launcher.event.RECENT_DOCK_ITEM_DELETE'; //request delete app from recent dock
  public static readonly EVENT_REQUEST_RESIDENT_DOCK_ITEM_UPDATE: string =
    'launcher.event.EVENT_REQUEST_RESIDENT_DOCK_ITEM_UPDATE'; //request update item from smartDock

  // bigfolder events
  public static readonly EVENT_FOLDER_PACKAGE_REMOVED: string = 'usual.event.FOLDER_PACKAGE_REMOVED';
  // gesturenavigation events
  public static readonly EVENT_NAVIGATOR_BAR_STATUS_CHANGE: string = 'usual.event.NAVIGATOR_BAR_STATUS_CHANGE';
  // animation event
  public static readonly EVENT_ANIMATION_START_APPLICATION: string = 'launcher.event.EVENT_ANIMATION_START_APPLICATION';
  public static readonly EVENT_ANIMATION_CLOSE_APPLICATION: string = 'launcher.event.EVENT_ANIMATION_CLOSE_APPLICATION';
}