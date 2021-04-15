var engagementWindow = $("#engagementWindow");
var validator = $("#engagementWindow").kendoValidator().data("kendoValidator");
var today = new Date();
var day = today.getDate();
var month = today.getMonth();
var yearMin = today.getFullYear() - 50;
var yearMax = today.getFullYear() + 50;
var start = $("#startDate").kendoDatePicker({
    change: startChange
}).data("kendoDatePicker");
var end = $("#endDate").kendoDatePicker({
    change: endChange
}).data("kendoDatePicker");
var scheduleStart = $("#scheduleDateFrom").kendoDateTimePicker({
    format: LEAD.Constants.DateTimeFormat,
    change: scheduleStartChange
}).data("kendoDateTimePicker");
var scheduleEnd = $("#scheduleDateTo").kendoDateTimePicker({
    format: LEAD.Constants.DateTimeFormat,
    change: scheduleEndChange
}).data("kendoDateTimePicker");
var briefDue = $("#briefDue").kendoDatePicker({
    change: briefDueChange
}).data("kendoDatePicker");
var isSaved = false;
var selectedTab = "EngagementTab"; // EngagementTab,ReviewTab,ScheduleTab
var currentRole = "";
var overlay = null;
var prevStatus = 0;
var buttonTriggered = 0;
var exportFlag = false;
var isAdmin = false;
$.ajax({
    url: '/api/Lookup/GetCurrentRole',
    type: 'Get',
    contentType: 'json',
    success: function (res) {
        currentRole = res;
        if (currentRole) {
            if (currentRole == "IsLeadApprover") {
                $($("#engagementTabStrip").data("kendoTabStrip").items()[2]).attr("style", "display:none");//Scheduling Tab
            }
            else if (currentRole == "IsLeadAll" || currentRole == "IsLeadMultiDivisionUser") {
                $($("#engagementTabStrip").data("kendoTabStrip").items()[1]).attr("style", "display:none");//Review Tab
                $($("#engagementTabStrip").data("kendoTabStrip").items()[2]).attr("style", "display:none");//Scheduling Tab     
            }
            else if (currentRole == "IsLeadAdmin") { isAdmin = true; }
        }
        setFieldVisibility(selectedTab);
        hideFields();
        return currentRole;
    }
});
//note: do not remove object name values in field. this is for exporting
var engagementColumns = [
        { width: 150, field: "Division.name", title: "Division", filterable: { multi: true }, template: "#if (Division !=null) {# #=Division.name# #} else{# #}#" },//col -0
        { width: 150, field: "Team.team", title: "Team", filterable: { multi: true }, template: "#if (Team !=null) {# #=Team.team# #} else{# #}#" },//col -1
        { width: 150, field: "Title", title: "Title" },//col -2
        { width: 175, field: "PrincipalRequiredDisplay", title: "Required Principal(s)" },//col -3
        { width: 175, field: "PrincipalAlternateDisplay", title: "Alternate Principal(s)" },//col -4
        { width: 150, field: "Objectives", title: "Objectives", },//col -5
        { width: 150, field: "Details", title: "Details" },//col -6
        {
            width: 150, field: "DateStart", title: "Start Date", format: "{0:MM/dd/yyyy}",
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
        },//col -7
        {
            width: 150, field: "DateEnd", title: "End Date", format: "{0:MM/dd/yyyy}",
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
        },//col -8
        {
            width: 155, field: "DateFrom", title: "Scheduled Start",
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
            template: "#if (data.DateFromString !='') {# #=kendo.toString(kendo.parseDate(data.DateFromString), 'MM/dd/yyyy h:mm tt')# #} else{# #}#"
        },//col -9
        {
            width: 155, field: "DateFromTime", title: "Scheduled Start Time",
            template: "#if (data.DateFromTime !=null) {# #=kendo.toString(DateFromTime, 'hh:mm')# #} else{# #}#",
            hidden: true
        },//col -10
        {
            width: 155, field: "DateTo", title: "Scheduled End",
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
            template: "#if (data.DateToString !='') {# #=kendo.toString(kendo.parseDate(data.DateToString), 'MM/dd/yyyy h:mm tt')# #} else{# #}#"
        },//col -11
        {
            width: 155, field: "DateToTime", title: "Scheduled End Time",
            template: "#if (data.DateToTime !=null) {# #=kendo.toString(DateToTime, 'hh:mm')# #} else{# #}#",
            hidden: true
        },//col -12
        { width: 150, field: "Region.regionName", title: "Region", filterable: { multi: true }, template: "#if (Region !=null) {# #=Region.regionName# #} else{# #}#" },//col -13
        { width: 150, field: "EngagementCountriesDisplay", title: "Country", filterable: { multi: true } },//col -14
        { width: 150, field: "City", title: "City" },//col -15
        { width: 150, field: "Location", title: "Location" },//col -16
        { width: 150, field: "Duration.duration", title: "Duration", filterable: { multi: true }, template: "#if (Duration !=null) {# #=Duration.duration# #} else{# #}#" },//col -17
        { width: 150, field: "EngagementYearQuartersDisplay", title: "Yr/Qtr", filterable: { multi: true } },//col -18
        { width: 150, field: "Purpose.purpose", title: "Engagement Purpose", filterable: { multi: true }, template: "#if (Purpose !=null) {# #=Purpose.purpose# #} else{# #}#" },//col -19
        { width: 150, field: "Status.name", title: "Status", filterable: { multi: true }, template: "#if (Status !=null) {# #=Status.name# #} else{# #}#" },//col -20
        { width: 150, field: "TeamRanking.ranking", title: "Team Ranking", filterable: { multi: true }, template: "#if (TeamRanking !=null) {# #=TeamRanking.ranking# #} else{# #}#" },//col -21
        { width: 175, field: "PresidentRanking.ranking", title: "President Ranking", filterable: { multi: true }, template: "#if (PresidentRanking !=null) {# #=PresidentRanking.ranking# #} else{# #}#" },//col -22
        { width: 150, field: "PresidentComment", title: "President Review Comment" },//col -23
        { width: 175, field: "SsuTripDirectorDisplay", title: "Trip Director", filterable: { multi: true } },//col -24
        { width: 175, field: "SsuCommunicationsLeadDisplay", title: "Communications Lead", filterable: { multi: true } },//col -25
        { width: 175, field: "ContentOwnerDisplay", title: "Content Owner", filterable: { multi: true } },//col -26
        {
            width: 150, field: "BriefDueToGCEByDate", title: "Brief due to SP&E by", format: "{0:MM/dd/yyyy}",

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
        },//col -27
        { width: 175, field: "StaffDisplay", title: "Staff", filterable: { multi: true } },
        { width: 150, field: "Priority", title: "Strategic Priority", hidden: true, filterable: { multi: true }},//col -29
        { width: 150, field: "IsExternalLabel", title: "Engagement Type", filterable: { multi: true }, template: "#if (IsExternal) {#External#} else{#Internal#}#" },//col -30
];

