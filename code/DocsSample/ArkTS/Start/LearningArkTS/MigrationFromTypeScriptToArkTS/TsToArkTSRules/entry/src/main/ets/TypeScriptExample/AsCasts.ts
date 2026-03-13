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
// [Start as_casts_ts]
class testShape { }
class testCircle extends testShape { x: number = 5 }
class testSquare extends testShape { y: string = 'a' }

function createShape(): testShape {
    return new testCircle();
}

let c1 = <testCircle>createShape();

let c2 = createShape() as testCircle;

// 如果转换错误，不会产生编译时或运行时报错
let c3 = createShape() as testSquare;
console.info(c3.y); // undefined

// 在TS中，由于`as`关键字不会在运行时生效，所以`instanceof`的左操作数不会在运行时被装箱成引用类型
let e1 = (5.0 as Number) instanceof Number; // false

// 创建Number对象，获得预期结果：
let e2 = (new Number(5.0)) instanceof Number; // true
// [End as_casts_ts]
