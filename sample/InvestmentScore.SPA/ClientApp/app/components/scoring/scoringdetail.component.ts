import { ChangeDetectionStrategy, Component, Input, OnInit } from '@angular/core';
import { Http, Response, Headers } from "@angular/http";
import { ActivatedRoute, Params } from '@angular/router';
import { Adal4Service, Adal4HTTPService } from 'adal-angular4';

import { Score, User, Investment, DimensionValues, DimensionCategories } from '../models/investments';
import { Constants, FieldLength } from '../models/constants';
import { Helpers } from '../helpers/helpers';
import { InvestmentService } from '../services/investment.service';
import { LookupService } from '../services/lookup.service';

import { BrowserModule } from '@angular/platform-browser';
import { Message } from 'primeng/components/common/api';
import { MessageService } from 'primeng/components/common/messageservice';
import { AutoCompleteModule } from 'primeng/primeng';


@Component({
    selector: 'scoring-detail',
    templateUrl: './scoringdetail.component.html',
    styleUrls: ['./scoringdetail.component.css'],
    providers: [MessageService]
    //pipes: [OrderBy]
})

export class ScoringDetailComponent implements OnInit {
    @Input()
    investment: Investment;
    currentYear: number;
    previousYear: number;
    currentUser: string;
    users: User[];
    enableAddScore: boolean;
    isEditingScore: boolean;
    hideIsExcluded: boolean;

    length: FieldLength;

    endOfSeasonYear: number;
    endOfSeasonDate: any;
    testScoreYear: any;

    //Declare options set
    private optionsPerformanceAgainstExecution: any;
    private optionsPerformanceAgainstStrategy: any;
    private optionsReinvestmentProspects: any;
    private optionsScoreYear: any;

    private selectedScore: Score;
    private backupScore: Score;
    public showScoringModal: boolean;
    public showScoringModalDelete: boolean;

    private setYearDisabled: boolean;    

    msgs: Message[] = [];
    onBehalfOf: User;
    previousOnBehalfOf: User;
    filteredUsers: User[];    

    constructor(
        private investmentService: InvestmentService,
        private route: ActivatedRoute,
        private service: Adal4Service,
        private lookupService: LookupService,
        private messageService: MessageService
    ) {
    }

    ngOnInit() {
        if (this.service.userInfo.authenticated) {
            this.investmentService.getUsers().then((u) => { this.users = u });
            this.investmentService.getCurrentUserId().then((uid) => { this.currentUser = uid });
            this.loadScoreDimensionValues();   
            this.loadEndOfSeasonDate();
            this.loadTestScoreYear();
            this.currentYear = this.testScoreYear != undefined && this.testScoreYear != "" ? this.testScoreYear : (new Date()).getUTCFullYear();
            this.previousYear = this.currentYear - 1;
            this.isEditingScore = false;
            this.hideIsExcluded = true;
            this.endOfSeasonYear = Helpers.formatDate(((new Date()).getUTCMonth() + 1) + "/" + (new Date()).getUTCDate() + "/" + this.currentYear) < Helpers.formatDate(this.endOfSeasonDate + this.currentYear) ? this.currentYear - 1 : this.currentYear;
            this.investmentService.saveInvestmentScoreFromStorage()
                .then(score => {

                    var redirectUrl = sessionStorage.getItem("adal.login.investmentUrl");

                    if (redirectUrl != null && window.location.href !== redirectUrl) {
                        location.href = sessionStorage.getItem("adal.login.investmentUrl").toString();
                        sessionStorage.removeItem("adal.login.investmentUrl");
                    }
                    this.handleSaveSuccessfulFromCache(score);
                })
                .catch(this.handleError);
        } else {
            this.messageService.add({ severity: 'warning', summary: 'Connection Lost', detail: 'Attempting to reconnect' });
        }
    }


    loadScoreDimensionValues() {
        if (this.lookupService.areDimensionsLoaded() === false) {
            this.lookupService.getDimensionCategories().then(
                sdc => {
                    this.assignDimensionOptions();
                }
            )
        }
        else {
            this.assignDimensionOptions();
        }
    }

    loadEndOfSeasonDate() {
        
        if (this.lookupService.isEndOfSeasonLoaded() === false) {
            this.lookupService.getEndOfSeason().then(
                sdc => {
                    this.assignEndOfSeasonDate();
                }
            )
        }
        else {
            this.assignEndOfSeasonDate();
        }
        
    }

    loadTestScoreYear() {

        if (this.lookupService.isTestScoreYearLoaded() === false) {
            this.lookupService.getTestScoreYear().then(
                tsy => {
                    this.assignTestScoreYear();
                }
            )
        }
        else {
            this.assignTestScoreYear();
        }

    }