$(document).ready(function () {
    document.getElementById('engagementTabs').hidden = "";
});

$("button").click(function () {
    //flag down button triggering this function, to be used in form submit
    if (this.id == "save") {
        buttonTriggered = 1;
    }
    else if (this.id == "submit") {
        buttonTriggered = 2;
    }

});

$("#search").click(function () {
    var searchString = $("#searchString").val();
    LEAD.Method.SearchGrid(searchString, LEAD.Constants.EngagementGridSettings);
});

$("#searchString").on('keyup', function (e) {
    // Trigger search when Enter is clicked
    LEAD.Method.TriggerSearchOnEnter(e);
});

$("#delete").click(function () {
    if (confirm("Are you sure you want to delete the Engagement?")) {
        deleteEngagement();
    }
});
$("form").submit(function (event) {

    // Prevent refresh page
    event.preventDefault();

    //Determine status from button triggered
    if (buttonTriggered == 1) {
        if (!selectedEngagement.Status) {
            selectedEngagement.Status = new Status();
            selectedEngagement.Status.id = LEAD.Constants.EngagementStatus.Draft;
            selectedEngagement.Status.name = "Draft";
        }
    }
    else if (buttonTriggered == 2) {
        if (!selectedEngagement.Status) {
            selectedEngagement.Status = new Status();
            selectedEngagement.Status.id = LEAD.Constants.EngagementStatus.SubmittedForReview;
            selectedEngagement.Status.name = "Submitted for Review";
        }
        else if (selectedEngagement.Status.id == LEAD.Constants.EngagementStatus.Draft) {
            selectedEngagement.Status.id = LEAD.Constants.EngagementStatus.SubmittedForReview;
            selectedEngagement.Status.name = "Submitted for Review";
        }
    }
    if (scheduleStart._value && !scheduleEnd._value) {
        $("#scheduleDateTo").attr('required', true);
        $("#scheduleDateTo").next("span .k-invalid-msg").show();
        return;
    }
    else if (!scheduleStart._value && scheduleEnd._value) {
        $("#scheduleDateFrom").attr('required', true);
        $("#scheduleDateFrom").next("span .k-invalid-msg").show();
        return;
    }
    else if (!scheduleStart._value && !scheduleEnd._value) {
        if (engagementStatus[0].value == LEAD.Constants.EngagementStatus.Scheduled ||
                engagementStatus[0].value == LEAD.Constants.EngagementStatus.Completed ||
                engagementStatus[0].value == LEAD.Constants.EngagementStatus.Opportunistic) {
            $("#scheduleDateTo").attr('required', true);
            $("#scheduleDateTo").next("span .k-invalid-msg").show();
            $("#scheduleDateFrom").attr('required', true);
            $("#scheduleDateFrom").next("span .k-invalid-msg").show();
            return;
        }
    }
    
    // Disable buttons of type submit
    $(this).find(':submit').attr('disabled', 'disabled');

    if (selectedEngagement.id == "") {
        selectedEngagement.IsExternal = selectedEngagement.IsExternal.value == 1 ? true : false;
        selectedEngagement.IsDateFlexible = selectedEngagement.IsDateFlexible.value == 1 ? true : false;
        selectedEngagement.DetailsRtf = "";
        selectedEngagement.ObjectivesRtf = "";
        selectedEngagement.PresidentCommentRtf = "";
    }
    if (selectedEngagement.Duration == null) {
        selectedEngagement.Duration = new Duration();
    }
    if (selectedEngagement.ContentOwner == null) {
        selectedEngagement.ContentOwner = new SysUser();
    }
    if (selectedEngagement.Staff == null) {
        selectedEngagement.Staff = new SysUser();
    }
   
    if (selectedEngagement.PrincipalAlternate == null) {
        selectedEngagement.PrincipalAlternate = new Leader();
    }

    selectedEngagement.RegionFk = selectedEngagement.Region.regionId;
    selectedEngagement.DivisionFk = selectedEngagement.Division.divisionId;

    // Multiselect field: 1 Engagement: N Principal - Alternate and Required
    selectedEngagement.Principals = new Array();
    if (selectedEngagement.PrincipalRequired != null) {
        for (var x = 0; x < selectedEngagement.PrincipalRequired.length; x++) {
            selectedEngagement.PrincipalRequired[x].engagementFk = selectedEngagement.Id;
            selectedEngagement.PrincipalRequired[x].typeFk = 1000;
            selectedEngagement.Principals.push(selectedEngagement.PrincipalRequired[x]);
        }
    }
    if (selectedEngagement.PrincipalAlternate != null) {
        for (var x = 0; x < selectedEngagement.PrincipalAlternate.length; x++) {
            selectedEngagement.PrincipalAlternate[x].engagementFk = selectedEngagement.Id;
            selectedEngagement.PrincipalAlternate[x].typeFk = 1001;
            selectedEngagement.Principals.push(selectedEngagement.PrincipalAlternate[x]);
        }
    }

    // Multiselect field: 1 Engagement: N YearQuarter
    if (selectedEngagement.EngagementYearQuarters != null) {
        for (var x = 0; x < selectedEngagement.EngagementYearQuarters.length; x++) {
            selectedEngagement.EngagementYearQuarters[x].engagementFk = selectedEngagement.Id;
        }
    }
    if (selectedEngagement.EngagementCountries != null) {
        for (var x = 0; x < selectedEngagement.EngagementCountries.length; x++) {
            selectedEngagement.EngagementCountries[x].engagementFk = selectedEngagement.Id;
        }
    }

    // Multiselect field: 1 Engagement: N SysUser - Content Owner, Staff
    selectedEngagement.EngagementSysUsers = new Array();

    if (selectedEngagement.ContentOwner != null) {
        for (var x = 0; x < selectedEngagement.ContentOwner.length; x++) {
            selectedEngagement.ContentOwner[x].engagementFk = selectedEngagement.Id;
            selectedEngagement.ContentOwner[x].typeFk = LEAD.Constants.SysUserType.ContentOwner;
            selectedEngagement.EngagementSysUsers.push(selectedEngagement.ContentOwner[x]);
        }
    }
    if (selectedEngagement.Staff != null) {
        for (var x = 0; x < selectedEngagement.Staff.length; x++) {
            selectedEngagement.Staff[x].engagementFk = selectedEngagement.Id;
            selectedEngagement.Staff[x].typeFk = LEAD.Constants.SysUserType.Staff;
            selectedEngagement.EngagementSysUsers.push(selectedEngagement.Staff[x]);
        }
    }
    
    if (selectedEngagement.ExecutiveSponsor != null) {
        if (selectedEngagement.ExecutiveSponsor.leaderFk == undefined) {
            selectedEngagement.ExecutiveSponsorFk = selectedEngagement.ExecutiveSponsor.id;
        }
        else if (selectedEngagement.ExecutiveSponsor.id == undefined) {
            selectedEngagement.ExecutiveSponsorFk = selectedEngagement.ExecutiveSponsor.leaderFk;
        }
    }
    else {
        selectedEngagement.ExecutiveSponsorFk = 0;
    }
    if (selectedEngagement.DateStart) {
        selectedEngagement.DateStart = convertDateTimebyTimeZone(selectedEngagement.DateStart);
    }
    if (selectedEngagement.DateEnd) {
        selectedEngagement.DateEnd = convertDateTimebyTimeZone(selectedEngagement.DateEnd);
    }
    if (selectedEngagement.IsExternal) {
        selectedEngagement.IsExternalLabel = "External";
    }
    else {
        selectedEngagement.IsExternalLabel = "Internal";
    }
    saveEngagement();

});

