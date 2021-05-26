import { Component } from '@angular/core';
import { Adal4Service, Adal4HTTPService } from 'adal-angular4';

import { LookupService } from '../services/lookup.service';
import { Helpers } from '../helpers/helpers';
import { Constants } from '../models/constants';

@Component({
    selector: 'home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.css'],
})
export class HomeComponent {
    MaintenanceNoticeHTML: any;
    // Inject the ADAL Services
    constructor(private service: Adal4Service, private http: Adal4HTTPService, private lookupService: LookupService) { }

    // Check authentication on component load
    ngOnInit() {

        // Handle callback if this is a redirect from Azure
        this.service.handleWindowCallback();

        // Check if the user is authenticated. If not, call the login() method
        if (!this.service.userInfo.authenticated) {
            this.service.login();
        }

        var redirectUrl = sessionStorage.getItem("adal.login.investmentUrl");

        if (redirectUrl != null) {
            location.href = sessionStorage.getItem("adal.login.investmentUrl").toString();
            sessionStorage.removeItem("adal.login.investmentUrl");
        }

        // Log the user information to the console
        //console.log('username ' + this.service.userInfo.username);

        //console.log('authenticated: ' + this.service.userInfo.authenticated);

        //console.log('name: ' + this.service.userInfo.profile.name);

        //console.log('token: ' + this.service.userInfo.token);

        //console.log(this.service.userInfo.profile);

        
        this.loadMaintenanceMessageHTML();
    }

    loadMaintenanceMessageHTML() {
        if (this.lookupService.isMaintenanceNoticeHTMLLoaded() === false) {
            this.lookupService.getMaintenanceNoticeHTML().then(
                sgl => {
                    this.assignMaintenanceNoticeHTML();
                }
            )
        }
        else {
            this.assignMaintenanceNoticeHTML();
        }
    }

    // Logout Method
    public logout() {
        this.service.logOut();
    }

    assignMaintenanceNoticeHTML() {
        this.MaintenanceNoticeHTML = Helpers.getMaintenanceNoticeHTML(Constants.MAINTENANCE_NOTICE_HTML);
        document.getElementById("divMaintenanceNoticeHTML").innerHTML = this.MaintenanceNoticeHTML;
    }
}
