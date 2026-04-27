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
import { AsyncCallback } from './basic'

export default fileIo;

/**
 * fileio
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @import import fileio from '@ohos.file.js';
 */
declare namespace fileIo {
    export { open };
    export { openSync };
    export { read };
    export { readSync };
    export { stat };
    export { statSync };
    export { truncate };
    export { truncateSync };
    export { write };
    export { writeSync };
    export { File };
    export { OpenMode };
    export { Stat };
    
    /**
     * Mode Indicates the open flags.
     * @since 9
     * @syscap SystemCapability.FileManagement.File.FileIO
     */
    namespace OpenMode  {
        const READ_ONLY = 0o0;              // Read only Permission
        const WRITE_ONLY = 0o1;             // Write only Permission
        const READ_WRITE = 0o2;             // Write and Read Permission
        const CREATE = 0o100;               // If not exist, create file
        const TRUNC = 0o1000;               // File truncate len 0
        const APPEND = 0o2000;              // File append write
        const NONBLOCK = 0o4000;            // File open in nonblocking mode
        const DIR = 0o200000;               // File is Dir
        const NOFOLLOW = 0o400000;          // File is not symbolic link
        const SYNC = 0o4010000;             // SYNC IO
    }
}

/**
 * Open file.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function open
 * @param {string} path - path.
 * @param {number} [mode = OpenMode.READ_ONLY] - mode.
 * @param {AsyncCallback<File>} [callback] - callback.
 * @returns {void | Promise<File>} no callback return Promise otherwise return void
 * @throws { BusinessError } 13900001  - Operation not permitted
 * @throws { BusinessError } 13900002  - No such file or directory
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900006  - No such device or address
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900011  - Out of memory
 * @throws { BusinessError } 13900012  - Permission denied
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900014  - Device or resource busy
 * @throws { BusinessError } 13900015  - File exists
 * @throws { BusinessError } 13900017  - No such device
 * @throws { BusinessError } 13900018  - Not a directory
 * @throws { BusinessError } 13900019  - Is a directory
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900022  - Too many open files
 * @throws { BusinessError } 13900023  - Text file busy
 * @throws { BusinessError } 13900024  - File too large
 * @throws { BusinessError } 13900025  - No space left on device
 * @throws { BusinessError } 13900027  - Read-only file system
 * @throws { BusinessError } 13900029  - Resource deadlock would occur
 * @throws { BusinessError } 13900030  - File name too long
 * @throws { BusinessError } 13900033  - Too many symbolic links encountered
 * @throws { BusinessError } 13900034  - Operation would block
 * @throws { BusinessError } 13900038  - Value too large for defined data type
 * @throws { BusinessError } 13900041  - Quota exceeded
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function open(path: string, mode?: number): Promise<File>;
declare function open(path: string, callback: AsyncCallback<File>): void;
declare function open(path: string, mode: number, callback: AsyncCallback<File>): void;
/**
 * Open file with sync interface.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function openSync
 * @param {string} path - path.
 * @param {number} [mode = OpenMode.READ_ONLY] - mode.
 * @returns {File} open fd
 * @throws { BusinessError } 13900001  - Operation not permitted
 * @throws { BusinessError } 13900002  - No such file or directory
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900006  - No such device or address
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900011  - Out of memory
 * @throws { BusinessError } 13900012  - Permission denied
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900014  - Device or resource busy
 * @throws { BusinessError } 13900015  - File exists
 * @throws { BusinessError } 13900017  - No such device
 * @throws { BusinessError } 13900018  - Not a directory
 * @throws { BusinessError } 13900019  - Is a directory
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900022  - Too many open files
 * @throws { BusinessError } 13900023  - Text file busy
 * @throws { BusinessError } 13900024  - File too large
 * @throws { BusinessError } 13900025  - No space left on device
 * @throws { BusinessError } 13900027  - Read-only file system
 * @throws { BusinessError } 13900029  - Resource deadlock would occur
 * @throws { BusinessError } 13900030  - File name too long
 * @throws { BusinessError } 13900033  - Too many symbolic links encountered
 * @throws { BusinessError } 13900034  - Operation would block
 * @throws { BusinessError } 13900038  - Value too large for defined data type
 * @throws { BusinessError } 13900041  - Quota exceeded
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function openSync(path: string, mode?: number): File;

/**
 * Read file.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function read
 * @param {number} fd - file descriptor.
 * @param {ArrayBuffer} buffer - file descriptor.
 * @param {Object} [options] - options.
 * @param {number} [options.offset = 0] - offset.
 * @param {number} [options.length = 0] - length.
 * @param {AsyncCallback<number>} [callback] - callback.
 * @returns {void | Promise<number>} no callback return Promise otherwise return void
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900010  - Try again
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900019  - Is a directory
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900034  - Operation would block
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function read(fd: number, buffer: ArrayBuffer, options?: {
    offset?: number;
    length?: number;
}): Promise<number>
declare function read(fd: number, buffer: ArrayBuffer, callback: AsyncCallback<number>): void;
declare function read(fd: number, buffer: ArrayBuffer, options: {
    offset?: number;
    length?: number;
}, callback: AsyncCallback<number>): void;
/**
 * Read file with sync interface.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function readSync
 * @param {number} fd - file descriptor.
 * @param {ArrayBuffer} buffer - file descriptor.
 * @param {Object} [options] - options.
 * @param {number} [options.offset = 0] - offset.
 * @param {number} [options.length = 0] - length.
 * @returns {number} number of bytesRead
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900010  - Try again
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900019  - Is a directory
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900034  - Operation would block
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function readSync(fd: number, buffer: ArrayBuffer, options?: {
    offset?: number;
    length?: number;
}): number;

/**
 * Get file information.
 * @static
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @param {string | number} file - path or file descriptor.
 * @param {AsyncCallback<Stat>} [callback] - callback.
 * @returns {void | Promise<Stat>} no callback return Promise otherwise return void
 * @throws { BusinessError } 13900002  - No such file or directory
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900011  - Out of memory
 * @throws { BusinessError } 13900012  - Permission denied
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900018  - Not a directory
 * @throws { BusinessError } 13900030  - File name too long
 * @throws { BusinessError } 13900031  - Function not implemented
 * @throws { BusinessError } 13900033  - Too many symbolic links encountered
 * @throws { BusinessError } 13900038  - Value too large for defined data type
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function stat(file: string | number): Promise<Stat>;
declare function stat(file: string | number, callback: AsyncCallback<Stat>): void;
/**
 * Get file information with sync interface.
 * @static
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @param {string | number} file - path or file descriptor.
 * @returns {Stat} stat success
 * @throws { BusinessError } 13900002  - No such file or directory
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900011  - Out of memory
 * @throws { BusinessError } 13900012  - Permission denied
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900018  - Not a directory
 * @throws { BusinessError } 13900030  - File name too long
 * @throws { BusinessError } 13900031  - Function not implemented
 * @throws { BusinessError } 13900033  - Too many symbolic links encountered
 * @throws { BusinessError } 13900038  - Value too large for defined data type
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function statSync(file: string | number): Stat;

 /**
 * Truncate file.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function truncate
 * @param {string | number} file - path or file descriptor.
 * @param {number} [len = 0] - len.
 * @param {AsyncCallback<void>} [callback] - callback.
 * @returns {void | Promise<void>} no callback return Promise otherwise return void
 * @throws { BusinessError } 13900001  - Operation not permitted
 * @throws { BusinessError } 13900002  - No such file or directory
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900012  - Permission denied
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900018  - Not a directory
 * @throws { BusinessError } 13900019  - Is a directory
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900023  - Text file busy
 * @throws { BusinessError } 13900024  - File too large
 * @throws { BusinessError } 13900027  - Read-only file system
 * @throws { BusinessError } 13900030  - File name too long
 * @throws { BusinessError } 13900033  - Too many symbolic links encountered
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function truncate(file: string | number, len?: number): Promise<void>;
declare function truncate(file: string | number, callback: AsyncCallback<void>): void;
declare function truncate(file: string | number, len: number, callback: AsyncCallback<void>): void;
/**
 * Truncate file with sync interface.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function truncateSync
 * @param {string | number} file - path or file descriptor.
 * @param {number} [len = 0] - len.
 * @returns {void} truncate success
 * @throws { BusinessError } 13900001  - Operation not permitted
 * @throws { BusinessError } 13900002  - No such file or directory
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900012  - Permission denied
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900018  - Not a directory
 * @throws { BusinessError } 13900019  - Is a directory
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900023  - Text file busy
 * @throws { BusinessError } 13900024  - File too large
 * @throws { BusinessError } 13900027  - Read-only file system
 * @throws { BusinessError } 13900030  - File name too long
 * @throws { BusinessError } 13900033  - Too many symbolic links encountered
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function truncateSync(file: string | number, len?: number): void;

/**
 * Write file.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function write
 * @param {number} fd - file descriptor.
 * @param {ArrayBuffer | string} buffer - file descriptor.
 * @param {Object} [options] - options.
 * @param {number} [options.offset = 0] - offset.
 * @param {number} [options.length = 0] - length.
 * @param {string} [options.encoding = 'utf-8'] - encoding.
 * @param {AsyncCallback<number>} [callback] - callback.
 * @returns {void | Promise<number>} no callback return Promise otherwise return void
 * @throws { BusinessError } 13900001  - Operation not permitted
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900010  - Try again
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900024  - File too large
 * @throws { BusinessError } 13900025  - No space left on device
 * @throws { BusinessError } 13900034  - Operation would block
 * @throws { BusinessError } 13900041  - Quota exceeded
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function write(fd: number, buffer: ArrayBuffer | string, options?: {
    offset?: number;
    length?: number;
    encoding?: string;
}): Promise<number>;
declare function write(fd: number, buffer: ArrayBuffer | string, callback: AsyncCallback<number>): void;
declare function write(fd: number, buffer: ArrayBuffer | string, options: {
    offset?: number;
    length?: number;
    encoding?: string;
}, callback: AsyncCallback<number>): void;
/**
 * Write file with sync interface.
 *
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 * @function writeSync
 * @param {number} fd - file descriptor.
 * @param {ArrayBuffer | string} buffer - file descriptor.
 * @param {Object} [options] - options.
 * @param {number} [options.offset = 0] - offset.
 * @param {number} [options.length = 0] - length.
 * @param {string} [options.encoding = 'utf-8'] -  encoding.
 * @returns {number} on success number of bytesRead
 * @throws { BusinessError } 13900001  - Operation not permitted
 * @throws { BusinessError } 13900004  - Interrupted system call
 * @throws { BusinessError } 13900005  - I/O error
 * @throws { BusinessError } 13900008  - Bad file descriptor
 * @throws { BusinessError } 13900010  - Try again
 * @throws { BusinessError } 13900013  - Bad address
 * @throws { BusinessError } 13900020  - Invalid argument
 * @throws { BusinessError } 13900024  - File too large
 * @throws { BusinessError } 13900025  - No space left on device
 * @throws { BusinessError } 13900034  - Operation would block
 * @throws { BusinessError } 13900041  - Quota exceeded
 * @throws { BusinessError } 13900042  - Unknown error
 */
declare function writeSync(fd: number, buffer: ArrayBuffer | string, options?: {
    offset?: number;
    length?: number;
    encoding?: string;
}): number;

/**
 * File object.
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 */
declare interface File {
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly fd: number;
}
/**
 * Stat object.
 * @syscap SystemCapability.FileManagement.File.FileIO
 * @since 9
 */
declare interface Stat {
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly ino: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly mode: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly uid: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly gid: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly size: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly atime: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly mtime: number;
    /**
     * @type {number}
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @readonly
     */
    readonly ctime: number;
    /**
     * whether path/fd is block device.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isBlockDevice(): boolean;
    /**
     * whether path/fd is character device.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isCharacterDevice(): boolean;
    /**
     * whether path/fd is directory.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isDirectory(): boolean;
    /**
     * whether path/fd is fifo.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isFIFO(): boolean;
    /**
     * whether path/fd is file.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isFile(): boolean;
    /**
     * whether path/fd is socket.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isSocket(): boolean;
    /**
     * whether path/fd is symbolic link.
     * @syscap SystemCapability.FileManagement.File.FileIO
     * @since 9
     * @returns {boolean} is or not
     */
    isSymbolicLink(): boolean;
}
