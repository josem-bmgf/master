$("#search").click(function () {
    var searchString = $("#searchString").val();
    LEAD.Method.SearchGrid(searchString, LEAD.Constants.ReportGridSettings);
});


$("#searchString").on('keyup', function (e) {
    // Trigger search when Enter is clicked
    LEAD.Method.TriggerSearchOnEnter(e);
});
var exportFlag = false;
var reportGridCurrentPage = 1;
$("#reportGrid").kendoGrid({
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
            e.sender.columns[8].hidden = false
            e.sender.columns[10].hidden = false
            e.preventDefault();
            exportFlag = true;
            setTimeout(function () {
                e.sender.saveAsExcel();
            });
        } else {
            e.sender.columns[8].hidden = true
            e.sender.columns[10].hidden = true
            exportFlag = false;
        }

        var sheet = e.workbook.sheets[0];

        for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
            var row = sheet.rows[rowIndex];
            for (var cellIndex = 0; cellIndex < row.cells.length; cellIndex++) {
                row.cells[cellIndex].format = "MM/dd/yyyy"
            }
        }
    },
    dataSource: {
        type: "jsonp",
        transport: {
            read: "/api/Report/GetvEngagementLeaderSchedules"
        },
        schema: {
            parse: function (data) {
                var scheduleFields = [];
                for (var i = 0; i < data.length; i++) {
                    var scheduleField = data[i];
                    var f = new Date(scheduleField.ScheduleFromDate);
                    var t = new Date(scheduleField.ScheduleToDate);
                    var dateFrom = addZero(f.getHours()) + ":" + addZero(f.getMinutes()) + ":" + addZero(f.getSeconds());
                    var dateTo = addZero(t.getHours()) + ":" + addZero(t.getMinutes()) + ":" + addZero(t.getSeconds());
                    scheduleField.DateFromTime = scheduleField.ScheduleFromDate != null ? dateFrom : "";
                    scheduleField.DateToTime = scheduleField.ScheduleToDate != null ? dateTo : "";
                    scheduleField.DateFrom = kendo.toString(kendo.parseDate(scheduleField.ScheduleFromDate), 'MM/dd/yyyy');
                    scheduleField.DateTo = kendo.toString(kendo.parseDate(scheduleField.ScheduleToDate), 'MM/dd/yyyy');
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
                    ScheduleFromDate: { type: "date" },
                    ScheduleToDate: { type: "date" },
                    DateFrom: { type: "date" },
                    DateTo: { type: "date" },
                    DateFromTime: { type: "string" },
                    DateToTime: { type: "string" },
                    ScheduleBriefDueToGCEByDate: { type: "date" }
                }
            }
        },
        pageSize: LEAD.Constants.PageSizeOfGrid,
        sort: LEAD.Constants.ReportGridSettings.Report.SortBy
    },
    dataBinding: function (e) {
        var pageNow = $("#reportGrid").data("kendoGrid").dataSource.page();
        if (pageNow != reportGridCurrentPage) {
            reportGridCurrentPage = pageNow;
            LEAD.Method.ResetKendoGridScrollBarPosition(e);
        }
    },
    //editable: "popup",
    change: function (e) {
        selectedEngagement = e.sender.dataItem(e.sender.select());
        kendo.bind($("#window"), selectedEngagement);
        alert('['+ selectedEngagement.PrincipalRequired +']')
        myWindow.data("kendoWindow").center().open();
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
            e.field === "Team"
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
    columns: [
        { width: 150, field: "Division", title: "Division", filterable: { multi: true } },
        { width: 150, field: "Team", title: "Team", filterable: { multi: true } },
        { width: 150, field: "Title", title: "Title" },
        { width: 175, field: "PrincipalRequired", title: "Required Principal(s)" },
        { width: 175, field: "PrincipalAlternate", title: "Alternate Principal(s)" },  
        { width: 150, field: "Objectives", title: "Objectives", },
        { width: 150, field: "Details", title: "Details" },
        {
            width: 155, field: "DateFrom", title: "Scheduled Start",
            template: "#if (ScheduleFromDate !=null) {# #= kendo.toString(ScheduleFromDate, 'MM/dd/yyyy h:mm tt') # #} else{# #}#",
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
            width: 155, field: "DateFromTime", title: "Scheduled Start Time",
            hidden: true
        },
        {
            width: 155, field: "DateTo", title: "Scheduled End",
            template: "#if (ScheduleToDate !=null) {# #= kendo.toString(ScheduleToDate, 'MM/dd/yyyy h:mm tt') # #} else{# #}#",
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
            width: 155, field: "DateToTime", title: "Scheduled End Time",
            hidden: true
        },
        { width: 150, field: "Region", title: "Region", filterable: { multi: true } },
        { width: 150, field: "Country", title: "Country", filterable: { multi: true } },
        { width: 150, field: "City", title: "City"},
        { width: 150, field: "Location", title: "Location" },
        { width: 150, field: "Duration", title: "Duration", filterable: { multi: true } },
        { width: 150, field: "YearQuarter", title: "Yr/Qtr" },
        { width: 150, field: "Purpose", title: "Engagement Purpose", filterable: { multi: true } },
        { width: 150, field: "Status", title: "Status", filterable: { multi: true } },
        { width: 150, field: "TeamRanking", title: "Team Ranking", filterable: { multi: true } },
        { width: 175, field: "PresidentRanking", title: "President Ranking", filterable: { multi: true } },
        { width: 150, field: "PresidentComment", title: "President Review Comment" },
        { width: 150, field: "TripDirector", title: "Trip Director", filterable: { multi: true } },
        { width: 150, field: "CommunicationsLead", title: "Communications Lead", filterable: { multi: true } },
        { width: 150, field: "BriefOwner", title: "Content Owner", filterable: { multi: true } },        
        {
            width: 150, field: "ScheduleBriefDueToGCEByDate", title: "Brief due to SP&E", format: "{0:MM/dd/yyyy}",

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
        { width: 150, field: "Staff", title: "Staff", filterable: { multi: true } },
        { width: 150, field: "StrategicPriority", title: "Strategic Priority",  hidden: true, filterable: { multi: true } },
        { width: 150, field: "EngagementType", title: "Engagement Type", filterable: { multi: true } },
    ]
});

function addZero(time) {
    if (time < 10) {
        time = "0" + time;
    }
    return time;
}
