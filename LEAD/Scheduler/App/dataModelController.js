var Division = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "name": {
            type: "string"
        },
    }
});

var Team = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "team": {
            type: "string"
        },
    }
});

var Country = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "countryName": {
            type: "string"
        },
        "regionFk": {
            type: "number"
        },
    }
});
var Duration = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "duration": {
            type: "string"
        },
    }
});
var Leader = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "leaderFk": {
            type: "number"
        },
        "typeFk": {
            type: "number"
        },
        "name": {
            type: "string"
        },
        "engagementFk": {
            type: "number"
        },
    }
});
var SysUser = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "name": {
            type: "string"
        },
    }
});
var Status = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "name": {
            type: "string"
        },
    }
});
var PresidentRanking = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "ranking": {
            type: "string"
        },
    }
});
var Schedule = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "EngagementFk": {
            type: "number"
        },
        "TripDirector": {
            type: "string"
        },
        "SpeechWriter": {
            type: "string"
        },
        "CommunicationsLead": {
            type: "string"
        },
        "BriefDueToGCEByDate": {
            type: "date"
        },
        "DateFrom": {
            type: "date"
        },
        "DateTo": {
            type: "date"
        },
        "ScheduleComment": {
            type: "string"
        }
    }
});
var Engagement = kendo.data.Model.define({
    id: "id", // the identifier of the model
    fields: {
        "ContentOwner": {
            type: "object"
        },
        "Staff": {
            type: "object"
        },
        "Details": {
            type: "string"
        },
        "PrincipalAlternate": {
            type: "object"
        },
        "Country": {
            type: "object",
        },
        "City": {
            type: "string"
        },
        "Location": {
            type: "string"
        },
        "Duration": {
            type: "object"
        },
        "PresidentComment": {
            type: "string"
        },
        "Status": {
            type: "object",
        },
        "PresidentRanking": {
            type: "object",
        }
    }
});