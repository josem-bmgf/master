var LEAD = {
    Constants: {
        DateTimeFormat: "MM/dd/yyyy h:mm tt",
        DefaultDateTime: "0001-01-01T00:00:00",
        EngagementStatus: {
            Draft: 1000,
            SubmittedForReview: 1001,
            Declined: 1003,
            Approved: 1004,
            Scheduled: 1006,
            Completed: 1007,
            Opportunistic: 1008,
        },
        EngagementGridSettings: {
            Engagement: {
                ElementId: "engagementGrid",
                TabName: "EngagementTab",
                SortBy: [{ field: "Status", dir: "asc" }, { field: "Status.display", dir: "asc" }, { field: "DateStart", dir: "asc" }]
            },
            Review: {
                ElementId: "reviewEngagementGrid",
                TabName: "ReviewTab",
                SortBy: [{ field: "Status", dir: "asc" }, { field: "Status.display", dir: "asc" }, { field: "DateStart", dir: "asc" }]
            },
            Scheduling: {
                ElementId: "schedulingEngagementGrid",
                TabName: "ScheduleTab",
                SortBy: [{ field: "Status", dir: "asc" }, { field: "Status.display", dir: "asc" }, { field: "DateFromSort", dir: "asc" }]
            }

        },
        KeyCode: {
            Enter: 13
        },
        PageSizeOfGrid: 15,
        ReportGridSettings: {
            Report: {
                ElementId: "reportGrid",
                SortBy: [{ field: "StatusDisplaySortSequence", dir: "asc" }, { field: "ScheduleFromDate", dir: "asc" }]
            },
        },
        SysUserType: {
            // Ids are based on dbo.SysUserType table
            CommunicationsLead: 1003,
            ContentOwner: 1001,
            SpeechWriter: 1004,
            Staff: 1000,
            TripDirector: 1002,
        },

    },
    Method: {
        // Returns a string containing the required message used in validation
        // Parameter: 
        // [1] dataFor - the validation control this error message is against to
        // [2] subject - the subject of the error message
        HtmlRequiredString: function (dataFor, subject) {
            return '<span class="k-widget k-tooltip k-tooltip-validation k-invalid-msg" data-for="'
                + dataFor + '" role="alert"><span class="k-icon k-warning"> </span> ' + subject + ' must be selected.</span>';
        },
        // Filter the Kendogrid by Title, Objectives, and Details column
        // Parameter: 
        // [1] searchString - string to search
        // [2] gridSettings - identify if its for EngagementGridSettings or ReportGridSettings
        SearchGrid: function (searchString, gridSettings) {

            for (var key in gridSettings) {

                var currentGrid = gridSettings[key];
                var grid = $("#" + currentGrid.ElementId).data("kendoGrid");

                grid.dataSource.query({
                    page: 1,
                    pageSize: LEAD.Constants.PageSizeOfGrid,
                    filter: {
                        logic: "or",
                        filters: [
                          { field: "Title", operator: "contains", value: searchString },
                          { field: "Objectives", operator: "contains", value: searchString },
                          { field: "Details", operator: "contains", value: searchString }
                        ]
                    }
                });
                grid.dataSource.sort(currentGrid.SortBy);
            }
        },
        // Trigger search when Enter is clicked
        // Parameter: 
        // [1] e - event
        TriggerSearchOnEnter: function (e) {
            if (e.keyCode == LEAD.Constants.KeyCode.Enter) {
                $("#search").click();
            }
        },
        // Resets Kendo Grid scrollbar positions to topmost and leftmost
        // Parameter: 
        // [1] e - event
        ResetKendoGridScrollBarPosition: function (e) {
            var container = e.sender.wrapper.children(".k-grid-content");
            container.scrollLeft(0);
            container.scrollTop(0);
        }
    }
}