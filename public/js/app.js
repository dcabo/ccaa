$(function () {
    // FIXME: ay ay ay
    var series_ids = 
        ['11', '12', '13', '14', '21', '22', '23', '24', '25', '26', '29', 
        '31', '32', '33', '41', '42', '43', '44', '45', '46', '49', '91',
        '92', '93', '94', '95'];
    
    var graphs = {};
    $.each(series_ids, function(i, series) { 
        var new_graph = $("<div id='graph-"+series+"' class='span-4' style='width:250px;height:200px;'</div>");
        $("#graphs").append(new_graph);
        graphs[series] = new_graph;
    });
    
    var options = {
        bars: { show: true, barWidth: 0.8 },
        xaxis: { tickDecimals: 0, tickSize: 1, labelWidth: 40, reserveSpace: true },
        legend: { show: false },
        grid: { markings: [] }
    };
    var first_region = [];
    var second_region = [];
    
    $.each(graphs, function(i, graph) {
        $.plot(graph, [], options);
    })
    
    $("#region").change(function () {
        function onDataReceived(data) {
            first_region = data;
            $.each(series_ids, function(i, series) { 
                var series_data = first_region.per_policy_data[series];
                if ( series_data == null ) {
                    series_data = [];
                }
                $.plot(graphs[series], [series_data, second_region], options);
            });
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