var engagementGridCurrentPage = 1;
var engagementGrid = $("#engagementGrid").kendoGrid({
    toolbar: ["excel", { text: "Add Engagement", className: "addEnaggementBtn" }],
    scrollable: {
        virtual: false
    },
    excel: {
        fileName: "lead.xlsx",
        allPages: true
    },
    dataSource: engagementDataSource,
    dataBinding: function (e) {
        var pageNow = $("#engagementGrid").data("kendoGrid").dataSource.page();
        if (pageNow != engagementGridCurrentPage) {
            engagementGridCurrentPage = pageNow;
            LEAD.Method.ResetKendoGridScrollBarPosition(e);
        }
    },
    change: function (e) {
        onChangeGrid(e);
    },
    selectable: "row",
    sortable: true,
    pageable: true,
    groupable: true,
    columnMenu: true,
    reorderable: true,
    resizable: true,
    height: 700,

    columnMenuInit: function (e) {
        if (
            e.field === "Team.team"
            ) {
            var filterMultiCheck = e.container.find(".k-filterable").data("kendoFilterMultiCheck");
            filterMultiCheck.container.empty();
            filterMultiCheck.checkSource.sort({ field: e.field, dir: "asc" });

            filterMultiCheck.checkSource.data(filterMultiCheck.checkSource.view().toJSON());
            filterMultiCheck.createCheckBoxes();
        }
    },
    columnMenu: true,

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
    columns: engagementColumns
}).data("kendoGrid");
var reviewEngagementGridCurrentPage = 1;
var reviewEngagementGrid = $("#reviewEngagementGrid").kendoGrid({
    toolbar: ["excel"],
    scrollable: {
        virtual: false
    },
    excel: {
        fileName: "lead.xlsx",
        allPages: true
    },
    dataSource: engagementReviewDataSource,
    dataBinding: function (e) {
        var pageNow = $("#reviewEngagementGrid").data("kendoGrid").dataSource.page();
        if (pageNow != reviewEngagementGridCurrentPage) {
            reviewEngagementGridCurrentPage = pageNow;
            LEAD.Method.ResetKendoGridScrollBarPosition(e);
        }
    },
    //editable: "popup",
    selectable: "row",
    change: function (e) {
        onChangeGrid(e);
    },
    sortable: true,
    pageable: true,
    groupable: true,
    columnMenu: true,
    reorderable: true,
    resizable: true,
    height: 700,

    columnMenuInit: function (e) {
        if (
            e.field === "Team.team"
            ) {
            var filterMultiCheck = e.container.find(".k-filterable").data("kendoFilterMultiCheck");
            filterMultiCheck.container.empty();
            filterMultiCheck.checkSource.sort({ field: e.field, dir: "asc" });

            filterMultiCheck.checkSource.data(filterMultiCheck.checkSource.view().toJSON());
            filterMultiCheck.createCheckBoxes();
        }
    },
    columnMenu: true,

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
    columns: engagementColumns
}).data("kendoGrid");
var schedulingEngagementGridCurrentPage = 1;
var schedulingEngagementGrid = $("#schedulingEngagementGrid").kendoGrid({
    toolbar: ["excel"],
    scrollable: {
        virtual: false
    },
    excel: {
        fileName: "lead.xlsx",
        allPages: true
    },
    excelExport: function (e) {
        if (!exportFlag) {
            //  e.sender.showColumn(0); for demo
            // for your case show column that you want to see in export file
            e.sender.columns[10].hidden = false
            e.sender.columns[12].hidden = false
            e.preventDefault();
            exportFlag = true;
            setTimeout(function () {
                e.sender.saveAsExcel();
            });
        } else {
            e.sender.columns[10].hidden = true
            e.sender.columns[12].hidden = true
            exportFlag = false;
        }
        var sheet = e.workbook.sheets[0];

        for (var rowIndex = 0; rowIndex < sheet.rows.length; rowIndex++) {
            var row = sheet.rows[rowIndex];
            for (var cellIndex = 0; cellIndex < row.cells.length; cellIndex++) {
                row.cells[cellIndex].format = "MM/dd/yyyy";
            }
        }
    },
    dataSource: engagementSchedulingDataSource,
    dataBinding: function (e) {
        var pageNow = $("#schedulingEngagementGrid").data("kendoGrid").dataSource.page();
        if (pageNow != schedulingEngagementGridCurrentPage) {
            schedulingEngagementGridCurrentPage = pageNow;
            LEAD.Method.ResetKendoGridScrollBarPosition(e);
        }
    },
    change: function (e) {
        onChangeGrid(e);
    },
    selectable: "row",
    sortable: true,
    pageable: true,
    groupable: true,
    columnMenu: true,
    reorderable: true,
    resizable: true,
    height: 700,

    columnMenuInit: function (e) {
        if (
            e.field === "Team.team"
            ) {
            var filterMultiCheck = e.container.find(".k-filterable").data("kendoFilterMultiCheck");
            filterMultiCheck.container.empty();
            filterMultiCheck.checkSource.sort({ field: e.field, dir: "asc" });

            filterMultiCheck.checkSource.data(filterMultiCheck.checkSource.view().toJSON());
            filterMultiCheck.createCheckBoxes();
        }
    },
    columnMenu: true,

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
    columns: engagementColumns
}).data("kendoGrid");

