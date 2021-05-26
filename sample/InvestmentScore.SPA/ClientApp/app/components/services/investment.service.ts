import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';

import { Investment, UserDivision, Score } from '../models/investments';
import { FieldLength, Constants } from '../models/constants';
import { Adal4Service, Adal4HTTPService } from 'adal-angular4';

@Injectable()
export class InvestmentService {

    private headers = new Headers({ 'Content-Type': 'application/json' });
    private investmentUrl = 'api/Investment';  // URL to web api

    constructor(private http: Adal4HTTPService, private service: Adal4Service, ) { }

    searchInvestments(term: string): Promise<Investment[]> {
        return this.http.get(this.investmentUrl + '/Search?term=' + term)
            .toPromise()
            .then(response => response.json() as Investment[])
            .catch(this.handleError)
    }

    getInvestment(id: number): Promise<Investment> {
        return this.http.get(this.investmentUrl + '/Get?id=' + id)
            .toPromise()
            .then(response => response.json() as Investment)
            .catch(this.handleError)
    }

    deleteInvestmentScore(id: number): Promise<boolean> {
        return this.http.get(this.investmentUrl + '/DeleteScore?id=' + id)
            .toPromise()
            .then(response => response.json() as boolean)
            .catch(this.handleError)
    }

    getUsers() {
        return this.http.get(this.investmentUrl + '/GetUsers')
            .toPromise()
            .then(response => response.json())
            .catch(this.handleError)
    }

    getCurrentUserId() {
        return this.http.get(this.investmentUrl + '/GetCurrentUserID')
            .toPromise()
            .then(response => response.json())
            .catch(this.handleError)
    }

    getFieldLengthProperties() {
        return this.http.get(this.investmentUrl + '/FieldLengthProperties')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(length => { sessionStorage[Constants.FIELD_LENGTH_SESSION_STORAGE] = length; })
            .catch(this.handleError)
    }

    saveInvestment(investment: Investment): Promise<Investment> {
        this.service.refreshDataFromCache();
        return this.http.post(this.investmentUrl + '/SaveInvestment', investment)
            .toPromise()
            .then(response => {
                return response.json() as Investment;
            })
            .catch(err => { return this.handleError(err); })
    }

    saveInvestmentScore(score: Score): Promise<Score> {
        this.service.refreshDataFromCache();
        localStorage.setItem("ScoreToSave", JSON.stringify(score));
        return this.http.post(this.investmentUrl + '/SaveScore', score)
            .toPromise()
            .then(response => {
                localStorage.removeItem("ScoreToSave");
                return response.json() as Score;
            })
            .catch(err => { return this.handleError(err); })
    }

    saveInvestmentScoreFromStorage(): Promise<Score> {
        var score: Score = JSON.parse(localStorage.getItem("ScoreToSave"));

        if (score) {
            return this.http.post(this.investmentUrl + '/SaveScore', score)
                .toPromise()
                .then(response => {
                    localStorage.removeItem("ScoreToSave");
                    return response.json() as Score;
                })
                .catch(this.handleError)
        }
        else {
            return Promise.reject("No cached score")
        }
    }

    private handleError(error: XMLHttpRequest): Promise<any> {
        return Promise.reject(error.statusText || error);
    }
}