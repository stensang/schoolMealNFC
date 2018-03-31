$(document).ready(function() {

    // Söögikordade ja õpilaste registreerimiste andmete sorteerimine
    $('.data-table').DataTable();

    // Õpilaste registreerimiste ja õpilase registreerimiste andmete pärimine veebiteenuselt kuupäeva järgi
    $('.input-daterange').datepicker({
        maxViewMode: 2,
        todayBtn: "linked",
        language: "et",
        daysOfWeekHighlighted: "0,6",
        autoclose: true,
    });

} );
