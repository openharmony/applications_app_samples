import { NodeContent } from "@kit.ArkUI";

export const createNativeRoot: (content: Object) => void;
export const createNodeTreeOnMultiThread: (content: Object, context: Object) => void;
export const disposeNodeTreeOnMultiThread: (content: Object) => void;
export const createCustomPropertyDemo: (content: Object) => void;
export const createNodeAdapterDemo: (content: Object) => void;
export const disposeNodeTree: (content: Object) => void;
export const getContext: (context: Object) => void;
export const getNodeHandle: (node: Object) => void;
export const getNodeHandleById: (id: Object) => void;
export const getNodeHandleByUniqueId: (uniqueId: Object) => void;
export const destroyNativeRoot: () => void;
export const CreateDrawNode: (content: NodeContent) => void;
export const CreateNativeRoot: (content: NodeContent) => void;
export const DestroyNativeRoot: () => void;