$(".k-grid-AddEngagement").click(function () {
    overlay = $('<div></div>').prependTo('html').attr('id', 'overlay');
    selectedEngagement = new Engagement();
    selectedEngagement.Schedule = new Schedule();
    kendo.bind($("#engagementWindow"), selectedEngagement);
    engagementWindow.data("kendoWindow").center().open();

    $("#country").data("kendoMultiSelect").enable(false);
    document.getElementById("delete").style.display = "none";

    // Keep modified span to empty
    document.getElementById("modifiedSpan").innerHTML = "";

});
$(".close-button").click(function () {
    // call 'close' method on nearest kendoWindow
    //$(this).closest("[data-role=window]").data("kendoWindow").close();
    // the above is equivalent to:
    $(this).closest(".k-window-content").data("kendoWindow").close();
});
$("#engagementTabStrip").kendoTabStrip({
    animation: {
        open: {
            effects: "fadeIn"
        }
    }
});
engagementWindow.kendoWindow({
    width: "1180px",
    title: "Engagement",
    resizable: false,
    actions: [
        "Close"
    ],

    close: onClose
}).data("kendoWindow")

function tabChange(tab) {
    selectedTab = tab;
    setFieldVisibility(tab);
}
function deleteEngagement() {
    $.ajax("/api/Engagement/HardDeleteEngagement", {
        method: 'POST',
        data: JSON.stringify(selectedEngagement),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (e) {

            if (selectedTab == "EngagementTab") { //refresh Engagement grid
                engagementGrid.editRow($("#grid tr:eq(1)"));
                engagementGrid.saveRow();
                engagementGrid.dataSource.read();
                engagementGrid.refresh();
            }
            else if (selectedTab == "ReviewTab") {//refresh Review grid
                reviewEngagementGrid.editRow($("#grid tr:eq(1)"));
                reviewEngagementGrid.saveRow();
                reviewEngagementGrid.dataSource.read();
                reviewEngagementGrid.refresh();
            }
            else if (selectedTab == "ScheduleTab") {//refresh Scheduling grid
                schedulingEngagementGrid.editRow($("#grid tr:eq(1)"));
                schedulingEngagementGrid.saveRow();
                schedulingEngagementGrid.dataSource.read();
                schedulingEngagementGrid.refresh();
            }
            engagementWindow.data("kendoWindow").close();
        }
    });
}
function saveEngagement() {
    $.ajax("/api/Engagement/SaveEngagement?prevStatus=" + prevStatus, {
        method: 'POST',
        data: JSON.stringify(selectedEngagement),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (e) {
            selectedEngagement.ModifiedDate = e.ModifiedDate;
            if (selectedEngagement.id == "") {
                selectedEngagement.Id = e.Id;
            }
            moveEngagementRecordToTab();
            refreshTab();
            if (selectedTab == LEAD.Constants.EngagementGridSettings.Scheduling.TabName || isAdmin) {
                engagementSchedule();
            }
            else {
                isSaved = true;
                engagementWindow.data("kendoWindow").close();
            }
        }
    });
}

function engagementSchedule() {
    if (selectedEngagement.Schedule == null) {
        selectedEngagement.Schedule = new Schedule();
    }
    selectedEngagement.Schedule.EngagementFk = selectedEngagement.Id;
    selectedEngagement.Schedule.ScheduleComment = selectedEngagement.ScheduleComment;
    selectedEngagement.Schedule.BriefDueToGCEByDate = convertDateTimebyTimeZone(selectedEngagement.BriefDueToGCEByDate);
    if (selectedEngagement.DateFrom && scheduleStart._value) {
        selectedEngagement.Schedule.DateFrom = convertDateTimebyTimeZone(new Date(selectedEngagement.DateFrom));
    }
    else {
        selectedEngagement.Schedule.DateFrom = null
    }

    if (selectedEngagement.DateTo && scheduleEnd._value) {
        selectedEngagement.Schedule.DateTo = convertDateTimebyTimeZone(new Date(selectedEngagement.DateTo));
    }
    else {
        selectedEngagement.Schedule.DateTo = null
    }

    // Multiselect field: 1 Schedule: N SysUser - Trip Director, Communications Lead, Speech Writer
    selectedEngagement.Schedule.ScheduleSysUsers = new Array();
    if (selectedEngagement.Schedule.SsuTripDirector != null) {
        for (var x = 0; x < selectedEngagement.Schedule.SsuTripDirector.length; x++) {
            selectedEngagement.Schedule.SsuTripDirector[x].scheduleFk = selectedEngagement.Schedule.Id;
            selectedEngagement.Schedule.SsuTripDirector[x].typeFk = LEAD.Constants.SysUserType.TripDirector;
            selectedEngagement.Schedule.ScheduleSysUsers.push(selectedEngagement.Schedule.SsuTripDirector[x]);
        }
    }

    if (selectedEngagement.Schedule.SsuCommunicationsLead != null) {
        for (var x = 0; x < selectedEngagement.Schedule.SsuCommunicationsLead.length; x++) {
            selectedEngagement.Schedule.SsuCommunicationsLead[x].scheduleFk = selectedEngagement.Schedule.Id;
            selectedEngagement.Schedule.SsuCommunicationsLead[x].typeFk = LEAD.Constants.SysUserType.CommunicationsLead;
            selectedEngagement.Schedule.ScheduleSysUsers.push(selectedEngagement.Schedule.SsuCommunicationsLead[x]);
        }
    }

    if (selectedEngagement.Schedule.SsuSpeechWriter != null) {
        for (var x = 0; x < selectedEngagement.Schedule.SsuSpeechWriter.length; x++) {
            selectedEngagement.Schedule.SsuSpeechWriter[x].scheduleFk = selectedEngagement.Schedule.Id;
            selectedEngagement.Schedule.SsuSpeechWriter[x].typeFk = LEAD.Constants.SysUserType.SpeechWriter;
            selectedEngagement.Schedule.ScheduleSysUsers.push(selectedEngagement.Schedule.SsuSpeechWriter[x]);
        }
    }
    var argsEngagement = typeof preEngagement == "undefined" || preEngagement == null ? selectedEngagement : preEngagement;
    $.ajax("/api/Engagement/SaveEngagementSchedule?prevStatus=" + prevStatus
        , {
        method: 'POST',
        data: JSON.stringify(selectedEngagement.Schedule),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (e) {

            refreshTab();

            isSaved = true;
            engagementWindow.data("kendoWindow").close();
        }
    });
}

