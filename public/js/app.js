$(function () {
    var options = {
        lines: { show: true },
        points: { show: true },
        xaxis: { tickDecimals: 0, tickSize: 1 }
    };
    var first_region = [];
    var second_region = [];
    var placeholder = $("#placeholder");
    
    $.plot(placeholder, [], options);
    
    $("#region").change(function () {
        function onDataReceived(series) {
            first_region = series;
            var data = [first_region, second_region];
            $.plot(placeholder, data, options);
        }
        
        var dataurl = "/ca/"+$("#region").val();
        $.ajax({
            url: dataurl,
            method: 'GET',
            dataType: 'json',
            success: onDataReceived
        });
    });
});