    assignDimensionOptions() {
        this.optionsPerformanceAgainstExecution = Helpers.getDimensionValuesByCategory(Constants.PERFORMANCE_AGAINST_EXECUTION);
        this.optionsPerformanceAgainstStrategy = Helpers.getDimensionValuesByCategory(Constants.PERFORMANCE_AGAINST_STRATEGY);
        this.optionsReinvestmentProspects = Helpers.getDimensionValuesByCategory(Constants.REINVESTMENT_PROSPECTS);
    }

    assignScoreYearOptions() {
        if (this.investment.scores.filter(s => s.scoreYear == this.previousYear && !s.isArchived).length == 0
            && this.investment.scores.filter(s => s.scoreYear == this.currentYear && !s.isArchived).length == 0
            && this.previousYear == this.endOfSeasonYear)
        {
            this.optionsScoreYear = [this.currentYear, this.previousYear];
            this.selectedScore.scoreYear = this.previousYear;
        }
        else if (this.investment.scores.filter(s => s.scoreYear == this.previousYear && !s.isArchived).length > 0
            || this.currentYear <= this.endOfSeasonYear) {
            this.optionsScoreYear = [this.currentYear];  
            this.selectedScore.scoreYear = this.currentYear;
        }
        else if (this.investment.scores.filter(s => s.scoreYear == this.currentYear && !s.isArchived).length > 0
            || this.previousYear <= this.endOfSeasonYear) {
            this.optionsScoreYear = [this.previousYear];
            this.selectedScore.scoreYear = this.previousYear;
        }
        
    }

    assignEndOfSeasonDate() {
        this.endOfSeasonDate = Helpers.getEndOfSeasonDate(Constants.END_OF_SEASON_DATE);
    }

    assignTestScoreYear() {
        this.testScoreYear = Helpers.getTestScoreYear(Constants.TEST_SCORE_YEAR);
    }

    searchUsersByField(fieldName: string, id: string): User {
        if (this.users != undefined || this.users != null)
            for (var i = 0; i < this.users.length; i++) {
                if (
                    (fieldName == "id" && this.users[i].id == id) ||
                    (fieldName == "name" && (this.users[i].displayName.toLowerCase().indexOf(this.selectedScore.scoredBy.toLowerCase()) == 0))
                ) {
                    return this.users[i];
                }
            }

        return null;
    }

    searchUsersById(id: string) {
        let searchedUser: User = this.searchUsersByField("id", id);
        this.selectedScore.scoredById = searchedUser.id;
        this.selectedScore.scoredBy = searchedUser.displayName;
        this.selectedScore.user = searchedUser.displayName;
        this.onBehalfOf = this.searchUsersByField("name", "0");        
    }

    searchUsersByName() {
        if (this.filteredUsers.length > 0) {
            this.selectedScore.scoredById = this.filteredUsers[0].id;
            this.selectedScore.scoredBy = this.filteredUsers[0].displayName;
            this.selectedScore.user = this.filteredUsers[0].displayName;
            this.onBehalfOf = this.filteredUsers[0];
        }
        else {
            this.selectedScore.scoredById = this.backupScore.scoredById;
            this.selectedScore.scoredBy = this.backupScore.scoredBy;
            this.selectedScore.user = this.backupScore.user;
            this.onBehalfOf = this.previousOnBehalfOf;
        }
    }

    isYearDisabled() {
        //set the year filter to disabled on edit. Enabled on Add New
        if (this.setYearDisabled) {
            return true;
        }
        return false;
    }
    
    isSaveDisabled() {
        if (this.isScoreArchived() || this.isScoreInEndofSeason())
            return true;

        if (Helpers.isNullOrEmpty(this.selectedScore.performanceAgainstStrategy)
            || Helpers.isNullOrEmpty(this.selectedScore.performanceAgainstMilestones)
            || Helpers.isNullOrEmpty(this.selectedScore.reinvestmentProspects)
            || Helpers.isNullOrEmpty(this.selectedScore.keyResultsData)
            || Helpers.isNullOrEmpty(this.selectedScore.rationale)) {
            return true;
        }

        return false;
    }

    getMaxLength(id: string): number {

        return Helpers.getMaxLength(id);
    }

    isScoreArchived() {
        if (!Helpers.isNullOrEmpty(this.selectedScore.isArchived)
            && this.selectedScore.isArchived == true) {
            return true;
        }

        return false;
    }

    isScoreInEndofSeason() {
        if (!Helpers.isNullOrEmpty(this.selectedScore.isScoreInEndOfSeason)
            && this.selectedScore.isScoreInEndOfSeason == true) {
            return true;
        }

        return false;
    }

