var engagementReviewWindow = $("#engagementReviewWindow");
var EngagementReview = kendo.data.Model.define({
    id: "Id", // the identifier of the model
    fields: {
        "Division": {
            type: "string"
        },
        "Team": {
            type: "string"
        },
        "Title": {
            type: "string"
        },
        "Objectives": {
            type: "string"
        },
        "Details": {
            type: "string"
        },
        "ExecutiveSponsor": {
            type: "string"
        },
        "PrincipalRequired": {
            type: "string"
        },
        "PrincipalAlternate": {
            type: "string"
        },
        "StrategicPriority": {
            type: "string"
        },
        "TeamRanking": {
            type: "string"
        },
        "EngagementType": {
            type: "string"
        },
        "Region": {
            type: "string"
        },
        "Country": {
            type: "string"
        },
        "City": {
            type: "string"
        },
        "Purpose": {
            type: "string"
        },
        "ContentOwner": {
            type: "string"
        },
        "Staff": {
            type: "string"
        },
        "Duration": {
            type: "string"
        },
        "DateFlexible": {
            type: "string"
        },
        "YearQuarter": {
            type: "string"
        },
        "DateStart": {
            type: "string"
        },
        "DateEnd": {
            type: "string"
        },
        "StatusFk": {
            type: "int"
        },
        "PresidentRankingFk": {
            type: "int"
        },
        "PresidentComment": {
            type: "string"
        },
    }
});

$("form").submit(function (event) {
    event.preventDefault();
    $.ajax("/api/vEngagementLeaderSchedules/SaveEngagement", {
        method: 'POST',
        data: JSON.stringify(selectedEngagement),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function () {
            engagementReviewWindow.data("kendoWindow").close();
        }
    });
});

function onClose() {
    var selectedEngagement = new EngagementReview();
}
function onSponsorChange() {
    var selectedDataItem = leadersDataSource.get(selectedEngagement.ExecutiveSponsor);
    if (selectedDataItem.LeaderId != null) {
        selectedEngagement.ExecutiveSponsorFk = selectedDataItem.LeaderId;
    }
}

function onBriefOwnerChange() {
    var selectedDataItem = sysUserDataSource.get(selectedEngagement.BriefOwner);
    if (selectedDataItem.UserId != null) {
        selectedEngagement.BriefOwnerFk = selectedDataItem.UserId;
    }
}

function onStaffChange() {
    var selectedDataItem = sysUserDataSource.get(selectedEngagement.Staff);
    if (selectedDataItem.UserId != null) {
        selectedEngagement.StaffFk = selectedDataItem.UserId;
    }
}

//DataSources
var principalDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetLeaders',
            dataType: 'json'
        }
    },
});

var alternatePrincipalDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetAlternatePrincipals',
            dataType: 'json'
        }
    },
});

var requiredPrincipalDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetRequiredPrincipals',
            dataType: 'json'
        }
    },
});


//Data Source for Executive Sponsor
var executiveSponsorDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetExecutiveSponsors',
            dataType: 'json'
        }
    },
    schema: {
        model: { id: "Name", leaderId: "LeaderId" }
    }
});
var rankingDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetTeamRankings',
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
var sysUserDataSource = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetSysUsers',
            dataType: 'json'
        }
    },
    schema: {
        model: { id: "Name", userId: "UserId" }
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
var engagementTypeDataSource = [
    { text: "External", value: 1 },
    { text: "Internal", value: 0 }
];
var dateFlexibleDataSource = [
    { text: "Flexible", value: 1 },
    { text: "Non Flexible", value: 0 }
];
var engagementStatus = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetStatus',
            dataType: 'json'
        }
    }
});
var presidentRanking = new kendo.data.DataSource({
    transport: {
        read: {
            url: '/api/Lookup/GetRanking',
            dataType: 'json'
        }
    }
});

