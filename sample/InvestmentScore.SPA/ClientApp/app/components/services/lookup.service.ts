import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';

import { DimensionValues, DimensionCategories } from '../models/investments';
import { Constants } from '../models/constants';
import { Helpers } from '../helpers/helpers';

@Injectable()
export class LookupService {

    private header = new Headers({ 'Content-Type': 'application/json' });
    private lookupUrl = 'api/Lookup';
    
    constructor(private http: Http) {
        if (this.areDimensionsLoaded() === false) {
            this.getDimensionCategories();
        }
        if (this.isPreviewDetailedSlideReportURLLoaded() === false) {
            this.getPreviewReportLink();
        }
        if (this.isFraudulentActivityURLLoaded() === false) {
            this.getFraudulentActivityLink();
        }
        if (this.isPrivacyAndCookiesURLLoaded() === false) {
            this.getPrivacyAndCookiesLink();
        }
        if (this.isTermsOfUseURLLoaded() === false) {
            this.getTermsOfUseLink();
        }
        if (this.isEndOfSeasonLoaded() === false) {
            this.getEndOfSeason();
        }
        if (this.isTestScoreYearLoaded() === false) {
            this.getTestScoreYear();
        }
    }
    
    areDimensionsLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.DIMENSIONS_SESSION_STORAGE]))
            return false;
    }

    isPreviewDetailedSlideReportURLLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.PREVIEW_DETAILED_SLIDE_URL_SESSION_STORAGE]))
            return false;
    }

    isFraudulentActivityURLLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.FRAUDULENT_ACTIVITY_URL_SESSION_STORAGE]))
            return false;
    }

    isPrivacyAndCookiesURLLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.PRIVACY_AND_COOKIES_URL_SESSION_STORAGE]))
            return false;
    }

    isTermsOfUseURLLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.TERMS_OF_USE_URL_SESSION_STORAGE]))
            return false;
    }

    isEndOfSeasonLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.END_OF_SEASON_DATE]))
            return false;
    }

    isTestScoreYearLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.TEST_SCORE_YEAR]))
            return false;
    }

    isMaintenanceNoticeHTMLLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.MAINTENANCE_NOTICE_HTML]))
            return false;
    }

    getPreviewReportLink(): any {
        return this.http.get(this.lookupUrl + '/GetPreviewDetailedSlideReportLink')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(prl => { sessionStorage[Constants.PREVIEW_DETAILED_SLIDE_URL_SESSION_STORAGE] = prl; })
            .catch(this.handleError)
    }

    getFraudulentActivityLink(): any {
        return this.http.get(this.lookupUrl + '/GetFraudulentActivityURL')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(frl => { sessionStorage[Constants.FRAUDULENT_ACTIVITY_URL_SESSION_STORAGE] = frl; })
            .catch(this.handleError)
    }

    getPrivacyAndCookiesLink(): any {
        return this.http.get(this.lookupUrl + '/GetPrivacyAndCookiesURL')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(crl => { sessionStorage[Constants.PRIVACY_AND_COOKIES_URL_SESSION_STORAGE] = crl; })
            .catch(this.handleError)
    }

    getTermsOfUseLink(): any {
        return this.http.get(this.lookupUrl + '/GetTermsOfUseURL')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(trl => { sessionStorage[Constants.TERMS_OF_USE_URL_SESSION_STORAGE] = trl; })
            .catch(this.handleError)
    }

    getDimensionCategories(): any {
        return this.http.get(this.lookupUrl + '/GetDimensionCategories')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(sdv => { sessionStorage[Constants.DIMENSIONS_SESSION_STORAGE] = sdv; })
            .catch(this.handleError)
    }

    getEndOfSeason(): any {
        return this.http.get(this.lookupUrl + '/GetEndSeasonDate')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(eos => { sessionStorage[Constants.END_OF_SEASON_DATE] = eos; })
            .catch(this.handleError)
    }

    getTestScoreYear(): any {
        return this.http.get(this.lookupUrl + '/GetTestScoreYear')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(tsy => { sessionStorage[Constants.TEST_SCORE_YEAR] = tsy; })
            .catch(this.handleError)
    }

    getMaintenanceNoticeHTML(): any {
        return this.http.get(this.lookupUrl + '/GetMaintenanceNoticeHTML')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(sgl => { sessionStorage[Constants.MAINTENANCE_NOTICE_HTML] = sgl; })
            .catch(this.handleError)
    }
    
    private handleError(error: any): Promise<any> {
        console.error('An error occurred', error); // for demo purposes only
        return Promise.reject(error.message || error);
    }
}