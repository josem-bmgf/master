import { Injectable } from '@angular/core';
import { Headers, Http } from '@angular/http';
import 'rxjs/add/operator/toPromise';

import { TaxonomyCategory, TaxonomyItem, TaxonomyValue, Taxonomy } from '../models/investments';
import { Constants } from '../models/constants';
import { Helpers } from '../helpers/helpers';

import { Adal4Service, Adal4HTTPService } from 'adal-angular4';

@Injectable()
export class TaxonomyService {
    private header = new Headers({ 'Content-Type': 'application/json' });
    private taxonomyUrl = 'api/Taxonomy';

    constructor(private service: Adal4Service, private http: Adal4HTTPService) { }

    areTaxonomyCategoriesLoaded(): boolean {
        if (Helpers.isNullOrEmpty(sessionStorage[Constants.TAXONOMY_CATEGORIES_SESSION_STORAGE]))
            return false;
    }

    loadTaxonomies(investmentId: number): Promise<TaxonomyCategory[]> {
        if (this.areTaxonomyCategoriesLoaded() === false) {
            return this.getTaxonomyCategories().then(tc => {
                return this.getTaxonomy(investmentId);
            });
        }
        else {
            return this.getTaxonomy(investmentId);
        }
    }

    getTaxonomyFlag(): Promise<boolean> {
        return this.http.get(this.taxonomyUrl + '/GetTaxonomyFlag')
            .toPromise()
            .then(response => response.json() as boolean)
            .catch(this.handleError)
    }

    getTaxonomyCategories(): Promise<TaxonomyCategory[]> {
        return this.http.get(this.taxonomyUrl + '/GetTaxonomyCategories')
            .toPromise()
            .then(response => JSON.stringify(response.json()))
            .then(categories => { sessionStorage[Constants.TAXONOMY_CATEGORIES_SESSION_STORAGE] = categories; })
            .catch(this.handleError)
    }
    
    getTaxonomy(investmentId: number): Promise<TaxonomyCategory[]> {
        
        return this.http.get(this.taxonomyUrl + '/GetTaxonomy?investmentId=' + investmentId)
            .toPromise()
            .then(response => {
                var t = response.json() as Taxonomy[]
                let categories: TaxonomyCategory[] = JSON.parse(sessionStorage[Constants.TAXONOMY_CATEGORIES_SESSION_STORAGE]) as TaxonomyCategory[];
                for (var i = 0; i < categories.length; i++) {
                    categories[i].taxonomy = t.filter(t => t.categoryId == categories[i].id && t.isAllocation);
                    categories[i].total = 0;
                    for (var x = 0; x < categories[i].taxonomy.length; x++) {
                        categories[i].total += categories[i].taxonomy[x].allocation;
                    }
                    categories[i].comments = t.filter(t => t.categoryId == categories[i].id && !t.isAllocation);
                }
                return categories;
            })
            .catch(this.handleError)

    }
    
    saveTaxonomy(taxonomy: Taxonomy[], investmentId: number): Promise<TaxonomyValue[]> {
        var values: TaxonomyValue[];
        values = new Array<TaxonomyValue>();
        for (var i = 0; i < taxonomy.length; i++) {            
            if (taxonomy[i].valueId > 0 || taxonomy[i].allocation > 0 || taxonomy[i].comment) {
                var value = new TaxonomyValue();
                value.investmentId = investmentId;
                value.id = taxonomy[i].valueId;
                value.taxonomyItemId = taxonomy[i].itemId;
                value.numericValue = taxonomy[i].allocation;
                value.value = taxonomy[i].comment;
                values.push(value);
            }
        }
        return this.http.post(this.taxonomyUrl + '/SaveTaxonomy', values)
            .toPromise()
            .then(response => response.json() as TaxonomyValue[])
            .catch(this.handleError);
    }
    
    private handleError(error: XMLHttpRequest): Promise<any> {
        if (error.status == 401) {
            this.service.login();
        }
        console.error('An error occurred', error); // for demo purposes only
        return Promise.reject(error.statusText || error);
    }
}