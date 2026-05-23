// BovinoCheck AI Pro — Service Worker V7.5
// Estrategia: cache-first para app shell + network-first para Gemini API
// No cacheamos las llamadas a Gemini (datos clínicos, cambiantes)

const CACHE_VERSION = 'bovinocheck-v7.5.0';
const APP_SHELL = [
  './',
  './v7.5.html',
  './manifest.json',
  './icon.svg',
  'https://cdn.tailwindcss.com',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css',
  'https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js',
  'https://cdn.jsdelivr.net/npm/chart.js',
  'https://cdn.jsdelivr.net/npm/idb@8/build/umd.js'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_VERSION).then((cache) => {
      return Promise.allSettled(
        APP_SHELL.map((url) =>
          cache.add(url).catch((err) => console.warn('[SW] Skip cache:', url, err))
        )
      );
    }).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);

  // Network-only para Gemini API (datos clínicos sensibles)
  if (url.hostname.includes('generativelanguage.googleapis.com')) {
    return;
  }

  // Cache-first para todo lo demás
  event.respondWith(
    caches.match(event.request).then((cached) => {
      if (cached) return cached;
      return fetch(event.request).then((response) => {
        if (response.ok && event.request.method === 'GET') {
          const responseClone = response.clone();
          caches.open(CACHE_VERSION).then((cache) => {
            cache.put(event.request, responseClone).catch(() => {});
          });
        }
        return response;
      }).catch(() => {
        // Offline fallback
        if (event.request.mode === 'navigate') {
          return caches.match('./v7.5.html');
        }
      });
    })
  );
});
