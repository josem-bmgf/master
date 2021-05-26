import { Component, OnInit } from '@angular/core';
import { Adal4Service, Adal4HTTPService } from 'adal-angular4';

import { LookupService } from '../services/lookup.service';
import { Helpers } from '../helpers/helpers';
import { Constants } from '../models/constants';

@Component({
    selector: 'footer-app',
    templateUrl: './footer.component.html',
    styleUrls: ['./footer.component.css']
})
export class FooterComponent implements OnInit {
    adalService: Adal4Service;
    fraudulentActivityURL: any;
    PrivacyAndCookiesURL: any;
    TermsOfUseURL: any;
    currYear: number = new Date().getFullYear();
    constructor(private service: Adal4Service,
        private lookupService: LookupService) {
        this.adalService = service;
    }

    loadFraudulentActivityLink() {
        if (this.lookupService.isFraudulentActivityURLLoaded() === false) {
            this.lookupService.getFraudulentActivityLink().then(
                sgl => {
                    this.assignFradulentActivityUrl();
                }
            )
        }
        else {
            this.assignFradulentActivityUrl();
        }
    }

    loadPrivacyAndCookiesLink() {
        if (this.lookupService.isPrivacyAndCookiesURLLoaded() === false) {
            this.lookupService.getPrivacyAndCookiesLink().then(
                pgl => {
                    this.assignPrivacyAndCookiesURL();
                }
            )
        }
        else {
            this.assignPrivacyAndCookiesURL();
        }
    }

    loadTermsOfUseLink() {
        if (this.lookupService.isTermsOfUseURLLoaded() === false) {
            this.lookupService.getTermsOfUseLink().then(
                tgl => {
                    this.assignTermsOfUseURL();
                }
            )
        }
        else {
            this.assignTermsOfUseURL();
        }
    }

    ngOnInit() {
        this.loadFraudulentActivityLink();
        this.loadPrivacyAndCookiesLink();
        this.loadTermsOfUseLink();
    }

    assignFradulentActivityUrl() {
        this.fraudulentActivityURL = Helpers.getFraudulentActivityURL(Constants.FRAUDULENT_ACTIVITY_URL_SESSION_STORAGE);
    }
    assignPrivacyAndCookiesURL() {
        this.PrivacyAndCookiesURL = Helpers.getPrivacyAndCookiesURL(Constants.PRIVACY_AND_COOKIES_URL_SESSION_STORAGE);
    }
    assignTermsOfUseURL() {
        this.TermsOfUseURL = Helpers.getTermsOfUseURL(Constants.TERMS_OF_USE_URL_SESSION_STORAGE);
    }
}
