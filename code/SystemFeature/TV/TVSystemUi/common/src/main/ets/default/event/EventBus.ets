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

export type EventArg = string | number | boolean | Object | undefined;
export type Callback = (args: EventArg) => void;
const TAG = 'EventBus';

export interface EventBus<T> {
    on(event: T | T[], cb: Callback): () => void;
    once(event: T, cb: Callback): () => void;
    off(event: T | T[] | undefined, cb: Callback): void;
    emit(event: T, args: EventArg): void;
}

// SystemUI 各面板（音量、通知、导航栏）运行在独立的 ServiceExtension 进程中，
// 无法直接共享内存对象，需要一个轻量级的进程内发布/订阅总线完成模块间解耦通信。
export function createEventBus<T extends string>(): EventBus<T> {
    return new EventBusImpl<T>();
}

class EventBusImpl<T extends string> implements EventBus<T> {
    private cbs: Map<T, Set<Callback>> = new Map<T, Set<Callback>>();

    on(event: T | T[], cb: Callback): () => void {
        if (Array.isArray(event)) {
            event.forEach((e: T) => {
                this.addSingleEvent(e, cb);
            });
        } else {
            this.addSingleEvent(event, cb);
        }
        return () => this.off(event, cb);
    }

    once(event: T, cb: Callback): () => void {
        let removeHandle: (() => void) | undefined = undefined;
        const wrapped: Callback = (args: EventArg): void => {
            cb(args);
            if (removeHandle) {
                removeHandle();
            }
        };
        removeHandle = this.on(event, wrapped);
        return removeHandle;
    }

    off(event: T | T[] | undefined, cb: Callback): void {
        if (!event) {
            this.cbs.clear();
            Log.showInfo(TAG, 'remove all event callbacks');
            return;
        }
        if (Array.isArray(event)) {
            event.forEach((e: T) => {
                this.removeSingleEvent(e, cb);
            });
            return;
        }
        this.removeSingleEvent(event, cb);
    }

    emit(event: T, args: EventArg): void {
        const eventSet: Set<Callback> | undefined = this.cbs.get(event);
        if (!eventSet) {
            return;
        }
        eventSet.forEach((cb: Callback) => cb(args));
    }

    private addSingleEvent(event: T, cb: Callback): void {
        let eventSet: Set<Callback> | undefined = this.cbs.get(event);
        if (!eventSet) {
            eventSet = new Set<Callback>();
            this.cbs.set(event, eventSet);
        }
        eventSet.add(cb);
        Log.showInfo(TAG, `add event[${event}] callback, size: ${eventSet.size}`);
    }

    private removeSingleEvent(event: T, cb: Callback): void {
        const eventSet: Set<Callback> | undefined = this.cbs.get(event);
        if (!eventSet) {
            return;
        }
        eventSet.delete(cb);
        Log.showInfo(TAG, `remove event[${event}] callback, size: ${eventSet.size}`);
        if (eventSet.size == 0) {
            this.cbs.delete(event);
        }
    }
}
