//DataSources

var divisionDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetDivisions',
            dataType: 'json'
        }
    }

});

var principalRequiredDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetRequiredPrincipals',
            dataType: 'json'
        }
    },
});

var principalAlternateDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetAlternatePrincipals',
            dataType: 'json'
        }
    },
});


//Data Source for Executive Sponsor
var leadersDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetExecutiveSponsors',
            dataType: 'json'
        }
    }
});

var teamDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetTeams',
            dataType: 'json'
        }
    }
});
var regionDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetRegions',
            dataType: 'json'
        }
    }
});
var countryDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetCountries',
            dataType: 'json'
        }
    }
});
var purposeDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetPurposes',
            dataType: 'json'
        }
    }
});
var contentOwnerDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetSysUsers',
            dataType: 'json'
        }
    }
});
var staffDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetSysUsers',
            dataType: 'json'
        }
    }
});
var durationDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetDurations',
            dataType: 'json'
        }
    }
});
var yrQtrDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetYearQuarter',
            dataType: 'json'
        }
    }
});
var statusDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetStatus',
            dataType: 'json'
        }
    }
});
var rankingDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetRanking',
            dataType: 'json'
        }
    }
}); 

var teamRankingDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetTeamRankings',
            dataType: 'json',
        }
    }
});

var engagementTypeDataSource = [
    { text: "External", value: 1 },
    { text: "Internal", value: 0 }
];
var dateFlexibleDataSource = [
    { text: "Flexible", value: 1 },
    { text: "Non Flexible", value: 0 }
];
var tripDirectorDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetSysUsers',
            dataType: 'json'
        }
    }
});

var speechWriterDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetSysUsers',
            dataType: 'json'
        }
    }
});

var communicationsLeadDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetSysUsers',
            dataType: 'json'
        }
    }
});

var errorListDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/ErrorLogs/GetErrors',
            dataType: 'json'
        }
    },
    schema: {
        model: {
            fields: {
                LogID: { type: "number" },
                User: { type: "string" },
                Details: { type: "string" },
                RunDate: { type: "date" },
            }
        }
    },
    pageSize: LEAD.Constants.PageSizeOfGrid,
});

var engagementDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Engagement/GetEngagements?source=1',
            dataType: 'json'
        }
    },
    schema: {
        model: {
            fields: {
                id: { type: "number" },
                Title: { type: "string" },
                Objectives: { type: "string" },
                DateStart: { type: "date" },
                DateEnd: { type: "date" },
                BriefDueToGCEByDate: { type: "date" }
            }
        }
    },
    pageSize: LEAD.Constants.PageSizeOfGrid,
    sort: LEAD.Constants.EngagementGridSettings.Engagement.SortBy
});

var engagementReviewDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Engagement/GetEngagements?source=2',
            dataType: 'json'
        }
    },
    schema: {
        model: {
            fields: {
                id: { type: "number" },
                Title: { type: "string" },
                Objectives: { type: "string" },
                DateStart: { type: "date" },
                DateEnd: { type: "date" },
                BriefDueToGCEByDate: { type: "date" }
            }
        }
    },
    pageSize: LEAD.Constants.PageSizeOfGrid,
    sort: LEAD.Constants.EngagementGridSettings.Review.SortBy
});

var engagementSchedulingDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Engagement/GetEngagements?source=3',
            dataType: 'json'
        }
    },
    schema: {
        parse: function (data) {
            var scheduleFields = [];
            for (var i = 0; i < data.length; i++) {
                var scheduleField = data[i];
                scheduleField.DateFromSort = scheduleField.DateFrom;
                scheduleField.DateFrom = kendo.toString(kendo.parseDate(scheduleField.DateFromString), 'MM/dd/yyyy');
                scheduleField.DateTo = kendo.toString(kendo.parseDate(scheduleField.DateToString), 'MM/dd/yyyy');
                scheduleFields.push(scheduleField);
            }
            return scheduleFields;
        },
        model: {
            fields: {
                id: { type: "number" },
                Title: { type: "string" },
                Objectives: { type: "string" },
                DateStart: { type: "date" },
                DateEnd: { type: "date" },
                DateFrom: { type: "date" },
                DateTo: { type: "date" },
                DateFromSort: { type: "date" },
                DateFromString: { type: "string" },
                DateToString: { type: "string" },
                BriefDueToGCEByDate: { type: "date" }
            }
        }
    },
    pageSize: LEAD.Constants.PageSizeOfGrid,
    sort: LEAD.Constants.EngagementGridSettings.Scheduling.SortBy
});

