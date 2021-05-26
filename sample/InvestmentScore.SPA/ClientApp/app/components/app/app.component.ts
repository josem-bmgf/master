import { Component } from '@angular/core';
import { Headers, Http } from '@angular/http';
import { Router, RouterModule } from '@angular/router';
import { Adal4Service } from 'adal-angular4';
import adal from 'adal-angular';


import { LookupService } from '../services/lookup.service';

const config: any = {                                       // <-- ADD
    tenant: document.getElementById('tenant').getAttribute('value'),                       // <-- ADD
    clientId: document.getElementById('clientId').getAttribute('value')
}  

@Component({
    selector: 'app',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css']
}) 

export class AppComponent {
    constructor(private service: Adal4Service, private router: Router, private http: Http, private lookupService: LookupService) {      // <-- ADD
        this.service.init(config); // <-- ADD
    }
    //Style of the Contents when in the Report's table
    styleReportDiv = {
        'width': '100%'
    }
    styleReportBody = {
        'margin': '0 auto',
        'width': '75%'
    }
    //Show or Hide the Searchbox when the Report button was clicked
    hideShowSearchbox() {
        //if (this.router.url === '/fetch-data')
        /*
        if (this.router.url.startsWith('/report',0)) {
            return false;
        }
        else return true;
        */
        return true
    }
    //Alignment and Style when in the Report's Table
    bodyContentStyle() {
        //if (this.router.url === '/report')
        /*
        if (this.router.url.startsWith('/report', 0)) {
            return this.styleReportBody;
        }
        */
    }
    divContentStyle() {
        //if (this.router.url === '/fetch-data')
        /*
        if (this.router.url.startsWith('/report', 0)) {
            return this.styleReportDiv;
        }
        */
    }
}