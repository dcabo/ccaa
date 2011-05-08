$(function () {
    // Hidden at start
    $("#graphs").hide();    
    $("#region2-div").hide();
    
    // Tooltip, taken from Flot example
    function showTooltip(x, y, contents) {
        $('<div id="tooltip">' + contents + '</div>').css( {
            position: 'absolute',
            display: 'none',
            top: y + 5,
            left: x + 5,
            border: '1px solid #fdd',
            padding: '2px',
            'background-color': '#fee',
            opacity: 0.80
        }).appendTo("body").fadeIn(200);
    };
    var previousPoint = null;
    function onHover(event, pos, item) {
        if (item) {
            if (previousPoint != item.dataIndex) {
                previousPoint = item.dataIndex;
                
                $("#tooltip").remove();
                var x = item.datapoint[0].toFixed(2),
                    y = item.datapoint[1].toFixed(2);
                
                showTooltip(item.pageX, item.pageY,
                            item.series.label + " : " + y);
            }
        }
        else {
            $("#tooltip").remove();
            previousPoint = null;            
        }
    };
    
    // Generate all Flot graphs
    var graphs = {};
    $.each(policies, function(i, policy) { 
        var new_graph = $("<div id='graph-"+policy.id+"' style='width:250px;height:190px;'</div>");
        new_graph.bind("plothover", onHover);
        graphs[policy.id] = new_graph;

        var new_div = $("<div class='span-6'><p style='text-align:center; font-weight:bold; font-variant: small-caps;'>"+policy.name+"</p></div>");
        new_div.prepend(new_graph);
        $("#graphs").append(new_div);
        
        // Quick hack to make sure the grid of graphs is laid out correctly
        if (((i+1) % 3) == 0)
            $("#graphs").append("<div class='clear'></div>");
    });
    
    // Auxiliary Flot stuff
    var options = {
        xaxis: { tickDecimals: 0, tickSize: 1, labelWidth: 60, reserveSpace: true },
        legend: { show: false, container: '#graph_legend' },
        grid: { hoverable: true }
    };
    var first_region = {};
    var second_region = {};
    
    // Retrieve data from server
    function fetchData(region, callback) {
        var dataurl = "/ca/"+region;
        $.ajax({
            url: dataurl,
            method: 'GET',
            dataType: 'json',
            success: callback
        });
    }
    
    // Calculate data if needed
    function processData(data, policy_id) {
        switch ($("#comparison_mode").val()) {
            case 'total':
                return data[policy_id];
                
            case 'per_capita':
            default:
                return data[policy_id];
        }
    }
    
    // Redraw all graphs
    function displayGraphs() {
        $.each(policies, function(i, policy) { 
            var ds = new Array();
            if (first_region.per_policy_data != null && first_region.per_policy_data[policy.id] != null)
                ds.push({
                    data: processData(first_region.per_policy_data, policy.id), 
                    label: first_region.label,
                    bars: { show: true, barWidth: 0.35, order: 1 }
                });
            if (second_region.per_policy_data != null && second_region.per_policy_data[policy.id] != null)
                ds.push({
                    data: processData(second_region.per_policy_data, policy.id), 
                    label: second_region.label,
                    bars: { show: true, barWidth: 0.35, order: 2 }
                });
            
            $.plot(graphs[policy.id], ds, options);
        });
        $("#graphs").show();    // Hidden at start
    }
    
    // Event handling
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

    $("#region").change(function () {
        displayGraphs();    // Redraw
    });
});
