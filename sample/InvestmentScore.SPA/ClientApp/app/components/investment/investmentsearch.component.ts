import { Component, OnInit } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import { Investment } from '../models/investments'
import { InvestmentService } from '../services/investment.service'
import { Helpers } from '../helpers/helpers';
import { Adal4Service, Adal4HTTPService } from 'adal-angular4';
import { CheckboxModule } from 'primeng/primeng';

import { Observable } from 'rxjs/Observable';
import { Subject } from 'rxjs/Subject';

// Observable operators
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/debounceTime';
import 'rxjs/add/operator/distinctUntilChanged';

@Component({
    selector: 'investment-search',
    templateUrl: './investmentsearch.component.html',
    styleUrls: ['./investmentsearch.component.css'],
    providers: [InvestmentService]
})

export class InvestmentSearchComponent implements OnInit {
    private values: Observable<Investment[]>;
    private stringValue: string;
    private term: string;
    private defaultTabId: string;
    isLoading: boolean;
    directURL: boolean;
    private selectedInvestmentId: number;
    private overFiveMillion: boolean;
    private searchTerms = new Subject<string>();
    private showSearchOptions: boolean;    

    constructor(private investmentService: InvestmentService, private service: Adal4Service) {
        
    }

    ngOnInit() {
        // Handle callback if this is a redirect from Azure
        this.service.handleWindowCallback();
        // Check if the user is authenticated. If not, call the login() method
        if (!this.service.userInfo.authenticated) {
            this.service.login();
        }

        this.values = this.searchTerms
            .debounceTime(300)
            .distinctUntilChanged() 
            .switchMap(term => term
                ? this.investmentService.searchInvestments(term)
                : Observable.of<Investment[]>([]))
            .catch(error => {
                // TODO: add real error handling                
                return Observable.of<Investment[]>([]);
            });
    }

    onSearch() {
        //Show and hide the help text when the term search box empty.
        if (this.term.length > 0) {             
            this.showSearchOptions = true;  
            var searchKey = Helpers.replaceCharactersToASCII(this.term);
            this.searchTerms.next(searchKey + '&overFiveMillion=' + this.overFiveMillion);
        }
        else {
            this.showSearchOptions = false;
        }
    }

    selectInvestmentId(id: number) {
        this.selectedInvestmentId = id;
    }

    onSearchKeyUp(event: KeyboardEvent) {
        this.onSearch();
    }
}
