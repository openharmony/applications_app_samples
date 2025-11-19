if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AnimatablePropertyText_Params {
    textWidth?: number;
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
// [Start animatable_extend_text]
function animatableWidth(width: number, elmtId, isInitialRender, parent): void {
    if (isInitialRender) {
        Text.createAnimatableProperty("animatableWidth", width, (width: number) => {
            ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
            ViewStackProcessor.GetAndPushFrameNode("Text", elmtId);
            Text.width(width);
            ViewStackProcessor.StopGetAccessRecording();
            parent.finishUpdateFunc(elmtId);
        });
        Text.width(width);
    }
    else {
        Text.updateAnimatableProperty("animatableWidth", width);
    }
}
class AnimatablePropertyText extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__textWidth = new ObservedPropertySimplePU(80, this, "textWidth");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AnimatablePropertyText_Params) {
        if (params.textWidth !== undefined) {
            this.textWidth = params.textWidth;
        }
    }
    updateStateVars(params: AnimatablePropertyText_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__textWidth.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__textWidth.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __textWidth: ObservedPropertySimplePU<number>;
    get textWidth() {
        return this.__textWidth.get();
    }
    set textWidth(newValue: number) {
        this.__textWidth.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.padding(10);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('AnimatableProperty');
            Context.animation({ duration: 2000, curve: Curve.Ease });
            animatableWidth(this.textWidth, elmtId, isInitialRender, this);
            Context.animation(null);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Play');
            Button.onClick(() => {
                this.textWidth = this.textWidth == 80 ? 160 : 80;
            });
        }, Button);
        Button.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "AnimatablePropertyText";
    }
}
registerNamedRoute(() => new AnimatablePropertyText(undefined, {}), "", { bundleName: "com.example.componentextension", moduleName: "entry", pagePath: "pages/AnimatableExtendDecorator/AnimatablePropertyText", pageFullPath: "entry/src/main/ets/pages/AnimatableExtendDecorator/AnimatablePropertyText", integratedHsp: "false", moduleType: "followWithHap" });