function moveEngagementRecordToTab() {
    if (selectedEngagement.Status) {
        var newStatus = selectedEngagement.Status.id;

        // Do  not proceed if there's no change in Status
        if (prevStatus == newStatus) return;

        // Remove the engagement record to its previous tab
        if (prevStatus == LEAD.Constants.EngagementStatus.Draft
            || prevStatus == LEAD.Constants.EngagementStatus.Declined) {
            engagementDataSource.remove(selectedEngagement);
        }
        else if (prevStatus == LEAD.Constants.EngagementStatus.SubmittedForReview) {
            engagementReviewDataSource.remove(selectedEngagement);
        }
        else if (prevStatus >= LEAD.Constants.EngagementStatus.Approved) {
            engagementSchedulingDataSource.remove(selectedEngagement);
        }

        // Add the engagement record to its new tab
        if (newStatus == LEAD.Constants.EngagementStatus.Draft
           || newStatus == LEAD.Constants.EngagementStatus.Declined) {
            engagementDataSource.add(selectedEngagement);
        }
        else if (newStatus == LEAD.Constants.EngagementStatus.SubmittedForReview) {
            engagementReviewDataSource.add(selectedEngagement);
        }
        else if (newStatus >= LEAD.Constants.EngagementStatus.Approved) {
            engagementSchedulingDataSource.add(selectedEngagement);
        }
    }
}
function refreshTab() {
    // Refresh kendo tabs based on selected tab OR selected Status
    if (selectedTab == LEAD.Constants.EngagementGridSettings.Engagement.TabName
        || selectedEngagement.Status.id == LEAD.Constants.EngagementStatus.Draft
        || selectedEngagement.Status.id == LEAD.Constants.EngagementStatus.Declined) { //refresh Engagement grid
        engagementGrid.editRow($("#grid tr:eq(1)"));
        engagementGrid.saveRow();
        engagementGrid.dataSource.read();
        engagementGrid.refresh();
    }
    if (selectedTab == LEAD.Constants.EngagementGridSettings.Review.TabName
        || selectedEngagement.Status.id == LEAD.Constants.EngagementStatus.SubmittedForReview) {//refresh Review grid
        reviewEngagementGrid.editRow($("#grid tr:eq(1)"));
        reviewEngagementGrid.saveRow();
        reviewEngagementGrid.dataSource.read();
        reviewEngagementGrid.refresh();
    }
    if (selectedTab == LEAD.Constants.EngagementGridSettings.Scheduling.TabName
        || selectedEngagement.Status.id >= LEAD.Constants.EngagementStatus.Approved) {//refresh Scheduling grid
        schedulingEngagementGrid.editRow($("#grid tr:eq(1)"));
        schedulingEngagementGrid.saveRow();
        schedulingEngagementGrid.dataSource.read();
        schedulingEngagementGrid.refresh();
    }

}
function onClose() {
    overlay.remove();
    $("#engagementWindow").find("span.k-tooltip-validation").hide();
    var btn = $("button");
    btn.prop('disabled', false);

    resetDateTimeMinMax(start);
    resetDateTimeMinMax(end);
    resetDateTimeMinMax(scheduleStart);
    resetDateTimeMinMax(scheduleEnd);
    start.value(new Date());
    end.value(new Date());
    scheduleStart.value(new Date());
    scheduleEnd.value(new Date());
    briefDue.value(new Date());

    //reset field required properties
    $("#startDate").attr('required', false);
    $("#endDate").attr('required', false);
    $("#scheduleDateFrom").attr('required', false);
    $("#scheduleDateTo").attr('required', false);

    var selectedEngagement = new Engagement();
    var preEngagement = new Engagement();

    if (!isSaved) {
        if (selectedTab == "EngagementTab") {
            engagementGrid.cancelChanges();
        }
        else if (selectedTab == "ReviewTab") {
            reviewEngagementGrid.cancelChanges();
        }
        else if (selectedTab == "ScheduleTab") {
            schedulingEngagementGrid.cancelChanges();
        }
    }
    isSaved = false;
}