//=======Kendo Fields=======//
//team field//
$("#team").kendoDropDownList({
    dataTextField: "team",
    dataValueField: "id",
    dataSource: teamDataSource,
    placeholder: ""
});
//principalRequired field//
$("#principalRequired").kendoMultiSelect({
    dataTextField: "Name",
    dataValueField: "LeaderId",
    dataSource: requiredPrincipalDataSource
});
//principalAlternate field//
$("#principalAlternate").kendoMultiSelect({
    dataTextField: "Name",
    dataValueField: "LeaderId",
    dataSource: alternatePrincipalDataSource
});
//strategicPriority field//

//teamRanking field//
$("#teamRanking").kendoDropDownList({
    dataTextField: "ranking",
    dataValueField: "id",
    dataSource: rankingDataSource,
    placeholder: ""
});
//executiveSponsor field//
$("#executiveSponsor").kendoAutoComplete({
    dataTextField: "Name",
    change: onSponsorChange,
    dataSource: executiveSponsorDataSource,
    filter: "contains"
});
//engagementType field//
$("#engagementType").kendoDropDownList({
    dataTextField: "text",
    dataValueField: "value",
    dataSource: engagementTypeDataSource,
    placeholder: ""
});
//region field//
$("#region").kendoDropDownList({
    dataTextField: "regionName",
    dataValueField: "id",
    dataSource: regionDataSource,
    placeholder: ""
});
//country field//
$("#country").kendoDropDownList({
    dataTextField: "countryName",
    dataValueField: "id",
    dataSource: countryDataSource,
    placeholder: ""
});
//purpose field//
$("#purpose").kendoDropDownList({
    dataTextField: "purpose",
    dataValueField: "id",
    dataSource: purposeDataSource,
    placeholder: ""
});
//contentOwner field//
$("#contentOwner").kendoMultiSelect({
    dataTextField: "Name",
    dataValueField: "SysUserId",
    dataSource: sysUserDataSource
});
//staff field//
$("#staff").kendoAutoComplete({
    dataTextField: "Name",
    dataValueField: "SysUserId",
    dataSource: sysUserDataSource
});
//duration field//
$("#duration").kendoDropDownList({
    dataTextField: "duration",
    dataValueField: "id",
    dataSource: durationDataSource,
    placeholder: ""
});
//isDateFlexible field//
$("#dateFlexible").kendoDropDownList({
    dataTextField: "text",
    dataValueField: "value",
    dataSource: dateFlexibleDataSource,
    placeholder: ""
});
//yearQuarter field//
$("#yearQuarter").kendoMultiSelect({
    dataTextField: "display",
    dataValueField: "id",
    dataSource: yrQtrDataSource,
    placeholder: ""
});
//status field//
$("#engagementStatus").kendoDropDownList({
    dataTextField: "name",
    dataValueField: "id",
    dataSource: engagementStatus,
    placeholder: ""
});
//ranking field//
$("#presidentRanking").kendoDropDownList({
    dataTextField: "ranking",
    dataValueField: "id",
    dataSource: presidentRanking,
    placeholder: ""
});


