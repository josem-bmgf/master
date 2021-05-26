import 'rxjs/add/operator/switchMap';
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { Location } from '@angular/common';
import { Adal4Service, Adal4HTTPService } from 'adal-angular4';
import { Constants, FieldLength } from '../models/constants';
import { Helpers } from '../helpers/helpers';
import { Investment, UserDivision, TaxonomyCategory, TaxonomyItem, Taxonomy } from '../models/investments';
import { InvestmentService } from '../services/investment.service';
import { TaxonomyService } from '../services/taxonomy.service';
import { ButtonModule, TabViewModule } from 'primeng/primeng';
import { LookupService } from '../services/lookup.service';
import { MessageService } from 'primeng/components/common/messageservice';

@Component({
    selector: 'investment-detail',
    templateUrl: './investmentdetail.component.html',
    styleUrls: ['./investmentdetail.component.css'],
    providers: [MessageService]
})

export class InvestmentDetailComponent implements OnInit {
    investment: Investment;
    categories: TaxonomyCategory[];
    PreviewDetailedSlideReportURL: any;

    public showExcludeModal: boolean;
    public excludeChecked: boolean;

    constructor(
        private investmentService: InvestmentService,
        private taxonomyService: TaxonomyService,
        private route: ActivatedRoute,
        private location: Location,
        private service: Adal4Service,
        private http: Adal4HTTPService,
        private lookupService: LookupService,        
        private messageService: MessageService
    ) {
        this.investment = new Investment();
    }

    loadPreviewReportLink() {
        if (this.lookupService.isPreviewDetailedSlideReportURLLoaded() === false) {
            this.lookupService.getPreviewReportLink().then(
                sgl => {
                    this.assignPreviewDetailedSlideReportURL();
                }
            )
        }
        else {
            this.assignPreviewDetailedSlideReportURL();
        }
    }

    ngOnInit() {             
        this.loadPreviewReportLink();
        this.route.params
            .switchMap((params: Params) => this.investmentService.getInvestment(+params['id']))
            .subscribe(investment => {
                this.investment = investment;
                var btnAddScore = document.getElementById('btnAddScore');
                if (btnAddScore != null) {
                    btnAddScore.setAttribute("disabled", "disabled");
                    btnAddScore.innerHTML = "Loading";
                }
                this.taxonomyService.getTaxonomyFlag().then(
                    d => {
                        if (d) {
                            this.taxonomyService.loadTaxonomies(this.investment.id).then(t => this.categories = t)
                                .then(function () {
                                var btnAddScore = document.getElementById('btnAddScore');
                                if (btnAddScore != null)
                                {
                                    btnAddScore.removeAttribute("disabled");
                                    btnAddScore.innerHTML = "Add New";
                                }
                            });
                        }
                        else {
                            var btnAddScore = document.getElementById('btnAddScore');
                            if (btnAddScore != null) {
                                btnAddScore.removeAttribute("disabled");
                                btnAddScore.innerHTML = "Add New";
                            }
                        }
                    });
            });
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.FIELD_LENGTH_SESSION_STORAGE]) === true) {
            this.investmentService.getFieldLengthProperties();
        }    
    }
    assignPreviewDetailedSlideReportURL() {
        this.PreviewDetailedSlideReportURL = Helpers.getPreviewDetailedSlideReportURL(Constants.PREVIEW_DETAILED_SLIDE_URL_SESSION_STORAGE);
    }

    showExclude(investment, value: boolean) {
        this.showExcludeModal = true;
    }

    confirmExclude() {              
        this.saveInvestment(this.investment);
    }

    saveInvestment(investment) {
        sessionStorage.setItem("adal.login.investmentUrl", window.location.href);
        this.investmentService.saveInvestment(investment)
            .then(score => {
                this.handleSaveSuccessful(investment);
            })
            .catch(error => {
                this.messageService.add({
                    severity: 'warn',
                    summary: 'Session Expired',
                    detail: 'We are reconnecting to the server to save your changes.'
                });
                setTimeout(() => {
                    this.service.login();
                }, 3000);
            });
    }

    handleSaveSuccessful(investment: Investment ) {
        var localInvestment = this.investment;        
        Object.assign(localInvestment, investment);
        this.messageService.add({ severity: 'success', summary: 'Success Message', detail: 'Investment has been updated' });        
    }
}