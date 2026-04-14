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
 

import Log from '../Log';

export type EventTarget = 'local' | 'remote' | 'ability' | 'commonEvent';
export type EventArg = string | number | boolean | Object | undefined;

export interface EventData {
    eventName?: string;
    bundleName?: string;
    abilityName?: string;
    args?: EventArg;
}

export interface Event {
    target: EventTarget;
    data: EventData;
}

export interface EventParser {
    local(data: EventData): boolean;
    remote(data: EventData): boolean;
    ability(data: EventData): boolean;
    commonEvent(data: EventData): boolean;
}

export interface LocalEvent {
    eventName: string;
    args: EventArg;
}

export interface LocalTypedEvent extends Event {
    data: LocalEvent;
}

export const START_ABILITY_EVENT = 'startAbilityEvent';
export const PUBLISH_COMMON_EVENT = 'publishCommonEvent';

const TAG = 'EventUtil';
const LOCAL_EVENT_TYPE = 'local';
const START_ABILITY_TYPE = 'ability';

export function obtainLocalEvent(event: string, args: EventArg): LocalTypedEvent {
    const localData: LocalEvent = {
        eventName: event,
        args: args,
    };
    const result: LocalTypedEvent = {
        target: LOCAL_EVENT_TYPE,
        data: localData,
    };
    return result;
}

export function obtainStartAbility(bundleName: string, abilityName: string, args?: EventArg): Event {
    const data: EventData = {
        bundleName: bundleName,
        abilityName: abilityName,
        args: args
    };
    const result: Event = {
        target: START_ABILITY_TYPE,
        data: data,
    };
    return result;
}

export function parseEventString(eventString: string | undefined): Event | undefined {
    // string must be "local=eventName|args" or "ability=bundleName|abilityName"
    if (!eventString) {
        return;
    }
    let splitResult: string[] = eventString.split('=');
    let eventType: string = splitResult[0];
    let eventData: string | undefined = splitResult.length > 1 ? splitResult[1] : undefined;
    if (eventType == LOCAL_EVENT_TYPE && eventData) {
        let localParts: string[] = eventData.split('|');
        let localEventName: string | undefined = localParts.length > 0 ? localParts[0] : undefined;
        let args: string | undefined = localParts.length > 1 ? localParts[1] : undefined;
        if (localEventName) {
            Log.showDebug(TAG, `parseEventData name:${localEventName}, args: ${args}`);
            return obtainLocalEvent(localEventName, args);
        }
    }
    if (eventType == START_ABILITY_TYPE && eventData) {
        let abilityParts: string[] = eventData.split('|');
        let bundleName: string | undefined = abilityParts.length > 0 ? abilityParts[0] : undefined;
        let abilityName: string | undefined = abilityParts.length > 1 ? abilityParts[1] : undefined;
        if (bundleName && abilityName) {
            Log.showDebug(TAG, `parseEventData bundleName:${bundleName}, abilityName: ${abilityName}`);
            return obtainStartAbility(bundleName, abilityName);
        }
    }
    Log.showError(TAG, `Can't parse event data: ${eventString}`);
    return undefined;
}
