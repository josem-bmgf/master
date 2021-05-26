import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';

import { Reports, ReportCategories } from '../models/investments';
import { Constants } from '../models/constants';
import { Helpers } from '../helpers/helpers';

@Injectable()
export class ReportService {

    private header = new Headers({ 'Content-Type': 'application/json' });
    private lookupUrl = 'api/Report';
    
    constructor(private http: Http) {
       
    }
    
    areReportsLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.REPORTS_SESSION_STORAGE]))
            return false;
    }
    
    getReports(): Promise<any> {
        return this.http.get(this.lookupUrl + '/GetReports')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(r => { sessionStorage[Constants.REPORTS_SESSION_STORAGE] = r; })
            .catch(this.handleError)
    }
    
    private handleError(error: any): Promise<any> {
        console.error('An error occurred', error); // for demo purposes only
        return Promise.reject(error.message || error);
    }
}