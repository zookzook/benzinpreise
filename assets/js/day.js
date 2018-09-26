import * as d3 from "d3";

function init() {

    let locale= {
        "decimal": ",",
        "thousands": ".",
        "grouping": [3],
        "currency": ["", "\u00a0€"]
    };

    let formatter= d3.formatLocale(locale);

    Date.prototype.addHours = function(h) {

        let result= new Date(this.getTime());
        result.setTime(result.getTime() + (h*60*60*1000));
        return result;
    };

    let svg = d3.select("svg"),
            margin = {top: 20, right: 80, bottom: 30, left: 50},
            width = svg.attr("width") - margin.left - margin.right,
            height = svg.attr("height") - margin.top - margin.bottom,
            g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    let parseTime = d3.utcParse("%Y-%m-%dT%H:%M:%S.%fZ");

    let x= d3.scaleTime().range([0, width]),
        y= d3.scaleLinear().range([height, 0]);

    let line = d3.line()
            .x(function(d) { return x(d.t); })
            .y(function(d) { return y(d.e10); });

    d3.json('/api/day', {
        method:"POST",
        body: JSON.stringify({
            from: '2018-08-01',
            stid: '2330ac9d-9376-4fd9-90aa-e5f9934bcf3d'
        }),
        headers: {
            "content-type": "application/json; charset=UTF-8"
        }
    }).then( function(data) {
        data = data.map(function (record) {
            record.t = parseTime(record.date);
            record.e10= record.e10 / 1000;
            return record;
        });

        let xDomain= d3.extent(data, function(d) { return d.t; });
        xDomain[ 0 ]= xDomain[ 0 ].addHours( -1 );
        xDomain[ 1 ]= xDomain[ 1 ].addHours( +1 );
        x.domain(xDomain);

        let yDomain= d3.extent(data, function(d) { return d.e10; });

        yDomain[0]= yDomain[0] - 0.1;
        yDomain[1]= yDomain[1] + 0.1;
        y.domain( yDomain );

        g.append("g")
                .attr("transform", "translate(0," + height + ")")
                .call(d3.axisBottom(x).ticks(d3.timeHour.every(1)).tickFormat(function(d) { return d3.timeFormat('%H:%M')(d); }))
                .attr("fill", "none");


        g.append("g")
                .call(d3.axisLeft(y).tickFormat( formatter.format("($.3f") ) )
                .append("text")
                .attr("fill", "#000")
                .attr("x", 8)
                .attr("dy", "5")
                .attr("text-anchor", "start")
                .text("Preis");

        g.append("path")
                .datum(data)
                .attr("fill", "none")
                .attr("stroke", "steelblue")
                .attr("stroke-linejoin", "round")
                .attr("stroke-linecap", "round")
                .attr("stroke-width", 0.5)
                .attr("d", line);

        g.selectAll("price-dot")
                .data(data)
                .enter().append("circle")
                .attr("class", "price-dot")
                .attr("r", 3)
                .attr("cx", function(d) { return x(d.t); })
                .attr("cy", function(d) { return y(d.e10); });

    } );
}

export function hello() {
    init();
}