$("#engagementReviewGrid").kendoGrid({
    toolbar: ["excel", { text: "Add Engagement", className: "addEnaggementBtn" }],
    scrollable: {
        virtual: false
    },
    excel: {
        fileName: "lead.xlsx",
        allPages: true
    },
    dataSource: {
        type: "jsonp",
        transport: {
            read: "/api/vEngagementLeaderSchedules/GetEngagements",
        },
        schema: {
            model: {
                fields: {
                    id: { type: "number" },
                    Title: { type: "string" },
                    Objectives: { type: "string" },
                    DateStart: { type: "date" },
                    DateEnd: { type: "date" }
                }
            }
        },
        pageSize: LEAD.Constants.PageSizeOfGrid,
    },
    selectable: "row",
    change: function (e) {
        selectedEngagement = e.sender.dataItem(e.sender.select());
        kendo.bind($("#engagementReviewWindow"), selectedEngagement);
        engagementReviewWindow.data("kendoWindow").center().open();
    },
    sortable: true,
    pageable: true,
    groupable: true,
    columnMenu: true,
    reorderable: true,
    resizable: true,
    height: 700,
    filterable: {
        extra: true,
        operators: {
            string: {
                contains: "Contains",
                isequalto: "Is equal to",
                doesnotcontain: "Does not contain"
            }
        }
    },
    columns: [
        { width: 150, field: "Division", title: "Division", filterable: { multi: true } },
        { width: 150, field: "Team", title: "Team", filterable: { multi: true } },
        { width: 150, field: "StrategicPriority", title: "Strategic Priority", filterable: { multi: true } },
        { width: 150, field: "Title", title: "Title" },
        { width: 150, field: "Details", title: "Details" },
        { width: 150, field: "Objectives", title: "Objectives", },
        { width: 175, field: "PrincipalRequired", title: "Principal Required" },
        { width: 175, field: "PrincipalAlternate", title: "Principal Alternate" },
        { width: 150, field: "ExecutiveSponsor", title: "Executive Sponsor", filterable: { multi: true } },
        { width: 150, field: "Status", title: "Status", filterable: { multi: true } },
        { width: 150, field: "TeamRanking", title: "Team Ranking", filterable: { multi: true } },
        { width: 175, field: "PresidentRanking", title: "President Ranking", filterable: { multi: true } },
        { width: 150, field: "PresidentComment", title: "Comment" },
        { width: 150, field: "EngagementType", title: "Engagement Type", filterable: { multi: true } },
        { width: 150, field: "Duration", title: "Duration", filterable: { multi: true } },
        { width: 150, field: "Purpose", title: "Purpose", filterable: { multi: true } },
        { width: 150, field: "Region", title: "Region", filterable: { multi: true } },
        { width: 150, field: "Country", title: "Country", filterable: { multi: true } },
        { width: 150, field: "City", title: "City", filterable: { multi: true } },
        { width: 150, field: "ContentOwner", title: "Content Owner", filterable: { multi: true } },
        { width: 150, field: "Staff", title: "Staff", filterable: { multi: true } },
        { width: 150, field: "DateFlexible", title: "Date Flexible", filterable: { multi: true } },
        { width: 150, field: "YearQuarter", title: "Year Quarter" },
        {
            width: 150, field: "DateStart", title: "Date Start", format: "{0:MM/dd/yyyy}",

            filterable: {
                extra: false,
                ui: "datepicker",
                operators: {
                    string: {
                        eq: "Is equal to",
                        gte: "Is after or equal to",
                        lte: "Is before or equal to"
                    }
                }
            },
        },
        {
            width: 150, field: "DateEnd", title: "Date End", format: "{0:MM/dd/yyyy}",

            filterable: {
                extra: false,
                ui: "datepicker",
                operators: {
                    string: {
                        eq: "Is equal to",
                        gte: "Is after or equal to",
                        lte: "Is before or equal to"
                    }
                }
            },
        },
        {}
    ]
});
$(".k-grid-AddEngagement").click(function () {
    selectedEngagement = new EngagementReview();
    kendo.bind($("#engagementReviewWindow"), selectedEngagement);
    engagementReviewWindow.data("kendoWindow").center().open();
});
$("#startDate").kendoDatePicker();
$("#endDate").kendoDatePicker();
$(".close-button").click(function () {
    // call 'close' method on nearest kendoWindow
    $(this).closest("[data-role=window]").data("kendoWindow").close();
    // the above is equivalent to:
    //$(this).closest(".k-window-content").data("kendoWindow").close();
});

engagementReviewWindow.kendoWindow({
    width: "1200px",
    title: "Engagement",
    visible: false,
    resizable: false,
    actions: [
        "Close"
    ],
    close: onClose
}).data("kendoWindow")

$("#engagementTabStrip").kendoTabStrip({
    animation: {
        open: {
            effects: "fadeIn"
        }
    }
});