// Called when an Engagement form is opened
function onChangeGrid(e) {
    overlay = $('<div></div>').prependTo('html').attr('id', 'overlay');
    selectedEngagement = e.sender.dataItem(e.sender.select());
    preEngagement = JSON.parse(JSON.stringify(selectedEngagement));
    
    if (typeof selectedEngagement != "undefined" && selectedEngagement != null) {

        if (selectedEngagement.DateTo) {
            if (selectedEngagement.DateTo.toString() == LEAD.Constants.DefaultDateTime ||
                    selectedEngagement.DateTo.toString() == new Date(LEAD.Constants.DefaultDateTime).toString()) {
                selectedEngagement.DateTo = null;
            }
            else {
                selectedEngagement.DateTo = kendo.parseDate(selectedEngagement.DateToString);
            }
        }
        if (selectedEngagement.DateFrom) {
            if (selectedEngagement.DateFrom.toString() == LEAD.Constants.DefaultDateTime ||
                selectedEngagement.DateFrom.toString() == new Date(LEAD.Constants.DefaultDateTime).toString()) {
                selectedEngagement.DateFrom = null;
            }
            else {
                selectedEngagement.DateFrom = kendo.parseDate(selectedEngagement.DateFromString);
            }
        }

        var modifiedOn = "", modifiedBy = "";
        // Populate Modified On
        modifiedOn = convertDateTimebyTimeZone(new Date(selectedEngagement.ModifiedDate));
        modifiedOn = modifiedOn.trim();
        // Populate Modified By
        if (selectedEngagement.ModifiedBy) {
            modifiedBy = selectedEngagement.ModifiedBy.fullName;
            modifiedBy = modifiedBy.trim();
        }
        // Set up display text for #modifiedSpan
        if (modifiedOn != "" || modifiedBy != "") {
            var modifiedText = "Last modified";
            if (modifiedBy != "") modifiedText = modifiedText + " by " + modifiedBy;
            if (modifiedOn != "") modifiedText = modifiedText + " on " + modifiedOn;
            document.getElementById("modifiedSpan").innerHTML = modifiedText;
        }
        countryDataSource.filter([
            { field: "regionId", operator: "eq", value: selectedEngagement.RegionFk }
        ]);
        prevStatus = selectedEngagement.Status.id;


        if (selectedEngagement.StatusFk == LEAD.Constants.EngagementStatus.Draft ||
            selectedEngagement.StatusFk == LEAD.Constants.EngagementStatus.SubmittedForReview) {
            $("#presidentRanking").attr('required', false);
        }
        else {
            $("#presidentRanking").attr('required', true);
        }
        if (selectedEngagement.StatusFk == LEAD.Constants.EngagementStatus.Scheduled ||
            selectedEngagement.StatusFk == LEAD.Constants.EngagementStatus.Completed ||
            selectedEngagement.StatusFk == LEAD.Constants.EngagementStatus.Opportunistic) {
            $("#scheduleDateFrom").attr('required', true);
            $("#scheduleDateTo").attr('required', true);
        }
        else {
            $("#scheduleDateFrom").attr('required', false);
            $("#scheduleDateTo").attr('required', false);
        }
        if (currentRole == "IsLeadAdmin") {
            document.getElementById("delete").style.display = "inline";
        }
        else {
            document.getElementById("delete").style.display = "none";
        }


        if (selectedEngagement.DateStart) {
            $("#endDate").attr('required', true);
        }
        if (selectedEngagement.DateEnd) {
            $("#startDate").attr('required', true);
        }

        if (selectedEngagement.Schedule == null) {
            selectedEngagement.Schedule = new Schedule();
        }
    }
    selectedEngagement = nullifyAutocompleteData(selectedEngagement);
    $("#country").data("kendoMultiSelect").enable(true);
    validateDateTimePicker(selectedEngagement);
    kendo.bind($("#engagementWindow"), selectedEngagement);
    forceUpdateMultiSelectFields(selectedEngagement);
    engagementWindow.data("kendoWindow").center().open();
}

//Force update multi select fields
function forceUpdateMultiSelectFields(selectedEngagement) {
    //principalRequired
    var principalRequired = $("#principalRequired").data("kendoMultiSelect");
    var valuesPrincipalRequired = new Array();
    for (var x = 0; x < selectedEngagement.PrincipalRequired.length; x++) {
        valuesPrincipalRequired.push(selectedEngagement.PrincipalRequired[x].leaderFk);
    } 
    if (!compareArrays(principalRequired.value(), valuesPrincipalRequired)) {
        fillMultiSelect(principalRequired, valuesPrincipalRequired);
    }

    //principalAlternate    
    var principalAlternate = $("#principalAlternate").data("kendoMultiSelect");
    var valuesPrincipalAlternate = new Array();    
    for (var x = 0; x < selectedEngagement.PrincipalAlternate.length; x++) {
        valuesPrincipalAlternate.push(selectedEngagement.PrincipalAlternate[x].leaderFk);
    }
    if (!compareArrays(principalAlternate.value(), valuesPrincipalAlternate)) {
        fillMultiSelect(principalAlternate, valuesPrincipalAlternate);
    }

    //contentOwner 
    var contentOwner = $("#contentOwner").data("kendoMultiSelect");
    var valuesContentOwner = new Array();
    for (var x = 0; x < selectedEngagement.ContentOwner.length; x++) {
        valuesContentOwner.push(selectedEngagement.ContentOwner[x].sysUserFk);
    }
    if (!compareArrays(contentOwner.value(), valuesContentOwner)) {
        fillMultiSelect(contentOwner, valuesContentOwner);
    }

    //staff   
    var staff = $("#staff").data("kendoMultiSelect");
    var valuesStaff = new Array();    
    for (var x = 0; x < selectedEngagement.Staff.length; x++) {
        valuesStaff.push(selectedEngagement.Staff[x].sysUserFk);
    }
    if (!compareArrays(staff.value(), valuesStaff)) {
        fillMultiSelect(staff, valuesStaff);
    }

    //yearQuarter
    var yearQuarter = $("#yearQuarter").data("kendoMultiSelect");
    var valuesYearQuarter = new Array();
    for (var x = 0; x < selectedEngagement.EngagementYearQuarters.length; x++) {
        valuesYearQuarter.push(selectedEngagement.EngagementYearQuarters[x].yearQuarterFk);
    }
    if (!compareArrays(yearQuarter.value(), valuesYearQuarter)) {
        fillMultiSelect(yearQuarter, valuesYearQuarter);
    }
    
    //checks if engagement has data in scheduling table
    if (selectedEngagement.Schedule.SsuTripDirector == undefined ||
        selectedEngagement.Schedule.SsuSpeechWriter == undefined ||
        selectedEngagement.Schedule.SsuCommunicationsLead == undefined) return;

    //tripDirector   
    var tripDirector = $("#tripDirector").data("kendoMultiSelect");
    var valuesTripDirector = new Array();
    for (var x = 0; x < selectedEngagement.Schedule.SsuTripDirector.length; x++) {
        valuesTripDirector.push(selectedEngagement.Schedule.SsuTripDirector[x].sysUserFk);
    }
    if (!compareArrays(tripDirector.value(), valuesTripDirector)) {
        fillMultiSelect(tripDirector, valuesTripDirector);
    }

    //speechWriter    
    var speechWriter = $("#speechWriter").data("kendoMultiSelect");
    var valuesSpeechWriter = new Array();
    for (var x = 0; x < selectedEngagement.Schedule.SsuSpeechWriter.length; x++) {
        valuesSpeechWriter.push(selectedEngagement.Schedule.SsuSpeechWriter[x].sysUserFk);
    }
    if (!compareArrays(speechWriter.value(), valuesSpeechWriter)) {
        fillMultiSelect(speechWriter, valuesSpeechWriter);
    }

    //communicationsLead  
    var communicationsLead = $("#communicationsLead").data("kendoMultiSelect");
    var valuesCommunicationsLead = new Array();
    for (var x = 0; x < selectedEngagement.Schedule.SsuCommunicationsLead.length; x++) {
        valuesCommunicationsLead.push(selectedEngagement.Schedule.SsuCommunicationsLead[x].sysUserFk);
    }
    if (!compareArrays(communicationsLead.value(), valuesCommunicationsLead)) {
        fillMultiSelect(communicationsLead, valuesCommunicationsLead);
    }
}

