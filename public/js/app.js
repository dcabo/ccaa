$(function () {
    // Hidden at start
    $("#graphs").hide();    
    $("#region2-div").hide();
    
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
    var first_region = {};
    var second_region = {};
    
    function fetchData(region, callback) {
        var dataurl = "/ca/"+region;
        $.ajax({
            url: dataurl,
            method: 'GET',
            dataType: 'json',
            success: callback
        });
    }
    
    function displayGraphs() {
        $.each(policies, function(i, policy) { 
            var first = [];
            if (first_region.per_policy_data != null && first_region.per_policy_data[policy.id] != null)
                first = first_region.per_policy_data[policy.id];
            
            var second = [];
            if (second_region.per_policy_data != null && second_region.per_policy_data[policy.id] != null)
                second = second_region.per_policy_data[policy.id];
                
            $.plot(graphs[policy.id], [first, second], options);
        });
        $("#graphs").show();    // Hidden at start
    }
    
    $("#region").change(function () {
        function onDataReceived(data) {
            first_region = data;
            displayGraphs();
        }
        fetchData($("#region").val(), onDataReceived);
        $("#region2-div").show();    // Hidden at start
    });

    $("#region2").change(function () {
        function onDataReceived(data) {
            second_region = data;
            displayGraphs();
        }
        fetchData($("#region2").val(), onDataReceived);
    });
});
