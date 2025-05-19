self.addEventListener('install', event => {
    console.log('v1 installing');
    event.waitUntil(
        caches.open('static-v1').then(cache => cache.add('/cat.svg'))
    );
});


self.addEventListener('activate', event => {
    console.log("v1 now redy to handle fetches.");
});