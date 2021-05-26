export class Constants {
    static readonly PERFORMANCE_AGAINST_EXECUTION = "Performance Against Execution";
    static readonly PERFORMANCE_AGAINST_STRATEGY = "Performance Against Strategy";
    static readonly REINVESTMENT_PROSPECTS = "Reinvestment Prospects";
    static readonly RELATIVE_STRATEGIC_IMPORTANCE = "Relative Strategic Importance";
    static readonly DIMENSIONS_SESSION_STORAGE = "Dimensions";
    static readonly TAXONOMY_CATEGORIES_SESSION_STORAGE = "Taxonomies";
    static readonly REPORTS_SESSION_STORAGE = "Reports";
    static readonly FIELD_LENGTH_SESSION_STORAGE = "FieldLength";
    static readonly USER_SETTINGS = "Investment Score User Settings";
    static readonly PREVIEW_DETAILED_SLIDE_URL_SESSION_STORAGE = "PreviewReportLink";
    static readonly FRAUDULENT_ACTIVITY_URL_SESSION_STORAGE = "FraudulentActivityLink";
    static readonly PRIVACY_AND_COOKIES_URL_SESSION_STORAGE = "PrivacyAndCookiesLink";
    static readonly TERMS_OF_USE_URL_SESSION_STORAGE = "TermsOfUseLink";
    static readonly END_OF_SEASON_DATE = "EndOfSeason";
    static readonly TEST_SCORE_YEAR = "TEST_SCORE_YEAR";
    static readonly MAINTENANCE_NOTICE_HTML = "MaintenanceNoticeHTML";
}

export class FieldLength {
    [id: string]: number;
}

export class FISLink {
    url: string;
}

export class DateReference {
    date: string;
}

export class MaintenanceNoticeHTML {
    html: string;
}