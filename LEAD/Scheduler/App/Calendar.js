$("#scheduler").kendoScheduler({
    height: 1500,
    editable: {
        //set the template
        template: kendo.template($('#CustomEditorTemplate').html())
    },
    views: [
            //"day",
            //"workWeek",
            //"week",
            { type: "month", selected: true }
           // "agenda",
           // { type: "timeline", eventHeight: 50 }
    ],
    timezone: "Etc/UTC",
    dataSource: {

        data: [{ "Id": 1000, "Title": "Blackout Dates", "PrincipalRequired": "", "Details": "Blackout Dates", "Region": "", "Country": "", "City": "", "Duration": "", "DateStart": "7/19/2016", "DateEnd": "7/19/2016" },
               { "Id": 1000038, "Title": "Testing this awesome tool", "PrincipalRequired": "", "Details": "Hello\t", "Region": "Eastern Europe", "Country": "Poland", "City": "warsaw", "Duration": "1/2 day", "DateStart": "7/15/2016", "DateEnd": "7/31/2016" },
               { "Id": 1000039, "Title": "Test", "PrincipalRequired": "Allan", "Details": "Test", "Region": "Africa, South Of Sahara", "Country": "Benin", "City": "sss", "Duration": "1/2 day", "DateStart": "1/1/2000", "DateEnd": "12/31/2999" },
               { "Id": 1000040, "Title": "test", "PrincipalRequired": "Bill, Bill Sr.", "Details": "tx`est", "Region": "Micronesia", "Country": "Micronesia, Federated States of", "City": "main street", "Duration": "2 days", "DateStart": "1/1/2000", "DateEnd": "12/31/2999" },
               { "Id": 1000041, "Title": "Testing this awesome tool", "PrincipalRequired": "", "Details": "Hello\t", "Region": "Eastern Europe", "Country": "Poland", "City": "warsaw", "Duration": "1/2 day", "DateStart": "1/1/2000", "DateEnd": "12/31/2999" },
               { "Id": 1000042, "Title": "Advocacy/Outreach Calls: FP Fund", "PrincipalRequired": "Melinda", "Details": "", "Region": "", "Country": "", "City": "", "Duration": "30 minutes", "DateStart": "1/1/2000", "DateEnd": "12/31/2999" }
        //dates that are set for July 2016
        //data: [{"Id":1000,"Title":"Blackout Dates","PrincipalRequired":"","Details":"Blackout Dates","Region":"","Country":"","City":"","Duration":"","DateStart":"07/01/2016","DateEnd":"07/15/2016"},
        //        { "Id": 1000038, "Title": "Testing this awesome tool", "PrincipalRequired": "", "Details": "Hello\t", "Region": "Eastern Europe", "Country": "Poland", "City": "warsaw", "Duration": "1/2 day", "DateStart": "07/15/2016", "DateEnd": "07/15/2016" },
        //        { "Id": 1000039, "Title": "Test", "PrincipalRequired": "Allan", "Details": "Test", "Region": "Africa, South Of Sahara", "Country": "Benin", "City": "sss", "Duration": "1/2 day", "DateStart": "07/15/2016", "DateEnd": "07/15/2016" },
        //        { "Id": 1000040, "Title": "test", "PrincipalRequired": "Bill, Bill Sr.", "Details": "test", "Region": "Micronesia", "Country": "Micronesia, Federated States of", "City": "main street", "Duration": "2 days", "DateStart": "07/15/2016", "DateEnd": "07/15/2016" },
        //        { "Id": 1000041, "Title": "Testing this awesome tool", "PrincipalRequired": "", "Details": "Hello\t", "Region": "Eastern Europe", "Country": "Poland", "City": "warsaw", "Duration": "1/2 day", "DateStart": "07/15/2016", "DateEnd": "07/15/2016" },
        //        { "Id": 1000042, "Title": "Advocacy/Outreach Calls: FP Fund", "PrincipalRequired": "Melinda", "Details": "", "Region": "", "Country": "", "City": "", "Duration": "30 minutes", "DateStart": "07/15/2016", "DateEnd": "07/15/2016" }
        ],
        batch: true,
        schema: {
            model: {
                id: "Id",
                fields: {
                    Id: { from: "Id", type: "number" },
                    title: { from: "Title" },
                    principal: { from: "PrincipalRequired" },
                    start: { type: "date", from: "DateStart" },
                    end: { type: "date", from: "DateEnd" },
                    duration: { from: "Duration" },
                    region: { from: "Region" },
                    country: { from: "Country" },
                    city: { from: "City" },
                    details: { from: "Details" },

                }
            }
        }
    },
    resources: [
        {
            field: "Id",
            title: "Id",
            dataSource: [
                { text: "1000", value: 1000, color: "yellow" },
                { text: "1000038", value: 1000038, color: "blue" },
                { text: "1000039", value: 1000039, color: "red" },
                { text: "1000040", value: 1000040, color: "green" },
                { text: "1000041", value: 1000041, color: "orange" },
                { text: "1000042", value: 1000042, color: "teal" },
            ]
        }
    ]
});