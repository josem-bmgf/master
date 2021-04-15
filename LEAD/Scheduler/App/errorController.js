var errorLogColumns = [
        { width: 20, field: "RunDate", title: "Logged on", format: "{0:MM/dd/yyyy HH:mm:ss}" },
        { width: 20, field: "User", title: "Logged User" },
        { width: 100, field: "Details", title: "Error Details" }
];
$("#errorListGrid").kendoGrid({
    toolbar: ["excel"],
    scrollable: {
        virtual: false
    },
    excel: {
        fileName: "leadErrorList.xlsx",
        allPages: true
    },
    dataSource: errorListDataSource,
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
    columns: errorLogColumns
});

