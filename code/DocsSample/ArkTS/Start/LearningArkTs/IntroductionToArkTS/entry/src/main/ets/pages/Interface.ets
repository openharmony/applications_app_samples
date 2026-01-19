/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

export {};
{
  // [Start interface_example]
  interface Style {
    color: string; // 属性
  }
  interface AreaSize {
    calculateAreaSize(): number; // 方法的声明
    someMethod(): void;     // 方法的声明
  }
  // [End interface_example]
}

{
  // [Start interface_class_example]
  // 接口：
  interface AreaSize {
    calculateAreaSize(): number; // 方法的声明
    someMethod(): void;     // 方法的声明
  }

  // 实现：
  class RectangleSize implements AreaSize {
    private width: number = 0;
    private height: number = 0;
    someMethod(): void {
      console.info('someMethod called');
    }
    calculateAreaSize(): number {
      this.someMethod(); // 调用另一个方法并返回结果
      return this.width * this.height;
    }
  }
  // [End interface_class_example]
}

{
  // [Start interface_attribute]
  interface Style {
    color: string;
  }
  // [End interface_attribute]
}

{
  // [Start interface_set_attribute]
  interface Style {
    get color(): string;
    set color(x: string);
  }
  // [End interface_set_attribute]
}

{
  // [Start interface_class_attribute]
  interface Style {
    color: string;
  }

  class StyledRectangle implements Style {
    public color: string = '';
  }
  // [End interface_class_attribute]
}

{
  // [Start interface_class_set_attribute]
  interface Style {
    color: string;
  }

  class StyledRectangle implements Style {
    private _color: string = '';
    get color(): string { return this._color; }
    set color(x: string) { this._color = x; }
  }
  // [End interface_class_set_attribute]
}

{
  // [Start interface_extends]
  interface Style {
    color: string;
  }

  interface ExtendedStyle extends Style {
    width: number;
  }
  // [End interface_extends]
}