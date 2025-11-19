if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AnimatablePropertyExample_Params {
    points?: PointVector;
}
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
// [Start animatable_extend_example]
class Point {
    x: number;
    y: number;
    constructor(x: number, y: number) {
        this.x = x;
        this.y = y;
    }
    plus(rhs: Point): Point {
        return new Point(this.x + rhs.x, this.y + rhs.y);
    }
    subtract(rhs: Point): Point {
        return new Point(this.x - rhs.x, this.y - rhs.y);
    }
    multiply(scale: number): Point {
        return new Point(this.x * scale, this.y * scale);
    }
    equals(rhs: Point): boolean {
        return this.x === rhs.x && this.y === rhs.y;
    }
}
// PointVector实现了AnimatableArithmetic<T>接口
class PointVector extends Array<Point> implements AnimatableArithmetic<PointVector> {
    constructor(value: Array<Point>) {
        super();
        value.forEach(p => this.push(p));
    }
    plus(rhs: PointVector): PointVector {
        let result = new PointVector([]);
        const len = Math.min(this.length, rhs.length);
        for (let i = 0; i < len; i++) {
            result.push((this as Array<Point>)[i].plus((rhs as Array<Point>)[i]));
        }
        return result;
    }
    subtract(rhs: PointVector): PointVector {
        let result = new PointVector([]);
        const len = Math.min(this.length, rhs.length);
        for (let i = 0; i < len; i++) {
            result.push((this as Array<Point>)[i].subtract((rhs as Array<Point>)[i]));
        }
        return result;
    }
    multiply(scale: number): PointVector {
        let result = new PointVector([]);
        for (let i = 0; i < this.length; i++) {
            result.push((this as Array<Point>)[i].multiply(scale));
        }
        return result;
    }
    equals(rhs: PointVector): boolean {
        if (this.length != rhs.length) {
            return false;
        }
        for (let i = 0; i < this.length; i++) {
            if (!(this as Array<Point>)[i].equals((rhs as Array<Point>)[i])) {
                return false;
            }
        }
        return true;
    }
    get(): Array<Object[]> {
        let result: Array<Object[]> = [];
        this.forEach(p => result.push([p.x, p.y]));
        return result;
    }
}
function animatablePoints(points: PointVector, elmtId, isInitialRender, parent): void {
    if (isInitialRender) {
        Polyline.createAnimatableProperty("animatablePoints", points, (points: PointVector) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            ViewStackProcessor.GetAndPushFrameNode("Polyline", elmtId);
            Polyline.points(points.get());
            ViewStackProcessor.StopGetAccessRecording();
            parent.finishUpdateFunc(elmtId);
        });
        Polyline.points(points.get());
    }
    else {
        Polyline.updateAnimatableProperty("animatablePoints", points);
    }
}
class AnimatablePropertyExample extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__points = new ObservedPropertyObjectPU(new PointVector([
            new Point(50, Math.random() * 200),
            new Point(100, Math.random() * 200),
            new Point(150, Math.random() * 200),
            new Point(200, Math.random() * 200),
            new Point(250, Math.random() * 200),
        ]), this, "points");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AnimatablePropertyExample_Params) {
        if (params.points !== undefined) {
            this.points = params.points;
        }
    }
    updateStateVars(params: AnimatablePropertyExample_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__points.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__points.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __points: ObservedPropertyObjectPU<PointVector>;
    get points() {
        return this.__points.get();
    }
    set points(newValue: PointVector) {
        this.__points.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.padding(10);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Polyline.create();
            Context.animation({ duration: 1000, curve: Curve.Ease });
            animatablePoints(ObservedObject.GetRawObject(this.points), elmtId, isInitialRender, this);
            Context.animation(null);
            Polyline.size({ height: 220, width: 300 });
            Polyline.fill(Color.Green);
            Polyline.stroke(Color.Red);
            Polyline.backgroundColor('#eeaacc');
        }, Polyline);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Play');
            Button.onClick(() => {
                // points是实现了可动画协议的数据类型，points在动画过程中可按照定义的运算规则、动画参数从之前的PointVector变为新的PointVector数据，产生每一帧的PointVector数据，进而产生动画
                this.points = new PointVector([
                    new Point(50, Math.random() * 200),
                    new Point(100, Math.random() * 200),
                    new Point(150, Math.random() * 200),
                    new Point(200, Math.random() * 200),
                    new Point(250, Math.random() * 200),
                ]);
            });
        }, Button);
        Button.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "AnimatablePropertyExample";
    }
}
registerNamedRoute(() => new AnimatablePropertyExample(undefined, {}), "", { bundleName: "com.example.componentextension", moduleName: "entry", pagePath: "pages/AnimatableExtendDecorator/AnimatablePropertyExample", pageFullPath: "entry/src/main/ets/pages/AnimatableExtendDecorator/AnimatablePropertyExample", integratedHsp: "false", moduleType: "followWithHap" });
