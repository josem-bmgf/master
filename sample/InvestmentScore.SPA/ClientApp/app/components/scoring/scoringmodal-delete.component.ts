import { Component, Input } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';

import { InvestmentService } from '../services/investment.service';

@Component({
})

export class ScoringModalDelete {
    @Input()
    selectedScore: any;

    constructor(
        private investmentService: InvestmentService
    ) {

    }

    deleteScore() {
        this.investmentService.deleteInvestmentScore(this.selectedScore.id).then(function () { });
    }
}