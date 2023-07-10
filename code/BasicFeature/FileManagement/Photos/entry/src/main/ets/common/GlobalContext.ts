
export class GlobalContext {
    private constructor() { }
    private static instance: GlobalContext;
    private _objects = new Map<string, Object>();

    public static getContext(): GlobalContext {
        if (!(new Boolean(GlobalContext.instance)).valueOf()) {
            GlobalContext.instance = new GlobalContext();
        }
        return GlobalContext.instance;
    }

    getObject(value: string): Object {
        return this._objects.get(value);
    }

    setObject(key: string, objectClass: Object): void {
        this._objects.set(key, objectClass);
    }
}