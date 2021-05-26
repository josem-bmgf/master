//import 'angular2-universal-polyfills';
import 'zone.js';
import { createServerRenderer, RenderResult } from 'aspnet-prerendering';
import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { AppModule } from './app/app.module';

enableProdMode();
const platform = platformBrowserDynamic();

export default createServerRenderer(params => {
    return new Promise<RenderResult>((resolve, reject) => {
        const requestZone = Zone.current.fork({
            name: 'angular-universal request',
            properties: {
                baseUrl: '/',
                requestUrl: params.url,
                originUrl: params.origin,
                preboot: false,
                document: '<app></app>'
            },
            onHandleError: (parentZone, currentZone, targetZone, error) => {
                // If any error occurs while rendering the module, reject the whole operation
                reject(error);
                return true;
            }
        });

        return requestZone.run<Promise<string>>(() => platform.bootstrapModule(AppModule)).then(html => {
            resolve({ html: html });
        }, reject);
    });
});
