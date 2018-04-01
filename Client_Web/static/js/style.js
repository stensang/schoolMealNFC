$(document).ready(function() {

    // Söögikordade ja õpilaste registreerimiste andmete sorteerimine
    $('.opilaste-registreerimised').DataTable({
        "order": [[ 3, "asc" ]]
    });

    //
    $('.opilase-registreerimised').DataTable({
        "order": [[ 1, "desc" ]]
    });

    //
    $('.soogikorrad').DataTable({
        "order": [[ 0, "desc" ]]
    });

    // Õpilaste registreerimiste ja õpilase registreerimiste andmete pärimine veebiteenuselt kuupäeva järgi
    $('.input-daterange').datepicker({
        maxViewMode: 2,
        todayBtn: "linked",
        language: "et",
        daysOfWeekHighlighted: "0,6",
        autoclose: true,
    });

} );
