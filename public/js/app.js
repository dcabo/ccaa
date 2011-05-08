$(function () {
    var options = {
        lines: { show: true },
        points: { show: true },
        xaxis: { tickDecimals: 0, tickSize: 1 }
    };
    var data = [];
    var placeholder = $("#placeholder");
    
    $.plot(placeholder, data, options);
    
    $("#fetch_button").click(function () {
        function onDataReceived(series) {
            data.push(series);
            $.plot(placeholder, data, options);
        }
        
        var dataurl = "/data.json";
        $.ajax({
            url: dataurl,
            method: 'GET',
            dataType: 'json',
            success: onDataReceived
        });
    });
});