    isScoringDisabled() {
        if (this.isScoreArchived() || this.isScoreInEndofSeason())
            return true;
    }

    //Add score
    addScore() {
        this.selectedScore = new Score();
        this.backupScore = new Score();
        this.selectedScore.investmentId = this.investment.id;
        this.selectedScore.isArchived = false;
        this.selectedScore.isScoreInEndOfSeason = false;
        this.searchUsersById(this.currentUser);
        this.assignScoreYearOptions();
        this.isEditingScore = false;
        this.hideIsExcluded = false;
        this.showScoringModal = true;
    }

    //Edit Score
    editScore(scoreId) {
        this.delay(2000);
        this.isEditingScore = true;        
        this.showScoringModal = true;
        this.backupScore = Object.assign({}, (this.investment.scores.filter(s => s.id === scoreId)[0]));
        this.backupScore.fundingTeamInput = this.backupScore.fundingTeamInput != null ? this.backupScore.fundingTeamInput : null;
        this.selectedScore = this.investment.scores.filter(s => s.id === scoreId)[0]; 
        this.selectedScore.scoredBy = this.selectedScore.user;
        this.selectedScore.isScoreInEndOfSeason = this.selectedScore.scoreYear < this.endOfSeasonYear ? true : false;
        this.hideIsExcluded = this.selectedScore.isArchived || this.selectedScore.isScoreInEndOfSeason ? true : false;
        this.onBehalfOf = this.searchUsersByField("name", "0");
        this.previousOnBehalfOf = this.searchUsersByField("name", "0");
        let createdBy = this.searchUsersByField("id", this.selectedScore.createdById);
        let modifiedBy = this.searchUsersByField("id", this.selectedScore.modifiedById);
        this.selectedScore.createdBy = createdBy != null ? createdBy.displayName : null;
        this.selectedScore.modifiedBy = modifiedBy != null ? modifiedBy.displayName : null;
        this.selectedScore.fundingTeamInput = this.selectedScore.fundingTeamInput != null ? this.selectedScore.fundingTeamInput : null;

    }

    //Delete Score
    deleteScore(score) {
        this.showScoringModalDelete = true;
        this.selectedScore = Object.assign({}, score)

    }

    confirmDeleteScore() {
        this.msgs = [];
        this.investmentService.deleteInvestmentScore(this.selectedScore.id)
            .then(response => {
                let score = this.investment.scores.filter(s => s.id === this.selectedScore.id);
                this.investment.scores.splice(this.investment.scores.indexOf(score[0]), 1)
                this.messageService.add({ severity: 'success', summary: 'Success Message', detail: 'Score has been deleted' })
            });
    }

    isOverLimitKeyResults() {
        if (this.selectedScore.keyResultsData)
            return this.selectedScore.keyResultsData.split(/\n/).length > 15; 
        else false;
    }

    delay(ms: number) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    isOverLimitRationale() {
        
        if (this.selectedScore.rationale) {

            return document.getElementById("comment").scrollHeight > 302;
        }
        else false;     
    }

    isOverLimitFundingTeam() {
        if (this.selectedScore.fundingTeamInput)
            return this.selectedScore.fundingTeamInput.split(/\n/).length > 5;
        else false;
    }

    cancelScore() {
        Object.assign(this.selectedScore, this.backupScore); 
    }

    isScored() {
        if (this.investment === undefined || this.investment.scores === undefined ||
            this.investment === null || this.investment.scores === null)
            return false;

        // There needs to be a score present for the current and previous year
        if (this.investment.scores.filter(s => s.scoreYear == this.currentYear && !s.isArchived).length > 0
            && this.investment.scores.filter(s => s.scoreYear == this.previousYear && !s.isArchived).length > 0)
            return true;

        if ((this.investment.scores.filter(s => s.scoreYear == this.currentYear && !s.isArchived).length > 0 && this.currentYear == this.endOfSeasonYear)
            && (this.investment.scores.filter(s => s.scoreYear == this.previousYear && !s.isArchived).length == 0 && this.previousYear <= this.endOfSeasonYear)) {
            return true;
        }

        if ((this.investment.scores.filter(s => s.scoreYear == this.currentYear && !s.isArchived).length == 0 && this.currentYear == this.endOfSeasonYear)
            && (this.investment.scores.filter(s => s.scoreYear == this.previousYear && !s.isArchived).length > 0 && this.previousYear <= this.endOfSeasonYear)) {
            return false;
        }

        return false;
    }

    cancelDeleteScore() {
    }

