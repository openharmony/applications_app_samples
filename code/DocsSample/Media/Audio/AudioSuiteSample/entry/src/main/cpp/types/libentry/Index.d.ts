export const CreateAudioRender: (type: number) => string;

export const DestroyAudioRender: (type: number) => string;

export const BaseEditor: (callback: (result: string) => void) => void;

export const AudioSourceSeparationNapi: (callback: (result: string) => void) => void;

export const MixingAndCascadingNapi: (callback: (result: string) => void) => void;

export const EqualizerEffectNapi: () => string;