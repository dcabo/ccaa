$(function () {
    $("#graphs").hide();    // Hidden at start
    
    var graphs = {};
    $.each(policies, function(i, policy) { 
        var new_graph = $("<div id='graph-"+policy.id+"' style='width:250px;height:200px;'</div>");
        graphs[policy.id] = new_graph;

        var new_div = $("<div class='span-6'><p style='text-align:center; font-weight:bold; font-variant: small-caps;'>"+policy.name+"</p></div>");
        new_div.prepend(new_graph);
        $("#graphs").append(new_div);
        
        // Quick hack to make sure the grid of graphs is laid out correctly
        if (((i+1) % 3) == 0)
            $("#graphs").append("<div class='clear'></div>");
    });
    
    var options = {
        bars: { show: true, barWidth: 0.8 },
        xaxis: { tickDecimals: 0, tickSize: 1, labelWidth: 40, reserveSpace: true },
        legend: { show: false },
        grid: { markings: [] }
    };
    var first_region = [];
    var second_region = [];
    
    $("#region").change(function () {
        function onDataReceived(data) {
            first_region = data;
            $.each(policies, function(i, policy) { 
                var series_data = first_region.per_policy_data[policy.id];
                if ( series_data == null ) {
                    series_data = [];
                }
                $.plot(graphs[policy.id], [series_data, second_region], options);
            });
        }
        
        $("#graphs").show();    // Hidden at start
        
        var dataurl = "/ca/"+$("#region").val();
        $.ajax({
            url: dataurl,
            method: 'GET',
            dataType: 'json',
            success: onDataReceived
        });
    });
});