    saveScore(score) {
        sessionStorage.setItem("adal.login.investmentUrl", window.location.href);
        this.investmentService.saveInvestmentScore(score)
            .then(score => {
                this.handleSaveSuccessful(score);
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

    handleSaveSuccessfulFromCache(score: Score) {

        var localScore = this.investment.scores.filter(s => s.id === score.id);
        if (localScore.length === 0) {
            this.investment.scores.push(score);
            this.messageService.add({ severity: 'success', summary: 'Success Message', detail: 'Score has been created' });

            this.investment.scores.sort((a: Score, b: Score) => {
                if (a.scoreYear < b.scoreYear) {
                    return 1;
                } else if (a.scoreYear > b.scoreYear) {
                    return -1;
                } else {
                    return 0;
                }
            });
        }
        else {
            Object.assign(localScore[0], score);
            this.messageService.add({ severity: 'success', summary: 'Success Message', detail: 'Score has been updated' });
        }
    }
    handleSaveSuccessful(score: Score) {

        var localScore = this.investment.scores.filter(s => s.id === score.id);
        if (this.selectedScore !== null
            && (this.selectedScore.id === undefined || this.selectedScore.id === 0)) {

            this.selectedScore.id = score.id;
            this.investment.scores.push(score);
            this.messageService.add({ severity: 'success', summary: 'Success Message', detail: 'Score has been created' });

            this.investment.scores.sort((a: Score, b: Score) => {
                if (a.scoreYear < b.scoreYear) {
                    return 1;
                } else if (a.scoreYear > b.scoreYear) {
                    return -1;
                } else {
                    return 0;
                }
            });
        }
        else {
            Object.assign(localScore[0], score);
            this.messageService.add({ severity: 'success', summary: 'Success Message', detail: 'Score has been updated' });
        }
    }

    getScoreNameOnly(score: string, isExcluded: boolean) {
        if (isExcluded == true)
            return "Excluded";

        if (Helpers.isNullOrEmpty(score))
            return "";

        if (!score.includes(' - '))
            return score;

        return score.substring(0, score.indexOf(' - '));

    }

    convertUTCToLocal(date) {
        if (Helpers.isNullOrEmpty(date))
            return "";

        return Helpers.convertUTCToLocal(date);
    }

    flagCharacterCountIndicator(id: string, input: string): boolean {
            return Helpers.flagCharacterCountIndicator(id, input);
    }

    getModifiedDate(score) {
        if (score.modifiedOn === null || score.modifiedOn === undefined)
            return this.convertUTCToLocal(score.scoreDate);
        return this.convertUTCToLocal(score.modifiedOn);
    }

    handleError(error) {
        //this.messageService.add({ severity: 'error', summary: 'Error Encountered', detail: 'Retrying Save' })
        //this.investmentService.saveInvestmentScoreFromStorage().then(this.handleSaveSuccessful);
    }

    filterUsers(event) {
        let query = event.query;
        this.filteredUsers = this.filterUserSelection(query, this.users);
    }

    filterUserSelection(query, users: User[]): User[] {
        let filtered: User[] = [];
        for (let i = 0; i < users.length && filtered.length < 5; i++) {
            let user: User = users[i];
            if (user.displayName.toLowerCase().indexOf(query.toLowerCase()) >= 0) {
                filtered.push(user);
            }
        }
        return filtered;
    }

    updateOnBehalfOf(event: User, eventName: string) {
        if (eventName == "onSelect") {
            let searchedUser: User = this.onBehalfOf != null ? this.onBehalfOf : event;
            this.selectedScore.scoredById = searchedUser.id;
            this.selectedScore.scoredBy = searchedUser.displayName;
            this.selectedScore.user = searchedUser.displayName;
        }
        else if ((eventName == "onBlur") && this.filteredUsers.length == 0) {
            this.selectedScore.scoredById = this.backupScore.scoredById;
            this.selectedScore.scoredBy = this.backupScore.scoredBy;
            this.selectedScore.user = this.backupScore.user;
        }
    }
    
    disableControlsWhenExcluded() {
        if (this.selectedScore.isExcluded)
            return true;
        return false;
    }
  
    getScoredBy(score: Score) { 
        let searchedUser: User = this.searchUsersByField("id", score.modifiedById != null || score.modifiedById != "" ? score.modifiedById : score.scoredById);
        return score.isExcluded ? searchedUser.displayName : score.user;
    }

    isSaveDisabledWhenExcluded() {
        if (this.isSaveDisabled() && this.selectedScore.isExcluded && !this.isScoreInEndofSeason())
            return !this.isSaveDisabled();
        return this.isSaveDisabled();    
    }     

    isScoredOnEndOfSeason(scoreYear: number, scoreArchived : boolean) {
        if ((scoreYear >= this.endOfSeasonYear) && scoreArchived == false)
            return true;
        return false;        
    }

}