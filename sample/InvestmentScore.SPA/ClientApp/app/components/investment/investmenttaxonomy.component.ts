import { Component, OnInit, Input } from '@angular/core';
import { Http, Response, Headers } from '@angular/http';
import { FormsModule } from '@angular/forms';

import { Constants, FieldLength } from '../models/constants';
import { Helpers } from '../helpers/helpers'
import { Investment, TaxonomyCategory } from '../models/investments'
import { TaxonomyService } from '../services/taxonomy.service'
import { BrowserModule } from '@angular/platform-browser';
import { GrowlModule, Message, SpinnerModule } from 'primeng/primeng';

@Component({
    selector: 'investment-taxonomy',
    templateUrl: './investmenttaxonomy.component.html',
    styleUrls: ['./investmenttaxonomy.component.css']
})

export class InvestmentTaxonomyComponent implements OnInit {
    @Input() category: TaxonomyCategory;
    @Input() investmentId: number;
    saveDisabled: boolean;
    msgs: Message[] = [];

    originalTaxonomy: any;

    constructor(private taxonomyService: TaxonomyService) {
    }

    ngOnInit() {
        this.originalTaxonomy = JSON.stringify(this.category);
        this.computeTotal();
        this.saveDisabled = true;
    }

    isSaveDisabled() {
        return this.saveDisabled;
    }

    onSave() {
        this.msgs = [];
        this.taxonomyService.saveTaxonomy(this.category.taxonomy, this.investmentId)
            .then(values => {
                this.msgs.push({ severity: 'success', summary: 'Success Message', detail: 'Taxonomy has been updated' })
                for (var i = 0; i < values.length; i++) {
                    for (var x = 0; x < this.category.taxonomy.length; x++) {
                        if (this.category.taxonomy[x].itemId == values[i].taxonomyItemId) {
                            this.category.taxonomy[x].valueId = values[i].id;
                        }
                    }
                }
                this.originalTaxonomy = JSON.stringify(this.category);
                this.saveDisabled = true;
            });
        this.taxonomyService.saveTaxonomy(this.category.comments, this.investmentId);

    }

    isTaxonomyDirty() {
        if (JSON.stringify(this.category) === this.originalTaxonomy) {
            this.saveDisabled = true;
        }
    }

    onCancel() {
        this.saveDisabled = true;
        this.taxonomyService.loadTaxonomies(this.investmentId).then(c =>
            this.category = c.find(cat => cat.id === this.category.id)
        );
    }

    computeTotal() {

        var sum: number;
        sum = 0;
        var disabled: boolean = false;
        for (var i = 0; i < this.category.taxonomy.length; i++) {
            sum = sum + this.category.taxonomy[i].allocation;
            if (this.category.taxonomy[i].allocation > 100 || this.category.taxonomy[i].allocation < 0) {
                disabled = true;
            }
        }
        if (sum == 100) {
            this.saveDisabled = disabled;
        }
        else {
            this.saveDisabled = true;
        }
        this.category.total = sum;
        
    }


    restrictToNumbers(event: any) {
        const pattern = new RegExp('^[0-9]*$');
        const inputChar = String.fromCharCode(event.key ? event.which : event.key);
        const value = (event.target.value) + inputChar;
        if (!pattern.test(inputChar) || !pattern.test(value)) {
            event.preventDefault();
            return false;
        }

    }

    onTaxonomyValueChange() {
        this.computeTotal();
        this.isTaxonomyDirty();
    }


    getMaxLength(id: string): number {
        return Helpers.getMaxLength(id);
    }

    flagCharacterCountIndicator(id: string, input: string): boolean {
        return Helpers.flagCharacterCountIndicator(id, input);
    }
}