//Set multi select fields values
function fillMultiSelect(multiSelectField, multiSelectValues) {
    //requires clearing of datsource filtering before setting values
    multiSelectField.dataSource.filter({});
    //forced set multi select values
    multiSelectField.value(multiSelectValues);
}

//Two-array compare function
function compareArrays(postUpdateValues, preUpdateValues) {
    //Copy elements to temporary arrays
    var tempPostUpdate = postUpdateValues.slice();
    var tempPreUpdate = preUpdateValues.slice();
    //Compare two arays if they're equal
    return JSON.stringify(tempPostUpdate.sort()) === JSON.stringify(tempPreUpdate.sort());
}

function setFieldVisibility(selectedTab) {
    var isReview = false;
    var isScheduling = false;
    var isEngagementStatus = false;
    var submittedForReviewBtnDisplay = "none";
    var displayStatus = "display:none";

    if (selectedTab == "EngagementTab") {
        isReview = isAdmin ? true : false;
        isScheduling = isAdmin ? true : false;
        isEngagementStatus = isAdmin ? true : false;
        submittedForReviewBtnDisplay = isAdmin ? "none" : "inline";
        if (isAdmin) {
            displayStatus = "display:block";
        }
        else {
            displayStatus = "display:none";
        }
    }
    else if (selectedTab == "ReviewTab") {
        reviewEngagementGrid.hideColumn(9); reviewEngagementGrid.hideColumn(11);
        isReview = true;
        isScheduling = isAdmin ? true : false;
        isEngagementStatus = true;
        submittedForReviewBtnDisplay = "none";
        if (isAdmin) {
            displayStatus = "display:block";
        }
        else {
            displayStatus = "display:none";
        }
    }
    else if (selectedTab == "ScheduleTab") {
        schedulingEngagementGrid.hideColumn(7); schedulingEngagementGrid.hideColumn(8);
        isReview = true;
        isScheduling = true;
        isEngagementStatus = true;
        submittedForReviewBtnDisplay = "none";
        displayStatus = "display:block";
    }
    engagementGrid.hideColumn(9);    engagementGrid.hideColumn(11);
    $("#presidentRanking").data("kendoDropDownList").enable(isReview);
    document.getElementById("presidentReview").disabled = !isReview;
    $("#tripDirector").data("kendoMultiSelect").enable(isScheduling);
    $("#communicationsLead").data("kendoMultiSelect").enable(isScheduling);
    $("#speechWriter").data("kendoMultiSelect").enable(isScheduling);
    $("#briefDue").data("kendoDatePicker").enable(isScheduling);
    $("#scheduleDateFrom").data("kendoDateTimePicker").enable(isScheduling);
    $("#scheduleDateTo").data("kendoDateTimePicker").enable(isScheduling);
    document.getElementById("scheduleComment").disabled = !isScheduling
    document.getElementById("location").disabled = !isScheduling
    $("#engagementStatus").data("kendoDropDownList").enable(isEngagementStatus);
    document.getElementById("submit").style.display = (submittedForReviewBtnDisplay);
    if (isAdmin && selectedTab == "EngagementTab" && $("#engagementStatus").data("kendoDropDownList").length != 0) {
        $($("#engagementStatus").data("kendoDropDownList").items()[0]).attr("style", "display:block");// Status: Draft
        $($("#engagementStatus").data("kendoDropDownList").items()[1]).attr("style", "display:block");// Status: Submitted for Review
        $($("#engagementStatus").data("kendoDropDownList").items()[2]).attr("style", displayStatus);// Status: Approved 
        $($("#engagementStatus").data("kendoDropDownList").items()[3]).attr("style", "display:block");// Status: Scheduled
        $($("#engagementStatus").data("kendoDropDownList").items()[4]).attr("style", "display:block");// Status: Opportunistic
        $($("#engagementStatus").data("kendoDropDownList").items()[5]).attr("style", displayStatus);// Status: Completed
        $($("#engagementStatus").data("kendoDropDownList").items()[6]).attr("style", displayStatus);// Status: Declined         
    }    
    else if (selectedTab == "ReviewTab" && $("#engagementStatus").data("kendoDropDownList").length != 0) {
        $($("#engagementStatus").data("kendoDropDownList").items()[0]).attr("style", "display:block");// Status: Draft
        $($("#engagementStatus").data("kendoDropDownList").items()[1]).attr("style", "display:block");// Status: Submitted for Review
        $($("#engagementStatus").data("kendoDropDownList").items()[2]).attr("style", "display:block");// Status: Approved   
        $($("#engagementStatus").data("kendoDropDownList").items()[3]).attr("style", displayStatus);// Status: Scheduled
        $($("#engagementStatus").data("kendoDropDownList").items()[4]).attr("style", displayStatus);// Status: Opportunistic
        $($("#engagementStatus").data("kendoDropDownList").items()[5]).attr("style", displayStatus);// Status: Completed
        $($("#engagementStatus").data("kendoDropDownList").items()[6]).attr("style", "display:block");// Status: Declined 
    }
    else if (selectedTab == "ScheduleTab" && $("#engagementStatus").data("kendoDropDownList").length != 0) {
        $($("#engagementStatus").data("kendoDropDownList").items()[0]).attr("style", displayStatus);// Status: Draft
        $($("#engagementStatus").data("kendoDropDownList").items()[1]).attr("style", displayStatus);// Status: Submitted for Review
        $($("#engagementStatus").data("kendoDropDownList").items()[2]).attr("style", displayStatus);// Status: Approved  
        $($("#engagementStatus").data("kendoDropDownList").items()[3]).attr("style", displayStatus);// Status: Scheduled
        $($("#engagementStatus").data("kendoDropDownList").items()[4]).attr("style", displayStatus);// Status: Opportunistic
        $($("#engagementStatus").data("kendoDropDownList").items()[5]).attr("style", displayStatus);// Status: Completed
        $($("#engagementStatus").data("kendoDropDownList").items()[6]).attr("style", displayStatus);// Status: Declined 
    }
}

function hideFields() {
    if (currentRole == "IsLeadAdmin") {
        return;
    }
    else {
        document.getElementById("scheduleCommentRow").style.display = "none";
    }
}

