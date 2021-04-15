//=======Kendo Fields=======//

//=================Global Filter=====================//
$("#divisionFilter").kendoDropDownList({
    dataTextField: "name",
    dataValueField: "id",
    dataSource: divisionDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//==================================================//

//=================Details Section==================//
//division field//
$("#division").kendoDropDownList({
    dataTextField: "name",
    dataValueField: "divisionId",
    dataSource: divisionDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});

//team field//
$("#team").kendoDropDownList({
    cascadeFrom: "division",
    dataTextField: "team",
    dataValueField: "id",
    dataSource: teamDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});

//principalRequired field//
$("#principalRequired").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "leaderFk",
    dataSource: principalRequiredDataSource,
    placeholder: "Type a name...",
    change: function (e) {
        var currentValue = this.value(); // an array containing the selected principal ids

        // If there's no selected value, manually create a required alert message
        // This is necessary for Required fields of type autocomplete and multiselect
        if (typeof currentValue == "undefined" || currentValue.length == 0) {
           $("#principalRequiredRequiredAlert").html(LEAD.Method.HtmlRequiredString("Required Principal", "A Required Principal(s)"));
        }
    }
});
//principalAlternate field//
$("#principalAlternate").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "leaderFk",
    dataSource: principalAlternateDataSource,
    placeholder: "Type a name..."
});
//strategicPriority field//

//teamRanking field//
$("#teamRanking").kendoDropDownList({
    dataTextField: "ranking",
    dataValueField: "id",
    dataSource: teamRankingDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//executiveSponsor field//n
$("#executiveSponsor").kendoAutoComplete({
    dataTextField: "name",
    dataSource: leadersDataSource,
    filter: "contains",
    placeholder: "Type a name...",
    change: function (e) {
        nullifyAutoCompleteWhenInvalid(this, "executiveSponsor", "leaderFk");
    }
});
//engagementType field//
$("#engagementType").kendoDropDownList({
    dataTextField: "text",
    dataValueField: "value",
    dataSource: engagementTypeDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//country field//
var country = $("#country").kendoMultiSelect({
    dataTextField: "countryName",
    dataValueField: "countryFk",
    dataSource: countryDataSource,
    placeholder: "Select a value...",
}).data("kendoMultiSelect");
//region field//
$("#region").kendoDropDownList({
    dataTextField: "regionName",
    dataValueField: "regionId",
    dataSource: regionDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
    change: regionChange,
}).data("kendoDropDownList");
//purpose field//
$("#purpose").kendoDropDownList({
    dataTextField: "purpose",
    dataValueField: "id",
    dataSource: purposeDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//contentOwner field//
$("#contentOwner").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "sysUserFk",
    dataSource: contentOwnerDataSource,
    placeholder: "Type a name..."
});

//staff field//
$("#staff").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "sysUserFk",
    dataSource: staffDataSource,
    placeholder: "Type a name..."
});
//duration field//
$("#duration").kendoDropDownList({
    dataTextField: "duration",
    dataValueField: "id",
    dataSource: durationDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//isDateFlexible field//
$("#dateFlexible").kendoDropDownList({
    dataTextField: "text",
    dataValueField: "value",
    dataSource: dateFlexibleDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//yearQuarter field//
$("#yearQuarter").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "yearQuarterFk",
    dataSource: yrQtrDataSource,
    placeholder: "Select a value...",
    change: function (e) {
        var currentValue = this.value(); // an array containing the selected YearQuarter ids

        // If there's no selected value, manually create a required alert message
        // This is necessary for Required fields of type autocomplete and multiselect
        if (typeof currentValue == "undefined" || currentValue.length == 0) {
            $("#yearQuarterRequiredAlert").html(LEAD.Method.HtmlRequiredString("Yr/Qtr", "A Yr/Qtr"));
        }
    }
});
//==================================================//

//=================Review Section===================//
//president ranking field//
$("#presidentRanking").kendoDropDownList({
    dataTextField: "ranking",
    dataValueField: "id",
    dataSource: rankingDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//==================================================//

//=================Scheduling Section===============//
//tripDirector
$("#tripDirector").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "sysUserFk",
    dataSource: tripDirectorDataSource,
    placeholder: "Type a name..."
});
//speechWriter
$("#speechWriter").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "sysUserFk",
    dataSource: speechWriterDataSource,
    placeholder: "Type a name..."
});
//communicationsLead
$("#communicationsLead").kendoMultiSelect({
    dataTextField: "name",
    dataValueField: "sysUserFk",
    dataSource: communicationsLeadDataSource,
    placeholder: "Type a name..."
});

//==================================================//

//=================Status Section===================//
//status field//
var engagementStatus = $("#engagementStatus").kendoDropDownList({
    change: function(e) {
        if (this.value() == LEAD.Constants.EngagementStatus.Draft ||
            this.value() == LEAD.Constants.EngagementStatus.SubmittedForReview) {
            $("#presidentRanking").attr('required', false);
        }
        else {
            $("#presidentRanking").attr('required', true);
        }
        
        if (this.value() == LEAD.Constants.EngagementStatus.Scheduled ||
            this.value() == LEAD.Constants.EngagementStatus.Completed ||
            this.value() == LEAD.Constants.EngagementStatus.Opportunistic) {
            $("#scheduleDateFrom").attr('required', true);
            $("#scheduleDateTo").attr('required', true);
        }
        else {
            $("#scheduleDateFrom").attr('required', false);
            $("#scheduleDateTo").attr('required', false);
        }
    },
    dataTextField: "name",
    dataValueField: "id",
    dataSource: statusDataSource,
    optionLabel: "Select a value...",
    optionLabelTemplate: optnLblTempt,
});
//=================================================//

//optionLabelTemplate of kendo dropdownlist, US#131964 : Add watermark texts when field is blank
function optnLblTempt() {
    return '<span style="color:#808080;">Select a value...</span>'
}

function regionChange() {
    var r = this._old;
    if (r == "" || r == undefined || r == null) {
        country.enable(false);
        country.value(null);
        return;
    }
    country.enable(true);
    // Filter Country options based on selected Region
    countryDataSource.filter(
      { field: "regionId", operator: "eq", value: parseInt(r) }
    );
}

// Set the autocomplete (input) control to NULL when there's no selected data 
// or user tries to type string
// This is called onchange of autocomplete
function nullifyAutoCompleteWhenInvalid(self, elementId, dataId) {
    var selectedData = self.dataItem(); // Selected object

    // dataItem is undefined if the autocomplete control has no selected data
    if (typeof selectedData == "undefined" || selectedData[dataId] == 0) {
        $("#" + elementId).val(null);
    }
}