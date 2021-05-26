import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { Http, JsonpModule, HttpModule } from '@angular/http';
import { BrowserModule } from '@angular/platform-browser';

import { AppComponent } from './components/app/app.component'
import { NavMenuComponent } from './components/navmenu/navmenu.component';
import { HomeComponent } from './components/home/home.component';
import { FooterComponent } from './components/footer/footer.component';
import { NotFoundComponent } from './components/notfound/notfound.component';

//import { FetchDataComponent } from './components/fetchdata/fetchdata.component';
//import { ReportComponent } from './components/report/report.component';
import { CounterComponent } from './components/counter/counter.component';
import { InvestmentSearchComponent } from './components/investment/investmentsearch.component';
import { InvestmentDetailComponent } from './components/investment/investmentdetail.component';
import { InvestmentTaxonomyComponent } from './components/investment/investmenttaxonomy.component';
import { ScoringDetailComponent } from './components/scoring/scoringdetail.component';

//Services
import { InvestmentService } from './components/services/investment.service';
import { LookupService } from './components/services/lookup.service';
import { ReportService } from './components/services/report.service';
import { TaxonomyService } from './components/services/taxonomy.service';
import { MessageService } from 'primeng/components/common/messageservice';


import { Adal4Service, Adal4HTTPService } from 'adal-angular4';        

import {
    InputTextModule,
    ButtonModule,
    SpinnerModule,
    DataTableModule,
    DialogModule,
    GrowlModule,
    TabViewModule,
    CheckboxModule,
    AutoCompleteModule
} from 'primeng/primeng';


@NgModule({
    bootstrap: [AppComponent],
    declarations: [
        AppComponent,
        NavMenuComponent,
        FooterComponent,
        CounterComponent,
        //ReportComponent,
        HomeComponent,
        NotFoundComponent,
        InvestmentSearchComponent,
        InvestmentDetailComponent,
        InvestmentTaxonomyComponent,
        ScoringDetailComponent
    ],
    imports: [
        BrowserModule, // Must be first import. This automatically imports BrowserModule, HttpModule, and JsonpModule too.
        HttpModule,
        JsonpModule,
        FormsModule,
        GrowlModule,
        ButtonModule,
        TabViewModule,
        SpinnerModule,
        CheckboxModule,
        AutoCompleteModule,
        RouterModule.forRoot([
            { path: '', redirectTo: 'home', pathMatch: 'full' },
            { path: 'home', component: HomeComponent },
            { path: 'counter', component: CounterComponent },
            //{ path: 'report', component: ReportComponent },
            { path: 'investment-search', component: InvestmentSearchComponent },
            { path: 'investment-detail/:id', component: InvestmentDetailComponent },
            { path: '**', component: NotFoundComponent },
            { path: '**', redirectTo: 'home' }
        ])
    ],
    providers: [InvestmentService,
        TaxonomyService,
        ReportService,
        LookupService,
        Adal4Service,
        {
            provide: Adal4HTTPService,
            useFactory: Adal4HTTPService.factory,
            deps: [Http, Adal4Service]
        }]
})
export class AppModule {
}
