// Keeps the web app usable without a connection. Every file the app loads is
// kept in the cache and served from there when the network cannot be reached.
// The app's own files are fetched fresh whenever the network is there, so an
// update shows on the next start; the fonts never change at the same address,
// so they come from the cache first.
const CACHE = 'app';

// The fonts the app's own screens draw with in every language it speaks, kept
// when the app is installed, so switching language works without a connection.
// devops/web/fallback_fonts.dart checks that the engine still asks for them.
const UI_FONTS = [
  'roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2',
  'notosansarabic/v28/nwpxtLGrOAZMl5nJ_wfgRg3DrWFZWsnVBJ_sS6tlqHHFlhQ5l3sQWIHPqzCfyGyvvnCBFQLaig.woff2',
  'notosansmath/v15/7Aump_cpkSecTWaHRlH2hyV5UHkD-V048PW0.woff2',
  'notosanssymbols2/v24/I_uyMoGduATTei9eI8daxVHDyfisHr71-vrgfE71.woff2',
  'notosanssc/v37/k3kCo84MPvpLmixcA63oeAL7Iqp5IZJF9bmaG9_FnYkldv7JjxkkgFsFSSOPMOkySAZ73y9ViAt3acb8NexQ2w.87.woff2',
  'notocoloremoji/v32/Yq6P-KqIXTD0t4D9z1ESnKM3-HpFabsE4tq3luCC7p-aXxcn.0.woff2',
  'notocoloremoji/v32/Yq6P-KqIXTD0t4D9z1ESnKM3-HpFabsE4tq3luCC7p-aXxcn.3.woff2',
  'notocoloremoji/v32/Yq6P-KqIXTD0t4D9z1ESnKM3-HpFabsE4tq3luCC7p-aXxcn.7.woff2',
];

self.addEventListener('install', (event) => event.waitUntil((async () => {
  const cache = await caches.open(CACHE);
  // One missing file must not keep the app from installing.
  await Promise.all(['./', ...UI_FONTS.map((font) => `fonts/${font}`)]
    .map((path) => cache.add(path).catch(() => {})));
  await self.skipWaiting();
})()));
self.addEventListener('activate', (event) => event.waitUntil(self.clients.claim()));

self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || url.origin !== self.location.origin) return;
  const fonts = new URL('fonts/', self.registration.scope).pathname;
  event.respondWith(url.pathname.startsWith(fonts) ? cacheFirst(request) : networkFirst(request));
});

async function networkFirst(request) {
  const cache = await caches.open(CACHE);
  try {
    // A page load cannot be refetched with options of its own; every other
    // file is revalidated with the server instead of read from the HTTP cache.
    const response = await (request.mode === 'navigate' ? fetch(request) : fetch(request, { cache: 'no-cache' }));
    if (response.ok) await cache.put(request, response.clone());
    return response;
  } catch (error) {
    const cached = await cache.match(request)
      ?? (request.mode === 'navigate' ? await cache.match(self.registration.scope) : undefined);
    if (cached) return cached;
    throw error;
  }
}

async function cacheFirst(request) {
  const cache = await caches.open(CACHE);
  const cached = await cache.match(request);
  if (cached) return cached;
  const response = await fetch(request);
  if (response.ok) await cache.put(request, response.clone());
  return response;
}
