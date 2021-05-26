import { Constants, FieldLength, FISLink, DateReference , MaintenanceNoticeHTML} from '../models/constants';
import { DimensionValues, DimensionCategories } from '../models/investments';

export class Helpers {
    static isNullOrEmpty(str): boolean {
        return (str === null || str === "" || str === undefined)
    }    
    
    static formatNumberToTwoDigits(number) {
        return (number < 10 ? '0' : '') + number;
    }

    static convertUTCToLocal(date: Date): any {
        return (new Date(date.toString().replace('Z', '') + 'Z'));
    }

    static getMaxLength(id: string): number {
        let length: FieldLength = JSON.parse(sessionStorage[Constants.FIELD_LENGTH_SESSION_STORAGE]) as FieldLength;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.FIELD_LENGTH_SESSION_STORAGE])
            || length === null || length === undefined)
            return 0;

        if (Helpers.isNullOrEmpty(length[id]) === false)
            return length[id];

        return 0;
    }

    static getPreviewDetailedSlideReportURL(link: any) {        
        let url: FISLink = JSON.parse(sessionStorage[Constants.PREVIEW_DETAILED_SLIDE_URL_SESSION_STORAGE]) as FISLink;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.PREVIEW_DETAILED_SLIDE_URL_SESSION_STORAGE])
            || url === null || url === undefined)
            return "";

        if (Helpers.isNullOrEmpty(url) === false)
            return link = url;

        return "";
    }

    static getFraudulentActivityURL(link: any) {
        let url: FISLink = JSON.parse(sessionStorage[Constants.FRAUDULENT_ACTIVITY_URL_SESSION_STORAGE]) as FISLink;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.FRAUDULENT_ACTIVITY_URL_SESSION_STORAGE])
            || url === null || url === undefined)
            return "";

        if (Helpers.isNullOrEmpty(url) === false)
            return link = url;

        return "";
    }

    static getPrivacyAndCookiesURL(link: any) {
        let url: FISLink = JSON.parse(sessionStorage[Constants.PRIVACY_AND_COOKIES_URL_SESSION_STORAGE]) as FISLink;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.PRIVACY_AND_COOKIES_URL_SESSION_STORAGE])
            || url === null || url === undefined)
            return "";

        if (Helpers.isNullOrEmpty(url) === false)
            return link = url;

        return "";
    }

    static getTermsOfUseURL(link: any) {
        let url: FISLink = JSON.parse(sessionStorage[Constants.TERMS_OF_USE_URL_SESSION_STORAGE]) as FISLink;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.TERMS_OF_USE_URL_SESSION_STORAGE])
            || url === null || url === undefined)
            return "";

        if (Helpers.isNullOrEmpty(url) === false)
            return link = url;

        return "";
    }

    static getEndOfSeasonDate(link: any) {
        let date: DateReference = JSON.parse(sessionStorage[Constants.END_OF_SEASON_DATE]) as DateReference;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.END_OF_SEASON_DATE])
            || date === null || date === undefined)
            return "";

        if (Helpers.isNullOrEmpty(date) === false)
            return link = date;

        return "";
    }

    static getTestScoreYear(link: any) {
        let year: DateReference = JSON.parse(sessionStorage[Constants.TEST_SCORE_YEAR]) as DateReference;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.TEST_SCORE_YEAR])
            || year === null || year === undefined)
            return "";

        if (Helpers.isNullOrEmpty(year) === false)
            return link = year;

        return "";
    }

    static getMaintenanceNoticeHTML(link: any) {
        let url: MaintenanceNoticeHTML = JSON.parse(sessionStorage[Constants.MAINTENANCE_NOTICE_HTML]) as MaintenanceNoticeHTML;

        if (Helpers.isNullOrEmpty(sessionStorage[Constants.MAINTENANCE_NOTICE_HTML])
            || url === null || url === undefined)
            return "";

        if (Helpers.isNullOrEmpty(url) === false)
            return link = url;

        return "";
    }

    static flagCharacterCountIndicator(id: string, input: string): boolean{
        input = input != null ? input : "";
        if ((this.getMaxLength(id) - input.length) <= this.getMaxLength('caution')) {
            return true;
        }

        return false;
    }

    static getDimensionValuesByCategory(categoryName: string): DimensionValues[] {
        let dimensionCategories: DimensionCategories[] = JSON.parse(sessionStorage[Constants.DIMENSIONS_SESSION_STORAGE]) as DimensionCategories[];
        let category: DimensionCategories = dimensionCategories.find(sdc => sdc.name === categoryName);
        return category.dimensionValues as DimensionValues[];
    }

    static replaceCharactersToASCII(term: string): string
    {   
        var searchKey = term.replace(/&/g, "%26");
        searchKey = searchKey.replace(/\+/g, "%2B");
        searchKey = searchKey.replace(/#/g, "%23");       
        
        return searchKey;
    }

    static formatDate(date: any) {
        var newDate = new Date(date);
        var day = newDate.getDate();
        var monthIndex = newDate.getMonth() + 1;
        var year = newDate.getFullYear();
        var minutes = newDate.getMinutes();
        var hours = newDate.getHours();
        var seconds = newDate.getSeconds();
        return Helpers.formatNumberToTwoDigits(monthIndex) + "/" + Helpers.formatNumberToTwoDigits(day) + "/" + year;
    }

}