//=====DateTimePicker Validation Functions======//
function convertDateTimebyTimeZone(selectedDateTime) {
    var dateobj = kendo.parseDate(selectedDateTime, LEAD.Constants.DateTimeFormat);
    var datestring = kendo.toString(dateobj, LEAD.Constants.DateTimeFormat);
    return datestring;
}
function resetDateTimeMinMax(datetime) {
    if (datetime) {
        datetime.min(new Date(yearMin, month, day));
        datetime.max(new Date(yearMax, month, day));
    }
}
function validateDateTimePicker(selectedEngagement) {

    if (selectedEngagement.DateEnd) { //if engagement end date has value
        var dateEnd = new Date(selectedEngagement.DateEnd);
        dateEnd = new Date(dateEnd);
        dateEnd.setDate(dateEnd.getDate());
        start.max(new Date(dateEnd));
    }

    if (selectedEngagement.DateStart) { //if engagement start date has value
        var dateStart = new Date(selectedEngagement.DateStart);
        dateStart = new Date(dateStart);
        dateStart.setDate(dateStart.getDate());
        end.min(new Date(dateStart));
    }

    if (selectedEngagement.DateTo) {//if schedule end date has value
        scheduleEnd.value(new Date(selectedEngagement.DateTo));
        scheduleStart.max(new Date(scheduleEnd.value()));
        selectedEngagement.DateTo = new Date(selectedEngagement.DateTo);
    }

    if (selectedEngagement.DateFrom) {//if schedule start date has value
        scheduleStart.value(new Date(selectedEngagement.DateFrom));
        scheduleEnd.min(new Date(scheduleStart.value()));
        selectedEngagement.DateFrom = new Date(selectedEngagement.DateFrom);
    }
}

//Change Event of Engagement StartDate
function startChange() {
    if (!this._value) {
        $("#endDate").attr('required', false);
        resetDateTimeMinMax(start);
        resetDateTimeMinMax(end);
        $("#endDate").next("span .k-invalid-msg").hide();
        start.value(new Date());
        start.value("");
        return;
    }
    $("#endDate").attr('required', true);
    var startDate = start.value();
    endDate = end.value();

    if (startDate) {
        startDate = new Date(startDate);
        startDate.setDate(startDate.getDate());
        end.min(startDate);
    }
    else if (endDate) {
        start.max(new Date(endDate));
    } else {
        endDate = new Date();
        start.max(endDate);
        end.min(endDate);
    }
    if (start._value != null && end._value != null) {
        startDateValue = Date.parse(start._oldText);
        endDateValue = Date.parse(end._oldText);
        if (startDateValue > endDateValue) {
            end.value("");
            $("#startDate").attr('required', false);
            $("#startDate").next("span .k-invalid-msg").hide();
        }
    }
}
//Change Event of Engagement EndDate
function endChange() {
    if (!this._value) {
        $("#startDate").attr('required', false);
        resetDateTimeMinMax(start);
        resetDateTimeMinMax(end);
        $("#startDate").next("span .k-invalid-msg").hide();
        end.value(new Date());
        end.value("");
        return;
    }
    $("#startDate").attr('required', true);
    var endDate = end.value();
    startDate = start.value();

    if (endDate) {
        endDate = new Date(endDate);
        endDate.setDate(endDate.getDate());
        start.max(endDate);
    }
    else if (startDate) {
        end.min(new Date(startDate));
    } else {
        endDate = new Date();
        start.max(endDate);
        end.min(endDate);
    }
    if (start._value != null && end._value != null) {
        startDateValue = Date.parse(start._oldText);
        endDateValue = Date.parse(end._oldText);
        if (startDateValue > endDateValue) {
            start.value("");
            $("#endDate").attr('required', false);
            $("#endDate").next("span .k-invalid-msg").hide();
        }
    }
}

// Change event of Schedule StartDate
function scheduleStartChange() {
    if (!this._value) {
        $("#scheduleDateTo").attr('required', false);
        resetDateTimeMinMax(scheduleStart);
        $("#scheduleDateTo").next("span .k-invalid-msg").hide();
        resetDateTimeMinMax(scheduleEnd);        
        scheduleStart.value(new Date());        
        scheduleStart.value("");
        return;
    }
    $("#scheduleDateTo").attr('required', true);
    var dateFrom = scheduleStart.value();
    dateTo = scheduleEnd.value();

    if (dateFrom) {
        dateFrom = new Date(dateFrom);
        dateFrom.setDate(dateFrom.getDate());
        scheduleEnd.min(dateFrom);
    }

    if (scheduleStart._value > scheduleEnd._value) {
        scheduleEnd.value("");
        $("#scheduleDateFrom").attr('required', false);
        $("#scheduleDateFrom").next("span .k-invalid-msg").hide();
    }
}
// Change event of Schedule EndDate
function scheduleEndChange() {
    if (!this._value) {
        $("#scheduleDateFrom").attr('required', false);
        resetDateTimeMinMax(scheduleStart);
        resetDateTimeMinMax(scheduleEnd);
        $("#scheduleDateFrom").next("span .k-invalid-msg").hide();
        scheduleEnd.value(new Date());
        scheduleEnd.value("");
        return;
    }
    $("#scheduleDateFrom").attr('required', true);
    var dateTo = scheduleEnd.value();
    dateFrom = scheduleStart.value();

    if (dateTo) {
        dateTo = new Date(dateTo);
        dateTo.setDate(dateTo.getDate());
        scheduleStart.max(dateTo);
    }

    if (scheduleStart._value > scheduleEnd._value) {
        scheduleStart.value("");
        $("#scheduleDateTo").attr('required', false);
        $("#scheduleDateTo").next("span .k-invalid-msg").hide();
    }
}

function briefDueChange() {
    if (!this._value) {
        briefDue.value(new Date());
        briefDue.value("");
        return;
    }
}

// This is to make sure to clear autocomplete controls when selected id is 0
// so it will be displayed as blank in UI
// Called once on load of an Engagement form
function nullifyAutocompleteData(selectedEngagement) {
    // The names of the control can be found on EngagementController.cs > Engagement object
    var autoCompleteControls = [
        "ExecutiveSponsor"
    ];

    for (var i = 0; i < autoCompleteControls.length; i++) {
        var currentControl = autoCompleteControls[i];
        if (selectedEngagement[currentControl] != null
            && selectedEngagement[currentControl].id == 0) {
            // This has no impact on saving because these fields have NOT NULL in DB, with DEFAULT 0 constraint
            selectedEngagement[currentControl] = null;
        }
    }
    return selectedEngagement;
}