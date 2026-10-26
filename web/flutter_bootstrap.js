{{flutter_js}}
{{flutter_build_config}}

// The app starts once the offline worker (sw.js) controls the page, so even
// the files of the very first visit are kept for use without a connection.
// The fonts for characters the app's own fonts lack are served from the
// app's fonts/ folder instead of a font CDN, so the app loads nothing from
// other hosts.
(async () => {
  if ('serviceWorker' in navigator) {
    try {
      await navigator.serviceWorker.register('sw.js');
      if (!navigator.serviceWorker.controller) {
        await new Promise((resolve) => {
          navigator.serviceWorker.addEventListener('controllerchange', resolve, { once: true });
          setTimeout(resolve, 4000);
        });
      }
    } catch (e) {
      console.warn('The app will not work offline:', e);
    }
  }
  _flutter.loader.load({
    config: { fontFallbackBaseUrl: new URL('fonts/', document.baseURI).href },
  });
})();
