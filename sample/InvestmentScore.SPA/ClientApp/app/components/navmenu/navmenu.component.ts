import { Component } from '@angular/core';
import { Adal4Service } from 'adal-angular4';

@Component({
    selector: 'nav-menu',
    templateUrl: './navmenu.component.html',
    styleUrls: ['./navmenu.component.css']
})
export class NavMenuComponent {
    adalService: Adal4Service;

    constructor(private service: Adal4Service) {
        this.adalService = service;
    }
}
